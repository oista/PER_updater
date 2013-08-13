unit UPDATERUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DMUnit, Vcl.StdCtrls, uADStanIntf,
  uADStanOption, uADStanParam, uADStanError, uADDatSManager, uADPhysIntf,
  uADDAptIntf, uADStanAsync, uADDAptManager, Data.DB, uADCompDataSet,
  uADCompClient, IBCustomDataSet, IBQuery, Data.Win.ADODB;

type
  TUPDATER = class(TForm)
    gb_docholidays: TGroupBox;
    qry_ORADOCUMENT: TADQuery;
    gb_citezens: TGroupBox;
    qry_SKD_CITEZEN: TADOQuery;
    qry_ORA_CITEZEN: TADQuery;
    cmd_SKD_INSCITEZEN: TADOCommand;
    qry_SKD_CITEZENLAST_NAME: TWideStringField;
    qry_SKD_CITEZENFIRST_NAME: TWideStringField;
    qry_SKD_CITEZENMIDDLE_NAME: TWideStringField;
    qry_SKD_CITEZENID_STAFF: TIntegerField;
    qry_SKD_CITEZENDISPLAY_NAME: TWideStringField;
    qry_ORA_CITEZENCITEZENID: TFMTBCDField;
    lbl1: TLabel;
    cmd_SKD_INSDOCUMENT: TADOCommand;
    qry_ORADOCUMENTINDATE: TDateTimeField;
    qry_ORADOCUMENTOUTDATE: TDateTimeField;
    qry_ORADOCUMENTCITEZENID: TFMTBCDField;
    qry_ORADOCUMENTSTUFFID: TFMTBCDField;
    qry_ORADOCUMENTSKUDINSERT: TFMTBCDField;
    qry_ORADOCUMENTINSDATE: TStringField;
    qry_ORADOCUMENTHOLIDAYTYPEID: TFMTBCDField;
    cmd_ORA_UPDDOC: TADCommand;
    qry_ORADOCUMENTDOCID: TFMTBCDField;
    QRY_STAFF: TADOQuery;
    PRC_INSERT_STUFF: TADStoredProc;
    QRY_STAFFID_STAFF: TIntegerField;
    QRY_STAFFLAST_NAME: TWideStringField;
    QRY_STAFFFIRST_NAME: TWideStringField;
    QRY_STAFFMIDDLE_NAME: TWideStringField;
    QRY_STAFFDELETED: TIntegerField;
    QRY_STAFFDATE_BEGIN: TDateField;
    QRY_STAFFDATE_DISMISS: TDateField;
    QRY_STAFFDISPLAY_NAME: TWideStringField;
    cmd_SKD_INSCITEZEN2: TADOCommand;
    QRY_STAFFID_FROM_1C: TWideStringField;
    qry_ORAUPDDOC: TADQuery;
    qry_ORAUPDDOCUPDID: TFMTBCDField;
    qry_ORAUPDDOCEDITTYPE: TStringField;
    qry_ORAUPDDOCEDITDATE: TDateTimeField;
    qry_ORAUPDDOCINDATE: TDateTimeField;
    qry_ORAUPDDOCOUTDATE: TDateTimeField;
    qry_ORAUPDDOCCITEZENID: TFMTBCDField;
    qry_ORAUPDDOCHOLIDAYTYPEID: TFMTBCDField;
    qry_ORAUPDDOCDOCID: TFMTBCDField;
    qry_ORAUPDDOCSKUDINSERT: TFMTBCDField;
    cmd_SKD_DELDOC: TADOCommand;
    cmd_SKD_UPDDOC: TADOCommand;
    cmd_ORA_UPDEVENT: TADCommand;
    btn_citezen: TButton;
    btn_documents: TButton;
    PRC_ORA_UPD_CITEZEN: TADStoredProc;

    procedure Processing  (Sender: TObject);
    procedure SyncCitezen (Sender: TObject);
    procedure SyncDocument(Sender: TObject);


  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  UPDATER:   TUPDATER;
  logfile:   TextFile;
  errorfile: TextFile;

implementation

{$R *.dfm}


procedure TUPDATER.Processing(Sender: TObject);
begin
  updater.Visible := True;
  updater.Show;

  // открываем лог
  AssignFile(logfile,   'logfile.txt');
  AssignFile(errorfile, 'errorfile.txt');
  Append(logfile);
  Append(errorfile);
  WriteLn(logfile,   '+'+DateToStr(now)+'+');
  WriteLn(errorfile, '+'+DateToStr(now)+'+');
  WriteLn(logfile, '        - START PROCESSING');

  try
   DMUnit.DataModule1.ORA_CON.Open;
   DMUnit.DataModule1.ADO_CON.Open;

  finally
   if (DMUnit.DataModule1.ORA_CON.Connected) then
    WriteLn(logfile,  timetostr(now)+'- ORACLE connected')
   else
    WriteLn(logfile,  timetostr(now)+'- ORACLE NOT connected');

   if (DMUnit.DataModule1.ADO_CON.Connected) then
    WriteLn(logfile,  timetostr(now)+'- FIREBIRD connected')
   else
    WriteLn(logfile,  timetostr(now)+'- FIREBIRD NOT connected');
  end;

  // назначаем сотрудникам СКУД номера citezenid
  SyncCitezen(self);
  // копируем оправдвт. док-ты(ОТПУСКА)
  SyncDocument(self);

  WriteLn(logfile,   '- FINISH '+DateToStr(now)+' '+timetostr(now)+'+');
  WriteLn(logfile, '');
  WriteLn(logfile, '');
  CloseFile(logfile);
  CloseFile(errorfile);

  Updater.Close;
end;


procedure TUPDATER.SyncCitezen(Sender: TObject);
var
cno : integer;
begin
 // получаем всех сотрудников СКУД без citezenid
 qry_SKD_CITEZEN.Open;
 cno :=1;

 WriteLn(logfile, '');
 WriteLn(logfile, timetostr(now)+'- START SYNC CITEZENID:');

  // ЗАЛИВКА НОВЫХ СОТРУДНИКОВ ИЗ СКУД В ОРАКЛ ---------------------------------

  QRY_STAFF.Open;
  while not QRY_STAFF.eof do
   begin
    PRC_INSERT_STUFF.Params[0].Value:=  QRY_STAFFID_STAFF.AsInteger;
    PRC_INSERT_STUFF.Params[1].Value:=  QRY_STAFFDELETED.AsInteger;
    PRC_INSERT_STUFF.Params[2].Value:=  QRY_STAFFLAST_NAME.AsString;
    PRC_INSERT_STUFF.Params[3].Value:=  QRY_STAFFFIRST_NAME.AsString;
    PRC_INSERT_STUFF.Params[4].Value:=  QRY_STAFFMIDDLE_NAME.AsString;
    PRC_INSERT_STUFF.Params[5].Value:=  QRY_STAFFDATE_BEGIN.AsDateTime;
    PRC_INSERT_STUFF.Params[6].Value:=  QRY_STAFFDATE_DISMISS.AsDateTime;
    PRC_INSERT_STUFF.Params[7].Value:=  QRY_STAFFDISPLAY_NAME.AsString;
    PRC_INSERT_STUFF.Params[8].Value:=  0;//QRY_STAFFID_FROM_1C.AsInteger;
    PRC_INSERT_STUFF.ExecProc;
    QRY_STAFF.Next;
    end;

   QRY_STAFF.Close;

  // Связывание сотрудников с пустыми CITEZENID в ОРАКЛЕ ( табл TC_STAFF)
  PRC_ORA_UPD_CITEZEN.ExecProc;

 //-----------------------------------------------------------------------------

 //  Вносим citezenid новым сотрудникам в СКУДе
 {while not qry_SKD_CITEZEN.eof do
   begin
    // запрос  оракла
    qry_ORA_CITEZEN.Params[0].Value  := qry_SKD_CITEZENLAST_NAME.AsString;
    qry_ORA_CITEZEN.Params[1].Value  := qry_SKD_CITEZENFIRST_NAME.AsString;
    qry_ORA_CITEZEN.Params[2].Value  := qry_SKD_CITEZENMIDDLE_NAME.AsString;
    qry_ORA_CITEZEN.Params[3].Value  := qry_SKD_CITEZENDISPLAY_NAME.AsString;
    qry_ORA_CITEZEN.Open;

    // присваивание citezenid записи СКУД
    if (qry_ORA_CITEZENCITEZENID.AsString<>'') then
     begin
      WriteLn(logfile, IntToStr(cno)+' cid:'+qry_ORA_CITEZENCITEZENID.AsString+' '+qry_SKD_CITEZENLAST_NAME.AsString
              +' '+qry_SKD_CITEZENFIRST_NAME.AsString+' '+qry_SKD_CITEZENMIDDLE_NAME.AsString);

      // апдейтим видимое пользователю информационное поле (для работы из интерфейса)
      cmd_SKD_INSCITEZEN.Parameters[0].Value := qry_ORA_CITEZENCITEZENID.AsInteger;
      cmd_SKD_INSCITEZEN.Parameters[1].Value := qry_SKD_CITEZENID_STAFF.AsInteger;
      cmd_SKD_INSCITEZEN.Execute;
      ShowMessage('4');
      // апдейтим скрытое поле (зарезервированно для 1С)
      cmd_SKD_INSCITEZEN2.Parameters[0].Value := qry_ORA_CITEZENCITEZENID.AsInteger;
      cmd_SKD_INSCITEZEN2.Parameters[1].Value := qry_SKD_CITEZENID_STAFF.AsInteger;
      cmd_SKD_INSCITEZEN2.Execute;

      inc(cno);
     end;

    qry_ORA_CITEZEN.Close;
    qry_SKD_CITEZEN.Next;
    end;

  qry_SKD_CITEZEN.Close;   }


  WriteLn(logfile, '----------------------------');
end;

procedure TUPDATER.SyncDocument(Sender: TObject);
 var
 htype :Integer;
 cno : integer;
begin
  WriteLn(logfile, timetostr(now)+'- START SYNC DOCUMENTS:');
  qry_ORADOCUMENT.Open;
  cno:=1;


   while not qry_ORADOCUMENT.eof do
   begin
    if (qry_ORADOCUMENTSTUFFID.asstring<>'') then    // вносим док-ты только связанные с сотрудниками по STAFFID
     begin
      htype:=0;
      case  qry_ORADOCUMENTHOLIDAYTYPEID.AsInteger of
        6898188:  htype:= 6;           // Ежегодный дополнительный отпуск
        1860   :  htype:= 5;           // Ежегодный основной отпуск
      end;

      if (htype=0) then Exit; // доп проверка


      cmd_SKD_INSDOCUMENT.Parameters[0].Value := qry_ORADOCUMENTSTUFFID.AsInteger;
      cmd_SKD_INSDOCUMENT.Parameters[1].Value := 'bdhr';
      cmd_SKD_INSDOCUMENT.Parameters[2].Value := qry_ORADOCUMENTINSDATE.AsDateTime;
      cmd_SKD_INSDOCUMENT.Parameters[3].Value := qry_ORADOCUMENTINDATE.AsDateTime;
      cmd_SKD_INSDOCUMENT.Parameters[4].Value := qry_ORADOCUMENTOUTDATE.AsDateTime;
      cmd_SKD_INSDOCUMENT.Parameters[5].Value := htype;  // тип отпуска
      cmd_SKD_INSDOCUMENT.Parameters[6].Value := qry_ORADOCUMENTDOCID.AsInteger;
      cmd_SKD_INSDOCUMENT.Execute;

      // отметка о добавлении
      cmd_ORA_UPDDOC.Params[0].Value :=  qry_ORADOCUMENTDOCID.AsInteger;
      cmd_ORA_UPDDOC.Execute;

      WriteLn(logfile, IntToStr(cno)+' cid:'+qry_ORADOCUMENTCITEZENID.AsString+' c '+qry_ORADOCUMENTINSDATE.AsString
             +' по '+qry_ORADOCUMENTOUTDATE.AsString+'  htype-'+inttostr(htype) +'docid-'+qry_ORADOCUMENTDOCID.AsString);

      inc(cno);
     end
    else
     begin    // ОШИБКА: неизвестный идентификатор staffid
       WriteLn(errorfile,  timetostr(now)+'- SYNC DOCUMENT: not found staffid for citezenid = '+qry_ORADOCUMENTCITEZENID.asstring);
     end;

     qry_ORADOCUMENT.Next;
   end;

   qry_ORADOCUMENT.Close;

   // ОБРАБОТКА ИЗМЕНЕНИЙ В ВВЕДЕННЫХ ОТПУСКАХ  ------------------------------------
   WriteLn(logfile, '');
   WriteLn(logfile, '');
   WriteLn(logfile, timetostr(now)+'- START UPDATE DOCUMENTS:');

   cno:=0;

   qry_ORAUPDDOC.Open();
   while not qry_ORAUPDDOC.eof do
    begin

     if (qry_ORAUPDDOCEDITTYPE.AsString='DELETE') then
      begin
        cmd_SKD_DELDOC.Parameters[0].Value := qry_ORAUPDDOCDOCID.AsString;
        cmd_SKD_DELDOC.Execute;

        WriteLn(logfile, IntToStr(cno)+' DELETE_DOC_ID:'+qry_ORAUPDDOCDOCID.AsString+' '
        +qry_ORAUPDDOCINDATE.AsString+' / '+qry_ORAUPDDOCOUTDATE.AsString);
      end;

     if (qry_ORAUPDDOCEDITTYPE.AsString='UPDATE') then
      begin
        cmd_SKD_UPDDOC.Parameters[0].Value := qry_ORAUPDDOCINDATE.AsDateTime;
        cmd_SKD_UPDDOC.Parameters[1].Value := qry_ORAUPDDOCOUTDATE.AsDateTime;
        cmd_SKD_UPDDOC.Parameters[2].Value := qry_ORAUPDDOCDOCID.AsString;
        cmd_SKD_UPDDOC.Execute;

        WriteLn(logfile, IntToStr(cno)+' UPDATE_DOC_ID:'+qry_ORAUPDDOCDOCID.AsString+' '
        +qry_ORAUPDDOCINDATE.AsString+' / '+qry_ORAUPDDOCOUTDATE.AsString);
      end;

     // отметка о выполнении апдейта
     cmd_ORA_UPDEVENT.Params[0].Value := qry_ORAUPDDOCUPDID.AsInteger;
     cmd_ORA_UPDEVENT.Execute;

     Inc(cno);
     qry_ORAUPDDOC.Next;
    end;
   qry_ORAUPDDOC.Close;

   WriteLn(logfile, '----------------------------');
end;

end.

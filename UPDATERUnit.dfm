object UPDATER: TUPDATER
  Left = 0
  Top = 0
  Caption = 'UPDATER'
  ClientHeight = 812
  ClientWidth = 702
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = Processing
  PixelsPerInch = 96
  TextHeight = 13
  object lbl1: TLabel
    Left = 216
    Top = 6
    Width = 273
    Height = 24
    Caption = 'PROCESSING IS PERFOMED.....'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object gb_docholidays: TGroupBox
    Left = 8
    Top = 279
    Width = 393
    Height = 234
    Caption = '  gb_docholidays  '
    TabOrder = 0
  end
  object gb_citezens: TGroupBox
    Left = 8
    Top = 72
    Width = 297
    Height = 201
    Caption = '  gb_citezens'
    TabOrder = 1
  end
  object btn_citezen: TButton
    Left = 8
    Top = 33
    Width = 89
    Height = 25
    Caption = 'btn_citezen'
    TabOrder = 2
    OnClick = SyncCitezen
  end
  object btn_documents: TButton
    Left = 114
    Top = 33
    Width = 89
    Height = 25
    Caption = 'btn_documents'
    TabOrder = 3
    OnClick = SyncDocument
  end
  object qry_ORADOCUMENT: TADQuery
    Connection = DataModule1.ORA_CON
    SQL.Strings = (
      'select '
      '        hl.indate, hl.outdate, hl.citezenid'
      '       , hl.holidaytypeid ,hl.id docid'
      '       ,st.stuffid, hl.skudinsert'
      
        '       ,to_char(NVL(hl.changestatusdate,sysdate), '#39'dd.mm.yyyy'#39') ' +
        'insdate'
      'from '
      '       hr_holiday hl '
      '      ,tc_stuff st'
      'where '
      '      st.citezenid(+)=hl.citezenid'
      '      and (hl.skudinsert is null)'
      '      and hl.holidaytypeid<>4182528 '
      '      and hl.holidaytypeid<>7024115'
      '      and hl.holidaytypeid in (6898188,1860)')
    Left = 48
    Top = 304
    object qry_ORADOCUMENTINDATE: TDateTimeField
      FieldName = 'INDATE'
    end
    object qry_ORADOCUMENTOUTDATE: TDateTimeField
      FieldName = 'OUTDATE'
    end
    object qry_ORADOCUMENTCITEZENID: TFMTBCDField
      FieldName = 'CITEZENID'
      Precision = 38
      Size = 38
    end
    object qry_ORADOCUMENTSTUFFID: TFMTBCDField
      FieldName = 'STUFFID'
      Required = True
      Precision = 38
      Size = 38
    end
    object qry_ORADOCUMENTSKUDINSERT: TFMTBCDField
      FieldName = 'SKUDINSERT'
      Precision = 38
      Size = 38
    end
    object qry_ORADOCUMENTINSDATE: TStringField
      FieldName = 'INSDATE'
      Size = 10
    end
    object qry_ORADOCUMENTHOLIDAYTYPEID: TFMTBCDField
      FieldName = 'HOLIDAYTYPEID'
      Precision = 38
      Size = 38
    end
    object qry_ORADOCUMENTDOCID: TFMTBCDField
      FieldName = 'DOCID'
      Required = True
      Precision = 38
      Size = 38
    end
  end
  object qry_SKD_CITEZEN: TADOQuery
    Connection = DataModule1.ADO_CON
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select   DISTINCT'
      '     st.LAST_NAME,st.FIRST_NAME, st.MIDDLE_NAME'
      '    , st.id_staff'
      '    ,sd.display_name'
      '  --  ,str.info_data'
      'from'
      '     STAFF     as st  ,'
      '     STAFF_REF as sr ,'
      '     subdiv_ref    sd'
      ' --    staff_info_data_str str'
      ''
      'where'
      ''
      '    st.ID_STAFF         = sr.STAFF_ID'
      '    and sd.id_ref        = sr.SUBDIV_ID'
      ' --   and str.staff_id    = st.ID_STAFF'
      ' --   and str.ref_id       = 5028'
      ' --   and str.info_data = '#39#39
      '    and st.deleted=0'
      '    and st.ID_FROM_1C='#39#39
      '    and sd.display_name not in ('#39#1054#1054#1054' '#171#1069#1085#1077#1088#1075#1086#1084#1072#1096' - '#1069#1083#1077#1082#1090#1088#1086#1089#1074#1103#1079#1100#187#39
      
        '    ,'#39#1052#1077#1090#1072#1083#1083#1086#1089#1073#1086#1088#39','#39#1053#1055#1060' '#171#1040#1050#1040#1088#187#39','#39#1047#1040#1054' '#171#1058#1058#1062#187#39','#39#1054#1054#1054' '#171#1042#1080#1082#1090#1086#1088#1080#1103#187#39','#39#1050#1072 +
        #1084#1089#1082#1080#1081' '#1092'-'#1083#39
      
        '    ,'#39#1042#1086#1077#1085#1085#1072#1103' '#1087#1088#1080#1077#1084#1082#1072#39','#39'935'#39','#39'958'#39','#39#1055#1088#1080#1074#1086#1083#1078#1089#1082#1080#1081' '#1092'-'#1083#39','#39'('#1085#1077' '#1086#1087#1088#1077#1076#1077 +
        #1083#1077#1085#1086')'#39','#39'978'#39
      '    ,'#39'914'#39','#39#1040#1053#1054' '#171#1057#1086#1094#1080#1072#1083#1100#1085#1099#1077' '#1091#1089#1083#1091#1075#1080#187#39')'
      '    and st.ID_STAFF not in (301552,301564,301558,301570,173919)'
      ''
      'ORDER by'
      '    st.ID_STAFF')
    Left = 192
    Top = 104
    object qry_SKD_CITEZENLAST_NAME: TWideStringField
      FieldName = 'LAST_NAME'
      Size = 100
    end
    object qry_SKD_CITEZENFIRST_NAME: TWideStringField
      FieldName = 'FIRST_NAME'
      Size = 100
    end
    object qry_SKD_CITEZENMIDDLE_NAME: TWideStringField
      FieldName = 'MIDDLE_NAME'
      Size = 100
    end
    object qry_SKD_CITEZENID_STAFF: TIntegerField
      FieldName = 'ID_STAFF'
    end
    object qry_SKD_CITEZENDISPLAY_NAME: TWideStringField
      FieldName = 'DISPLAY_NAME'
      Size = 100
    end
  end
  object qry_ORA_CITEZEN: TADQuery
    Connection = DataModule1.ORA_CON
    SQL.Strings = (
      'select cz.citezenid from HR_V_ACTIVE_EMPLOYEE cz'
      'where'
      '     cz.lastname    = :lastname'
      ' and cz.name        = :name'
      ' and ((:fathership is null) OR'
      '      (cz.fathership  = :fathership))'
      ' and cz.DCODE       = :dcode'
      ' ')
    Left = 192
    Top = 152
    ParamData = <
      item
        Name = 'LASTNAME'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'NAME'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'FATHERSHIP'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'DCODE'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end>
    object qry_ORA_CITEZENCITEZENID: TFMTBCDField
      FieldName = 'CITEZENID'
      Precision = 38
      Size = 38
    end
  end
  object cmd_SKD_INSCITEZEN: TADOCommand
    CommandText = 
      'update'#13#10'     staff_info_data_str str'#13#10'set'#13#10'   str.info_data= :xi' +
      'tezenid'#13#10'where'#13#10#13#10'    str.staff_id    =  :staffid'#13#10'   and str.re' +
      'f_id       = 5028;'
    Connection = DataModule1.ADO_CON
    Parameters = <
      item
        Name = 'xitezenid'
        Size = -1
        Value = Null
      end
      item
        Name = 'staffid'
        Size = -1
        Value = Null
      end>
    Left = 168
    Top = 208
  end
  object cmd_SKD_INSDOCUMENT: TADOCommand
    CommandText = 
      'insert into docum_leave'#13#10'(ID_LEAVE, STAFF_ID, NOMER_DOC, DOCUM_D' +
      'ATE, BEGIN_DATE_DOCUM'#13#10',END_DATE_DOCUM,LENGTH_HOUR,REFERENCE_ID,' +
      ' LAWS,ID_FROM_1C)'#13#10'values'#13#10'(gen_id(general_generator,1), :xstaff' +
      'id, :xdocnum, :docdate, :xindate, :xoutdate, 0, :xtypeid ,1, :do' +
      'cid) ;'
    Connection = DataModule1.ADO_CON
    Parameters = <
      item
        Name = 'xstaffid'
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'xdocnum'
        Attributes = [paNullable]
        DataType = ftWideString
        Precision = 100
        Size = 100
        Value = Null
      end
      item
        Name = 'docdate'
        DataType = ftDateTime
        Precision = 10
        Size = 6
        Value = Null
      end
      item
        Name = 'xindate'
        DataType = ftDateTime
        Precision = 10
        Size = 6
        Value = Null
      end
      item
        Name = 'xoutdate'
        DataType = ftDateTime
        Precision = 10
        Size = 6
        Value = Null
      end
      item
        Name = 'xtypeid'
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'docid'
        Attributes = [paNullable]
        DataType = ftWideString
        Precision = 38
        Size = 38
        Value = Null
      end>
    Left = 50
    Top = 360
  end
  object cmd_ORA_UPDDOC: TADCommand
    Connection = DataModule1.ORA_CON
    CommandText.Strings = (
      'update hr_holiday t set t.skudinsert=1'
      'where t.id=:xdocid')
    ParamData = <
      item
        Name = 'XDOCID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
    Left = 48
    Top = 416
  end
  object QRY_STAFF: TADOQuery
    Connection = DataModule1.ADO_CON
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select distinct'
      '     st.ID_STAFF, st.LAST_NAME, st.FIRST_NAME, st.MIDDLE_NAME'
      
        '     ,st.deleted, st.date_begin, st.date_dismiss, sd.display_nam' +
        'e'
      '    ,st.id_from_1c'
      'from'
      '     STAFF as st  ,'
      '     STAFF_REF as sr ,'
      '     subdiv_ref    sd'
      'where'
      '    st.ID_STAFF = sr.STAFF_ID'
      '    and sd.id_ref= sr.SUBDIV_ID'
      '    and st.deleted=0'
      '    and st.id_from_1c='#39#39
      'ORDER by'
      '    st.ID_STAFF')
    Left = 48
    Top = 104
    object QRY_STAFFID_STAFF: TIntegerField
      FieldName = 'ID_STAFF'
    end
    object QRY_STAFFLAST_NAME: TWideStringField
      FieldName = 'LAST_NAME'
      Size = 100
    end
    object QRY_STAFFFIRST_NAME: TWideStringField
      FieldName = 'FIRST_NAME'
      Size = 100
    end
    object QRY_STAFFMIDDLE_NAME: TWideStringField
      FieldName = 'MIDDLE_NAME'
      Size = 100
    end
    object QRY_STAFFDELETED: TIntegerField
      FieldName = 'DELETED'
    end
    object QRY_STAFFDATE_BEGIN: TDateField
      FieldName = 'DATE_BEGIN'
    end
    object QRY_STAFFDATE_DISMISS: TDateField
      FieldName = 'DATE_DISMISS'
    end
    object QRY_STAFFDISPLAY_NAME: TWideStringField
      FieldName = 'DISPLAY_NAME'
      Size = 100
    end
    object QRY_STAFFID_FROM_1C: TWideStringField
      FieldName = 'ID_FROM_1C'
      Size = 38
    end
  end
  object PRC_INSERT_STUFF: TADStoredProc
    Connection = DataModule1.ORA_CON
    StoredProcName = 'APPROOT.TC_INSERT_STUFF'
    Left = 48
    Top = 152
    ParamData = <
      item
        Position = 1
        Name = 'XSTUFFID'
        DataType = ftFMTBcd
        ADDataType = dtFmtBCD
        Precision = 38
        NumericScale = 38
        ParamType = ptInput
      end
      item
        Position = 2
        Name = 'XDELFLAG'
        DataType = ftFMTBcd
        ADDataType = dtFmtBCD
        Precision = 38
        NumericScale = 38
        ParamType = ptInput
      end
      item
        Position = 3
        Name = 'XLASTNAME'
        DataType = ftString
        ADDataType = dtAnsiString
        ParamType = ptInput
      end
      item
        Position = 4
        Name = 'XNAME'
        DataType = ftString
        ADDataType = dtAnsiString
        ParamType = ptInput
      end
      item
        Position = 5
        Name = 'XFATHERSHIP'
        DataType = ftString
        ADDataType = dtAnsiString
        ParamType = ptInput
      end
      item
        Position = 6
        Name = 'XDATEBEGIN'
        DataType = ftDateTime
        ADDataType = dtDateTime
        ParamType = ptInput
      end
      item
        Position = 7
        Name = 'XDATEDISMISS'
        DataType = ftDateTime
        ADDataType = dtDateTime
        ParamType = ptInput
      end
      item
        Position = 8
        Name = 'XDCODE'
        DataType = ftString
        ADDataType = dtAnsiString
        ParamType = ptInput
      end
      item
        Name = 'XID_FROM_1C'
        DataType = ftFMTBcd
      end>
  end
  object cmd_SKD_INSCITEZEN2: TADOCommand
    CommandText = 
      'update  STAFF st '#13#10'set '#13#10' st.ID_FROM_1C              = :citezeni' +
      'd'#13#10' where st.ID_STAFF         = :STAFF_ID'
    Connection = DataModule1.ADO_CON
    Parameters = <
      item
        Name = 'citezenid'
        Attributes = [paNullable]
        DataType = ftWideString
        Precision = 38
        Size = 38
        Value = Null
      end
      item
        Name = 'STAFF_ID'
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end>
    Left = 232
    Top = 208
  end
  object qry_ORAUPDDOC: TADQuery
    Connection = DataModule1.ORA_CON
    SQL.Strings = (
      'select'
      '     he.id updid, he.edittype, he.editdate'
      '     ,hl.indate, hl.outdate, hl.citezenid'
      '     ,hl.holidaytypeid ,he.holidayid docid'
      '     ,hl.skudinsert'
      ''
      'from'
      '    HR_HOLIDAYEDIT he'
      '   ,HR_HOLIDAY hl'
      'where'
      '    he.holidayid=hl.id(+)'
      '    and (he.updflag is null)')
    Left = 176
    Top = 304
    object qry_ORAUPDDOCUPDID: TFMTBCDField
      FieldName = 'UPDID'
      Required = True
      Precision = 38
      Size = 38
    end
    object qry_ORAUPDDOCEDITTYPE: TStringField
      FieldName = 'EDITTYPE'
    end
    object qry_ORAUPDDOCEDITDATE: TDateTimeField
      FieldName = 'EDITDATE'
    end
    object qry_ORAUPDDOCINDATE: TDateTimeField
      FieldName = 'INDATE'
    end
    object qry_ORAUPDDOCOUTDATE: TDateTimeField
      FieldName = 'OUTDATE'
    end
    object qry_ORAUPDDOCCITEZENID: TFMTBCDField
      FieldName = 'CITEZENID'
      Precision = 38
      Size = 38
    end
    object qry_ORAUPDDOCHOLIDAYTYPEID: TFMTBCDField
      FieldName = 'HOLIDAYTYPEID'
      Precision = 38
      Size = 38
    end
    object qry_ORAUPDDOCDOCID: TFMTBCDField
      FieldName = 'DOCID'
      Required = True
      Precision = 38
      Size = 38
    end
    object qry_ORAUPDDOCSKUDINSERT: TFMTBCDField
      FieldName = 'SKUDINSERT'
      Precision = 38
      Size = 38
    end
  end
  object cmd_SKD_DELDOC: TADOCommand
    CommandText = 
      'DELETE  from'#13#10'         docum_leave dl  '#13#10'where'#13#10'       dl.id_fro' +
      'm_1c  = :docid'#13#10
    Connection = DataModule1.ADO_CON
    Parameters = <
      item
        Name = 'docid'
        Attributes = [paNullable]
        DataType = ftWideString
        Precision = 38
        Size = 38
        Value = Null
      end>
    Left = 178
    Top = 360
  end
  object cmd_SKD_UPDDOC: TADOCommand
    CommandText = 
      'UPDATE'#13#10'         docum_leave dl '#13#10'set'#13#10'      dl.BEGIN_DATE_DOCUM' +
      ' = :indate'#13#10'     ,dl.END_DATE_DOCUM    = :outdate'#13#10' where'#13#10'     ' +
      '  dl.id_from_1c  = :docid'#13#10
    Connection = DataModule1.ADO_CON
    Parameters = <
      item
        Name = 'indate'
        DataType = ftDateTime
        Precision = 10
        Size = 6
        Value = Null
      end
      item
        Name = 'outdate'
        DataType = ftDateTime
        Precision = 10
        Size = 6
        Value = Null
      end
      item
        Name = 'docid'
        Attributes = [paNullable]
        DataType = ftWideString
        Precision = 38
        Size = 38
        Value = Null
      end>
    Left = 266
    Top = 359
  end
  object cmd_ORA_UPDEVENT: TADCommand
    Connection = DataModule1.ORA_CON
    CommandText.Strings = (
      'update '
      '  hr_holidayedit hh '
      'set '
      '  hh.upddate=sysdate, hh.updflag=1'
      'where'
      '  hh.id= :updid')
    ParamData = <
      item
        Name = 'UPDID'
        ParamType = ptInput
      end>
    Left = 176
    Top = 416
  end
  object PRC_ORA_UPD_CITEZEN: TADStoredProc
    Connection = DataModule1.ORA_CON
    StoredProcName = 'APPROOT.TC_UPDATECITEZEN'
    Left = 48
    Top = 208
  end
end

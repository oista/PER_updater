program PER_updater;

uses
  Vcl.Forms,
  UPDATERUnit in 'UPDATERUnit.pas' {Form1},
  DMUnit in 'DMUnit.pas' {DataModule1: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TUPDATER, UPDATER);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.Run;
end.

unit DMUnit;

interface

uses
  System.SysUtils, System.Classes, uADGUIxIntf, uADGUIxFormsfError,
  uADGUIxFormsWait, uADStanIntf, uADStanOption, uADStanError, uADPhysIntf,
  uADStanDef, uADStanPool, uADStanAsync, uADPhysManager, uADPhysIB,
  uADCompClient, Data.DB, IBDatabase, uADPhysOracle, uADCompGUIx, Data.Win.ADODB;

type
  TDataModule1 = class(TDataModule)
    ADGUIxErrorDialog1: TADGUIxErrorDialog;
    ADGUIxWaitCursor1: TADGUIxWaitCursor;
    ADPhysOracleDriverLink1: TADPhysOracleDriverLink;
    ORA_CON: TADConnection;
    ADPhysIBDriverLink1: TADPhysIBDriverLink;
    ADO_CON: TADOConnection;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule1: TDataModule1;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.

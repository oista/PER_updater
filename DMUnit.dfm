object DataModule1: TDataModule1
  OldCreateOrder = False
  Height = 585
  Width = 623
  object ADGUIxErrorDialog1: TADGUIxErrorDialog
    Left = 88
    Top = 64
  end
  object ADGUIxWaitCursor1: TADGUIxWaitCursor
    Left = 88
    Top = 120
  end
  object ADPhysOracleDriverLink1: TADPhysOracleDriverLink
    Left = 88
    Top = 176
  end
  object ORA_CON: TADConnection
    Params.Strings = (
      'Database=PARUS'
      'User_Name=approot'
      'Password=app968root'
      'DriverID=Ora')
    Connected = True
    LoginPrompt = True
    Left = 224
    Top = 64
  end
  object ADPhysIBDriverLink1: TADPhysIBDriverLink
    DriverID = 'FB'
    Left = 85
    Top = 232
  end
  object ADO_CON: TADOConnection
    ConnectionString = 
      'Provider=MSDASQL.1;Password=percoperco;Persist Security Info=Tru' +
      'e;User ID=sysdba;Extended Properties="DSN=FireBird;Driver={Fireb' +
      'ird/InterBase(r) driver};Dbname=C:\SCD17K.FDB;CHARSET=NONE;PWD=p' +
      'ercoperco;UID=sysdba;Client=C:\Program Files (x86)\Firebird\Fire' +
      'bird_2_5\bin\fbclient.dll;"'
    DefaultDatabase = 'C:\SCD17K.FDB'
    Provider = 'MSDASQL.1'
    Left = 224
    Top = 128
  end
end

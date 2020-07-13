object Dm: TDm
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 270
  Width = 315
  object Conn: TFDConnection
    Params.Strings = (
      'Database=D:\Projetos\IdeaCli\BD\IdeaCli.db'
      'OpenMode=ReadWrite'
      'DriverID=SQLite')
    Connected = True
    LoginPrompt = False
    Left = 56
    Top = 40
  end
  object qry_cliente: TFDQuery
    Connection = Conn
    Left = 56
    Top = 104
  end
  object qry_geral: TFDQuery
    Connection = Conn
    Left = 144
    Top = 104
  end
  object qry_usuario: TFDQuery
    Connection = Conn
    Left = 232
    Top = 104
  end
  object qry_perfil: TFDQuery
    Connection = Conn
    Left = 56
    Top = 176
  end
  object qry_perfil_opcao: TFDQuery
    Connection = Conn
    Left = 144
    Top = 176
  end
  object qry_perfis: TFDQuery
    Connection = Conn
    SQL.Strings = (
      'SELECT * FROM TAB_PERFIL P WHERE P.SITUACAO='#39'A'#39)
    Left = 232
    Top = 176
  end
end

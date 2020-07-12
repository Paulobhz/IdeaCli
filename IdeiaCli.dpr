program IdeiaCli;

uses
  System.StartUpCopy,
  FMX.Forms,
  uFrmLogin in 'uFrmLogin.pas' {FrmLogin},
  uFrmMenu in 'uFrmMenu.pas' {FrmMenu},
  uFrmBase in 'uFrmBase.pas' {FrmBase},
  uFancyDialog in 'Units\uFancyDialog.pas',
  uDm in 'uDm.pas' {Dm: TDataModule},
  uFrmCliente in 'uFrmCliente.pas' {FrmCliente},
  uFrmPerfil in 'uFrmPerfil.pas' {FrmPerfil},
  UFrmUsuario in 'UFrmUsuario.pas' {FrmUsuario};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := true;
  Application.Initialize;
  Application.CreateForm(TFrmLogin, FrmLogin);
  Application.CreateForm(TDm, Dm);
  Application.Run;
end.

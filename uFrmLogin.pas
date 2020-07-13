unit uFrmLogin;

interface

uses
  uFancyDialog,

  FMX.Controls,
  FMX.Controls.Presentation,
  FMX.Dialogs,
  FMX.Edit,
  FMX.Forms,
  FMX.Graphics,
  FMX.Layouts,
  FMX.Objects,
  FMX.StdCtrls,
  FMX.Types,

  System.Classes,
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Variants,

  Winapi.Windows;

type
  TFrmLogin = class(TForm)
    lytLogin: TLayout;
    rctLogin: TRectangle;
    Rectangle1: TRectangle;
    Label1: TLabel;
    Rectangle2: TRectangle;
    Rectangle3: TRectangle;
    btnAcessar: TSpeedButton;
    edtUsuario: TEdit;
    StyleBook1: TStyleBook;
    edtSenha: TEdit;
    procedure FormShow(Sender: TObject);
    procedure edtUsuarioKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure btnAcessarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    fancy : TFancyDialog;

    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation

uses
  uDm,
  uFrmMenu;

{$R *.fmx}

procedure TFrmLogin.btnAcessarClick(Sender: TObject);
begin
    //validar usuário
    Dm.qry_usuario.Active := False;
    Dm.qry_usuario.SQL.Clear;
    Dm.qry_usuario.SQL.Add('SELECT * FROM TAB_USUARIO U ');
    Dm.qry_usuario.SQL.Add('WHERE U.LOGIN = :LOGIN');
    Dm.qry_usuario.ParamByName('LOGIN').Value := edtUsuario.Text;
    Dm.qry_usuario.Active := True;

    if (Dm.qry_usuario.RecordCount>0)and
       (Dm.qry_usuario.FieldByName('LOGIN').AsString = edtUsuario.Text)and
       (Dm.qry_usuario.FieldByName('SENHA').AsString = edtSenha.text) then
    begin

        if not Assigned(FrmMenu) then
            Application.CreateForm(TFrmMenu,FrmMenu);
        Application.MainForm := FrmMenu;
        //preencher lista de permissões
       FrmMenu.PPermission[1].aOpcao:='CLI'; //Permissão Cliente
       FrmMenu.PPermission[2].aOpcao:='USR'; //Permissão Usuário
       FrmMenu.PPermission[3].aOpcao:='PER'; //Permissão Perfil

       FrmMenu.UserAdmin := Dm.qry_usuario.FieldByName('ADMINISTRADOR').AsString='S';

       if not FrmMenu.UserAdmin then begin
            Dm.qry_perfil_opcao.Active := False;
            Dm.qry_perfil_opcao.SQL.Clear;
            Dm.qry_perfil_opcao.SQL.Add('SELECT * FROM TAB_PERFIL_OPCAO O ');
            Dm.qry_perfil_opcao.SQL.Add('WHERE O.COD_PERFIL = :PERFIL');
            Dm.qry_perfil_opcao.ParamByName('PERFIL').Value := Dm.qry_usuario.FieldByName('COD_PERFIL').AsString;
            Dm.qry_perfil_opcao.Active := True;
            while not Dm.qry_perfil_opcao.Eof do  begin
                if Dm.qry_perfil_opcao.FieldByName('COD_OPCAO').AsString = 'CLI' then
                   FrmMenu.PPermission[1].aPermissao := Dm.qry_perfil_opcao.FieldByName('COD_PERMISSAO').AsString;
                if Dm.qry_perfil_opcao.FieldByName('COD_OPCAO').AsString = 'USR' then
                  FrmMenu.PPermission[2].aPermissao := Dm.qry_perfil_opcao.FieldByName('COD_PERMISSAO').AsString;
                if Dm.qry_perfil_opcao.FieldByName('COD_OPCAO').AsString = 'PER' then
                  FrmMenu.PPermission[3].aPermissao := Dm.qry_perfil_opcao.FieldByName('COD_PERMISSAO').AsString;
                Dm.qry_perfil_opcao.Next;
            end;

       end;


       FrmMenu.Show;
       FrmLogin.Close;


    end else begin
       fancy.Show(TIconDialog.Error,'Erro de Usuário','Usuário ou senha não encontrados! Qualquer dúvida, chamar o administrador do sistema!','Ok');
       edtUsuario.SetFocus;
       exit

    end;
end;

procedure TFrmLogin.edtUsuarioKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
   If (key = VK_RETURN)or(Key = 9) then
   Begin
      Key:= 0;
      if (Sender is TEdit)and(TEdit(Sender).tag = 1) then
          edtSenha.SetFocus;
      if (Sender is TEdit)and(TEdit(Sender).tag = 2) then
          btnAcessar.SetFocus;
   end;
   if Key = VK_ESCAPE then
      Close;

end;

procedure TFrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    fancy.DisposeOf;
    FrmLogin := nil;
end;

procedure TFrmLogin.FormCreate(Sender: TObject);
begin
  fancy := TFancyDialog.Create(FrmLogin);
end;

procedure TFrmLogin.FormShow(Sender: TObject);
begin
    edtUsuario.SetFocus;
end;

end.

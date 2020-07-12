unit uFrmMenu;

interface

uses
  uDm,
  uFancyDialog,

  FMX.Controls,
  FMX.Controls.Presentation,
  FMX.Dialogs,
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
  System.Variants;

type
    aPermission = record
      aOpcao     : string;
      aPermissao : string;
    end;

type
  TFrmMenu = class(TForm)
    StyleBook: TStyleBook;
    lytMenu: TLayout;
    rctLogin: TRectangle;
    rctPerfil: TRectangle;
    lblNome: TLabel;
    rctUsuario: TRectangle;
    rctCliente: TRectangle;
    Image1: TImage;
    Image2: TImage;
    img_clientes: TImage;
    Label1: TLabel;
    PERFIL: TLabel;
    Label3: TLabel;
    procedure rctClienteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure rctPerfilClick(Sender: TObject);
    procedure rctUsuarioClick(Sender: TObject);
  private
    Fancy : TFancyDialog;
    { Private declarations }
  public
    PPermission : array[1..3] of aPermission;
    UserAdmin   : boolean;
    function VerificaPermissao(aOpcao : string; aPermiss: Char):Boolean;
    { Public declarations }
  end;

var
  FrmMenu: TFrmMenu;

implementation

uses
  uFrmCliente, uFrmPerfil, UFrmUsuario;

{$R *.fmx}

procedure TFrmMenu.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Fancy.DisposeOf;
end;

procedure TFrmMenu.FormCreate(Sender: TObject);
begin
    Fancy := TFancyDialog.Create(FrmMenu);
end;

procedure TFrmMenu.rctClienteClick(Sender: TObject);
begin
    if VerificaPermissao('CLI','C') then
    begin
        if not Assigned(FrmCliente) then
            Application.CreateForm(TFrmCliente,FrmCliente);
        FrmCliente.Show;

    end else
        fancy.Show(TIconDialog.Error,'Permissão','Você não tem permissão para acessar essa opção!','Ok');

end;

procedure TFrmMenu.rctPerfilClick(Sender: TObject);
begin
    if VerificaPermissao('PER','C') then
    begin
        if not Assigned(FrmPerfil) then
            Application.CreateForm(TFrmPerfil,FrmPerfil);
        FrmPerfil.Show;

    end else
        fancy.Show(TIconDialog.Error,'Permissão','Você não tem permissão para acessar essa opção!','Ok');
end;

procedure TFrmMenu.rctUsuarioClick(Sender: TObject);
begin
    if VerificaPermissao('USR','C') then
    begin
        if not Assigned(FrmUsuario) then
            Application.CreateForm(TFrmUsuario,FrmUsuario);
        FrmUsuario.Show;

    end else
        fancy.Show(TIconDialog.Error,'Permissão','Você não tem permissão para acessar essa opção!','Ok');

end;

function TFrmMenu.VerificaPermissao(aOpcao: string; aPermiss: Char): Boolean;
Var
  I : Integer;
begin
    Result := UserAdmin;
    if not UserAdmin then
    begin
      for I := 1 to Length(PPermission) do
          if PPermission[I].aOpcao=aOpcao then Result := (Pos(aPermiss,PPermission[I].aPermissao)>0);

    end;
end;

end.

unit uFrmMenu;

interface

uses
  uDm,

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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMenu: TFrmMenu;

implementation

uses
  uFrmCliente;

{$R *.fmx}

procedure TFrmMenu.rctClienteClick(Sender: TObject);
begin
    if not Assigned(FrmCliente) then
        Application.CreateForm(TFrmCliente,FrmCliente);
    FrmCliente.Show;

end;

end.

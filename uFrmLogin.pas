unit uFrmLogin;

interface

uses
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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.fmx}

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

end;

procedure TFrmLogin.FormShow(Sender: TObject);
begin
    edtUsuario.SetFocus;
end;

end.

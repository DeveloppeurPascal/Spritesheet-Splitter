unit fMain;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Edit,
  FMX.EditBox,
  FMX.NumberBox,
  FMX.StdCtrls,
  FMX.Controls.Presentation;

type
  TfrmMain = class(TForm)
    OpenDialog1: TOpenDialog;
    btnLoad: TButton;
    lblLargeur: TLabel;
    edtSpriteWidth: TNumberBox;
    lblSpriteMarginBottom: TLabel;
    edtSpriteMarginBottom: TNumberBox;
    lblSpriteMarginRight: TLabel;
    edtSpriteMarginRight: TNumberBox;
    lblSpriteHeight: TLabel;
    edtSpriteHeight: TNumberBox;
    btnExportSpritesFromSpriteSheet: TButton;
    procedure btnLoadClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnExportSpritesFromSpriteSheetClick(Sender: TObject);
  private
    FSpriteSheetFileName: string;
    procedure SetSpriteSheetFileName(const Value: string);
  public
    property SpriteSheetFileName: string read FSpriteSheetFileName
      write SetSpriteSheetFileName;

    function ZeroLeft(ANumber: integer; Zerocount: integer): string;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

uses
  System.IOUtils;

procedure TfrmMain.btnExportSpritesFromSpriteSheetClick(Sender: TObject);
var
  bmpSource, bmpSprite: tbitmap;
  x, y: integer;
  num: integer;
  SpriteWidth, SpriteHeight, SpriteMarginRight, SpriteMarginBottom: integer;
  SpriteFileName: string;
  SpriteFileExtension: string;
begin
  SpriteFileName := tpath.Combine(tpath.GetDirectoryName(FSpriteSheetFileName),
    tpath.GetFileNameWithoutExtension(FSpriteSheetFileName));
  SpriteFileExtension := tpath.GetExtension(FSpriteSheetFileName);

  SpriteWidth := trunc(edtSpriteWidth.Value);
  SpriteHeight := trunc(edtSpriteHeight.Value);
  SpriteMarginRight := trunc(edtSpriteMarginRight.Value);
  SpriteMarginBottom := trunc(edtSpriteMarginBottom.Value);

  bmpSource := tbitmap.CreateFromFile(SpriteSheetFileName);
  try
    num := 0;
    y := 0;
    while (y < bmpSource.Height) do
    begin
      x := 0;
      while (x < bmpSource.Width) do
      begin
        bmpSprite := tbitmap.Create;
        try
          bmpSprite.SetSize(SpriteWidth, SpriteHeight);
          bmpSprite.CopyFromBitmap(bmpSource,
            trect.Create(x, y, x + SpriteWidth, y + SpriteHeight), 0, 0);
          bmpSprite.SaveToFile(SpriteFileName + '-' + ZeroLeft(num, 5) +
            SpriteFileExtension);
          inc(num);
        finally
          bmpSprite.Free;
        end;
        x := x + SpriteWidth + SpriteMarginRight;
      end;
      y := y + SpriteHeight + SpriteMarginBottom;
    end;
  finally
    bmpSource.Free;
  end;
  Showmessage('Done !');
end;

procedure TfrmMain.btnLoadClick(Sender: TObject);
begin
  if OpenDialog1.Execute and tfile.exists(OpenDialog1.FileName) then
  begin
    SpriteSheetFileName := OpenDialog1.FileName;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  OpenDialog1.InitialDir := tpath.GetPicturesPath;
  SpriteSheetFileName := '';
end;

procedure TfrmMain.SetSpriteSheetFileName(const Value: string);
begin
  FSpriteSheetFileName := Value;
  if Value.IsEmpty then
  begin
    edtSpriteWidth.Enabled := false;
    edtSpriteHeight.Enabled := false;
    edtSpriteMarginRight.Enabled := false;
    edtSpriteMarginBottom.Enabled := false;
    btnExportSpritesFromSpriteSheet.Enabled := false;
  end
  else
  begin
    edtSpriteWidth.Enabled := true;
    edtSpriteHeight.Enabled := true;
    edtSpriteMarginRight.Enabled := true;
    edtSpriteMarginBottom.Enabled := true;
    btnExportSpritesFromSpriteSheet.Enabled := true;
  end;
end;

function TfrmMain.ZeroLeft(ANumber, Zerocount: integer): string;
begin
  result := ANumber.ToString;
  while (result.Length < Zerocount) do
    result := '0' + result;
end;

initialization

{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := true;
{$ENDIF}

end.

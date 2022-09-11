unit Al;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, defSets, math;

type

  { TForm5 }

  TForm5 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    StaticText1: TStaticText;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: char);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    function checkAL():boolean;
  private

  public

  end;

var
  Form5: TForm5;

implementation

uses Unit1;

{$R *.lfm}

{ TForm5 }

procedure TForm5.Button1Click(Sender: TObject);
begin
  self.Hide();
end;
// Применить
procedure TForm5.Button2Click(Sender: TObject);
begin
  if checkAL = False then
  begin
    lampChance := strtoint(Edit1.Text);
    Form1.Edit1.Text := Edit1.Text;
    Form1.TrackBar1.Position := strtoint(Edit1.Text);
    Form1.ReDraw;
  end;
end;
// Ок
procedure TForm5.Button3Click(Sender: TObject);
begin
  if checkAL = False then
  begin
    lampChance := strtoint(Edit1.Text);
    Form1.ReDraw;
    self.Hide();
  end;
end;

// случайно
procedure TForm5.Button4Click(Sender: TObject);
begin
     Edit1.Text := inttostr(RandomRange(0,101));
end;

procedure TForm5.Edit1Change(Sender: TObject);
begin
     checkAL();
end;

procedure TForm5.Edit1KeyPress(Sender: TObject; var Key: char);
begin
 // проверяем нажатую клавишу
 case Key of
  // цифры разрешаем
  '0'..'9':key:=key;
  // разрешаем BackSpace
  #8: key:=key;
  #13: checkAL();
  // все прочие клавиши "гасим"
  else
    begin
         beep();
         key:=#0;
    end;
 end;
end;

procedure TForm5.FormHide(Sender: TObject);
begin
  Form1.Enabled := True;
end;

procedure TForm5.FormShow(Sender: TObject);
begin
  Form1.Enabled := False;
  Edit1.Text := inttostr(lampChance);
end;


function TForm5.checkAL():boolean;
var sp:integer;
begin
 StaticText1.Visible := False;
 if ((Edit1.Text <> '') and not ( (length(Edit1.Text) > 1) and (Edit1.Text[1] = '0'))) then
  begin
    if(StrToInt(Edit1.Text) > 100) then
      Edit1.Text := '100';
    sp := StrToInt(Edit1.Text);

    if ((sp >= 0) and (sp <= 100)) then
    begin
         Result := False;
    end
    else
    begin
         StaticText1.Visible := True;
         Result := True;
    end;

  end
  else
  begin
  Edit1.Text := '0';
  StaticText1.Visible := True;
  Result := True;
  end;

end;

end.


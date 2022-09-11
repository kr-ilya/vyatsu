unit settings;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, defSets, math;

type

  { TForm2 }

  TForm2 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure ComboBox1Select(Sender: TObject);
    procedure ComboBox2Select(Sender: TObject);
    procedure ComboBox3Select(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    function getColorName(clr:string):string;
    function getColorByName(clr:string):string;
    function getIndexColor(clr:string):integer;
    function checkDiffrentColor():boolean;
  private

  public

  end;

var
  Form2: TForm2;
  rClrs:array of string;
  aid: array[0..2] of integer;

implementation

uses Unit1;
{$R *.lfm}

{ TForm2 }

procedure TForm2.FormShow(Sender: TObject);
var
  i:integer;
begin
     setLength(rClrs, 6);
     rClrs := allColors;
     ComboBox1.Items.Clear();
     ComboBox2.Items.Clear();
     ComboBox3.Items.Clear();

     for i:= 0 to 5 do
     begin
          ComboBox1.Items.Add(getColorName(allColors[i]));
          ComboBox2.Items.Add(getColorName(allColors[i]));
          ComboBox3.Items.Add(getColorName(allColors[i]));
     end;
     ComboBox1.ItemIndex := getIndexColor(clrs[0]);
     ComboBox2.ItemIndex := getIndexColor(clrs[1]);
     ComboBox3.ItemIndex := getIndexColor(clrs[2]);
     aid[0] := ComboBox1.ItemIndex;
     aid[1] := ComboBox2.ItemIndex;
     aid[2] := ComboBox3.ItemIndex;
     Form1.Enabled := False;
end;

// Отмена
procedure TForm2.Button2Click(Sender: TObject);
begin
     self.Hide();
end;

// Ок
procedure TForm2.Button3Click(Sender: TObject);
begin
    if checkDiffrentColor() = False then
    begin
     clrs[0] := getColorByName(ComboBox1.Items[ComboBox1.ItemIndex]);
     clrs[1] := getColorByName(ComboBox2.Items[ComboBox2.ItemIndex]);
     clrs[2] := getColorByName(ComboBox3.Items[ComboBox3.ItemIndex]);
     Form1.set_custom_settings;
     self.Hide();
    end;
end;

//случайно
procedure TForm2.Button4Click(Sender: TObject);
var id:integer;
begin
     StaticText4.Visible := False;
     id := RandomRange(0,6) mod length(rClrs);
     ComboBox1.ItemIndex := getIndexColor(rClrs[id]);
     aid[0] := ComboBox1.ItemIndex;
     delete(rClrs, id, 1);
     id := RandomRange(0,6) mod length(rClrs);
     ComboBox2.ItemIndex := getIndexColor(rClrs[id]);
     aid[1] := ComboBox2.ItemIndex;
     delete(rClrs, id, 1);
     id := RandomRange(0,6) mod length(rClrs);
     ComboBox3.ItemIndex := getIndexColor(rClrs[id]);
     aid[2] := ComboBox3.ItemIndex;
     delete(rClrs, id, 1);
     setLength(rClrs, 6);
     rClrs := allColors;
end;

// Применить
procedure TForm2.Button1Click(Sender: TObject);
begin
    if checkDiffrentColor() = False then
    begin
     clrs[0] := getColorByName(ComboBox1.Items[ComboBox1.ItemIndex]);
     clrs[1] := getColorByName(ComboBox2.Items[ComboBox2.ItemIndex]);
     clrs[2] := getColorByName(ComboBox3.Items[ComboBox3.ItemIndex]);
     Form1.set_custom_settings;
    end;
end;

procedure TForm2.ComboBox1Select(Sender: TObject);
begin
     if checkDiffrentColor() = True then
        ComboBox1.ItemIndex := aid[0]
     else
        aid[0] := ComboBox1.ItemIndex;
end;

procedure TForm2.ComboBox2Select(Sender: TObject);
begin
     if checkDiffrentColor() = True then
        ComboBox2.ItemIndex := aid[1]
     else
        aid[1] := ComboBox2.ItemIndex;
end;

procedure TForm2.ComboBox3Select(Sender: TObject);
begin
     if checkDiffrentColor() = True then
        ComboBox3.ItemIndex := aid[2]
     else
        aid[2] := ComboBox3.ItemIndex;
end;

procedure TForm2.FormHide(Sender: TObject);
begin
   Form1.Enabled := True;
end;

function TForm2.getColorName(clr:string):string;
begin
  case(clr) of
    'blue': Result := 'Синий';
    'red': Result := 'Красный';
    'green': Result := 'Зеленый';
    'purple': Result := 'Фиолетовый';
    'aqua': Result := 'Голубой';
    'yellow': Result := 'Желтый';
   end;
end;


function TForm2.getColorByName(clr:string):string;
begin
  case(clr) of
    'Синий': Result := 'blue';
    'Красный': Result := 'red';
    'Зеленый': Result := 'green';
    'Фиолетовый': Result := 'purple';
    'Голубой': Result := 'aqua';
    'Желтый': Result := 'yellow';
   end;
end;

function TForm2.getIndexColor(clr:string):integer;
var i:integer;
begin
     for i:= 0 to 5 do
     begin
          if(allColors[i] = clr) then
              Result := i;
     end;
end;

function TForm2.checkDiffrentColor():boolean;
begin
     StaticText4.Visible := False;
     if (ComboBox1.Items[ComboBox1.ItemIndex] = ComboBox2.Items[ComboBox2.ItemIndex]) or
        (ComboBox1.Items[ComboBox1.ItemIndex] = ComboBox3.Items[ComboBox3.ItemIndex]) or
        (ComboBox2.Items[ComboBox2.ItemIndex] = ComboBox3.Items[ComboBox3.ItemIndex]) then
     begin
        StaticText4.Font.Color := clRed;
        StaticText4.Visible := True;
        Result := True
     end
     else
         Result := False;
end;

end.


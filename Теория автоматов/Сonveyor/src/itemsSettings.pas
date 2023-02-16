unit itemsSettings;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, defSets, math;

type

  { TForm4 }

  TForm4 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    StaticText1: TStaticText;

    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure ComboBox1Select(Sender: TObject);
    procedure ComboBox2Select(Sender: TObject);
    procedure ComboBox3Select(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    function getItemName(clr:string):string;
    function getItemByName(clr:string):string;
    function getIndexItem(clr:string):integer;
    function checkDiffrentItem():boolean;
  private

  public

  end;

var
  Form4: TForm4;
  rItems:array of string;
  aid: array[0..2] of integer;

implementation

uses Unit1;

{$R *.lfm}

{ TForm4 }


procedure TForm4.FormShow(Sender: TObject);
var i:integer;
begin
     setLength(rItems, 6);
     rItems := allItems;
     ComboBox1.Items.Clear();
     ComboBox2.Items.Clear();
     ComboBox3.Items.Clear();

     for i:= 0 to 5 do
     begin
          ComboBox1.Items.Add(getItemName(allItems[i]));
          ComboBox2.Items.Add(getItemName(allItems[i]));
          ComboBox3.Items.Add(getItemName(allItems[i]));
     end;
     ComboBox1.ItemIndex := getIndexItem(items[0]);
     ComboBox2.ItemIndex := getIndexItem(items[1]);
     ComboBox3.ItemIndex := getIndexItem(items[2]);
     aid[0] := ComboBox1.ItemIndex;
     aid[1] := ComboBox2.ItemIndex;
     aid[2] := ComboBox3.ItemIndex;
   Form1.Enabled := False;
end;

procedure TForm4.FormHide(Sender: TObject);
begin
  Form1.Enabled := True;
end;

procedure TForm4.ComboBox1Select(Sender: TObject);
begin
  if checkDiffrentItem() = True then
        ComboBox1.ItemIndex := aid[0]
     else
        aid[0] := ComboBox1.ItemIndex;
end;

// Отмена
procedure TForm4.Button1Click(Sender: TObject);
begin
  Self.Hide()
end;

// Применить
procedure TForm4.Button2Click(Sender: TObject);
begin
  if checkDiffrentItem() = False then
  begin
     items[0] := getItemByName(ComboBox1.Items[ComboBox1.ItemIndex]);
     items[1] := getItemByName(ComboBox2.Items[ComboBox2.ItemIndex]);
     items[2] := getItemByName(ComboBox3.Items[ComboBox3.ItemIndex]);
     Form1.set_custom_settings;
  end;
end;
// Ок
procedure TForm4.Button3Click(Sender: TObject);
begin
  if checkDiffrentItem() = False then
  begin
   items[0] := getItemByName(ComboBox1.Items[ComboBox1.ItemIndex]);
   items[1] := getItemByName(ComboBox2.Items[ComboBox2.ItemIndex]);
   items[2] := getItemByName(ComboBox3.Items[ComboBox3.ItemIndex]);
   Form1.set_custom_settings;
   Self.Hide()
  end;
end;

//случайно
procedure TForm4.Button4Click(Sender: TObject);
var id:integer;
begin
     StaticText1.Visible := False;
     id := RandomRange(0,6) mod length(rItems);
     ComboBox1.ItemIndex := getIndexItem(rItems[id]);
     delete(rItems, id, 1);
     id := RandomRange(0,6) mod length(rItems);
     ComboBox2.ItemIndex := getIndexItem(rItems[id]);
     delete(rItems, id, 1);
     id := RandomRange(0,6) mod length(rItems);
     ComboBox3.ItemIndex := getIndexItem(rItems[id]);
     delete(rItems, id, 1);
     setLength(rItems, 6);
     rItems := allItems;

     aid[0] := ComboBox1.ItemIndex;
     aid[1] := ComboBox2.ItemIndex;
     aid[2] := ComboBox3.ItemIndex;

end;

procedure TForm4.ComboBox2Select(Sender: TObject);
begin
  if checkDiffrentItem() = True then
        ComboBox2.ItemIndex := aid[1]
     else
        aid[1] := ComboBox2.ItemIndex;
end;

procedure TForm4.ComboBox3Select(Sender: TObject);
begin
  if checkDiffrentItem() = True then
        ComboBox3.ItemIndex := aid[2]
     else
        aid[2] := ComboBox3.ItemIndex;
end;


function TForm4.getItemName(clr:string):string;
begin
  case(clr) of
    'hammer': Result := 'Молоток';
    'wrench': Result := 'Ключ';
    'gear': Result := 'Шестерня';
    'pencil': Result := 'Карандаш';
    'pliers': Result := 'Плоскогубцы';
    'saw': Result := 'Пила';
   end;
end;

function TForm4.getItemByName(clr:string):string;
begin
  case(clr) of
    'Молоток': Result := 'hammer';
    'Ключ': Result := 'wrench';
    'Шестерня': Result := 'gear';
    'Карандаш': Result := 'pencil';
    'Плоскогубцы': Result := 'pliers';
    'Пила': Result := 'saw';
   end;
end;

function TForm4.getIndexItem(clr:string):integer;
var i:integer;
begin
     for i:= 0 to 5 do
     begin
          if(allItems[i] = clr) then
              Result := i;
     end;
end;

function TForm4.checkDiffrentItem():boolean;
begin
     StaticText1.Visible := False;
     if (ComboBox1.Items[ComboBox1.ItemIndex] = ComboBox2.Items[ComboBox2.ItemIndex]) or
        (ComboBox1.Items[ComboBox1.ItemIndex] = ComboBox3.Items[ComboBox3.ItemIndex]) or
        (ComboBox2.Items[ComboBox2.ItemIndex] = ComboBox3.Items[ComboBox3.ItemIndex]) then
     begin
        StaticText1.Font.Color := clRed;
        StaticText1.Visible := True;
        Result := True
     end
     else
         Result := False;
end;

end.


unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls,
  PrintersDlgs, Printers, ExtCtrls, ComCtrls, strutils;

type

  { TForm1 }

  TForm1 = class(TForm)
    FontDialog1: TFontDialog;
    MainMenu1: TMainMenu;
    Memo1: TMemo;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    OpenDialog1: TOpenDialog;
    PrintDialog1: TPrintDialog;
    SaveDialog1: TSaveDialog;
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure Memo1Change(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem13Click(Sender: TObject);
    procedure MenuItem14Click(Sender: TObject);
    procedure MenuItem15Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);

  private
    procedure save();
    function confirm():boolean;

  public

  end;

var
  Form1: TForm1;
  filename:string = 'Безымянный.txt';
  saved:boolean = true;
  isFile:boolean = false;
  nf:boolean = false;
  cr:boolean;
  buttonSelected:integer;
implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.MenuItem1Click(Sender: TObject);
begin

end;

procedure TForm1.MenuItem3Click(Sender: TObject);
begin

end;

// Справка
procedure TForm1.MenuItem5Click(Sender: TObject);
begin
  ShowMessage('Блокнот.' + chr(10) + 'Разработчик: Крючков И. С.');
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
     if saved = true then
        CanClose := true
     else
        begin
           buttonSelected := MessageDlg('Вы хотите сохранить изменения в файле '+StringReplace(ExtractFileName(filename),ExtractFileExt(filename),'', [])+'?', mtConfirmation, [mbYes, mbNo, mbCancel],0);
          if buttonSelected = mrYes then save();
          if buttonSelected = mrNo then CanClose := true;
          if buttonSelected = mrCancel then CanClose := false;
        end;
end;

procedure TForm1.Memo1Change(Sender: TObject);
begin
     if not nf then
     begin
       saved := false;
       Self.Caption := Concat('*',StringReplace(ExtractFileName(filename),ExtractFileExt(filename),' - Блокнот', []));
     end;
end;

// Создать
procedure TForm1.MenuItem6Click(Sender: TObject);
begin
     cr := confirm();
     if cr then
     begin
       isFile := false;
       filename := 'Безымянный.txt';
       nf := true;
       Memo1.Lines.Clear;
       saved := true;
       Self.Caption := StringReplace(ExtractFileName(filename),ExtractFileExt(filename),' - Блокнот', []);
     end;
end;

// Открыть
procedure TForm1.MenuItem8Click(Sender: TObject);
begin
   cr := confirm();
   if cr then
   begin
      if OpenDialog1.Execute then
      begin
           filename := OpenDialog1.Filename;
           Memo1.Lines.LoadFromFile(filename);
           saved := true;
           isFile := true;
           Self.Caption := StringReplace(ExtractFileName(filename),ExtractFileExt(filename),' - Блокнот', []);
      end;
    end;
end;

//Сохранение
procedure TForm1.save();
begin
     if (filename <> '') and isFile then
     begin
          Memo1.Lines.SaveToFile(filename);
     end
     else
     begin
          if SaveDialog1.Execute then
          begin
               Memo1.Lines.SaveToFile(SaveDialog1.FileName);
               filename := SaveDialog1.FileName;
          end;
     end;
     saved := true;
     isFile := true;
     Self.Caption := StringReplace(ExtractFileName(filename),ExtractFileExt(filename),' - Блокнот', []);
end;

// Сохранить
procedure TForm1.MenuItem9Click(Sender: TObject);
begin
    save();
end;

// Сохранить как
procedure TForm1.MenuItem10Click(Sender: TObject);
begin
  if SaveDialog1.Execute then
  begin
       Memo1.Lines.SaveToFile(SaveDialog1.FileName);
       saved := true;
       isFile := true;
       filename := SaveDialog1.FileName;
       Self.Caption := StringReplace(ExtractFileName(filename),ExtractFileExt(filename),' - Блокнот', []);
  end;
end;

// Выход
procedure TForm1.MenuItem11Click(Sender: TObject);
begin
     Self.Close;
end;
// Шрифт...
procedure TForm1.MenuItem13Click(Sender: TObject);
begin
     FontDialog1.Font := Memo1.Font;
     if FontDialog1.Execute then
        Self.Memo1.Font := FontDialog1.Font;
end;

procedure TForm1.MenuItem14Click(Sender: TObject);
var
  i:longint;
begin
  if PrintDialog1.Execute then
  begin
      Printer.BeginDoc;
      Printer.Canvas.Font.Name := Memo1.Font.Name;
      //Printer.Canvas.Font.Size := Memo1.Font.Size;
      Printer.Canvas.Font.Color := Memo1.Font.Color;
      for i := 0 to Memo1.Lines.Count do
          Printer.Canvas.TextOut(300, 100 + i * 100, Memo1.Lines.Strings[i]);
      Printer.EndDoc;
    end;
end;

// Статистика
procedure TForm1.MenuItem15Click(Sender: TObject);
var
  symb, words, strings, i, cnt: longint;
begin
     strings := Memo1.Lines.Count;
     symb := 0;
     words := 0;
     for i := 0 to strings - 1 do
     begin
          inc(symb, Length(Memo1.Lines.Strings[i]));
          cnt := WordCount(Memo1.Lines.Strings[i], [' ']);
          inc(words, cnt);
     end;
     ShowMessage('Количество символов: ' + IntToStr(symb) + chr(10) + 'Количество слов: ' + IntToStr(words));
end;

function TForm1.confirm():boolean;
begin
  if saved = true then
     confirm := true
  else
  begin
    buttonSelected := MessageDlg('Вы хотите сохранить изменения в файле '+StringReplace(ExtractFileName(filename),ExtractFileExt(filename),'', [])+'?', mtConfirmation, [mbYes, mbNo, mbCancel],0);
    if buttonSelected = mrYes then begin save(); confirm := true; end;
    if buttonSelected = mrNo then confirm := true;
    if buttonSelected = mrCancel then confirm := false;
  end;
end;

end.


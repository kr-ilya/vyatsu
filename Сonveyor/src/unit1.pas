unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ComCtrls, MaskEdit, Menus, gears, defSets, jsonparser,
  jsonscanner, fpjson, settings, boxs, pushers, fullness, itemsSettings, Math, Al;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Image1: TImage;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    Timer1: TTimer;
    TrackBar1: TTrackBar;
    Memo1: TMemo;
    TrackBar2: TTrackBar;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: char);
    procedure Edit2Change(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: char);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure MenuItem13Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure MoveGears;
    procedure ReDraw;
    procedure setSpeed;
    procedure changeTrack(setVal:boolean);
    procedure TrackBar1Change(Sender: TObject);
    procedure removingHolesGears;
    procedure generateGears(av:integer);
    procedure shiftGears;
    procedure removingHolesGearsIds(var arr:array of integer);
    procedure getTarget(id:integer);
    procedure stopGame;
    procedure set_initial_settings;
    procedure set_custom_settings;
    procedure TrackBar2Change(Sender: TObject);
    procedure changeLampTrack(setVal:boolean);
  private

  public

  end;

var
  Form1: TForm1;
  lenta, box, gear, pusher,boxlabel,trashbox, closedbox, lamp_off, lamp_on, lamp_status_img: TBitmap;
  gearsList: array[0..9] of TGear;
  boxsList: array[0..9] of TBox;
  pushersList: array[0..9] of TPusher;
  interval:integer = 0;
  numGears:integer = 0;
  speed:integer = 10;
  defTimerInterval:integer = 1000;
  pausa:boolean = False;
  started:boolean = False;
  lpos:boolean = False;
  shiftGear:boolean = False;
  shiftGearId, shiftBoxId:integer;
  shiftGearsIds,shiftBoxsIds, shiftPushersIds: array[0..9] of integer;
  shiftGearsIdsLength:integer = 0;
  shiftPushersidsLength:integer = 0;
  moveLenta:boolean = True;
  closedBoxs:integer = 0;
  gameEnd:boolean = False;
  al_now:boolean = False;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  Randomize;
  Image1.Canvas.Brush.Color := $808000;
  Image1.Canvas.Fillrect(Image1.Canvas.ClipRect);

  lenta := TBitmap.Create;
  lenta.LoadFromFile('img/lenta.bmp');
  Image1.Canvas.Draw(-5,200,lenta);

  box := TBitmap.Create;
  box.LoadFromFile('img/box.bmp');

  trashbox := TBitmap.Create;
  trashbox.LoadFromFile('img/trashbox.bmp');

  closedbox := TBitmap.Create;
  closedbox.LoadFromFile('img/closedbox.bmp');


  pusher := TBitmap.Create;
  pusher.LoadFromFile('img/pusher.bmp');

  lamp_on := TBitmap.Create;
  lamp_on.LoadFromFile('img/lamp_on.bmp');

  lamp_off := TBitmap.Create;
  lamp_off.LoadFromFile('img/lamp_off.bmp');

  lamp_status_img := lamp_off;

  set_initial_settings;

end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  // FreeAndNil(lamp_off);
  // FreeAndNil(lamp_off);

end;


procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var y:integer;
begin
  // FreeAndNil(Image1);
  // FreeAndNil(lamp_on);
  // FreeAndNil(pusher);
  // FreeAndNil(closedbox);
  // FreeAndNil(trashbox);
  // FreeAndNil(box);
  // FreeAndNil(lenta);
  // FreeAndNil(boxlabel);
  // FreeAndNil(gear);
  // FreeAndNil(lamp_status_img);

  // for y :=0 to 9 do
  // begin
  //   // FreeAndNil(boxsList[y].labelImg);
  //   // FreeAndNil(boxsList[y].boxImg);
  //   FreeAndNil(boxsList[y]);
  //   // FreeAndNil(pushersList[y]);
    
  // end;
  //   FreeAndNil(pushersList[0]);
  // FreeAndNil(pushersList[1]);
  // FreeAndNil(pushersList[2]);
  // FreeAndNil(pushersList[3]);
  // FreeAndNil(pushersList[4]);
  // FreeAndNil(pushersList[5]);
  // FreeAndNil(pushersList[6]);
  // FreeAndNil(pushersList[7]);
  // FreeAndNil(pushersList[8]);
  // FreeAndNil(pushersList[9]);
end;

// АЛ
procedure TForm1.MenuItem10Click(Sender: TObject);
begin
     Form5.Show;
end;

// Сброс настроек
procedure TForm1.MenuItem11Click(Sender: TObject);
begin
     clrs := defColors;
     items := defItems;
     itemsTmp := defItems;
     itemsCounts := [0,0,0,0,0,0,0,0];
     lampChance := 20;
     speed := 10;
     TrackBar1.Position := speed;
     TrackBar2.Position := lampChance;
     Timer1.Interval := defTimerInterval div speed;
     Edit1.Text := inttostr(speed);
     Edit2.Text := inttostr(lampChance);
     set_initial_settings;
end;

procedure TForm1.MenuItem12Click(Sender: TObject);
begin
  Application.MessageBox(PChar(
  'О программе:' + chr(10) +
  'Конвейер.' + chr(10) +
  'Детали 3х цветов из 6 возможных.' + chr(10) +
  'Детали 3х типов из 6 возможных.' + chr(10) +
  'Вместимость ящиков 0-5 деталей. начальное заполнение 0-4 деталей.' + chr(10) +
  'При заполнении ящика, детали попадают в ящик того же цвета, другого типа.' + chr(10) +
  'При заполнении всех ящиков определного цвета, детали этого цвета попадают в брак.' + chr(10) +
  'Аварийная лампочка генерирует деталь черного цвета, которая попадает в брак.'), PChar('О программе'), 0);
end;

procedure TForm1.MenuItem13Click(Sender: TObject);
begin
  Application.MessageBox(PChar('Разработчик: Крючков И. С.'), PChar('Об авторе'), 0);
end;

// открыть
procedure TForm1.MenuItem2Click(Sender: TObject);
var k:integer;
  settingsParser: TJSONParser;
  settingsData: TJSONObject;
  filename:string;
  strm: TFileStream;
  JsonEnum, JsonArrayEnum: TBaseJSONEnumerator;
begin

  if OpenDialog1.Execute then
  begin
    filename := OpenDialog1.Filename;
    strm := TFileStream.Create(filename, fmOpenRead or fmShareDenyWrite);
    try
      settingsParser:=TJSONParser.Create(strm);
      try
        settingsData:=settingsParser.Parse as TJSONObject;
        try
          JsonEnum := settingsData.GetEnumerator;
          try
            JsonArrayEnum:=TJSONArray(settingsData.FindPath('colors')).GetEnumerator;
            try
              k := 0;
              while JsonArrayEnum.MoveNext and (k < 3) do
              begin
                    clrs[k] := JsonArrayEnum.Current.Value.AsString;
                    Memo1.Lines.Add(JsonArrayEnum.Current.Value.AsString);
                    inc(k);
              end;

              JsonArrayEnum:=TJSONArray(settingsData.FindPath('gears')).GetEnumerator;
              k := 0;
              while JsonArrayEnum.MoveNext and (k < 3) do
              begin
                    items[k] := JsonArrayEnum.Current.Value.AsString;
                    itemsTmp[k] := JsonArrayEnum.Current.Value.AsString;
                    Memo1.Lines.Add(JsonArrayEnum.Current.Value.AsString);
                    inc(k);
              end;

              JsonArrayEnum:=TJSONArray(settingsData.FindPath('itemsCounts')).GetEnumerator;
              k := 0;
              while JsonArrayEnum.MoveNext and (k < 8) do
              begin
                    itemsCounts[k] := JsonArrayEnum.Current.Value.AsInteger;
                    Memo1.Lines.Add(JsonArrayEnum.Current.Value.AsString);
                    inc(k);
              end;

              lampChance := settingsData.Get('lampChance', 20);
              speed := settingsData.Get('speed', 10);
              TrackBar1.Position := speed;
              TrackBar2.Position := lampChance;
              Edit1.Text := inttostr(speed);
              Edit2.Text := inttostr(lampChance);

               if speed = 0 then
                   Timer1.Interval := 0
               else
                   Timer1.Interval := defTimerInterval div speed;



              Memo1.Lines.Add(inttostr(lampChance));

              set_custom_settings;

            finally
              FreeAndNil(JsonArrayEnum);
            end;

          finally
            FreeAndNil(JsonEnum);
          end;
       finally
        FreeAndNil(settingsData);
      end;

      finally
        FreeAndNil(settingsParser);
      end;

    finally
      FreeAndNil(strm);
    end;

  end;
end;

// Сохранить
procedure TForm1.MenuItem3Click(Sender: TObject);
var jsonObj: TJSONObject;
    jsonArray, jsonGearArray, jsonclrsArray: TJSONArray;
    MS:TMemoryStream;
    SS:TStringStream;
begin

  if SaveDialog1.Execute then
  begin

   jsonObj:=TJSONObject.Create(['lampChance', lampChance,
                                 'speed', speed ]);

   try
     //создаем массив
     jsonArray:=TJSONArray.Create;
     jsonArray.Add(itemsCounts[0]);
     jsonArray.Add(itemsCounts[1]);
     jsonArray.Add(itemsCounts[2]);
     jsonArray.Add(itemsCounts[3]);
     jsonArray.Add(itemsCounts[4]);
     jsonArray.Add(itemsCounts[5]);
     jsonArray.Add(itemsCounts[6]);
     jsonArray.Add(itemsCounts[7]);

     jsonGearArray:=TJSONArray.Create;
     jsonGearArray.Add(items[0]);
     jsonGearArray.Add(items[1]);
     jsonGearArray.Add(items[2]);

     jsonclrsArray:=TJSONArray.Create;
     jsonclrsArray.Add(clrs[0]);
     jsonclrsArray.Add(clrs[1]);
     jsonclrsArray.Add(clrs[2]);

     jsonObj.Add('colors',jsonclrsArray);
     jsonObj.Add('gears',jsonGearArray);
     jsonObj.Add('itemsCounts',jsonArray);

     Memo1.Lines.Add(jsonObj.AsJSON);

     SS:=TStringStream.Create('');
     SS.WriteString(jsonObj.AsJSON);
     SS.Seek(0,0);
     MS:=TMemoryStream.Create;
     MS.CopyFrom(SS,SS.Size);
     MS.SaveToFile(SaveDialog1.FileName);

     FreeAndNil(MS);
     FreeAndNil(SS);
   finally
     FreeAndNil(jsonObj)
   end;
  end;
end;

// выход (из меню)
procedure TForm1.MenuItem4Click(Sender: TObject);
begin
     self.close();
end;

// Настройки цвета
procedure TForm1.MenuItem6Click(Sender: TObject);
begin
    Form2.Show;
end;
// Заполнение ящиков
procedure TForm1.MenuItem7Click(Sender: TObject);
begin
   Form3.Show;
end;

// Детали
procedure TForm1.MenuItem9Click(Sender: TObject);
begin
  Form4.Show;
end;


// СТАРТ/СТОП
procedure TForm1.Button1Click(Sender: TObject);
begin
  StaticText2.Visible := False;

  if(gameend <> True) then
    begin
      if (started = True) then
      begin
          started := False;
          Button1.Caption := 'Старт';
          set_initial_settings;
          Timer1.Enabled := False;
          MenuItem6.Enabled := True;
          MenuItem7.Enabled := True;
          MenuItem9.Enabled := True;
          MenuItem10.Enabled := True;
          MenuItem11.Enabled := True;
          MenuItem2.Enabled := True;
          MenuItem3.Enabled := True;
          MenuItem8.Enabled := True;
          MenuItem5.Enabled := True;
          MenuItem1.Enabled := True;
      end
      else if ((started = False) and (pausa = True)) then
      begin
          Button1.Caption := 'Стоп';
          started := True;
          MenuItem6.Enabled := False;
          MenuItem7.Enabled := False;
          MenuItem9.Enabled := False;
          MenuItem10.Enabled := False;
          MenuItem2.Enabled := False;
          MenuItem3.Enabled := False;
          MenuItem11.Enabled := False;
          MenuItem8.Enabled := False;
          MenuItem5.Enabled := False;
          MenuItem1.Enabled := False;
      end
      else
      begin
          Button1.Caption := 'Стоп';
          started := True;
          Timer1.Enabled := True;
          MenuItem6.Enabled := False;
          MenuItem7.Enabled := False;
          MenuItem9.Enabled := False;
          MenuItem10.Enabled := False;
          MenuItem2.Enabled := False;
          MenuItem3.Enabled := False;
          MenuItem11.Enabled := False;
          MenuItem8.Enabled := False;
          MenuItem5.Enabled := False;
          MenuItem1.Enabled := False;
      end;
    end
  else
    begin
        Button1.Caption := 'Старт';
        MenuItem6.Enabled := True;
        MenuItem7.Enabled := True;
        MenuItem9.Enabled := True;
        MenuItem10.Enabled := True;
        MenuItem2.Enabled := True;
        MenuItem3.Enabled := True;
        MenuItem11.Enabled := True;
        MenuItem8.Enabled := True;
        MenuItem5.Enabled := True;
        MenuItem1.Enabled := True;
        set_initial_settings;
        ReDraw;
    end;

end;

// ПАУЗА/ПРОДОЛЖИТь
procedure TForm1.Button2Click(Sender: TObject);
begin
 if ((pausa = True) and (started = True)) then
 begin
    Button2.Caption := 'Пауза';
    pausa := False;
    Timer1.Enabled := True;
 end
 else if ((pausa = True) and (started = False)) then
 begin
    Button2.Caption := 'Пауза';
    pausa := False;
 end
 else if ((pausa = False) and (started = True)) then
 begin
    Button2.Caption := 'Продолжить';
    pausa := True;
    Timer1.Enabled := False;
 end
 else
 begin
    Button2.Caption := 'Продолжить';
    pausa := True;
 end;
end;

// выход (на поле)
procedure TForm1.Button3Click(Sender: TObject);
begin
  Self.Close;
end;

procedure TForm1.Edit1Change(Sender: TObject);
begin
  changeTrack(True);
end;

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: char);
begin
  // проверяем нажатую клавишу
 case Key of
  // цифры разрешаем
  '0'..'9':
    begin
       key:=key;
    end;
  // разрешаем BackSpace
  #8: key:=key;
  //Enter                        //.val
  #13: changeTrack(True);
  // все прочие клавиши "гасим"
  else
    begin
    key:=#0;
    StaticText1.Visible := True;
    end;
 end;
end;

procedure TForm1.Edit2Change(Sender: TObject);
begin
  changeLampTrack(True);
end;

procedure TForm1.Edit2KeyPress(Sender: TObject; var Key: char);
begin
// проверяем нажатую клавишу
 case Key of
  // цифры разрешаем
  '0'..'9':
    begin
       key:=key;
    end;
  // разрешаем BackSpace
  #8: begin
  key:=key;

  end;
  //Enter                        //.val
  #13: changeLampTrack(True);
  // все прочие клавиши "гасим"
  else
    begin
    key:=#0;
    StaticText5.Visible := True;
    end;
 end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  i:integer;
  shift:boolean;
  ch,maxrand:integer;
begin

 if not shiftGear then
    begin

     interval += 10;

     if interval = 120 then
     begin
       interval := 0;
       lamp_status_img := lamp_off;
       // генерируем детали
       // если сейчас очередь АЛ
       //Memo1.Lines.Add('F');
       if(al_now) then
         begin
          maxrand := 100000000;
             //ch := RandomRange(1, 101);
             ch := RandomRange(1, maxrand+1);
             //Memo1.Lines.Add(inttostr(ch));
             // лампочка зажглась
             if (ch <= round((lampChance/100)*maxrand)) then
               begin
                   lamp_status_img := lamp_on;
                    generateGears(1);
                    al_now := False;
               end
             else
                generateGears(0);



         end
       else
         begin
             generateGears(0);
             al_now := True;
         end;
     end;

     MoveGears;
     shiftGears;
     end
 else
     begin

         for i := 0 to 9 do
         begin
            shift := False;
            if(shiftPushersIds[i] <> -1) then
            begin
              if(pushersList[shiftPushersIds[i]].active = True) then
                  begin
                      pushersList[shiftPushersIds[i]].moveYPlus;
                      if(pushersList[shiftPushersIds[i]].getY>=120) then
                         shift := True;
                  end
              else
                  begin
                      pushersList[shiftPushersIds[i]].moveYMinus;
                      if(pushersList[shiftPushersIds[i]].getY <= 80) then
                      begin
                           dec(shiftPushersidsLength);
                           pushersList[shiftPushersIds[i]].active := True;
                           shiftPushersIds[i] := -1;
                      end;
                  end;

              if((shiftGearsIds[i] <> -1) and (shift = True)) then
              begin

                  gearsList[shiftGearsIds[i]].moveY;
                  if(gearsList[shiftGearsIds[i]].getY >= 300) then
                  begin
                       pushersList[shiftPushersIds[i]].active := False;

                       inc(boxsList[shiftBoxsIds[i]].itemsCount);

                       if(boxsList[shiftBoxsIds[i]].itemsCount = boxsList[shiftBoxsIds[i]].limit) then
                       begin
                            boxsList[shiftBoxsIds[i]].boxImg := closedbox;
                            inc(closedBoxs);
                       end;

                       //gearsList[shiftGearsIds[i]] := nil;
                       FreeAndNil(gearsList[shiftGearsIds[i]]);

                       shiftGearsIds[i] := -1;
                       shiftBoxsIds[i] := -1;
                       dec(shiftGearsIdsLength);
                       dec(numGears);
                  end;
              end;
              if((shiftGearsIdsLength = 0) and (shiftPushersidsLength = 0)) then
               begin
                   shiftGear := False;
                   removingHolesGearsIds(shiftGearsIds);
                   removingHolesGearsIds(shiftBoxsIds);
                   removingHolesGearsIds(shiftPushersIds);
                   removingHolesGears();
                   if(closedBoxs = 9) then
                    begin
                         stopGame;
                    end;
                   moveLenta := True;
               end;
            end;
         end;

     end;

     ReDraw;
end;


procedure TForm1.MoveGears;
var i: integer;
begin
     for i := 0 to 9 do
     begin
       if(gearsList[i] <> nil) then
         gearsList[i].move;
     end;
end;

procedure TForm1.ReDraw;
var i:integer;
begin
  Image1.Canvas.Brush.Color := $808000;
  Image1.Canvas.Fillrect(Image1.Canvas.ClipRect);


  if lpos then
    begin
         Image1.Canvas.Draw(0,200,lenta);
         if moveLenta then
            lpos := False;
    end
  else
    begin
         Image1.Canvas.Draw(-5,200,lenta);
         if moveLenta then
            lpos := True;
    end;

  for i := 0 to 9 do
  begin
    Image1.Canvas.Draw(boxsList[i].getX, boxsList[i].getY, boxsList[i].boxImg);
    if (boxsList[i].boxVal = 1) then
       Image1.Canvas.TextOut(20+i*120+72,450, inttostr(boxsList[i].itemsCount)+'/'+inttostr(boxsList[i].limit))
    else
       Image1.Canvas.TextOut(20+i*120+72,450, inttostr(boxsList[i].itemsCount));
    if(boxsList[i].boxType <> 'trash') then
        Image1.Canvas.Draw(20+i*120+50,390,boxsList[i].labelImg);

    Image1.Canvas.Draw(pushersList[i].getX,pushersList[i].getY,pusher);

    if gearsList[i] <> nil then
       Image1.Canvas.Draw(gearsList[i].getX,gearsList[i].getY,gearsList[i].img);
  end;

  Image1.Canvas.Draw(200, 480,lamp_status_img);
  //Image1.Canvas.TextOut(240,650, inttostr(lampChance)+'%');
end;

procedure TForm1.TrackBar1Change(Sender: TObject);
begin
  Edit1.Text := IntToStr(TrackBar1.Position);
  speed := TrackBar1.Position;
  if speed = 0 then
      Timer1.Interval := 0
  else
      Timer1.Interval := defTimerInterval div speed;
end;

procedure TForm1.changeTrack(setVal:boolean);
var sp:integer;
begin
 StaticText1.Visible := False;
 if ((Edit1.Text <> '') and not ( (length(Edit1.Text) > 1) and (Edit1.Text[1] = '0'))) then
  begin
    if StrToInt(Edit1.Text) > 100 then
      Edit1.Text := '100';

    sp := StrToInt(Edit1.Text);

    if ((sp >= 0) and (sp <= 100)) then
    begin
         if(setVal) then
         begin
           speed := sp;
           TrackBar1.Position := sp;
           StaticText1.Visible := False;
           if speed = 0 then
               Timer1.Interval := 0
           else
               Timer1.Interval := defTimerInterval div speed;

         end;
    end
    else
    begin
         StaticText1.Visible := True;
    end;

  end
  else
  begin
  Edit1.Text := '0';
  StaticText1.Visible := True;
  end;
end;




procedure TForm1.setSpeed;
begin
   if speed = 0 then
    Timer1.Interval := 0;

end;

procedure TForm1.removingHolesGears();
var
  i,l:integer;
  j:integer = -1;
begin
    l := length(gearsList);

    i:= 0;
    while i < l do
    begin
        if(gearsList[i] = nil) then
        begin
            if j = -1 then
                j := i;
            inc(i)
        end
        else
        begin
            if j <> -1 then
            begin
                gearsList[j] := gearsList[i];
                gearsList[i] := nil;
                inc(j)
            end
            else
            inc(i)
        end;
    end;
end;

procedure TForm1.removingHolesGearsIds(var arr:array of integer);
var
  i,l:integer;
  j:integer = -1;
begin
    l := length(arr);

    i:= 0;
    while i < l do
    begin
        if(arr[i] = -1) then
        begin
            if j = -1 then
                j := i;
            inc(i)
        end
        else
        begin
            if j <> -1 then
            begin
                arr[j] := arr[i];
                arr[i] := -1;
                inc(j)
            end
            else
            inc(i)
        end;
    end;
end;

procedure TForm1.generateGears(av:integer);
begin
     gearsList[numGears] := TGear.Create(0, 230, av);
     if av = 0 then
        getTarget(numGears);
     inc(numGears);
end;


procedure TForm1.shiftGears;
var
  i, j:integer;
begin
     for i := 0 to numGears-1 do
     begin
       for j := 0 to 9 do
       begin

         if((gearsList[i].getX = boxsList[j].getX) and (gearsList[i].target = boxsList[j].boxType)) then
         begin

              shiftGearsIds[shiftGearsIdsLength] := i;
              shiftBoxsIds[shiftGearsIdsLength] := j;
              shiftPushersIds[shiftGearsIdsLength] := j;
              inc(shiftGearsIdsLength);
              inc(shiftPushersidsLength);
              shiftGear := True;
              moveLenta := False;
         end;

       end;
     end;
end;

procedure TForm1.getTarget(id:integer);
var
  bid,totar:integer;
begin
     totar := 0;
     if((boxsList[0].boxType = gearsList[id].gearType) and (boxsList[0].hiddenItemsCount < boxsList[0].limit)) then
       begin
            totar := 1;
            bid := 0;

       end;
     if ((totar = 0) and (gearsList[id].color = boxsList[0].color) and (boxsList[0].hiddenItemsCount < boxsList[0].limit)) then
       begin
            totar := 2;
            bid := 0;

       end;

     if((boxsList[1].boxType = gearsList[id].gearType) and (boxsList[1].hiddenItemsCount < boxsList[1].limit)) then
       begin
            totar := 1;
            bid := 1;

       end;
     if ((totar = 0) and (gearsList[id].color = boxsList[1].color) and (boxsList[1].hiddenItemsCount < boxsList[1].limit)) then
       begin
            totar := 2;
            bid := 1;

       end;

     if((boxsList[2].boxType = gearsList[id].gearType) and (boxsList[2].hiddenItemsCount < boxsList[2].limit)) then
       begin
            totar := 1;
            bid := 2;

       end;
     if ((totar = 0) and (gearsList[id].color = boxsList[2].color) and (boxsList[2].hiddenItemsCount < boxsList[2].limit)) then
       begin
            totar := 2;
            bid := 2;

       end;

     if((boxsList[3].boxType = gearsList[id].gearType) and (boxsList[3].hiddenItemsCount < boxsList[3].limit)) then
       begin
            totar := 1;
            bid := 3;
       end;
     if ((totar = 0) and (gearsList[id].color = boxsList[3].color) and (boxsList[3].hiddenItemsCount < boxsList[3].limit)) then
       begin
            totar := 2;
            bid := 3;

       end;

     if((boxsList[4].boxType = gearsList[id].gearType) and (boxsList[4].hiddenItemsCount < boxsList[4].limit)) then
       begin
            totar := 1;
            bid := 4;

       end;
     if ((totar = 0) and (gearsList[id].color = boxsList[4].color) and (boxsList[4].hiddenItemsCount < boxsList[4].limit)) then
       begin
            totar := 2;
            bid := 4;
       end;

    if((boxsList[5].boxType = gearsList[id].gearType) and (boxsList[5].hiddenItemsCount < boxsList[5].limit)) then
       begin
            totar := 1;
            bid := 5;

       end;
     if ((totar = 0) and (gearsList[id].color = boxsList[5].color) and (boxsList[5].hiddenItemsCount < boxsList[5].limit)) then
       begin
            totar := 2;
            bid := 5;

       end;

     if((boxsList[6].boxType = gearsList[id].gearType) and (boxsList[6].hiddenItemsCount < boxsList[6].limit)) then
       begin
            totar := 1;
            bid := 6;

       end;
     if ((totar = 0) and (gearsList[id].color = boxsList[6].color) and (boxsList[6].hiddenItemsCount < boxsList[6].limit)) then
       begin
            totar := 2;
            bid := 6;

       end;
     if((boxsList[7].boxType = gearsList[id].gearType) and (boxsList[7].hiddenItemsCount < boxsList[7].limit)) then
       begin
            totar := 1;
            bid := 7;
       end;
    if ((totar = 0) and (gearsList[id].color = boxsList[7].color) and (boxsList[7].hiddenItemsCount < boxsList[7].limit)) then
       begin
            totar := 2;
            bid := 7;

       end;
    if((boxsList[8].boxType = gearsList[id].gearType) and (boxsList[8].hiddenItemsCount < boxsList[8].limit)) then
       begin
            totar := 1;
            bid := 8;
       end;
    if ((totar = 0) and (gearsList[id].color = boxsList[8].color) and (boxsList[8].hiddenItemsCount < boxsList[8].limit)) then
       begin
            totar := 2;
            bid := 8;

       end;
     if((boxsList[9].boxType = gearsList[id].gearType) and (boxsList[9].hiddenItemsCount < boxsList[9].limit)) then
       begin
            totar := 1;
            bid := 9;
            
       end;
    if ((totar = 0) and (gearsList[id].color = boxsList[9].color) and (boxsList[9].hiddenItemsCount < boxsList[9].limit)) then
       begin
            bid := 9;
            totar := 2;
       end;
    if (totar = 0) then
       begin
           gearsList[id].target := 'trash';
           bid := 10;
       end;

     if bid <> 10 then
     begin
         gearsList[id].target := boxsList[bid].boxType;
         inc(boxsList[bid].hiddenItemsCount);
     end;
end;


procedure TForm1.stopGame;
begin
     Timer1.Enabled := False;
     StaticText2.Visible := True;
     gameEnd := True;
     started := False;
end;


procedure TForm1.set_initial_settings;
var
  i, j, ij, itco:integer;
  cl, it: string;

begin
  // for y :=0 to 9 do
  // begin
  //   FreeAndNil(boxsList[y]);
  //   FreeAndNil(pushersList[y]);
  // end;
  
  interval := 0;
  numGears := 0;
  shiftGearsIdsLength := 0;
  shiftPushersidsLength := 0;
  moveLenta := True;
  closedBoxs := 0;
  shiftGear := False;
  shiftGearsIdsLength := 0;
  shiftPushersidsLength := 0;
  closedBoxs := 0;
  gameEnd := False;
  al_now := False;

  lamp_status_img := lamp_off;

  ij := 0;
  for i := 0 to 2 do
  begin
    for j := 0 to 2 do
    begin
        cl := clrs[i];
        it := items[j];
        itco := itemsCounts[ij];
        boxlabel := TBitmap.Create;
        boxlabel.LoadFromFile('img/'+it+'_'+cl+'.bmp');

        boxsList[ij] := TBox.Create(ij*90+30*ij + 50, 350,boxlabel, box, it+'_'+cl, itco, 1, 5, it, cl);
        //FreeAndNil(boxlabel);
        inc(ij);
    end;
  end;
  
  
  boxsList[9] := TBox.Create(9*90+30*9 + 50, 350,nil, trashbox, 'trash', 0, 2, 0, '-', '-');
  
  for j := 0 to 9 do
  begin
     gearsList[j] := nil;
     shiftGearsIds[j] := -1;
     shiftBoxsIds[j] := -1;
     shiftPushersIds[j] := -1;
  end;
  
  for i := 0 to 9 do
  begin
    pushersList[i] := TPusher.Create(10 + i*90+30*i+50, 80);

     Image1.Canvas.Draw(pushersList[i].getX,pushersList[i].getY,pusher);

     Image1.Canvas.Draw(boxsList[i].getX, boxsList[i].getY, boxsList[i].boxImg);
      if(boxsList[i].boxType <> 'trash') then
          Image1.Canvas.Draw(20+i*120+50,390,boxsList[i].labelImg);

    if (boxsList[i].boxVal = 1) then
       Image1.Canvas.TextOut(20+i*120+72,450, inttostr(boxsList[i].itemsCount)+'/'+inttostr(boxsList[i].limit))
    else
       Image1.Canvas.TextOut(20+i*120+72,450, inttostr(boxsList[i].itemsCount))
  end;

  ReDraw;

end;


procedure TForm1.set_custom_settings;
var
  i, j, ij, itco:integer;
  cl, it: string;

begin
  ij := 0;
  for i := 0 to 2 do
  begin
    for j := 0 to 2 do
    begin
        cl := clrs[i];
        it := items[j];
        itco := itemsCounts[ij];
        boxlabel := TBitmap.Create;
        boxlabel.LoadFromFile('img/'+it+'_'+cl+'.bmp');

        boxsList[ij].labelImg := boxlabel;
        boxsList[ij].boxType :=  it+'_'+cl;
        boxsList[ij].btt := it;
        boxsList[ij].color := cl;
        boxsList[ij].itemsCount := itco;
        boxsList[ij].hiddenItemsCount := itco;

        inc(ij);
    end;
  end;

  ReDraw;

end;

procedure TForm1.TrackBar2Change(Sender: TObject);
begin
     Edit2.Text := IntToStr(TrackBar2.Position);
     lampChance := TrackBar2.Position;
end;

procedure TForm1.changeLampTrack(setVal:boolean);
var lc:integer;
begin
 StaticText5.Visible := False;
 if ((Edit2.Text <> '') and not ( (length(Edit2.Text) > 1) and (Edit2.Text[1] = '0'))) then
  begin

   if strtoint(Edit2.Text) > 100 then
    Edit2.Text := '100';
    lc := StrToInt(Edit2.Text);

    if ((lc >= 0) and (lc <= 100)) then
    begin
         if(setVal) then
         begin
           lampChance := lc;
           TrackBar2.Position := lc;
           StaticText5.Visible := False;
         end;
    end
    else
    begin
         StaticText5.Visible := True;
    end;

  end
  else
  begin
  Edit2.Text := '0';
  StaticText5.Visible := True;
  end;
end;


end.


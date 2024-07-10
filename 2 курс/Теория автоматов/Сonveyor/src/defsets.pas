unit defSets;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;


var
  allColors:array of string = ('red', 'green', 'yellow', 'purple', 'blue', 'aqua');
  allItems:array of string = ('hammer', 'wrench', 'gear', 'pencil', 'pliers', 'saw');
  defColors:array of string = ('red', 'green', 'blue');
  defItems:array of string = ('hammer', 'wrench', 'gear');
  clrs:array of string = ('red', 'green', 'blue');
  items:array of string = ('hammer', 'wrench', 'gear');
  itemsTmp:array of string = ('hammer', 'wrench', 'gear');
  itemsCounts:array of integer = (0,0,0,0,0,0,0,0,0);
  lampChance:integer = 20;

implementation

end.


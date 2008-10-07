unit UsrFilesList;

interface

uses
  SysUtils, Classes, Masks, Math;

type
  TFileInfo = class
    Size       : integer;
    Name       : string;
    Modified   : TDateTime;
  end;

  TSortMode = (smName, smPath, smSize, smDate);

  TListFichier = class(TList)
  private
    function GetItem( i : integer) : TFileInfo;
    procedure SetItem( i : integer; item : TFileInfo);
  public
    Destructor Destroy; override;
    procedure Clear;override;
    procedure Delete(Index: Integer);
    procedure Remove(aFileName : TFileName);
    procedure BuildFromPath(StartPath : TFileName; FileExt : string; SubFolder : boolean);
    procedure SortBy(Mode : TSortMode; Ascending : boolean);
    function Add(Item: TFileInfo): Integer;reintroduce;
    property items[Index: Integer] : TFileInfo read GetItem write SetItem;default;
  end;



implementation

{ TListFichier }

destructor TListFichier.Destroy;
begin
  Clear;
  inherited;
end;



function TListFichier.Add(Item: TFileInfo): Integer;
begin
  result := inherited add(Item);
end;



procedure TListFichier.Clear;
var
  i : integer;
begin
  for i := 0 to Count - 1 do
    if items[ i ] <> nil then
      Items[i].Free;

  inherited;
end;


function TListFichier.GetItem(i: integer): TFileInfo;
begin
  result := TFileInfo(inherited Get(i));
end;



procedure TListFichier.SetItem(i: integer; item: TFileInfo);
begin
  inherited Put(i, Item);
end;



procedure TListFichier.BuildFromPath(StartPath : TFileName; FileExt : string; SubFolder : boolean);
var
  SearchRec : TSearchRec;
  Res : integer;
  aFileInfo : TFileInfo;
  aMask : TMask;
begin
  aMask := TMask.Create(FileExt);

    Res := FindFirst(IncludeTrailingPathDelimiter(StartPath) + '*.*', FaAnyFile or FaDirectory, SearchRec);

    While Res = 0 do begin
      If (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
        if ((SearchRec.Attr And FaDirectory) = FaDirectory) and SubFolder Then
          BuildFromPath( IncludeTrailingPathDelimiter(StartPath) + SearchRec.Name, '*.*', SubFolder)
        else
          if aMask.Matches(SearchRec.Name) then begin
            aFileInfo := TFileInfo.Create;
            aFileInfo.Name := IncludeTrailingPathDelimiter(StartPath) + SearchRec.Name;
            aFileInfo.Size := SearchRec.Size;
            aFileInfo.Modified := FileDateToDateTime(SearchRec.Time);
            Add(aFileInfo);
          end;

      Res := FindNext(SearchRec)
    end;

  FindClose(SearchRec);
  aMask.Free;
end;



procedure TListFichier.Delete(Index: Integer);
begin
  if items[ Index ] <> nil then
    items[ Index ].Free;
  inherited;
end;



procedure TListFichier.Remove(aFileName: TFileName);
var
  i : integer;
begin
  for i := 0 to Count - 1 do
    if Items[i].Name = aFileName then begin
      Delete(i);
      Break;
    end;
end;



{>0 (positive)	Item1 est inférieur à Item2.
0	Item1 est égal à Item2.
<0 (negative)	Item1 est supérieur à Item2.}

function SizeAsc(Item1, Item2: Pointer): Integer;
begin
  Result := TFileInfo(Item2).Size - TFileInfo(Item1).Size;
end;


function SizeDesc(Item1, Item2: Pointer): Integer;
begin
  Result := -SizeAsc(Item1, Item2);
end;


function DateAsc(Item1, Item2: Pointer): Integer;
begin
  if TFileInfo(Item1).Modified < TFileInfo(Item2).Modified then
    Result := 1
  else
    if TFileInfo(Item1).Modified > TFileInfo(Item2).Modified then
      Result := -1
    else
      Result := 0;
end;


function DateDesc(Item1, Item2: Pointer): Integer;
begin
  Result := -DateAsc(Item1, Item2);
end;


function NameAsc(Item1, Item2: Pointer): Integer;
begin
  Result := CompareText(ExtractFileName(TFileInfo(Item1).Name), ExtractFileName(TFileInfo(Item2).Name));
end;

function NameDesc(Item1, Item2: Pointer): Integer;
begin
  Result := - NameAsc(Item1, Item2);
end;



function PathAsc(Item1, Item2: Pointer): Integer;
begin
  Result := CompareText(TFileInfo(Item1).Name, TFileInfo(Item2).Name);
end;

function PathDesc(Item1, Item2: Pointer): Integer;
begin
  Result := - PathAsc(Item1, Item2);
end;


procedure TListFichier.SortBy(Mode : TSortMode; Ascending : boolean);
begin
  Case Mode of
    smName:
      if Ascending then
        Sort(NameAsc)
      else
        Sort(NameDesc);

    smPath :
      if Ascending then
        Sort(PathAsc)
      else
        Sort(PathDesc);
        
    smSize :
      if Ascending then
        Sort(SizeAsc)
      else
        Sort(SizeDesc);

    smDate :
      if Ascending then
        Sort(DateAsc)
      else
        Sort(DateDesc);
  end;
end;
end.



{ Under GNU License
 check http://www.opensource.org/
 project by
 Nicolas Camil
 http://n.camil.chez.tiscali.fr
------------------------------

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Library General Public
License as published by the Free Software Foundation.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Library General Public License for more details.}

unit ProfilesMngr_fm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, PngSpeedButton, ComCtrls,
  IniFiles, UsrFilesList, ImgList, PngImageList, Menus, DKLang, TIRTypes;

type
  TOnProfile = procedure (Sender: TObject; aINI : TIniFile) of object;
  TProgram = class (TObject)
  private
    FID: string;
    FName: string;
  public
    property ID: string read FID write FID;
    property Name: string read FName write FName;
  end;
  
  TListPrograms = class (TList)
  private
    function GetItems(AIndex: Integer): TProgram;
    procedure SetItems(AIndex: Integer; AItem: TProgram);
  public
    destructor Destroy; override;
    function Add(ProgramID: string): Integer; overload;
    function Add(AItem: TProgram): Integer; overload;
    procedure Clear; override;
    procedure Erase(Index : integer);
    function IndexOf(aProgramID: string): Integer; overload;
    function IndexOf(AItem: TProgram): Integer; overload;
    procedure Update(aNode : TTreenode);
    property Items[AIndex: Integer]: TProgram read GetItems write SetItems; default;
  end;
  
  TIniProfile = class (TObject)
  private
    FFilename: string;
    FName: string;
    Programs: TListPrograms;
    procedure SetFilename(const Value: string);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Update(aNode : TTreenodes);
    property Filename: string read FFilename write SetFilename;
    property Name: string read FName;
  end;
  
  TListIniProfiles = class (TList)
  private
    function GetItems(AIndex: Integer): TIniProfile;
    procedure SetItems(AIndex: Integer; AItem: TIniProfile);
  public
    destructor Destroy; override;
    function Add(AItem: TIniProfile): Integer;
    procedure Clear; override;
    function IndexOf(ProfileName: string): Integer;
    procedure LoadFromDir(aProfilePath : TFilename);
    procedure LoadFromFile(aIni : TIniFile);
    procedure SaveToFile(aIni : TIniFile);
    procedure Update(aNode : TTreenodes);
    property Items[AIndex: Integer]: TIniProfile read GetItems write SetItems; default;
  end;

  TProfilesMngr = class (TForm)
    Add1: TMenuItem;
    butRefreshProfileList: TPngSpeedButton;
    butNewProfile: TPngSpeedButton;
    butSaveProfile: TPngSpeedButton;
    Delete1: TMenuItem;
    imlistPopProfile: TPngImageList;
    PopProfile: TPopupMenu;
    Rename1: TMenuItem;
    TreeView: TTreeView;
    DKLanguageController1: TDKLanguageController;
    Saveas1: TMenuItem;
    procedure Add1Click(Sender: TObject);
    procedure butSaveAsProfileClick(Sender: TObject);
    procedure butSaveProfileClick(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure Rename1Click(Sender: TObject);
    procedure TreeViewChange(Sender: TObject; Node: TTreeNode);
    procedure TreeViewChanging(Sender: TObject; Node: TTreeNode; var AllowChange: Boolean);
    procedure TreeViewCompare(Sender: TObject; Node1, Node2: TTreeNode; Data: Integer; var Compare: Integer);
    procedure TreeViewDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure TreeViewDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure TreeViewMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure TreeViewMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure TreeViewStartDrag(Sender: TObject; var DragObject: TDragObject);

  private
    FOnDefaultRequired: TOnProfile;
    FOnProfileSelected: TOnProfile;
    FOnSaveProfile: TOnProfile;
    FOnProfileRenamed: TOnProfile;
    FProfileIni: TFilename;
    FreeTrackIni: TFilename;
    ProgramsIni: TFilename;
    FProfileIsDirty: Boolean;
    LoadingProfiles: Boolean;
    ListProfiles: TListIniProfiles;
    NodeOrigin: TTreeNode;
    OnProgramID: UINT;
    FAutoLoad: Boolean;
    FAutoSave: Boolean;
    FAutoLoadingProfile : Boolean;
    procedure AddProfileToTreeview(aProfileName : string);
    procedure EvDefaultRequired(aINI : TFileName);
    procedure EvProfileSelected(aINI : TFileName);
    procedure SetProfileIsDirty(Value: Boolean);
  public
    constructor Create(AOWner : TComponent); override;
    destructor Destroy; override;
    procedure LoadFromFile(aIni : TIniFile; aProfilePath : TFilename; lastProfile : String);
    procedure SaveToFile(aIni : TIniFile);
    procedure SelectProgramID(aProgramID : string);
    procedure SelectProgramName(aProgramName : string);
    procedure SetProgramsList(aFile : TFilename);
    procedure butNewProfileClick(aProfilePath : TFilename);
    property ProfileIsDirty: Boolean read FProfileIsDirty write SetProfileIsDirty;
    function AutoLoadProfile(programID : integer; programName : String) : Boolean;
    property AutoLoad: Boolean read FAutoLoad write FAutoLoad;
    property AutoSave: Boolean read FAutoSave write FAutoSave;
    property AutoLoadingPRofile: Boolean read FAutoLoadingProfile write FAutoLoadingProfile;
  published
    property OnDefaultRequired: TOnProfile read FOnDefaultRequired write FOnDefaultRequired;
    property OnProfileSelected: TOnProfile read FOnProfileSelected write FOnProfileSelected;
    property OnSaveProfile: TOnProfile read FOnSaveProfile write FOnSaveProfile;
    property OnProfileRenamed: TOnProfile read FOnProfileRenamed write FOnProfileRenamed;
  end;
  
var
  ProfilesMngr: TProfilesMngr;
  ProgramsList: TStrings;

implementation

//uses TirTypes;

const
  PROGRAMS = 'Programs';
  DEFAULT = 'Default';
  FSX = 'FSX';
  PROFILE_EXT = 'ftp';
  DOT_PROFILE_EXT = '.ftp';

{$R *.dfm}

function SortProfile(Item1, Item2: Pointer): Integer;
begin
  //Set Node "Default" always to the top
  if (TObject(Item1) is TIniProfile) and (TIniProfile(Item1).Name = DEFAULT) then
    Result := -1
  else
    if (TObject(Item2) is TIniProfile) and (TIniProfile(Item2).Name = DEFAULT) then
      Result := 1
    else
      Result := CompareText(TIniProfile(Item2).Name, TIniProfile(Item2).Name);
end;

{
********************************************************* TListIniProfiles *********************************************************
}
{-


}
destructor TListIniProfiles.Destroy;
begin
  Clear;
  inherited Destroy;
end;

{-


}
function TListIniProfiles.Add(AItem: TIniProfile): Integer;
begin
  Result := inherited Add(Pointer(AItem));
end;

{-


}
procedure TListIniProfiles.Clear;
var
  I: Integer;
begin
  for I := Count - 1 downto 0 do begin
      Items[I].Free;
      Delete(I);
  end;
  
  inherited Clear;
end;

{-


}
function TListIniProfiles.GetItems(AIndex: Integer): TIniProfile;
begin
  Result := TIniProfile(inherited Items[AIndex]);
end;

{-


}
function TListIniProfiles.IndexOf(ProfileName: string): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Count - 1 do
    if CompareText(Items[i].Name, ProfileName) = 0 then begin
      Result := i;
      Break;
    end;
end;

{-


}
procedure TListIniProfiles.LoadFromDir(aProfilePath : TFilename);
var
  i: Integer;
  aProfile: TIniProfile;
  Files: TListFichier;
begin
  Files := TListFichier.Create;
  Files.BuildFromPath(aProfilePath, '*' + DOT_PROFILE_EXT, False);

  for i := 0 to Files.Count - 1 do begin
    aProfile := TIniProfile.Create;
    aProfile.Filename := Files[i].Name;
    Add(aProfile);
  end;

  if Files.Count > 1 then
    Sort(SortProfile);
  Files.Free;
end;


{-


}
procedure TListIniProfiles.LoadFromFile(aIni : TIniFile);
var
  i, idx: Integer;
  aList: TStringList;
begin
  aList := TStringList.Create;
  aIni.ReadSectionValues(ProgramS, aList);

  for i := 0 to aList.Count - 1 do begin
    idx := IndexOf(aList.ValueFromIndex[i]);
    if idx > -1 then
      Items[idx].Programs.Add( aList.Names[i])
    else
      Items[0].Programs.Add( aList.Names[i]);
  end;
  
  aList.Free;

  //Add all unassigned Programs to Default profile
  for i := 0 to ProgramsList.Count - 1 do
    if not Assigned(ProgramsList.Objects[i]) then
      Items[0].Programs.Add( ProgramsList.Names[i]);
end;

{-


}
procedure TListIniProfiles.SaveToFile(aIni : TIniFile);
var
  i, j: Integer;
begin
  aIni.EraseSection(ProgramS);
  for i := 0 to Count - 1 do
    for j := 0 to Items[i].Programs.Count - 1 do
      aIni.WriteString(ProgramS, Items[i].Programs[j].ID , Items[i].Name);
end;

{-


}
procedure TListIniProfiles.SetItems(AIndex: Integer; AItem: TIniProfile);
begin
  inherited Items[AIndex] := Pointer(AItem);
end;

{-


}
procedure TListIniProfiles.Update(aNode : TTreenodes);
var
  i: Integer;
begin
  aNode.Clear;
  for i := 0 to Count - 1 do
    Items[i].Update(aNode);
end;



{
************************************************************ TListPrograms ************************************************************
}
{-


}
destructor TListPrograms.Destroy;
begin
  Clear;
  inherited Destroy;
end;

{-


}
function TListPrograms.Add(ProgramID: string): Integer;
var
  aProgram: TProgram;
begin
  if ProgramsList.IndexOfName(ProgramID) > -1 then begin
    aProgram := TProgram.Create;
    aProgram.ID := ProgramID;
    aProgram.Name := ProgramsList.Values[ProgramID];
    ProgramsList.Objects[ProgramsList.IndexOfName(ProgramID)] := TObject(1);  //Flag items as used
    Result := Add(aProgram);
  end else
    Result := -1;
end;

{-


}
function TListPrograms.Add(AItem: TProgram): Integer;
begin
  Result := inherited Add(Pointer(AItem));
end;

{-


}
procedure TListPrograms.Clear;
var
  I: Integer;
begin
  for I := Count - 1 downto 0 do
      Delete(I);
  
  inherited Clear;
end;

{-


}
procedure TListPrograms.Erase(Index : integer);
begin
  Items[Index].Free;
  inherited Delete(Index);
end;

{-


}
function TListPrograms.GetItems(AIndex: Integer): TProgram;
begin
  Result := TProgram(inherited Items[AIndex]);
end;

{-


}
function TListPrograms.IndexOf(aProgramID: string): Integer;
var
  i: Integer;
begin
  Result := -1;
  
  for i := 0 to Count - 1 do
    if Items[i].FID = aProgramID then begin
      Result := i;
      Break;
    end;
end;

{-


}
function TListPrograms.IndexOf(AItem: TProgram): Integer;
begin
  Result := inherited IndexOf(Pointer(AItem));
end;

{-


}
procedure TListPrograms.SetItems(AIndex: Integer; AItem: TProgram);
begin
  inherited Items[AIndex] := Pointer(AItem);
end;

{-


}
procedure TListPrograms.Update(aNode : TTreenode);
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    aNode.Owner.AddChildObject(aNode, Items[i].Name, Items[i]);
end;


{
*********************************************************** TIniProfile ************************************************************
}
{-


}
constructor TIniProfile.Create;
begin
  Programs := TListPrograms.Create;
end;

{-


}
destructor TIniProfile.Destroy;
begin
  Programs.Free;
end;

{-


}
procedure TIniProfile.SetFilename(const Value: string);
begin
  FFilename := Value;
  FName := ChangeFileExt(ExtractFileName(FFilename), '');
end;

{-


}
procedure TIniProfile.Update(aNode : TTreenodes);
var
  NewNode: TTreenode;
begin
  NewNode := aNode.AddObject(nil, Name, Self);

  Programs.Update(NewNode);
end;


{
********************************************************** TProfilesMngr ***********************************************************
}
{-


}
constructor TProfilesMngr.Create(AOWner : TComponent);
begin
  inherited;
  ListProfiles := TListIniProfiles.Create;
  ProgramsList := TStringList.Create;
  OnProgramID := RegisterWindowMessage(FT_PROGRAMID);
end;

{-


}
destructor TProfilesMngr.Destroy;
begin
  FreeAndNil(ListProfiles);
  FreeAndNil(ProgramsList);
  inherited;
end;

{-


}
procedure TProfilesMngr.Add1Click(Sender: TObject);
var
  i: Integer;
  openDialog: TopenDialog;
begin
  openDialog := TopenDialog.Create(self);
  
  openDialog.Filter := DKLangConstW('S_DIALOG_PROFILE_FILTER');
  openDialog.Title := DKLangConstW('S_DIALOG_PROFILE_TITLE');
  openDialog.DefaultExt := PROFILE_EXT;
  openDialog.FilterIndex := 1;
  openDialog.Options := [ofAllowMultiSelect, ofFileMustExist];

  if openDialog.Execute then begin
    for i := 0 to openDialog.Files.Count - 1 do begin
      if Movefile(PChar(openDialog.Files[i]), PChar(IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'Profiles\' + ExtractFilename(openDialog.Files[i]))) = False then
        MessageDlg(DKLangConstW('S_ERROR_MOVING_FILE'), mtError, [mbOK], 0)
      else
        AddProfileToTreeview(openDialog.Files[i]);
    end;

    openDialog.Free;
  end;
end;

{-


}
procedure TProfilesMngr.AddProfileToTreeview(aProfileName : string);
var
  NewProfile: TIniProfile;
begin
  //update ListProfiles
  NewProfile:= TIniProfile.Create;
  NewProfile.Filename := aProfileName;
  ListProfiles.Add(NewProfile);
  
  //update treeview
  TreeView.Items.AddChildObject(nil, NewProfile.Name, NewProfile);
  TreeView.AlphaSort(True);
end;

{-


}
procedure TProfilesMngr.butSaveAsProfileClick(Sender: TObject);
var
  SaveFilename: string;
  aIni: TIniFile;
begin
  SaveFilename := ChangeFileExt(ExtractFileName( FProfileIni), '');
  if InputQuery(DKLangConstW('S_SAVEAS'), DKLangConstW('S_FILENAME'), SaveFilename) then begin

    if TObject(TreeView.Selected.Data) is TIniProfile then
      SaveFilename := IncludeTrailingPathDelimiter( ExtractFilePath(TIniProfile(TreeView.Selected.Data).Filename)) + SaveFilename + DOT_PROFILE_EXT
    else
      SaveFilename := IncludeTrailingPathDelimiter( ExtractFilePath(TIniProfile(TreeView.Selected.Parent.Data).Filename)) + SaveFilename + DOT_PROFILE_EXT;

    if not FileExists(SaveFilename) and Assigned(FOnSaveProfile) then begin
      aIni := TIniFile.Create(SaveFilename);
      try
        FOnSaveProfile(Self, aIni);
      finally
        aIni.Free
      end;
      AddProfileToTreeview(SaveFilename);
    end else
      MessageDlg(DKLangConstW('S_ERROR_PROFILE_ALREADY_EXISTS'), mtError, [mbOK], 0)
  end;
end;

{-


}
procedure TProfilesMngr.butSaveProfileClick(Sender: TObject);
var
  aIni: TIniFile;
begin
  if Assigned(FOnSaveProfile) then begin
    aIni := TIniFile.Create(FProfileIni);
    try
       ProfileIsDirty := False;
       FOnSaveProfile(Self, aIni);
    finally
      aIni.Free;
    end;
  end;
end;

{-


}
procedure TProfilesMngr.Delete1Click(Sender: TObject);
var
  aProfile: TIniProfile;
  FileDelete: TFilename;
begin
  if MessageDlg(Format(DKLangConstW('S_QUERY_DELETEPROFILE'), [ChangeFileExt( ExtractFileName(FProfileIni), '')]),mtWarning, [mbYes, mbNo], 0) = mrYes then begin
    NodeOrigin := TreeView.Selected.GetLastChild;

    // FProfileIni becomes default.ftp
    FileDelete := FProfileIni;

    //Move Programs to Default profile
    while Assigned(NodeOrigin) do begin
      TreeViewDragDrop(nil, TreeView.Items.GetFirstNode, 0, 0);
      NodeOrigin := TreeView.Selected.GetLastChild;
    end;

    aProfile := TreeView.Selected.Data;

    //delete profile
    ListProfiles.Remove(aProfile);
    aProfile.Free;
  
    //delete Treenode
    TreeView.Selected.Delete;
  
    //Select first node
    TreeView.Selected := TreeView.Items.GetFirstNode;
    TreeView.AlphaSort(True);

    if DeleteFile(FileDelete) = False then
      MessageDlg(DKLangConstW('S_ERROR_DELETING_FILE') , mtError, [mbOK], 0)

  end;
end;

{-


}
procedure TProfilesMngr.EvDefaultRequired(aINI : TFileName);
var
  aDefaultIni: TIniFile;
begin
  aDefaultIni := TIniFile.Create(aINI);
  try
    if Assigned(FOnDefaultRequired) then
      FOnDefaultRequired(Self, aDefaultIni);

  finally
    aDefaultIni.Free;
  end;
end;

{-


}
procedure TProfilesMngr.EvProfileSelected(aINI : TFileName);
var
  IniProfile: TInifile;
begin
  if Assigned(FOnProfileSelected) and (FProfileIni <> aIni) then begin
    FProfileIni := aINI;
    IniProfile := TInifile.Create(FProfileIni);
    try
      FOnProfileSelected(Self, IniProfile);
    finally
      IniProfile.Free;
    end;
  end;
end;

{-


}
procedure TProfilesMngr.LoadFromFile(aIni : TIniFile; aProfilePath : TFilename; lastProfile : String);
var
  CurSel: TObject;
  CurProfile, CurProgram: string;
  aNode: TTreeNode;
  SavedOnChange: TTVChangedEvent;
  SavedOnChanging: TTVChangingEvent;
begin
  FreeTrackIni := aIni.FileName;

  //Default.ftp is required to attach all orphan Programs
  if not FileExists(IncludeTrailingPathDelimiter(aProfilePath) + DEFAULT + DOT_PROFILE_EXT) then
    EvDefaultRequired( IncludeTrailingPathDelimiter(aProfilePath) + DEFAULT + DOT_PROFILE_EXT);
  
  //Memorize current node
  if Assigned(TreeView.Selected) then begin
    CurSel := TreeView.Selected.Data;
    if CurSel is TIniProfile then
      CurProfile := (CurSel as TIniProfile).Name
    else
      if CurSel is TProgram then
        CurProgram := (CurSel as TProgram).Name;
  end;

  TreeView.Items.BeginUpdate;
  SavedOnChange := TreeView.OnChange;
  TreeView.OnChange := nil;
  SavedOnChanging := TreeView.OnChanging;
  TreeView.OnChanging := nil;

  TreeView.Items.Clear;
  ListProfiles.Clear;

  ListProfiles.LoadFromDir(aProfilePath);
  ListProfiles.LoadFromFile(aIni);

  //Fill the treeview
  ListProfiles.Update(TreeView.Items);

  TreeView.OnChange := SavedOnChange;
  TreeView.OnChanging := SavedOnChanging;

  LoadingProfiles := True;

  // load last selected profile
  aNode := TreeView.Items.GetFirstNode;
  while Assigned(aNode) do begin
    if (TObject(aNode.Data) is TIniProfile) and (TIniProfile(aNode.Data).Name = CurProfile) then begin
      TreeView.Selected := aNode;
      Break;
    end;
  
    //Restore memorized node selection
    if (TObject(aNode.Data) is TProgram) and (TProgram(aNode.Data).Name = CurProgram) then begin
      TreeView.Selected := aNode;
      Break;
    end;

    aNode := aNode.GetNext;
  end;

  // load last profile filename in config ini
  aNode := TreeView.Items.GetFirstNode;
  if not Assigned(TreeView.Selected) then
    while Assigned(aNode) do begin
      if (TIniProfile(aNode.Data).Name = lastProfile) then begin
        TreeView.Selected := aNode;
        Break;
      end;
      aNode := aNode.GetNext;
    end;

  // fallback on default profile
  if not Assigned(TreeView.Selected) then
    TreeView.Selected := Treeview.Items.GetFirstNode;

  LoadingProfiles := False;

  TreeView.AlphaSort(True);
  TreeView.Items.EndUpdate;
end;

{-


}
procedure TProfilesMngr.Rename1Click(Sender: TObject);
var
  i : integer;
  CurProfileFilename,
  NewProfileFilename: string;
  aIni, IniProfile: TIniFile;
  ProgramsProfile: TStrings;
begin
  CurProfileFilename:=  ChangeFileExt( ExtractFileName( FProfileIni), '');
  NewProfileFilename := CurProfileFilename;

  if InputQuery(DKLangConstW('S_RENAME_PROFILE'), DKLangConstW('S_NEW_PROFILE_NAME'), NewProfileFilename) then begin
    if FileExists(IncludeTrailingPathDelimiter( ExtractFilePath(FProfileIni)) + NewProfileFilename + DOT_PROFILE_EXT) then begin
      MessageDlg(Format(DKLangConstW('S_ERROR_PROFILE_ALREADY_EXISTS'), [NewProfileFilename]), mtError, [mbOK], 0);
      Exit;
    end;

    if RenameFile(FProfileIni, IncludeTrailingPathDelimiter( ExtractFilePath(FProfileIni)) + NewProfileFilename + DOT_PROFILE_EXT) then begin
      FProfileIni := IncludeTrailingPathDelimiter( ExtractFilePath(TIniProfile(TreeView.Selected.Data).Filename)) + NewProfileFilename + DOT_PROFILE_EXT;

      if Assigned(FOnProfileRenamed) then begin
        IniProfile := TInifile.Create(FProfileIni);
        try
          FOnProfileRenamed(Self, IniProfile);
        finally
          IniProfile.Free;
        end;
      end;
      TIniProfile(TreeView.Selected.Data).Filename := FProfileIni;
      TreeView.Selected.Text := NewProfileFilename;
      TreeView.AlphaSort(True);

      //Change in FreeTrack.ini all CurProfileFilename to NewProfileFilename
      aIni := TIniFile.Create(FreeTrackIni);
      ProgramsProfile:= TStringList.Create;
      aIni.ReadSectionValues(ProgramS, ProgramsProfile);
      for i := 0 to ProgramsProfile.Count - 1 do
        if ProgramsProfile.ValueFromIndex[i] = CurProfileFilename then
          aIni.WriteString(ProgramS, ProgramsProfile.Names[i], NewProfileFilename);

      aIni.Free;
      ProgramsProfile.Free;
    end else
      MessageDlg(DKLangConstW('S_ERROR_RENAMING_FILE'), mtError, [mbOK], 0);
  end;
end;

{-


}
procedure TProfilesMngr.SaveToFile(aIni : TIniFile);
begin
  ListProfiles.SaveToFile(aIni);
end;

{-


}
procedure TProfilesMngr.SelectProgramID(aProgramID : string);
var
  aNodeProfile, aNodeProgram: TTreeNode;
begin
  aNodeProfile := TreeView.Items.GetFirstNode;
  while Assigned(aNodeProfile) do begin
    aNodeProgram := aNodeProfile.getFirstChild;

    while Assigned(aNodeProgram) do begin
      if TProgram(aNodeProgram.Data).ID = aProgramID then begin
        aNodeProgram.Selected := True;
        aNodeProfile := nil; // to break the aNodeProfile loop
        Break;
      end;
      aNodeProgram := aNodeProgram.getNextSibling;
    end;

    if Assigned(aNodeProfile)  then
      aNodeProfile := aNodeProfile.getNextSibling;
  end;
end;


procedure TProfilesMngr.SelectProgramName(aProgramName : string);
var
  aNodeProfile, aNodeProgram: TTreeNode;
begin
  aNodeProfile := TreeView.Items.GetFirstNode;
  while Assigned(aNodeProfile) do begin
    aNodeProgram := aNodeProfile.getFirstChild;

    while Assigned(aNodeProgram) do begin
      if TProgram(aNodeProgram.Data).FName = aProgramName then begin
        aNodeProgram.Selected := True;
        aNodeProfile := nil; // to break the aNodeProfile loop
        Break;
      end;
      aNodeProgram := aNodeProgram.getNextSibling;
    end;

    if Assigned(aNodeProfile)  then
      aNodeProfile := aNodeProfile.getNextSibling;
  end;
end;

{-


}
procedure TProfilesMngr.SetProgramsList(aFile : TFilename);
var
  aIni: TIniFile;
begin
  if Assigned(ProgramsList) then begin
    aIni := TIniFile.Create(aFile);
    aIni.ReadSectionValues(Programs, ProgramsList);

    aIni.Free;
    ProgramsIni := aFile;
  end;
end;

{-


}
procedure TProfilesMngr.SetProfileIsDirty(Value: Boolean);
begin
  FProfileIsDirty := Value;
end;

{-


}
procedure TProfilesMngr.TreeViewChange(Sender: TObject; Node: TTreeNode);
begin
  if Assigned(Node.Data) and (TObject(Node.Data) is TProgram) then begin
    TreeView.DragMode := dmAutomatic;
    EvProfileSelected( TIniProfile(Node.Parent.Data).Filename);
  end else
    TreeView.DragMode := dmManual;
  
  
  if Assigned(Node.Data) and (TObject(Node.Data) is TIniProfile) then
    EvProfileSelected( TIniProfile(Node.Data).Filename);
end;

{-


}
procedure TProfilesMngr.TreeViewChanging(Sender: TObject; Node: TTreeNode; var AllowChange: Boolean);
begin
  if not LoadingProfiles and FProfileIsDirty then
    if FAutoSave then
      butSaveProfileClick(Self)
    else if not FAutoloadingProfile then
      case MessageDlg(Format(DKLangConstW('S_QUERY_SAVE_CHANGES'), [ChangeFileExt( ExtractFileName( FProfileIni), '')]), mtConfirmation, mbYesNoCancel, 0) of
        mrYes    : butSaveProfileClick(Self);
        mrNo     : ProfileIsDirty := False;
        mrCancel : AllowChange := False;
      end;
end;

{-


}
procedure TProfilesMngr.TreeViewCompare(Sender: TObject; Node1, Node2: TTreeNode; Data: Integer; var Compare: Integer);
begin
  //Set Node "Default" always to the top
  if (TObject(Node1.Data) is TIniProfile) and (TIniProfile(Node1.Data).Name = DEFAULT) then
    Compare := -1
  else
    if (TObject(Node2.Data) is TIniProfile) and (TIniProfile(Node2.Data).Name = DEFAULT) then
      Compare := 1
    else
      Compare := CompareText(Node1.Text, Node2.Text);
end;

{-


}
procedure TProfilesMngr.TreeViewDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  NodeDest: TTreeNode;
  SrcProfile, DstProfile: TIniProfile;
  aProgram: TProgram;
begin
  if Source is TTreeNode then
    NodeDest := Source as TTreeNode
  else
    NodeDest := TreeView.GetNodeAt(X, Y);

  if Assigned( NodeDest.Data ) and (TObject(NodeDest.Data ) is TIniProfile) then begin
    aProgram := NodeOrigin.Data;
  
    //Add to the new profile
    DstProfile := NodeDest.Data;
    DstProfile.Programs.Add(aProgram);

    //Remove from the old profile
    SrcProfile := NodeOrigin.Parent.Data;
    SrcProfile.Programs.Delete(SrcProfile.Programs.IndexOf(aProgram));
  
    //Move the treenode too
    NodeOrigin.MoveTo(NodeDest, naAddChild);
  end;
end;

{-


}
procedure TProfilesMngr.TreeViewDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
var
  DestNode: TTreeNode;
begin
  DestNode := TreeView.GetNodeAt(X, Y);
  Accept := Assigned(DestNode) and Assigned(DestNode.Data) and
            (TObject(DestNode.Data) is TIniProfile) and
            Assigned(NodeOrigin) and
            (NodeOrigin.Parent.Data <> DestNode.Data);
  if Y >= TreeView.Height - 20 then
    SendMessage(TreeView.handle, WM_VSCROLL, SB_LINEDOWN, 0)
  else if Y <= 20 then
    SendMessage(TreeView.handle, WM_VSCROLL, SB_LINEUP, 0);
end;

{-


}
procedure TProfilesMngr.TreeViewMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  aNode: TTreeNode;
begin
  aNode := TreeView.GetNodeAt(X, Y);
  if (aNode = TreeView.Selected) and (TObject(aNode.Data) is TIniProfile) then begin
    TreeView.PopupMenu := PopProfile;
    Rename1.Enabled := (aNode.Text <> DEFAULT) and (aNode.Text <> FSX);
    Delete1.Enabled := (aNode.Text <> DEFAULT) and (aNode.Text <> FSX);
  end else
    TreeView.PopupMenu := nil;
end;

{-


}
procedure TProfilesMngr.TreeViewMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  aNode: TTreenode;
  aProgram: TProgram;
  aPt: TPoint;
begin
  aNode:= TreeView.GetNodeAt(x,y);
  if Assigned(aNode) and (TObject(aNode.Data) is TProgram)and (aNode.Text <> Treeview.Hint)then begin
    aProgram := aNode.Data;
    TreeView.Hint := Format(DKLangConstW('S_PROGRAMID') + '=%s', [aProgram.ID]);
    aPt := TreeView.ClientToScreen(Point(x,y));
    Application.ActivateHint( aPt);
  end else
    Application.CancelHint;
end;

{-


}
procedure TProfilesMngr.TreeViewStartDrag(Sender: TObject; var DragObject: TDragObject);
var
  NodePos: TPoint;
begin
  NodePos := TreeView.ScreenToClient(Mouse.CursorPos);
  NodeOrigin := TreeView.GetNodeAt(NodePos.X, NodePos.Y);
  if not (TObject(NodeOrigin.Data) is TProgram) then
    NodeOrigin := nil;
end;



function TProfilesMngr.AutoLoadProfile(programID : integer; programName : String) : Boolean;
var
  newProgramName : string;
  aIni : TIniFile;
  aProgram : TProgram;
begin
  Result := False;

  // new program detected?
  if ProgramsList.IndexOfName(IntToStr(programID)) = -1 then begin
    while True do begin
      if not InputQuery(DKLangConstW('S_TRACKIR_NEW_PROGRAM'), DKLangConstW('S_TRACKIR_NEW_PROGRAM_CAPTION'), newProgramName) then
        Break;

      if Length(Trim(newProgramName)) > 2 then begin
        aIni := TIniFile.Create(ProgramsIni);
        aIni.WriteString(Programs, InttoStr(programID), newProgramName);
        aIni.Free;

        ProgramsList.Values[InttoStr(programID)] := newProgramName;

        aProgram := TProgram.Create;
        aProgram.ID := InttoStr(programID);
        aProgram.Name := newProgramName;

        //add new Program to Default profile
        ListProfiles.items[ListProfiles.IndexOf(DEFAULT)].Programs.Add(aProgram);
        TreeView.Items.AddChildObject(TreeView.Items[0], newProgramName, aProgram);
        Break;
      end else
        MessageDlg(DKLangConstW('S_ERROR_PROGRAM_NAME_TOO_SMALL'), mtError, [mbOK], 0)
    end;
  end else if FAutoLoad then begin
    FAutoLoadingProfile := True;
    if (programID = 0) then // freetrack interface
      SelectProgramName(programName)
    else // trackir interface
      SelectProgramID(IntToStr(programID));
    FAutoLoadingProfile := False;
    Result := True; // program auto loaded
  end;
end;



procedure TProfilesMngr.butNewProfileClick(aProfilePath : TFilename);
var
  NewFilename: string;
begin
  NewFilename := 'NewProfile';
  if InputQuery(DKLangConstW('S_NEW_PROFILE'), DKLangConstW('S_FILENAME'), NewFilename) then begin
    NewFilename := IncludeTrailingPathDelimiter(aProfilePath) + NewFilename + DOT_PROFILE_EXT;
    if not FileExists(NewFilename) then begin
      EvDefaultRequired(NewFilename);
      AddProfileToTreeview(NewFilename);
    end else
      MessageDlg(DKLangConstW('S_ERROR_PROFILE_ALREADY_EXISTS'), mtError, [mbOK], 0)
  end;

end;



end.







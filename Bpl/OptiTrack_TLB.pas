unit OptiTrack_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : 1.2
// File generated on 6/04/2008 11:27:30 PM from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Headtrack\Freetrack\OptiTrack\Optitrack34\bin\OptiTrack.dll (1)
// LIBID: {2627555C-CA32-4D0D-AA55-D04783A5497E}
// LCID: 0
// Helpfile: 
// HelpString: OptiTrack 1.0 Type Library
// DepndLst: 
//   (1) v2.0 stdole, (D:\WINDOWS\system32\stdole2.tlb)
// Errors:
//   Error creating palette bitmap of (TNPCameraCollection) : Server C:\Headtrack\Freetrack\OptiTrack\Optitrack34\bin\OptiTrack.dll contains no icons
//   Error creating palette bitmap of (TNPCamera) : Server C:\Headtrack\Freetrack\OptiTrack\Optitrack34\bin\OptiTrack.dll contains no icons
//   Error creating palette bitmap of (TNPCameraFrame) : Server C:\Headtrack\Freetrack\OptiTrack\Optitrack34\bin\OptiTrack.dll contains no icons
//   Error creating palette bitmap of (TNPObject) : Server C:\Headtrack\Freetrack\OptiTrack\Optitrack34\bin\OptiTrack.dll contains no icons
//   Error creating palette bitmap of (TNPSmoothing) : Server C:\Headtrack\Freetrack\OptiTrack\Optitrack34\bin\OptiTrack.dll contains no icons
//   Error creating palette bitmap of (TNPVector) : Server C:\Headtrack\Freetrack\OptiTrack\Optitrack34\bin\OptiTrack.dll contains no icons
//   Error creating palette bitmap of (TNPPoint) : Server C:\Headtrack\Freetrack\OptiTrack\Optitrack34\bin\OptiTrack.dll contains no icons
//   Error creating palette bitmap of (TNPAvi) : Server C:\Headtrack\Freetrack\OptiTrack\Optitrack34\bin\OptiTrack.dll contains no icons
// ************************************************************************ //
// *************************************************************************//
// NOTE:                                                                      
// Items guarded by $IFDEF_LIVE_SERVER_AT_DESIGN_TIME are used by properties  
// which return objects that may need to be explicitly created via a function 
// call prior to any access via the property. These items have been disabled  
// in order to prevent accidental use from within the object inspector. You   
// may enable them by defining LIVE_SERVER_AT_DESIGN_TIME or by selectively   
// removing them from the $IFDEF blocks. However, such items must still be    
// programmatically created via a method of the appropriate CoClass before    
// they can be used.                                                          
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, OleServer, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  OptiTrackMajorVersion = 1;
  OptiTrackMinorVersion = 0;

  LIBID_OptiTrack: TGUID = '{2627555C-CA32-4D0D-AA55-D04783A5497E}';

  DIID__INPCameraCollectionEvents: TGUID = '{076F9DDA-1422-4B4D-926A-961DF5725B5A}';
  IID_INPCamera: TGUID = '{ADE1E272-C86A-460D-B7B9-3051F310E4D0}';
  IID_INPCameraFrame: TGUID = '{73CF9A64-837A-4F05-9BF6-8A253CE16E46}';
  IID_INPObject: TGUID = '{6E439CE4-AB0D-44B8-BF1E-644C5CC489DC}';
  DIID__INPCameraEvents: TGUID = '{A50B57C5-7472-4F16-BC14-2345B8D24BFD}';
  IID_INPCameraCollection: TGUID = '{28E501BB-FDD9-46CF-A112-741587110F0E}';
  CLASS_NPCameraCollection: TGUID = '{1CA83C6F-70A6-40EB-836F-D9EEC0BD168F}';
  CLASS_NPCamera: TGUID = '{77686C4C-8402-42CE-ADF2-913B53E0A25B}';
  CLASS_NPCameraFrame: TGUID = '{4656500B-863B-48F6-8725-AB029769EA89}';
  CLASS_NPObject: TGUID = '{B696B174-5B53-4DDD-B78B-CA75C072C85A}';
  IID_INPSmoothing: TGUID = '{0EDD3505-855C-4D91-A9C1-DCBEC1B816FA}';
  CLASS_NPSmoothing: TGUID = '{B4CA710D-9B17-42C3-846B-FC16876B6D5E}';
  IID_INPVector3: TGUID = '{9124C9AA-9296-4E89-973D-4F3C502E36CA}';
  IID_INPVector2: TGUID = '{9124C9A9-9296-4E89-973D-4F3C502E36CA}';
  IID_INPPoint: TGUID = '{9124C9F0-9296-4E89-973D-4F3C502E36CA}';
  IID_INPVector: TGUID = '{9124C9A8-9296-4E89-973D-4F3C502E36CA}';
  CLASS_NPVector: TGUID = '{FE7D5FB0-0560-49ED-BF49-CE9996C62A6B}';
  CLASS_NPPoint: TGUID = '{FE7D5FB2-0560-49ED-BF49-CE9996C62A6B}';
  IID_INPAvi: TGUID = '{9124CA00-9296-4E89-973D-4F3C502E36CA}';
  CLASS_NPAvi: TGUID = '{FE7D5FB3-0560-49ED-BF49-CE9996C62A6B}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  _INPCameraCollectionEvents = dispinterface;
  INPCamera = interface;
  INPCameraDisp = dispinterface;
  INPCameraFrame = interface;
  INPCameraFrameDisp = dispinterface;
  INPObject = interface;
  INPObjectDisp = dispinterface;
  _INPCameraEvents = dispinterface;
  INPCameraCollection = interface;
  INPCameraCollectionDisp = dispinterface;
  INPSmoothing = interface;
  INPSmoothingDisp = dispinterface;
  INPVector3 = interface;
  INPVector3Disp = dispinterface;
  INPVector2 = interface;
  INPVector2Disp = dispinterface;
  INPPoint = interface;
  INPPointDisp = dispinterface;
  INPVector = interface;
  INPVectorDisp = dispinterface;
  INPAvi = interface;
  INPAviDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  NPCameraCollection = INPCameraCollection;
  NPCamera = INPCamera;
  NPCameraFrame = INPCameraFrame;
  NPObject = INPObject;
  NPSmoothing = INPSmoothing;
  NPVector = INPVector3;
  NPPoint = INPPoint;
  NPAvi = INPAvi;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//
  PByte1 = ^Byte; {*}


// *********************************************************************//
// DispIntf:  _INPCameraCollectionEvents
// Flags:     (4096) Dispatchable
// GUID:      {076F9DDA-1422-4B4D-926A-961DF5725B5A}
// *********************************************************************//
  _INPCameraCollectionEvents = dispinterface
    ['{076F9DDA-1422-4B4D-926A-961DF5725B5A}']
    procedure DeviceRemoval(const pCamera: INPCamera); dispid 1;
    procedure DeviceArrival(const pCamera: INPCamera); dispid 2;
    procedure FrameAvailableId(Group: Integer; Id: Integer); dispid 3;
  end;

// *********************************************************************//
// Interface: INPCamera
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {ADE1E272-C86A-460D-B7B9-3051F310E4D0}
// *********************************************************************//
  INPCamera = interface(IDispatch)
    ['{ADE1E272-C86A-460D-B7B9-3051F310E4D0}']
    function Get_SerialNumber: Integer; safecall;
    function Get_Model: Integer; safecall;
    function Get_Revision: Integer; safecall;
    function Get_Width: Integer; safecall;
    function Get_Height: Integer; safecall;
    function Get_FrameRate: Integer; safecall;
    procedure Start; safecall;
    procedure Stop; safecall;
    procedure Open; safecall;
    procedure Close; safecall;
    procedure SetLED(lLED: Integer; fOn: WordBool); safecall;
    function GetFrame(lTimeout: Integer): INPCameraFrame; safecall;
    procedure DrawFrame(const pFrame: INPCameraFrame; hwnd: Integer); safecall;
    procedure ResetTrackedObject; safecall;
    function GetOption(lOption: Integer): OleVariant; safecall;
    procedure SetOption(lOption: Integer; Val: OleVariant); safecall;
    function GetFrameById(Id: Integer): INPCameraFrame; safecall;
    procedure GetFrameImage(const pFrame: INPCameraFrame; PixelWidth: SYSINT; PixelHeight: SYSINT; 
                            ByteSpan: SYSINT; BitsPerPixel: SYSINT; var Buffer: Byte); safecall;
    procedure SetVideo(fOn: WordBool); safecall;
    property SerialNumber: Integer read Get_SerialNumber;
    property Model: Integer read Get_Model;
    property Revision: Integer read Get_Revision;
    property Width: Integer read Get_Width;
    property Height: Integer read Get_Height;
    property FrameRate: Integer read Get_FrameRate;
  end;

// *********************************************************************//
// DispIntf:  INPCameraDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {ADE1E272-C86A-460D-B7B9-3051F310E4D0}
// *********************************************************************//
  INPCameraDisp = dispinterface
    ['{ADE1E272-C86A-460D-B7B9-3051F310E4D0}']
    property SerialNumber: Integer readonly dispid 1;
    property Model: Integer readonly dispid 2;
    property Revision: Integer readonly dispid 3;
    property Width: Integer readonly dispid 4;
    property Height: Integer readonly dispid 5;
    property FrameRate: Integer readonly dispid 6;
    procedure Start; dispid 50;
    procedure Stop; dispid 51;
    procedure Open; dispid 52;
    procedure Close; dispid 53;
    procedure SetLED(lLED: Integer; fOn: WordBool); dispid 54;
    function GetFrame(lTimeout: Integer): INPCameraFrame; dispid 55;
    procedure DrawFrame(const pFrame: INPCameraFrame; hwnd: Integer); dispid 56;
    procedure ResetTrackedObject; dispid 57;
    function GetOption(lOption: Integer): OleVariant; dispid 58;
    procedure SetOption(lOption: Integer; Val: OleVariant); dispid 59;
    function GetFrameById(Id: Integer): INPCameraFrame; dispid 60;
    procedure GetFrameImage(const pFrame: INPCameraFrame; PixelWidth: SYSINT; PixelHeight: SYSINT; 
                            ByteSpan: SYSINT; BitsPerPixel: SYSINT; var Buffer: Byte); dispid 61;
    procedure SetVideo(fOn: WordBool); dispid 62;
  end;

// *********************************************************************//
// Interface: INPCameraFrame
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {73CF9A64-837A-4F05-9BF6-8A253CE16E46}
// *********************************************************************//
  INPCameraFrame = interface(IDispatch)
    ['{73CF9A64-837A-4F05-9BF6-8A253CE16E46}']
    function Get__NewEnum: IUnknown; safecall;
    function Get_Count: Integer; safecall;
    function Item(a_vlIndex: Integer): INPObject; safecall;
    function Get_Id: Integer; safecall;
    function Get_SwitchState: Integer; safecall;
    function Get_IsEmpty: WordBool; safecall;
    function Get_IsCorrupt: WordBool; safecall;
    function Get_IsGreyscale: WordBool; safecall;
    function Get_TimeStamp: OleVariant; safecall;
    function Get_TimeStampFrequency: OleVariant; safecall;
    function GetObjectData(var Buffer: Byte; BufferSize: SYSINT): Integer; safecall;
    procedure Free; safecall;
    property _NewEnum: IUnknown read Get__NewEnum;
    property Count: Integer read Get_Count;
    property Id: Integer read Get_Id;
    property SwitchState: Integer read Get_SwitchState;
    property IsEmpty: WordBool read Get_IsEmpty;
    property IsCorrupt: WordBool read Get_IsCorrupt;
    property IsGreyscale: WordBool read Get_IsGreyscale;
    property TimeStamp: OleVariant read Get_TimeStamp;
    property TimeStampFrequency: OleVariant read Get_TimeStampFrequency;
  end;

// *********************************************************************//
// DispIntf:  INPCameraFrameDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {73CF9A64-837A-4F05-9BF6-8A253CE16E46}
// *********************************************************************//
  INPCameraFrameDisp = dispinterface
    ['{73CF9A64-837A-4F05-9BF6-8A253CE16E46}']
    property _NewEnum: IUnknown readonly dispid -4;
    property Count: Integer readonly dispid 1;
    function Item(a_vlIndex: Integer): INPObject; dispid 0;
    property Id: Integer readonly dispid 5;
    property SwitchState: Integer readonly dispid 6;
    property IsEmpty: WordBool readonly dispid 7;
    property IsCorrupt: WordBool readonly dispid 8;
    property IsGreyscale: WordBool readonly dispid 9;
    property TimeStamp: OleVariant readonly dispid 10;
    property TimeStampFrequency: OleVariant readonly dispid 11;
    function GetObjectData(var Buffer: Byte; BufferSize: SYSINT): Integer; dispid 12;
    procedure Free; dispid 50;
  end;

// *********************************************************************//
// Interface: INPObject
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6E439CE4-AB0D-44B8-BF1E-644C5CC489DC}
// *********************************************************************//
  INPObject = interface(IDispatch)
    ['{6E439CE4-AB0D-44B8-BF1E-644C5CC489DC}']
    function Get_Area: OleVariant; safecall;
    function Get_X: OleVariant; safecall;
    function Get_Y: OleVariant; safecall;
    function Get_Score: OleVariant; safecall;
    function Get_Rank: Integer; safecall;
    function Get_Width: Integer; safecall;
    function Get_Height: Integer; safecall;
    procedure Transform(const pCamera: INPCamera); safecall;
    property Area: OleVariant read Get_Area;
    property X: OleVariant read Get_X;
    property Y: OleVariant read Get_Y;
    property Score: OleVariant read Get_Score;
    property Rank: Integer read Get_Rank;
    property Width: Integer read Get_Width;
    property Height: Integer read Get_Height;
  end;

// *********************************************************************//
// DispIntf:  INPObjectDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6E439CE4-AB0D-44B8-BF1E-644C5CC489DC}
// *********************************************************************//
  INPObjectDisp = dispinterface
    ['{6E439CE4-AB0D-44B8-BF1E-644C5CC489DC}']
    property Area: OleVariant readonly dispid 1;
    property X: OleVariant readonly dispid 2;
    property Y: OleVariant readonly dispid 3;
    property Score: OleVariant readonly dispid 4;
    property Rank: Integer readonly dispid 5;
    property Width: Integer readonly dispid 6;
    property Height: Integer readonly dispid 7;
    procedure Transform(const pCamera: INPCamera); dispid 50;
  end;

// *********************************************************************//
// DispIntf:  _INPCameraEvents
// Flags:     (4096) Dispatchable
// GUID:      {A50B57C5-7472-4F16-BC14-2345B8D24BFD}
// *********************************************************************//
  _INPCameraEvents = dispinterface
    ['{A50B57C5-7472-4F16-BC14-2345B8D24BFD}']
    procedure FrameAvailable(const pCamera: INPCamera); dispid 1;
    procedure SwitchChange(const pCamera: INPCamera; lNewSwitchState: Integer); dispid 2;
    procedure FrameAvailableIdCamera(const pCamera: INPCamera; Group: Integer; Id: Integer); dispid 3;
  end;

// *********************************************************************//
// Interface: INPCameraCollection
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {28E501BB-FDD9-46CF-A112-741587110F0E}
// *********************************************************************//
  INPCameraCollection = interface(IDispatch)
    ['{28E501BB-FDD9-46CF-A112-741587110F0E}']
    function Get__NewEnum: IUnknown; safecall;
    function Get_Count: Integer; safecall;
    function Item(a_vlIndex: Integer): INPCamera; safecall;
    procedure Enum; safecall;
    procedure Synchronize; safecall;
    property _NewEnum: IUnknown read Get__NewEnum;
    property Count: Integer read Get_Count;
  end;

// *********************************************************************//
// DispIntf:  INPCameraCollectionDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {28E501BB-FDD9-46CF-A112-741587110F0E}
// *********************************************************************//
  INPCameraCollectionDisp = dispinterface
    ['{28E501BB-FDD9-46CF-A112-741587110F0E}']
    property _NewEnum: IUnknown readonly dispid -4;
    property Count: Integer readonly dispid 1;
    function Item(a_vlIndex: Integer): INPCamera; dispid 0;
    procedure Enum; dispid 10;
    procedure Synchronize; dispid 11;
  end;

// *********************************************************************//
// Interface: INPSmoothing
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0EDD3505-855C-4D91-A9C1-DCBEC1B816FA}
// *********************************************************************//
  INPSmoothing = interface(IDispatch)
    ['{0EDD3505-855C-4D91-A9C1-DCBEC1B816FA}']
    function Get_Amount: OleVariant; safecall;
    procedure Set_Amount(pVal: OleVariant); safecall;
    function Get_X: OleVariant; safecall;
    function Get_Y: OleVariant; safecall;
    procedure Update(ValX: OleVariant; ValY: OleVariant); safecall;
    procedure Reset; safecall;
    property Amount: OleVariant read Get_Amount write Set_Amount;
    property X: OleVariant read Get_X;
    property Y: OleVariant read Get_Y;
  end;

// *********************************************************************//
// DispIntf:  INPSmoothingDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0EDD3505-855C-4D91-A9C1-DCBEC1B816FA}
// *********************************************************************//
  INPSmoothingDisp = dispinterface
    ['{0EDD3505-855C-4D91-A9C1-DCBEC1B816FA}']
    property Amount: OleVariant dispid 1;
    property X: OleVariant readonly dispid 2;
    property Y: OleVariant readonly dispid 3;
    procedure Update(ValX: OleVariant; ValY: OleVariant); dispid 50;
    procedure Reset; dispid 51;
  end;

// *********************************************************************//
// Interface: INPVector3
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9124C9AA-9296-4E89-973D-4F3C502E36CA}
// *********************************************************************//
  INPVector3 = interface(IDispatch)
    ['{9124C9AA-9296-4E89-973D-4F3C502E36CA}']
    function Get_Yaw: OleVariant; safecall;
    function Get_Pitch: OleVariant; safecall;
    function Get_Roll: OleVariant; safecall;
    function Get_X: OleVariant; safecall;
    function Get_Y: OleVariant; safecall;
    function Get_Z: OleVariant; safecall;
    function Get_dist01: OleVariant; safecall;
    procedure Set_dist01(pVal: OleVariant); safecall;
    function Get_dist02: OleVariant; safecall;
    procedure Set_dist02(pVal: OleVariant); safecall;
    function Get_dist12: OleVariant; safecall;
    procedure Set_dist12(pVal: OleVariant); safecall;
    function Get_distol: OleVariant; safecall;
    procedure Set_distol(pVal: OleVariant); safecall;
    function Get_Tracking: OleVariant; safecall;
    function Get_imagerPixelWidth: OleVariant; safecall;
    procedure Set_imagerPixelWidth(pVal: OleVariant); safecall;
    function Get_imagerPixelHeight: OleVariant; safecall;
    procedure Set_imagerPixelHeight(pVal: OleVariant); safecall;
    function Get_imagerMMWidth: OleVariant; safecall;
    procedure Set_imagerMMWidth(pVal: OleVariant); safecall;
    function Get_imagerMMHeight: OleVariant; safecall;
    procedure Set_imagerMMHeight(pVal: OleVariant); safecall;
    function Get_imagerMMFocalLength: OleVariant; safecall;
    procedure Set_imagerMMFocalLength(pVal: OleVariant); safecall;
    procedure Update(const pCamera: INPCamera; const pFrame: INPCameraFrame); safecall;
    procedure Reset; safecall;
    function GetPoint(nPoint: SYSINT): INPPoint; safecall;
    property Yaw: OleVariant read Get_Yaw;
    property Pitch: OleVariant read Get_Pitch;
    property Roll: OleVariant read Get_Roll;
    property X: OleVariant read Get_X;
    property Y: OleVariant read Get_Y;
    property Z: OleVariant read Get_Z;
    property dist01: OleVariant read Get_dist01 write Set_dist01;
    property dist02: OleVariant read Get_dist02 write Set_dist02;
    property dist12: OleVariant read Get_dist12 write Set_dist12;
    property distol: OleVariant read Get_distol write Set_distol;
    property Tracking: OleVariant read Get_Tracking;
    property imagerPixelWidth: OleVariant read Get_imagerPixelWidth write Set_imagerPixelWidth;
    property imagerPixelHeight: OleVariant read Get_imagerPixelHeight write Set_imagerPixelHeight;
    property imagerMMWidth: OleVariant read Get_imagerMMWidth write Set_imagerMMWidth;
    property imagerMMHeight: OleVariant read Get_imagerMMHeight write Set_imagerMMHeight;
    property imagerMMFocalLength: OleVariant read Get_imagerMMFocalLength write Set_imagerMMFocalLength;
  end;

// *********************************************************************//
// DispIntf:  INPVector3Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9124C9AA-9296-4E89-973D-4F3C502E36CA}
// *********************************************************************//
  INPVector3Disp = dispinterface
    ['{9124C9AA-9296-4E89-973D-4F3C502E36CA}']
    property Yaw: OleVariant readonly dispid 1;
    property Pitch: OleVariant readonly dispid 2;
    property Roll: OleVariant readonly dispid 3;
    property X: OleVariant readonly dispid 4;
    property Y: OleVariant readonly dispid 5;
    property Z: OleVariant readonly dispid 6;
    property dist01: OleVariant dispid 10;
    property dist02: OleVariant dispid 11;
    property dist12: OleVariant dispid 12;
    property distol: OleVariant dispid 13;
    property Tracking: OleVariant readonly dispid 14;
    property imagerPixelWidth: OleVariant dispid 15;
    property imagerPixelHeight: OleVariant dispid 16;
    property imagerMMWidth: OleVariant dispid 17;
    property imagerMMHeight: OleVariant dispid 18;
    property imagerMMFocalLength: OleVariant dispid 19;
    procedure Update(const pCamera: INPCamera; const pFrame: INPCameraFrame); dispid 50;
    procedure Reset; dispid 51;
    function GetPoint(nPoint: SYSINT): INPPoint; dispid 52;
  end;

// *********************************************************************//
// Interface: INPVector2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9124C9A9-9296-4E89-973D-4F3C502E36CA}
// *********************************************************************//
  INPVector2 = interface(IDispatch)
    ['{9124C9A9-9296-4E89-973D-4F3C502E36CA}']
    function Get_Yaw: OleVariant; safecall;
    function Get_Pitch: OleVariant; safecall;
    function Get_Roll: OleVariant; safecall;
    function Get_X: OleVariant; safecall;
    function Get_Y: OleVariant; safecall;
    function Get_Z: OleVariant; safecall;
    function Get_dist01: OleVariant; safecall;
    procedure Set_dist01(pVal: OleVariant); safecall;
    function Get_dist02: OleVariant; safecall;
    procedure Set_dist02(pVal: OleVariant); safecall;
    function Get_dist12: OleVariant; safecall;
    procedure Set_dist12(pVal: OleVariant); safecall;
    function Get_distol: OleVariant; safecall;
    procedure Set_distol(pVal: OleVariant); safecall;
    function Get_Tracking: OleVariant; safecall;
    procedure Update(const pCamera: INPCamera; const pFrame: INPCameraFrame); safecall;
    procedure Reset; safecall;
    function GetPoint(nPoint: SYSINT): INPPoint; safecall;
    property Yaw: OleVariant read Get_Yaw;
    property Pitch: OleVariant read Get_Pitch;
    property Roll: OleVariant read Get_Roll;
    property X: OleVariant read Get_X;
    property Y: OleVariant read Get_Y;
    property Z: OleVariant read Get_Z;
    property dist01: OleVariant read Get_dist01 write Set_dist01;
    property dist02: OleVariant read Get_dist02 write Set_dist02;
    property dist12: OleVariant read Get_dist12 write Set_dist12;
    property distol: OleVariant read Get_distol write Set_distol;
    property Tracking: OleVariant read Get_Tracking;
  end;

// *********************************************************************//
// DispIntf:  INPVector2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9124C9A9-9296-4E89-973D-4F3C502E36CA}
// *********************************************************************//
  INPVector2Disp = dispinterface
    ['{9124C9A9-9296-4E89-973D-4F3C502E36CA}']
    property Yaw: OleVariant readonly dispid 1;
    property Pitch: OleVariant readonly dispid 2;
    property Roll: OleVariant readonly dispid 3;
    property X: OleVariant readonly dispid 4;
    property Y: OleVariant readonly dispid 5;
    property Z: OleVariant readonly dispid 6;
    property dist01: OleVariant dispid 10;
    property dist02: OleVariant dispid 11;
    property dist12: OleVariant dispid 12;
    property distol: OleVariant dispid 13;
    property Tracking: OleVariant readonly dispid 14;
    procedure Update(const pCamera: INPCamera; const pFrame: INPCameraFrame); dispid 50;
    procedure Reset; dispid 51;
    function GetPoint(nPoint: SYSINT): INPPoint; dispid 52;
  end;

// *********************************************************************//
// Interface: INPPoint
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9124C9F0-9296-4E89-973D-4F3C502E36CA}
// *********************************************************************//
  INPPoint = interface(IDispatch)
    ['{9124C9F0-9296-4E89-973D-4F3C502E36CA}']
    function Get_X: OleVariant; safecall;
    function Get_Y: OleVariant; safecall;
    function Get_Z: OleVariant; safecall;
    property X: OleVariant read Get_X;
    property Y: OleVariant read Get_Y;
    property Z: OleVariant read Get_Z;
  end;

// *********************************************************************//
// DispIntf:  INPPointDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9124C9F0-9296-4E89-973D-4F3C502E36CA}
// *********************************************************************//
  INPPointDisp = dispinterface
    ['{9124C9F0-9296-4E89-973D-4F3C502E36CA}']
    property X: OleVariant readonly dispid 1;
    property Y: OleVariant readonly dispid 2;
    property Z: OleVariant readonly dispid 3;
  end;

// *********************************************************************//
// Interface: INPVector
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9124C9A8-9296-4E89-973D-4F3C502E36CA}
// *********************************************************************//
  INPVector = interface(IDispatch)
    ['{9124C9A8-9296-4E89-973D-4F3C502E36CA}']
    function Get_Yaw: OleVariant; safecall;
    function Get_Pitch: OleVariant; safecall;
    function Get_Roll: OleVariant; safecall;
    function Get_X: OleVariant; safecall;
    function Get_Y: OleVariant; safecall;
    function Get_Z: OleVariant; safecall;
    procedure Update(const pCamera: INPCamera; const pFrame: INPCameraFrame); safecall;
    procedure Reset; safecall;
    property Yaw: OleVariant read Get_Yaw;
    property Pitch: OleVariant read Get_Pitch;
    property Roll: OleVariant read Get_Roll;
    property X: OleVariant read Get_X;
    property Y: OleVariant read Get_Y;
    property Z: OleVariant read Get_Z;
  end;

// *********************************************************************//
// DispIntf:  INPVectorDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9124C9A8-9296-4E89-973D-4F3C502E36CA}
// *********************************************************************//
  INPVectorDisp = dispinterface
    ['{9124C9A8-9296-4E89-973D-4F3C502E36CA}']
    property Yaw: OleVariant readonly dispid 1;
    property Pitch: OleVariant readonly dispid 2;
    property Roll: OleVariant readonly dispid 3;
    property X: OleVariant readonly dispid 4;
    property Y: OleVariant readonly dispid 5;
    property Z: OleVariant readonly dispid 6;
    procedure Update(const pCamera: INPCamera; const pFrame: INPCameraFrame); dispid 50;
    procedure Reset; dispid 51;
  end;

// *********************************************************************//
// Interface: INPAvi
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9124CA00-9296-4E89-973D-4F3C502E36CA}
// *********************************************************************//
  INPAvi = interface(IDispatch)
    ['{9124CA00-9296-4E89-973D-4F3C502E36CA}']
    function Get_FileName: WideString; safecall;
    procedure Set_FileName(const pVal: WideString); safecall;
    function Get_FrameRate: Integer; safecall;
    procedure Set_FrameRate(pVal: Integer); safecall;
    procedure Start; safecall;
    procedure Stop; safecall;
    procedure AddFrame(const pCamera: INPCamera; const pFrame: INPCameraFrame); safecall;
    property FileName: WideString read Get_FileName write Set_FileName;
    property FrameRate: Integer read Get_FrameRate write Set_FrameRate;
  end;

// *********************************************************************//
// DispIntf:  INPAviDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9124CA00-9296-4E89-973D-4F3C502E36CA}
// *********************************************************************//
  INPAviDisp = dispinterface
    ['{9124CA00-9296-4E89-973D-4F3C502E36CA}']
    property FileName: WideString dispid 1;
    property FrameRate: Integer dispid 2;
    procedure Start; dispid 50;
    procedure Stop; dispid 51;
    procedure AddFrame(const pCamera: INPCamera; const pFrame: INPCameraFrame); dispid 52;
  end;

// *********************************************************************//
// The Class CoNPCameraCollection provides a Create and CreateRemote method to          
// create instances of the default interface INPCameraCollection exposed by              
// the CoClass NPCameraCollection. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoNPCameraCollection = class
    class function Create: INPCameraCollection;
    class function CreateRemote(const MachineName: string): INPCameraCollection;
  end;

  TNPCameraCollectionDeviceRemoval = procedure(ASender: TObject; const pCamera: INPCamera) of object;
  TNPCameraCollectionDeviceArrival = procedure(ASender: TObject; const pCamera: INPCamera) of object;
  TNPCameraCollectionFrameAvailableId = procedure(ASender: TObject; Group: Integer; Id: Integer) of object;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TNPCameraCollection
// Help String      : NPCameraCollection Class
// Default Interface: INPCameraCollection
// Def. Intf. DISP? : No
// Event   Interface: _INPCameraCollectionEvents
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TNPCameraCollectionProperties= class;
{$ENDIF}
  TNPCameraCollection = class(TOleServer)
  private
    FOnDeviceRemoval: TNPCameraCollectionDeviceRemoval;
    FOnDeviceArrival: TNPCameraCollectionDeviceArrival;
    FOnFrameAvailableId: TNPCameraCollectionFrameAvailableId;
    FIntf:        INPCameraCollection;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TNPCameraCollectionProperties;
    function      GetServerProperties: TNPCameraCollectionProperties;
{$ENDIF}
    function      GetDefaultInterface: INPCameraCollection;
  protected
    procedure InitServerData; override;
    procedure InvokeEvent(DispID: TDispID; var Params: TVariantArray); override;
    function Get_Count: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: INPCameraCollection);
    procedure Disconnect; override;
    function Item(a_vlIndex: Integer): INPCamera;
    procedure Enum;
    procedure Synchronize;
    property DefaultInterface: INPCameraCollection read GetDefaultInterface;
    property Count: Integer read Get_Count;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TNPCameraCollectionProperties read GetServerProperties;
{$ENDIF}
    property OnDeviceRemoval: TNPCameraCollectionDeviceRemoval read FOnDeviceRemoval write FOnDeviceRemoval;
    property OnDeviceArrival: TNPCameraCollectionDeviceArrival read FOnDeviceArrival write FOnDeviceArrival;
    property OnFrameAvailableId: TNPCameraCollectionFrameAvailableId read FOnFrameAvailableId write FOnFrameAvailableId;
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TNPCameraCollection
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TNPCameraCollectionProperties = class(TPersistent)
  private
    FServer:    TNPCameraCollection;
    function    GetDefaultInterface: INPCameraCollection;
    constructor Create(AServer: TNPCameraCollection);
  protected
    function Get_Count: Integer;
  public
    property DefaultInterface: INPCameraCollection read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoNPCamera provides a Create and CreateRemote method to          
// create instances of the default interface INPCamera exposed by              
// the CoClass NPCamera. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoNPCamera = class
    class function Create: INPCamera;
    class function CreateRemote(const MachineName: string): INPCamera;
  end;

  TNPCameraFrameAvailable = procedure(ASender: TObject; const pCamera: INPCamera) of object;
  TNPCameraSwitchChange = procedure(ASender: TObject; const pCamera: INPCamera; 
                                                      lNewSwitchState: Integer) of object;
  TNPCameraFrameAvailableIdCamera = procedure(ASender: TObject; const pCamera: INPCamera; 
                                                                Group: Integer; Id: Integer) of object;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TNPCamera
// Help String      : NPCamera Class
// Default Interface: INPCamera
// Def. Intf. DISP? : No
// Event   Interface: _INPCameraEvents
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TNPCameraProperties= class;
{$ENDIF}
  TNPCamera = class(TOleServer)
  private
    FOnFrameAvailable: TNPCameraFrameAvailable;
    FOnSwitchChange: TNPCameraSwitchChange;
    FOnFrameAvailableIdCamera: TNPCameraFrameAvailableIdCamera;
    FIntf:        INPCamera;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TNPCameraProperties;
    function      GetServerProperties: TNPCameraProperties;
{$ENDIF}
    function      GetDefaultInterface: INPCamera;
  protected
    procedure InitServerData; override;
    procedure InvokeEvent(DispID: TDispID; var Params: TVariantArray); override;
    function Get_SerialNumber: Integer;
    function Get_Model: Integer;
    function Get_Revision: Integer;
    function Get_Width: Integer;
    function Get_Height: Integer;
    function Get_FrameRate: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: INPCamera);
    procedure Disconnect; override;
    procedure Start;
    procedure Stop;
    procedure Open;
    procedure Close;
    procedure SetLED(lLED: Integer; fOn: WordBool);
    function GetFrame(lTimeout: Integer): INPCameraFrame;
    procedure DrawFrame(const pFrame: INPCameraFrame; hwnd: Integer);
    procedure ResetTrackedObject;
    function GetOption(lOption: Integer): OleVariant;
    procedure SetOption(lOption: Integer; Val: OleVariant);
    function GetFrameById(Id: Integer): INPCameraFrame;
    procedure GetFrameImage(const pFrame: INPCameraFrame; PixelWidth: SYSINT; PixelHeight: SYSINT; 
                            ByteSpan: SYSINT; BitsPerPixel: SYSINT; var Buffer: Byte);
    procedure SetVideo(fOn: WordBool);
    property DefaultInterface: INPCamera read GetDefaultInterface;
    property SerialNumber: Integer read Get_SerialNumber;
    property Model: Integer read Get_Model;
    property Revision: Integer read Get_Revision;
    property Width: Integer read Get_Width;
    property Height: Integer read Get_Height;
    property FrameRate: Integer read Get_FrameRate;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TNPCameraProperties read GetServerProperties;
{$ENDIF}
    property OnFrameAvailable: TNPCameraFrameAvailable read FOnFrameAvailable write FOnFrameAvailable;
    property OnSwitchChange: TNPCameraSwitchChange read FOnSwitchChange write FOnSwitchChange;
    property OnFrameAvailableIdCamera: TNPCameraFrameAvailableIdCamera read FOnFrameAvailableIdCamera write FOnFrameAvailableIdCamera;
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TNPCamera
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TNPCameraProperties = class(TPersistent)
  private
    FServer:    TNPCamera;
    function    GetDefaultInterface: INPCamera;
    constructor Create(AServer: TNPCamera);
  protected
    function Get_SerialNumber: Integer;
    function Get_Model: Integer;
    function Get_Revision: Integer;
    function Get_Width: Integer;
    function Get_Height: Integer;
    function Get_FrameRate: Integer;
  public
    property DefaultInterface: INPCamera read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoNPCameraFrame provides a Create and CreateRemote method to          
// create instances of the default interface INPCameraFrame exposed by              
// the CoClass NPCameraFrame. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoNPCameraFrame = class
    class function Create: INPCameraFrame;
    class function CreateRemote(const MachineName: string): INPCameraFrame;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TNPCameraFrame
// Help String      : NPCameraFrame Class
// Default Interface: INPCameraFrame
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TNPCameraFrameProperties= class;
{$ENDIF}
  TNPCameraFrame = class(TOleServer)
  private
    FIntf:        INPCameraFrame;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TNPCameraFrameProperties;
    function      GetServerProperties: TNPCameraFrameProperties;
{$ENDIF}
    function      GetDefaultInterface: INPCameraFrame;
  protected
    procedure InitServerData; override;
    function Get_Count: Integer;
    function Get_Id: Integer;
    function Get_SwitchState: Integer;
    function Get_IsEmpty: WordBool;
    function Get_IsCorrupt: WordBool;
    function Get_IsGreyscale: WordBool;
    function Get_TimeStamp: OleVariant;
    function Get_TimeStampFrequency: OleVariant;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: INPCameraFrame);
    procedure Disconnect; override;
    function Item(a_vlIndex: Integer): INPObject;
    function GetObjectData(var Buffer: Byte; BufferSize: SYSINT): Integer;
    procedure Free;
    property DefaultInterface: INPCameraFrame read GetDefaultInterface;
    property Count: Integer read Get_Count;
    property Id: Integer read Get_Id;
    property SwitchState: Integer read Get_SwitchState;
    property IsEmpty: WordBool read Get_IsEmpty;
    property IsCorrupt: WordBool read Get_IsCorrupt;
    property IsGreyscale: WordBool read Get_IsGreyscale;
    property TimeStamp: OleVariant read Get_TimeStamp;
    property TimeStampFrequency: OleVariant read Get_TimeStampFrequency;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TNPCameraFrameProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TNPCameraFrame
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TNPCameraFrameProperties = class(TPersistent)
  private
    FServer:    TNPCameraFrame;
    function    GetDefaultInterface: INPCameraFrame;
    constructor Create(AServer: TNPCameraFrame);
  protected
    function Get_Count: Integer;
    function Get_Id: Integer;
    function Get_SwitchState: Integer;
    function Get_IsEmpty: WordBool;
    function Get_IsCorrupt: WordBool;
    function Get_IsGreyscale: WordBool;
    function Get_TimeStamp: OleVariant;
    function Get_TimeStampFrequency: OleVariant;
  public
    property DefaultInterface: INPCameraFrame read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoNPObject provides a Create and CreateRemote method to          
// create instances of the default interface INPObject exposed by              
// the CoClass NPObject. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoNPObject = class
    class function Create: INPObject;
    class function CreateRemote(const MachineName: string): INPObject;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TNPObject
// Help String      : NPObject Class
// Default Interface: INPObject
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TNPObjectProperties= class;
{$ENDIF}
  TNPObject = class(TOleServer)
  private
    FIntf:        INPObject;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TNPObjectProperties;
    function      GetServerProperties: TNPObjectProperties;
{$ENDIF}
    function      GetDefaultInterface: INPObject;
  protected
    procedure InitServerData; override;
    function Get_Area: OleVariant;
    function Get_X: OleVariant;
    function Get_Y: OleVariant;
    function Get_Score: OleVariant;
    function Get_Rank: Integer;
    function Get_Width: Integer;
    function Get_Height: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: INPObject);
    procedure Disconnect; override;
    procedure Transform(const pCamera: INPCamera);
    property DefaultInterface: INPObject read GetDefaultInterface;
    property Area: OleVariant read Get_Area;
    property X: OleVariant read Get_X;
    property Y: OleVariant read Get_Y;
    property Score: OleVariant read Get_Score;
    property Rank: Integer read Get_Rank;
    property Width: Integer read Get_Width;
    property Height: Integer read Get_Height;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TNPObjectProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TNPObject
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TNPObjectProperties = class(TPersistent)
  private
    FServer:    TNPObject;
    function    GetDefaultInterface: INPObject;
    constructor Create(AServer: TNPObject);
  protected
    function Get_Area: OleVariant;
    function Get_X: OleVariant;
    function Get_Y: OleVariant;
    function Get_Score: OleVariant;
    function Get_Rank: Integer;
    function Get_Width: Integer;
    function Get_Height: Integer;
  public
    property DefaultInterface: INPObject read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoNPSmoothing provides a Create and CreateRemote method to          
// create instances of the default interface INPSmoothing exposed by              
// the CoClass NPSmoothing. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoNPSmoothing = class
    class function Create: INPSmoothing;
    class function CreateRemote(const MachineName: string): INPSmoothing;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TNPSmoothing
// Help String      : NPSmoothing Class
// Default Interface: INPSmoothing
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TNPSmoothingProperties= class;
{$ENDIF}
  TNPSmoothing = class(TOleServer)
  private
    FIntf:        INPSmoothing;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TNPSmoothingProperties;
    function      GetServerProperties: TNPSmoothingProperties;
{$ENDIF}
    function      GetDefaultInterface: INPSmoothing;
  protected
    procedure InitServerData; override;
    function Get_Amount: OleVariant;
    procedure Set_Amount(pVal: OleVariant);
    function Get_X: OleVariant;
    function Get_Y: OleVariant;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: INPSmoothing);
    procedure Disconnect; override;
    procedure Update(ValX: OleVariant; ValY: OleVariant);
    procedure Reset;
    property DefaultInterface: INPSmoothing read GetDefaultInterface;
    property Amount: OleVariant read Get_Amount write Set_Amount;
    property X: OleVariant read Get_X;
    property Y: OleVariant read Get_Y;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TNPSmoothingProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TNPSmoothing
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TNPSmoothingProperties = class(TPersistent)
  private
    FServer:    TNPSmoothing;
    function    GetDefaultInterface: INPSmoothing;
    constructor Create(AServer: TNPSmoothing);
  protected
    function Get_Amount: OleVariant;
    procedure Set_Amount(pVal: OleVariant);
    function Get_X: OleVariant;
    function Get_Y: OleVariant;
  public
    property DefaultInterface: INPSmoothing read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoNPVector provides a Create and CreateRemote method to          
// create instances of the default interface INPVector3 exposed by              
// the CoClass NPVector. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoNPVector = class
    class function Create: INPVector3;
    class function CreateRemote(const MachineName: string): INPVector3;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TNPVector
// Help String      : NPVector Class
// Default Interface: INPVector3
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TNPVectorProperties= class;
{$ENDIF}
  TNPVector = class(TOleServer)
  private
    FIntf:        INPVector3;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TNPVectorProperties;
    function      GetServerProperties: TNPVectorProperties;
{$ENDIF}
    function      GetDefaultInterface: INPVector3;
  protected
    procedure InitServerData; override;
    function Get_Yaw: OleVariant;
    function Get_Pitch: OleVariant;
    function Get_Roll: OleVariant;
    function Get_X: OleVariant;
    function Get_Y: OleVariant;
    function Get_Z: OleVariant;
    function Get_dist01: OleVariant;
    procedure Set_dist01(pVal: OleVariant);
    function Get_dist02: OleVariant;
    procedure Set_dist02(pVal: OleVariant);
    function Get_dist12: OleVariant;
    procedure Set_dist12(pVal: OleVariant);
    function Get_distol: OleVariant;
    procedure Set_distol(pVal: OleVariant);
    function Get_Tracking: OleVariant;
    function Get_imagerPixelWidth: OleVariant;
    procedure Set_imagerPixelWidth(pVal: OleVariant);
    function Get_imagerPixelHeight: OleVariant;
    procedure Set_imagerPixelHeight(pVal: OleVariant);
    function Get_imagerMMWidth: OleVariant;
    procedure Set_imagerMMWidth(pVal: OleVariant);
    function Get_imagerMMHeight: OleVariant;
    procedure Set_imagerMMHeight(pVal: OleVariant);
    function Get_imagerMMFocalLength: OleVariant;
    procedure Set_imagerMMFocalLength(pVal: OleVariant);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: INPVector3);
    procedure Disconnect; override;
    procedure Update(const pCamera: INPCamera; const pFrame: INPCameraFrame);
    procedure Reset;
    function GetPoint(nPoint: SYSINT): INPPoint;
    property DefaultInterface: INPVector3 read GetDefaultInterface;
    property Yaw: OleVariant read Get_Yaw;
    property Pitch: OleVariant read Get_Pitch;
    property Roll: OleVariant read Get_Roll;
    property X: OleVariant read Get_X;
    property Y: OleVariant read Get_Y;
    property Z: OleVariant read Get_Z;
    property dist01: OleVariant read Get_dist01 write Set_dist01;
    property dist02: OleVariant read Get_dist02 write Set_dist02;
    property dist12: OleVariant read Get_dist12 write Set_dist12;
    property distol: OleVariant read Get_distol write Set_distol;
    property Tracking: OleVariant read Get_Tracking;
    property imagerPixelWidth: OleVariant read Get_imagerPixelWidth write Set_imagerPixelWidth;
    property imagerPixelHeight: OleVariant read Get_imagerPixelHeight write Set_imagerPixelHeight;
    property imagerMMWidth: OleVariant read Get_imagerMMWidth write Set_imagerMMWidth;
    property imagerMMHeight: OleVariant read Get_imagerMMHeight write Set_imagerMMHeight;
    property imagerMMFocalLength: OleVariant read Get_imagerMMFocalLength write Set_imagerMMFocalLength;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TNPVectorProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TNPVector
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TNPVectorProperties = class(TPersistent)
  private
    FServer:    TNPVector;
    function    GetDefaultInterface: INPVector3;
    constructor Create(AServer: TNPVector);
  protected
    function Get_Yaw: OleVariant;
    function Get_Pitch: OleVariant;
    function Get_Roll: OleVariant;
    function Get_X: OleVariant;
    function Get_Y: OleVariant;
    function Get_Z: OleVariant;
    function Get_dist01: OleVariant;
    procedure Set_dist01(pVal: OleVariant);
    function Get_dist02: OleVariant;
    procedure Set_dist02(pVal: OleVariant);
    function Get_dist12: OleVariant;
    procedure Set_dist12(pVal: OleVariant);
    function Get_distol: OleVariant;
    procedure Set_distol(pVal: OleVariant);
    function Get_Tracking: OleVariant;
    function Get_imagerPixelWidth: OleVariant;
    procedure Set_imagerPixelWidth(pVal: OleVariant);
    function Get_imagerPixelHeight: OleVariant;
    procedure Set_imagerPixelHeight(pVal: OleVariant);
    function Get_imagerMMWidth: OleVariant;
    procedure Set_imagerMMWidth(pVal: OleVariant);
    function Get_imagerMMHeight: OleVariant;
    procedure Set_imagerMMHeight(pVal: OleVariant);
    function Get_imagerMMFocalLength: OleVariant;
    procedure Set_imagerMMFocalLength(pVal: OleVariant);
  public
    property DefaultInterface: INPVector3 read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoNPPoint provides a Create and CreateRemote method to          
// create instances of the default interface INPPoint exposed by              
// the CoClass NPPoint. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoNPPoint = class
    class function Create: INPPoint;
    class function CreateRemote(const MachineName: string): INPPoint;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TNPPoint
// Help String      : NPPoint Class
// Default Interface: INPPoint
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TNPPointProperties= class;
{$ENDIF}
  TNPPoint = class(TOleServer)
  private
    FIntf:        INPPoint;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TNPPointProperties;
    function      GetServerProperties: TNPPointProperties;
{$ENDIF}
    function      GetDefaultInterface: INPPoint;
  protected
    procedure InitServerData; override;
    function Get_X: OleVariant;
    function Get_Y: OleVariant;
    function Get_Z: OleVariant;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: INPPoint);
    procedure Disconnect; override;
    property DefaultInterface: INPPoint read GetDefaultInterface;
    property X: OleVariant read Get_X;
    property Y: OleVariant read Get_Y;
    property Z: OleVariant read Get_Z;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TNPPointProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TNPPoint
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TNPPointProperties = class(TPersistent)
  private
    FServer:    TNPPoint;
    function    GetDefaultInterface: INPPoint;
    constructor Create(AServer: TNPPoint);
  protected
    function Get_X: OleVariant;
    function Get_Y: OleVariant;
    function Get_Z: OleVariant;
  public
    property DefaultInterface: INPPoint read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoNPAvi provides a Create and CreateRemote method to          
// create instances of the default interface INPAvi exposed by              
// the CoClass NPAvi. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoNPAvi = class
    class function Create: INPAvi;
    class function CreateRemote(const MachineName: string): INPAvi;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TNPAvi
// Help String      : NPAvi Class
// Default Interface: INPAvi
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TNPAviProperties= class;
{$ENDIF}
  TNPAvi = class(TOleServer)
  private
    FIntf:        INPAvi;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TNPAviProperties;
    function      GetServerProperties: TNPAviProperties;
{$ENDIF}
    function      GetDefaultInterface: INPAvi;
  protected
    procedure InitServerData; override;
    function Get_FileName: WideString;
    procedure Set_FileName(const pVal: WideString);
    function Get_FrameRate: Integer;
    procedure Set_FrameRate(pVal: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: INPAvi);
    procedure Disconnect; override;
    procedure Start;
    procedure Stop;
    procedure AddFrame(const pCamera: INPCamera; const pFrame: INPCameraFrame);
    property DefaultInterface: INPAvi read GetDefaultInterface;
    property FileName: WideString read Get_FileName write Set_FileName;
    property FrameRate: Integer read Get_FrameRate write Set_FrameRate;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TNPAviProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TNPAvi
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TNPAviProperties = class(TPersistent)
  private
    FServer:    TNPAvi;
    function    GetDefaultInterface: INPAvi;
    constructor Create(AServer: TNPAvi);
  protected
    function Get_FileName: WideString;
    procedure Set_FileName(const pVal: WideString);
    function Get_FrameRate: Integer;
    procedure Set_FrameRate(pVal: Integer);
  public
    property DefaultInterface: INPAvi read GetDefaultInterface;
  published
    property FileName: WideString read Get_FileName write Set_FileName;
    property FrameRate: Integer read Get_FrameRate write Set_FrameRate;
  end;
{$ENDIF}


procedure Register;

resourcestring
  dtlServerPage = 'OptiTrack';

  dtlOcxPage = 'OptiTrack';

implementation

uses ComObj;

class function CoNPCameraCollection.Create: INPCameraCollection;
begin
  Result := CreateComObject(CLASS_NPCameraCollection) as INPCameraCollection;
end;

class function CoNPCameraCollection.CreateRemote(const MachineName: string): INPCameraCollection;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_NPCameraCollection) as INPCameraCollection;
end;

procedure TNPCameraCollection.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{1CA83C6F-70A6-40EB-836F-D9EEC0BD168F}';
    IntfIID:   '{28E501BB-FDD9-46CF-A112-741587110F0E}';
    EventIID:  '{076F9DDA-1422-4B4D-926A-961DF5725B5A}';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TNPCameraCollection.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    ConnectEvents(punk);
    Fintf:= punk as INPCameraCollection;
  end;
end;

procedure TNPCameraCollection.ConnectTo(svrIntf: INPCameraCollection);
begin
  Disconnect;
  FIntf := svrIntf;
  ConnectEvents(FIntf);
end;

procedure TNPCameraCollection.DisConnect;
begin
  if Fintf <> nil then
  begin
    DisconnectEvents(FIntf);
    FIntf := nil;
  end;
end;

function TNPCameraCollection.GetDefaultInterface: INPCameraCollection;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TNPCameraCollection.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TNPCameraCollectionProperties.Create(Self);
{$ENDIF}
end;

destructor TNPCameraCollection.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TNPCameraCollection.GetServerProperties: TNPCameraCollectionProperties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TNPCameraCollection.InvokeEvent(DispID: TDispID; var Params: TVariantArray);
begin
  case DispID of
    -1: Exit;  // DISPID_UNKNOWN
    1: if Assigned(FOnDeviceRemoval) then
         FOnDeviceRemoval(Self, IUnknown(TVarData(Params[0]).VPointer) as INPCamera {const INPCamera});
    2: if Assigned(FOnDeviceArrival) then
         FOnDeviceArrival(Self, IUnknown(TVarData(Params[0]).VPointer) as INPCamera {const INPCamera});
    3: if Assigned(FOnFrameAvailableId) then
         FOnFrameAvailableId(Self,
                             Params[0] {Integer},
                             Params[1] {Integer});
  end; {case DispID}
end;

function TNPCameraCollection.Get_Count: Integer;
begin
    Result := DefaultInterface.Count;
end;

function TNPCameraCollection.Item(a_vlIndex: Integer): INPCamera;
begin
  Result := DefaultInterface.Item(a_vlIndex);
end;

procedure TNPCameraCollection.Enum;
begin
  DefaultInterface.Enum;
end;

procedure TNPCameraCollection.Synchronize;
begin
  DefaultInterface.Synchronize;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TNPCameraCollectionProperties.Create(AServer: TNPCameraCollection);
begin
  inherited Create;
  FServer := AServer;
end;

function TNPCameraCollectionProperties.GetDefaultInterface: INPCameraCollection;
begin
  Result := FServer.DefaultInterface;
end;

function TNPCameraCollectionProperties.Get_Count: Integer;
begin
    Result := DefaultInterface.Count;
end;

{$ENDIF}

class function CoNPCamera.Create: INPCamera;
begin
  Result := CreateComObject(CLASS_NPCamera) as INPCamera;
end;

class function CoNPCamera.CreateRemote(const MachineName: string): INPCamera;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_NPCamera) as INPCamera;
end;

procedure TNPCamera.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{77686C4C-8402-42CE-ADF2-913B53E0A25B}';
    IntfIID:   '{ADE1E272-C86A-460D-B7B9-3051F310E4D0}';
    EventIID:  '{A50B57C5-7472-4F16-BC14-2345B8D24BFD}';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TNPCamera.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    ConnectEvents(punk);
    Fintf:= punk as INPCamera;
  end;
end;

procedure TNPCamera.ConnectTo(svrIntf: INPCamera);
begin
  Disconnect;
  FIntf := svrIntf;
  ConnectEvents(FIntf);
end;

procedure TNPCamera.DisConnect;
begin
  if Fintf <> nil then
  begin
    DisconnectEvents(FIntf);
    FIntf := nil;
  end;
end;

function TNPCamera.GetDefaultInterface: INPCamera;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TNPCamera.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TNPCameraProperties.Create(Self);
{$ENDIF}
end;

destructor TNPCamera.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TNPCamera.GetServerProperties: TNPCameraProperties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TNPCamera.InvokeEvent(DispID: TDispID; var Params: TVariantArray);
begin
  case DispID of
    -1: Exit;  // DISPID_UNKNOWN
    1: if Assigned(FOnFrameAvailable) then
         FOnFrameAvailable(Self, IUnknown(TVarData(Params[0]).VPointer) as INPCamera {const INPCamera});
    2: if Assigned(FOnSwitchChange) then
         FOnSwitchChange(Self,
                         IUnknown(TVarData(Params[0]).VPointer) as INPCamera {const INPCamera},
                         Params[1] {Integer});
    3: if Assigned(FOnFrameAvailableIdCamera) then
         FOnFrameAvailableIdCamera(Self,
                                   IUnknown(TVarData(Params[0]).VPointer) as INPCamera {const INPCamera},
                                   Params[1] {Integer},
                                   Params[2] {Integer});
  end; {case DispID}
end;

function TNPCamera.Get_SerialNumber: Integer;
begin
    Result := DefaultInterface.SerialNumber;
end;

function TNPCamera.Get_Model: Integer;
begin
    Result := DefaultInterface.Model;
end;

function TNPCamera.Get_Revision: Integer;
begin
    Result := DefaultInterface.Revision;
end;

function TNPCamera.Get_Width: Integer;
begin
    Result := DefaultInterface.Width;
end;

function TNPCamera.Get_Height: Integer;
begin
    Result := DefaultInterface.Height;
end;

function TNPCamera.Get_FrameRate: Integer;
begin
    Result := DefaultInterface.FrameRate;
end;

procedure TNPCamera.Start;
begin
  DefaultInterface.Start;
end;

procedure TNPCamera.Stop;
begin
  DefaultInterface.Stop;
end;

procedure TNPCamera.Open;
begin
  DefaultInterface.Open;
end;

procedure TNPCamera.Close;
begin
  DefaultInterface.Close;
end;

procedure TNPCamera.SetLED(lLED: Integer; fOn: WordBool);
begin
  DefaultInterface.SetLED(lLED, fOn);
end;

function TNPCamera.GetFrame(lTimeout: Integer): INPCameraFrame;
begin
  Result := DefaultInterface.GetFrame(lTimeout);
end;

procedure TNPCamera.DrawFrame(const pFrame: INPCameraFrame; hwnd: Integer);
begin
  DefaultInterface.DrawFrame(pFrame, hwnd);
end;

procedure TNPCamera.ResetTrackedObject;
begin
  DefaultInterface.ResetTrackedObject;
end;

function TNPCamera.GetOption(lOption: Integer): OleVariant;
begin
  Result := DefaultInterface.GetOption(lOption);
end;

procedure TNPCamera.SetOption(lOption: Integer; Val: OleVariant);
begin
  DefaultInterface.SetOption(lOption, Val);
end;

function TNPCamera.GetFrameById(Id: Integer): INPCameraFrame;
begin
  Result := DefaultInterface.GetFrameById(Id);
end;

procedure TNPCamera.GetFrameImage(const pFrame: INPCameraFrame; PixelWidth: SYSINT; 
                                  PixelHeight: SYSINT; ByteSpan: SYSINT; BitsPerPixel: SYSINT; 
                                  var Buffer: Byte);
begin
  DefaultInterface.GetFrameImage(pFrame, PixelWidth, PixelHeight, ByteSpan, BitsPerPixel, Buffer);
end;

procedure TNPCamera.SetVideo(fOn: WordBool);
begin
  DefaultInterface.SetVideo(fOn);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TNPCameraProperties.Create(AServer: TNPCamera);
begin
  inherited Create;
  FServer := AServer;
end;

function TNPCameraProperties.GetDefaultInterface: INPCamera;
begin
  Result := FServer.DefaultInterface;
end;

function TNPCameraProperties.Get_SerialNumber: Integer;
begin
    Result := DefaultInterface.SerialNumber;
end;

function TNPCameraProperties.Get_Model: Integer;
begin
    Result := DefaultInterface.Model;
end;

function TNPCameraProperties.Get_Revision: Integer;
begin
    Result := DefaultInterface.Revision;
end;

function TNPCameraProperties.Get_Width: Integer;
begin
    Result := DefaultInterface.Width;
end;

function TNPCameraProperties.Get_Height: Integer;
begin
    Result := DefaultInterface.Height;
end;

function TNPCameraProperties.Get_FrameRate: Integer;
begin
    Result := DefaultInterface.FrameRate;
end;

{$ENDIF}

class function CoNPCameraFrame.Create: INPCameraFrame;
begin
  Result := CreateComObject(CLASS_NPCameraFrame) as INPCameraFrame;
end;

class function CoNPCameraFrame.CreateRemote(const MachineName: string): INPCameraFrame;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_NPCameraFrame) as INPCameraFrame;
end;

procedure TNPCameraFrame.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{4656500B-863B-48F6-8725-AB029769EA89}';
    IntfIID:   '{73CF9A64-837A-4F05-9BF6-8A253CE16E46}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TNPCameraFrame.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as INPCameraFrame;
  end;
end;

procedure TNPCameraFrame.ConnectTo(svrIntf: INPCameraFrame);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TNPCameraFrame.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TNPCameraFrame.GetDefaultInterface: INPCameraFrame;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TNPCameraFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TNPCameraFrameProperties.Create(Self);
{$ENDIF}
end;

destructor TNPCameraFrame.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TNPCameraFrame.GetServerProperties: TNPCameraFrameProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TNPCameraFrame.Get_Count: Integer;
begin
    Result := DefaultInterface.Count;
end;

function TNPCameraFrame.Get_Id: Integer;
begin
    Result := DefaultInterface.Id;
end;

function TNPCameraFrame.Get_SwitchState: Integer;
begin
    Result := DefaultInterface.SwitchState;
end;

function TNPCameraFrame.Get_IsEmpty: WordBool;
begin
    Result := DefaultInterface.IsEmpty;
end;

function TNPCameraFrame.Get_IsCorrupt: WordBool;
begin
    Result := DefaultInterface.IsCorrupt;
end;

function TNPCameraFrame.Get_IsGreyscale: WordBool;
begin
    Result := DefaultInterface.IsGreyscale;
end;

function TNPCameraFrame.Get_TimeStamp: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.TimeStamp;
end;

function TNPCameraFrame.Get_TimeStampFrequency: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.TimeStampFrequency;
end;

function TNPCameraFrame.Item(a_vlIndex: Integer): INPObject;
begin
  Result := DefaultInterface.Item(a_vlIndex);
end;

function TNPCameraFrame.GetObjectData(var Buffer: Byte; BufferSize: SYSINT): Integer;
begin
  Result := DefaultInterface.GetObjectData(Buffer, BufferSize);
end;

procedure TNPCameraFrame.Free;
begin
  DefaultInterface.Free;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TNPCameraFrameProperties.Create(AServer: TNPCameraFrame);
begin
  inherited Create;
  FServer := AServer;
end;

function TNPCameraFrameProperties.GetDefaultInterface: INPCameraFrame;
begin
  Result := FServer.DefaultInterface;
end;

function TNPCameraFrameProperties.Get_Count: Integer;
begin
    Result := DefaultInterface.Count;
end;

function TNPCameraFrameProperties.Get_Id: Integer;
begin
    Result := DefaultInterface.Id;
end;

function TNPCameraFrameProperties.Get_SwitchState: Integer;
begin
    Result := DefaultInterface.SwitchState;
end;

function TNPCameraFrameProperties.Get_IsEmpty: WordBool;
begin
    Result := DefaultInterface.IsEmpty;
end;

function TNPCameraFrameProperties.Get_IsCorrupt: WordBool;
begin
    Result := DefaultInterface.IsCorrupt;
end;

function TNPCameraFrameProperties.Get_IsGreyscale: WordBool;
begin
    Result := DefaultInterface.IsGreyscale;
end;

function TNPCameraFrameProperties.Get_TimeStamp: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.TimeStamp;
end;

function TNPCameraFrameProperties.Get_TimeStampFrequency: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.TimeStampFrequency;
end;

{$ENDIF}

class function CoNPObject.Create: INPObject;
begin
  Result := CreateComObject(CLASS_NPObject) as INPObject;
end;

class function CoNPObject.CreateRemote(const MachineName: string): INPObject;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_NPObject) as INPObject;
end;

procedure TNPObject.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{B696B174-5B53-4DDD-B78B-CA75C072C85A}';
    IntfIID:   '{6E439CE4-AB0D-44B8-BF1E-644C5CC489DC}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TNPObject.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as INPObject;
  end;
end;

procedure TNPObject.ConnectTo(svrIntf: INPObject);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TNPObject.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TNPObject.GetDefaultInterface: INPObject;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TNPObject.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TNPObjectProperties.Create(Self);
{$ENDIF}
end;

destructor TNPObject.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TNPObject.GetServerProperties: TNPObjectProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TNPObject.Get_Area: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.Area;
end;

function TNPObject.Get_X: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.X;
end;

function TNPObject.Get_Y: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.Y;
end;

function TNPObject.Get_Score: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.Score;
end;

function TNPObject.Get_Rank: Integer;
begin
    Result := DefaultInterface.Rank;
end;

function TNPObject.Get_Width: Integer;
begin
    Result := DefaultInterface.Width;
end;

function TNPObject.Get_Height: Integer;
begin
    Result := DefaultInterface.Height;
end;

procedure TNPObject.Transform(const pCamera: INPCamera);
begin
  DefaultInterface.Transform(pCamera);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TNPObjectProperties.Create(AServer: TNPObject);
begin
  inherited Create;
  FServer := AServer;
end;

function TNPObjectProperties.GetDefaultInterface: INPObject;
begin
  Result := FServer.DefaultInterface;
end;

function TNPObjectProperties.Get_Area: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.Area;
end;

function TNPObjectProperties.Get_X: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.X;
end;

function TNPObjectProperties.Get_Y: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.Y;
end;

function TNPObjectProperties.Get_Score: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.Score;
end;

function TNPObjectProperties.Get_Rank: Integer;
begin
    Result := DefaultInterface.Rank;
end;

function TNPObjectProperties.Get_Width: Integer;
begin
    Result := DefaultInterface.Width;
end;

function TNPObjectProperties.Get_Height: Integer;
begin
    Result := DefaultInterface.Height;
end;

{$ENDIF}

class function CoNPSmoothing.Create: INPSmoothing;
begin
  Result := CreateComObject(CLASS_NPSmoothing) as INPSmoothing;
end;

class function CoNPSmoothing.CreateRemote(const MachineName: string): INPSmoothing;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_NPSmoothing) as INPSmoothing;
end;

procedure TNPSmoothing.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{B4CA710D-9B17-42C3-846B-FC16876B6D5E}';
    IntfIID:   '{0EDD3505-855C-4D91-A9C1-DCBEC1B816FA}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TNPSmoothing.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as INPSmoothing;
  end;
end;

procedure TNPSmoothing.ConnectTo(svrIntf: INPSmoothing);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TNPSmoothing.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TNPSmoothing.GetDefaultInterface: INPSmoothing;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TNPSmoothing.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TNPSmoothingProperties.Create(Self);
{$ENDIF}
end;

destructor TNPSmoothing.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TNPSmoothing.GetServerProperties: TNPSmoothingProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TNPSmoothing.Get_Amount: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.Amount;
end;

procedure TNPSmoothing.Set_Amount(pVal: OleVariant);
begin
  DefaultInterface.Set_Amount(pVal);
end;

function TNPSmoothing.Get_X: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.X;
end;

function TNPSmoothing.Get_Y: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.Y;
end;

procedure TNPSmoothing.Update(ValX: OleVariant; ValY: OleVariant);
begin
  DefaultInterface.Update(ValX, ValY);
end;

procedure TNPSmoothing.Reset;
begin
  DefaultInterface.Reset;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TNPSmoothingProperties.Create(AServer: TNPSmoothing);
begin
  inherited Create;
  FServer := AServer;
end;

function TNPSmoothingProperties.GetDefaultInterface: INPSmoothing;
begin
  Result := FServer.DefaultInterface;
end;

function TNPSmoothingProperties.Get_Amount: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.Amount;
end;

procedure TNPSmoothingProperties.Set_Amount(pVal: OleVariant);
begin
  DefaultInterface.Set_Amount(pVal);
end;

function TNPSmoothingProperties.Get_X: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.X;
end;

function TNPSmoothingProperties.Get_Y: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.Y;
end;

{$ENDIF}

class function CoNPVector.Create: INPVector3;
begin
  Result := CreateComObject(CLASS_NPVector) as INPVector3;
end;

class function CoNPVector.CreateRemote(const MachineName: string): INPVector3;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_NPVector) as INPVector3;
end;

procedure TNPVector.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{FE7D5FB0-0560-49ED-BF49-CE9996C62A6B}';
    IntfIID:   '{9124C9AA-9296-4E89-973D-4F3C502E36CA}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TNPVector.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as INPVector3;
  end;
end;

procedure TNPVector.ConnectTo(svrIntf: INPVector3);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TNPVector.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TNPVector.GetDefaultInterface: INPVector3;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TNPVector.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TNPVectorProperties.Create(Self);
{$ENDIF}
end;

destructor TNPVector.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TNPVector.GetServerProperties: TNPVectorProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TNPVector.Get_Yaw: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.Yaw;
end;

function TNPVector.Get_Pitch: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.Pitch;
end;

function TNPVector.Get_Roll: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.Roll;
end;

function TNPVector.Get_X: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.X;
end;

function TNPVector.Get_Y: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.Y;
end;

function TNPVector.Get_Z: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.Z;
end;

function TNPVector.Get_dist01: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.dist01;
end;

procedure TNPVector.Set_dist01(pVal: OleVariant);
begin
  DefaultInterface.Set_dist01(pVal);
end;

function TNPVector.Get_dist02: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.dist02;
end;

procedure TNPVector.Set_dist02(pVal: OleVariant);
begin
  DefaultInterface.Set_dist02(pVal);
end;

function TNPVector.Get_dist12: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.dist12;
end;

procedure TNPVector.Set_dist12(pVal: OleVariant);
begin
  DefaultInterface.Set_dist12(pVal);
end;

function TNPVector.Get_distol: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.distol;
end;

procedure TNPVector.Set_distol(pVal: OleVariant);
begin
  DefaultInterface.Set_distol(pVal);
end;

function TNPVector.Get_Tracking: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.Tracking;
end;

function TNPVector.Get_imagerPixelWidth: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.imagerPixelWidth;
end;

procedure TNPVector.Set_imagerPixelWidth(pVal: OleVariant);
begin
  DefaultInterface.Set_imagerPixelWidth(pVal);
end;

function TNPVector.Get_imagerPixelHeight: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.imagerPixelHeight;
end;

procedure TNPVector.Set_imagerPixelHeight(pVal: OleVariant);
begin
  DefaultInterface.Set_imagerPixelHeight(pVal);
end;

function TNPVector.Get_imagerMMWidth: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.imagerMMWidth;
end;

procedure TNPVector.Set_imagerMMWidth(pVal: OleVariant);
begin
  DefaultInterface.Set_imagerMMWidth(pVal);
end;

function TNPVector.Get_imagerMMHeight: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.imagerMMHeight;
end;

procedure TNPVector.Set_imagerMMHeight(pVal: OleVariant);
begin
  DefaultInterface.Set_imagerMMHeight(pVal);
end;

function TNPVector.Get_imagerMMFocalLength: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.imagerMMFocalLength;
end;

procedure TNPVector.Set_imagerMMFocalLength(pVal: OleVariant);
begin
  DefaultInterface.Set_imagerMMFocalLength(pVal);
end;

procedure TNPVector.Update(const pCamera: INPCamera; const pFrame: INPCameraFrame);
begin
  DefaultInterface.Update(pCamera, pFrame);
end;

procedure TNPVector.Reset;
begin
  DefaultInterface.Reset;
end;

function TNPVector.GetPoint(nPoint: SYSINT): INPPoint;
begin
  Result := DefaultInterface.GetPoint(nPoint);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TNPVectorProperties.Create(AServer: TNPVector);
begin
  inherited Create;
  FServer := AServer;
end;

function TNPVectorProperties.GetDefaultInterface: INPVector3;
begin
  Result := FServer.DefaultInterface;
end;

function TNPVectorProperties.Get_Yaw: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.Yaw;
end;

function TNPVectorProperties.Get_Pitch: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.Pitch;
end;

function TNPVectorProperties.Get_Roll: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.Roll;
end;

function TNPVectorProperties.Get_X: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.X;
end;

function TNPVectorProperties.Get_Y: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.Y;
end;

function TNPVectorProperties.Get_Z: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.Z;
end;

function TNPVectorProperties.Get_dist01: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.dist01;
end;

procedure TNPVectorProperties.Set_dist01(pVal: OleVariant);
begin
  DefaultInterface.Set_dist01(pVal);
end;

function TNPVectorProperties.Get_dist02: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.dist02;
end;

procedure TNPVectorProperties.Set_dist02(pVal: OleVariant);
begin
  DefaultInterface.Set_dist02(pVal);
end;

function TNPVectorProperties.Get_dist12: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.dist12;
end;

procedure TNPVectorProperties.Set_dist12(pVal: OleVariant);
begin
  DefaultInterface.Set_dist12(pVal);
end;

function TNPVectorProperties.Get_distol: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.distol;
end;

procedure TNPVectorProperties.Set_distol(pVal: OleVariant);
begin
  DefaultInterface.Set_distol(pVal);
end;

function TNPVectorProperties.Get_Tracking: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.Tracking;
end;

function TNPVectorProperties.Get_imagerPixelWidth: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.imagerPixelWidth;
end;

procedure TNPVectorProperties.Set_imagerPixelWidth(pVal: OleVariant);
begin
  DefaultInterface.Set_imagerPixelWidth(pVal);
end;

function TNPVectorProperties.Get_imagerPixelHeight: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.imagerPixelHeight;
end;

procedure TNPVectorProperties.Set_imagerPixelHeight(pVal: OleVariant);
begin
  DefaultInterface.Set_imagerPixelHeight(pVal);
end;

function TNPVectorProperties.Get_imagerMMWidth: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.imagerMMWidth;
end;

procedure TNPVectorProperties.Set_imagerMMWidth(pVal: OleVariant);
begin
  DefaultInterface.Set_imagerMMWidth(pVal);
end;

function TNPVectorProperties.Get_imagerMMHeight: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.imagerMMHeight;
end;

procedure TNPVectorProperties.Set_imagerMMHeight(pVal: OleVariant);
begin
  DefaultInterface.Set_imagerMMHeight(pVal);
end;

function TNPVectorProperties.Get_imagerMMFocalLength: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.imagerMMFocalLength;
end;

procedure TNPVectorProperties.Set_imagerMMFocalLength(pVal: OleVariant);
begin
  DefaultInterface.Set_imagerMMFocalLength(pVal);
end;

{$ENDIF}

class function CoNPPoint.Create: INPPoint;
begin
  Result := CreateComObject(CLASS_NPPoint) as INPPoint;
end;

class function CoNPPoint.CreateRemote(const MachineName: string): INPPoint;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_NPPoint) as INPPoint;
end;

procedure TNPPoint.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{FE7D5FB2-0560-49ED-BF49-CE9996C62A6B}';
    IntfIID:   '{9124C9F0-9296-4E89-973D-4F3C502E36CA}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TNPPoint.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as INPPoint;
  end;
end;

procedure TNPPoint.ConnectTo(svrIntf: INPPoint);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TNPPoint.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TNPPoint.GetDefaultInterface: INPPoint;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TNPPoint.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TNPPointProperties.Create(Self);
{$ENDIF}
end;

destructor TNPPoint.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TNPPoint.GetServerProperties: TNPPointProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TNPPoint.Get_X: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.X;
end;

function TNPPoint.Get_Y: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.Y;
end;

function TNPPoint.Get_Z: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.Z;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TNPPointProperties.Create(AServer: TNPPoint);
begin
  inherited Create;
  FServer := AServer;
end;

function TNPPointProperties.GetDefaultInterface: INPPoint;
begin
  Result := FServer.DefaultInterface;
end;

function TNPPointProperties.Get_X: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.X;
end;

function TNPPointProperties.Get_Y: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.Y;
end;

function TNPPointProperties.Get_Z: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.Z;
end;

{$ENDIF}

class function CoNPAvi.Create: INPAvi;
begin
  Result := CreateComObject(CLASS_NPAvi) as INPAvi;
end;

class function CoNPAvi.CreateRemote(const MachineName: string): INPAvi;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_NPAvi) as INPAvi;
end;

procedure TNPAvi.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{FE7D5FB3-0560-49ED-BF49-CE9996C62A6B}';
    IntfIID:   '{9124CA00-9296-4E89-973D-4F3C502E36CA}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TNPAvi.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as INPAvi;
  end;
end;

procedure TNPAvi.ConnectTo(svrIntf: INPAvi);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TNPAvi.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TNPAvi.GetDefaultInterface: INPAvi;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TNPAvi.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TNPAviProperties.Create(Self);
{$ENDIF}
end;

destructor TNPAvi.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TNPAvi.GetServerProperties: TNPAviProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TNPAvi.Get_FileName: WideString;
begin
    Result := DefaultInterface.FileName;
end;

procedure TNPAvi.Set_FileName(const pVal: WideString);
  { Warning: The property FileName has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.FileName := pVal;
end;

function TNPAvi.Get_FrameRate: Integer;
begin
    Result := DefaultInterface.FrameRate;
end;

procedure TNPAvi.Set_FrameRate(pVal: Integer);
begin
  DefaultInterface.Set_FrameRate(pVal);
end;

procedure TNPAvi.Start;
begin
  DefaultInterface.Start;
end;

procedure TNPAvi.Stop;
begin
  DefaultInterface.Stop;
end;

procedure TNPAvi.AddFrame(const pCamera: INPCamera; const pFrame: INPCameraFrame);
begin
  DefaultInterface.AddFrame(pCamera, pFrame);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TNPAviProperties.Create(AServer: TNPAvi);
begin
  inherited Create;
  FServer := AServer;
end;

function TNPAviProperties.GetDefaultInterface: INPAvi;
begin
  Result := FServer.DefaultInterface;
end;

function TNPAviProperties.Get_FileName: WideString;
begin
    Result := DefaultInterface.FileName;
end;

procedure TNPAviProperties.Set_FileName(const pVal: WideString);
  { Warning: The property FileName has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.FileName := pVal;
end;

function TNPAviProperties.Get_FrameRate: Integer;
begin
    Result := DefaultInterface.FrameRate;
end;

procedure TNPAviProperties.Set_FrameRate(pVal: Integer);
begin
  DefaultInterface.Set_FrameRate(pVal);
end;

{$ENDIF}

procedure Register;
begin
  RegisterComponents(dtlServerPage, [TNPCameraCollection, TNPCamera, TNPCameraFrame, TNPObject, 
    TNPSmoothing, TNPVector, TNPPoint, TNPAvi]);
end;

end.

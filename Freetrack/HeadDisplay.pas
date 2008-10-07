unit HeadDisplay;

interface


uses Windows, Classes, ExtCtrls, SysUtils, Controls, Math,
     Direct3D9, D3DX9, DirectInput, DirectShow9, DSPack,  DSUtil, Response, Parameters, DKLang;


type
  THeadDisplay = class (TPanel)
  private
    d3d9: IDirect3D9;
    d3ddev9: IDirect3DDevice9;
    g_pArrowMesh: ID3DXMesh;
    Material: TD3DMaterial9;
    FRespMax: array[TDOF] of Single;
    matHeadRotTrans, matHeadOffsetRotTrans, matHeadTrans, matScaleText, matScale2Text,
    viewMatrix, matProj: TD3DXMatrix;
    xTextMesh, yTextMesh, zTextMesh : ID3DXMesh;
    xlimitMesh, ylimitMesh, zlimitMesh : ID3DXMesh;
    sphereMesh, earthMesh : ID3DXMesh;
    pointerMesh, xAxisHeadMesh, yAxisHeadMesh, zAxisHeadMesh,
    xAxisMesh, yAxisMesh, zAxisMesh : ID3DXMesh;
    FPSText : ID3DXFont;
    FPerspective : TPerspectives;
    FHeadAids : array[THeadAids] of Boolean;
    vbuffer: IDirect3DVertexBuffer9;
    fOwner: TObject;
    PanelRect : TRect;
    CurTickRend, LastTickRend, FrameCountRend, ScreenFPSRend : Integer;
    CurTickPose, LastTickPose, FrameCountPose, ScreenFPSPose : Integer;
    FResized : Boolean;

    procedure LoadMeshFromResource;
    procedure SetupViewAndProjection;
    procedure DefineScreenFormat;
    procedure GetPresentationParams(var d3dpp: TD3DPRESENT_PARAMETERS);
    procedure SetHeadAids(aHeadAid : THeadAids; Value : Boolean);
    procedure SetRespMax(aDOF : TDOF; Value : Single);
  public
    Zooming, Portal : Boolean;
    procedure ChangePerspective(perspective : TPerspectives);
    constructor Create(AOwner :  TComponent); override;
    Destructor Destroy;override;
    procedure Attitude(yaw, pitch, roll, PanX, PanY, PanZ: Single);
    procedure RestoreAttitude(yaw, pitch, roll, PanX, PanY, PanZ: Single);
    procedure Redraw3D;
    procedure Reset;
    property HeadAids[aHeadAid : THeadAids] : Boolean write SetHeadAids;
    property RespMax[aDOF : TDOF] : Single write SetRespMax;
    property Resized : Boolean write FResized;

  end;

var
  HeadPanel : THeadDisplay;

{$R head.res}

implementation

type
  CUSTOMVERTEX = record
    x, y, z : Single;
    nx, ny, nz : Single;
    color : TD3DColor;
  end;

const
  ABS_LIMIT = 1.7;
  DX_PAN_SCALE = 0.5;


{
*********************************************************** THeadDisplay ***********************************************************
}
{-


}
constructor THeadDisplay.Create(AOwner :  TComponent);
var
  d3dpp: TD3DPRESENT_PARAMETERS;
  //light0: TD3DLIGHT9;
  ahdc : HDC;
  font : Hfont;
begin
  fOwner := AOwner as TPanel;

  d3d9:= Direct3DCreate9( D3D_SDK_VERSION );
  if d3d9 = nil then begin
    (fOwner as TPanel).Caption := DKLangConstW('S_ERROR_3DSCENE_CREATION');
    Abort;
  end else
    (fOwner as TPanel).Caption := '';

  inherited;
  if AOwner is TWincontrol then begin
    Parent := AOwner as TWinControl;
    Align := alClient;
  end;

  GetPresentationParams(d3dpp);

  // Define screen format
  {if ( d3d9.GetAdapterDisplayMode( D3DADAPTER_DEFAULT, d3ddm ) <> D3D_OK ) then
    Raise Exception.Create('Failed to get display mode !');

  ZeroMemory( @d3dpp, sizeof( d3dpp ) );

  d3dpp.Windowed := TRUE;
  d3dpp.SwapEffect := D3DSWAPEFFECT_DISCARD;
  d3dpp.BackBufferFormat := d3ddm.Format;
  d3dpp.EnableAutoDepthStencil := TRUE;
  d3dpp.AutoDepthStencilFormat := D3DFMT_D16;}

  if ( d3d9.CreateDevice(D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL, Handle,
                         D3DCREATE_SOFTWARE_VERTEXPROCESSING, @d3dpp, d3ddev9 ) <> D3D_OK ) then begin
    (fOwner as TPanel).Caption := DKLangConstW('S_ERROR_3DSCENE_INI');
    Abort;
  end else
    (fOwner as TPanel).Caption := '';

  DefineScreenFormat;
  {d3ddev9.SetRenderState(D3DRS_LIGHTING,  iTrue);
  
  d3dDev9.SetRenderState(D3DRS_AMBIENT, $00202020);
  d3dDev9.SetRenderState(D3DRS_SPECULARENABLE, iTRUE ) ;
  
  d3dDev9.SetRenderState(D3DRS_FILLMODE, D3DFILL_SOLID);
  d3ddev9.SetRenderState(D3DRS_ZENABLE, iTRUE );
  d3ddev9.SetRenderState(D3DRS_CULLMODE, D3DCULL_NONE );
  
  // Set light 0 to be a pure white directional light
  ZeroMemory( @light0, sizeof(D3DLIGHT9) );
  light0._Type := D3DLIGHT_DIRECTIONAL;
  light0.Direction := D3DXVECTOR3( 1.0, 1.0, 1.0);
  light0.Diffuse.r := 1.0;
  light0.Diffuse.g := 1.0;
  light0.Diffuse.b := 1.0;
  light0.Diffuse.a := 1.0;
  d3dDev9.SetLight(0, light0);

  d3dDev9.LightEnable(0, TRUE);}

  D3DXCreateSphere(d3ddev9, 5.1, 30, 30, sphereMesh, nil);
  D3DXCreateBox(d3ddev9, 0.05, 0.05, 8, pointerMesh, nil);
  D3DXCreateBox(d3ddev9, 20, 0.05, 0.05, xAxisHeadMesh, nil);
  D3DXCreateBox(d3ddev9, 0.05, 20, 0.05, yAxisHeadMesh, nil);
  D3DXCreateBox(d3ddev9, 0.05, 0.05, 20, zAxisHeadMesh, nil);
  D3DXCreateBox(d3ddev9, 1000, 0.01, 0.01, xAxisMesh, nil);
  D3DXCreateBox(d3ddev9, 0.01, 1000, 0.01, yAxisMesh, nil);
  D3DXCreateBox(d3ddev9, 0.01, 0.01, 1000, zAxisMesh, nil);
  D3DXCreateBox(d3ddev9, 10000, 2, 10000, earthMesh, nil);

  D3DXCreateBox(d3ddev9, 2, 0.1, 0.1, xlimitMesh, nil);
  D3DXCreateBox(d3ddev9, 0.1, 2, 0.1, ylimitMesh, nil);
  D3DXCreateBox(d3ddev9, 0.1, 0.1, 2, zlimitMesh, nil);

  //xTextFont.DrawTextA('This is text', 1,
  ahdc := CreateCompatibleDC(0);

  font := CreateFont(10,         //Height
                   0,          //Width
                   0,          //Escapement
                   0,          //Orientation
                   FW_NORMAL,  //Weight
                   0,      //Italic
                   0,      //Underline
                   0,      //Strikeout
                   DEFAULT_CHARSET,//Charset 
                   OUT_DEFAULT_PRECIS,  //Output Precision
                   CLIP_DEFAULT_PRECIS, //Clipping Precision
                   DEFAULT_QUALITY,     //Quality
                   DEFAULT_PITCH or FF_DONTCARE, //Pitch and Family
                   'Arial');

  SelectObject(ahdc, font);

  D3DXCreateText(d3ddev9, ahdc, 'X', 0.01, 0.1, xTextMesh, nil, nil);
  D3DXCreateText(d3ddev9, ahdc, 'Y', 0.01, 0.1, yTextMesh, nil, nil);
  D3DXCreateText(d3ddev9, ahdc, 'Z', 0.01, 0.1, zTextMesh, nil, nil);

  D3DXCreateFont( d3ddev9,
                  40,
                  0,
                  FW_BOLD,
                  1,
                  False,
                  DEFAULT_CHARSET,
                  OUT_DEFAULT_PRECIS,
                  DEFAULT_QUALITY,
                  DEFAULT_PITCH or FF_DONTCARE,
                  'Arial',
                  FPSText);

  SetRect(PanelRect, 0, 0, width, height);

  D3DXMatrixScaling(matScaleText, 0.3, 0.3, 0.3);
  D3DXMatrixScaling(matScale2Text, 0.4, 0.4, 0.4);

  LoadMeshFromResource;

  SetupViewAndProjection;
end;

procedure THeadDisplay.GetPresentationParams(var d3dpp: TD3DPRESENT_PARAMETERS);
var
  d3ddm : TD3DDISPLAYMODE;
begin
  // Define screen format
  if ( d3d9.GetAdapterDisplayMode( D3DADAPTER_DEFAULT, d3ddm ) <> D3D_OK ) then
    (fOwner as TPanel).Caption := DKLangConstW('S_ERROR_3DSCENE_DISPLAYMODE')
  else
    (fOwner as TPanel).Caption := '';

    //Raise Exception.Create('Failed to get display mode !');

  ZeroMemory( @d3dpp, sizeof( d3dpp ) );

  d3dpp.Windowed := TRUE;
  d3dpp.SwapEffect := D3DSWAPEFFECT_DISCARD;
  d3dpp.BackBufferFormat := d3ddm.Format;
  d3dpp.EnableAutoDepthStencil := TRUE;
  d3dpp.AutoDepthStencilFormat := D3DFMT_D16;
  d3dpp.PresentationInterval := D3DPRESENT_INTERVAL_DEFAULT; // vsync on
end;
{-


}
procedure THeadDisplay.Attitude(yaw, pitch, roll, PanX, PanY, PanZ: Single);
var
    up, look, right, position : TD3DXVector3;
    yawMatrix, pitchMatrix, rollMatrix, matHeadOffset, matRot : TD3DXMatrix;
    fov : Single;

begin

  if FHeadAids[aidPoseFPS] then begin
    CurTickPose := GetTickCount;
    if (CurTickPose > LastTickPose) then begin
      ScreenFPSPose := FrameCountPose;
      LastTickPose := CurTickPose + 1000;
      FrameCountPose := 0;
    end else
      inc(FrameCountPose);
  end;

  PanX := PanX * DX_PAN_SCALE;
  PanY := PanY * DX_PAN_SCALE;
  PanZ := PanZ * DX_PAN_SCALE;

  D3DXMatrixTranslation(matHeadOffset, 0, -1, 0);
  D3DXMatrixRotationYawPitchRoll(matRot, -Yaw, Pitch, -Roll);
  D3DXMatrixTranslation(matHeadTrans, PanX, PanY, PanZ);

  // order important
  D3DXMatrixmultiply (matHeadOffsetRotTrans, matHeadOffset, matRot);
  D3DXMatrixmultiply (matHeadOffsetRotTrans, matHeadOffsetRotTrans, matHeadTrans);
  D3DXMatrixmultiply (matHeadRotTrans, matRot, matHeadTrans);


  fov := D3DX_PI/4;
  if FPerspective = pFirstPerson then begin

    up := D3DXVector3(0.0, 1.0,  0.0);
    look := D3DXVector3(0.0, 0.0,  -1.0);
    right := D3DXVector3( 1.0, 0.0, 0.0);

    D3DXMatrixRotationAxis(yawMatrix, up, yaw);
    D3DXVec3TransformCoord(look, look, yawMatrix);
    D3DXVec3TransformCoord(right, right, yawMatrix);

    D3DXMatrixRotationAxis(pitchMatrix, right, pitch);
    D3DXVec3TransformCoord(look, look, pitchMatrix);
    D3DXVec3TransformCoord(up, up, pitchMatrix);

    D3DXMatrixRotationAxis(rollMatrix, look, -roll);
    D3DXVec3TransformCoord(right, right, rollMatrix);
    D3DXVec3TransformCoord(up, up, rollMatrix);

    D3DXMatrixIdentity(viewMatrix);

    viewMatrix._11 := right.x; viewMatrix._12 := up.x; viewMatrix._13 := look.x;
    viewMatrix._21 := right.y; viewMatrix._22 := up.y; viewMatrix._23 := look.y;
    viewMatrix._31 := right.z; viewMatrix._32 := up.z; viewMatrix._33 := look.z;

    if not Zooming or Portal then
      position := D3DXVector3(PanX, -PanY,  -PanZ);

    if Portal then
      PanZ  := -0.5 * PanZ;

    if Zooming then
      position := D3DXVector3(PanX, -PanY,  0);

    if Zooming or Portal then begin
      if PanZ < -0.01 then
        fov := (D3DX_PI/4) / (1 - (PanZ + 0.01) * 3)
      else if PanZ > 0.01 then
        fov := (D3DX_PI/4) * (1 + (PanZ - 0.01));
      if (fov <= 0) then
        fov := 0;
      if (fov >= (3 * D3DX_PI/4)) then
        fov := 3 * (D3DX_PI/4);
    end;

    viewMatrix._41 := D3DXVec3Dot( position, right );
    viewMatrix._42 := D3DXVec3Dot( position, up );
    viewMatrix._43 := D3DXVec3Dot( position, look );
  end;

  D3DXMatrixPerspectiveFovLH(matProj, fov, width/height, 0.1, 10000.0);

end;

{-


}
procedure THeadDisplay.LoadMeshFromResource;
var
  pTempMesh: ID3DXMesh;
  rgdwAdjacency: PDWORD;
begin
  if D3DXLoadMeshFromXResource(hInstance, 'HEAD', RT_RCDATA, D3DXMESH_SYSTEMMEM, d3ddev9, nil, nil, nil, nil, g_pArrowMesh) <> D3D_OK then
    exit;
  
  // Make sure there are normals which are required for lighting
  if (g_pArrowMesh.GetFVF and D3DFVF_NORMAL = 0) then begin
    g_pArrowMesh.CloneMeshFVF(g_pArrowMesh.GetOptions,
                              g_pArrowMesh.GetFVF or D3DFVF_NORMAL,
                              d3ddev9, pTempMesh);
    D3DXComputeNormals(pTempMesh, nil);
    g_pArrowMesh := nil;
    g_pArrowMesh := pTempMesh;
  end;



  // Optimize the mesh for this graphics card's vertex cache
  GetMem(rgdwAdjacency, SizeOf(DWORD)*g_pArrowMesh.GetNumFaces*3);
  try
    g_pArrowMesh.ConvertPointRepsToAdjacency(nil, rgdwAdjacency);
    g_pArrowMesh.OptimizeInplace(D3DXMESHOPT_VERTEXCACHE, rgdwAdjacency, nil, nil, nil);
  finally
    FreeMem(rgdwAdjacency);
  end;

end;

{-


}
procedure THeadDisplay.Redraw3D;
var
  originMatrix, earthMatrix, matRot, matTrans, matRotTrans, matScale : TD3DXMatrix;

begin
  if Assigned(d3ddev9) then begin

    if FHeadAids[aidPoseFPS] then begin
      CurTickRend := GetTickCount;
      if (CurTickRend > LastTickRend) then begin
        ScreenFPSRend := FrameCountRend;
        LastTickRend := CurTickRend + 1000;
        FrameCountRend := 0;
      end else
        inc(FrameCountRend);
    end;

    if FResized then begin
      Reset;
      FResized := False;
    end;

    // clear Backbuffer
    d3dDev9.Clear( 0, nil, D3DCLEAR_TARGET or D3DCLEAR_ZBUFFER, D3DCOLOR_COLORVALUE(0, 0, 0, 1), 1, 0 );

    // Render scene
    d3dDev9.BeginScene;

    // Render Vertexbuffers
    d3dDev9.SetStreamSource( 0, vBuffer, 0, sizeof( CUSTOMVERTEX ) );  //inutile ?

    d3ddev9.SetTransform(D3DTS_PROJECTION, matProj);
    if FPerspective = pFirstPerson then
      d3ddev9.SetTransform(D3DTS_VIEW, viewMatrix);

    // white sky
    if FHeadAids[aidWhiteSky] then begin
      Material.Diffuse := D3DXColor(1.0, 1.0, 1.0, 1.0);
      Material.Emissive := D3DXColor(1.0, 1.0, 1.0, 1.0);
      d3dDev9.SetMaterial(Material);

      d3ddev9.SetRenderState(D3DRS_FILLMODE, D3DFILL_SOLID);
      D3DXMatrixTranslation(earthMatrix, 0, 7, 0);
      d3dDev9.SetTransform(D3DTS_WORLD, earthMatrix);
      earthMesh.DrawSubset(0);
    end;



    // wireframe sphere
    if FHeadAids[aidSphere] then begin
      Material.Diffuse := D3DXColor(0.0, 0.0, 0.0, 1.0);
      Material.Emissive := D3DXColor(0.5, 0.5, 0.5, 1.0);
      d3dDev9.SetMaterial(Material);

      D3DXMatrixIdentity(originMatrix);
      d3dDev9.setTransform(D3DTS_WORLD, originMatrix);

      d3ddev9.SetRenderState(D3DRS_FILLMODE, D3DFILL_WIREFRAME);
      sphereMesh.DrawSubset(0);
      d3ddev9.SetRenderState(D3DRS_FILLMODE, D3DFILL_SOLID);
    end;

    // fixed blue axes
    if FHeadAids[aidAxes] then begin
      Material.Diffuse := D3DXColor(0.0, 0.0, 1.0, 0.3);
      Material.Emissive := D3DXColor(0.0, 0.0, 1.0, 0.3);
      d3dDev9.SetMaterial(Material);
      D3DXMatrixIdentity(originMatrix);
      d3dDev9.setTransform(D3DTS_WORLD, originMatrix);

      if FPerspective = pFirstPerson then begin
        xAxisMesh.DrawSubset(0);
        yAxisMesh.DrawSubset(0);
        zAxisMesh.DrawSubset(0);
      end;

      if FPerspective <> pFirstPerson then begin
        if FPerspective <> pSide then
          xAxisHeadMesh.DrawSubset(0);
        if FPerspective <> pTop then
          yAxisHeadMesh.DrawSubset(0);
        if FPerspective <> pFront then
          zAxisHeadMesh.DrawSubset(0);
      end;
    end;


    // X, Y, Z labels
    if FHeadAids[aidLabels] then begin
      Material.Diffuse := D3DXColor(0.0, 0.0, 1.0, 1.0);
      Material.Emissive := D3DXColor(0.0, 0.0, 1.0, 1.0);
      d3dDev9.SetMaterial(Material);
      case FPerspective of
        pFront : begin
          D3DXMatrixTranslation(matTrans, 1.8, 0.1, 0);
          D3DXMatrixmultiply (matTrans, matScaleText, matTrans);
          d3dDev9.setTransform(D3DTS_WORLD, matTrans);
          xTextMesh.DrawSubset(0);
          D3DXMatrixTranslation(matTrans, 0.1, 1.8, 0);
          D3DXMatrixmultiply (matTrans, matScaleText, matTrans);
          d3dDev9.setTransform(D3DTS_WORLD, matTrans);
          yTextMesh.DrawSubset(0);
        end;

        pTop : begin
          D3DXMatrixTranslation(matTrans, 1.8, 0, 0.1);
          D3DXMatrixRotationYawPitchRoll(matRot, 0 , D3DX_PI/2, 0);
          D3DXMatrixmultiply (matRot, matScaleText, matRot);
          D3DXMatrixmultiply (matTrans, matRot, matTrans);
          d3dDev9.setTransform(D3DTS_WORLD, matTrans);
          xTextMesh.DrawSubset(0);
          D3DXMatrixTranslation(matTrans, 0.1, 0, 1.8);
          D3DXMatrixmultiply (matTrans, matRot, matTrans);
          d3dDev9.setTransform(D3DTS_WORLD, matTrans);
          zTextMesh.DrawSubset(0);
        end;

        pSide : begin
          D3DXMatrixTranslation(matTrans, 0, 1.8, -0.1);
          D3DXMatrixRotationYawPitchRoll(matRot, D3DX_PI/2 , 0, 0);
          D3DXMatrixmultiply (matRot, matScaleText, matRot);
          D3DXMatrixmultiply (matTrans, matRot, matTrans);
          d3dDev9.setTransform(D3DTS_WORLD, matTrans);
          yTextMesh.DrawSubset(0);
          D3DXMatrixTranslation(matTrans, 0, 0.1, 1.8);
          D3DXMatrixmultiply (matTrans, matRot, matTrans);
          d3dDev9.setTransform(D3DTS_WORLD, matTrans);
          zTextMesh.DrawSubset(0);
        end;

        pFirstPerson : begin
          D3DXMatrixTranslation(matTrans, -5, 0.2, 0.1);
          D3DXMatrixRotationYawPitchRoll(matRot, D3DX_PI/2 , 0, 0);
          D3DXMatrixmultiply (matRot, matScale2Text, matRot);
          D3DXMatrixmultiply (matTrans, matRot, matTrans);
          d3dDev9.setTransform(D3DTS_WORLD, matTrans);
          xTextMesh.DrawSubset(0);
          D3DXMatrixTranslation(matTrans, 0.1, 0.2, 5);
          D3DXMatrixRotationYawPitchRoll(matRot, D3DX_PI , 0, 0);
          D3DXMatrixmultiply (matRot, matScale2Text, matRot);
          D3DXMatrixmultiply (matTrans, matRot, matTrans);
          d3dDev9.setTransform(D3DTS_WORLD, matTrans);
          zTextMesh.DrawSubset(0);
          D3DXMatrixTranslation(matTrans, -0.1, 5, 0.2);
          D3DXMatrixRotationYawPitchRoll(matRot, 0 , D3DX_PI/2, 0);
          D3DXMatrixmultiply (matRot, matScale2Text, matRot);
          D3DXMatrixmultiply (matTrans, matRot, matTrans);
          d3dDev9.setTransform(D3DTS_WORLD, matTrans);
          yTextMesh.DrawSubset(0);
        end;
      end;
    end;

    // red tracking axes
    if FHeadAids[aidTracking] then begin
      Material.Diffuse := D3DXColor(1.0, 0.0, 0.0, 1.0);
      Material.Emissive := D3DXColor(1.0, 0.0, 0.0, 1.0);
      d3dDev9.SetMaterial(Material);

      d3dDev9.setTransform(D3DTS_WORLD, matHeadTrans);

      if FPerspective <> pFirstPerson then begin
        case FPerspective of
          pFront : begin
            xAxisHeadMesh.DrawSubset(0);
            yAxisHeadMesh.DrawSubset(0);
          end;

          pTop : begin
            xAxisHeadMesh.DrawSubset(0);
            zAxisHeadMesh.DrawSubset(0);
          end;

          pSide : begin
            yAxisHeadMesh.DrawSubset(0);
            zAxisHeadMesh.DrawSubset(0);
          end;
        end;
        d3dDev9.setTransform(D3DTS_WORLD, matHeadRotTrans);
        pointerMesh.DrawSubset(0);
      end;
    end;


    // head
    if FPerspective <> pFirstPerson then begin

      ZeroMemory( @Material, sizeof(D3DMATERIAL9) );

      Material.Diffuse := D3DXColor(1.0, 0.5, 0.2, 1.0);
      Material.Emissive := D3DXColor(0.1, 0.1, 0.1, 1.0);
      d3dDev9.SetMaterial( Material );

      d3dDev9.setTransform(D3DTS_WORLD, matHeadOffsetRotTrans);
      g_pArrowMesh.DrawSubset(0);   //skull
      g_pArrowMesh.DrawSubset(3);   //jaw

      ZeroMemory( @Material, sizeof(D3DMATERIAL9) );
      Material.Diffuse := D3DXColor(1.0, 1.0, 1.0, 1.0);
      Material.Ambient := D3DXColor(1.0, 1.0, 1.0, 1.0);
      Material.Emissive := D3DXColor(0.5, 0.5, 0.5, 1.0);
      Material.Specular := D3DXColor(1.0, 1.0, 1.0, 1.0);

      d3dDev9.SetMaterial( Material );
      g_pArrowMesh.DrawSubset(1); //up teeth
      g_pArrowMesh.DrawSubset(2); //down teeth
    end;

    ZeroMemory( @Material, sizeof(D3DMATERIAL9) );

    d3ddev9.SetRenderState(D3DRS_ALPHABLENDENABLE, iTrue);
    d3ddev9.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCALPHA);
    d3ddev9.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA);

    // absolute limit box
    if FHeadAids[aidLimitBoxAbs] then begin
      Material.Diffuse := D3DXColor(0.0, 0.0, 1.0, 0.3);
      Material.Emissive := D3DXColor(0.0, 0.0, 1.0, 0.3);
      d3dDev9.SetMaterial(Material);

      D3DXMatrixScaling(matScale, ABS_LIMIT, 1.0, 1.0);
      D3DXMatrixTranslation(matTrans, 0, ABS_LIMIT, ABS_LIMIT);
      D3DXMatrixMultiply(matTrans, matScale, matTrans);
      d3dDev9.setTransform(D3DTS_WORLD, matTrans);
      xlimitMesh.DrawSubset(0);
      D3DXMatrixTranslation(matTrans, 0, -ABS_LIMIT, ABS_LIMIT);
      D3DXMatrixMultiply(matTrans, matScale, matTrans);
      d3dDev9.setTransform(D3DTS_WORLD, matTrans);
      xlimitMesh.DrawSubset(0);
      D3DXMatrixTranslation(matTrans, 0, ABS_LIMIT, -ABS_LIMIT);
      D3DXMatrixMultiply(matTrans, matScale, matTrans);
      d3dDev9.setTransform(D3DTS_WORLD, matTrans);
      xlimitMesh.DrawSubset(0);
      D3DXMatrixTranslation(matTrans, 0, -ABS_LIMIT, -ABS_LIMIT);
      D3DXMatrixMultiply(matTrans, matScale, matTrans);
      d3dDev9.setTransform(D3DTS_WORLD, matTrans);
      xlimitMesh.DrawSubset(0);

      D3DXMatrixScaling(matScale, 1.0, ABS_LIMIT, 1.0);
      D3DXMatrixTranslation(matTrans, ABS_LIMIT, 0, ABS_LIMIT);
      D3DXMatrixMultiply(matTrans, matScale, matTrans);
      d3dDev9.setTransform(D3DTS_WORLD, matTrans);
      ylimitMesh.DrawSubset(0);
      D3DXMatrixTranslation(matTrans, -ABS_LIMIT, 0, ABS_LIMIT);
      D3DXMatrixMultiply(matTrans, matScale, matTrans);
      d3dDev9.setTransform(D3DTS_WORLD, matTrans);
      ylimitMesh.DrawSubset(0);
      D3DXMatrixTranslation(matTrans, ABS_LIMIT, 0, -ABS_LIMIT);
      D3DXMatrixMultiply(matTrans, matScale, matTrans);
      d3dDev9.setTransform(D3DTS_WORLD, matTrans);
      ylimitMesh.DrawSubset(0);
      D3DXMatrixTranslation(matTrans, -ABS_LIMIT, 0, -ABS_LIMIT);
      D3DXMatrixMultiply(matTrans, matScale, matTrans);
      d3dDev9.setTransform(D3DTS_WORLD, matTrans);
      ylimitMesh.DrawSubset(0);

      D3DXMatrixScaling(matScale, 1.0, 1.0, ABS_LIMIT);
      D3DXMatrixTranslation(matTrans, ABS_LIMIT, ABS_LIMIT, 0);
      D3DXMatrixMultiply(matTrans, matScale, matTrans);
      d3dDev9.setTransform(D3DTS_WORLD, matTrans);
      zlimitMesh.DrawSubset(0);
      D3DXMatrixTranslation(matTrans, -ABS_LIMIT, ABS_LIMIT, 0);
      D3DXMatrixMultiply(matTrans, matScale, matTrans);
      d3dDev9.setTransform(D3DTS_WORLD, matTrans);
      zlimitMesh.DrawSubset(0);
      D3DXMatrixTranslation(matTrans, ABS_LIMIT, -ABS_LIMIT, 0);
      D3DXMatrixMultiply(matTrans, matScale, matTrans);
      d3dDev9.setTransform(D3DTS_WORLD, matTrans);
      zlimitMesh.DrawSubset(0);
      D3DXMatrixTranslation(matTrans, -ABS_LIMIT, -ABS_LIMIT, 0);
      D3DXMatrixMultiply(matTrans, matScale, matTrans);
      d3dDev9.setTransform(D3DTS_WORLD, matTrans);
      zlimitMesh.DrawSubset(0);
    end;

    // limit box
    if FHeadAids[aidLimitBox] then begin
      Material.Diffuse := D3DXColor(0.0, 1.0, 0.0, 0.5);
      Material.Emissive := D3DXColor(0.0, 1.0, 0.0, 0.5);
      d3dDev9.SetMaterial(Material);

      D3DXMatrixScaling(matScale,  FRespMax[dofPanX], 1.0, 1.0);
      D3DXMatrixTranslation(matTrans, 0, FRespMax[dofPanY], FRespMax[dofPanZ]);
      D3DXMatrixMultiply(matTrans, matScale, matTrans);
      d3dDev9.setTransform(D3DTS_WORLD, matTrans);
      xlimitMesh.DrawSubset(0);
      D3DXMatrixTranslation(matTrans, 0, -FRespMax[dofPanY], FRespMax[dofPanZ]);
      D3DXMatrixMultiply(matTrans, matScale, matTrans);
      d3dDev9.setTransform(D3DTS_WORLD, matTrans);
      xlimitMesh.DrawSubset(0);
      D3DXMatrixTranslation(matTrans, 0, FRespMax[dofPanY], -FRespMax[dofPanZ]);
      D3DXMatrixMultiply(matTrans, matScale, matTrans);
      d3dDev9.setTransform(D3DTS_WORLD, matTrans);
      xlimitMesh.DrawSubset(0);
      D3DXMatrixTranslation(matTrans, 0, -FRespMax[dofPanY], -FRespMax[dofPanZ]);
      D3DXMatrixMultiply(matTrans, matScale, matTrans);
      d3dDev9.setTransform(D3DTS_WORLD, matTrans);
      xlimitMesh.DrawSubset(0);

      D3DXMatrixScaling(matScale, 1.0, FRespMax[dofPanY], 1.0);
      D3DXMatrixTranslation(matTrans, FRespMax[dofPanX], 0, FRespMax[dofPanZ]);
      D3DXMatrixMultiply(matTrans, matScale, matTrans);
      d3dDev9.setTransform(D3DTS_WORLD, matTrans);
      ylimitMesh.DrawSubset(0);
      D3DXMatrixTranslation(matTrans, -FRespMax[dofPanX], 0, FRespMax[dofPanZ]);
      D3DXMatrixMultiply(matTrans, matScale, matTrans);
      d3dDev9.setTransform(D3DTS_WORLD, matTrans);
      ylimitMesh.DrawSubset(0);
      D3DXMatrixTranslation(matTrans, FRespMax[dofPanX], 0, -FRespMax[dofPanZ]);
      D3DXMatrixMultiply(matTrans, matScale, matTrans);
      d3dDev9.setTransform(D3DTS_WORLD, matTrans);
      ylimitMesh.DrawSubset(0);
      D3DXMatrixTranslation(matTrans, -FRespMax[dofPanX], 0, -FRespMax[dofPanZ]);
      D3DXMatrixMultiply(matTrans, matScale, matTrans);
      d3dDev9.setTransform(D3DTS_WORLD, matTrans);
      ylimitMesh.DrawSubset(0);

      D3DXMatrixScaling(matScale, 1.0, 1.0, FRespMax[dofPanZ]);
      D3DXMatrixTranslation(matTrans, FRespMax[dofPanX], FRespMax[dofPanY], 0);
      D3DXMatrixMultiply(matTrans, matScale, matTrans);
      d3dDev9.setTransform(D3DTS_WORLD, matTrans);
      zlimitMesh.DrawSubset(0);
      D3DXMatrixTranslation(matTrans, -FRespMax[dofPanX], FRespMax[dofPanY], 0);
      D3DXMatrixMultiply(matTrans, matScale, matTrans);
      d3dDev9.setTransform(D3DTS_WORLD, matTrans);
      zlimitMesh.DrawSubset(0);
      D3DXMatrixTranslation(matTrans, FRespMax[dofPanX], -FRespMax[dofPanY], 0);
      D3DXMatrixMultiply(matTrans, matScale, matTrans);
      d3dDev9.setTransform(D3DTS_WORLD, matTrans);
      zlimitMesh.DrawSubset(0);
      D3DXMatrixTranslation(matTrans, -FRespMax[dofPanX], -FRespMax[dofPanY], 0);
      D3DXMatrixMultiply(matTrans, matScale, matTrans);
      d3dDev9.setTransform(D3DTS_WORLD, matTrans);
      zlimitMesh.DrawSubset(0);
    end;

    // rotation limits
    if FHeadAids[aidLimitRotation] then begin
      if FPerspective <> pFirstPerson then begin
        Material.Diffuse := D3DXColor(0.0, 1.0, 0.0, 0.5);
        Material.Emissive := D3DXColor(0.0, 1.0, 0.0, 0.5);
        d3dDev9.SetMaterial(Material);

        // yaw limits
        case FPerspective of
          pTop : begin
            D3DXMatrixTranslation(matTrans, 0, 0, -10);
            D3DXMatrixRotationYawPitchRoll(matRot, FRespMax[dofYaw], 0, 0);
            D3DXMatrixMultiply(matRotTrans, matTrans, matRot);
            D3DXMatrixMultiply(matRotTrans, matRotTrans, matHeadTrans);
            d3dDev9.setTransform(D3DTS_WORLD, matRotTrans);
            zAxisHeadMesh.DrawSubset(0);
            D3DXMatrixRotationYawPitchRoll(matRot, -FRespMax[dofYaw], 0, 0);
            D3DXMatrixMultiply(matRotTrans, matTrans, matRot);
            D3DXMatrixMultiply(matRotTrans, matRotTrans, matHeadTrans);
            d3dDev9.setTransform(D3DTS_WORLD, matRotTrans);
            zAxisHeadMesh.DrawSubset(0);
          end;

          // pitch limits
          pSide : begin
            D3DXMatrixTranslation(matTrans, 0, 0, -10);
            D3DXMatrixRotationYawPitchRoll(matRot, 0, FRespMax[dofPitch], 0);
            D3DXMatrixMultiply(matRotTrans, matTrans, matRot);
            D3DXMatrixMultiply(matRotTrans, matRotTrans, matHeadTrans);
            d3dDev9.setTransform(D3DTS_WORLD, matRotTrans);
            zAxisHeadMesh.DrawSubset(0);
            D3DXMatrixRotationYawPitchRoll(matRot, 0, -FRespMax[dofPitch], 0);
            D3DXMatrixMultiply(matRotTrans, matTrans, matRot);
            D3DXMatrixMultiply(matRotTrans, matRotTrans, matHeadTrans);
            d3dDev9.setTransform(D3DTS_WORLD, matRotTrans);
            zAxisHeadMesh.DrawSubset(0);
          end;

          // roll limits
          pFront : begin
            D3DXMatrixTranslation(matTrans, 0, 10, 0);
            D3DXMatrixRotationYawPitchRoll(matRot, 0, 0, FRespMax[dofRoll]);
            D3DXMatrixMultiply(matRotTrans, matTrans, matRot);
            D3DXMatrixMultiply(matRotTrans, matRotTrans, matHeadTrans);
            d3dDev9.setTransform(D3DTS_WORLD, matRotTrans);
            yAxisHeadMesh.DrawSubset(0);
            D3DXMatrixRotationYawPitchRoll(matRot, 0, 0, -FRespMax[dofRoll]);
            D3DXMatrixMultiply(matRotTrans, matTrans, matRot);
            D3DXMatrixMultiply(matRotTrans, matRotTrans, matHeadTrans);
            d3dDev9.setTransform(D3DTS_WORLD, matRotTrans);
            yAxisHeadMesh.DrawSubset(0);
          end;
        end;
      end;
    end;

    if FHeadAids[aidRenderFPS] then
      FPSText.DrawTextA(nil, PAnsiChar(InttoStr(ScreenFPSRend)), -1, @PanelRect, DT_LEFT or DT_NOCLIP, D3DXColorToDWord(D3DXColor(0, 0, 1.0, 1.0)));

    if FHeadAids[aidPoseFPS] then
      FPSText.DrawTextA(nil, PAnsiChar(InttoStr(ScreenFPSPose)), -1, @PanelRect, DT_RIGHT or DT_NOCLIP, D3DXColorToDWord(D3DXColor(1.0, 0.5, 0.2, 1.0)));

    d3ddev9.SetRenderState(D3DRS_ALPHABLENDENABLE, iFalse);

    ZeroMemory( @Material, sizeof(D3DMATERIAL9) );

    // Render ends
    d3ddev9.EndScene;

    //swap Backbuffer and Frontbuffer
    if d3ddev9.Present(nil, nil, 0, nil)<> D3D_OK then
      Reset;
  end;
end;

{-


}
procedure THeadDisplay.SetupViewAndProjection;
var
  matView, matProj: TD3DXMatrix;
  _v1, _v2, _v3: TD3DXVector3;
begin
  // View.
  case FPerspective of
    pFront : begin
      _v1 := D3DXVector3(0.0, 0.0, -5.0);
      _v2 := D3DXVector3(0.0, 0.0,  0.0);
      _v3 := D3DXVector3(0.0, 1.0,  0.0);
      D3DXMatrixLookAtLH(matView, _v1, _v2, _v3);
      d3ddev9.SetTransform(D3DTS_VIEW, matView);
    end;

    pTop : begin
      _v1 := D3DXVector3(0.0, 5.0, 0.0);
      _v2 := D3DXVector3(0.0, 0.0,  0.0);
      _v3 := D3DXVector3(0.0, 0.0,  1.0);
      D3DXMatrixLookAtLH(matView, _v1, _v2, _v3);
      d3ddev9.SetTransform(D3DTS_VIEW, matView);
    end;

    pSide : begin
      _v1 := D3DXVector3(-5, 0.0, 0.0);
      _v2 := D3DXVector3(0.0, 0.0,  0.0);
      _v3 := D3DXVector3(0.0, 1.0,  0.0);
      D3DXMatrixLookAtLH(matView, _v1, _v2, _v3);
      d3ddev9.SetTransform(D3DTS_VIEW, matView);
    end;

    pFirstPerson : begin
      _v1 := D3DXVector3(0.0, 0.0, 0.0);
      _v2 := D3DXVector3(0.0, 0.0, 1.0);
      _v3 := D3DXVector3(0.0, 1.0, 0.0);
      D3DXMatrixLookAtLH(matView, _v1, _v2, _v3);
      d3ddev9.SetTransform(D3DTS_VIEW, matView);
    end;
  end;

  // Projection.
  D3DXMatrixPerspectiveFovLH(matProj, D3DX_PI / 4, width/height, 0.1, 10000.0);
  d3ddev9.SetTransform(D3DTS_PROJECTION, matProj);
end;



destructor THeadDisplay.Destroy;
begin

  if d3ddev9 <> nil then d3ddev9.EndScene;

  // Delphi automatically destroys COM objects that go out of scope

  inherited;
end;



procedure THeadDisplay.Reset;
var
  d3dpp: TD3DPRESENT_PARAMETERS;
begin
  FPSText.OnLostDevice;
  GetPresentationParams(d3dpp);
  d3ddev9.Reset(d3dpp);
  DefineScreenFormat;

  SetRect(PanelRect, 0, 0, width, height);

  SetupViewAndProjection;

  FPSText.OnResetDevice;
end;



procedure THeadDisplay.DefineScreenFormat;
var
  light0: TD3DLIGHT9;
begin

  d3ddev9.SetRenderState(D3DRS_LIGHTING,  iTrue);
  d3dDev9.SetRenderState(D3DRS_FILLMODE, D3DFILL_SOLID);

  d3dDev9.SetRenderState(D3DRS_AMBIENT, $00202020);
  d3dDev9.SetRenderState(D3DRS_SPECULARENABLE, iTRUE ) ;

  d3ddev9.SetRenderState(D3DRS_ZENABLE, iTRUE );
  d3ddev9.SetRenderState(D3DRS_CULLMODE, D3DCULL_NONE );

  d3ddev9.SetRenderState(D3DRS_MULTISAMPLEANTIALIAS, iFALSE);
  d3ddev9.SetRenderState(D3DRS_ANTIALIASEDLINEENABLE, iFALSE);

  // Set light 0 to be a pure white directional light
  ZeroMemory( @light0, sizeof(D3DLIGHT9) );
  light0._Type := D3DLIGHT_DIRECTIONAL;
  light0.Direction := D3DXVECTOR3( 10.0, -10.0, 10.0);
  light0.Diffuse.r := 1.0;
  light0.Diffuse.g := 1.0;
  light0.Diffuse.b := 1.0;
  light0.Diffuse.a := 1.0;
  d3dDev9.SetLight(0, light0);

  d3dDev9.LightEnable(0, TRUE);
end;


procedure THeadDisplay.ChangePerspective(perspective : TPerspectives);
begin
  FPerspective := perspective;
  SetupViewAndProjection;
end;


procedure THeadDisplay.SetRespMax(aDOF : TDOF; Value : Single);
begin

  FRespMax[aDOF] := Value * ifthen(aDOF in [dofPanX, dofPanY, dofPanZ], DX_PAN_SCALE, 1);
end;


procedure THeadDisplay.SetHeadAids(aHeadAid : THeadAids; Value : Boolean);
begin
  FHeadAids[aHeadAid] := Value;
end;


procedure THeadDisplay.RestoreAttitude(yaw, pitch, roll, PanX, PanY, PanZ: Single);
var
  temp : TPerspectives;
begin
  // generate attitude for first person as well
  temp := FPerspective;
  FPerspective := pFirstPerson;
  Attitude(yaw, pitch, roll, PanX, PanY, PanZ);
  FPerspective := temp;
end;


end.

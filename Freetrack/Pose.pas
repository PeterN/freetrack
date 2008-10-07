//******************************************************************************************
//
//
//******************************************************************************************
{$define debug}

unit Pose;

interface

uses
  windows, SysUtils, Math, IniFiles, Forms, Parameters, D3DX9;

const
  NB_POINT = 4;

type

  Matr32f = array[0..8] of Single;
  Vect32f = array[0..2] of Single;

  Th1h2 = array[0..1] of Single;

  Matr32f_3x3 = array[0..2] of RPoint3D32f;

  TermCriteria = record
    max_iter : integer;
    epsilon : double;
  end;

  TPoseObject = class (TObject)
  private
    FInvFocale: Single;
    FNumPoints: Integer;
    FPoseCritere: TermCriteria;
    r1m_norm, r2m_norm, r3m_norm : array[0..2] of Single;
    R01, R02, R12 : Single;
    dist1, dist2 : Single;
    img_vecs: Array of Single;
    inv_matr: Array of Single;
    obj_vecs: Array of Single;
    prevh1, prevh2 : Single;
    yawAlignModel, pitchAlignModel : Single;
    FZScalar : Single;
    function GetEpsilon: Single;
    function GetMaxIteration: Integer;
    procedure PseudoInverse(var a, b : array of Single; n : integer);
    procedure SetEpsilon(Value: Single);
    procedure SetMaxIteration(Value: Integer);
  public
    Clip3PRoll, Clip3PYaw, Clip3PPitch: Integer;
    constructor Create;
    procedure Initialize3PClipModel(const dimensions3PtsClip : TArrayOfPoint3D32f);
    procedure Initialize3PCapModel(const dimensions3PtsCap : TArrayOfPoint3D32f);
    procedure Initialize4PModel(const dimensions4Pts : TArrayOfPoint3D32f);
    function Posit(const img: TArrayOfPoint2D32f; var pose : TPose): Boolean;
    function AlterPose(const img: TArrayOfPoint2D32f; var pose : TPose; var axis_norm: TArrayOfPoint3D32f) : Boolean;
    function AlterPoseClip(const imgClip: TArrayOfPoint2D32f; var pose: TPose; var h1h2 : Th1h2) : Boolean;
    function AlterPoseCap(const imgCap: TArrayOfPoint2D32f; var pose : TPose; var h1h2 : Th1h2) : Boolean;
    property Epsilon: Single read GetEpsilon write SetEpsilon;
    property InvFocale : Single read FInvFocale write FInvFocale;
    property MaxIteration: Integer read GetMaxIteration write SetMaxIteration;
    property NumPoints: Integer read FNumPoints;
    property ZScalar: Single read FZScalar write FZScalar;
  end;

   function Point2D32f(a, b : single) : RPoint2D32f;

var
  MyPoseObj : TPoseObject;

implementation



function InvSqrt( value : single) : single;
var
  x, y : Single;
begin
  PCardinal(longint(@x))^ := ($be6f0000 -  PCardinal(longint(@value))^ ) shr 1;
  y := value * 0.5;
  x := x * (1.5 - y*x*x);
  x := x * (1.5 - y*x*x);
  x := x * (1.5 - y*x*x);

  result := x;
end;



function Point2D32f(a, b : single) : RPoint2D32f;
begin
  Result.x := a;
  Result.y := b;
end;


{
*********************************************************** TPoseObject ***********************************************************
}
{-


}
constructor TPoseObject.Create;
begin
  FPoseCritere.max_iter := 72;
  FPoseCritere.epsilon := 0.01;

  prevh1 := -1;
  prevh2 := -1;

  // optimize by setting FPU precision to Single
  SetPrecisionMode(pmSingle);

end;

procedure TPoseObject.Initialize3PClipModel(const dimensions3PtsClip : TArrayOfPoint3D32f);
var
  i: Integer;
  dot : Single;
  top, R01_v, R02_v, R12_v  : array[0..2] of Single;
begin
  R01_v[0] := 0;
  R01_v[1] := dimensions3PtsClip[0].y;
  R01_v[2] := -dimensions3PtsClip[0].z;
  R01 := sqrt(sqr(R01_v[0]) + sqr(R01_v[1]) + sqr(R01_v[2]));

  R02_v[0] := 0;
  R02_v[1] := -dimensions3PtsClip[1].y;
  R02_v[2] := -dimensions3PtsClip[1].z;
  R02 := sqrt(sqr(R02_v[0]) + sqr(R02_v[1]) + sqr(R02_v[2]));

  R12_v[0] := 0;
  R12_v[1] := -dimensions3PtsClip[1].y - dimensions3PtsClip[0].y;
  R12_v[2] := -dimensions3PtsClip[1].z + dimensions3PtsClip[0].z;
  R12 := sqrt(sqr(R12_v[0]) + sqr(R12_v[1]) + sqr(R12_v[2]));

  {********model triad************}
  for i := 0 to 2 do
    r1m_norm[i] := R01_v[i] * (1/R01);

  dot :=  R02_v[0] * r1m_norm[0] +
          R02_v[1] * r1m_norm[1] +
          R02_v[2] * r1m_norm[2];

  for i := 0 to 2 do
      top[i] := (R02_v[i] - dot * r1m_norm[i]);

  for i := 0 to 2 do
    r2m_norm[i] := top[i] * (1/sqrt(sqr(top[0]) + sqr(top[1])));

  //cross product x1_norm X y1_norm
  r3m_norm[0] := r1m_norm[1] * r2m_norm[2] - r1m_norm[2] * r2m_norm[1];
  r3m_norm[1] := r1m_norm[2] * r2m_norm[0] - r1m_norm[0] * r2m_norm[2];
  r3m_norm[2] := r1m_norm[0] * r2m_norm[1] - r1m_norm[1] * r2m_norm[0];

  yawAlignModel := 0;
  pitchAlignModel := arcTan(dimensions3PtsClip[0].z/dimensions3PtsClip[0].y);
end;



procedure TPoseObject.Initialize3PCapModel(const dimensions3PtsCap : TArrayOfPoint3D32f);
var
  i: Integer;
  dot : Single;
  top, R01_v, R02_v, R12_v  : array[0..2] of Single;

begin
  R01_v[0] := -dimensions3PtsCap[0].x;
  R01_v[1] := -dimensions3PtsCap[0].y;
  R01_v[2] := -dimensions3PtsCap[0].z;
  R01 := sqrt(sqr(R01_v[0]) + sqr(R01_v[1]) + sqr(R01_v[2]));

  R02_v[0] := dimensions3PtsCap[0].x;
  R02_v[1] := -dimensions3PtsCap[0].y;
  R02_v[2] := -dimensions3PtsCap[0].z;
  R02 := sqrt(sqr(R02_v[0]) + sqr(R02_v[1]) + sqr(R02_v[2]));

  R12_v[0] := 2 * dimensions3PtsCap[0].x;
  R12_v[1] := 0;
  R12_v[2] := 0;
  R12 := sqrt(sqr(R12_v[0]) + sqr(R12_v[1]) + sqr(R12_v[2]));

  {********model triad************}
  for i := 0 to 2 do
    r1m_norm[i] := R01_v[i] * (1/R01);

  dot :=  R02_v[0] * r1m_norm[0] +
          R02_v[1] * r1m_norm[1] +
          R02_v[2] * r1m_norm[2] ;

  for i := 0 to 2 do
      top[i] := (R02_v[i] - dot * r1m_norm[i]);

  for i := 0 to 2 do
    r2m_norm[i] := top[i] * (1/sqrt(sqr(top[0]) + sqr(top[1]) + sqr(top[2])));

  //cross product x1_norm X y1_norm
  r3m_norm[0] := r1m_norm[1] * r2m_norm[2] - r1m_norm[2] * r2m_norm[1];
  r3m_norm[1] := r1m_norm[2] * r2m_norm[0] - r1m_norm[0] * r2m_norm[2];
  r3m_norm[2] := r1m_norm[0] * r2m_norm[1] - r1m_norm[1] * r2m_norm[0];

  yawAlignModel := arcTan(dimensions3PtsCap[0].x/dimensions3PtsCap[0].z);
  pitchAlignModel := arcTan(dimensions3PtsCap[0].y/dimensions3PtsCap[0].z);
end;




procedure TPoseObject.Initialize4PModel(const dimensions4Pts : TArrayOfPoint3D32f);
var
  i: Integer;
  points_four : TArrayOfPoint3D32f;
begin

  FNumPoints := 4;
  SetLength(inv_matr, 3*FNumPoints);
  SetLength(obj_vecs, 3*FNumPoints);
  SetLength(img_vecs, 2*FNumPoints);
  SetLength(points_four, FNumPoints);

  // convert dimensions into model
  points_four[0].x := 0;
  points_four[0].y := 0;
  points_four[0].z := 0;
  points_four[1].x := -dimensions4Pts[1].x;
  points_four[1].y := -(dimensions4Pts[1].y + dimensions4Pts[2].y);
  points_four[1].z := -(dimensions4Pts[1].z - dimensions4Pts[2].z);
  points_four[2].x := 0;
  points_four[2].y := -dimensions4Pts[1].y;
  points_four[2].z := -dimensions4Pts[1].z;
  points_four[3].x := -points_four[1].x;
  points_four[3].y := points_four[1].y;
  points_four[3].z := points_four[1].z;

  for i := 0 to FNumPoints-1 do begin
    obj_vecs[i] := points_four[i + 1].x - points_four[0].x;
    obj_vecs[FNumPoints + i] := points_four[i + 1].y - points_four[0].y;
    obj_vecs[2 * FNumPoints + i] := points_four[i + 1].z - points_four[0].z;
  end;

  PseudoInverse( obj_vecs, inv_matr, FNumPoints);

  yawAlignModel := arcTan(points_four[1].x/points_four[1].z);
  pitchAlignModel := arcTan(points_four[1].y/points_four[1].z);
end;



function TPoseObject.GetEpsilon: Single;
begin
  Result := FPoseCritere.Epsilon;
end;


function TPoseObject.GetMaxIteration: Integer;
begin
  Result := FPoseCritere.max_iter;
end;


{Pose from Orthography and Scaling, a scaled orthographic proj. approximation.
This code is based on POSIT algorithm from:
     Daniel DeMenthon http://www.cfar.umd.edu/~daniel/
Reference: D. DeMenthon and L.S. Davis, "Model-Based Object Pose in 25 Lines of Code",
International Journal of Computer Vision, 15, pp. 123-141, June 1995.   }
function TPoseObject.Posit(const img : TArrayOfPoint2D32f; var pose : TPose):
        Boolean;
var
  i, j, k, count : Integer;
  converged: Boolean;
  inorm, jnorm, invInorm, invJnorm, inv_z, s : Single;
  diff, old, tmp, dot: Single;
  rotation_matrix: Matr32f;
  matTrans, matPitch, matYaw : TD3DXMatrix;
  r1e_norm, r2e_norm, r3e_norm, top : array[0..2] of Single;
  est_obj01, est_obj02 : array[0..2] of Single;
  aDOF : TDOF;

begin
  count := 0;
  converged := false;
  inv_z := 0;
  s := 0;
  diff := FPoseCritere.epsilon;

  while not converged do begin
    if count = 0 then begin
      for i := 0 to FNumPoints-2 do begin
        img_vecs[i] := img[i + 1].x - img[0].x;
        img_vecs[FNumPoints + i] := img[i + 1].y - img[0].y;
      end;
    end else begin
      diff := 0;
      for i := 0 to FNumPoints-1 do  begin
        tmp := obj_vecs[ i] * rotation_matrix[6] +
               obj_vecs[FNumPoints + i] * rotation_matrix[7] +
               obj_vecs[2 * FNumPoints + i] * rotation_matrix[8];

        tmp := (tmp * inv_Z) + 1;

        old := img_vecs[i];
        img_vecs[i] := img[i + 1].x * tmp - img[0].x;

        diff := MAX( diff, abs( img_vecs[i] - old ));
  
        old := img_vecs[FNumPoints + i];
        img_vecs[FNumPoints + i] := img[i + 1].y * tmp - img[0].y;

        diff := MAX( diff, abs( img_vecs[FNumPoints + i] - old ));
      end;
    end;
  
    // I and J vectors
    for i := 0 to 2-1 do begin
      for j := 0 to 3-1 do begin
        rotation_matrix[3*i+j] := 0;
        for k := 0 to FNumPoints-1 do begin
          rotation_matrix[3*i+j] := rotation_matrix[ 3*i+j] +
                                    inv_matr[j * FNumPoints + k] *
                                    img_vecs[i * FNumPoints + k];
        end;
      end;
    end;
  
    inorm := Sqr(rotation_matrix[0]) +
             Sqr(rotation_matrix[1]) +
             Sqr(rotation_matrix[2]);
  
    jnorm := Sqr(rotation_matrix[3]) +
             Sqr(rotation_matrix[4]) +
             Sqr(rotation_matrix[5]);

    invInorm := InvSqrt( inorm );   //    invInorm := 1/Sqrt( inorm );
    invJnorm := InvSqrt( jnorm );   //    invJnorm := 1/Sqrt( jnorm );
  
    inorm := inorm * invInorm;
    jnorm := jnorm * invJnorm;
  
    rotation_matrix[0] := rotation_matrix[0] * invInorm;
    rotation_matrix[1] := rotation_matrix[1] * invInorm;
    rotation_matrix[2] := rotation_matrix[2] * invInorm;

    rotation_matrix[3] := rotation_matrix[3] * invJnorm;
    rotation_matrix[4] := rotation_matrix[4] * invJnorm;
    rotation_matrix[5] := rotation_matrix[5] * invJnorm;
  
    // cross product
    rotation_matrix[6] := rotation_matrix[1] * rotation_matrix[5] -
                          rotation_matrix[2] * rotation_matrix[4] ;
  
    rotation_matrix[7] := rotation_matrix[2] * rotation_matrix[3] -
                          rotation_matrix[0] * rotation_matrix[5];

    rotation_matrix[8] := rotation_matrix[0] * rotation_matrix[4] -
                          rotation_matrix[1] * rotation_matrix[3];

    s := (inorm + jnorm) / 2.0;
    inv_z := s/FZScalar;

    inc(count);
    converged := diff < FPoseCritere.epsilon;
  end;

  Result := count < FPoseCritere.max_iter;
  if Result then begin

    // matrix multipliation
    for i := 0 to 2 do begin
      est_obj01[i] := obj_vecs[0] * rotation_matrix[3*i] + obj_vecs[4] * rotation_matrix[3*i + 1] + obj_vecs[8] * rotation_matrix[3*i + 2];
      est_obj02[i] := obj_vecs[2] * rotation_matrix[3*i] + obj_vecs[6] * rotation_matrix[3*i + 1] + obj_vecs[10] * rotation_matrix[3*i + 2];
    end;

    {**********image triad*********}
    for i := 0 to 2 do
      r1e_norm[i] := est_obj01[i] * (1/sqrt(sqr(est_obj01[0]) + sqr(est_obj01[1]) + sqr(est_obj01[2])));

    dot :=  est_obj02[0] * r1e_norm[0] +
            est_obj02[1] * r1e_norm[1] +
            est_obj02[2] * r1e_norm[2] ;

    for i := 0 to 2 do
      top[i] := (est_obj02[i] - dot * r1e_norm[i]);

    for i := 0 to 2 do
      r2e_norm[i] := top[i] * (1/sqrt(sqr(top[0]) + sqr(top[1]) + sqr(top[2])));

    //cross product x1_norm x y1_norm
    r3e_norm[0] := r1e_norm[1] * r2e_norm[2] - r1e_norm[2] * r2e_norm[1];
    r3e_norm[1] := r1e_norm[2] * r2e_norm[0] - r1e_norm[0] * r2e_norm[2];
    r3e_norm[2] := r1e_norm[0] * r2e_norm[1] - r1e_norm[1] * r2e_norm[0];

    // matrix is actually 4x4, fill matrix to make sure there are no NAN entries
    D3DXMatrixIdentity(matTrans);
    {align estimated model normalised vectors with axes by rotating relative to other normalised vectors}
    matTrans._11 := r2e_norm[0];       matTrans._12 := r3e_norm[0];        matTrans._13 := r1e_norm[0];
    matTrans._21 := r2e_norm[1];       matTrans._22 := r3e_norm[1];        matTrans._23 := r1e_norm[1];
    matTrans._31 := r2e_norm[2];       matTrans._32 := r3e_norm[2];        matTrans._33 := r1e_norm[2];

    D3DXMatrixRotationY(matYaw, -yawAlignModel);
    D3DXMatrixRotationX(matPitch, -pitchAlignModel);

    D3DXMatrixMultiply(matTrans, matTrans, matYaw);
    D3DXMatrixMultiply(matTrans, matTrans, matPitch);

    pose[dofYaw]  := ArcTan2(rotation_matrix[6], rotation_matrix[0]);
    pose[dofPitch] := ArcTan2(-rotation_matrix[5], rotation_matrix[4]);
    pose[dofRoll]  := ArcSin(-rotation_matrix[3]);

    pose[dofPanX]  := (1/s) * img[0].x - (  MyConfig.RotOffset[MyConfig.TrackingMethod, dofPanX] * matTrans._11 +
                                            MyConfig.RotOffset[MyConfig.TrackingMethod, dofPanY] * -matTrans._12 +
                                            MyConfig.RotOffset[MyConfig.TrackingMethod, dofPanZ] * -matTrans._13);

    pose[dofPanY]  := (1/s) * img[0].y - (  MyConfig.RotOffset[MyConfig.TrackingMethod, dofPanX] * matTrans._21 +
                                            MyConfig.RotOffset[MyConfig.TrackingMethod, dofPanY] * -matTrans._22 +
                                            MyConfig.RotOffset[MyConfig.TrackingMethod, dofPanZ] * -matTrans._23);

                          // same as (1/s) * MyConfig.CamFocalLength;
    pose[dofPanZ]  := 1 / inv_z  - (  MyConfig.RotOffset[MyConfig.TrackingMethod, dofPanX] * matTrans._31 +
                                      MyConfig.RotOffset[MyConfig.TrackingMethod, dofPanY] * -matTrans._32 +
                                      MyConfig.RotOffset[MyConfig.TrackingMethod, dofPanZ] * -matTrans._33);
  end;
end;



function TPoseObject.AlterPoseClip(const imgClip: TArrayOfPoint2D32f; var pose : TPose; var h1h2 : Th1h2) : Boolean;
var
  img : TArrayOfPoint2D32f;
  axis_norm : TArrayOfPoint3D32f;
  matTrans, matPitch : TD3DXMatrix;
  aDOF : TDOF;
begin
   SetLength(img, 3);
   SetLength(axis_norm, 3);

   // image points 0 and 1 swapped around
  // (the second point in the point list, img[1], is the model origin)
  img[0] := imgClip[1];
  img[1] := imgClip[0];
  img[2] := imgClip[2];

  h1h2[0] := dist1;
  h1h2[1] := dist2;

  Result := AlterPose(img, pose, axis_norm);

  // matrix is actually 4x4, fill matrix to make sure there are no NAN entries
  D3DXMatrixIdentity(matTrans);
  {align estimated model normalised vectors with axes by rotating relative to other normalised vectors}
  matTrans._11 := axis_norm[2].x;        matTrans._12 := axis_norm[0].x;        matTrans._13 := axis_norm[1].x;
  matTrans._21 := axis_norm[2].y;        matTrans._22 := axis_norm[0].y;        matTrans._23 := axis_norm[1].y;
  matTrans._31 := axis_norm[2].z;        matTrans._32 := axis_norm[0].z;        matTrans._33 := axis_norm[1].z;

  D3DXMatrixRotationX(matPitch, pitchAlignModel);
  D3DXMatrixMultiply(matTrans, matTrans, matPitch);

  // normalised vectors representing x and z facing opposite to actual x and z axes
  pose[dofPanX]  := pose[dofPanX] - ( MyConfig.RotOffset[MyConfig.TrackingMethod, dofPanX] * -matTrans._11 +
                                      MyConfig.RotOffset[MyConfig.TrackingMethod, dofPanY] * matTrans._12 +
                                      MyConfig.RotOffset[MyConfig.TrackingMethod, dofPanZ] * -matTrans._13);

  pose[dofPanY]  := pose[dofPanY] - ( MyConfig.RotOffset[MyConfig.TrackingMethod, dofPanX] * -matTrans._21 +
                                      MyConfig.RotOffset[MyConfig.TrackingMethod, dofPanY] * matTrans._22 +
                                      MyConfig.RotOffset[MyConfig.TrackingMethod, dofPanZ] * -matTrans._23);

  pose[dofPanZ]  := pose[dofPanZ]  - (  MyConfig.RotOffset[MyConfig.TrackingMethod, dofPanX] * -matTrans._31 +
                                        MyConfig.RotOffset[MyConfig.TrackingMethod, dofPanY] * matTrans._32 +
                                        MyConfig.RotOffset[MyConfig.TrackingMethod, dofPanZ] * -matTrans._33);

end;


function TPoseObject.AlterPoseCap(const imgCap: TArrayOfPoint2D32f; var pose : TPose; var h1h2 : Th1h2) : Boolean;
var
  axis_norm : TArrayOfPoint3D32f;
  matTrans, matPitch, matYaw : TD3DXMatrix;
  aDOF : TDOF;
begin
  SetLength(axis_norm, 3);

  Result := AlterPose(imgCap, pose, axis_norm);

  h1h2[0] := dist1;
  h1h2[1] := dist2;

  // matrix is actually 4x4, fill matrix to make sure there are no NAN entries
  D3DXMatrixIdentity(matTrans);
  {align estimated model normalised vectors with axes by rotating relative to other normalised vectors}
  matTrans._11 := axis_norm[1].x;        matTrans._12 := axis_norm[2].x;        matTrans._13 := axis_norm[0].x;
  matTrans._21 := axis_norm[1].y;        matTrans._22 := axis_norm[2].y;        matTrans._23 := axis_norm[0].y;
  matTrans._31 := axis_norm[1].z;        matTrans._32 := axis_norm[2].z;        matTrans._33 := axis_norm[0].z;

  D3DXMatrixRotationY(matYaw, -yawAlignModel);
  D3DXMatrixRotationX(matPitch, -pitchAlignModel);

  D3DXMatrixMultiply(matTrans, matTrans, matYaw);
  D3DXMatrixMultiply(matTrans, matTrans, matPitch);

  // normalised vectors representing y and z facing opposite to actual y and z axes
  pose[dofPanX]  := pose[dofPanX] - ( MyConfig.RotOffset[MyConfig.TrackingMethod, dofPanX] * matTrans._11 +
                                      MyConfig.RotOffset[MyConfig.TrackingMethod, dofPanY] * -matTrans._12 +
                                      MyConfig.RotOffset[MyConfig.TrackingMethod, dofPanZ] * -matTrans._13);

  pose[dofPanY]  := pose[dofPanY] - ( MyConfig.RotOffset[MyConfig.TrackingMethod, dofPanX] * matTrans._21 +
                                      MyConfig.RotOffset[MyConfig.TrackingMethod, dofPanY] * -matTrans._22 +
                                      MyConfig.RotOffset[MyConfig.TrackingMethod, dofPanZ] * -matTrans._23);

  pose[dofPanZ]  := pose[dofPanZ] - ( MyConfig.RotOffset[MyConfig.TrackingMethod, dofPanX] * matTrans._31 +
                                      MyConfig.RotOffset[MyConfig.TrackingMethod, dofPanY] * -matTrans._32 +
                                      MyConfig.RotOffset[MyConfig.TrackingMethod, dofPanZ] * -matTrans._33);
end;



{ Three point pose estimation, using Alter algorithm.
 Refer to "3D Pose from 3 Corresponding Points under Weak-Perspective Projection" }
function TPoseObject.AlterPose(const img: TArrayOfPoint2D32f; var pose : TPose; var axis_norm: TArrayOfPoint3D32f)  : Boolean;
var
  i, j : Integer;

  Rot : array[0..2] of array[0..2] of Single;

  top, est_obj01, est_obj02, r1e_norm, r2e_norm, r3e_norm : array[0..2] of Single;

  d01_v, d02_v, d12_v : array[0..1] of Single;

  d01, d02, d12, a, b, c, s, inv_s, h1, h2, dot : Single;

begin
  Result := False;

  d01_v[0] := img[1].x - img[0].x;
  d01_v[1] := img[1].y - img[0].y;
  d01 := sqrt(sqr(d01_v[0]) + sqr(d01_v[1]));

  d02_v[0] := img[2].x - img[0].x;
  d02_v[1] := img[2].y - img[0].y;
  d02 := sqrt(sqr(d02_v[0]) + sqr(d02_v[1]));

  d12_v[0] := (img[2].x - img[1].x);
  d12_v[1] := img[2].y - img[1].y;
  d12 := sqrt(sqr(d12_v[0]) + sqr(d12_v[1]));

  {**********Alter's magic equations**********}
  a := (R01 + R02 + R12) * (-R01 + R02 + R12) * (R01 - R02 + R12) * (R01 + R02 - R12);
  b :=  sqr(d01) * (-sqr(R01) + sqr(R02) + sqr(R12))
      + sqr(d02) * (sqr(R01) - sqr(R02) + sqr(R12))
      + sqr(d12) * (sqr(R01) + sqr(R02) - sqr(R12));
  c := (d01 + d02 + d12) * (-d01 + d02 + d12) * (d01 - d02 + d12) * (d01 + d02 - d12);
  s := sqrt((b + sqrt(sqr(b) - a * c)) * (1/a));
  inv_s := 1/s;

  {if ((sqr(d01) + sqr(d02) - sqr(d12)) <= (sqr(s) * (sqr(R01) + sqr(R02) - sqr(R12)))) then
    sigma := 1
  else
    sigma := -1; }

  h1 := - sqrt(sqr(s*R01) - sqr(d01));
  h2 := - {sigma *} sqrt(sqr(s*R02) - sqr(d02));

   // account for ambiguity when turning right (abs(h1) < abs(h2)) and h1 crosses 0
  {if (abs(h1) < abs(h2)) and (sigma = -1) then begin
    h1 := -h1;
    h2 := -h2;
  end;  }

  // sqrt(negative number) sometimes occurs for extreme poses, more often with 3point cap.
  if IsNAN(h1) or IsNAN(h2) then begin
    Result := False;
    Exit;
  end;

  { Calculate rotation matrix given estimated depth information }
  est_obj01[0] := inv_s * d01_v[0];
  est_obj01[1] := inv_s * d01_v[1];
  est_obj01[2] := inv_s * h1;  // distance drops out


  est_obj02[0] := inv_s * d02_v[0];
  est_obj02[1] := inv_s * d02_v[1];
  est_obj02[2] := inv_s * h2;


  {if  ((abs(est_obj01[2]) > 2) and not (Sign(est_obj01[2]) = Sign(prevh1))) or
      ((abs(est_obj02[2]) > 2) and not (Sign(est_obj02[2]) = Sign(prevh2))) then begin
    est_obj01[2] := -est_obj01[2];
    est_obj02[2] := -est_obj02[2];
  end;

  prevh1 := est_obj01[2];
  prevh2 := est_obj02[2];  }


  // account for mirror ambiguity
  // prevent sign change when one point is close to mirror plane and the other isn't
  {if (est_obj02[2] < 10) and (est_obj01[2] > 10) and (sigma = -1) then begin
    est_obj01[2] := - est_obj01[2];
    est_obj02[2] := - est_obj02[2];
  end;      }

  dist1 := est_obj01[2];
  dist2 := est_obj02[2];

  {**********image triad*********}
  for i := 0 to 2 do
    r1e_norm[i] := est_obj01[i] * (1/sqrt(sqr(est_obj01[0]) + sqr(est_obj01[1]) + sqr(est_obj01[2])));

  dot :=  est_obj02[0] * r1e_norm[0] +
          est_obj02[1] * r1e_norm[1] +
          est_obj02[2] * r1e_norm[2] ;

  for i := 0 to 2 do
    top[i] := (est_obj02[i] - dot * r1e_norm[i]);

  for i := 0 to 2 do
    r2e_norm[i] := top[i] * (1/sqrt(sqr(top[0]) + sqr(top[1]) + sqr(top[2])));

  //cross product x1_norm x y1_norm
  r3e_norm[0] := r1e_norm[1] * r2e_norm[2] - r1e_norm[2] * r2e_norm[1];
  r3e_norm[1] := r1e_norm[2] * r2e_norm[0] - r1e_norm[0] * r2e_norm[2];
  r3e_norm[2] := r1e_norm[0] * r2e_norm[1] - r1e_norm[1] * r2e_norm[0];

  // R = M2 * (M1)^T
  for i := 0 to 2 do // columns
    for j := 0 to 2 do // rows
      Rot[j][i] := r1e_norm[j] * r1m_norm[i] + r2e_norm[j] * r2m_norm[i] + r3e_norm[j] * r3m_norm[i];

  pose[dofYaw] := ArcTan2(Rot[2][0], Rot[0][0]);
  pose[dofPitch] := ArcTan2(-Rot[1][2], Rot[1][1]);
  pose[dofRoll] := ArcTan2(-Rot[1][0], Rot[0][0]); // use arctan instead of arcsin to avoid NAN when > 1

  pose[dofPanX] := inv_s * img[0].x;
  pose[dofPanY] := inv_s * img[0].y;
  pose[dofPanZ] := inv_s * FZScalar;

  axis_norm[0].x := r1e_norm[0];
  axis_norm[0].y := r1e_norm[1];
  axis_norm[0].z := r1e_norm[2];

  axis_norm[1].x := r2e_norm[0];
  axis_norm[1].y := r2e_norm[1];
  axis_norm[1].z := r2e_norm[2];

  axis_norm[2].x := r3e_norm[0];
  axis_norm[2].y := r3e_norm[1];
  axis_norm[2].z := r3e_norm[2];

  Result := True;

end;


{-


}
procedure TPoseObject.PseudoInverse(var a, b : array of Single; n : integer);
var
  k: Integer;
  mat00, mat11, mat22, mat01, mat02, mat12, det: Single;
  a0, a1, a2: Single;
  inv_det: Single;
  p00, p01, p02, p11, p12, p22: Single;
  
  {******************************************************************************************
  B returns the pseudoinverse of A (A with dimension N rows x 3 columns).
  It is the matrix v.[diag(1/wi)].(u)t (cf. svdcmp())
  Function returns True if B has maximum rank, False otherwise
  ******************************************************************************************}
  
begin
  mat00 := 0;
  mat11 := 0;
  mat22 := 0;
  mat01 := 0;
  mat02 := 0;
  mat12 := 0;
  det   := 0;
  
  for k := 0 to n-1 do begin
    a0 := a[k];
    a1 := a[n + k];
    a2 := a[2 * n + k];
  
    mat00 := mat00 + a0 * a0;
    mat11 := mat11 + a1 * a1;
    mat22 := mat22 + a2 * a2;
  
    mat01 := mat01 + a0 * a1;
    mat02 := mat02 + a0 * a2;
    mat12 := mat12 + a1 * a2;
  end;
  
  p00 := mat11 * mat22 - mat12 * mat12;
  p01 := -(mat01 * mat22 - mat12 * mat02);
  p02 := mat12 * mat01 - mat11 * mat02;
  
  p11 := mat00 * mat22 - mat02 * mat02;
  p12 := -(mat00 * mat12 - mat01 * mat02);
  p22 := mat00 * mat11 - mat01 * mat01;

  det := det + mat00 * p00;
  det := det + mat01 * p01;
  det := det + mat02 * p02;

  if (det < 0.0001) then
   Raise Exception.Create('Leds cannot be coplanar');

  inv_det := 1 / det;

  // compute resultant matrix
  for k := 0 to n-1 do begin
    a0 := a[k];
    a1 := a[n + k];
    a2 := a[2 * n + k];
  
    b[k] := (p00 * a0 + p01 * a1 + p02 * a2) * inv_det;
    b[n + k] := (p01 * a0 + p11 * a1 + p12 * a2) * inv_det;
    b[2 * n + k] := (p02 * a0 + p12 * a1 + p22 * a2) * inv_det;
  end;
end;

{-


}
procedure TPoseObject.SetEpsilon(Value: Single);
begin
  FPoseCritere.Epsilon := Value;
end;

{-


}
procedure TPoseObject.SetMaxIteration(Value: Integer);
begin
  FPoseCritere.max_iter := Value;
end;



end.



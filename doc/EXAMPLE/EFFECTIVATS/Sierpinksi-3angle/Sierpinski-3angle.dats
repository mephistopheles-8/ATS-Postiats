(*
** Animating a drawing
** of Sierpinski triangles
*)

(* ****** ****** *)
//
// HX-2014-11-19
//
(* ****** ****** *)
//
#include
"share/atspre_staload.hats"
//  
(* ****** ****** *)
//
extern
fun
drawAnim (): void = "mac#"
extern
fun
drawAnim_init (): void = "mac#"
extern
fun
drawAnim_loop (): void = "mac#"
extern
fun
drawAnim_loop_cont (): void = "mac#"
//
extern
fun drawFrame (): void = "mac#"
//
(* ****** ****** *)

implement
drawAnim() =
{
  val () = drawAnim_init ()
  val () = drawAnim_loop ()
}
(*
implement
drawAnim_init () = ()
*)
implement
drawAnim_loop () =
{
//
val () = drawFrame ()
val () = drawAnim_loop_cont ()
//
} (* end of [drawAnim] *)

(* ****** ****** *)

implement
drawAnim_loop_cont () =
{
//
val () =
$extfcall
(
  void, "setTimeout", drawAnim_loop, 1000(*ms*)
) (* end of [val] *)
//
} (* end of [drawAnim_loop_cont] *)

(* ****** ****** *)
//
abstype color
//
val BLUE = $extval(color, "#0000ff")
val YELLOW = $extval(color, "#ffff00")
//
(* ****** ****** *)

extern
fun
drawTriangle
(
  c: color
, Ax: double, Ay: double
, Bx: double, By: double
, Cx: double, Cy: double
) : void = "mac#"
//
extern
fun
drawSTriangle
(
  c: color
, Ax: double, Ay: double
, Bx: double, By: double
, Cx: double, Cy: double
, level: int
) : void = "mac#"
//
(* ****** ****** *)

implement
drawSTriangle
(
  c, Ax, Ay, Bx, By, Cx, Cy, level
) =
(
if
level > 0
then let
  val Px = (Ax + Bx) / 2
  and Py = (Ay + By) / 2
  val Qx = (Bx + Cx) / 2
  and Qy = (By + Cy) / 2
  val Rx = (Cx + Ax) / 2
  and Ry = (Cy + Ay) / 2
//
  val () = drawTriangle (c, Px, Py, Qx, Qy, Rx, Ry)
//
  val level1 = level - 1
  val () = drawSTriangle (c, Ax, Ay, Px, Py, Rx, Ry, level1)
  val () = drawSTriangle (c, Px, Py, Bx, By, Qx, Qy, level1)
  val () = drawSTriangle (c, Rx, Ry, Qx, Qy, Cx, Cy, level1)
in
  // nothing
end // end of [then]
else () // end of [else]
) (* end of [drawSTriangle] *)

(* ****** ****** *)
//
extern
fun theAx_get(): double = "mac#"
and theAy_get(): double = "mac#"
extern
fun theBx_get(): double = "mac#"
and theBy_get(): double = "mac#"
extern
fun theCx_get(): double = "mac#"
and theCy_get(): double = "mac#"
//
(* ****** ****** *)
  
implement
drawAnim_init () =
{
  val Ax = theAx_get()
  val Ay = theAy_get()
  val Bx = theBx_get()
  val By = theBy_get()
  val Cx = theCx_get()
  val Cy = theCy_get()
  val () = drawTriangle (BLUE, Ax, Ay, Bx, By, Cx, Cy)
} (* end of [drawAnim_init] *)
  
(* ****** ****** *)

extern
fun
theLevel_getinc(): int = "mac#"

(* ****** ****** *)

implement
drawFrame () =
{
  val Ax = theAx_get()
  val Ay = theAy_get()
  val Bx = theBx_get()
  val By = theBy_get()
  val Cx = theCx_get()
  val Cy = theCy_get()
  val level = theLevel_getinc ()
  val ((*void*)) = drawSTriangle (YELLOW, Ax, Ay, Bx, By, Cx, Cy, level)
}

(* ****** ****** *)

%{$
//
var
canvas =
document.getElementById
  ("Patsoptaas-Evaluate-canvas");
var
ctx2d = canvas.getContext( '2d' );
//
function
theAx_get() { return 0; }
function
theAy_get() { return ctx2d.height; }
function
theBx_get() { return ctx2d.width/2; }
function
theBy_get() { return 0; }
function
theCx_get() { return ctx2d.width; }
function
theCy_get() { return ctx2d.height; }
//
var
theLevel = 0;
function
theLevel_getinc()
{
  var
  level = theLevel;
  theLevel = (level+1)%6;
  return level;
}
//
function
drawTriangle
(
  Ax, Ay, Bx, By, Cx, Cy, color
)
{
  ctx2d.beginPath();
  ctx2d.moveTo(Ax, Ay);
  ctx2d.lineTo(Bx, By);
  ctx2d.lineTo(Cx, Cy);
  ctx2d.closePath();
  ctx2d.fillStyle = color; ctx2d.fill();
  return;
}
//
jQuery(document).ready(function(){drawAnim();});
//
%} // end of [%{$]

(* ****** ****** *)

(* end of [Sierpinski-3angle-part1.dats] *)
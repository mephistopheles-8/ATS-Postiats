(* ****** ****** *)
//
// Atscc2js:
// from ATS to JavaScript
//
(* ****** ****** *)
//
// HX-2014-08-20: start
// HX-2015-05-21: restructure
//
(* ****** ****** *)
//
#define
ATS_DYNLOADNAME
"libatscc2js_dynload"
//
(* ****** ****** *)
//
#include
"share/atspre_define.hats"
#include
"share/atspre_staload.hats"
//
(* ****** ****** *)
//
#staload
STDIO =
"{$PATSLIBATSLIBC}/SATS/stdio.sats"
//
(* ****** ****** *)
//
#if
defined
(
CATSPARSEMIT_targetloc
)
#then
#else
//
#define
CATSPARSEMIT_targetloc
"./../CATS-parsemit"
//
#endif // end of [ifdef]
//
(* ****** ****** *)
//
#staload
"{$CATSPARSEMIT}/SATS/catsparse.sats"
#staload
"{$CATSPARSEMIT}/SATS/catsparse_emit.sats"
#staload
"{$CATSPARSEMIT}/SATS/catsparse_parsing.sats"
//
(* ****** ****** *)
//
val () =
catsparse_all_dynload() where
{
extern
fun
catsparse_all_dynload(): void = "ext#"
} (* end of [val] *)
//
(* ****** ****** *)

#dynload "./atscc2js_emit.dats"
#dynload "./atscc2js_emit2.dats"

(* ****** ****** *)
//
datatype
comarg =
COMARG of (int, string)
//
typedef comarglst = List0 (comarg)
//
(* ****** ****** *)

datatype
waitkind =
  | WTKnone of ()
  | WTKinput of ()
  | WTKoutput of () // -o / --output
  | WTKiife of () // -iife <name>
// end of [waitkind]

(* ****** ****** *)
//
datatype
OUTCHAN =
| OUTCHANref of (FILEref) | OUTCHANptr of (FILEref)
// end of [OUTCHAN]
//
(* ****** ****** *)

fun
outchan_get_fileref
  (x: OUTCHAN): FILEref =
(
//
case+ x of
| OUTCHANref(filr) => filr | OUTCHANptr(filr) => filr
//
) (* end of [outchan_get_fileref] *)

(* ****** ****** *)

datatype JSModule =
 | JSnone
 | JSMcommonJS
 | JSMes6
 | JSMiife of string (** iifes need a global name **)

typedef
cmdstate = @{
  comarg0= comarg
, ncomarg= int // number of arguments
, waitkind= waitkind
// number of processed input files;
, ninputfile= int // waiting for STDIN if it is 0
, outchan= OUTCHAN // current output channel
, nerror= int // number of accumulated errors
, module= JSModule // module format
} (* end of [cmdstate] *)

(* ****** ****** *)

fun
cmdstate_set_outchan
(
  state: &cmdstate >> _, chan_new: OUTCHAN
) : void = let
//
val chan_old = state.outchan
val ((*void*)) = state.outchan := chan_new
//
in
//
case+
chan_old of
| OUTCHANref(filr) => ()
| OUTCHANptr(filp) => let
    val err = $STDIO.fclose0(filp) in (*nothing*)
  end // end of [OUTCHANptr]
//
end // end of [cmdstate_set_outchan]

(* ****** ****** *)
//
extern
fun
atscc2js_module_beg
  (state: &cmdstate >> _, filr: FILEref): void
//
implement
atscc2js_module_beg
  (state, out) = let
//
//
in case+ state.module of
    | JSMiife(name) =>
        begin
            emit_text( out, "\n/* IIFE Beg */\n");
            emit_text( out, "var ");
            emit_text( out,  name );
            emit_text( out,  " = (function () {\n" );
        end
    | _ => ()
end // end of [atscc2js_module_beg]
//
extern
fun
atscc2js_module_end
  (state: &cmdstate >> _, filr: FILEref, d0cs: d0eclist ): void
//
implement
atscc2js_module_end
  (state, out, d0cs) = let
//
    fn is_f0decl ( d0c: d0ecl ) : bool =
        case+ d0c.d0ecl_node of
         | D0Cfundecl(fk,f0d) =>
            (case+ f0d.f0decl_node of
              | F0DECLsome _=> true
              | _ => false
            )
          | _ => false


    fn emit_f0decl_name ( out: FILEref, d0c: d0ecl ) : void =
        case+ d0c.d0ecl_node of
         | D0Cfundecl(fk,f0d) =>
            (case+ f0d.f0decl_node of
              | F0DECLsome(fhd,_) =>
                   (case+ fhd.f0head_node of 
                     | F0HEAD(fid,_,_) =>
                         emit_i0de(out,fid);
                     )
    
              | _ => () 
            )
         | _ => ()
    

    fun loopObj(obj_name: string, out: FILEref, d0cs: d0eclist ) 
     : void =
        case+ d0cs of
         | list_nil() => ()
         | list_cons(d0c, d0cs) => 
           let
              val () =
                if is_f0decl(d0c)
                then (emit_text(out, obj_name);
                      emit_text(out, "."); 
                      emit_f0decl_name(out,d0c);
                      emit_text(out, " = " );
                      emit_f0decl_name(out,d0c);
                      emit_text(out, ";\n"))
                else () 
 
            in loopObj(obj_name,out,d0cs) 
           end // end [loopES6]


    fun loopES6( out: FILEref, d0cs: d0eclist, ct: bool ) 
     : void =
        case+ d0cs of
         | list_nil() => ()
         | list_cons(d0c, d0cs) => 
           let
              val b =
                if is_f0decl(d0c)
                then  
                    ((if ct 
                      then emit_text(out, "\n  , ")
                      else emit_text(out, "    "));
                     emit_f0decl_name(out,d0c);
                     true )
                else ct 
 
            in loopES6(out,d0cs,b) 
           end // end [loopES6]

in case+ state.module of
    | JSMiife(name) =>
            ( emit_text(out, "\nvar _ATS2_iife_exports = {};\n");
              loopObj("_ATS2_iife_exports", out, d0cs);
              emit_text(out, "\nreturn _ATS2_iife_exports;\n");
              emit_text( out, "\n})(); // end [iife]\n"))
    | JSMcommonJS() =>
            ( emit_text(out, "\nmodule.exports = {};\n");
              loopObj("module.exports", out, d0cs) )

    | JSMes6() =>
           ( emit_text(out, "\nexport {\n");
             loopES6( out, d0cs, false);
             emit_text(out, "\n}; // end [export]")
            )
            
    | _ => ()
end // end of [atscc2js_module_beg]
//
extern
fun
atscc2js_fileref
  (state: &cmdstate >> _, filr: FILEref): void
//
implement
atscc2js_fileref
  (state, inp) = let
//
val oc = state.outchan
val out = outchan_get_fileref(oc)
//
val d0cs = parse_from_fileref(inp)
//
val () = emit_time_stamp(out)
//
val () = atscc2js_module_beg(state,out)
//
val ((*void*)) = emit_toplevel(out, d0cs)
//
val () = atscc2js_module_end(state,out,d0cs)
//
val () =
emit_text (out, "\n/* ****** ****** */\n")
val () =
emit_text (out, "\n/* end-of-compilation-unit */")
//
val ((*flusing*)) = emit_newline(out)
//
in
  // nothing
end // end of [atscc2js_fileref]

(* ****** ****** *)
//
macdef fopen = $STDIO.fopen
//
extern
fun
atscc2js_basename
(
  state: &cmdstate >> _, fname: string
) : void // end-of-fun
extern
fun
atscc2js_basename_
(
  state: &cmdstate >> _, fname: string
) : void // end-of-fun
//
implement
atscc2js_basename
  (state, fname) =
(
case+
fname of
| "-" => let
    val inp = stdin_ref
  in
    atscc2js_fileref(state, inp)
  end // end of [stdin]
| _(*fname*) =>
    atscc2js_basename_(state, fname)
  // end of [non-stdin]
)
//
implement
atscc2js_basename_
  (state, fname) = let
//
val
inp =
fopen(fname, file_mode_r)
val
p_inp = $STDIO.ptrcast(inp)
//
in
//
if
p_inp > 0
then
fileref_close(inp) where
{
//
val
inp =
$UNSAFE.castvwtp0{FILEref}(inp)
val () =
the_filename_push(filename_make(fname))
//
val () = atscc2js_fileref(state, inp)
//
} (* end of [then] *)
else let
//
prval
(
// freed
) = $STDIO.FILEptr_free_null(inp)
val ((*void*)) =
  (state.nerror := state.nerror + 1)
//
in
  // nothing
end // end of [else]
//
end // end of [atscc2js_basename_]

(* ****** ****** *)

fun
cmdstate_set_outchan_basename
(
  state: &cmdstate >> _, basename: string
) : void = let
//
val
filp =
$STDIO.fopen
  (basename, file_mode_w)
val
p_out = $STDIO.ptrcast(filp)
//
(*
val () = println! ("cmdstate_set_outchan_basename: p0 = ", p0)
*)
//
in
//
if
p_out > 0
then let
  val filp = $UNSAFE.castvwtp0{FILEref}(filp)
in
  cmdstate_set_outchan(state, OUTCHANptr(filp))
end // end of [then]
else let
  prval
  ( // freed
  ) = $STDIO.FILEptr_free_null(filp)
  val ((*void*)) = state.nerror := state.nerror + 1
in
  cmdstate_set_outchan(state, OUTCHANref(stderr_ref))
end // end of [else]
//
end // end of [cmdstate_set_outchan_basename]

(* ****** ****** *)
//
fn
isinwait
  (state: cmdstate): bool =
(
  case+ state.waitkind of WTKinput() => true | _ => false
) (* end of [isinwait] *)
//
fn
isoutwait
  (state: cmdstate): bool =
(
  case+ state.waitkind of WTKoutput() => true | _ => false
) (* end of [isoutwait] *)
//
fn
isiffewait
  (state: cmdstate): bool =
(
  case+ state.waitkind of WTKiife() => true | _ => false
) (* end of [isiffewait] *)
//
(* ****** ****** *)
//
extern
fun
comarg_warning
  (msg: string): void
//
implement
comarg_warning
  (msg) = {
  val () = prerr("waring(ATS)")
  val () = prerr(": unrecognized command line argument [")
  val () = prerr(msg)
  val () = prerr("] is ignored.")
  val () = prerr_newline((*void*))
} (* end of [comarg_warning] *)
//
(* ****** ****** *)
  
fun
atscc2js_usage
  (cmd: string): void = {
//
val () =
println!
(
  "Usage: ", cmd, " <command> ... <command>\n"
)
val () =
println!
(
  "where each <command> is of one of the following forms:\n"
)
//
val () =
println! ("  -i <filename> : for processing <filename>")
val () =
println! ("  --input <filename> : for processing <filename>")
//
val () =
println! ("  -o <filename> : output into <filename>")
val () =
println! ("  --output <filename> : output into <filename>")
//
val () =
println! ("  -iife <global> : to compile JS to an IIFE. Top-level function delarations are added to an object declared as <global>.")
val () =
println! ("  -es6 : to compile JS to an ES6 module. Exports top-level function declarations.")
val () =
println! ("  -commonjs : to compile JS to a CommonJS module.  Exports top-level function declarations.")
//
val () =
println! ("  -h : for printing out this help usage")
val () =
println! ("  --help : for printing out this help usage")
//
} (* end of [atscc2js_usage] *)
  
(* ****** ****** *)

fun
process_cmdline
(
  state: &cmdstate, arglst: comarglst
) : void = let
in
//
case+ arglst of
//
| list_nil
    ((*void*)) => let
    val nif =
      state.ninputfile
    // end of [val]
    val wait0 =
    (
      case+ 0 of
      | _ when nif < 0 => true
      | _ when nif = 0 => isinwait(state)
      | _ (* nif > 0 *) => false
    ) : bool // end of [val]

  in
    if wait0 then
    (
      if state.ncomarg = 0
        then atscc2js_usage("atscc2js")
        else atscc2js_fileref(state, stdin_ref)
      // end of [if]
    ) (* end of [if] *)
  end // end of [list_nil]
//
| list_cons
    (arg, arglst) => let
    val () =
      state.ncomarg := state.ncomarg + 1
    // end of [val]
  in
    process_cmdline2(state, arg, arglst)
  end // end of [list_cons]
//
end // end of [process_cmdline]

and
process_cmdline2
(
  state: &cmdstate, arg: comarg, arglst: comarglst
) : void = let
in
//
case+ arg of
//
| _ when
    isoutwait(state) => let
//
    val COMARG(_, fname) = arg
//
    val () =
    cmdstate_set_outchan_basename(state, fname)
//
    val () = state.waitkind := WTKnone((*void*))
//
  in
    process_cmdline(state, arglst)
  end // end of [_ when isoutwait]
//
| _ when
    isinwait(state) => let
    val nif = state.ninputfile
  in
    case+ arg of
    | COMARG(1, key) when nif > 0 =>
      process_cmdline2_comarg1(state, arglst, key)
    | COMARG(2, key) when nif > 0 =>
      process_cmdline2_comarg2(state, arglst, key)
    | COMARG(_, fname) =>
      process_cmdline(state, arglst) where
      {
        val () = state.ninputfile := nif + 1
        val () = atscc2js_basename(state, fname(*input*))
      } (* end of [COMARG(_, _)] *)
  end // end of [_ when isinpwait]
//
| _ when
    isiffewait(state) => let
    val COMARG(_, iffeName) = arg
  in
    state.waitkind := WTKnone((*void*));
    state.module   := JSMiife(iffeName);
    process_cmdline(state, arglst)
 end
//
| COMARG(1, key) =>
    process_cmdline2_comarg1(state, arglst, key)
| COMARG(2, key) =>
    process_cmdline2_comarg2(state, arglst, key)
//
| COMARG(_, key) =>
    process_cmdline(state, arglst) where
  {
    val () = comarg_warning(key)
    val () = state.waitkind := WTKnone((*void*))
  } // end of [COMARG(_, _)]
//
end // end of [process_cmdline2]

and
process_cmdline2_comarg1
(
  state: &cmdstate >> _
, arglst: comarglst, key: string
) : void = let
//
val () = (
//
case+ key of
//
| "-i" =>
  {
    val () =
      (state.ninputfile := 0)
    // end of [val]
    val () = state.waitkind := WTKinput()
  } (* end of [-i] *)
//
| "-iife" =>
  {
    val () = state.waitkind := WTKiife()
    // end of [val]
   // val () = state.module := JSMiife()
  } (* end of [-iife] *)
//
| "-es6" =>
  {
    // end of [val]
    val () = state.module := JSMes6()
  } (* end of [-es6] *)
//
| "-commonjs" =>
  {
    // end of [val]
    val () = state.module := JSMcommonJS()
  } (* end of [-es6] *)
//
| "-o" =>
  {
    val () = state.waitkind := WTKoutput()
  } (* end of [-o] *)
//
| "-h" =>
  {
    val () = atscc2js_usage("atscc2js")
    val () = state.waitkind := WTKnone((*void*))
    val () =
    if state.ninputfile >= 0 then () else state.ninputfile := 0
  } (* end of [-h] *)
//
| _ (*unrecognized*) => comarg_warning(key)
//
) : void // end of [val]
//
in
  process_cmdline(state, arglst)
end // end of [process_cmdline2_comarg1]

and
process_cmdline2_comarg2
(
  state: &cmdstate >> _
, arglst: comarglst, key: string
) : void = let
//
val () = state.waitkind := WTKnone()
//
val () = (
//
case+ key of
//
| "--input" =>
  {
    val () = state.ninputfile := 0
    val () = state.waitkind := WTKinput()
  } (* end of [--input] *)
//
| "--output" =>
  {
    val () = state.waitkind := WTKoutput()
  } (* end of [--output] *)
//
| "--help" => {
    val () = atscc2js_usage("atscc2js")
    val () = state.waitkind := WTKnone((*void*))
    val () =
    if state.ninputfile >= 0 then () else state.ninputfile := 0
  } (* end of [--help] *)
//
| _ (*unrecognized*) => comarg_warning(key)
//
) : void // end of [val]
//
in
  process_cmdline(state, arglst)
end // end of [process_cmdline2_comarg2]

(* ****** ****** *)
//
extern
fun
comarg_parse(string):<> comarg
//
extern
fun
comarglst_parse{n:nat}
  (argc: int(n), argv: !argv(n)): list(comarg, n)
// end of [comarglst_parse]
//
(* ****** ****** *)

implement
comarg_parse
  (str) = let
//
fun
loop
{n:int}
{i:nat|i <= n} .<n-i>.
(
  str: string(n), n: int(n), i: int(i)
) :<(*void*)> comarg = 
(
if
(i < n)
then (
  if
  (str[i] != '-')
  then COMARG(i, str) else loop(str, n, i+1)
) else COMARG(n, str)
) (* end of [if] *)  
// end of [loop]
//
val str = g1ofg0(str)
val len = string_length (str)
//
in
  loop (str, sz2i(len), 0)
end // end of [comarg_parse]

(* ****** ****** *)

implement
comarglst_parse
  {n}(argc, argv) = let
//
fun
loop
  {i,j:nat | i <= n} .<n-i>.
(
  argv: !argv(n), i: int(i), res: list_vt(comarg, j)
) : list_vt (comarg, n-i+j) =
(
if i < argc
  then let
    val res = list_vt_cons(comarg_parse(argv[i]), res)
  in
    loop (argv, i+1, res)
  end // end of [then]
  else res // end of [else]
// end of [if]
) (* end of [loop] *)
//
val res =
  loop (argv, 0, list_vt_nil())
//
in
  list_vt2t (list_vt_reverse (res))
end // end of [comarglst_parse]

(* ****** ****** *)
//
extern
fun
atscc2js_main0
  {n:pos}
(
  argc: int(n), argv: !argv(n)
) : void =
  "ext#libatscc2js_atscc2js_main0"
//
implement
atscc2js_main0
  (argc, argv) =
{
//
val () =
  prerrln! ("Hello from atscc2js!")
//
//
val
arglst =
comarglst_parse(argc, argv)
//
val+list_cons(arg0, arglst) = arglst
//
var
state = @{
  comarg0= arg0
, ncomarg= 0 // counting from 0
, waitkind= WTKnone()
// number of prcessed
, ninputfile= ~1 // input files
, outchan= OUTCHANref(stdout_ref)
, nerror= 0 // number of accumulated errors
, module=JSnone() //module format 
} : cmdstate // end of [var]
//
val () = process_cmdline(state, arglst)
//
val () =
if
state.nerror = 1
then let
  val () =
  prerrln! ("atscc2js: there is a reported error.")
in
  // nothing
end // end of [then]
else if
state.nerror >= 2
then let
  val () =
  prerrln! ("atscc2js: there are some reported errors.")
in
  // nothing
end // end of [then]
else () // end of [else]
//
(*
val () =
prerrln! ("Good-bye from atscc2js!")
*)
//
} (* end of [atscc2js_main0] *)
//
(* ****** ****** *)

#ifndef
ATSCC2JS_MAIN_NONE
//
implement
main0(argc, argv) =
{
//
val () = atscc2js_main0(argc, argv)
//
} (* end of [main0] *)
//
#endif // ifndef(ATSCC2JS_MAIN_NONE)

(* ****** ****** *)

(* end of [atscc2js_main.dats] *)

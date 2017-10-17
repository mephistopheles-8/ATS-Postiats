(* ****** ****** *)
(*
** libatscc-common
*)
(* ****** ****** *)

(*
staload "./../../basics.sats"
*)

(* ****** ****** *)
//
fun
matrix0_make_elt
{a:t@ype}{m,n:nat}
( nrow: int(m)
, ncol: int(n), x0: a): matrix0(a) = "mac#%"
//
(* ****** ****** *)
//
fun
matrix0_nrow
{a:vt0p}(M: matrix0(a)): intGte(0) = "mac#%"
//
fun
matrix0_ncol
{a:vt0p}(M: matrix0(a)): intGte(0) = "mac#%"
//
(* ****** ****** *)
//
fun
matrix0_get_at
{a:t0p}(M: matrix0(a), i: int, j: int): a = "mac#%"
//
fun
matrix0_set_at
{a:t0p}(M: matrix0(a), i: int, j: int, x0: a): void = "mac#%"
//
fun
matrix0_exch_at
{a:vt0p}(M: matrix0(a), i: int, j: int, x0: a): (a) = "mac#%"
//
(* ****** ****** *)
//
overload [] with matrix0_get_at of 100
overload [] with matrix0_set_at of 100
//
overload nrow with matrix0_nrow of 100
overload ncol with matrix0_ncol of 100
//
(* ****** ****** *)

(* end of [matrix0.sats] *)

(***********************************************************************)
(*                                                                     *)
(*                         Applied Type System                         *)
(*                                                                     *)
(***********************************************************************)

(*
** ATS/Postiats - Unleashing the Potential of Types!
** Copyright (C) 2011-2012 Hongwei Xi, ATS Trustful Software, Inc.
** All rights reserved
**
** ATS is free software;  you can  redistribute it and/or modify it under
** the terms of the GNU LESSER GENERAL PUBLIC LICENSE as published by the
** Free Software Foundation; either version 2.1, or (at your option)  any
** later version.
**
** ATS is distributed in the hope that it will be useful, but WITHOUT ANY
** WARRANTY; without  even  the  implied  warranty  of MERCHANTABILITY or
** FITNESS FOR A PARTICULAR PURPOSE.  See the  GNU General Public License
** for more details.
**
** You  should  have  received  a  copy of the GNU General Public License
** along  with  ATS;  see the  file COPYING.  If not, please write to the
** Free Software Foundation,  51 Franklin Street, Fifth Floor, Boston, MA
** 02110-1301, USA.
*)

(* ****** ****** *)
//
// Author: Hongwei Xi (hwxi AT cs DOT bu DOT edu)
// Time: October, 2010
//
(* ****** ****** *)
//
// HX: reasoning about integer sequences
//
(* ****** ****** *)
//
// HX-2012-12: starting to implement proofs
//
(* ****** ****** *)

staload "libats/SATS/ilist_prf.sats"

(* ****** ****** *)

(*
prfun ilisteq_elim
  {xs1,xs2:ilist} (pf: ilisteq (xs1, xs2)): ILISTEQ (xs1, xs2)
// end of [ilisteq_elim]
*)
primplmnt
ilisteq_elim (pf) = let
//
prfun lemma
  {xs1,xs2:ilist} .<xs1>.
  (pf: ilisteq (xs1, xs2)): ILISTEQ (xs1, xs2) = let
in
  case+ pf of
  | ilisteq_cons (pf) => let
      prval ILISTEQ () = lemma (pf) in ILISTEQ ()
    end // end of [ILISTEQ_cons]
  | ilisteq_nil () => ILISTEQ ()
end // end of [lemma]
//
in
  lemma (pf)
end // end of [ilisteq_elim]

(* ****** ****** *)

(*
prfun length_istot {xs:ilist} (): [n:nat] LENGTH (xs, n)
*)
primplmnt
length_istot {xs} () = let
//
prfun lemma
  {xs:ilist} .<xs>. (): [n:nat] LENGTH (xs, n) = (
  scase xs of
  | ilist_cons (x, xs) => LENGTHcons (lemma {xs} ()) | ilist_nil () => LENGTHnil ()
) // end of [lemma]
//
in
  lemma {xs} ()
end // end of [length_istot]

(* ****** ****** *)

(*
prfun length_isfun {xs:ilist} {n1,n2:int}
  (pf1: LENGTH (xs, n1), pf2: LENGTH (xs, n2)): [n1==n2] void
// end of [length_isfun]
*)
primplmnt
length_isfun {xs} (pf1, pf2) = let
//
prfun lemma
  {xs:ilist} {n1,n2:int} .<xs>. (
  pf1: LENGTH (xs, n1), pf2: LENGTH (xs, n2)
) : [n1==n2] void = let
in
//
case+ (pf1, pf2) of
| (LENGTHcons (pf1),
   LENGTHcons (pf2)) => lemma (pf1, pf2)
| (LENGTHnil (), LENGTHnil ()) => ()
//
end // end of [length_isfun]
//
in
  lemma (pf1, pf2)
end // end of [length_isfun]

(* ****** ****** *)

(*
prfun length_isnat
  {xs:ilist} {n:int} (pf: LENGTH (xs, n)): [n>=0] void
// end of [length_isnat]
*)
primplmnt
length_isnat (pf) = (
  case+ pf of LENGTHcons _ => () | LENGTHnil () => ()
) // end of [length_isnat]

(* ****** ****** *)

(*
prfun lemma_snoc_length
  {xs:ilist} {x:int} {xsx:ilist} {n:nat}
  (pf1: SNOC (xs, x, xsx), pf2: LENGTH (xs, n)): LENGTH (xsx, n+1)
// end of [lemma_snoc_length]
*)
primplmnt
lemma_snoc_length
  (pf1, pf2) = let
//
prfun lemma
  {xs:ilist}
  {x:int}
  {xsx:ilist}
  {n:nat} .<xs>. (
  pf1: SNOC (xs, x, xsx), pf2: LENGTH (xs, n)
) : LENGTH (xsx, n+1) = let
in
//
case+ pf1 of
| SNOCnil () => let
    prval LENGTHnil () = pf2 in LENGTHcons (LENGTHnil ())
  end // end of [SNOCnil]
| SNOCcons (pf1) => let
    prval LENGTHcons (pf2) = pf2 in LENGTHcons (lemma (pf1, pf2))
  end // end of [SNOCcons]
//
end // end of [lemma]
//
in
  lemma (pf1, pf2)
end // end of [lemma_snoc_length]

(* ****** ****** *)

primplmnt
append_unit_left () = APPENDnil ()

primplmnt
append_unit_right {xs} () = let
//
prfun lemma
  {xs:ilist} .<xs>. (
) : APPEND (xs, ilist_nil, xs) =
  scase xs of
  | ilist_cons (x, xs) => APPENDcons (lemma {xs} ())
  | ilist_nil () => APPENDnil ()
//
in
  lemma {xs} ()
end // end of [append_unit_right]

(* ****** ****** *)

(*
prfun
lemma_append_length
  {xs1,xs2:ilist}
  {xs:ilist}
  {n1,n2:int} (
  pf: APPEND (xs1, xs2, xs), pf1len: LENGTH (xs1, n1), pf2len: LENGTH (xs2, n2)
) : LENGTH (xs, n1+n2) // end of [lemma_append_length]
*)
primplmnt
lemma_append_length
  (pf, pf1len, pf2len) = let
//
prfun lemma
  {xs1,xs2:ilist}
  {xs:ilist}
  {n1,n2:nat} .<xs1>. (
  pf: APPEND (xs1, xs2, xs), pf1len: LENGTH (xs1, n1), pf2len: LENGTH (xs2, n2)
) : LENGTH (xs, n1+n2) = let
in
//
case+ pf of
| APPENDnil () => let
    prval LENGTHnil () = pf1len in pf2len
  end // end of [APPENDnil]
| APPENDcons (pf) => let
    prval LENGTHcons (pf1len) = pf1len in LENGTHcons (lemma (pf, pf1len, pf2len))
  end // end of [APPENDcons]
//
end // end of [lemma]
//
prval () = length_isnat (pf1len)
prval () = length_isnat (pf2len)
//
in
  lemma (pf, pf1len, pf2len)
end // end of [lemma_append_length]

(* ****** ****** *)

(*
prfun
lemma_append_snoc
  {xs1:ilist}
  {x:int}
  {xs2:ilist}
  {xs1x:ilist}
  {xs:ilist} (
  pf1: APPEND (xs1, ilist_cons (x, xs2), xs)
, pf2: SNOC (xs1, x, xs1x)
) : APPEND (xs1x, xs2, xs) // end of [lemma_append_snoc]
*)
primplmnt
lemma_append_snoc
  (pf1, pf2) = let
//
prfun
lemma
  {xs1:ilist}
  {x:int}
  {xs2:ilist}
  {xs1x:ilist}
  {xs:ilist} .<xs1>. (
  pf1: APPEND (xs1, ilist_cons (x, xs2), xs)
, pf2: SNOC (xs1, x, xs1x)
) : APPEND (xs1x, xs2, xs) = let
in
//
case+ pf1 of
| APPENDnil () => let
    prval SNOCnil () = pf2 in APPENDcons (APPENDnil)
  end // end of [APPENDnil]
| APPENDcons (pf1) => let
    prval SNOCcons (pf2) = pf2 in APPENDcons (lemma (pf1, pf2))
  end // end of [APPENDcons]
//
end // end of [lemma]
//
in
  lemma (pf1, pf2)
end // end of [lemma_append_snoc]

(* ****** ****** *)

(*
prfun
lemma_append_assoc
  {xs1,xs2,xs3:ilist}
  {xs12,xs23:ilist}
  {xs12_3,xs1_23:ilist} (
  pf12: APPEND (xs1, xs2, xs12), pf23: APPEND (xs2, xs3, xs23)
, pf12_3: APPEND (xs12, xs3, xs12_3), pf1_23: APPEND (xs1, xs23, xs1_23)
) : ILISTEQ (xs12_3, xs1_23) // end of [lemma_append_assoc]
*)
primplmnt
lemma_append_assoc (
  pf12, pf23, pf12_3, pf1_23
) = let
//
prfun
lemma
  {xs1,xs2,xs3:ilist}
  {xs12,xs23:ilist}
  {xs12_3,xs1_23:ilist} .<xs1>. (
  pf12: APPEND (xs1, xs2, xs12), pf23: APPEND (xs2, xs3, xs23)
, pf12_3: APPEND (xs12, xs3, xs12_3), pf1_23: APPEND (xs1, xs23, xs1_23)
) : ILISTEQ (xs12_3, xs1_23) = let
in
//
case+ pf12 of
| APPENDnil () => let
    prval APPENDnil () = pf1_23
    prval ILISTEQ () = append_isfun (pf23, pf12_3)
  in
    ILISTEQ ()
  end // end of [APPENDnil]
| APPENDcons (pf12) => let
    prval APPENDcons (pf12_3) = pf12_3
    prval APPENDcons (pf1_23) = pf1_23
    prval ILISTEQ () = lemma (pf12, pf23, pf12_3, pf1_23)
  in
    ILISTEQ ()
  end // end of [APPENDcons]
//
end // end of [lemma]
//
in
  lemma (pf12, pf23, pf12_3, pf1_23)
end // end of [lemma_append_assoc]

(* ****** ****** *)

(*
prfun lemma_nth_ilisteq
  {xs1,xs2:ilist}{n:nat} (
  pf1len: LENGTH (xs1, n), pf2len: LENGTH (xs2, n)
, fpf: {i:nat | i < n}{x:int} NTH (x, xs1, i) -> NTH (x, xs2, i)
) : ILISTEQ (xs1, xs2) =
*)
primplmnt
lemma_nth_ilisteq
  (pf1len, pf2len, fpf) = let
//
prfun
lemma
  {xs1,xs2:ilist}
  {n:nat} .<n>. (
  pf1len: LENGTH (xs1, n)
, pf2len: LENGTH (xs2, n)
, fpf: {i:nat | i < n}{x:int} NTH (x, xs1, i) -> NTH (x, xs2, i)
) : ILISTEQ (xs1, xs2) =
  sif n > 0 then let
    prval LENGTHcons {x1}{xs11} pf11len = pf1len
    prval LENGTHcons {x2}{xs21} pf21len = pf2len
    prval NTHbas () = fpf {0}{x1} (NTHbas ())
    prfn fpf1
      {i:nat | i < n-1}
      {x:int} (pf: NTH (x, xs11, i)): NTH (x, xs21, i) = let
      prval NTHind (pfres) = fpf (NTHind (pf))
    in
      pfres
    end // end of [fpf1]
    prval ILISTEQ () = lemma (pf11len, pf21len, fpf1)
  in
    ILISTEQ ()
  end else let
    prval LENGTHnil () = pf1len
    prval LENGTHnil () = pf2len
  in
    ILISTEQ ()
  end // end of [sif]
//
in
  lemma (pf1len, pf2len, fpf)
end // end of [lemma_nth_ilisteq]

(* ****** ****** *)

(*
prfun lemma_revapp_length
  {xs,ys,zs:ilist}{m,n:nat} .<xs>. (
  pf1: REVAPP (xs, ys, zs), pf2: LENGTH (xs, m), pf3: LENGTH (ys, n)
) : LENGTH (zs, m+n) // end of [lemma_revapp_length]
*)
primplmnt
lemma_revapp_length
  (pf, pf1len, pf2len) = let
//
prfun
lemma
  {xs,ys,zs:ilist}
  {m,n:nat} .<xs>. (
  pf: REVAPP (xs, ys, zs)
, pf1len: LENGTH (xs, m), pf2len: LENGTH (ys, n)
) : LENGTH (zs, m+n) = let
in
//
case+ pf of
| REVAPPnil () => let
    prval LENGTHnil () = pf1len in pf2len
  end // end of[REVAPPnil]
| REVAPPcons (pf) => let
    prval LENGTHcons (pf1len) = pf1len
  in
    lemma (pf, pf1len, LENGTHcons (pf2len))
  end // end of [REVAPPcons]
//
end // end of [revapp_length_lemma]
//
prval () = length_isnat (pf1len)
prval () = length_isnat (pf2len)
//
in
  lemma (pf, pf1len, pf2len)
end // end of [lemma_revapp_length]

(* ****** ****** *)

(*
prfun lemma1_revapp_nth
  {xs,ys,zs:ilist}{n:nat}{x:int}{i:nat} (
  pf: REVAPP (xs, ys, zs), pflen: LENGTH (xs, n), pfnth: NTH (x, ys, i)
) : NTH (x, zs, n+i) // end of [lemma1_revapp_nth]
*)
primplmnt
lemma1_revapp_nth
  (pf, pflen, pfnth) = let
//
prfun lemma
  {xs,ys,zs:ilist}{n:nat}{x:int}{i:nat} .<xs>. (
  pf: REVAPP (xs, ys, zs), pflen: LENGTH (xs, n), pfnth: NTH (x, ys, i)
) : NTH (x, zs, n+i) = let
in
//
case+ pf of
| REVAPPnil () => let
    prval LENGTHnil () = pflen in pfnth
  end // end of [REVAPPnil]
| REVAPPcons (pf) => let
    prval LENGTHcons (pflen) = pflen in lemma (pf, pflen, NTHind (pfnth))
  end // end of[REVAPPcons]
//
end // end of [lemma1_revapp_nth]
//
in
  lemma (pf, pflen, pfnth)
end // end of [lemma1_revapp_nth]

(* ****** ****** *)

(*
prfun lemma2_revapp_nth
  {xs,ys,zs:ilist}{n:nat}{x:int}{i:nat} (
  pf: REVAPP (xs, ys, zs), pflen: LENGTH (xs, n), pfnth: NTH (x, xs, i)
) : NTH (x, zs, n-1-i) // end of [lemma2_revapp_nth]
*)
primplmnt
lemma2_revapp_nth
  (pf, pflen, pfnth) = let
//
prfun lemma
  {xs,ys,zs:ilist}{n:nat}{x:int}{i:nat} .<i>. (
  pf: REVAPP (xs, ys, zs), pflen: LENGTH (xs, n), pfnth: NTH (x, xs, i)
) : NTH (x, zs, n-1-i) = let
in
//
case+ pfnth of
| NTHbas () => let
    prval REVAPPcons (pf) = pf
    prval LENGTHcons pflen = pflen
  in
    lemma1_revapp_nth (pf, pflen, NTHbas ())
  end // end of [NTHbas]
| NTHind (pfnth) => let
    prval REVAPPcons (pf) = pf
    prval LENGTHcons (pflen) = pflen
  in
    lemma (pf, pflen, pfnth)
  end // end of [NTHind]
//
end // end of [lemma]
//
in
  lemma (pf, pflen, pfnth)
end // end of [lemma2_revapp_nth]

(* ****** ****** *)

primplmnt
lemma_reverse_nth
  (pf, pflen, pfnth) = lemma2_revapp_nth (pf, pflen, pfnth)
// end of [lemma_reverse_nth]    

(* ****** ****** *)

primplmnt
lemma_reverse_symm {xs,ys} (pf) = let
//
prval [n:int] pflen_xs = length_istot {xs} ()
prval pflen_ys = lemma_revapp_length (pf, pflen_xs, LENGTHnil ())
prval [zs:ilist] pf2 = revapp_istot {ys,ilist_nil} ()
prval pflen_zs = lemma_revapp_length (pf2, pflen_ys, LENGTHnil ())
//
prfn fpf {i:nat | i < n}{x:int}
  (pfnth: NTH (x, xs, i)): NTH (x, zs, i) = let
  prval pf2nth = lemma_reverse_nth (pf, pflen_xs, pfnth)
in
  lemma_reverse_nth (pf2, pflen_ys, pf2nth)
end // end of [fpf]
//
prval ILISTEQ () = lemma_nth_ilisteq (pflen_xs, pflen_zs, fpf)
//
in
  pf2
end // end of [lemma_reverse_symm]

(* ****** ****** *)

(* end of [ilist_prf.dats] *)

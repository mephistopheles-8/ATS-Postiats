(***********************************************************************)
(*                                                                     *)
(*                         Applied Type System                         *)
(*                                                                     *)
(***********************************************************************)

(*
** ATS/Postiats - Unleashing the Potential of Types!
** Copyright (C) 2011-20?? Hongwei Xi, ATS Trustful Software, Inc.
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
// Author: Hongwei Xi (gmhwxi AT gmail DOT com)
// Start Time: March, 2013
//
(* ****** ****** *)

%{#
#include "libc/CATS/string.cats"
%} // end of [%{#]

(* ****** ****** *)

#define ATS_PACKNAME "ATSLIB.libc"
#define ATS_STALOADFLAG 0 // no need for staloading at run-time
#define ATS_EXTERN_PREFIX "atslib_" // prefix for external names

(* ****** ****** *)

#define NSH (x) x // for commenting: no sharing
#define SHR (x) x // for commenting: it is shared

(* ****** ****** *)

fun strcmp (x1: string, x2: string):<> int = "mac#%"
fun strncmp (x1: string, x2: string, n: size_t):<> int = "mac#%"

(* ****** ****** *)

fun strcoll (x1: string, x2: string):<> int = "mac#%"

(* ****** ****** *)

fun strspn (x1: string, x2: string):<> size_t = "mac#%"
fun strcspn (x1: string, x2: string):<> size_t = "mac#%"

(* ****** ****** *)
//
fun strlen
  {n:int} (x: string n):<> size_t (n) = "mac#%"
fun strnlen {m,n:int}
  (x: string n, max: size_t m):<> size_t (min(m,n)) = "mac#%"
//
(* ****** ****** *)

fun strcat
  {l:addr}{m:int}{n1,n2:int | n1+n2 < m}
(
  !strbuf (l, m, n1) >> strbuf (l, m, n1+n2) | ptr (l), string (n2)
) :<!wrt> ptr (l) = "mac%#" // end of [strcat]

fun strcat_unsafe
  {l:agz} (x1: ptr (l), x2: string):<!wrt> ptr (l) = "mac%#"
fun strncat_unsafe
  {l:agz} (x1: ptr (l), x2: string, n: size_t):<!wrt> ptr (l) = "mac%#"

(* ****** ****** *)

absview strdup_view (l:addr)
viewdef strdup_v (l:addr) = strdup_view (l)

fun strdup
(
  str: string
) :<!wrt> [l:addr] (strdup_v (l) | strptr (l)) = "mac#%"
fun strndup
(
  str: string
) :<!wrt> [l:addr] (strdup_v (l) | strptr (l)) = "mac#%"

fun strdup_free
  {l:addr} (pf: strdup_v (l) | x: strptr l):<!wrt> void = "mac#%"
// end of [strdup_free]

(* ****** ****** *)
//
// HX-2013-03:
// strdupa-functions are gcc-functions;
// they use alloca for memory allocation
//
absview strdupa_view (l:addr)
viewdef strdupa_v (l:addr) = strdupa_view (l)

fun strdupa
(
  str: string
) :<!wrt> [l:addr] (strdupa_v (l) | strptr (l)) = "mac#%"
fun strndupa
(
  str: string
) :<!wrt> [l:addr] (strdupa_v (l) | strptr (l)) = "mac#%"

fun strdupa_free
  {l:addr} (pf: strdupa_v (l) | x: strptr l):<!wrt> void = "mac#%"
// end of [strdupa_free]

(* ****** ****** *)

(* end of [string.sats] *)

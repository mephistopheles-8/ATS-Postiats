######
#
# A simple Makefile for
# testing the ATS API for cairo
#
######

PATSHOMEQ="$(PATSHOME)"

######

PATSCC=$(PATSHOMEQ)/bin/patscc
PATSOPT=$(PATSHOMEQ)/bin/patsopt

######

XRLIBS=`pkg-config cairo --libs`
XRCFLAGS=`pkg-config cairo --cflags`

######

.PHONY: all

######

all::
regress::
cleanall::

######

all:: test00
all:: test01
all:: test02
all:: test03
all:: test04
all:: test05-1
all:: test05-2
all:: test06
all:: test07
all:: test08
all:: test09

######

regress:: test00; ./$<
regress:: test01; ./$<
regress:: test02; ./$<
regress:: test03; ./$<
regress:: test04; ./$<
regress:: test05-1; ./$<
regress:: test05-2; ./$<
regress:: test06; ./$<
regress:: test07; ./$<
regress:: test08; ./$<
regress:: test09; ./$<

######

cleanall:: ; $(RMF) test00
cleanall:: ; $(RMF) test01
cleanall:: ; $(RMF) test02
cleanall:: ; $(RMF) test03
cleanall:: ; $(RMF) test04
cleanall:: ; $(RMF) test05-1
cleanall:: ; $(RMF) test05-2
cleanall:: ; $(RMF) test06
cleanall:: ; $(RMF) test07
cleanall:: ; $(RMF) test08
cleanall:: ; $(RMF) test09

######

test00: test00.dats ; \
  $(PATSCC) -I./../.. $(XRCFLAGS) -o $@ $< $(XRLIBS) -lm 
test01: test01.dats ; \
  $(PATSCC) -I./../.. $(XRCFLAGS) -o $@ $< $(XRLIBS) -lm 
test02: test02.dats ; \
  $(PATSCC) -I./../.. $(XRCFLAGS) -o $@ $< $(XRLIBS) -lm 
test03: test03.dats ; \
  $(PATSCC) -I./../.. $(XRCFLAGS) -o $@ $< $(XRLIBS) -lm 
test04: test04.dats ; \
  $(PATSCC) -I./../.. $(XRCFLAGS) -o $@ $< $(XRLIBS) -lm 
test05-1: test05-1.dats ; \
  $(PATSCC) -I./../.. $(XRCFLAGS) -o $@ $< $(XRLIBS) -lm 
test05-2: test05-2.dats ; \
  $(PATSCC) -I./../.. $(XRCFLAGS) -o $@ $< $(XRLIBS) -lm 
test06: test06.dats ; \
  $(PATSCC) -I./../.. $(XRCFLAGS) -o $@ $< $(XRLIBS) -lm 
test07: test07.dats ; \
  $(PATSCC) -I./../.. $(XRCFLAGS) -o $@ $< $(XRLIBS) -lm 
test08: test08.dats ; \
  $(PATSCC) -DATS_MEMALLOC_LIBC -I./../.. $(XRCFLAGS) -o $@ $< $(XRLIBS) -lm 
test09: test09.dats ; \
  $(PATSCC) -I./../.. $(XRCFLAGS) -o $@ $< $(XRLIBS) -lm 

######

all:: \
cairo-multable
cairo-multable: \
cairo-multable.dats ; \
  $(PATSCC) -I./../.. $(XRCFLAGS) -o $@ $< $(XRLIBS) -lm 
regress:: cairo-multable; ./$<
cleanall:: ; $(RMF) cairo-multable

######

all:: \
cairo-Bulge02c
cairo-Bulge02c: \
cairo-Bulge02c.dats ; \
  $(PATSCC) -I./../.. $(XRCFLAGS) -o $@ $< $(XRLIBS) -lm 
regress:: cairo-Bulge02c; ./$<
cleanall:: ; $(RMF) cairo-Bulge02c

######

testall:: all
testall:: regress
testall:: cleanall

######

RMF=rm -f

######

clean:: ; $(RMF) *~
clean:: ; $(RMF) *_?ats.o *_?ats.c
clean:: ; $(RMF) *_atxt.txt
clean:: ; $(RMF) *_atxt.dats

cleanall:: clean
cleanall:: ; $(RMF) *.png
cleanall:: ; $(RMF) cairo-multable.ps

######

###### end of [Makefile] ######


INCLUDE "fortISSimO/main.asm"

TestSong::
    db 7 ; Tempo
    dw order1 ; CH1 order table
    dw order2 ; CH2 order table
    dw order3 ; CH3 order table
    dw order4 ; CH4 order table

order1:
    db 1
    dw empty
    ; Table of the IDs of the 15 instruments this pattern will use
    db 0

order2:
    db 1
    dw empty
    ; Table of the IDs of the 15 instruments this pattern will use
    db 0

order3:
    db 2
    dw tfau_bass
    dw tfau_bass2
    ; Table of the IDs of the 15 instruments this pattern will use
    db 1
    db 2

order4:
    db 1
    dw empty
    ; Table of the IDs of the 15 instruments this pattern will use
    db 3


lunawaves:
include "TestPatterns/lunawaves.inc"

unreal:
include "TestPatterns/unreal.inc"

unreal_arps:
include "TestPatterns/unreal_arps.inc"

tfau_arps:
include "TestPatterns/tfau_arps.inc"

tfau_bass:
include "TestPatterns/tfau_bass.inc"

tfau_bass2:
include "TestPatterns/tfau_bass2.inc"

empty:
rept 64
    row ___, 0, 0
endr

silence:
    row C_4, 1, $C00
rept 63
    row ___, 0, $000
endr

silence3:
    row C_4, 2, $C00
rept 63
    row ___, 0, $000
endr

testpatt:
rept 16
    row C_4, 1, $000
    row ___, 0, $000
    row ___, 0, $000
    row ___, 0, $000
    row ___, 0, $000
    row ___, 0, $000
    row ___, 0, $000
    row ___, 0, $000
endr

testpatt2:
    row C_4, 1, $000
rept 16
    row D_4, 0, $000
    row ___, 0, $000
    row ___, 0, $000
    row ___, 0, $000
    row ___, 0, $000
    row ___, 0, $000
    row ___, 0, $000
    row ___, 0, $000
endr

drums:
rept 16
    row C_4, 1, 0
    row ___, 0, 0
    row ___, 0, 0
    row ___, 0, 0
    row ___, 0, 0
    row ___, 0, 0
    row ___, 0, 0
    row ___, 0, 0
endr

walkup:
_ASDF = C_3
rept 64
    row _ASDF, 1, 0
_ASDF = _ASDF + 1
endr

slideup:
  row C_3, 1, $000
rept 63
    row ___, 0, $10C
endr

arps:
rept 64
    row C_5, 1, $047
endr

vib:
    row C_5, 1, $4C8
rept 63
    row ___, 00, $400
endr

updown:
    row G_3, 1, $105
rept 31
    row ___, 0, $105
endr
rept 32
    row ___, 0, $205
endr

volset:
    row C_5, 1, $000
rept 32
    row ___, 0, $C90
    row ___, 0, $CF0
endr

notecut:
rept 32
    row C_5, 1, $E04
    row ___, 0, $000
endr

notedelay:
rept 32
    row C_5, 1, 00
    row D#5, 0, $704
endr

volslide:
    row C_5, 1, 00
rept 63
    row ___, 0, $AF9
endr

setduty:
    row C_5, 1, $F04
rept 21
    row ___, 0, $900
    row ___, 0, $940
    row ___, 0, $980
    row ___, 0, $9C0
endr

setpan:
    row C_5, 1, $811
    rept 15
    row ___, 0, 00
    endr
    row C_5, 1, $801
    rept 15
    row ___, 0, 00
    endr
    row C_5, 1, $810
    rept 15
    row ___, 00, 00
    endr
    row C_5, 00, $800
    rept 15
    row ___, 00, 00
    endr


;;;;;;;;;;;;;;;;
;; Instruments
;;;;;;;;;;;;;;;;

;; Instruments come in blocks.

hUGE_Instruments::

;; Format for channels 1 and 2:

    db %11000000 ; rNRx4 mask
    db %11110000 ; rNRx2: envelope
    db %10000001 ; rNRx1: duty & length
    db 0 ; rNRx0: sweep, ignored for CH2

;; Format for channel 3:

    db %10000000 ; rNR34 mask
    db %00100000 ; rNR32: envelope
    db 0         ; rNR31: length
    db $00       ; Index into wave collection, multiplied by 16

    db %10000000
    db %00100000
    db 0
    db $10

;; Format for channel 4:

    db %10000000 ; rNR44 mask
    db 0         ; rNR43: LFSR width
    db %10100001 ; rNR42: envelope
    db 0         ; rNR41: length


;;;;;;;;;;;;;
;; Routines
;;;;;;;;;;;;;

hUGE_UserRoutines::

;; This must be a table of pointers to the routines
;; A routine will first be called with carry reset, on tick 0; then with carry set on all ticks (including a second time on tick 0)
;; If a routine returns carry set, then it will stop being called


;;;;;;;;;;
;; Waves
;;;;;;;;;;

hUGE_Waves::

rept 16
db %11110000
endr

rept 8
db %11111111
db %00000000
endr

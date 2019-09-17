;ines header
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    .inesprg 1  ; 1x 16KB PRG code
    .ineschr 1  ; 1x  8KB CHR data
    .inesmap 4
    .inesmir 1  ; background mirroring

;Declare some constants here
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

STATE_TITLE = 0
STATE_PLAYING = 1
STATE_OVER = 2

BUTTON_A = $80
BUTTON_B = $40
BUTTON_SELECT = $20
BUTTON_START = $10
BUTTON_UP = $08
BUTTON_DOWN = $04
BUTTON_LEFT = $02
BUTTON_RIGHT = $01

WALL_TOP = $17
WALL_BOTTOM = $A7
WALL_RIGHT = $F0
WALL_LEFT = $10

PLAYER1_WIDTH = $07
PLAYER1_HEIGHT = $08
PLAYER1_SWORD_WIDTH = $08
PLAYER1_SWORD_HEIGHT = $08
PLAYER2_WIDTH = $07
PLAYER2_HEIGHT = $08
PLAYER2_SWORD_WIDTH = $08
PLAYER2_SWORD_HEIGHT = $08

DIRECTION_RIGHT = 0
DIRECTION_LEFT = 1
DIRECTION_DOWN = 2
DIRECTION_UP = 3

PLAYER1_Y = $0200
PLAYER1_SPR = $0201
PLAYER1_ATTR = $0202
PLAYER1_X = $0203
PLAYER1_SWORD_Y = $0208
PLAYER1_SWORD_SPR = $0209
PLAYER1_SWORD_ATTR = $020A
PLAYER1_SWORD_X = $020B

PLAYER2_Y = $0204
PLAYER2_SPR = $0205
PLAYER2_ATTR = $0206
PLAYER2_X = $0207
PLAYER2_SWORD_Y = $020C
PLAYER2_SWORD_SPR = $020D
PLAYER2_SWORD_ATTR = $020E
PLAYER2_SWORD_X = $020F

PLAYER1_LIFE_LOW = $22
PLAYER1_LIFE_HIGH = $E8
PLAYER2_LIFE_LOW = $22
PLAYER2_LIFE_HIGH = $F8

LIFE_INIT = $03


;Declare some macros here
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


;Declare variables 
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    .rsset $0000  ;;start variables at ram location 0
test    .rs 1
test2   .rs 1
test3   .rs 1
test4   .rs 1

conroller1    .rs 1
conroller1pre .rs 1
conroller2    .rs 1
conroller2pre .rs 1

game_state  .rs 1

player1_x   .rs 1
player1_y   .rs 1
player1_spr .rs 1
player1_stelth  .rs 1
player1_sword_x   .rs 1
player1_sword_y   .rs 1
player1_sword_spr   .rs 1
player1_sword_state .rs 1
player1_sword_hit   .rs 1
player1_life    .rs 1
player1_hit_right_top    .rs 1
player1_hit_right_bottom   .rs 1
player1_hit_left_top    .rs 1
player1_hit_left_bottom   .rs 1
player1_hit_top_right   .rs 1
player1_hit_top_left   .rs 1
player1_hit_bottom_right   .rs 1
player1_hit_bottom_left   .rs 1



player2_x   .rs 1
player2_y   .rs 1
player2_spr .rs 1
player2_stelth  .rs 1
player2_sword_x   .rs 1
player2_sword_y   .rs 1
player2_sword_spr   .rs 1
player2_sword_state .rs 1
player2_sword_hit   .rs 1
player2_life    .rs 1

window_counter  .rs 1

tmp .rs 1
tmp2    .rs 1
source_addr_low    .rs 1
source_addr_high   .rs 1
ppu_addr_low    .rs 1
ppu_addr_high   .rs 1
general_counter .rs 1
arg .rs 1   ; argument for subroutine

;Initial settings
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    .bank 0
    .org $C000
main:

vWait1:
    bit $2002
    bpl vWait1

loadPalettes:
    lda $2002   ; reset high/low latch
    lda #$3F
    sta $2006
    lda #$00
    sta $2006
    ldx #$00
.loop:
    lda palette, x
    sta $2007
    inx
    cpx #$20
    bne .loop

vWait2:
    bit $2002
    bpl vWait2

titleNametables:
    lda $2002
    lda #$20
    sta $2006
    lda #$00
    sta $2006

    lda #LOW(titleNametable)
    sta source_addr_low
    lda #HIGH(titleNametable)
    sta source_addr_high

    ldx #$00
.loop:
    ldy #$00
.loop2:
    lda [source_addr_low], y
    sta $2007
    iny
    cpy #$20
    bne .loop2

    lda source_addr_low
    clc
	adc #$20
    sta source_addr_low
    lda source_addr_high
    adc #$00
    sta source_addr_high

    inx
    cpx #$1E
    bne .loop

titleAttrs:
    lda $2002
    lda #$23
    sta $2006
    lda #$C0
    sta $2006

    lda #LOW(titleAttr)
    sta source_addr_low
    lda #HIGH(titleAttr)
    sta source_addr_high

    ldy #$00
.loop:
    lda [source_addr_low], y
    sta $2007
    iny
    cpy #$40
    bne .loop


;Variable initialize
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

    lda #$FF
    sta conroller1
    sta conroller1pre

    lda #STATE_TITLE
    sta game_state


    lda #$20
    sta player1_sword_spr

    lda #%10010000  ; enable NMI
    sta $2000
    lda #%00011110  ; enable spr/BG
    sta $2001

    cli ; enable IRQ

forever:
    jmp forever

;Main Loop
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
NMI:

    lda #%10010000  ; PPU clean up
    sta $2000
    lda #%00011110
    sta $2001
    lda #$00
    sta $2005
    sta $2005

    jsr readController1
    jsr readController2

    inc general_counter

gameEngine:
.title:
    lda game_state
    cmp #STATE_TITLE
    bne .playing
    jsr engineTitle
    jmp .done
.playing:
    lda game_state
    cmp #STATE_PLAYING
    bne .over
    jsr enginePlaying
.over:
    lda game_state
    cmp #STATE_OVER
    bne .done
    jsr engineOver
.done:

    rti

;Title scene
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    .include "engineTitle.asm"

;Playing scene
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    .include "enginePlaying.asm"

;Over scene
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    .include "engineOver.asm"

;IRQ
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
IRQ:

    rti


    .include "subroutine.asm"

;Some datas
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

palette:
    .incbin "palette.pal"

titleNametable:
    .incbin "title.tile"
titleAttr:
    .incbin "title.attr"

playingNametable:
    .incbin "playing_beta.tile"
playingAttr:
    .incbin "playing_beta.attr"

winerWindow:
    .incbin "winner_window.tile"
winerWindowAttr1:
    .incbin "winner_window1.attr"
winerWindowAttr2:
    .incbin "winner_window2.attr"

;Vectors
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    .bank 1
    .org $E000
RESET:
    sei         ; disanle IRQs
    cld         ; disable decimal mode
    ldx #$40
    stx $4017   ; disable APU frame IRQ(?)
    ldx #$FF
    txs         ; setup stack
    inx
    stx $2000   ; disable NMI
    stx $2001   ; disable rendering
    stx $4010   ; disable DMC IRQs(?)
    lda #$00
    sta $A000   ; nametable mirroring
    sta $4015   ; sound register iniitialize

vblankWait1:
    bit $2002
    bpl vblankWait1

clearMemory:
    lda #$00
    sta $0000, x
    sta $0100, x
    sta $0300, x
    sta $0400, x
    sta $0500, x
    sta $0600, x
    sta $0700, x
    lda #$FE
    sta $0200, x    ; init sprite DMA space $FE
    inx
    bne clearMemory

initSprites:
    lda #$02
    sta $4014; sprite DMA

initBank:
    ldx #0
.initBankLoop:
    lda initBankTable, x
    stx $8000   ; select bank
    sta $8001   ; select data
    inx
    cpx #8
    bne .initBankLoop

    jmp main

initBankTable:
    .db $00,$02,$04,$05,$06,$07,$00,$00

    .org $FFFA
    .dw NMI
    .dw RESET
    .dw IRQ

;Character datas
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

    .bank 2
    .org $0000
    .incbin "chr.chr"   ;includes 8KB graphics file from SMB1
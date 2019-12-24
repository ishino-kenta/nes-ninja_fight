;ines header
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    .inesprg 1  ; 1x 16KB PRG code
    .ineschr 1  ; 1x  8KB CHR data
    .inesmap 4
    .inesmir 1  ; background mirroring

;Declare some constants here
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

TRUE = $01
FALSE = $00

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
PLAYER_SWORD_LENGTH = $08
PLAYER_SWORD_WIDTH = $07
PLAYER2_WIDTH = $07
PLAYER2_HEIGHT = $08

DIRECTION_RIGHT = $00
DIRECTION_LEFT = $01
DIRECTION_DOWN = $02
DIRECTION_UP = $03

PLAYER1_LIFE_HIGH = $22
PLAYER1_LIFE_LOW = $E8
PLAYER1_SWORD_HIGH = $23
PLAYER1_SWORD_LOW = $08
PLAYER2_LIFE_HIGH = $22
PLAYER2_LIFE_LOW = $F8
PLAYER2_SWORD_HIGH = $23
PLAYER2_SWORD_LOW = $18


LIFE_INIT = $04

SWORD_MAX = $04

FLOOR = $02

;Declare some macros here
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


;Declare variables 
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    .rsset $0000  ;;start variables at ram location 0
test    .rs 1
test2   .rs 1
test3   .rs 1
test4   .rs 1

controller1    .rs 1
controller1pre .rs 1
controller2    .rs 1
controller2pre .rs 1

game_state  .rs 1

player1_stelth  .rs 1
player1_sword_state .rs 1
player1_sword_hit   .rs 1
player1_life    .rs 1
player1_atacking_counter    .rs 1
player1_speed   .rs 1
player1_speed_level   .rs 1
player1_move_flag   .rs 1



player2_stelth  .rs 1
player2_sword_state .rs 1
player2_sword_hit   .rs 1
player2_life    .rs 1
player2_atacking_counter    .rs 1
player2_speed   .rs 1
player2_speed_level   .rs 1
player2_move_flag   .rs 1

window_counter  .rs 1

tmp .rs 1
tmp2    .rs 1
tmp3    .rs 1
tmp4    .rs 1
source_addr_low    .rs 1
source_addr_high   .rs 1
ppu_addr_low    .rs 1
ppu_addr_high   .rs 1
general_counter .rs 1

walk_counter    .rs 1

item_flag .rs 1
item_kind   .rs 1
item_counter    .rs 2
item_counter_inc    .rs 1




player1_sword   .rs 1
player2_sword   .rs 1

player1_sword_counter   .rs 1
player2_sword_counter   .rs 1

player1_sword_level    .rs 1
player2_sword_level    .rs 1


player1_direction   .rs 1

player2_direction   .rs 1


    .rsset $0200
player1_y   .rs 1
player1_spr .rs 1
player1_attr    .rs 1
player1_x   .rs 1

player2_y   .rs 1
player2_spr .rs 1
player2_attr    .rs 1
player2_x   .rs 1

player1_sword1_y   .rs 1
player1_sword1_spr   .rs 1
player1_sword1_attr   .rs 1
player1_sword1_x   .rs 1

player1_sword2_y   .rs 1
player1_sword2_spr   .rs 1
player1_sword2_attr   .rs 1
player1_sword2_x   .rs 1

player1_sword3_y   .rs 1
player1_sword3_spr   .rs 1
player1_sword3_attr   .rs 1
player1_sword3_x   .rs 1

player1_sword4_y   .rs 1
player1_sword4_spr   .rs 1
player1_sword4_attr   .rs 1
player1_sword4_x   .rs 1

player2_sword1_y   .rs 1
player2_sword1_spr   .rs 1
player2_sword1_attr   .rs 1
player2_sword1_x   .rs 1

player2_sword2_y   .rs 1
player2_sword2_spr   .rs 1
player2_sword2_attr   .rs 1
player2_sword2_x   .rs 1

player2_sword3_y   .rs 1
player2_sword3_spr   .rs 1
player2_sword3_attr   .rs 1
player2_sword3_x   .rs 1

player2_sword4_y   .rs 1
player2_sword4_spr   .rs 1
player2_sword4_attr   .rs 1
player2_sword4_x   .rs 1

item_y  .rs 1
item_spr    .rs 1
item_attr    .rs 1
item_x  .rs 1

;Initial settings
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    .bank 0
    .org $C000
Main:

.vw1:
    bit $2002
    bpl .vw1

LoadPalettes:
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

.vw2:
    bit $2002
    bpl .vw2

TitleNametables:
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

TitleAttrs:
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
    sta controller1
    sta controller1pre

    lda #STATE_TITLE
    sta game_state


    lda #%10010000  ; enable NMI
    sta $2000
    lda #%00011110  ; enable spr/BG
    sta $2001

Forever:
    jmp Forever

titleNametable:
    .incbin "src/graphic/title.tile"
titleAttr:
    .incbin "src/graphic/title.attr"


;Main Loop
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
NMI:

    inc general_counter

GameEngine:
.title:
    lda game_state
    cmp #STATE_TITLE
    bne .playing
    jsr EngineTitle
    jmp .done
.playing:
    lda game_state
    cmp #STATE_PLAYING
    bne .over
    jsr EnginePlaying
    jmp .done
.over:
    lda game_state
    cmp #STATE_OVER
    bne .done
    jsr EngineOver
.done:

    rti

;Title scene
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    .include "src/EngineTitle.asm"

;Playing scene
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    .include "src/EnginePlaying.asm"

;Over scene
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    .include "src/EngineOver.asm"

;IRQ
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
IRQ:

    rti
palette:
    .incbin "src/graphic/palette.pal"

winerWindow:
    .incbin "src/graphic/winner_window.tile"

winerWindowAttr1:
    .incbin "src/graphic/winner_window1.attr"
winerWindowAttr2:
    .incbin "src/graphic/winner_window2.attr"


    .include "src/Subroutine.asm"

;Some datas
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@








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

VblankWait1:
    bit $2002
    bpl VblankWait1

ClearMemory:
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
    bne ClearMemory

InitSprites:
    lda #$02
    sta $4014; sprite DMA

InitBank:
    ldx #0
.loop:
    lda initBankTable, x
    stx $8000   ; select bank
    sta $8001   ; select data
    inx
    cpx #8
    bne .loop

    jmp Main

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
    .incbin "src/graphic/chr.chr"   ;includes 8KB graphics file from SMB1
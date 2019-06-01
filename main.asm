;ines header
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    .inesprg 1  ; 1x 16KB PRG code
    .ineschr 1  ; 1x  8KB CHR data
    .inesmap 4
    .inesmir 1  ; background mirroring

;Declare variables 
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    .rsset $0000  ;;start variables at ram location 0

buttons1    .rs 1
buttons1pre .rs 1
buttons2    .rs 1
buttons2pre .rs 1

game_state  .rs 1

player1_x   .rs 1
player1_y   .rs 1
player2_x   .rs 1
player2_y   .rs 1

tmp .rs 1
tmp_addr_low    .rs 1
tmp_addr_high   .rs 1
general_counter .rs 1
arg .rs 1   ; argument for subroutine


;Declare some constants here
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

STATE_TITLE = 0
STATE_PLAYING = 1

BUTTON_A = $80
BUTTON_B = $40
BUTTON_SELECT = $20
BUTTON_START = $10
BUTTON_UP = $08
BUTTON_DOWN = $04
BUTTON_LEFT = $02
BUTTON_RIGHT = $01

WALL_TOP = $18
WALL_BOTTOM = $A8
WALL_RIGHT = $F8
WALL_LEFT = $08

PLAYER1_WIDTH = $08
PLAYER1_HEIGHT = $08
PLAYER2_WIDTH = $08
PLAYER2_HEIGHT = $08

;Declare some macros here
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
add .macro
    clc
    adc \1
    .endm

;Initial settings
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    .bank 0
    .org $C000 
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

initBank:
    ldx #0
.initBankLoop:
    lda initBankTable, x
    stx $8000   ; select bank
    sta $8001   ; select data
    inx
    cpx #8
    bne .initBankLoop

vblankWait2:
    bit $2002
    bpl vblankWait2

LoadPalettes:
    lda $2002   ; reset high/low latch
    lda #$3F
    sta $2006
    lda #$00
    sta $2006
    ldx #$00
.LoadPalettesLoop:
    lda palette, x
    sta $2007
    inx
    cpx #$20
    bne .LoadPalettesLoop

vblankWait3:
    bit $2002
    bpl vblankWait3

TitleNametables:
    lda $2002
    lda #$20
    sta $2006
    lda #$00
    sta $2006

    lda #LOW(titleNametable)
    sta tmp_addr_low
    lda #HIGH(titleNametable)
    sta tmp_addr_high

    ldx #$00
.TitleNametablesLoop1:

    lda tmp_addr_low
    add #$20
    sta tmp_addr_low
    lda tmp_addr_high
    adc #$00
    sta tmp_addr_high

    ldy #$00
.TitleNametablesLoop2:
    lda [tmp_addr_low], y
    sta $2007
    iny
    cpy #$20
    bne .TitleNametablesLoop2
    inx
    cpx #$1E
    bne .TitleNametablesLoop1

TitleAttrs:
    lda $2002
    lda #$23
    sta $2006
    lda #$C0
    sta $2006

    lda #LOW(titleAttr)
    sta tmp_addr_low
    lda #HIGH(titleAttr)
    sta tmp_addr_high

    ldy #$00
.TitleAttrsLoop:
    lda [tmp_addr_low], y
    sta $2007
    iny
    cpy #$20
    bne .TitleAttrsLoop


;Variable initialize
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

    lda #$00
    sta tmp
    sta arg

    lda #STATE_TITLE
    sta game_state

    lda #$20
    sta player1_x
    sta player1_y
    lda #$80
    sta player2_x
    sta player2_y

    lda #%10010000  ; enable NMI
    sta $2000
    lda #%00011110  ; enable spr/BG
    sta $2001

    cli ; enable IRQ

Forever:
    jmp Forever

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

    jsr ReadController1
    jsr ReadController2

    inc general_counter

GameEngine:

GameTitle:
    lda game_state
    cmp #STATE_TITLE
    bne GamePlaying
    jsr EngineTitle
    jmp GameEngineDone
GamePlaying:
    lda game_state
    cmp #STATE_PLAYING
    bne GameEngineDone
    jsr EnginePlaying

GameEngineDone:

    rti

;Title scene
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
EngineTitle:

    lda buttons1
    and #BUTTON_START
    beq NotStart
    jsr LoadPlaying
NotStart:
    rts


LoadPlaying:
    lda #STATE_PLAYING
    sta game_state

    lda #%00000000  ; disable NMI
    sta $2000
    lda #%00000000  ; disable spr/BG
    sta $2001

PlayingNametables:
    lda $2002
    lda #$20
    sta $2006
    lda #$00
    sta $2006

    lda #LOW(playingNametable)
    sta tmp_addr_low
    lda #HIGH(playingNametable)
    sta tmp_addr_high

    ldx #$00
.PlayingNametablesLoop1:

    lda tmp_addr_low
    add #$20
    sta tmp_addr_low
    lda tmp_addr_high
    adc #$00
    sta tmp_addr_high

    ldy #$00
.PlayingNametablesLoop2:
    lda [tmp_addr_low], y
    sta $2007
    iny
    cpy #$20
    bne .PlayingNametablesLoop2
    inx
    cpx #$1E
    bne .PlayingNametablesLoop1

PlayingAttrs:
    lda $2002
    lda #$23
    sta $2006
    lda #$C0
    sta $2006

    lda #LOW(playingAttr)
    sta tmp_addr_low
    lda #HIGH(playingAttr)
    sta tmp_addr_high

    ldy #$00
.PlayingAttrsLoop:
    lda [tmp_addr_low], y
    sta $2007
    iny
    cpy #$40
    bne .PlayingAttrsLoop

    lda #%10010000  ; enable NMI
    sta $2000
    lda #%00011110  ; enable spr/BG
    sta $2001


    lda player1_y
    sta $0200
    lda #$00
    sta $0201
    lda #$00
    sta $0202
    lda player1_x
    sta $0203

    lda player2_y
    sta $0204
    lda #$00
    sta $0205
    lda #$01
    sta $0206
    lda player2_x
    sta $0207

LoadPlayingDone:

    rts

;Playing scene
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
EnginePlaying:

    lda #$00
    sta $2003
    lda #$02
    sta $4014; sprite DMA

    lda #%10010000  ; PPU clean up
    sta $2000
    lda #%00011110
    sta $2001
    lda #$00
    sta $2005
    sta $2005

Player1Right:
    lda buttons1
    and #BUTTON_RIGHT
    beq Player1RightDone
    inc player1_x
    lda player1_x
    cmp #WALL_RIGHT-PLAYER1_WIDTH
    bcc Player1RightDone
    lda #WALL_RIGHT-PLAYER1_WIDTH
    sta player1_x
Player1RightDone:
Player1Left:
    lda buttons1
    and #BUTTON_LEFT
    beq Player1LeftDone
    dec player1_x
    lda player1_x
    cmp #WALL_LEFT
    bcs Player1LeftDone
    lda #WALL_LEFT
    sta player1_x
Player1LeftDone:
Player1Up:
    lda buttons1
    and #BUTTON_UP
    beq Player1UpDone
    dec player1_y
    lda player1_y
    cmp #WALL_TOP
    bcs Player1UpDone
    lda #WALL_TOP
    sta player1_y
Player1UpDone:
Player1Down:
    lda buttons1
    and #BUTTON_DOWN
    beq Player1DownDone
    inc player1_y
    lda player1_y
    cmp #WALL_BOTTOM-PLAYER1_HEIGHT
    bcc Player1DownDone
    lda #WALL_BOTTOM-PLAYER1_HEIGHT
    sta player1_y
Player1DownDone:

Player1SpriteUpdate:
    lda player1_y
    sta $0200
    lda player1_x
    sta $0203
Player1SpriteUpdateDone:


Player2Right:
    lda buttons2
    and #BUTTON_RIGHT
    beq Player2RightDone
    inc player2_x
    lda player2_x
    cmp #WALL_RIGHT-PLAYER2_WIDTH
    bcc Player2RightDone
    lda #WALL_RIGHT-PLAYER2_WIDTH
    sta player2_x
Player2RightDone:
Player2Left:
    lda buttons2
    and #BUTTON_LEFT
    beq Player2LeftDone
    dec player2_x
    lda player2_x
    cmp #WALL_LEFT
    bcs Player2LeftDone
    lda #WALL_LEFT
    sta player2_x
Player2LeftDone:
Player2Up:
    lda buttons2
    and #BUTTON_UP
    beq Player2UpDone
    dec player2_y
    lda player2_y
    cmp #WALL_TOP
    bcs Player2UpDone
    lda #WALL_TOP
    sta player2_y
Player2UpDone:
Player2Down:
    lda buttons2
    and #BUTTON_DOWN
    beq Player2DownDone
    inc player2_y
    lda player2_y
    cmp #WALL_BOTTOM-PLAYER2_HEIGHT
    bcc Player2DownDone
    lda #WALL_BOTTOM-PLAYER2_HEIGHT
    sta player2_y
Player2DownDone:


Player2SpriteUpdate:
    lda player2_y
    sta $0204
    lda player2_x
    sta $0207
Player2SpriteUpdateDone:



    rts

;IRQ
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
IRQ:


    rti


;Sub routine
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
ReadController1:
    lda buttons1
    sta buttons1pre
    lda #$01
    sta $4016
    lda #$00
    sta $4016
    ldx #$08
.ReadController1Loop:
    lda $4016
    lsr a
    rol buttons1
    dex
    bne .ReadController1Loop

    rts
;;;;;

ReadController2:
    lda buttons2
    sta buttons2pre
    lda #$01
    sta $4017
    lda #$00
    sta $4017
    ldx #$08
.ReadController2Loop:
    lda $4017
    lsr a
    rol buttons2
    dex
    bne .ReadController2Loop

    rts

;Some datas
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

initBankTable:
    .db $00,$02,$04,$05,$06,$07,$00,$00

palette:
    .incbin "palette.pal"

titleNametable:
    .incbin "title.nt"
titleAttr:
    .incbin "title.atr"

playingNametable:
    .incbin "playing.nt"
playingAttr:
    .incbin "playing.atr"

;Vectors
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    .bank 1
    .org $FFFA
    .dw NMI
    .dw RESET
    .dw IRQ

;Character datas
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

    .bank 2
    .org $0000
    .incbin "chr.chr"   ;includes 8KB graphics file from SMB1
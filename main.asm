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
player1_spr .rs 1
player1_stelth  .rs 1
player1_sword_x   .rs 1
player1_sword_y   .rs 1
player1_sword_spr   .rs 1
player1_sword_state .rs 1

player2_x   .rs 1
player2_y   .rs 1
player2_spr .rs 1
player2_stelth  .rs 1
player2_sword_x   .rs 1
player2_sword_y   .rs 1
player2_sword_spr   .rs 1
player2_sword_state .rs 1

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


;Declare some macros here
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
add .macro
    clc
    adc \1
    .endm

sub .macro
    clc
    sbc \1
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

    lda #$20
    sta player1_sword_spr

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

    lda #$20
    sta player1_y
    sta player1_x
    sta player1_sword_y
    add #$08
    sta player1_sword_x
    lda #$00
    sta player1_spr
    lda #$20
    sta player1_sword_spr
    lda #$00
    sta PLAYER1_ATTR
    sta PLAYER1_SWORD_ATTR

    lda #$A0
    sta player2_y
    sta player2_x
    sta player2_sword_y
    sub #$08
    sta player2_sword_x
    lda #$01
    sta player2_spr
    lda #$30
    sta player2_sword_spr
    lda #$01
    sta PLAYER2_ATTR
    sta PLAYER2_SWORD_ATTR

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


    lda player1_stelth
    bne DummyLabel
Player1Right:
    lda buttons1
    and #BUTTON_RIGHT
    beq Player1RightDone
    inc player1_x
    lda #DIRECTION_RIGHT
    sta player1_spr
    lda player1_x
    add #$08
    sta player1_sword_x
    lda player1_y
    sta player1_sword_y
    lda #$20
    sta player1_sword_spr
    lda player1_x
    cmp #WALL_RIGHT-PLAYER1_WIDTH
    bcc DummyLabel;Player1A
    lda #WALL_RIGHT-PLAYER1_WIDTH
    sta player1_x
    jmp DummyLabel;Player1A
Player1RightDone:
Player1Left:
    lda buttons1
    and #BUTTON_LEFT
    beq Player1LeftDone
    dec player1_x
    lda #DIRECTION_LEFT
    sta player1_spr
    lda player1_x
    sub #$08
    sta player1_sword_x
    lda player1_y
    sta player1_sword_y
    lda #$30
    sta player1_sword_spr
    lda player1_x
    cmp #WALL_LEFT
    bcs DummyLabel;Player1A
    lda #WALL_LEFT
    sta player1_x
DummyLabel: ; for avoid jumping limit
    jmp Player1A
Player1LeftDone:
Player1Up:
    lda buttons1
    and #BUTTON_UP
    beq Player1UpDone
    dec player1_y
    lda #DIRECTION_UP
    sta player1_spr
    lda player1_x
    sta player1_sword_x
    lda player1_y
    sub #$08
    sta player1_sword_y
    lda #$40
    sta player1_sword_spr
    lda player1_y
    cmp #WALL_TOP
    bcs Player1A
    lda #WALL_TOP
    sta player1_y
    jmp Player1A
Player1UpDone:
Player1Down:
    lda buttons1
    and #BUTTON_DOWN
    beq Player1DownDone
    inc player1_y
    lda #DIRECTION_DOWN
    sta player1_spr
    lda player1_x
    sta player1_sword_x
    lda player1_y
    add #$08
    sta player1_sword_y
    lda #$50
    sta player1_sword_spr
    lda player1_y
    cmp #WALL_BOTTOM-PLAYER1_HEIGHT
    bcc Player1A
    lda #WALL_BOTTOM-PLAYER1_HEIGHT
    sta player1_y
    jmp Player1A
Player1DownDone:
Player1A:
    lda buttons1
    eor buttons1pre
    and buttons1
    and #BUTTON_A
    beq Player1ADone
    lda #$0F
    sta player1_stelth
Player1ADone:
Player1StelthDec:
    lda #$00
    sta player1_sword_state
    lda player1_stelth
    beq Player1StelthDecDone
    lda player1_stelth
    lsr a
    sta player1_sword_state
    dec player1_stelth
Player1StelthDecDone:

    lda player2_stelth
    bne DummyLabel2
Player2Right:
    lda buttons2
    and #BUTTON_RIGHT
    beq Player2RightDone
    inc player2_x
    lda #DIRECTION_RIGHT
    sta player2_spr
    lda player2_x
    add #$08
    sta player2_sword_x
    lda player2_y
    sta player2_sword_y
    lda #$20
    sta player2_sword_spr
    lda player2_x
    cmp #WALL_RIGHT-PLAYER2_WIDTH
    bcc DummyLabel2;Player2A
    lda #WALL_RIGHT-PLAYER2_WIDTH
    sta player2_x
    jmp DummyLabel2;Player2A
Player2RightDone:
Player2Left:
    lda buttons2
    and #BUTTON_LEFT
    beq Player2LeftDone
    dec player2_x
    lda #DIRECTION_LEFT
    sta player2_spr
    lda player2_x
    sub #$08
    sta player2_sword_x
    lda player2_y
    sta player2_sword_y
    lda #$30
    sta player2_sword_spr
    lda player2_x
    cmp #WALL_LEFT
    bcs DummyLabel2;Player2A
    lda #WALL_LEFT
    sta player2_x
DummyLabel2: ; for avoid jumping limit
    jmp Player2A
Player2LeftDone:
Player2Up:
    lda buttons2
    and #BUTTON_UP
    beq Player2UpDone
    dec player2_y
    lda #DIRECTION_UP
    sta player2_spr
    lda player2_x
    sta player2_sword_x
    lda player2_y
    sub #$08
    sta player2_sword_y
    lda #$40
    sta player2_sword_spr
    lda player2_y
    cmp #WALL_TOP
    bcs Player2A
    lda #WALL_TOP
    sta player2_y
    jmp Player2A
Player2UpDone:
Player2Down:
    lda buttons2
    and #BUTTON_DOWN
    beq Player2DownDone
    inc player2_y
    lda #DIRECTION_DOWN
    sta player2_spr
    lda player2_x
    sta player2_sword_x
    lda player2_y
    add #$08
    sta player2_sword_y
    lda #$50
    sta player2_sword_spr
    lda player2_y
    cmp #WALL_BOTTOM-PLAYER2_HEIGHT
    bcc Player2A
    lda #WALL_BOTTOM-PLAYER2_HEIGHT
    sta player2_y
    jmp Player2A
Player2DownDone:
Player2A:
    lda buttons2
    eor buttons2pre
    and buttons2
    and #BUTTON_A
    beq Player2ADone
    lda #$0F
    sta player2_stelth
Player2ADone:
Player2StelthDec:
    lda #$00
    sta player2_sword_state
    lda player2_stelth
    beq Player2StelthDecDone
    lda player2_stelth
    lsr a
    sta player2_sword_state
    dec player2_stelth
Player2StelthDecDone:


Player1Attack:
    lda player1_sword_x
    add #PLAYER1_SWORD_WIDTH
    sta tmp
    lda player2_x
    cmp tmp ; p2x < p1sx+p1sw
    bcs .label1
    lda player2_x
    add #PLAYER2_WIDTH
    sta tmp
    lda player1_sword_x
    cmp tmp   ; p1sx < p2x+p2w
    bcs .label1
    lda player1_sword_y
    add #PLAYER1_SWORD_HEIGHT
    sta tmp
    lda player2_y
    cmp tmp ; p2y < p1sy+p1sh
    bcs .label1
    lda player2_y
    add #PLAYER2_HEIGHT
    sta tmp
    lda player1_sword_y
    cmp tmp   ; p1sy < p2y+p2h
    bcs .label1
    lda #$FF
    sta general_counter
.label1:
Player1AttackDone:

Player1SpriteUpdate:
    lda player1_y
    sta PLAYER1_Y
    lda player1_sword_y
    sta PLAYER1_SWORD_Y
    lda player1_stelth
    bne .label1

;    lda #$0F
;    sta PLAYER1_SPR
;    sta PLAYER1_SWORD_SPR
    lda #$00
    sta PLAYER1_SPR
    lda #$20
    sta PLAYER1_SWORD_SPR

    jmp .label2
.label1:
    lda player1_spr
    sta PLAYER1_SPR
    lda player1_sword_spr
    add player1_sword_state
    sta PLAYER1_SWORD_SPR
.label2:
    lda player1_x
    sta PLAYER1_X
    lda player1_sword_x
    sta PLAYER1_SWORD_X
Player1SpriteUpdateDone:
Player2SpriteUpdate:
    lda player2_y
    sta PLAYER2_Y
    lda player2_sword_y
    sta PLAYER2_SWORD_Y
    lda player2_stelth
    bne .label1

    ;lda #$0F
    ;sta PLAYER2_SPR
    ;sta PLAYER2_SWORD_SPR
    lda #$00
    sta PLAYER2_SPR
    lda #$20
    sta PLAYER2_SWORD_SPR
    
    jmp .label2
.label1:
    lda player2_spr
    sta PLAYER2_SPR
    lda player2_sword_spr
    add player2_sword_state
    sta PLAYER2_SWORD_SPR
.label2:
    lda player2_x
    sta PLAYER2_X
    lda player2_sword_x
    sta PLAYER2_SWORD_X
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
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

game_state  .rs 1

tmp .rs 1
tmp_addr_low    .rs 1
tmp_addr_high   .rs 1
general_counter .rs 1
arg .rs 1   ; argument for subroutine


;Declare some constants here
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

STATE_TITLE = 0
STATE_PLAYING = 1

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
    lda initbanktable, x
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


;Variable initialize
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

    lda #$00
    sta tmp
    sta arg

    lda #STATE_TITLE
    sta game_state

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

    inc general_counter

GameEngine:
    lda game_state
    cmp #STATE_TITLE
    beq EngineTitle

    lda game_state
    cmp #STATE_PLAYING
    beq EnginePlaying
GameEngineDone:

    rti

;Title scene
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
EngineTitle:

    lda buttons1
    and #%00010000
    beq NotStart
    lda #STATE_PLAYING
    sta game_state

NotStart:

    jmp GameEngineDone

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



    jmp GameEngineDone

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
.ReadControllre1Loop:
    lda $4016
    lsr a
    rol buttons1
    dex
    bne .ReadControllre1Loop

    rts

;Some datas
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

initbanktable:
    .db $00,$02,$04,$05,$06,$07,$00,$00

palette:
    .incbin "palette.pal"

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
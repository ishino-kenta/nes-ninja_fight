
ReadController1:
    lda controller1
    sta controller1pre
    lda #$01
    sta $4016
    lda #$00
    sta $4016
    ldx #$08
.ReadController1Loop:
    lda $4016
    lsr a
    rol controller1
    dex
    bne .ReadController1Loop

    rts


ReadController2:
    lda controller2
    sta controller2pre
    lda #$01
    sta $4017
    lda #$00
    sta $4017
    ldx #$08
.ReadController2Loop:
    lda $4017
    lsr a
    rol controller2
    dex
    bne .ReadController2Loop

    rts

;--------------------------------------------------
;in
; tmp: offset x
; tmp2: offset y
;out
; A: tile number
;memory
; tmp, tmp2
CheckTile:
    
    lda #LOW(playingNametable)
    sta source_addr_low
    lda #HIGH(playingNametable)
    sta source_addr_high

    lda tmp
    lsr a
    lsr a
    lsr a
    clc
    adc source_addr_low
    sta source_addr_low
    lda source_addr_high
    adc #$00
    sta source_addr_high

    lda #$00
    sta tmp
    inc tmp2
    lda tmp2
    and #$F8
    asl a
    rol tmp
    asl a
    rol tmp
    clc
    adc source_addr_low
    sta source_addr_low
    lda source_addr_high
    adc tmp
    sta source_addr_high

    ldy #$00
    lda [source_addr_low], y

    rts


;--------------------------------------------------
;in
; X: offset x
; Y: offset y
;out
; A: tile number
;memory
; tmp, tmp2
CheckTilePlayer2:
    stx tmp
    sty tmp2
    
    lda #LOW(playingNametable)
    sta source_addr_low
    lda #HIGH(playingNametable)
    sta source_addr_high

    lda player2_x
    clc
    adc tmp
    lsr a
    lsr a
    lsr a
    clc
    adc source_addr_low
    sta source_addr_low
    lda source_addr_high
    adc #$00
    sta source_addr_high

    lda #$00
    sta tmp
    lda player2_y
    clc
    adc tmp2
    and #$F8
    asl a
    rol tmp
    asl a
    rol tmp
    clc
    adc source_addr_low
    sta source_addr_low
    lda source_addr_high
    adc tmp
    sta source_addr_high

    ldy #$00
    lda [source_addr_low], y

    rts
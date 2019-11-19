
readController1:
    lda conroller1
    sta conroller1pre
    lda #$01
    sta $4016
    lda #$00
    sta $4016
    ldx #$08
.ReadController1Loop:
    lda $4016
    lsr a
    rol conroller1
    dex
    bne .ReadController1Loop

    rts


readController2:
    lda conroller2
    sta conroller2pre
    lda #$01
    sta $4017
    lda #$00
    sta $4017
    ldx #$08
.ReadController2Loop:
    lda $4017
    lsr a
    rol conroller2
    dex
    bne .ReadController2Loop

    rts

;--------------------------------------------------
;in
; X: offset x
; Y: offset y
;out
; A: tile number
;memory
; tmp, tmp2
checkTile:
    stx tmp
    sty tmp2
    
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
checkTilePlayer2:
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
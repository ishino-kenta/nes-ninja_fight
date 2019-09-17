engineOver:

ShowWinnerWindow:
    lda window_counter
    cmp #$A0
    beq ShowWinnerWindowTileDone
ShowWinnerWindowTile:
    lda #$C0
    clc
	adc window_counter
    sta ppu_addr_low
    lda #$22
    adc #0
    sta ppu_addr_high

    lda #LOW(winerWindow)
    clc
	adc window_counter
    sta source_addr_low
    lda #HIGH(winerWindow)
    adc #0
    sta source_addr_high

    lda ppu_addr_high
    sta $2006
    lda ppu_addr_low
    sta $2006
    ldy #0
.Loop:
    lda [source_addr_low], y
    sta $2007
    iny
    cpy #$10
    bne .Loop
ShowWinnerWindowTileDone:
    lda window_counter
    cmp #$A0
    beq ShowWinnerWindowAttrDone
ShowWinnerWindowAttr:
    lda window_counter
    lsr a
    lsr a
    clc
	adc #$E8
    sta ppu_addr_low
    lda #$23
    adc #0
    sta ppu_addr_high

    lda player2_life
    bne .player2Win
.player1Win:
    lda window_counter
    lsr a
    lsr a
    clc
	adc #LOW(winerWindowAttr1)
    sta source_addr_low
    lda #HIGH(winerWindowAttr1)
    adc #0
    sta source_addr_high
    jmp .JudgeDone
.player2Win:
    lda window_counter
    lsr a
    lsr a
    clc
	adc #LOW(winerWindowAttr2)
    sta source_addr_low
    lda #HIGH(winerWindowAttr2)
    adc #0
    sta source_addr_high
.JudgeDone:

    lda ppu_addr_high
    sta $2006
    lda ppu_addr_low
    sta $2006
    ldy #0
.loop:
    lda [source_addr_low], y
    sta $2007
    iny
    cpy #$04
    bne .loop

    lda window_counter
    clc
	adc #$10
    sta window_counter
ShowWinnerWindowAttrDone:


ShowWinner:
    lda #$23
    sta $2006
    lda #$10
    sta $2006
    lda player2_life
    bne Player2Win
Player1Win:
    lda #$1A
    sta $2007
    jmp ShowWinnerDone
Player2Win:
    lda #$1B
    sta $2007
ShowWinnerDone:


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

Player1StelthDecOver:
    lda #$00
    sta player1_sword_state
    lda player1_stelth
    beq Player1StelthDecOverDone
    lda player1_stelth
    lsr a
    sta player1_sword_state
    dec player1_stelth
Player1StelthDecOverDone:
Player2StelthDecOver:
    lda #$00
    sta player2_sword_state
    lda player2_stelth
    beq Player2StelthDecOverDone
    lda player2_stelth
    lsr a
    sta player2_sword_state
    dec player2_stelth
Player2StelthDecOverDone:

Player1SpriteUpdateOver:
    lda player1_spr
    sta PLAYER1_SPR
    lda player1_sword_spr
    clc
	adc player1_sword_state
    sta PLAYER1_SWORD_SPR
Player1SpriteUpdateOverDone:
Player2SpriteUpdateOver:
    lda player2_spr
    sta PLAYER2_SPR
    lda player2_sword_spr
    clc
	adc player2_sword_state
    sta PLAYER2_SWORD_SPR
Player2SpriteUpdateOverDone:

    lda window_counter
    cmp #$A0
    bne NotRestart

    lda conroller1
    eor conroller1pre
    and conroller1
    cmp #$10
    bne NotRestart
Restart:
    jmp RESET
NotRestart:

    rts

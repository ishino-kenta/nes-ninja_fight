Player1StatusDraw:
    ; life
    lda #PLAYER1_LIFE_HIGH
    sta $2006
    lda #PLAYER1_LIFE_LOW
    clc
	adc player1_life
    sec
    sbc #$01
    sta $2006
    lda #$05
    sta $2007
    lda #$00
    sta $2007
    ; sword
    lda #PLAYER1_SWORD_HIGH
    sta $2006
    lda #PLAYER1_SWORD_LOW
    clc
	adc player1_sword
    sec
    sbc #$01
    sta $2006
    lda #$22
    ldx player1_sword
    bne .1
    lda #$00
.1:
    sta $2007
    lda #$00
    sta $2007
Player2StatusDraw:
    ; life
    lda #PLAYER2_LIFE_HIGH
    sta $2006
    lda #PLAYER2_LIFE_LOW
    clc
	adc player2_life
    sec
    sbc #$01
    sta $2006
    lda #$05
    sta $2007
    lda #$00
    sta $2007
    ; sword
    lda #PLAYER2_SWORD_HIGH
    sta $2006
    lda #PLAYER2_SWORD_LOW
    clc
	adc player2_sword
    sec
    sbc #$01
    sta $2006
    lda #$22
    ldx player2_sword
    bne .1
    lda #$00
.1:
    sta $2007
    lda #$00
    sta $2007

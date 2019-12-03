EngineTitle:

    lda controller1
    eor controller1pre
    and controller1
    cmp #BUTTON_START
    bne .notStart
    jsr loadPlaying
.notStart:
    rts

loadPlaying:
    lda #STATE_PLAYING
    sta game_state

    lda #%00000000  ; disable NMI
    sta $2000
    lda #%00000000  ; disable spr/BG
    sta $2001

.setNametables:
    lda $2002
    lda #$20
    sta $2006
    lda #$00
    sta $2006

    lda #LOW(playingNametable)
    sta source_addr_low
    lda #HIGH(playingNametable)
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


    lda $2002   ; life player1
    lda #PLAYER1_LIFE_HIGH
    sta $2006
    lda #PLAYER1_LIFE_LOW
    sta $2006
    lda #$05
    ldx #0
.loop3:
    sta $2007
    inx
    cpx #LIFE_INIT
    bne .loop3

    lda $2002   ; sword player1
    lda #PLAYER1_SWORD_HIGH
    sta $2006
    lda #PLAYER1_SWORD_LOW
    sta $2006
    lda #$22
    ldx #0
.loop5:
    sta $2007
    inx
    cpx #LIFE_INIT
    bne .loop5

    lda $2002   ; life player2
    lda #PLAYER2_LIFE_HIGH
    sta $2006
    lda #PLAYER2_LIFE_LOW
    sta $2006
    lda #$05
    ldx #0
.loop4:
    sta $2007
    inx
    cpx #SWORD_MAX
    bne .loop4

    lda $2002   ; sword player2
    lda #PLAYER2_SWORD_HIGH
    sta $2006
    lda #PLAYER2_SWORD_LOW
    sta $2006
    lda #$22
    ldx #0
.loop6:
    sta $2007
    inx
    cpx #SWORD_MAX
    bne .loop6


playingAttrs:
    lda $2002
    lda #$23
    sta $2006
    lda #$C0
    sta $2006

    lda #LOW(playingAttr)
    sta source_addr_low
    lda #HIGH(playingAttr)
    sta source_addr_high

    ldy #$00
.loop:
    lda [source_addr_low], y
    sta $2007
    iny
    cpy #$40
    bne .loop

loadPlayingCont:
    lda #%10010000  ; enable NMI
    sta $2000
    lda #%00011110  ; enable spr/BG
    sta $2001

    lda #$20
    sta player1_y
    sta player1_x
    sta player1_sword_y
    clc
	adc #$07
    sta player1_sword_x
    lda #$00
    sta player1_spr
    lda #$20
    sta player1_sword_spr
    lda #$00
    sta PLAYER1_ATTR
    sta PLAYER1_SWORD_ATTR

    lda #$30
    sta player2_y
    sta player2_x
    sta player2_sword_y
    sec
	sbc #$08
    sta player2_sword_x
    lda #$01
    sta player2_spr
    lda #$30
    sta player2_sword_spr
    lda #$01
    sta PLAYER2_ATTR
    sta PLAYER2_SWORD_ATTR

    lda #LIFE_INIT
    sta player1_life
    sta player2_life

    lda #SWORD_MAX
    sta player1_sword
    sta player2_sword

    lda general_counter
    and #$7F
    ora #$A0
    sta item_counter_inc

    lda #$00
    sta player1_speed_level
    sta player2_speed_level

    lda #$50
    sta player1_sword_counter
    sta player2_sword_counter

    lda #$00
    sta tmp3
.1:
    lda tmp3
    adc general_counter
    sta tmp3
    and #$3F
    tax
    lda randomXTable, x
    sta player1_x
    sta player1_sword_x

    lda tmp3
    and #$3F
    tax
    lda randomYTable, x
    sta player1_y
    sta player1_sword_y
    dec player1_y
    dec player1_sword_y

    lda player1_x
    sta tmp
    lda player1_y
    sta tmp2
    jsr checkTile
    cmp #FLOOR
    bne .1

    lda tmp3
    adc general_counter
    sta tmp3
.2:
    lda tmp3
    adc general_counter
    sta tmp3
    and #$3F
    tax
    lda randomXTable, x
    sta player1_x
    sta player1_sword_x

    lda tmp3
    and #$3F
    tax
    lda randomYTable, x
    sta player1_y
    sta player1_sword_y
    dec player1_y
    dec player1_sword_y

    lda player1_x
    sta tmp
    lda player1_y
    sta tmp2
    jsr checkTile
    cmp #FLOOR
    bne .2


    rts
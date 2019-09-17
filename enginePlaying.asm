FLOOR = $02
enginePlaying:

playerLifeDec:
    lda #PLAYER1_LIFE_LOW    ; player1
    sta $2006
    lda #PLAYER1_LIFE_HIGH
    clc
	adc player1_life
    sta $2006
    lda #$00
    sta $2007

    lda #PLAYER2_LIFE_LOW   ; player2
    sta $2006
    lda #PLAYER2_LIFE_HIGH
    clc
	adc player2_life
    sta $2006
    lda #$00
    sta $2007


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

player1Controll:
.Right:

    lda conroller1
    and #BUTTON_RIGHT
    beq .Left

    ldx #$08
    ldy #$01
    jsr checkTile
    cmp #FLOOR
    bne .1
    ldx #$08
    ldy #$08
    jsr checkTile
    cmp #FLOOR
    bne .1
    inc player1_x
.1:
    lda #DIRECTION_RIGHT
    sta player1_spr
    lda player1_x
    clc
	adc #$07
    sta player1_sword_x
    lda player1_y
    sta player1_sword_y
    lda #$20
    sta player1_sword_spr
.Left:
    lda conroller1
    and #BUTTON_LEFT
    beq .Up

    ldx #$FF
    ldy #$01
    jsr checkTile
    cmp #FLOOR
    bne .2
    ldx #$FF
    ldy #$08
    jsr checkTile
    cmp #FLOOR
    bne .2
    dec player1_x
.2:
    lda #DIRECTION_LEFT
    sta player1_spr
    lda player1_x
    sec
	sbc  #$07
    sta player1_sword_x
    lda player1_y
    sta player1_sword_y
    lda #$30
    sta player1_sword_spr
.Up:
    lda conroller1
    and #BUTTON_UP
    beq .Down

    ldx #$00
    ldy #$00
    jsr checkTile
    cmp #FLOOR
    bne .3
    ldx #$07
    ldy #$00
    jsr checkTile
    cmp #FLOOR
    bne .3
    dec player1_y
.3:
    lda #DIRECTION_UP
    sta player1_spr
    lda player1_x
    sta player1_sword_x
    lda player1_y
    sec
	sbc  #$07
    sta player1_sword_y
    lda #$40
    sta player1_sword_spr
.Down:
    lda conroller1
    and #BUTTON_DOWN
    beq .A

    ldx #$00
    ldy #$09
    jsr checkTile
    cmp #FLOOR
    bne .4
    ldx #$07
    ldy #$09
    jsr checkTile
    cmp #FLOOR
    bne .4
    inc player1_y
.4:
    lda #DIRECTION_DOWN
    sta player1_spr
    lda player1_x
    sta player1_sword_x
    lda player1_y
    clc
	adc #$07
    sta player1_sword_y
    lda #$50
    sta player1_sword_spr
.A:
    lda conroller1
    eor conroller1pre
    and conroller1
    and #BUTTON_A
    beq Player1ControllDone
    lda #$0F
    sta player1_stelth

.ASound:
    lda $4015   ; enable sound
    ora #%00000001
    sta $4015

    lda #%10011111
    sta $4000
    lda #%10101100
    sta $4001
    lda #%00000100
    sta $4002
    lda #%11100100
    sta $4003
Player1ControllDone:
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

Player2Controll:
.Right:
    lda player2_stelth
    bne .Left
    lda conroller2
    and #BUTTON_RIGHT
    beq .Left
    inc player2_x
    lda player2_x
    cmp #WALL_RIGHT-PLAYER2_WIDTH
    bcc .1
    lda #WALL_RIGHT-PLAYER2_WIDTH
    sta player2_x
.1:
    lda #DIRECTION_RIGHT
    sta player2_spr
    lda player2_x
    clc
	adc #$07
    sta player2_sword_x
    lda player2_y
    sta player2_sword_y
    lda #$20
    sta player2_sword_spr
.Left:
    lda player2_stelth
    bne .Up
    lda conroller2
    and #BUTTON_LEFT
    beq .Up
    dec player2_x
    lda player2_x
    cmp #WALL_LEFT
    bcs .2
    lda #WALL_LEFT
    sta player2_x
.2:
    lda #DIRECTION_LEFT
    sta player2_spr
    lda player2_x
    sec
	sbc  #$07
    sta player2_sword_x
    lda player2_y
    sta player2_sword_y
    lda #$30
    sta player2_sword_spr
.Up:
    lda player2_stelth
    bne .Down
    lda conroller2
    and #BUTTON_UP
    beq .Down
    dec player2_y
    lda player2_y
    cmp #WALL_TOP
    bcs .3
    lda #WALL_TOP
    sta player2_y
.3:
    lda #DIRECTION_UP
    sta player2_spr
    lda player2_x
    sta player2_sword_x
    lda player2_y
    sec
	sbc  #$07
    sta player2_sword_y
    lda #$40
    sta player2_sword_spr
.Down:
    lda player2_stelth
    bne .A
    lda conroller2
    and #BUTTON_DOWN
    beq .A
    inc player2_y
    lda player2_y
    cmp #WALL_BOTTOM-PLAYER2_HEIGHT
    bcc .4
    lda #WALL_BOTTOM-PLAYER2_HEIGHT
    sta player2_y
.4:
    lda #DIRECTION_DOWN
    sta player2_spr
    lda player2_x
    sta player2_sword_x
    lda player2_y
    clc
	adc #$07
    sta player2_sword_y
    lda #$50
    sta player2_sword_spr
.A:
    lda conroller2
    eor conroller2pre
    and conroller2
    and #BUTTON_A
    beq Player2ControllDone
    lda #$0F
    sta player2_stelth

.ASound:
    lda $4015   ; enable sound
    ora #%00000010
    sta $4015

    lda #%10011111
    sta $4004
    lda #%10101100
    sta $4005
    lda #%00000100
    sta $4006
    lda #%11100001
    sta $4007

Player2ControllDone:
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


Player1SwordHit:
    lda player1_stelth
    beq .label1
    lda player1_sword_x
    clc
	adc #PLAYER1_SWORD_WIDTH
    sta tmp
    lda player2_x
    cmp tmp ; p2x < p1sx+p1sw
    bcs .label1
    lda player2_x
    clc
	adc #PLAYER2_WIDTH
    sta tmp
    lda player1_sword_x
    cmp tmp   ; p1sx < p2x+p2w
    bcs .label1
    lda player1_sword_y
    clc
	adc #PLAYER1_SWORD_HEIGHT
    sta tmp
    lda player2_y
    cmp tmp ; p2y < p1sy+p1sh
    bcs .label1
    lda player2_y
    clc
	adc #PLAYER2_HEIGHT
    sta tmp
    lda player1_sword_y
    cmp tmp   ; p1sy < p2y+p2h
    bcs .label1
    lda player1_sword_hit
    bne Player1SwordHitDone
    lda #$01
    sta player1_sword_hit
    dec player2_life

.Player2Damage:
    lda #%00001000
    sta $4015
    lda #%11000001
    sta $400C
    lda #%00001100
    sta $400E
    lda #%00010011
    sta $400F
.Player2DamageDone:

    jmp Player1SwordHitDone
.label1:
    lda #$00
    sta player1_sword_hit
Player1SwordHitDone:

Player2SwordHit:
    lda player2_stelth
    beq .label1
    lda player2_sword_x
    clc
	adc #PLAYER2_SWORD_WIDTH
    sta tmp
    lda player1_x
    cmp tmp ; p1x < p2sx+p2sw
    bcs .label1
    lda player1_x
    clc
	adc #PLAYER1_WIDTH
    sta tmp
    lda player2_sword_x
    cmp tmp   ; p1sx < p2x+p2w
    bcs .label1
    lda player2_sword_y
    clc
	adc #PLAYER2_SWORD_HEIGHT
    sta tmp
    lda player1_y
    cmp tmp ; p1y < p2sy+p2sh
    bcs .label1
    lda player1_y
    clc
	adc #PLAYER1_HEIGHT
    sta tmp
    lda player2_sword_y
    cmp tmp   ; p1sy < p2y+p2h
    bcs .label1
    lda player2_sword_hit
    bne Player2SwordHitDone
    lda #$01
    sta player2_sword_hit
    dec player1_life

.Player1Damage:
    lda #%00001000
    sta $4015
    lda #%11000001
    sta $400C
    lda #%00000100
    sta $400E
    lda #%00010011
    sta $400F
.Player1DamageDone:

    jmp Player2SwordHitDone
.label1:
    lda #$00
    sta player2_sword_hit
Player2SwordHitDone:


Player1SpriteUpdate:
    lda player1_y
    sta PLAYER1_Y
    lda player1_sword_y
    sta PLAYER1_SWORD_Y
    lda player1_stelth
;;;test
    jmp .label1
;;;
    bne .label1

    lda #$0F
    sta PLAYER1_SPR
    sta PLAYER1_SWORD_SPR
;    lda #$00
;    sta PLAYER1_SPR
;    lda #$20
;    sta PLAYER1_SWORD_SPR

    jmp .label2
.label1:
    lda player1_spr
    sta PLAYER1_SPR
    lda player1_sword_spr
    clc
	adc player1_sword_state
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

    lda #$0F
    sta PLAYER2_SPR
    sta PLAYER2_SWORD_SPR
;    lda #$00
;    sta PLAYER2_SPR
;    lda #$20
;    sta PLAYER2_SWORD_SPR
    
    jmp .label2
.label1:
    lda player2_spr
    sta PLAYER2_SPR
    lda player2_sword_spr
    clc
	adc player2_sword_state
    sta PLAYER2_SWORD_SPR
.label2:
    lda player2_x
    sta PLAYER2_X
    lda player2_sword_x
    sta PLAYER2_SWORD_X
Player2SpriteUpdateDone:

Player1Dead:
    lda player1_life
    bne Plater1DeadDone
    jmp GameOverInit
Plater1DeadDone:
Player2Dead:
    lda player2_life
    bne GameOverInitDone
    jmp GameOverInit
Plater2DeadDone:
GameOverInit:
    lda #STATE_OVER
    sta game_state
    lda #0
    sta window_counter
GameOverInitDone:

    rts
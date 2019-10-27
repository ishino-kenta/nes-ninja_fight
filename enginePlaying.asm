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
    sta $4014 ; sprite DMA

    lda #%10010000  ; PPU clean up
    sta $2000
    lda #%00011110
    sta $2001
    lda #$00
    sta $2005
    sta $2005

    lda #BUTTON_DOWN + BUTTON_LEFT + BUTTON_RIGHT + BUTTON_UP
    and #$0F
    bne .1
    lda player1_x
    sta player1_sword_x
    lda player1_y
    sta player1_sword_y
.1:

player1Controll:
    lda #$00
    sta tmp3

.down:
    lda conroller1
    and #BUTTON_DOWN
    beq .right

    lda #$01
    sta tmp3

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

    lda player1_atacking_timer
    bne .right

    ldx #$00
    ldy #$09
    jsr checkTilePlayer1
    cmp #FLOOR
    bne .right
    ldx #$07
    ldy #$09
    jsr checkTilePlayer1
    cmp #FLOOR
    bne .right
    inc player1_y

.right:
    lda tmp3
    bne .left

    lda conroller1
    and #BUTTON_RIGHT
    beq .left

    lda #$01
    sta tmp3

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

    lda player1_atacking_timer
    bne .left

    ldx #$08    ; collision detection
    ldy #$01
    jsr checkTilePlayer1
    cmp #FLOOR
    bne .left
    ldx #$08
    ldy #$08
    jsr checkTilePlayer1
    cmp #FLOOR
    bne .left
    inc player1_x
    jmp .left

.left:
    lda tmp3
    bne .up

    lda conroller1
    and #BUTTON_LEFT
    beq .up

    lda #$01
    sta tmp3

    lda #DIRECTION_LEFT
    sta player1_spr
    lda player1_x
    sec
	sbc #$07
    sta player1_sword_x
    lda player1_y
    sta player1_sword_y
    lda #$30
    sta player1_sword_spr

    lda player1_atacking_timer
    bne .up

    ldx #$FF
    ldy #$01
    jsr checkTilePlayer1
    cmp #FLOOR
    bne .up
    ldx #$FF
    ldy #$08
    jsr checkTilePlayer1
    cmp #FLOOR
    bne .up
    dec player1_x
    lda #TRUE
    jmp .up

.up:
    lda tmp3
    bne .A

    lda conroller1
    and #BUTTON_UP
    beq .A

    lda #DIRECTION_UP
    sta player1_spr
    lda player1_x
    sta player1_sword_x
    lda player1_y
    sec
	sbc #$07
    sta player1_sword_y
    lda #$40
    sta player1_sword_spr

    lda player1_atacking_timer
    bne .A

    ldx #$00
    ldy #$FF
    jsr checkTilePlayer1
    cmp #FLOOR
    bne .A
    ldx #$07
    ldy #$FF
    jsr checkTilePlayer1
    cmp #FLOOR
    bne .A
    dec player1_y
    jmp .A

.A:
    lda conroller1
    eor conroller1pre
    and conroller1
    and #BUTTON_A
    beq .B
    lda player1_atacking_timer
    bne .B
    lda #$0F
    sta player1_atacking_timer

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

.B:
    lda conroller1
    eor conroller1pre
    and conroller1
    and #BUTTON_B
    beq .done
    lda player1_atacking_timer
    bne .done
    lda player1_stelth
    eor #$FF
    sta player1_stelth
.done:
player1AatckingDec:
    lda player1_atacking_timer
    beq .1
    dec player1_atacking_timer
.1:
    lda player1_atacking_timer
    lsr a
    sta player1_sword_state
.done:


player2Controll:
    lda #$00
    sta tmp3

.down:
    lda conroller2
    and #BUTTON_DOWN
    beq .right

    lda #$01
    sta tmp3

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

    lda player2_atacking_timer
    bne .right

    ldx #$00
    ldy #$09
    jsr checkTilePlayer2
    cmp #FLOOR
    bne .right
    ldx #$07
    ldy #$09
    jsr checkTilePlayer2
    cmp #FLOOR
    bne .right
    inc player2_y

.right:
    lda tmp3
    bne .left

    lda conroller2
    and #BUTTON_RIGHT
    beq .left

    lda #$01
    sta tmp3

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

    lda player2_atacking_timer
    bne .left

    ldx #$08    ; collision detection
    ldy #$01
    jsr checkTilePlayer2
    cmp #FLOOR
    bne .left
    ldx #$08
    ldy #$08
    jsr checkTilePlayer2
    cmp #FLOOR
    bne .left
    inc player2_x
    jmp .left

.left:
    lda tmp3
    bne .up

    lda conroller2
    and #BUTTON_LEFT
    beq .up

    lda #$01
    sta tmp3

    lda #DIRECTION_LEFT
    sta player2_spr
    lda player2_x
    sec
	sbc #$07
    sta player2_sword_x
    lda player2_y
    sta player2_sword_y
    lda #$30
    sta player2_sword_spr

    lda player2_atacking_timer
    bne .up

    ldx #$FF
    ldy #$01
    jsr checkTilePlayer2
    cmp #FLOOR
    bne .up
    ldx #$FF
    ldy #$08
    jsr checkTilePlayer2
    cmp #FLOOR
    bne .up
    dec player2_x
    lda #TRUE
    jmp .up

.up:
    lda tmp3
    bne .A

    lda conroller2
    and #BUTTON_UP
    beq .A

    lda #DIRECTION_UP
    sta player2_spr
    lda player2_x
    sta player2_sword_x
    lda player2_y
    sec
	sbc #$07
    sta player2_sword_y
    lda #$40
    sta player2_sword_spr

    lda player2_atacking_timer
    bne .A

    ldx #$00
    ldy #$FF
    jsr checkTilePlayer2
    cmp #FLOOR
    bne .A
    ldx #$07
    ldy #$FF
    jsr checkTilePlayer2
    cmp #FLOOR
    bne .A
    dec player2_y
    jmp .A

.A:
    lda conroller2
    eor conroller2pre
    and conroller2
    and #BUTTON_A
    beq .B
    lda player2_atacking_timer
    bne .B
    lda #$0F
    sta player2_atacking_timer

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

.B:
    lda conroller2
    eor conroller2pre
    and conroller2
    and #BUTTON_B
    beq .done
    lda player2_atacking_timer
    bne .done
    lda player2_stelth
    eor #$FF
    sta player2_stelth
.done:
player2AatckingDec:
    lda player2_atacking_timer
    beq .1
    dec player2_atacking_timer
.1:
    lda player2_atacking_timer
    lsr a
    sta player2_sword_state
.done:


Player1SwordHit:
    lda player1_atacking_timer
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
    lda player1_atacking_timer
    beq .1
    lda #TRUE
    jmp .2
.1:
    lda #FALSE
.2:
    sta player1_stelth

    lda player1_y
    sta PLAYER1_Y
    lda player1_sword_y
    sta PLAYER1_SWORD_Y
    lda player1_stelth
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

Player2SpriteUpdate:
    lda player2_atacking_timer
    beq .1
    lda #TRUE
    jmp .2
.1:
    lda #FALSE
.2:
    sta player2_stelth

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
FLOOR = $02
enginePlaying:

    lda walk_counter
    clc
    adc #$01
    cmp #$03
    bne .1
    lda #$00
.1:
    sta walk_counter

    lda player1_speed_level
    asl a
    asl a
    adc walk_counter
    tax
    lda walkSpeed, x
    sta player1_speed

    lda player2_speed_level
    asl a
    asl a
    adc walk_counter
    tax
    lda walkSpeed, x
    sta player2_speed

    lda item_flag
    bne .2
    lda item_counter
    clc
    adc item_counter_inc
    sta item_counter
    lda item_counter+1
    adc #$00
    sta item_counter+1
.2:

player1LifeDec:
    lda #PLAYER1_LIFE_LOW    ; player1
    sta $2006
    lda #PLAYER1_LIFE_HIGH
    clc
	adc player1_life
    sta $2006
    lda #$00
    sta $2007
player2LifeDec:
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

    jsr player1Controll
    
player1AatckingDec:
    lda player1_atacking_timer
    beq .1
    dec player1_atacking_timer
.1:
    lda player1_atacking_timer
    lsr a
    sta player1_sword_state
.done:


    lda #BUTTON_DOWN + BUTTON_LEFT + BUTTON_RIGHT + BUTTON_UP
    and #$0F
    bne .2
    lda player2_x
    sta player2_sword_x
    lda player2_y
    sta player2_sword_y
.2:
    jsr player2Controll

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
    lda player2_atacking_timer
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

CheckItemCounter:

    lda item_counter+1
    cmp #$FF
    bne .1

    lda #$00
    sta item_counter+1

    lda #FALSE
    sta item_flag

    lda general_counter
    eor player1_y
    eor player2_x
    and #$F8
    cmp #$D8
    bcs .1
    clc
    adc #$10
    sta item_x

    lda general_counter
    eor player1_x
    eor player2_y
    and #$F8
    cmp #$80
    bcs .1
    clc
    adc #$17
    sta item_y

    ldx item_x
    ldy item_y
    iny
    jsr checkTile
    sta test
    cmp #FLOOR
    bne .1

    lda #TRUE
    sta item_flag

    lda item_counter_inc
    eor general_counter
    ora #$C0
    sta item_counter_inc

    cli

.1:

Item:

    lda item_flag
    beq .1
    
    lda #$80
    clc
    adc item_kind
    sta item_spr

    jsr Player1ItemGet
    jsr Player2ItemGet

    jmp .done

.1:
    lda #$FE
    sta item_spr
.done:

ShowItem:
    lda item_x
    sta ITEM_X
    lda item_y
    sta ITEM_Y
    lda item_spr
    sta ITEM_SPR
    lda #$02
    sta ITEM_ATTR



    rts
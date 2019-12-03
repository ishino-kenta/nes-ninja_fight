
EnginePlaying:

player1StatusDraw:
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
player2StatusDraw:
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

counters:
    ; speed
    lda player1_speed_level
    sta test
    asl a
    asl a
    clc
    adc player1_speed_level
    clc
    adc walk_counter
    tax
    lda walkSpeed, x
    sta player1_speed
    sta test2
    
    lda walk_counter
    sta test3

    lda player2_speed_level
    asl a
    asl a
    adc walk_counter
    tax
    lda walkSpeed, x
    sta player2_speed

    inc walk_counter
    lda walk_counter
    cmp #$05
    bne .1
    lda #$00
    sta walk_counter
.1:


    ; item
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

    ; sword
    lda player1_sword
    cmp #$04
    beq .3
    dec player1_sword_counter
    lda player1_sword_counter
    cmp #$00
    bne .3
    inc player1_sword
    lda #$50
    sta player1_sword_counter
.3:

    lda player2_sword
    cmp #$04
    beq .4
    dec player2_sword_counter
    lda player2_sword_counter
    cmp #$00
    bne .4
    inc player2_sword
    lda #$50
    sta player2_sword_counter
.4:


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


    jsr player1SwordHit

    jsr player2SwordHit


player1SpriteUpdate:

    lda player1_y
    sta PLAYER1_Y
    lda player1_sword_y
    sta PLAYER1_SWORD_Y
    lda player1_stelth
    bne .label1

    lda player1_atacking_timer
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

player2SpriteUpdate:

    lda player2_y
    sta PLAYER2_Y
    lda player2_sword_y
    sta PLAYER2_SWORD_Y
    lda player2_stelth
    bne .label1

    lda player2_atacking_timer
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

playerDeadCheck:
    ; player1
    lda player1_life
    beq .gameOverInit
    ; player2
    lda player2_life
    beq .gameOverInit
    jmp .done
.gameOverInit:
    lda #STATE_OVER
    sta game_state
    lda #0
    sta window_counter
.done:

checkItemCounter:
    lda item_counter+1
    cmp #$FF
    bne .1

    lda #$00
    sta item_counter+1

    lda #FALSE
    sta item_flag
    ; generate random item position.
    lda general_counter
    and #$3F
    tax
    lda randomXTable, x
    sta item_x

    lda general_counter
    and #$3F
    tax
    lda randomYTable, x
    sta item_y
    dec item_y

    lda item_x
    sta tmp
    lda item_y
    sta tmp2
    jsr checkTile
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


randomXTable:
    .db $C0,$10,$58,$28,$18,$A0,$38,$98
    .db $78,$C0,$98,$70,$D0,$80,$78,$68
    .db $18,$88,$50,$B8,$98,$90,$E0,$38
    .db $C8,$D8,$98,$40,$80,$70,$58,$28
    .db $E0,$C0,$C8,$88,$C0,$30,$28,$C0
    .db $40,$B0,$80,$58,$E0,$68,$70,$D8
    .db $E0,$30,$C8,$50,$88,$88,$80,$A8
    .db $A0,$68,$78,$78,$C8,$48,$A8,$30

randomYTable:
    .db $60,$50,$50,$28,$30,$18,$78,$20
    .db $68,$70,$80,$70,$68,$70,$38,$28
    .db $78,$50,$38,$78,$78,$78,$20,$40
    .db $88,$90,$68,$28,$30,$40,$60,$88
    .db $28,$50,$58,$28,$20,$30,$50,$20
    .db $40,$90,$30,$88,$68,$88,$60,$80
    .db $40,$80,$88,$30,$60,$80,$50,$30
    .db $38,$80,$40,$68,$70,$20,$68,$28
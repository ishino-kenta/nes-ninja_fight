

player1Controll:
    lda #FALSE
    sta player1_move_flag

    lda player1_atacking_timer
    bne .done

    lda conroller1
    and #BUTTON_RIGHT
    beq .1
    lda player1_move_flag
    bne .1
    jsr .right
.1:
    lda conroller1
    and #BUTTON_LEFT
    beq .2
    lda player1_move_flag
    bne .2
    jsr .left
.2:
    lda conroller1
    and #BUTTON_DOWN
    beq .3
    lda player1_move_flag
    bne .3
    jsr .down
.3:
    lda conroller1
    and #BUTTON_UP
    beq .4
    lda player1_move_flag
    bne .4
    jsr .up
.4:
    lda conroller1
    eor conroller1pre
    and conroller1
    and #BUTTON_A
    beq .5
    jsr .A

.5:
    lda conroller1
    eor conroller1pre
    and conroller1
    and #BUTTON_B
    beq .done
    lda player1_atacking_timer
    bne .done
.B:
    lda #$FF
    sta item_counter+1
.done:
    rts
.down:
    lda #$00
    sta tmp3
.12:
    lda #DIRECTION_DOWN
    sta player1_spr
    lda #$50
    sta player1_sword_spr

    lda player1_x
    clc
    adc #$00
    tax
    lda player1_y
    clc
    adc #$09
    tay
    jsr checkTile
    cmp #FLOOR
    bne .11
    lda player1_x
    clc
    adc #$06
    tax
    lda player1_y
    clc
    adc #$09
    tay
    jsr checkTile
    cmp #FLOOR
    bne .11
    inc player1_y
    lda #TRUE
    sta player1_move_flag

    lda tmp3
    clc
    adc #$01
    sta tmp3
    lda tmp3
    cmp player1_speed
    bne .12
.11:
    lda player1_x
    sta player1_sword_x
    lda player1_y
    clc
	adc #$08
    sta player1_sword_y
    rts
.right:
    lda #$00
    sta tmp3
.22:
    lda #DIRECTION_RIGHT
    sta player1_spr
    lda #$20
    sta player1_sword_spr

    lda player1_x
    clc
    adc #$07
    tax
    lda player1_y
    clc
    adc #$01
    tay
    jsr checkTile
    cmp #FLOOR
    bne .21
    lda player1_x
    clc
    adc #$07
    tax
    lda player1_y
    clc
    adc #$08
    tay
    jsr checkTile
    cmp #FLOOR
    bne .21
    inc player1_x
    lda #TRUE
    sta player1_move_flag

    lda tmp3
    clc
    adc #$01
    sta tmp3
    lda tmp3
    cmp player1_speed
    bne .22
.21:
    lda player1_x
    clc
	adc #$07
    sta player1_sword_x
    lda player1_y
    sta player1_sword_y
    rts
.left:
    lda #$00
    sta tmp3
.32:
    lda #DIRECTION_LEFT
    sta player1_spr
    lda #$30
    sta player1_sword_spr

    lda player1_x
    clc
    adc #$FF
    tax
    lda player1_y
    clc
    adc #$01
    tay
    jsr checkTile
    cmp #FLOOR
    bne .31
    lda player1_x
    clc
    adc #$FF
    tax
    lda player1_y
    clc
    adc #$08
    tay
    jsr checkTile
    cmp #FLOOR
    bne .31
    dec player1_x
    lda #TRUE
    sta player1_move_flag

    lda tmp3
    clc
    adc #$01
    sta tmp3
    lda tmp3
    cmp player1_speed
    bne .32
.31:
    lda player1_x
    sec
	sbc #$08
    sta player1_sword_x
    lda player1_y
    sta player1_sword_y
    rts
.up:
    lda #$00
    sta tmp3
.42:
    lda #DIRECTION_UP
    sta player1_spr
    lda #$40
    sta player1_sword_spr

    lda player1_x
    clc
    adc #$00
    tax
    lda player1_y
    clc
    adc #$00
    tay
    jsr checkTile
    cmp #FLOOR
    bne .41
    lda player1_x
    clc
    adc #$06
    tax
    lda player1_y
    clc
    adc #$00
    tay
    jsr checkTile
    cmp #FLOOR
    bne .41
    dec player1_y
    lda #TRUE
    sta player1_move_flag

    lda tmp3
    clc
    adc #$01
    sta tmp3
    lda tmp3
    cmp player1_speed
    bne .42
.41:
    lda player1_x
    sta player1_sword_x
    lda player1_y
    sec
	sbc #$08
    sta player1_sword_y
    rts
.A:
    lda #$0F
    sta player1_atacking_timer

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

    rts


player2Controll:
    lda #FALSE
    sta player2_move_flag

    lda player2_atacking_timer
    bne .done

    lda conroller2
    and #BUTTON_RIGHT
    beq .1
    lda player2_move_flag
    bne .1
    jsr .right
.1:
    lda conroller2
    and #BUTTON_LEFT
    beq .2
    lda player2_move_flag
    bne .2
    jsr .left
.2:
    lda conroller2
    and #BUTTON_DOWN
    beq .3
    lda player2_move_flag
    bne .3
    jsr .down
.3:
    lda conroller2
    and #BUTTON_UP
    beq .4
    lda player2_move_flag
    bne .4
    jsr .up
.4:
    lda conroller2
    eor conroller2pre
    and conroller2
    and #BUTTON_A
    beq .5
    jsr .A

.5:
    lda conroller2
    eor conroller2pre
    and conroller2
    and #BUTTON_B
    beq .done
    lda player2_atacking_timer
    bne .done
.B:
    lda #$FF
    sta item_counter+1
.done:
    rts
.down:
    lda #$00
    sta tmp3
.12:
    lda #DIRECTION_DOWN
    sta player2_spr
    lda #$50
    sta player2_sword_spr

    lda player2_x
    clc
    adc #$00
    tax
    lda player2_y
    clc
    adc #$09
    tay
    jsr checkTile
    cmp #FLOOR
    bne .11
    lda player2_x
    clc
    adc #$06
    tax
    lda player2_y
    clc
    adc #$09
    tay
    jsr checkTile
    cmp #FLOOR
    bne .11
    inc player2_y
    lda #TRUE
    sta player2_move_flag

    lda tmp3
    clc
    adc #$01
    sta tmp3
    lda tmp3
    cmp player2_speed
    bne .12
.11:
    lda player2_x
    sta player2_sword_x
    lda player2_y
    clc
	adc #$08
    sta player2_sword_y
    rts
.right:
    lda #$00
    sta tmp3
.22:
    lda #DIRECTION_RIGHT
    sta player2_spr
    lda #$20
    sta player2_sword_spr

    lda player2_x
    clc
    adc #$07
    tax
    lda player2_y
    clc
    adc #$01
    tay
    jsr checkTile
    cmp #FLOOR
    bne .21
    lda player2_x
    clc
    adc #$07
    tax
    lda player2_y
    clc
    adc #$08
    tay
    jsr checkTile
    cmp #FLOOR
    bne .21
    inc player2_x
    lda #TRUE
    sta player2_move_flag

    lda tmp3
    clc
    adc #$01
    sta tmp3
    lda tmp3
    cmp player2_speed
    bne .22
.21:
    lda player2_x
    clc
	adc #$07
    sta player2_sword_x
    lda player2_y
    sta player2_sword_y
    rts
.left:
    lda #$00
    sta tmp3
.32:
    lda #DIRECTION_LEFT
    sta player2_spr
    lda #$30
    sta player2_sword_spr

    lda player2_x
    clc
    adc #$FF
    tax
    lda player2_y
    clc
    adc #$01
    tay
    jsr checkTile
    cmp #FLOOR
    bne .31
    lda player2_x
    clc
    adc #$FF
    tax
    lda player2_y
    clc
    adc #$08
    tay
    jsr checkTile
    cmp #FLOOR
    bne .31
    dec player2_x
    lda #TRUE
    sta player2_move_flag

    lda tmp3
    clc
    adc #$01
    sta tmp3
    lda tmp3
    cmp player2_speed
    bne .32
.31:
    lda player2_x
    sec
	sbc #$08
    sta player2_sword_x
    lda player2_y
    sta player2_sword_y
    rts
.up:
    lda #$00
    sta tmp3
.42:
    lda #DIRECTION_UP
    sta player2_spr
    lda #$40
    sta player2_sword_spr

    lda player2_x
    clc
    adc #$00
    tax
    lda player2_y
    clc
    adc #$00
    tay
    jsr checkTile
    cmp #FLOOR
    bne .41
    lda player2_x
    clc
    adc #$06
    tax
    lda player2_y
    clc
    adc #$00
    tay
    jsr checkTile
    cmp #FLOOR
    bne .41
    dec player2_y
    lda #TRUE
    sta player2_move_flag

    lda tmp3
    clc
    adc #$01
    sta tmp3
    lda tmp3
    cmp player2_speed
    bne .42
.41:
    lda player2_x
    sta player2_sword_x
    lda player2_y
    sec
	sbc #$08
    sta player2_sword_y
    rts
.A:
    lda #$0F
    sta player2_atacking_timer

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

    rts

walkSpeed:
    .db 1,1,1,1
    .db 1,1,1,2
    .db 1,1,2,2
    .db 1,2,2,2
    .db 2,2,2,2
    .db 2,2,2,3
    .db 2,2,3,3
    .db 2,3,3,3
    .db 3,3,3,3


Player1ItemGet:
    lda item_x
    clc
	adc #$07
    sta tmp
    lda player1_x
    cmp tmp ; p1x < p2sx+p2sw
    bcs .notget
    
    lda player1_x
    clc
	adc #PLAYER1_WIDTH
    sta tmp
    lda item_x
    cmp tmp   ; p1sx < p2x+p2w
    bcs .notget

    lda item_y
    clc
	adc #$07
    sta tmp
    lda player1_y
    cmp tmp ; p1y < p2sy+p2sh
    
    bcs .notget
    lda player1_y
    clc
	adc #PLAYER1_HEIGHT
    sta tmp
    lda item_y
    cmp tmp   ; p1sy < p2y+p2h
    bcs .notget
    
    lda #FALSE
    sta item_flag

    lda item_kind
    asl a
    tay
    lda items, y
    sta source_addr_low
    lda items+1, y
    sta source_addr_high
    lda #$00
    jmp [source_addr_low]

.notget:
    rts

Player2ItemGet:
    lda item_x
    clc
	adc #$07
    sta tmp
    lda player2_x
    cmp tmp ; p1x < p2sx+p2sw
    bcs .notget
    
    lda player2_x
    clc
	adc #PLAYER2_WIDTH
    sta tmp
    lda item_x
    cmp tmp   ; p1sx < p2x+p2w
    bcs .notget

    lda item_y
    clc
	adc #$07
    sta tmp
    lda player2_y
    cmp tmp ; p1y < p2sy+p2sh
    
    bcs .notget
    lda player2_y
    clc
	adc #PLAYER2_HEIGHT
    sta tmp
    lda item_y
    cmp tmp   ; p1sy < p2y+p2h
    bcs .notget
    
    lda #FALSE
    sta item_flag

    lda item_kind
    asl a
    tay
    lda items, y
    sta source_addr_low
    lda items+1, y
    sta source_addr_high
    lda #$01
    jmp [source_addr_low]

.notget:
    rts

    .include "itemList.asm"
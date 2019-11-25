

player1Controll:
    lda #FALSE
    sta player1_move_flag

    lda player1_atacking_timer
    bne .done

    lda conroller1
    and #BUTTON_RIGHT
    beq .1
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
    sta tmp3    ; speed counter
    lda #DIRECTION_DOWN
    sta player1_spr
    lda #$50
    sta player1_sword_spr
.1a:
    jsr .1sr
    ; speed loop.
    lda tmp3
    clc
    adc #$01
    sta tmp3
    lda tmp3
    cmp player1_speed
    bne .1a
    ; set sword position.
    lda player1_x
    sta player1_sword_x
    lda player1_y
    clc
	adc #$08
    sta player1_sword_y
    rts
.1sr:
    lda #$00
    sta tmp4
    ; check hitting the wall flag.
    ldx #$00
.1l:
    lda player1_x
    clc
    adc .downTable, x
    sta tmp
    lda player1_y
    clc
    adc .downTable+2, x
    sta tmp2
    jsr checkTile
    cmp #FLOOR
    beq .1b
    lda tmp4
    ora .downTable+4, x
    sta tmp4
.1b:
    inx
    cpx #$02
    bne .1l
    ; move straight.
    lda tmp4
    and #$03
    bne .1c
    inc player1_y
    lda #TRUE
    sta player1_move_flag
    jmp .1e
.1c:
    ; slide along the wall.
    lda tmp4
    and #$02
    bne .1d
    inc player1_x
    lda #TRUE
    sta player1_move_flag
    jmp .1e
.1d:
    ; slide along the wall.
    lda tmp4
    and #$01
    bne .1e
    dec player1_x
    lda #TRUE
    sta player1_move_flag
.1e:
    rts
.downTable:
    .db $00,$06, $09,$09, $01,$02

.right:
    lda #$00
    sta tmp3    ; speed counter
    lda #DIRECTION_RIGHT
    sta player1_spr
    lda #$20
    sta player1_sword_spr
.2a:
    jsr .2sr
    ; speed loop.
    lda tmp3
    clc
    adc #$01
    sta tmp3
    lda tmp3
    cmp player1_speed
    bne .2a
    ; set sword position.
    lda player1_x
    clc
	adc #$07
    sta player1_sword_x
    lda player1_y
    sta player1_sword_y
    rts
.2sr:
    lda #$00
    sta tmp4
    ; check hitting the wall flag.
    ldx #$00
.2l:
    lda player1_x
    clc
    adc .rightTable, x
    sta tmp
    lda player1_y
    clc
    adc .rightTable+2, x
    sta tmp2
    jsr checkTile
    cmp #FLOOR
    beq .2b
    lda tmp4
    ora .rightTable+4, x
    sta tmp4
.2b:
    inx
    cpx #$02
    bne .2l
    ; move straight.
    lda tmp4
    and #$03
    bne .2c
    inc player1_x
    lda #TRUE
    sta player1_move_flag
    jmp .2e
.2c:
    ; slide along the wall.
    lda tmp4
    and #$02
    bne .2d
    inc player1_y
    lda #TRUE
    sta player1_move_flag
    jmp .2e
.2d:
    ; slide along the wall.
    lda tmp4
    and #$01
    bne .2e
    dec player1_y
    lda #TRUE
    sta player1_move_flag
.2e:

    ; increase item_counter_inc for random
    inc item_counter_inc

    rts
.rightTable:
    .db $07,$07, $01,$08, $01,$02
.left:
    lda #$00
    sta tmp3    ; speed counter
    lda #DIRECTION_LEFT
    sta player1_spr
    lda #$30
    sta player1_sword_spr
.3a:
    jsr .3sr
    ; speed loop.
    lda tmp3
    clc
    adc #$01
    sta tmp3
    lda tmp3
    cmp player1_speed
    bne .3a
    ; set sword position.
    lda player1_x
    sec
	sbc #$08
    sta player1_sword_x
    lda player1_y
    sta player1_sword_y
    rts
.3sr:
    lda #$00
    sta tmp4
    ; check hitting the wall flag.
    ldx #$00
.3l:
    lda player1_x
    clc
    adc .leftTable, x
    sta tmp
    lda player1_y
    clc
    adc .leftTable+2, x
    sta tmp2
    jsr checkTile
    cmp #FLOOR
    beq .3b
    lda tmp4
    ora .leftTable+4, x
    sta tmp4
.3b:
    inx
    cpx #$02
    bne .3l
    ; move straight.
    lda tmp4
    and #$03
    bne .3c
    dec player1_x
    lda #TRUE
    sta player1_move_flag
    jmp .3e
.3c:
    ; slide along the wall.
    lda tmp4
    and #$02
    bne .3d
    inc player1_y
    lda #TRUE
    sta player1_move_flag
    jmp .3e
.3d:
    ; slide along the wall.
    lda tmp4
    and #$01
    bne .3e
    dec player1_y
    lda #TRUE
    sta player1_move_flag
.3e:
    rts
.leftTable:
    .db $FF,$FF, $01,$08, $01,$02

.up:
    lda #$00
    sta tmp3    ; speed counter
    lda #DIRECTION_UP
    sta player1_spr
    lda #$40
    sta player1_sword_spr
.4a:
    jsr .4sr
    ; speed loop.
    lda tmp3
    clc
    adc #$01
    sta tmp3
    lda tmp3
    cmp player1_speed
    bne .4a
    ; set sword position.
    lda player1_x
    sta player1_sword_x
    lda player1_y
    clc
	sbc #$07
    sta player1_sword_y
    rts
.4sr:
    lda #$00
    sta tmp4
    ; check hitting the wall flag.
    ldx #$00
.4l:
    lda player1_x
    clc
    adc .upTable, x
    sta tmp
    lda player1_y
    clc
    adc .upTable+2, x
    sta tmp2
    jsr checkTile
    cmp #FLOOR
    beq .4b
    lda tmp4
    ora .upTable+4, x
    sta tmp4
.4b:
    inx
    cpx #$02
    bne .4l
    ; move straight.
    lda tmp4
    and #$03
    bne .4c
    dec player1_y
    lda #TRUE
    sta player1_move_flag
    jmp .4e
.4c:
    ; slide along the wall.
    lda tmp4
    and #$02
    bne .4d
    inc player1_x
    lda #TRUE
    sta player1_move_flag
    jmp .4e
.4d:
    ; slide along the wall.
    lda tmp4
    and #$01
    bne .4e
    dec player1_x
    lda #TRUE
    sta player1_move_flag
.4e:
    rts
.upTable:
    .db $00,$06, $01,$01, $01,$02
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
    sta tmp
    lda player2_y
    clc
    adc #$09
    sta tmp2
    jsr checkTile
    cmp #FLOOR
    bne .11
    lda player2_x
    clc
    adc #$06
    sta tmp
    lda player2_y
    clc
    adc #$09
    sta tmp2
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
    sta tmp
    lda player2_y
    clc
    adc #$01
    sta tmp2
    jsr checkTile
    cmp #FLOOR
    bne .21
    lda player2_x
    clc
    adc #$07
    sta tmp
    lda player2_y
    clc
    adc #$08
    sta tmp2
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
    sta tmp
    lda player2_y
    clc
    adc #$01
    sta tmp2
    jsr checkTile
    cmp #FLOOR
    bne .31
    lda player2_x
    clc
    adc #$FF
    sta tmp
    lda player2_y
    clc
    adc #$08
    sta tmp2
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
    sta tmp
    lda player2_y
    clc
    adc #$00
    sta tmp2
    jsr checkTile
    cmp #FLOOR
    bne .41
    lda player2_x
    clc
    adc #$06
    sta tmp
    lda player2_y
    clc
    adc #$00
    sta tmp2
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
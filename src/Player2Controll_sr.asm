Player2Controll:
    lda #FALSE
    sta player2_move_flag

    lda player2_atacking_counter
    bne .done

    lda controller2
    and #BUTTON_RIGHT
    beq .1
    jsr .right
.1:
    lda controller2
    and #BUTTON_LEFT
    beq .2
    lda player2_move_flag
    bne .2
    jsr .left
.2:
    lda controller2
    and #BUTTON_DOWN
    beq .3
    lda player2_move_flag
    bne .3
    jsr .down
.3:
    lda controller2
    and #BUTTON_UP
    beq .4
    lda player2_move_flag
    bne .4
    jsr .up
.4:
    lda controller2
    eor controller2pre
    and controller2
    and #BUTTON_A
    beq .5
    lda player2_sword
    beq .5
    jsr .A

.5:
    lda controller2
    eor controller2pre
    and controller2
    and #BUTTON_B
    beq .done
    lda player2_atacking_counter
    bne .done
.B:
    lda player2_stelth
    eor #$FF
    sta player2_stelth

.done:
    rts

.down:
    lda #$00
    sta tmp3    ; speed counter
    lda #DIRECTION_DOWN
    sta player2_direction
.1a:
    jsr .1sr
    ; speed loop.
    lda tmp3
    clc
    adc #$01
    sta tmp3
    lda tmp3
    cmp player2_speed
    bne .1a
    rts
.1sr:
    lda #$00
    sta tmp4
    ; check hitting the wall flag.
    ldx #$00
.1l:
    lda player2_x
    clc
    adc .downTable, x
    sta tmp
    lda player2_y
    clc
    adc .downTable+2, x
    sta tmp2
    jsr CheckTile
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
    inc player2_y
    lda #TRUE
    sta player2_move_flag
    jmp .1e
.1c:
    ; slide along the wall.
    lda tmp4
    and #$02
    bne .1d
    inc player2_x
    lda #TRUE
    sta player2_move_flag
    jmp .1e
.1d:
    ; slide along the wall.
    lda tmp4
    and #$01
    bne .1e
    dec player2_x
    lda #TRUE
    sta player2_move_flag
.1e:
    rts
.downTable:
    .db $00,$06, $08,$08, $01,$02

.right:
    lda #$00
    sta tmp3    ; speed counter
    lda #DIRECTION_RIGHT
    sta player2_direction
.2a:
    jsr .2sr
    ; speed loop.
    lda tmp3
    clc
    adc #$01
    sta tmp3
    lda tmp3
    cmp player2_speed
    bne .2a
    rts
.2sr:
    lda #$00
    sta tmp4
    ; check hitting the wall flag.
    ldx #$00
.2l:
    lda player2_x
    clc
    adc .rightTable, x
    sta tmp
    lda player2_y
    clc
    adc .rightTable+2, x
    sta tmp2
    jsr CheckTile
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
    inc player2_x
    lda #TRUE
    sta player2_move_flag
    jmp .2e
.2c:
    ; slide along the wall.
    lda tmp4
    and #$02
    bne .2d
    inc player2_y
    lda #TRUE
    sta player2_move_flag
    jmp .2e
.2d:
    ; slide along the wall.
    lda tmp4
    and #$01
    bne .2e
    dec player2_y
    lda #TRUE
    sta player2_move_flag
.2e:

    ; increase item_counter_inc for random
    inc item_counter_inc

    rts
.rightTable:
    .db $07,$07, $00,$07, $01,$02
.left:
    lda #$00
    sta tmp3    ; speed counter
    lda #DIRECTION_LEFT
    sta player2_direction
.3a:
    jsr .3sr
    ; speed loop.
    lda tmp3
    clc
    adc #$01
    sta tmp3
    lda tmp3
    cmp player2_speed
    bne .3a
    rts
.3sr:
    lda #$00
    sta tmp4
    ; check hitting the wall flag.
    ldx #$00
.3l:
    lda player2_x
    clc
    adc .leftTable, x
    sta tmp
    lda player2_y
    clc
    adc .leftTable+2, x
    sta tmp2
    jsr CheckTile
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
    dec player2_x
    lda #TRUE
    sta player2_move_flag
    jmp .3e
.3c:
    ; slide along the wall.
    lda tmp4
    and #$02
    bne .3d
    inc player2_y
    lda #TRUE
    sta player2_move_flag
    jmp .3e
.3d:
    ; slide along the wall.
    lda tmp4
    and #$01
    bne .3e
    dec player2_y
    lda #TRUE
    sta player2_move_flag
.3e:
    rts
.leftTable:
    .db $FF,$FF, $00,$07, $01,$02

.up:
    lda #$00
    sta tmp3    ; speed counter
    lda #DIRECTION_UP
    sta player2_direction
.4a:
    jsr .4sr
    ; speed loop.
    lda tmp3
    clc
    adc #$01
    sta tmp3
    lda tmp3
    cmp player2_speed
    bne .4a
    rts
.4sr:
    lda #$00
    sta tmp4
    ; check hitting the wall flag.
    ldx #$00
.4l:
    lda player2_x
    clc
    adc .upTable, x
    sta tmp
    lda player2_y
    clc
    adc .upTable+2, x
    sta tmp2
    jsr CheckTile
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
    dec player2_y
    lda #TRUE
    sta player2_move_flag
    jmp .4e
.4c:
    ; slide along the wall.
    lda tmp4
    and #$02
    bne .4d
    inc player2_x
    lda #TRUE
    sta player2_move_flag
    jmp .4e
.4d:
    ; slide along the wall.
    lda tmp4
    and #$01
    bne .4e
    dec player2_x
    lda #TRUE
    sta player2_move_flag
.4e:
    rts
.upTable:
    .db $00,$06, $FF,$FF, $01,$02
.A:
    lda #$0F
    sta player2_atacking_counter

    dec player2_sword

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

    lda #$50
    sta player2_sword_counter

    rts
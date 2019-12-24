Player1SpriteUpdate:
    ; player
    lda player1_y
    eor player1_x
    lsr a
    and #$04
    eor player1_direction
    sta player1_spr

    ; sword
    ; sword level
    lda player1_sword_level
    asl a
    asl a
    asl a
    asl a
    asl a
    asl a
    sta tmp
    ; direction
    lda player1_direction
    asl a
    asl a
    asl a
    asl a
    clc
    adc tmp
    tax

    ; sword position
    lda player1_atacking_counter
    lsr a
    eor #$07
    sec
    sbc #$03
    sta tmp

    lda #$00
    sta tmp3
.loop:

    jsr .sr

    inc tmp3
    lda tmp3
    cmp #$08
    bne .loop



    ; stelth
    lda player1_atacking_counter
    bne .1
    lda #$FE
    sta player1_sword1_spr
    sta player1_sword2_spr
    sta player1_sword3_spr
    sta player1_sword4_spr
    lda #$00
    sta player1_sword1_x
    sta player1_sword2_x
    sta player1_sword3_x
    sta player1_sword4_x
    sta player1_sword1_y
    sta player1_sword2_y
    sta player1_sword3_y
    sta player1_sword4_y

    lda player1_stelth
    bne .1
    lda #$FE
    sta player1_spr

    jmp .2
.1:
    lda player1_atacking_counter
    lsr a
    sta tmp
    lda player1_direction
    asl a
    asl a
    asl a
    asl a
    clc
    adc #$20
    clc
    adc tmp
    sta player1_sword1_spr
    clc
    adc #$08
    sta player1_sword2_spr
    sta player1_sword3_spr
    sta player1_sword4_spr
.2:
    rts

.sr:
    lda tmp3
    asl a
    asl a
    tay
    lda .table2, y
    sta source_addr_low
    lda .table2+1, y
    sta source_addr_high
    ldy #$00
    lda [source_addr_low], y
    sta tmp2


    lda tmp3
    asl a
    asl a
    tay
    lda .table2+2, y
    sta source_addr_low
    lda .table2+3, y
    sta source_addr_high
    ldy #$00

    lda swordPosition, x
    sta tmp4

    lda tmp
    and #$01
    beq .l1
    lda tmp4
    clc
    adc tmp2
    sta tmp2
.l1:
    asl tmp4
    lda tmp
    and #$02
    beq .l2
    lda tmp4
    clc
    adc tmp2
    sta tmp2
.l2:
    asl tmp4
    lda tmp
    and #$04
    beq .l3
    lda tmp4
    clc
    adc tmp2
    sta tmp2
.l3:
    asl tmp4
    lda tmp
    and #$08
    beq .l4
    lda tmp4
    clc
    adc tmp2
    sta tmp2
.l4:
    asl tmp4
    lda tmp
    and #$10
    beq .l5
    lda tmp4
    clc
    adc tmp2
    sta tmp2
.l5:
    asl tmp4
    lda tmp
    and #$20
    beq .l6
    lda tmp4
    clc
    adc tmp2
    sta tmp2
.l6:
    asl tmp4
    lda tmp
    and #$40
    beq .l7
    lda tmp4
    clc
    adc tmp2
    sta tmp2
.l7:
    asl tmp4
    lda tmp
    and #$80
    beq .l8
    lda tmp4
    clc
    adc tmp2
    sta tmp2
.l8:

    inx

    lda tmp2
    clc
    adc swordPosition, x
    sta [source_addr_low], y
    inx
    rts


.table2:
    .dw player1_x, player1_sword1_x, player1_y, player1_sword1_y
    .dw player1_x, player1_sword2_x, player1_y, player1_sword2_y
    .dw player1_x, player1_sword3_x, player1_y, player1_sword3_y
    .dw player1_x, player1_sword4_x, player1_y, player1_sword4_y
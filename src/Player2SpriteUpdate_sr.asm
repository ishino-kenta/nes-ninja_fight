Player2SpriteUpdate:
    ; player
    lda player2_y
    eor player2_x
    lsr a
    and #$04
    eor player2_direction
    sta player2_spr

    ; sword
    ; sword level
    lda player2_sword_level
    asl a
    asl a
    asl a
    asl a
    asl a
    asl a
    sta tmp
    ; direction
    lda player2_direction
    asl a
    asl a
    asl a
    asl a
    clc
    adc tmp
    tax

    ; sword position
    lda player2_atacking_counter
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
    lda player2_stelth
    bne .1
    lda player2_atacking_counter
    bne .1
    lda #$0F
    sta player2_spr
    sta player2_sword1_spr
    sta player2_sword2_spr
    sta player2_sword3_spr
    sta player2_sword4_spr
    jmp .2
.1:
    lda player2_atacking_counter
    lsr a
    sta tmp
    lda player2_direction
    asl a
    asl a
    asl a
    asl a
    clc
    adc #$20
    clc
    adc tmp
    sta player2_sword1_spr
    clc
    adc #$08
    sta player2_sword2_spr
    sta player2_sword3_spr
    sta player2_sword4_spr
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

    lda .table1, x
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
    adc .table1, x
    sta [source_addr_low], y
    inx
    rts

.table1:
;   .db i1x,s1x,i1y,s1y, i2x,s2x,i2y,s2y, i3x,s3x,i3y,s3y, i4x,s4x,i4y,s4y 
    .db $00,$07,$00,$00, $00,$07,$00,$00, $00,$07,$00,$00, $00,$07,$00,$00 ; right
    .db $00,$F8,$00,$00, $00,$F8,$00,$00, $00,$F8,$00,$00, $00,$F8,$00,$00 ; left
    .db $00,$00,$00,$08, $00,$00,$00,$08, $00,$00,$00,$08, $00,$00,$00,$08 ; down
    .db $00,$00,$00,$F8, $00,$00,$00,$F8, $00,$00,$00,$F8, $00,$00,$00,$F8 ; up

    .db $00,$07,$00,$00, $00,$0F,$01,$00, $00,$0F,$01,$00, $00,$0F,$01,$00 ; right
    .db $00,$F8,$00,$00, $00,$F0,$FF,$00, $00,$F0,$FF,$00, $00,$F0,$FF,$00 ; left
    .db $00,$00,$00,$08, $01,$00,$00,$10, $01,$00,$00,$10, $01,$00,$00,$10 ; down
    .db $00,$00,$00,$F8, $FF,$00,$00,$F0, $FF,$00,$00,$F0, $FF,$00,$00,$F0 ; up

    .db $00,$07,$00,$00, $00,$0F,$01,$00, $00,$17,$02,$00, $00,$17,$02,$00 ; right
    .db $00,$F8,$00,$00, $00,$F0,$FF,$00, $00,$E8,$FE,$00, $00,$E8,$FE,$00 ; left
    .db $00,$00,$00,$08, $01,$00,$00,$10, $02,$00,$00,$18, $02,$00,$00,$18 ; down
    .db $00,$00,$00,$F8, $FF,$00,$00,$F0, $FE,$00,$00,$E8, $FE,$00,$00,$E8 ; up

    .db $00,$07,$00,$00, $00,$0F,$01,$00, $00,$17,$02,$00, $00,$1F,$03,$00 ; right
    .db $00,$F8,$00,$00, $00,$F0,$FF,$00, $00,$E8,$FE,$00, $00,$E0,$FD,$00 ; left
    .db $00,$00,$00,$08, $01,$00,$00,$10, $02,$00,$00,$18, $03,$00,$00,$20 ; down
    .db $00,$00,$00,$F8, $FF,$00,$00,$F0, $FE,$00,$00,$E8, $FD,$00,$00,$E0 ; up


.table2:
    .dw player2_x, player2_sword1_x, player2_y, player2_sword1_y
    .dw player2_x, player2_sword2_x, player2_y, player2_sword2_y
    .dw player2_x, player2_sword3_x, player2_y, player2_sword3_y
    .dw player2_x, player2_sword4_x, player2_y, player2_sword4_y
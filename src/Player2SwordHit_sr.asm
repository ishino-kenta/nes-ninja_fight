Player2SwordHit:
    lda player2_atacking_counter
    beq .done

    jsr .sr

.done:

    rts

.sr:
    lda player2_spr
    and #$02
    lsr a
    tax
    lda swordTable, x
    clc
    adc player2_sword1_x
    sta tmp
    lda player1_x
    cmp tmp ; p2x < p1sx+p1sw
    bcs .label1
    lda player1_x
    clc
    adc #PLAYER1_WIDTH
    sta tmp
    lda player2_sword1_x
    cmp tmp   ; p1sx < p2x+p2w
    bcs .label1


    lda player2_spr
    and #$02
    eor #$02
    lsr a
    tax
    lda swordTable, x
    clc
    adc player2_sword1_y
    sta tmp
    lda player1_y
    cmp tmp ; p2y < p1sy+p1sh
    bcs .label1
    lda player1_y
    clc
    adc #PLAYER1_HEIGHT
    sta tmp
    lda player2_sword1_y
    cmp tmp   ; p1sy < p2y+p2h
    bcs .label1
    lda player2_sword_hit
    bne .label1
    lda #$01
    sta player2_sword_hit
    jsr .damage

    rts
.label1:

    lda player2_spr
    and #$02
    lsr a
    tax
    lda swordTable, x
    clc
    adc player2_sword2_x
    sta tmp
    lda player1_x
    cmp tmp ; p2x < p1sx+p1sw
    bcs .label2
    lda player1_x
    clc
    adc #PLAYER1_WIDTH
    sta tmp
    lda player2_sword2_x
    cmp tmp   ; p1sx < p2x+p2w
    bcs .label2


    lda player2_spr
    and #$02
    eor #$02
    lsr a
    tax
    lda swordTable, x
    clc
    adc player2_sword2_y
    sta tmp
    lda player1_y
    cmp tmp ; p2y < p1sy+p1sh
    bcs .label2
    lda player1_y
    clc
    adc #PLAYER1_HEIGHT
    sta tmp
    lda player2_sword2_y
    cmp tmp   ; p1sy < p2y+p2h
    bcs .label2
    lda player2_sword_hit
    bne .label2
    lda #$01
    sta player2_sword_hit
    jsr .damage

    rts
.label2:

    lda player2_spr
    and #$02
    lsr a
    tax
    lda swordTable, x
    clc
    adc player2_sword3_x
    sta tmp
    lda player1_x
    cmp tmp ; p2x < p1sx+p1sw
    bcs .label3
    lda player1_x
    clc
    adc #PLAYER1_WIDTH
    sta tmp
    lda player2_sword3_x
    cmp tmp   ; p1sx < p2x+p2w
    bcs .label3


    lda player2_spr
    and #$02
    eor #$02
    lsr a
    tax
    lda swordTable, x
    clc
    adc player2_sword3_y
    sta tmp
    lda player1_y
    cmp tmp ; p2y < p1sy+p1sh
    bcs .label3
    lda player1_y
    clc
    adc #PLAYER1_HEIGHT
    sta tmp
    lda player2_sword3_y
    cmp tmp   ; p1sy < p2y+p2h
    bcs .label3
    lda player2_sword_hit
    bne .label3
    lda #$01
    sta player2_sword_hit
    jsr .damage

    rts
.label3:

    lda player2_spr
    and #$02
    lsr a
    tax
    lda swordTable, x
    clc
    adc player2_sword4_x
    sta tmp
    lda player1_x
    cmp tmp ; p2x < p1sx+p1sw
    bcs .label4
    lda player1_x
    clc
    adc #PLAYER1_WIDTH
    sta tmp
    lda player2_sword4_x
    cmp tmp   ; p1sx < p2x+p2w
    bcs .label4


    lda player2_spr
    and #$02
    eor #$02
    lsr a
    tax
    lda swordTable, x
    clc
    adc player2_sword4_y
    sta tmp
    lda player1_y
    cmp tmp ; p2y < p1sy+p1sh
    bcs .label4
    lda player1_y
    clc
    adc #PLAYER1_HEIGHT
    sta tmp
    lda player2_sword4_y
    cmp tmp   ; p1sy < p2y+p2h
    bcs .label4
    lda player2_sword_hit
    bne .label4
    lda #$01
    sta player2_sword_hit
    jsr .damage

    rts
.label4:

    lda #$00
    sta player2_sword_hit
    rts



.damage:
    dec player1_life

    lda #%00001000
    sta $4015
    lda #%11000001
    sta $400C
    lda #%00000100
    sta $400E
    lda #%00010011
    sta $400F

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

    lda tmp3
    and #$3F
    tax
    lda randomYTable, x
    sta player1_y
    dec player1_y

    lda player1_x
    sta tmp
    lda player1_y
    sta tmp2
    jsr CheckTile
    cmp #FLOOR
    bne .1

    lda #$FF
    sta player1_stelth

    rts
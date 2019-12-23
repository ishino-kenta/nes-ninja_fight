CheckItemCounter:
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

    lda player1_x
    eor player1_y
    eor player2_x
    eor player2_y
    and #$07
    tax
    lda itemKindTable, x
    sta item_kind

.1:

    ; get check
    lda item_flag
    beq .2
    
    lda #$80
    clc
    adc item_kind
    sta item_spr

    jsr Player1ItemGet
    jsr Player2ItemGet

    jmp .done

.2:
    lda #$FE
    sta item_spr
.done:

    ; set item sprite
    lda item_x
    sta ITEM_X
    lda item_y
    sta ITEM_Y
    lda item_spr
    sta ITEM_SPR
    lda #$02
    sta ITEM_ATTR

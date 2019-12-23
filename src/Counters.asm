Counters:
    ; speed
    lda player1_speed_level
    asl a
    asl a
    clc
    adc player1_speed_level
    clc
    adc walk_counter
    tax
    lda walkSpeed, x
    sta player1_speed
    
    lda walk_counter

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
    cmp #SWORD_MAX
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
    cmp #SWORD_MAX
    beq .4
    dec player2_sword_counter
    lda player2_sword_counter
    cmp #$00
    bne .4
    inc player2_sword
    lda #$50
    sta player2_sword_counter
.4:

    ; attack player1
    lda player1_atacking_counter
    beq .5
    dec player1_atacking_counter
    lda player1_atacking_counter
    and #$FE
    bne .5
    lda #$00
    sta player1_atacking_counter
.5:
    lda player1_atacking_counter
    lsr a
    sta player1_sword_state

    ; attack player2
    lda player2_atacking_counter
    beq .6
    dec player2_atacking_counter
    lda player2_atacking_counter
    and #$FE
    bne .6
    lda #$00
    sta player2_atacking_counter
.6:
    lda player2_atacking_counter
    lsr a
    sta player2_sword_state

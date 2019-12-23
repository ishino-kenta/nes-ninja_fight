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
Player1SpriteDraw:
    lda player1_sword1_x
    sta PLAYER1_SWORD1_X
    lda player1_sword1_y
    sta PLAYER1_SWORD1_Y
    
    lda player1_sword2_x
    sta PLAYER1_SWORD2_X
    lda player1_sword2_y
    sta PLAYER1_SWORD2_Y
    
    lda player1_sword3_x
    sta PLAYER1_SWORD3_X
    lda player1_sword3_y
    sta PLAYER1_SWORD3_Y

    lda player1_sword4_x
    sta PLAYER1_SWORD4_X
    lda player1_sword4_y
    sta PLAYER1_SWORD4_Y

    lda player1_sword1_spr
    sta PLAYER1_SWORD1_SPR
    lda player1_sword2_spr
    sta PLAYER1_SWORD2_SPR
    lda player1_sword3_spr
    sta PLAYER1_SWORD3_SPR
    lda player1_sword4_spr
    sta PLAYER1_SWORD4_SPR

    lda player1_y
    sta PLAYER1_Y
    lda player1_x
    sta PLAYER1_X
    lda player1_spr
    sta PLAYER1_SPR

    rts


Player2SpriteDraw:
    lda player2_sword1_x
    sta PLAYER2_SWORD1_X
    lda player2_sword1_y
    sta PLAYER2_SWORD1_Y
    
    lda player2_sword2_x
    sta PLAYER2_SWORD2_X
    lda player2_sword2_y
    sta PLAYER2_SWORD2_Y
    
    lda player2_sword3_x
    sta PLAYER2_SWORD3_X
    lda player2_sword3_y
    sta PLAYER2_SWORD3_Y

    lda player2_sword1_spr
    sta PLAYER2_SWORD1_SPR
    lda player2_sword2_spr
    sta PLAYER2_SWORD2_SPR
    lda player2_sword3_spr
    sta PLAYER2_SWORD3_SPR

    lda player2_y
    sta PLAYER2_Y
    lda player2_x
    sta PLAYER2_X
    lda player2_spr
    sta PLAYER2_SPR

    

    rts
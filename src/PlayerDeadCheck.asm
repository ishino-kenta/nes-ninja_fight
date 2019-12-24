PlayerDeadCheck:
    ; player1
    lda player1_life
    beq .gameOverInit
    ; player2
    lda player2_life
    beq .gameOverInit
    jmp .done
.gameOverInit:
    lda #STATE_OVER
    sta game_state
    lda #0
    sta window_counter
.done:
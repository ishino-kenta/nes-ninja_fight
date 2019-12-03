DUMY_ITEM = $00
SWORD_LONGER = $01
SPEED_UPPER = $02

items:
    .dw dumyItem
    .dw swordLonger
    .dw speedUpper

dumyItem:

    rts

swordLonger:

    rts

;--------------------------------------------------
; in
;   a: player1->0, player2->1
; mem
;   source_addr_low, source_addr_high, y, x
speedUpper:
    asl a
    tax
    lda player_speed_level, x
    sta source_addr_low
    lda player_speed_level+1, x
    sta source_addr_high
    ldy #$00
    lda [source_addr_low], y
    cmp #$0A
    beq .1
    clc
    adc #$01
    sta [source_addr_low], y
.1:
    rts

player_speed_level:
    .dw player1_speed_level, player2_speed_level
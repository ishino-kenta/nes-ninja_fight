
EnginePlaying:

    .include "src/PlayerStatusDraw.asm"

    lda #$00
    sta $2003
    lda #$02
    sta $4014 ; sprite DMA

    lda #%10010000  ; PPU clean up
    sta $2000
    lda #%00011110
    sta $2001
    lda #$00
    sta $2005
    sta $2005

    .include "src/Counters.asm"

    jsr ReadController1
    jsr ReadController2

    jsr Player1Controll
    jsr Player2Controll

    jsr Player1SpriteUpdate
    jsr Player2SpriteUpdate

    jsr Player1SwordHit
    jsr Player2SwordHit

    .include "src/PlayerDeadCheck.asm"

    .include "src/Item.asm"


    rts

swordPosition:
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


randomXTable:
    .db $C0,$10,$58,$28,$18,$A0,$38,$98
    .db $78,$C0,$98,$70,$D0,$80,$78,$68
    .db $18,$88,$50,$B8,$98,$90,$E0,$38
    .db $C8,$D8,$98,$40,$80,$70,$58,$28
    .db $E0,$C0,$C8,$88,$C0,$30,$28,$C0
    .db $40,$B0,$80,$58,$E0,$68,$70,$D8
    .db $E0,$30,$C8,$50,$88,$88,$80,$A8
    .db $A0,$68,$78,$78,$C8,$48,$A8,$30

randomYTable:
    .db $60,$50,$50,$28,$30,$18,$78,$20
    .db $68,$70,$80,$70,$68,$70,$38,$28
    .db $78,$50,$38,$78,$78,$78,$20,$40
    .db $88,$90,$68,$28,$30,$40,$60,$88
    .db $28,$50,$58,$28,$20,$30,$50,$20
    .db $40,$90,$30,$88,$68,$88,$60,$80
    .db $40,$80,$88,$30,$60,$80,$50,$30
    .db $38,$80,$40,$68,$70,$20,$68,$28

itemKindTable:
    .db $02,$02,$02,$02,$02,$02,$01,$01
    
    .include "src/Player1Controll_sr.asm"
    .include "src/Player2Controll_sr.asm"
walkSpeed:
    .db 1,1,1,1,1
    .db 1,1,1,1,2
    .db 1,1,2,1,2
    .db 2,1,2,1,2
    .db 2,1,2,2,2
    .db 2,2,2,2,2
    .db 2,2,2,2,3
    .db 2,2,3,2,3
    .db 3,2,3,2,3
    .db 3,2,3,3,3
    .db 3,3,3,3,3

    .include "src/Player1ItemGet_sr.asm"
    .include "src/Player2ItemGet_sr.asm"

    .include "src/Player1SwordHit_sr.asm"
    .include "src/Player2SwordHit_sr.asm"
swordTable:
    .db PLAYER_SWORD_LENGTH, PLAYER_SWORD_WIDTH


    .include "src/Player1SpriteUpdate_sr.asm"
    .include "src/Player2SpriteUpdate_sr.asm"

    .include "src/ItemList_sr.asm"
    
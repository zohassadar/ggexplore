; da65 V2.19 - Git 16bf472e6
; Created:    2024-06-14 14:57:50
; Input file: tetris.prg
; Page:       1


        .setcpu "6502"

; ----------------------------------------------------------------------------
tmp1            := $0000
tmp2            := $0001
tmp3            := $0002
tmpBulkCopyToPpuReturnAddr:= $0005
patchToPpuAddr  := $0014
rng_seed        := $0017
spawnID         := $0019
spawnCount      := $001A
verticalBlankingInterval:= $0033
unused_0E       := $0034                        ; Always $0E
tetriminoX      := $0040                        ; Player data is $20 in size. It is copied here from $60 or $80, processed, then copied back
tetriminoY      := $0041
currentPiece    := $0042                        ; Current piece as an orientation ID
levelNumber     := $0044
fallTimer       := $0045
autorepeatX     := $0046
startLevel      := $0047
playState       := $0048
vramRow         := $0049                        ; Next playfield row to copy. Set to $20 when playfield copy is complete
completedRow    := $004A                        ; Row which has been cleared. 0 if none complete
autorepeatY     := $004E
holdDownPoints  := $004F
lines           := $0050
rowY            := $0052
score           := $0053
completedLines  := $0056
lineIndex       := $0057                        ; Iteration count of playState_checkForCompletedRows
curtainRow      := $0058
startHeight     := $0059
garbageHole     := $005A                        ; Position of hole in received garbage
player1_tetriminoX:= $0060
player1_tetriminoY:= $0061
player1_currentPiece:= $0062
player1_levelNumber:= $0064
player1_fallTimer:= $0065
player1_autorepeatX:= $0066
player1_startLevel:= $0067
player1_playState:= $0068
player1_vramRow := $0069
player1_completedRow:= $006A
player1_autorepeatY:= $006E
player1_holdDownPoints:= $006F
player1_lines   := $0070
player1_rowY    := $0072
player1_score   := $0073
player1_completedLines:= $0076
player1_curtainRow:= $0078
player1_startHeight:= $0079
player1_garbageHole:= $007A
player2_tetriminoX:= $0080
player2_tetriminoY:= $0081
player2_currentPiece:= $0082
player2_levelNumber:= $0084
player2_fallTimer:= $0085
player2_autorepeatX:= $0086
player2_startLevel:= $0087
player2_playState:= $0088
player2_vramRow := $0089
player2_completedRow:= $008A
player2_autorepeatY:= $008E
player2_holdDownPoints:= $008F
player2_lines   := $0090
player2_rowY    := $0092
player2_score   := $0093
player2_completedLines:= $0096
player2_curtainRow:= $0098
player2_startHeight:= $0099
player2_garbageHole:= $009A
spriteXOffset   := $00A0
spriteYOffset   := $00A1
spriteIndexInOamContentLookup:= $00A2
outOfDateRenderFlags:= $00A3                    ; Bit 0-lines 1-level 2-score 6-stats 7-high score entry letter
twoPlayerPieceDelayCounter:= $00A4              ; 0 is not delaying
twoPlayerPieceDelayPlayer:= $00A5
twoPlayerPieceDelayPiece:= $00A6                ; The future value of nextPiece, once the delay completes
gameModeState   := $00A7                        ; For values, see playState_checkForCompletedRows
generalCounter  := $00A8                        ; canon is legalScreenCounter2
generalCounter2 := $00A9
generalCounter3 := $00AA
generalCounter4 := $00AB
generalCounter5 := $00AC
selectingLevelOrHeight:= $00AD                  ; 0-level, 1-height
originalY       := $00AE
dropSpeed       := $00AF
tmpCurrentPiece := $00B0                        ; Only used as a temporary
frameCounter    := $00B1
oamStagingLength:= $00B3
newlyPressedButtons:= $00B5                     ; Active player's buttons
heldButtons     := $00B6                        ; Active player's buttons
activePlayer    := $00B7                        ; Which player is being processed (data in $40)
playfieldAddr   := $00B8                        ; HI byte is leftPlayfield in canon. Current playfield being processed: $0400 (left; 1st player) or $0500 (right; 2nd player)
allegro         := $00BA
pendingGarbage  := $00BB                        ; Garbage waiting to be delivered to the current player. This is exchanged with pendingGarbageInactivePlayer when swapping players.
pendingGarbageInactivePlayer:= $00BC            ; canon is totalGarbage
renderMode      := $00BD
numberOfPlayers := $00BE
nextPiece       := $00BF                        ; Stored by its orientation ID
gameMode        := $00C0                        ; 0=legal, 1=title, 2=type menu, 3=level menu, 4=play and ending and high score, 5=demo, 6=start demo
gameType        := $00C1                        ; A=0, B=1
musicType       := $00C2                        ; 0-3; 3 is off
sleepCounter    := $00C3                        ; canon is legalScreenCounter1
ending          := $00C4
ending_customVars:= $00C5                       ; Different usages depending on Type A and B and Type B concert
ending_currentSprite:= $00CC
ending_typeBCathedralFrameDelayCounter:= $00CD
demo_heldButtons:= $00CE
demo_repeats    := $00CF
demo_recording  := $00D0                        ; Always 0. FF enables recording
demoButtonsAddr := $00D1                        ; Current address within demoButtonsTable
demoIndex       := $00D3
highScoreEntryNameOffsetForLetter:= $00D4       ; Relative to current row
highScoreEntryRawPos:= $00D5                    ; High score position 0=1st type A, 1=2nd... 4=1st type B... 7=4th/extra type B
highScoreEntryNameOffsetForRow:= $00D6          ; Relative to start of table
highScoreEntryCurrentLetter:= $00D7
lineClearStatsByType:= $00D8                    ; bcd. one entry for each of single, double, triple, tetris
totalScore      := $00DC
displayNextPiece:= $00DF                        ; 0=show, 1=hide
AUDIOTMP1       := $00E0
AUDIOTMP2       := $00E1
AUDIOTMP3       := $00E2
AUDIOTMP4       := $00E3
AUDIOTMP5       := $00E4
musicChanTmpAddr:= $00E6
music_unused2   := $00EA                        ; Always 0
soundRngSeed    := $00EB                        ; Set, but not read
currentSoundEffectSlot:= $00ED                  ; Temporary
musicChannelOffset:= $00EE                      ; Temporary. Added to $4000-3 for MMIO
currentAudioSlot:= $00EF                        ; Temporary
unreferenced_buttonMirror:= $00F1               ; Mirror of $F5-F8
newlyPressedButtons_player1:= $00F5             ; $80-a $40-b $20-select $10-start $08-up $04-down $02-left $01-right
newlyPressedButtons_player2:= $00F6
heldButtons_player1:= $00F7
heldButtons_player2:= $00F8
joy1Location    := $00FB                        ; normal=0; 1 or 3 for expansion
ppuScrollY      := $00FC                        ; Set to 0 many places, but not read
ppuScrollX      := $00FD                        ; Set to 0 many places, but not read
currentPpuMask  := $00FE
currentPpuCtrl  := $00FF
stack           := $0100
oamStaging      := $0200                        ; format: https://wiki.nesdev.com/w/index.php/PPU_programmer_reference#OAM
statsByType     := $03F0
playfield       := $0400
playfieldForSecondPlayer:= $0500
musicStagingSq1Lo:= $0680
musicStagingSq1Hi:= $0681
audioInitialized:= $0682
musicPauseSoundEffectLengthCounter:= $0683
musicStagingSq2Lo:= $0684
musicStagingSq2Hi:= $0685
musicStagingTriLo:= $0688
musicStagingTriHi:= $0689
resetSq12ForMusic:= $068A                       ; 0-off. 1-sq1. 2-sq1 and sq2
musicPauseSoundEffectCounter:= $068B            ; Even/odd for sound effect alternating
music_unused    := $068C                        ; Always 0
musicPauseScreen:= $068D                        ; $05 if in pause screen
musicDataNoteTableOffset:= $0690                ; AKA start of musicData, of size $0A
musicDataDurationTableOffset:= $0691
musicDataChanPtr:= $0692
musicChanControl:= $069A                        ; high 3 bits are for LO offset behavior. Low 5 bits index into musicChanVolControlTable, minus 1. Technically size 4, but usages of the next variable 'cheat' since that variable's first index is unused
musicChanVolume := $069D                        ; Must not use first index. First and second index are unused. High nibble always used; low nibble may be used depending on control and frame
musicDataChanPtrDeref:= $06A0                   ; deref'd musicDataChanPtr+musicDataChanPtrOff
musicDataChanPtrOff:= $06A8
musicDataChanInstructionOffset:= $06AC
musicDataChanInstructionOffsetBackup:= $06B0
musicChanNoteDurationRemaining:= $06B4
musicChanNoteDuration:= $06B8
musicChanProgLoopCounter:= $06BC                ; As driven by bytecode instructions
musicStagingSq1Sweep:= $06C0                    ; Used as if size 4, but since Tri/Noise does nothing when written for sweep, the other two entries can have any value without changing behavior
musicChanNote   := $06C3
musicChanInhibitSetter:= $06C7
musicChanInhibit:= $06C8                        ; If x denotes channel, then channel inhibited when this value contains x+1. Disabled via musicChanInhibitSetter
musicTrack_dec  := $06CC                        ; $00-$09
musicChanVolFrameCounter:= $06CD                ; Pos 0/1 are unused
musicChanLoFrameCounter:= $06D1                 ; Pos 3 unused
soundEffectSlot0FrameCount:= $06D5              ; Number of frames
soundEffectSlot0FrameCounter:= $06DA            ; Current frame
soundEffectSlot0SecondaryCounter:= $06DF        ; nibble index into noiselo_/noisevol_table
soundEffectSlot1SecondaryCounter:= $06E0
soundEffectSlot2SecondaryCounter:= $06E1
soundEffectSlot3SecondaryCounter:= $06E2
soundEffectSlot0TertiaryCounter:= $06E3
soundEffectSlot1TertiaryCounter:= $06E4
soundEffectSlot2TertiaryCounter:= $06E5
soundEffectSlot3TertiaryCounter:= $06E6
soundEffectSlot0Tmp:= $06E7
soundEffectSlot1Tmp:= $06E8
soundEffectSlot2Tmp:= $06E9
soundEffectSlot3Tmp:= $06EA
soundEffectSlot0Init:= $06F0                    ; NOISE sound effect. 2-game over curtain. 3-ending rocket. For mapping, see soundEffectSlot0Init_table
soundEffectSlot1Init:= $06F1                    ; SQ1 sound effect. Menu, move, rotate, clear sound effects. For mapping, see soundEffectSlot1Init_table
soundEffectSlot2Init:= $06F2                    ; SQ2 sound effect. For mapping, see soundEffectSlot2Init_table
soundEffectSlot3Init:= $06F3                    ; TRI sound effect. For mapping, see soundEffectSlot3Init_table
soundEffectSlot4Init:= $06F4                    ; Unused. Assume meant for DMC sound effect. Uses some data from slot 2
musicTrack      := $06F5                        ; $FF turns off music. $00 continues selection. $01-$0A for new selection
musicDmcGapless := $06F7                        ; When non-zero, change sample without clearing buffered sample. Always 0
soundEffectSlot0Playing:= $06F8                 ; Used if init is zero
soundEffectSlot1Playing:= $06F9
soundEffectSlot2Playing:= $06FA
soundEffectSlot3Playing:= $06FB
soundEffectSlot4Playing:= $06FC
currentlyPlayingMusicTrack:= $06FD              ; Copied from musicTrack
unreferenced_soundRngTmp:= $06FF
highScoreNames  := $0700
highScoreScoresA:= $0730
highScoreScoresB:= $073C
highScoreLevels := $0748
initMagic       := $0750                        ; Initialized to a hard-coded number. When resetting, if not correct number then it knows this is a cold boot
PPUCTRL         := $2000
PPUMASK         := $2001
PPUSTATUS       := $2002
OAMADDR         := $2003
OAMDATA         := $2004
PPUSCROLL       := $2005
PPUADDR         := $2006
PPUDATA         := $2007
SQ1_VOL         := $4000
SQ1_SWEEP       := $4001
SQ1_LO          := $4002
SQ1_HI          := $4003
SQ2_VOL         := $4004
SQ2_SWEEP       := $4005
SQ2_LO          := $4006
SQ2_HI          := $4007
TRI_LINEAR      := $4008
TRI_LO          := $400A
TRI_HI          := $400B
NOISE_VOL       := $400C
NOISE_LO        := $400E
NOISE_HI        := $400F
DMC_FREQ        := $4010
DMC_RAW         := $4011
DMC_START       := $4012                        ; start << 6 + $C000
DMC_LEN         := $4013                        ; len << 4 + 1 
OAMDMA          := $4014
SND_CHN         := $4015
JOY1            := $4016
JOY2_APUFC      := $4017                        ; read: bits 0-4 joy data lines (bit 0 being normal controller), bits 6-7 are FC inhibit and mode
; ----------------------------------------------------------------------------

.segment        "PRG_chunk1": absolute

; incremented to reset MMC1 reg
initRam:ldx     #$00                            ; 8000 A2 00
        jmp     initRamContinued                ; 8002 4C 5A 80

; ----------------------------------------------------------------------------
nmi:    pha                                     ; 8005 48
        txa                                     ; 8006 8A
        pha                                     ; 8007 48
        tya                                     ; 8008 98
        pha                                     ; 8009 48
        lda     #$00                            ; 800A A9 00
        sta     oamStagingLength                ; 800C 85 B3
        jsr     render                          ; 800E 20 4B 80
        dec     sleepCounter                    ; 8011 C6 C3
        lda     sleepCounter                    ; 8013 A5 C3
        cmp     #$FF                            ; 8015 C9 FF
        bne     @jumpOverIncrement              ; 8017 D0 02
        inc     sleepCounter                    ; 8019 E6 C3
@jumpOverIncrement:
        jsr     copyOamStagingToOam             ; 801B 20 5E AB
        lda     frameCounter                    ; 801E A5 B1
        clc                                     ; 8020 18
        adc     #$01                            ; 8021 69 01
        sta     frameCounter                    ; 8023 85 B1
        lda     #$00                            ; 8025 A9 00
        adc     frameCounter+1                  ; 8027 65 B2
        sta     frameCounter+1                  ; 8029 85 B2
        ldx     #$17                            ; 802B A2 17
        ldy     #$02                            ; 802D A0 02
        jsr     generateNextPseudorandomNumber  ; 802F 20 47 AB
        lda     #$00                            ; 8032 A9 00
        sta     ppuScrollX                      ; 8034 85 FD
        sta     PPUSCROLL                       ; 8036 8D 05 20
        sta     ppuScrollY                      ; 8039 85 FC
        sta     PPUSCROLL                       ; 803B 8D 05 20
        lda     #$01                            ; 803E A9 01
        sta     verticalBlankingInterval        ; 8040 85 33
        jsr     pollControllerButtons           ; 8042 20 51 9D
        pla                                     ; 8045 68
        tay                                     ; 8046 A8
        pla                                     ; 8047 68
        tax                                     ; 8048 AA
        pla                                     ; 8049 68
irq:    rti                                     ; 804A 40

; ----------------------------------------------------------------------------
render: lda     renderMode                      ; 804B A5 BD
        jsr     switchOnA                       ; 804D 20 82 AC
        .addr   render_mode_legal_and_title_screens; 8050 B1 82
        .addr   render_mode_menu_screens        ; 8052 DA 85
        .addr   render_mode_congratulations_screen; 8054 44 A3
        .addr   render_mode_play_and_demo       ; 8056 EE 94
        .addr   render_mode_ending_animation    ; 8058 95 9F
; ----------------------------------------------------------------------------
initRamContinued:
        ldy     #$06                            ; 805A A0 06
        sty     tmp2                            ; 805C 84 01
        ldy     #$00                            ; 805E A0 00
        sty     tmp1                            ; 8060 84 00
        lda     #$00                            ; 8062 A9 00
@zeroOutPages:
        sta     (tmp1),y                        ; 8064 91 00
        dey                                     ; 8066 88
        bne     @zeroOutPages                   ; 8067 D0 FB
        dec     tmp2                            ; 8069 C6 01
        bpl     @zeroOutPages                   ; 806B 10 F7
        lda     initMagic                       ; 806D AD 50 07
        cmp     #$12                            ; 8070 C9 12
        bne     @initHighScoreTable             ; 8072 D0 21
        lda     initMagic+1                     ; 8074 AD 51 07
        cmp     #$34                            ; 8077 C9 34
        bne     @initHighScoreTable             ; 8079 D0 1A
        lda     initMagic+2                     ; 807B AD 52 07
        cmp     #$56                            ; 807E C9 56
        bne     @initHighScoreTable             ; 8080 D0 13
        lda     initMagic+3                     ; 8082 AD 53 07
        cmp     #$78                            ; 8085 C9 78
        bne     @initHighScoreTable             ; 8087 D0 0C
        lda     initMagic+4                     ; 8089 AD 54 07
        cmp     #$9A                            ; 808C C9 9A
        bne     @initHighScoreTable             ; 808E D0 05
        jmp     @continueWarmBootInit           ; 8090 4C BC 80

; ----------------------------------------------------------------------------
        ldx     #$00                            ; 8093 A2 00
; Only run on cold boot
@initHighScoreTable:
        lda     defaultHighScoresTable,x        ; 8095 BD 67 AD
        cmp     #$FF                            ; 8098 C9 FF
        beq     @continueColdBootInit           ; 809A F0 07
        sta     highScoreNames,x                ; 809C 9D 00 07
        inx                                     ; 809F E8
        jmp     @initHighScoreTable             ; 80A0 4C 95 80

; ----------------------------------------------------------------------------
@continueColdBootInit:
        lda     #$12                            ; 80A3 A9 12
        sta     initMagic                       ; 80A5 8D 50 07
        lda     #$34                            ; 80A8 A9 34
        sta     initMagic+1                     ; 80AA 8D 51 07
        lda     #$56                            ; 80AD A9 56
        sta     initMagic+2                     ; 80AF 8D 52 07
        lda     #$78                            ; 80B2 A9 78
        sta     initMagic+3                     ; 80B4 8D 53 07
        lda     #$9A                            ; 80B7 A9 9A
        sta     initMagic+4                     ; 80B9 8D 54 07
@continueWarmBootInit:
        ldx     #$89                            ; 80BC A2 89
        stx     rng_seed                        ; 80BE 86 17
        dex                                     ; 80C0 CA
        stx     rng_seed+1                      ; 80C1 86 18
        ldy     #$00                            ; 80C3 A0 00
        sty     ppuScrollX                      ; 80C5 84 FD
        sty     PPUSCROLL                       ; 80C7 8C 05 20
        ldy     #$00                            ; 80CA A0 00
        sty     ppuScrollY                      ; 80CC 84 FC
        sty     PPUSCROLL                       ; 80CE 8C 05 20
        lda     #$90                            ; 80D1 A9 90
        sta     currentPpuCtrl                  ; 80D3 85 FF
        sta     PPUCTRL                         ; 80D5 8D 00 20
        lda     #$06                            ; 80D8 A9 06
        sta     PPUMASK                         ; 80DA 8D 01 20
        jsr     LE006                           ; 80DD 20 06 E0
        jsr     updateAudio2                    ; 80E0 20 03 E0
        lda     #$C0                            ; 80E3 A9 C0
        sta     stack                           ; 80E5 8D 00 01
        lda     #$80                            ; 80E8 A9 80
        sta     stack+1                         ; 80EA 8D 01 01
        lda     #$35                            ; 80ED A9 35
        sta     stack+3                         ; 80EF 8D 03 01
        lda     #$AC                            ; 80F2 A9 AC
        sta     stack+4                         ; 80F4 8D 04 01
        jsr     updateAudioWaitForNmiAndDisablePpuRendering; 80F7 20 52 AA
        jsr     disableNmi                      ; 80FA 20 78 AA
        lda     #$20                            ; 80FD A9 20
        jsr     LAA82                           ; 80FF 20 82 AA
        lda     #$24                            ; 8102 A9 24
        jsr     LAA82                           ; 8104 20 82 AA
        lda     #$28                            ; 8107 A9 28
        jsr     LAA82                           ; 8109 20 82 AA
        lda     #$2C                            ; 810C A9 2C
        jsr     LAA82                           ; 810E 20 82 AA
        lda     #$EF                            ; 8111 A9 EF
        ldx     #$04                            ; 8113 A2 04
        ldy     #$05                            ; 8115 A0 05
        jsr     memset_page                     ; 8117 20 6A AC
        jsr     waitForVBlankAndEnableNmi       ; 811A 20 6B AA
        jsr     updateAudioWaitForNmiAndResetOamStaging; 811D 20 2F AA
        jsr     updateAudioWaitForNmiAndEnablePpuRendering; 8120 20 5F AA
        jsr     updateAudioWaitForNmiAndResetOamStaging; 8123 20 2F AA
        lda     #$0E                            ; 8126 A9 0E
        sta     unused_0E                       ; 8128 85 34
        lda     #$00                            ; 812A A9 00
        sta     gameModeState                   ; 812C 85 A7
        sta     gameMode                        ; 812E 85 C0
        lda     #$01                            ; 8130 A9 01
        sta     numberOfPlayers                 ; 8132 85 BE
        lda     #$00                            ; 8134 A9 00
        sta     frameCounter+1                  ; 8136 85 B2
@mainLoop:
        jsr     branchOnGameMode                ; 8138 20 61 81
        cmp     gameModeState                   ; 813B C5 A7
        bne     @checkForDemoDataExhaustion     ; 813D D0 03
        jsr     updateAudioWaitForNmiAndResetOamStaging; 813F 20 2F AA
@checkForDemoDataExhaustion:
        lda     gameMode                        ; 8142 A5 C0
        cmp     #$05                            ; 8144 C9 05
        bne     @continue                       ; 8146 D0 12
        lda     demoButtonsAddr+1               ; 8148 A5 D2
        cmp     #$DF                            ; 814A C9 DF
        bne     @continue                       ; 814C D0 0C
        lda     #$DD                            ; 814E A9 DD
        sta     demoButtonsAddr+1               ; 8150 85 D2
        lda     #$00                            ; 8152 A9 00
        sta     frameCounter+1                  ; 8154 85 B2
        lda     #$01                            ; 8156 A9 01
        sta     gameMode                        ; 8158 85 C0
@continue:
        jmp     @mainLoop                       ; 815A 4C 38 81

; ----------------------------------------------------------------------------
gameMode_playAndEndingHighScore_jmp:
        jsr     gameMode_playAndEndingHighScore ; 815D 20 9B 81
        rts                                     ; 8160 60

; ----------------------------------------------------------------------------
branchOnGameMode:
        lda     gameMode                        ; 8161 A5 C0
        jsr     switchOnA                       ; 8163 20 82 AC
        .addr   gameMode_legalScreen            ; 8166 00 82
        .addr   gameMode_titleScreen            ; 8168 4F 82
        .addr   gameMode_gameTypeMenu           ; 816A D1 82
        .addr   gameMode_levelMenu              ; 816C D7 83
        .addr   gameMode_playAndEndingHighScore_jmp; 816E 5D 81
        .addr   gameMode_playAndEndingHighScore_jmp; 8170 5D 81
        .addr   gameMode_startDemo              ; 8172 F6 9D
; ----------------------------------------------------------------------------
gameModeState_updatePlayer1:
        jsr     makePlayer1Active               ; 8174 20 76 87
        jsr     branchOnPlayStatePlayer1        ; 8177 20 B2 81
        jsr     stageSpriteForCurrentPiece      ; 817A 20 0A 8A
        jsr     savePlayer1State                ; 817D 20 AE 87
        jsr     stageSpriteForNextPiece         ; 8180 20 CE 8B
        inc     gameModeState                   ; 8183 E6 A7
        rts                                     ; 8185 60

; ----------------------------------------------------------------------------
gameModeState_updatePlayer2:
        lda     numberOfPlayers                 ; 8186 A5 BE
        cmp     #$02                            ; 8188 C9 02
        bne     @ret                            ; 818A D0 0C
        jsr     makePlayer2Active               ; 818C 20 92 87
        jsr     branchOnPlayStatePlayer2        ; 818F 20 D9 81
        jsr     stageSpriteForCurrentPiece      ; 8192 20 0A 8A
        jsr     savePlayer2State                ; 8195 20 C8 87
@ret:   inc     gameModeState                   ; 8198 E6 A7
        rts                                     ; 819A 60

; ----------------------------------------------------------------------------
gameMode_playAndEndingHighScore:
        lda     gameModeState                   ; 819B A5 A7
        jsr     switchOnA                       ; 819D 20 82 AC
        .addr   gameModeState_initGameBackground; 81A0 F0 85
        .addr   gameModeState_initGameState     ; 81A2 DC 86
        .addr   gameModeState_updateCountersAndNonPlayerState; 81A4 84 88
        .addr   gameModeState_handleGameOver    ; 81A6 BF 9C
        .addr   gameModeState_updatePlayer1     ; 81A8 74 81
        .addr   gameModeState_updatePlayer2     ; 81AA 86 81
        .addr   gameModeState_checkForResetKeyCombo; 81AC 16 9E
        .addr   gameModeState_startButtonHandling; 81AE 7F A3
        .addr   gameModeState_vblankThenRunState2; 81B0 27 9E
; ----------------------------------------------------------------------------
branchOnPlayStatePlayer1:
        lda     playState                       ; 81B2 A5 48
        jsr     switchOnA                       ; 81B4 20 82 AC
        .addr   playState_unassignOrientationId ; 81B7 2F 9E
        .addr   playState_playerControlsActiveTetrimino; 81B9 CF 81
        .addr   playState_lockTetrimino         ; 81BB A2 99
        .addr   playState_checkForCompletedRows ; 81BD 6B 9A
        .addr   playState_noop                  ; 81BF 39 9E
        .addr   playState_updateLinesAndStatistics; 81C1 58 9B
        .addr   playState_bTypeGoalCheck        ; 81C3 F2 A3
        .addr   playState_receiveGarbage        ; 81C5 03 9B
        .addr   playState_spawnNextTetrimino    ; 81C7 8E 98
        .addr   playState_noop                  ; 81C9 39 9E
        .addr   playState_updateGameOverCurtain ; 81CB 11 9A
        .addr   playState_incrementPlayState    ; 81CD 37 9E
; ----------------------------------------------------------------------------
playState_playerControlsActiveTetrimino:
        jsr     shift_tetrimino                 ; 81CF 20 AE 89
        jsr     rotate_tetrimino                ; 81D2 20 AB 88
        jsr     drop_tetrimino                  ; 81D5 20 14 89
        rts                                     ; 81D8 60

; ----------------------------------------------------------------------------
branchOnPlayStatePlayer2:
        lda     playState                       ; 81D9 A5 48
        jsr     switchOnA                       ; 81DB 20 82 AC
        .addr   playState_unassignOrientationId ; 81DE 2F 9E
        .addr   playState_player2ControlsActiveTetrimino; 81E0 F6 81
        .addr   playState_lockTetrimino         ; 81E2 A2 99
        .addr   playState_checkForCompletedRows ; 81E4 6B 9A
        .addr   playState_noop                  ; 81E6 39 9E
        .addr   playState_updateLinesAndStatistics; 81E8 58 9B
        .addr   playState_bTypeGoalCheck        ; 81EA F2 A3
        .addr   playState_receiveGarbage        ; 81EC 03 9B
        .addr   playState_spawnNextTetrimino    ; 81EE 8E 98
        .addr   playState_noop                  ; 81F0 39 9E
        .addr   playState_updateGameOverCurtain ; 81F2 11 9A
        .addr   playState_incrementPlayState    ; 81F4 37 9E
; ----------------------------------------------------------------------------
playState_player2ControlsActiveTetrimino:
        jsr     shift_tetrimino                 ; 81F6 20 AE 89
        jsr     rotate_tetrimino                ; 81F9 20 AB 88
        jsr     drop_tetrimino                  ; 81FC 20 14 89
        rts                                     ; 81FF 60

; ----------------------------------------------------------------------------
gameMode_legalScreen:
        jsr     updateAudio2                    ; 8200 20 03 E0
        lda     #$00                            ; 8203 A9 00
        sta     renderMode                      ; 8205 85 BD
        jsr     updateAudioWaitForNmiAndDisablePpuRendering; 8207 20 52 AA
        jsr     disableNmi                      ; 820A 20 78 AA
        lda     #$00                            ; 820D A9 00
        jsr     changeCHRBank0                  ; 820F 20 B7 AC
        lda     #$00                            ; 8212 A9 00
        jsr     changeCHRBank1                  ; 8214 20 CB AC
        jsr     bulkCopyToPpu                   ; 8217 20 98 AA
        .addr   legal_screen_palette            ; 821A 17 AD
; ----------------------------------------------------------------------------
        jsr     bulkCopyToPpu                   ; 821C 20 98 AA
        .addr   legal_screen_nametable          ; 821F B8 AD
; ----------------------------------------------------------------------------
        jsr     waitForVBlankAndEnableNmi       ; 8221 20 6B AA
        jsr     updateAudioWaitForNmiAndResetOamStaging; 8224 20 2F AA
        jsr     updateAudioWaitForNmiAndEnablePpuRendering; 8227 20 5F AA
        jsr     updateAudioWaitForNmiAndResetOamStaging; 822A 20 2F AA
        lda     #$00                            ; 822D A9 00
        ldx     #$02                            ; 822F A2 02
        ldy     #$02                            ; 8231 A0 02
        jsr     memset_page                     ; 8233 20 6A AC
        lda     #$FF                            ; 8236 A9 FF
        jsr     sleep_for_a_vblanks             ; 8238 20 59 A4
        lda     #$FF                            ; 823B A9 FF
        sta     generalCounter                  ; 823D 85 A8
@waitForStartButton:
        lda     newlyPressedButtons_player1     ; 823F A5 F5
        cmp     #$10                            ; 8241 C9 10
        beq     @continueToNextScreen           ; 8243 F0 07
        jsr     updateAudioWaitForNmiAndResetOamStaging; 8245 20 2F AA
        dec     generalCounter                  ; 8248 C6 A8
        bne     @waitForStartButton             ; 824A D0 F3
@continueToNextScreen:
        inc     gameMode                        ; 824C E6 C0
        rts                                     ; 824E 60

; ----------------------------------------------------------------------------
gameMode_titleScreen:
        jsr     updateAudio2                    ; 824F 20 03 E0
        lda     #$00                            ; 8252 A9 00
        sta     renderMode                      ; 8254 85 BD
        sta     demo_recording                  ; 8256 85 D0
        sta     displayNextPiece                ; 8258 85 DF
        jsr     updateAudioWaitForNmiAndDisablePpuRendering; 825A 20 52 AA
        jsr     disableNmi                      ; 825D 20 78 AA
        lda     #$00                            ; 8260 A9 00
        jsr     changeCHRBank0                  ; 8262 20 B7 AC
        lda     #$00                            ; 8265 A9 00
        jsr     changeCHRBank1                  ; 8267 20 CB AC
        jsr     bulkCopyToPpu                   ; 826A 20 98 AA
        .addr   menu_palette                    ; 826D 2B AD
; ----------------------------------------------------------------------------
        jsr     bulkCopyToPpu                   ; 826F 20 98 AA
        .addr   title_screen_nametable          ; 8272 19 B2
; ----------------------------------------------------------------------------
        jsr     waitForVBlankAndEnableNmi       ; 8274 20 6B AA
        jsr     updateAudioWaitForNmiAndResetOamStaging; 8277 20 2F AA
        jsr     updateAudioWaitForNmiAndEnablePpuRendering; 827A 20 5F AA
        jsr     updateAudioWaitForNmiAndResetOamStaging; 827D 20 2F AA
        lda     #$00                            ; 8280 A9 00
        ldx     #$02                            ; 8282 A2 02
        ldy     #$02                            ; 8284 A0 02
        jsr     memset_page                     ; 8286 20 6A AC
        lda     #$00                            ; 8289 A9 00
        sta     frameCounter+1                  ; 828B 85 B2
@waitForStartButton:
        jsr     updateAudioWaitForNmiAndResetOamStaging; 828D 20 2F AA
        lda     newlyPressedButtons_player1     ; 8290 A5 F5
        cmp     #$10                            ; 8292 C9 10
        beq     @startButtonPressed             ; 8294 F0 09
        lda     frameCounter+1                  ; 8296 A5 B2
        cmp     #$05                            ; 8298 C9 05
        beq     @timeout                        ; 829A F0 0B
        jmp     @waitForStartButton             ; 829C 4C 8D 82

; ----------------------------------------------------------------------------
; Show menu screens
@startButtonPressed:
        lda     #$02                            ; 829F A9 02
        sta     soundEffectSlot1Init            ; 82A1 8D F1 06
        inc     gameMode                        ; 82A4 E6 C0
        rts                                     ; 82A6 60

; ----------------------------------------------------------------------------
; Start demo
@timeout:
        lda     #$02                            ; 82A7 A9 02
        sta     soundEffectSlot1Init            ; 82A9 8D F1 06
        lda     #$06                            ; 82AC A9 06
        sta     gameMode                        ; 82AE 85 C0
        rts                                     ; 82B0 60

; ----------------------------------------------------------------------------
render_mode_legal_and_title_screens:
        lda     currentPpuCtrl                  ; 82B1 A5 FF
        and     #$FC                            ; 82B3 29 FC
        sta     currentPpuCtrl                  ; 82B5 85 FF
        lda     #$00                            ; 82B7 A9 00
        sta     ppuScrollX                      ; 82B9 85 FD
        sta     PPUSCROLL                       ; 82BB 8D 05 20
        sta     ppuScrollY                      ; 82BE 85 FC
        sta     PPUSCROLL                       ; 82C0 8D 05 20
        rts                                     ; 82C3 60

; ----------------------------------------------------------------------------
        lda     #$00                            ; 82C4 A9 00
        sta     player1_levelNumber             ; 82C6 85 64
        lda     #$00                            ; 82C8 A9 00
        sta     gameType                        ; 82CA 85 C1
        lda     #$04                            ; 82CC A9 04
        lda     gameMode                        ; 82CE A5 C0
        rts                                     ; 82D0 60

; ----------------------------------------------------------------------------
gameMode_gameTypeMenu:
        inc     initRam                         ; 82D1 EE 00 80
        lda     #$10                            ; 82D4 A9 10
        jsr     setMMC1Control                  ; 82D6 20 A3 AC
        lda     #$01                            ; 82D9 A9 01
        sta     renderMode                      ; 82DB 85 BD
        jsr     updateAudioWaitForNmiAndDisablePpuRendering; 82DD 20 52 AA
        jsr     disableNmi                      ; 82E0 20 78 AA
        jsr     bulkCopyToPpu                   ; 82E3 20 98 AA
        .addr   menu_palette                    ; 82E6 2B AD
; ----------------------------------------------------------------------------
        jsr     bulkCopyToPpu                   ; 82E8 20 98 AA
        .addr   game_type_menu_nametable        ; 82EB 7A B6
; ----------------------------------------------------------------------------
        lda     #$00                            ; 82ED A9 00
        jsr     changeCHRBank0                  ; 82EF 20 B7 AC
        lda     #$00                            ; 82F2 A9 00
        jsr     changeCHRBank1                  ; 82F4 20 CB AC
        jsr     waitForVBlankAndEnableNmi       ; 82F7 20 6B AA
        jsr     updateAudioWaitForNmiAndResetOamStaging; 82FA 20 2F AA
        jsr     updateAudioWaitForNmiAndEnablePpuRendering; 82FD 20 5F AA
        jsr     updateAudioWaitForNmiAndResetOamStaging; 8300 20 2F AA
        ldx     musicType                       ; 8303 A6 C2
        lda     musicSelectionTable,x           ; 8305 BD D2 85
        jsr     setMusicTrack                   ; 8308 20 07 9E
@handleInput:
        lda     #$FF                            ; 830B A9 FF
        ldx     #$02                            ; 830D A2 02
        ldy     #$02                            ; 830F A0 02
        jsr     memset_page                     ; 8311 20 6A AC
        lda     newlyPressedButtons_player1     ; 8314 A5 F5
        cmp     #$01                            ; 8316 C9 01
        bne     @rightNotPressed                ; 8318 D0 0C
        lda     #$01                            ; 831A A9 01
        sta     gameType                        ; 831C 85 C1
        lda     #$01                            ; 831E A9 01
        sta     soundEffectSlot1Init            ; 8320 8D F1 06
        jmp     @leftNotPressed                 ; 8323 4C 35 83

; ----------------------------------------------------------------------------
@rightNotPressed:
        lda     newlyPressedButtons_player1     ; 8326 A5 F5
        cmp     #$02                            ; 8328 C9 02
        bne     @leftNotPressed                 ; 832A D0 09
        lda     #$00                            ; 832C A9 00
        sta     gameType                        ; 832E 85 C1
        lda     #$01                            ; 8330 A9 01
        sta     soundEffectSlot1Init            ; 8332 8D F1 06
@leftNotPressed:
        lda     newlyPressedButtons_player1     ; 8335 A5 F5
        cmp     #$04                            ; 8337 C9 04
        bne     @downNotPressed                 ; 8339 D0 15
        lda     #$01                            ; 833B A9 01
        sta     soundEffectSlot1Init            ; 833D 8D F1 06
        lda     musicType                       ; 8340 A5 C2
        cmp     #$03                            ; 8342 C9 03
        beq     @upNotPressed                   ; 8344 F0 23
        inc     musicType                       ; 8346 E6 C2
        ldx     musicType                       ; 8348 A6 C2
        lda     musicSelectionTable,x           ; 834A BD D2 85
        jsr     setMusicTrack                   ; 834D 20 07 9E
@downNotPressed:
        lda     newlyPressedButtons_player1     ; 8350 A5 F5
        cmp     #$08                            ; 8352 C9 08
        bne     @upNotPressed                   ; 8354 D0 13
        lda     #$01                            ; 8356 A9 01
        sta     soundEffectSlot1Init            ; 8358 8D F1 06
        lda     musicType                       ; 835B A5 C2
        beq     @upNotPressed                   ; 835D F0 0A
        dec     musicType                       ; 835F C6 C2
        ldx     musicType                       ; 8361 A6 C2
        lda     musicSelectionTable,x           ; 8363 BD D2 85
        jsr     setMusicTrack                   ; 8366 20 07 9E
@upNotPressed:
        lda     newlyPressedButtons_player1     ; 8369 A5 F5
        cmp     #$10                            ; 836B C9 10
        bne     @startNotPressed                ; 836D D0 08
        lda     #$02                            ; 836F A9 02
        sta     soundEffectSlot1Init            ; 8371 8D F1 06
        inc     gameMode                        ; 8374 E6 C0
        rts                                     ; 8376 60

; ----------------------------------------------------------------------------
@startNotPressed:
        lda     newlyPressedButtons_player1     ; 8377 A5 F5
        cmp     #$40                            ; 8379 C9 40
        bne     @bNotPressed                    ; 837B D0 0C
        lda     #$02                            ; 837D A9 02
        sta     soundEffectSlot1Init            ; 837F 8D F1 06
        lda     #$00                            ; 8382 A9 00
        sta     frameCounter+1                  ; 8384 85 B2
        dec     gameMode                        ; 8386 C6 C0
        rts                                     ; 8388 60

; ----------------------------------------------------------------------------
@bNotPressed:
        ldy     #$00                            ; 8389 A0 00
        lda     gameType                        ; 838B A5 C1
        asl     a                               ; 838D 0A
        sta     generalCounter                  ; 838E 85 A8
        asl     a                               ; 8390 0A
        adc     generalCounter                  ; 8391 65 A8
        asl     a                               ; 8393 0A
        asl     a                               ; 8394 0A
        asl     a                               ; 8395 0A
        asl     a                               ; 8396 0A
        clc                                     ; 8397 18
        adc     #$3F                            ; 8398 69 3F
        sta     spriteXOffset                   ; 839A 85 A0
        lda     #$3F                            ; 839C A9 3F
        sta     spriteYOffset                   ; 839E 85 A1
        lda     #$01                            ; 83A0 A9 01
        sta     spriteIndexInOamContentLookup   ; 83A2 85 A2
        lda     frameCounter                    ; 83A4 A5 B1
        and     #$03                            ; 83A6 29 03
        bne     @flickerCursorPair1             ; 83A8 D0 04
        lda     #$02                            ; 83AA A9 02
        sta     spriteIndexInOamContentLookup   ; 83AC 85 A2
@flickerCursorPair1:
        jsr     loadSpriteIntoOamStaging        ; 83AE 20 27 8C
        lda     musicType                       ; 83B1 A5 C2
        asl     a                               ; 83B3 0A
        asl     a                               ; 83B4 0A
        asl     a                               ; 83B5 0A
        asl     a                               ; 83B6 0A
        clc                                     ; 83B7 18
        adc     #$8F                            ; 83B8 69 8F
        sta     spriteYOffset                   ; 83BA 85 A1
        lda     #$53                            ; 83BC A9 53
        sta     spriteIndexInOamContentLookup   ; 83BE 85 A2
        lda     #$67                            ; 83C0 A9 67
        sta     spriteXOffset                   ; 83C2 85 A0
        lda     frameCounter                    ; 83C4 A5 B1
        and     #$03                            ; 83C6 29 03
        bne     @flickerCursorPair2             ; 83C8 D0 04
        lda     #$02                            ; 83CA A9 02
        sta     spriteIndexInOamContentLookup   ; 83CC 85 A2
@flickerCursorPair2:
        jsr     loadSpriteIntoOamStaging        ; 83CE 20 27 8C
        jsr     updateAudioWaitForNmiAndResetOamStaging; 83D1 20 2F AA
        jmp     @handleInput                    ; 83D4 4C 0B 83

; ----------------------------------------------------------------------------
gameMode_levelMenu:
        inc     initRam                         ; 83D7 EE 00 80
        lda     #$10                            ; 83DA A9 10
        jsr     setMMC1Control                  ; 83DC 20 A3 AC
        jsr     updateAudio2                    ; 83DF 20 03 E0
        lda     #$01                            ; 83E2 A9 01
        sta     renderMode                      ; 83E4 85 BD
        jsr     updateAudioWaitForNmiAndDisablePpuRendering; 83E6 20 52 AA
        jsr     disableNmi                      ; 83E9 20 78 AA
        lda     #$00                            ; 83EC A9 00
        jsr     changeCHRBank0                  ; 83EE 20 B7 AC
        lda     #$00                            ; 83F1 A9 00
        jsr     changeCHRBank1                  ; 83F3 20 CB AC
        jsr     bulkCopyToPpu                   ; 83F6 20 98 AA
        .addr   menu_palette                    ; 83F9 2B AD
; ----------------------------------------------------------------------------
        jsr     bulkCopyToPpu                   ; 83FB 20 98 AA
        .addr   level_menu_nametable            ; 83FE DB BA
; ----------------------------------------------------------------------------
        lda     gameType                        ; 8400 A5 C1
        bne     @skipTypeBHeightDisplay         ; 8402 D0 05
        jsr     bulkCopyToPpu                   ; 8404 20 98 AA
        .addr   height_menu_nametablepalette_patch; 8407 5D C9
; ----------------------------------------------------------------------------
@skipTypeBHeightDisplay:
        jsr     showHighScores                  ; 8409 20 F2 9F
        jsr     waitForVBlankAndEnableNmi       ; 840C 20 6B AA
        jsr     updateAudioWaitForNmiAndResetOamStaging; 840F 20 2F AA
        lda     #$00                            ; 8412 A9 00
        sta     PPUSCROLL                       ; 8414 8D 05 20
        lda     #$00                            ; 8417 A9 00
        sta     PPUSCROLL                       ; 8419 8D 05 20
        jsr     updateAudioWaitForNmiAndEnablePpuRendering; 841C 20 5F AA
        jsr     updateAudioWaitForNmiAndResetOamStaging; 841F 20 2F AA
        lda     #$00                            ; 8422 A9 00
        sta     originalY                       ; 8424 85 AE
        sta     dropSpeed                       ; 8426 85 AF
@forceStartLevelToRange:
        lda     player1_startLevel              ; 8428 A5 67
        cmp     #$0A                            ; 842A C9 0A
        bcc     gameMode_levelMenu_processPlayer1Navigation; 842C 90 08
        sec                                     ; 842E 38
        sbc     #$0A                            ; 842F E9 0A
        sta     player1_startLevel              ; 8431 85 67
        jmp     @forceStartLevelToRange         ; 8433 4C 28 84

; ----------------------------------------------------------------------------
gameMode_levelMenu_processPlayer1Navigation:
        lda     #$00                            ; 8436 A9 00
        sta     activePlayer                    ; 8438 85 B7
        lda     player1_startLevel              ; 843A A5 67
        sta     startLevel                      ; 843C 85 47
        lda     player1_startHeight             ; 843E A5 79
        sta     startHeight                     ; 8440 85 59
        lda     originalY                       ; 8442 A5 AE
        sta     selectingLevelOrHeight          ; 8444 85 AD
        lda     newlyPressedButtons_player1     ; 8446 A5 F5
        sta     newlyPressedButtons             ; 8448 85 B5
        jsr     gameMode_levelMenu_handleLevelHeightNavigation; 844A 20 AE 84
        lda     startLevel                      ; 844D A5 47
        sta     player1_startLevel              ; 844F 85 67
        lda     startHeight                     ; 8451 A5 59
        sta     player1_startHeight             ; 8453 85 79
        lda     selectingLevelOrHeight          ; 8455 A5 AD
        sta     originalY                       ; 8457 85 AE
        lda     newlyPressedButtons_player1     ; 8459 A5 F5
        cmp     #$10                            ; 845B C9 10
        bne     @checkBPressed                  ; 845D D0 19
        lda     heldButtons_player1             ; 845F A5 F7
        cmp     #$90                            ; 8461 C9 90
        bne     @startAndANotPressed            ; 8463 D0 07
        lda     player1_startLevel              ; 8465 A5 67
        clc                                     ; 8467 18
        adc     #$0A                            ; 8468 69 0A
        sta     player1_startLevel              ; 846A 85 67
@startAndANotPressed:
        lda     #$00                            ; 846C A9 00
        sta     gameModeState                   ; 846E 85 A7
        lda     #$02                            ; 8470 A9 02
        sta     soundEffectSlot1Init            ; 8472 8D F1 06
        inc     gameMode                        ; 8475 E6 C0
        rts                                     ; 8477 60

; ----------------------------------------------------------------------------
@checkBPressed:
        lda     newlyPressedButtons_player1     ; 8478 A5 F5
        cmp     #$40                            ; 847A C9 40
        bne     @chooseRandomHole_player1       ; 847C D0 08
        lda     #$02                            ; 847E A9 02
        sta     soundEffectSlot1Init            ; 8480 8D F1 06
        dec     gameMode                        ; 8483 C6 C0
        rts                                     ; 8485 60

; ----------------------------------------------------------------------------
@chooseRandomHole_player1:
        ldx     #$17                            ; 8486 A2 17
        ldy     #$02                            ; 8488 A0 02
        jsr     generateNextPseudorandomNumber  ; 848A 20 47 AB
        lda     rng_seed                        ; 848D A5 17
        and     #$0F                            ; 848F 29 0F
        cmp     #$0A                            ; 8491 C9 0A
        bpl     @chooseRandomHole_player1       ; 8493 10 F1
        sta     player1_garbageHole             ; 8495 85 7A
@chooseRandomHole_player2:
        ldx     #$17                            ; 8497 A2 17
        ldy     #$02                            ; 8499 A0 02
        jsr     generateNextPseudorandomNumber  ; 849B 20 47 AB
        lda     rng_seed                        ; 849E A5 17
        and     #$0F                            ; 84A0 29 0F
        cmp     #$0A                            ; 84A2 C9 0A
        bpl     @chooseRandomHole_player2       ; 84A4 10 F1
        sta     player2_garbageHole             ; 84A6 85 9A
        jsr     updateAudioWaitForNmiAndResetOamStaging; 84A8 20 2F AA
        jmp     gameMode_levelMenu_processPlayer1Navigation; 84AB 4C 36 84

; ----------------------------------------------------------------------------
; Starts by checking if right pressed
gameMode_levelMenu_handleLevelHeightNavigation:
        lda     newlyPressedButtons             ; 84AE A5 B5
        cmp     #$01                            ; 84B0 C9 01
        bne     @checkLeftPressed               ; 84B2 D0 1C
        lda     #$01                            ; 84B4 A9 01
        sta     soundEffectSlot1Init            ; 84B6 8D F1 06
        lda     selectingLevelOrHeight          ; 84B9 A5 AD
        bne     @rightPressedForHeightSelection ; 84BB D0 0B
        lda     startLevel                      ; 84BD A5 47
        cmp     #$09                            ; 84BF C9 09
        beq     @checkLeftPressed               ; 84C1 F0 0D
        inc     startLevel                      ; 84C3 E6 47
        jmp     @checkLeftPressed               ; 84C5 4C D0 84

; ----------------------------------------------------------------------------
@rightPressedForHeightSelection:
        lda     startHeight                     ; 84C8 A5 59
        cmp     #$05                            ; 84CA C9 05
        beq     @checkLeftPressed               ; 84CC F0 02
        inc     startHeight                     ; 84CE E6 59
@checkLeftPressed:
        lda     newlyPressedButtons             ; 84D0 A5 B5
        cmp     #$02                            ; 84D2 C9 02
        bne     @checkDownPressed               ; 84D4 D0 18
        lda     #$01                            ; 84D6 A9 01
        sta     soundEffectSlot1Init            ; 84D8 8D F1 06
        lda     selectingLevelOrHeight          ; 84DB A5 AD
        bne     @leftPressedForHeightSelection  ; 84DD D0 09
        lda     startLevel                      ; 84DF A5 47
        beq     @checkDownPressed               ; 84E1 F0 0B
        dec     startLevel                      ; 84E3 C6 47
        jmp     @checkDownPressed               ; 84E5 4C EE 84

; ----------------------------------------------------------------------------
@leftPressedForHeightSelection:
        lda     startHeight                     ; 84E8 A5 59
        beq     @checkDownPressed               ; 84EA F0 02
        dec     startHeight                     ; 84EC C6 59
@checkDownPressed:
        lda     newlyPressedButtons             ; 84EE A5 B5
        cmp     #$04                            ; 84F0 C9 04
        bne     @checkUpPressed                 ; 84F2 D0 23
        lda     #$01                            ; 84F4 A9 01
        sta     soundEffectSlot1Init            ; 84F6 8D F1 06
        lda     selectingLevelOrHeight          ; 84F9 A5 AD
        bne     @downPressedForHeightSelection  ; 84FB D0 0E
        lda     startLevel                      ; 84FD A5 47
        cmp     #$05                            ; 84FF C9 05
        bpl     @checkUpPressed                 ; 8501 10 14
        clc                                     ; 8503 18
        adc     #$05                            ; 8504 69 05
        sta     startLevel                      ; 8506 85 47
        jmp     @checkUpPressed                 ; 8508 4C 17 85

; ----------------------------------------------------------------------------
@downPressedForHeightSelection:
        lda     startHeight                     ; 850B A5 59
        cmp     #$03                            ; 850D C9 03
        bpl     @checkUpPressed                 ; 850F 10 06
        inc     startHeight                     ; 8511 E6 59
        inc     startHeight                     ; 8513 E6 59
        inc     startHeight                     ; 8515 E6 59
@checkUpPressed:
        lda     newlyPressedButtons             ; 8517 A5 B5
        cmp     #$08                            ; 8519 C9 08
        bne     @checkAPressed                  ; 851B D0 23
        lda     #$01                            ; 851D A9 01
        sta     soundEffectSlot1Init            ; 851F 8D F1 06
        lda     selectingLevelOrHeight          ; 8522 A5 AD
        bne     @upPressedForHeightSelection    ; 8524 D0 0E
        lda     startLevel                      ; 8526 A5 47
        cmp     #$05                            ; 8528 C9 05
        bmi     @checkAPressed                  ; 852A 30 14
        sec                                     ; 852C 38
        sbc     #$05                            ; 852D E9 05
        sta     startLevel                      ; 852F 85 47
        jmp     @checkAPressed                  ; 8531 4C 40 85

; ----------------------------------------------------------------------------
@upPressedForHeightSelection:
        lda     startHeight                     ; 8534 A5 59
        cmp     #$03                            ; 8536 C9 03
        bmi     @checkAPressed                  ; 8538 30 06
        dec     startHeight                     ; 853A C6 59
        dec     startHeight                     ; 853C C6 59
        dec     startHeight                     ; 853E C6 59
@checkAPressed:
        lda     gameType                        ; 8540 A5 C1
        beq     @showSelection                  ; 8542 F0 11
        lda     newlyPressedButtons             ; 8544 A5 B5
        cmp     #$80                            ; 8546 C9 80
        bne     @showSelection                  ; 8548 D0 0B
        lda     #$01                            ; 854A A9 01
        sta     soundEffectSlot1Init            ; 854C 8D F1 06
        lda     selectingLevelOrHeight          ; 854F A5 AD
        eor     #$01                            ; 8551 49 01
        sta     selectingLevelOrHeight          ; 8553 85 AD
@showSelection:
        lda     selectingLevelOrHeight          ; 8555 A5 AD
        bne     @showSelectionLevel             ; 8557 D0 06
        lda     frameCounter                    ; 8559 A5 B1
        and     #$03                            ; 855B 29 03
        beq     @skipShowingSelectionLevel      ; 855D F0 22
@showSelectionLevel:
        ldx     startLevel                      ; 855F A6 47
        lda     levelToSpriteYOffset,x          ; 8561 BD B2 85
        sta     spriteYOffset                   ; 8564 85 A1
        lda     #$00                            ; 8566 A9 00
        sta     spriteIndexInOamContentLookup   ; 8568 85 A2
        ldx     startLevel                      ; 856A A6 47
        lda     levelToSpriteXOffset,x          ; 856C BD BC 85
        sta     spriteXOffset                   ; 856F 85 A0
        lda     activePlayer                    ; 8571 A5 B7
        cmp     #$01                            ; 8573 C9 01
        bne     @stageLevelSelectCursor         ; 8575 D0 07
        clc                                     ; 8577 18
        lda     spriteYOffset                   ; 8578 A5 A1
        adc     #$50                            ; 857A 69 50
        sta     spriteYOffset                   ; 857C 85 A1
@stageLevelSelectCursor:
        jsr     loadSpriteIntoOamStaging        ; 857E 20 27 8C
@skipShowingSelectionLevel:
        lda     gameType                        ; 8581 A5 C1
        beq     @ret                            ; 8583 F0 2C
        lda     selectingLevelOrHeight          ; 8585 A5 AD
        beq     @showSelectionHeight            ; 8587 F0 06
        lda     frameCounter                    ; 8589 A5 B1
        and     #$03                            ; 858B 29 03
        beq     @ret                            ; 858D F0 22
@showSelectionHeight:
        ldx     startHeight                     ; 858F A6 59
        lda     heightToPpuHighAddr,x           ; 8591 BD C6 85
        sta     spriteYOffset                   ; 8594 85 A1
        lda     #$00                            ; 8596 A9 00
        sta     spriteIndexInOamContentLookup   ; 8598 85 A2
        ldx     startHeight                     ; 859A A6 59
        lda     heightToPpuLowAddr,x            ; 859C BD CC 85
        sta     spriteXOffset                   ; 859F 85 A0
        lda     activePlayer                    ; 85A1 A5 B7
        cmp     #$01                            ; 85A3 C9 01
        bne     @stageHeightSelectCursor        ; 85A5 D0 07
        clc                                     ; 85A7 18
        lda     spriteYOffset                   ; 85A8 A5 A1
        adc     #$50                            ; 85AA 69 50
        sta     spriteYOffset                   ; 85AC 85 A1
@stageHeightSelectCursor:
        jsr     loadSpriteIntoOamStaging        ; 85AE 20 27 8C
@ret:   rts                                     ; 85B1 60

; ----------------------------------------------------------------------------
levelToSpriteYOffset:
        .byte   $53,$53,$53,$53,$53,$63,$63,$63 ; 85B2 53 53 53 53 53 63 63 63
        .byte   $63,$63                         ; 85BA 63 63
levelToSpriteXOffset:
        .byte   $34,$44,$54,$64,$74,$34,$44,$54 ; 85BC 34 44 54 64 74 34 44 54
        .byte   $64,$74                         ; 85C4 64 74
heightToPpuHighAddr:
        .byte   $53,$53,$53,$63,$63,$63         ; 85C6 53 53 53 63 63 63
heightToPpuLowAddr:
        .byte   $9C,$AC,$BC,$9C,$AC,$BC         ; 85CC 9C AC BC 9C AC BC
musicSelectionTable:
        .byte   $03,$04,$05,$FF,$06,$07,$08,$FF ; 85D2 03 04 05 FF 06 07 08 FF
; ----------------------------------------------------------------------------
render_mode_menu_screens:
        lda     currentPpuCtrl                  ; 85DA A5 FF
        and     #$FC                            ; 85DC 29 FC
        sta     currentPpuCtrl                  ; 85DE 85 FF
        sta     PPUCTRL                         ; 85E0 8D 00 20
        lda     #$00                            ; 85E3 A9 00
        sta     ppuScrollX                      ; 85E5 85 FD
        sta     PPUSCROLL                       ; 85E7 8D 05 20
        sta     ppuScrollY                      ; 85EA 85 FC
        sta     PPUSCROLL                       ; 85EC 8D 05 20
        rts                                     ; 85EF 60

; ----------------------------------------------------------------------------
gameModeState_initGameBackground:
        jsr     updateAudioWaitForNmiAndDisablePpuRendering; 85F0 20 52 AA
        jsr     disableNmi                      ; 85F3 20 78 AA
        lda     #$03                            ; 85F6 A9 03
        jsr     changeCHRBank0                  ; 85F8 20 B7 AC
        lda     #$03                            ; 85FB A9 03
        jsr     changeCHRBank1                  ; 85FD 20 CB AC
        jsr     bulkCopyToPpu                   ; 8600 20 98 AA
        .addr   game_palette                    ; 8603 F3 AC
; ----------------------------------------------------------------------------
        jsr     bulkCopyToPpu                   ; 8605 20 98 AA
        .addr   game_nametable                  ; 8608 3C BF
; ----------------------------------------------------------------------------
        lda     #$20                            ; 860A A9 20
        sta     PPUADDR                         ; 860C 8D 06 20
        lda     #$83                            ; 860F A9 83
        sta     PPUADDR                         ; 8611 8D 06 20
        lda     gameType                        ; 8614 A5 C1
        bne     @typeB                          ; 8616 D0 24
        lda     #$0A                            ; 8618 A9 0A
        sta     PPUDATA                         ; 861A 8D 07 20
        lda     #$20                            ; 861D A9 20
        sta     PPUADDR                         ; 861F 8D 06 20
        lda     #$B8                            ; 8622 A9 B8
        sta     PPUADDR                         ; 8624 8D 06 20
        lda     highScoreScoresA                ; 8627 AD 30 07
        jsr     twoDigsToPPU                    ; 862A 20 12 97
        lda     highScoreScoresA+1              ; 862D AD 31 07
        jsr     twoDigsToPPU                    ; 8630 20 12 97
        lda     highScoreScoresA+2              ; 8633 AD 32 07
        jsr     twoDigsToPPU                    ; 8636 20 12 97
        jmp     gameModeState_initGameBackground_finish; 8639 4C 93 86

; ----------------------------------------------------------------------------
@typeB: lda     #$0B                            ; 863C A9 0B
        sta     PPUDATA                         ; 863E 8D 07 20
        lda     #$20                            ; 8641 A9 20
        sta     PPUADDR                         ; 8643 8D 06 20
        lda     #$B8                            ; 8646 A9 B8
        sta     PPUADDR                         ; 8648 8D 06 20
        lda     highScoreScoresB                ; 864B AD 3C 07
        jsr     twoDigsToPPU                    ; 864E 20 12 97
        lda     highScoreScoresB+1              ; 8651 AD 3D 07
        jsr     twoDigsToPPU                    ; 8654 20 12 97
        lda     highScoreScoresB+2              ; 8657 AD 3E 07
        jsr     twoDigsToPPU                    ; 865A 20 12 97
        ldx     #$00                            ; 865D A2 00
@nextPpuAddress:
        lda     game_typeb_nametable_patch,x    ; 865F BD B0 86
        inx                                     ; 8662 E8
        sta     PPUADDR                         ; 8663 8D 06 20
        lda     game_typeb_nametable_patch,x    ; 8666 BD B0 86
        inx                                     ; 8669 E8
        sta     PPUADDR                         ; 866A 8D 06 20
@nextPpuData:
        lda     game_typeb_nametable_patch,x    ; 866D BD B0 86
        inx                                     ; 8670 E8
        cmp     #$FE                            ; 8671 C9 FE
        beq     @nextPpuAddress                 ; 8673 F0 EA
        cmp     #$FD                            ; 8675 C9 FD
        beq     @endOfPpuPatching               ; 8677 F0 06
        sta     PPUDATA                         ; 8679 8D 07 20
        jmp     @nextPpuData                    ; 867C 4C 6D 86

; ----------------------------------------------------------------------------
@endOfPpuPatching:
        lda     #$23                            ; 867F A9 23
        sta     PPUADDR                         ; 8681 8D 06 20
        lda     #$3B                            ; 8684 A9 3B
        sta     PPUADDR                         ; 8686 8D 06 20
        lda     startHeight                     ; 8689 A5 59
        and     #$0F                            ; 868B 29 0F
        sta     PPUDATA                         ; 868D 8D 07 20
        jmp     gameModeState_initGameBackground_finish; 8690 4C 93 86

; ----------------------------------------------------------------------------
gameModeState_initGameBackground_finish:
        jsr     waitForVBlankAndEnableNmi       ; 8693 20 6B AA
        jsr     updateAudioWaitForNmiAndResetOamStaging; 8696 20 2F AA
        jsr     updateAudioWaitForNmiAndEnablePpuRendering; 8699 20 5F AA
        jsr     updateAudioWaitForNmiAndResetOamStaging; 869C 20 2F AA
        lda     #$01                            ; 869F A9 01
        sta     player1_playState               ; 86A1 85 68
        sta     player2_playState               ; 86A3 85 88
        lda     player1_startLevel              ; 86A5 A5 67
        sta     player1_levelNumber             ; 86A7 85 64
        lda     player2_startLevel              ; 86A9 A5 87
        sta     player2_levelNumber             ; 86AB 85 84
        inc     gameModeState                   ; 86AD E6 A7
        rts                                     ; 86AF 60

; ----------------------------------------------------------------------------
game_typeb_nametable_patch:
        .byte   $22,$F7,$38,$39,$39,$39,$39,$39 ; 86B0 22 F7 38 39 39 39 39 39
        .byte   $39,$3A,$FE,$23,$17,$3B,$11,$0E ; 86B8 39 3A FE 23 17 3B 11 0E
        .byte   $12,$10,$11,$1D,$3C,$FE,$23,$37 ; 86C0 12 10 11 1D 3C FE 23 37
        .byte   $3B,$FF,$FF,$FF,$FF,$FF,$FF,$3C ; 86C8 3B FF FF FF FF FF FF 3C
        .byte   $FE,$23,$57,$3D,$3E,$3E,$3E,$3E ; 86D0 FE 23 57 3D 3E 3E 3E 3E
        .byte   $3E,$3E,$3F,$FD                 ; 86D8 3E 3E 3F FD
; ----------------------------------------------------------------------------
gameModeState_initGameState:
        lda     #$EF                            ; 86DC A9 EF
        ldx     #$04                            ; 86DE A2 04
        ldy     #$04                            ; 86E0 A0 04
        jsr     memset_page                     ; 86E2 20 6A AC
        ldx     #$0F                            ; 86E5 A2 0F
        lda     #$00                            ; 86E7 A9 00
; statsByType
@initStatsByType:
        sta     $03EF,x                         ; 86E9 9D EF 03
        dex                                     ; 86EC CA
        bne     @initStatsByType                ; 86ED D0 FA
        lda     #$05                            ; 86EF A9 05
        sta     player1_tetriminoX              ; 86F1 85 60
        sta     player2_tetriminoX              ; 86F3 85 80
        lda     #$00                            ; 86F5 A9 00
        sta     player1_tetriminoY              ; 86F7 85 61
        sta     player2_tetriminoY              ; 86F9 85 81
        sta     player1_vramRow                 ; 86FB 85 69
        sta     player2_vramRow                 ; 86FD 85 89
        sta     player1_fallTimer               ; 86FF 85 65
        sta     player2_fallTimer               ; 8701 85 85
        sta     pendingGarbage                  ; 8703 85 BB
        sta     pendingGarbageInactivePlayer    ; 8705 85 BC
        sta     player1_score                   ; 8707 85 73
        sta     player1_score+1                 ; 8709 85 74
        sta     player1_score+2                 ; 870B 85 75
        sta     player2_score                   ; 870D 85 93
        sta     player2_score+1                 ; 870F 85 94
        sta     player2_score+2                 ; 8711 85 95
        sta     player1_lines                   ; 8713 85 70
        sta     player1_lines+1                 ; 8715 85 71
        sta     player2_lines                   ; 8717 85 90
        sta     player2_lines+1                 ; 8719 85 91
        sta     twoPlayerPieceDelayCounter      ; 871B 85 A4
        sta     lineClearStatsByType            ; 871D 85 D8
        sta     lineClearStatsByType+1          ; 871F 85 D9
        sta     lineClearStatsByType+2          ; 8721 85 DA
        sta     lineClearStatsByType+3          ; 8723 85 DB
        sta     allegro                         ; 8725 85 BA
        sta     demo_heldButtons                ; 8727 85 CE
        sta     demo_repeats                    ; 8729 85 CF
        sta     demoIndex                       ; 872B 85 D3
        sta     demoButtonsAddr                 ; 872D 85 D1
        sta     spawnID                         ; 872F 85 19
        lda     #$DD                            ; 8731 A9 DD
        sta     demoButtonsAddr+1               ; 8733 85 D2
        lda     #$03                            ; 8735 A9 03
        sta     renderMode                      ; 8737 85 BD
        lda     #$A0                            ; 8739 A9 A0
        sta     player1_autorepeatY             ; 873B 85 6E
        sta     player2_autorepeatY             ; 873D 85 8E
        jsr     chooseNextTetrimino             ; 873F 20 EB 98
        sta     player1_currentPiece            ; 8742 85 62
        sta     player2_currentPiece            ; 8744 85 82
        jsr     incrementPieceStat              ; 8746 20 69 99
        ldx     #$17                            ; 8749 A2 17
        ldy     #$02                            ; 874B A0 02
        jsr     generateNextPseudorandomNumber  ; 874D 20 47 AB
        jsr     chooseNextTetrimino             ; 8750 20 EB 98
        sta     nextPiece                       ; 8753 85 BF
        sta     twoPlayerPieceDelayPiece        ; 8755 85 A6
        lda     gameType                        ; 8757 A5 C1
        beq     @skipTypeBInit                  ; 8759 F0 06
        lda     #$25                            ; 875B A9 25
        sta     player1_lines                   ; 875D 85 70
        sta     player2_lines                   ; 875F 85 90
@skipTypeBInit:
        lda     #$47                            ; 8761 A9 47
        sta     outOfDateRenderFlags            ; 8763 85 A3
        jsr     updateAudioWaitForNmiAndResetOamStaging; 8765 20 2F AA
        jsr     initPlayfieldIfTypeB            ; 8768 20 DC 87
        ldx     musicType                       ; 876B A6 C2
        lda     musicSelectionTable,x           ; 876D BD D2 85
        jsr     setMusicTrack                   ; 8770 20 07 9E
        inc     gameModeState                   ; 8773 E6 A7
        rts                                     ; 8775 60

; ----------------------------------------------------------------------------
; Copies $60 to $40
makePlayer1Active:
        lda     #$01                            ; 8776 A9 01
        sta     activePlayer                    ; 8778 85 B7
        lda     #$04                            ; 877A A9 04
        sta     playfieldAddr+1                 ; 877C 85 B9
        lda     newlyPressedButtons_player1     ; 877E A5 F5
        sta     newlyPressedButtons             ; 8780 85 B5
        lda     heldButtons_player1             ; 8782 A5 F7
        sta     heldButtons                     ; 8784 85 B6
        ldx     #$1F                            ; 8786 A2 1F
@copyByteFromMirror:
        lda     player1_tetriminoX,x            ; 8788 B5 60
        sta     tetriminoX,x                    ; 878A 95 40
        dex                                     ; 878C CA
        cpx     #$FF                            ; 878D E0 FF
        bne     @copyByteFromMirror             ; 878F D0 F7
        rts                                     ; 8791 60

; ----------------------------------------------------------------------------
; Copies $80 to $40
makePlayer2Active:
        lda     #$02                            ; 8792 A9 02
        sta     activePlayer                    ; 8794 85 B7
        lda     #$05                            ; 8796 A9 05
        sta     playfieldAddr+1                 ; 8798 85 B9
        lda     newlyPressedButtons_player2     ; 879A A5 F6
        sta     newlyPressedButtons             ; 879C 85 B5
        lda     heldButtons_player2             ; 879E A5 F8
        sta     heldButtons                     ; 87A0 85 B6
        ldx     #$1F                            ; 87A2 A2 1F
@whileXNotNeg1:
        lda     player2_tetriminoX,x            ; 87A4 B5 80
        sta     tetriminoX,x                    ; 87A6 95 40
        dex                                     ; 87A8 CA
        cpx     #$FF                            ; 87A9 E0 FF
        bne     @whileXNotNeg1                  ; 87AB D0 F7
        rts                                     ; 87AD 60

; ----------------------------------------------------------------------------
; Copies $40 to $60
savePlayer1State:
        ldx     #$1F                            ; 87AE A2 1F
@copyByteToMirror:
        lda     tetriminoX,x                    ; 87B0 B5 40
        sta     player1_tetriminoX,x            ; 87B2 95 60
        dex                                     ; 87B4 CA
        cpx     #$FF                            ; 87B5 E0 FF
        bne     @copyByteToMirror               ; 87B7 D0 F7
        lda     numberOfPlayers                 ; 87B9 A5 BE
        cmp     #$01                            ; 87BB C9 01
        beq     @ret                            ; 87BD F0 08
        ldx     pendingGarbage                  ; 87BF A6 BB
        lda     pendingGarbageInactivePlayer    ; 87C1 A5 BC
        sta     pendingGarbage                  ; 87C3 85 BB
        stx     pendingGarbageInactivePlayer    ; 87C5 86 BC
@ret:   rts                                     ; 87C7 60

; ----------------------------------------------------------------------------
; Copies $40 to $80
savePlayer2State:
        ldx     #$1F                            ; 87C8 A2 1F
@whileXNotNeg1:
        lda     tetriminoX,x                    ; 87CA B5 40
        sta     player2_tetriminoX,x            ; 87CC 95 80
        dex                                     ; 87CE CA
        cpx     #$FF                            ; 87CF E0 FF
        bne     @whileXNotNeg1                  ; 87D1 D0 F7
        ldx     pendingGarbage                  ; 87D3 A6 BB
        lda     pendingGarbageInactivePlayer    ; 87D5 A5 BC
        sta     pendingGarbage                  ; 87D7 85 BB
        stx     pendingGarbageInactivePlayer    ; 87D9 86 BC
        rts                                     ; 87DB 60

; ----------------------------------------------------------------------------
initPlayfieldIfTypeB:
        lda     gameType                        ; 87DC A5 C1
        bne     @initPlayfieldForTypeB          ; 87DE D0 03
        jmp     @ret                            ; 87E0 4C 75 88

; ----------------------------------------------------------------------------
@initPlayfieldForTypeB:
        lda     #$0C                            ; 87E3 A9 0C
        sta     generalCounter                  ; 87E5 85 A8
@randomizeRow:
        lda     generalCounter                  ; 87E7 A5 A8
        beq     @randomDone                     ; 87E9 F0 5F
        lda     #$14                            ; 87EB A9 14
        sec                                     ; 87ED 38
        sbc     generalCounter                  ; 87EE E5 A8
        sta     generalCounter2                 ; 87F0 85 A9
        lda     #$00                            ; 87F2 A9 00
        sta     player1_vramRow                 ; 87F4 85 69
        sta     player2_vramRow                 ; 87F6 85 89
        lda     #$09                            ; 87F8 A9 09
        sta     generalCounter3                 ; 87FA 85 AA
@setRandomBlock:
        ldx     #$17                            ; 87FC A2 17
        ldy     #$02                            ; 87FE A0 02
        jsr     generateNextPseudorandomNumber  ; 8800 20 47 AB
        lda     rng_seed                        ; 8803 A5 17
        and     #$07                            ; 8805 29 07
        tay                                     ; 8807 A8
        lda     rngTable,y                      ; 8808 B9 7C 88
        sta     generalCounter4                 ; 880B 85 AB
        ldx     generalCounter2                 ; 880D A6 A9
        lda     multBy10Table,x                 ; 880F BD D6 96
        clc                                     ; 8812 18
        adc     generalCounter3                 ; 8813 65 AA
        tay                                     ; 8815 A8
        lda     generalCounter4                 ; 8816 A5 AB
        sta     playfield,y                     ; 8818 99 00 04
        lda     generalCounter3                 ; 881B A5 AA
        beq     @emptyRandomBlock               ; 881D F0 05
        dec     generalCounter3                 ; 881F C6 AA
        jmp     @setRandomBlock                 ; 8821 4C FC 87

; ----------------------------------------------------------------------------
@emptyRandomBlock:
        ldx     #$17                            ; 8824 A2 17
        ldy     #$02                            ; 8826 A0 02
        jsr     generateNextPseudorandomNumber  ; 8828 20 47 AB
        lda     rng_seed                        ; 882B A5 17
        and     #$0F                            ; 882D 29 0F
        cmp     #$0A                            ; 882F C9 0A
        bpl     @emptyRandomBlock               ; 8831 10 F1
        sta     generalCounter5                 ; 8833 85 AC
        ldx     generalCounter2                 ; 8835 A6 A9
        lda     multBy10Table,x                 ; 8837 BD D6 96
        clc                                     ; 883A 18
        adc     generalCounter5                 ; 883B 65 AC
        tay                                     ; 883D A8
        lda     #$EF                            ; 883E A9 EF
        sta     playfield,y                     ; 8840 99 00 04
        jsr     updateAudioWaitForNmiAndResetOamStaging; 8843 20 2F AA
        dec     generalCounter                  ; 8846 C6 A8
        bne     @randomizeRow                   ; 8848 D0 9D
@randomDone:
        ldx     #$C8                            ; 884A A2 C8
@copyPlayfieldToPlayer2:
        lda     playfield,x                     ; 884C BD 00 04
        sta     playfieldForSecondPlayer,x      ; 884F 9D 00 05
        dex                                     ; 8852 CA
        bne     @copyPlayfieldToPlayer2         ; 8853 D0 F7
        ldx     player1_startHeight             ; 8855 A6 79
        lda     typeBBlankInitCountByHeightTable,x; 8857 BD 76 88
        tay                                     ; 885A A8
        lda     #$EF                            ; 885B A9 EF
@emptyAboveHeight_player1:
        sta     playfield,y                     ; 885D 99 00 04
        dey                                     ; 8860 88
        cpy     #$FF                            ; 8861 C0 FF
        bne     @emptyAboveHeight_player1       ; 8863 D0 F8
        ldx     player2_startHeight             ; 8865 A6 99
        lda     typeBBlankInitCountByHeightTable,x; 8867 BD 76 88
        tay                                     ; 886A A8
        lda     #$EF                            ; 886B A9 EF
@emptyAboveHeight_player2:
        sta     playfieldForSecondPlayer,y      ; 886D 99 00 05
        dey                                     ; 8870 88
        cpy     #$FF                            ; 8871 C0 FF
        bne     @emptyAboveHeight_player2       ; 8873 D0 F8
@ret:   rts                                     ; 8875 60

; ----------------------------------------------------------------------------
typeBBlankInitCountByHeightTable:
        .byte   $C8,$AA,$96,$78,$64,$50         ; 8876 C8 AA 96 78 64 50
rngTable:
        .byte   $EF,$7B,$EF,$7C,$7D,$7D,$EF     ; 887C EF 7B EF 7C 7D 7D EF
; ----------------------------------------------------------------------------
        .byte   $EF                             ; 8883 EF
gameModeState_updateCountersAndNonPlayerState:
        lda     #$03                            ; 8884 A9 03
        jsr     changeCHRBank0                  ; 8886 20 B7 AC
        lda     #$03                            ; 8889 A9 03
        jsr     changeCHRBank1                  ; 888B 20 CB AC
        lda     #$00                            ; 888E A9 00
        sta     oamStagingLength                ; 8890 85 B3
        inc     player1_fallTimer               ; 8892 E6 65
        inc     player2_fallTimer               ; 8894 E6 85
        lda     twoPlayerPieceDelayCounter      ; 8896 A5 A4
        beq     @checkSelectButtonPressed       ; 8898 F0 02
        inc     twoPlayerPieceDelayCounter      ; 889A E6 A4
@checkSelectButtonPressed:
        lda     newlyPressedButtons_player1     ; 889C A5 F5
        and     #$20                            ; 889E 29 20
        beq     @ret                            ; 88A0 F0 06
        lda     displayNextPiece                ; 88A2 A5 DF
        eor     #$01                            ; 88A4 49 01
        sta     displayNextPiece                ; 88A6 85 DF
@ret:   inc     gameModeState                   ; 88A8 E6 A7
        rts                                     ; 88AA 60

; ----------------------------------------------------------------------------
rotate_tetrimino:
        lda     currentPiece                    ; 88AB A5 42
        sta     originalY                       ; 88AD 85 AE
        clc                                     ; 88AF 18
        lda     currentPiece                    ; 88B0 A5 42
        asl     a                               ; 88B2 0A
        tax                                     ; 88B3 AA
        lda     newlyPressedButtons             ; 88B4 A5 B5
        and     #$80                            ; 88B6 29 80
        cmp     #$80                            ; 88B8 C9 80
        bne     @aNotPressed                    ; 88BA D0 13
        inx                                     ; 88BC E8
        lda     rotationTable,x                 ; 88BD BD EE 88
        sta     currentPiece                    ; 88C0 85 42
        jsr     isPositionValid                 ; 88C2 20 8B 94
        bne     @restoreOrientationID           ; 88C5 D0 22
        lda     #$05                            ; 88C7 A9 05
        sta     soundEffectSlot1Init            ; 88C9 8D F1 06
        jmp     @ret                            ; 88CC 4C ED 88

; ----------------------------------------------------------------------------
@aNotPressed:
        lda     newlyPressedButtons             ; 88CF A5 B5
        and     #$40                            ; 88D1 29 40
        cmp     #$40                            ; 88D3 C9 40
        bne     @ret                            ; 88D5 D0 16
        lda     rotationTable,x                 ; 88D7 BD EE 88
        sta     currentPiece                    ; 88DA 85 42
        jsr     isPositionValid                 ; 88DC 20 8B 94
        bne     @restoreOrientationID           ; 88DF D0 08
        lda     #$05                            ; 88E1 A9 05
        sta     soundEffectSlot1Init            ; 88E3 8D F1 06
        jmp     @ret                            ; 88E6 4C ED 88

; ----------------------------------------------------------------------------
@restoreOrientationID:
        lda     originalY                       ; 88E9 A5 AE
        sta     currentPiece                    ; 88EB 85 42
@ret:   rts                                     ; 88ED 60

; ----------------------------------------------------------------------------
rotationTable:
        .dbyt   $0301,$0002,$0103,$0200         ; 88EE 03 01 00 02 01 03 02 00
        .dbyt   $0705,$0406,$0507,$0604         ; 88F6 07 05 04 06 05 07 06 04
        .dbyt   $0909,$0808,$0A0A,$0C0C         ; 88FE 09 09 08 08 0A 0A 0C 0C
        .dbyt   $0B0B,$100E,$0D0F,$0E10         ; 8906 0B 0B 10 0E 0D 0F 0E 10
        .dbyt   $0F0D,$1212,$1111               ; 890E 0F 0D 12 12 11 11
; ----------------------------------------------------------------------------
drop_tetrimino:
        lda     autorepeatY                     ; 8914 A5 4E
        bpl     @notBeginningOfGame             ; 8916 10 0A
        lda     newlyPressedButtons             ; 8918 A5 B5
        and     #$04                            ; 891A 29 04
        beq     @incrementAutorepeatY           ; 891C F0 6B
        lda     #$00                            ; 891E A9 00
        sta     autorepeatY                     ; 8920 85 4E
@notBeginningOfGame:
        bne     @autorepeating                  ; 8922 D0 15
@playing:
        lda     heldButtons                     ; 8924 A5 B6
        and     #$03                            ; 8926 29 03
        bne     @lookupDropSpeed                ; 8928 D0 49
        lda     newlyPressedButtons             ; 892A A5 B5
        and     #$0F                            ; 892C 29 0F
        cmp     #$04                            ; 892E C9 04
        bne     @lookupDropSpeed                ; 8930 D0 41
        lda     #$01                            ; 8932 A9 01
        sta     autorepeatY                     ; 8934 85 4E
        jmp     @lookupDropSpeed                ; 8936 4C 73 89

; ----------------------------------------------------------------------------
@autorepeating:
        lda     heldButtons                     ; 8939 A5 B6
        and     #$0F                            ; 893B 29 0F
        cmp     #$04                            ; 893D C9 04
        beq     @downPressed                    ; 893F F0 09
        lda     #$00                            ; 8941 A9 00
        sta     autorepeatY                     ; 8943 85 4E
        sta     holdDownPoints                  ; 8945 85 4F
        jmp     @lookupDropSpeed                ; 8947 4C 73 89

; ----------------------------------------------------------------------------
@downPressed:
        inc     autorepeatY                     ; 894A E6 4E
        lda     autorepeatY                     ; 894C A5 4E
        cmp     #$03                            ; 894E C9 03
        bcc     @lookupDropSpeed                ; 8950 90 21
        lda     #$01                            ; 8952 A9 01
        sta     autorepeatY                     ; 8954 85 4E
        inc     holdDownPoints                  ; 8956 E6 4F
@drop:  lda     #$00                            ; 8958 A9 00
        sta     fallTimer                       ; 895A 85 45
        lda     tetriminoY                      ; 895C A5 41
        sta     originalY                       ; 895E 85 AE
        inc     tetriminoY                      ; 8960 E6 41
        jsr     isPositionValid                 ; 8962 20 8B 94
        beq     @ret                            ; 8965 F0 0B
        lda     originalY                       ; 8967 A5 AE
        sta     tetriminoY                      ; 8969 85 41
        lda     #$02                            ; 896B A9 02
        sta     playState                       ; 896D 85 48
        jsr     updatePlayfield                 ; 896F 20 AF 9C
@ret:   rts                                     ; 8972 60

; ----------------------------------------------------------------------------
@lookupDropSpeed:
        lda     #$01                            ; 8973 A9 01
        ldx     levelNumber                     ; 8975 A6 44
        cpx     #$1D                            ; 8977 E0 1D
        bcs     @noTableLookup                  ; 8979 B0 03
        lda     framesPerDropTable,x            ; 897B BD 8E 89
@noTableLookup:
        sta     dropSpeed                       ; 897E 85 AF
        lda     fallTimer                       ; 8980 A5 45
        cmp     dropSpeed                       ; 8982 C5 AF
        bpl     @drop                           ; 8984 10 D2
        jmp     @ret                            ; 8986 4C 72 89

; ----------------------------------------------------------------------------
@incrementAutorepeatY:
        inc     autorepeatY                     ; 8989 E6 4E
        jmp     @ret                            ; 898B 4C 72 89

; ----------------------------------------------------------------------------
framesPerDropTable:
        .byte   $30,$2B,$26,$21,$1C,$17,$12,$0D ; 898E 30 2B 26 21 1C 17 12 0D
        .byte   $08,$06,$05,$05,$05,$04,$04,$04 ; 8996 08 06 05 05 05 04 04 04
        .byte   $03,$03,$03,$02,$02,$02,$02,$02 ; 899E 03 03 03 02 02 02 02 02
        .byte   $02,$02,$02,$02,$02,$01         ; 89A6 02 02 02 02 02 01
unreferenced_framesPerDropTable:
        .byte   $01,$01                         ; 89AC 01 01
; ----------------------------------------------------------------------------
shift_tetrimino:
        lda     tetriminoX                      ; 89AE A5 40
        sta     originalY                       ; 89B0 85 AE
        lda     heldButtons                     ; 89B2 A5 B6
        and     #$04                            ; 89B4 29 04
        bne     @ret                            ; 89B6 D0 51
        lda     newlyPressedButtons             ; 89B8 A5 B5
        and     #$03                            ; 89BA 29 03
        bne     @resetAutorepeatX               ; 89BC D0 15
        lda     heldButtons                     ; 89BE A5 B6
        and     #$03                            ; 89C0 29 03
        beq     @ret                            ; 89C2 F0 45
        inc     autorepeatX                     ; 89C4 E6 46
        lda     autorepeatX                     ; 89C6 A5 46
        cmp     #$10                            ; 89C8 C9 10
        bmi     @ret                            ; 89CA 30 3D
        lda     #$0A                            ; 89CC A9 0A
        sta     autorepeatX                     ; 89CE 85 46
        jmp     @buttonHeldDown                 ; 89D0 4C D7 89

; ----------------------------------------------------------------------------
@resetAutorepeatX:
        lda     #$00                            ; 89D3 A9 00
        sta     autorepeatX                     ; 89D5 85 46
@buttonHeldDown:
        lda     heldButtons                     ; 89D7 A5 B6
        and     #$01                            ; 89D9 29 01
        beq     @notPressingRight               ; 89DB F0 0F
        inc     tetriminoX                      ; 89DD E6 40
        jsr     isPositionValid                 ; 89DF 20 8B 94
        bne     @restoreX                       ; 89E2 D0 1D
        lda     #$03                            ; 89E4 A9 03
        sta     soundEffectSlot1Init            ; 89E6 8D F1 06
        jmp     @ret                            ; 89E9 4C 09 8A

; ----------------------------------------------------------------------------
@notPressingRight:
        lda     heldButtons                     ; 89EC A5 B6
        and     #$02                            ; 89EE 29 02
        beq     @ret                            ; 89F0 F0 17
        dec     tetriminoX                      ; 89F2 C6 40
        jsr     isPositionValid                 ; 89F4 20 8B 94
        bne     @restoreX                       ; 89F7 D0 08
        lda     #$03                            ; 89F9 A9 03
        sta     soundEffectSlot1Init            ; 89FB 8D F1 06
        jmp     @ret                            ; 89FE 4C 09 8A

; ----------------------------------------------------------------------------
@restoreX:
        lda     originalY                       ; 8A01 A5 AE
        sta     tetriminoX                      ; 8A03 85 40
        lda     #$10                            ; 8A05 A9 10
        sta     autorepeatX                     ; 8A07 85 46
@ret:   rts                                     ; 8A09 60

; ----------------------------------------------------------------------------
; temp memory usage: generalCounter3=tetrimino x pos
stageSpriteForCurrentPiece:
        lda     tetriminoX                      ; 8A0A A5 40
        asl     a                               ; 8A0C 0A
        asl     a                               ; 8A0D 0A
        asl     a                               ; 8A0E 0A
        adc     #$60                            ; 8A0F 69 60
        sta     generalCounter3                 ; 8A11 85 AA
        lda     numberOfPlayers                 ; 8A13 A5 BE
        cmp     #$01                            ; 8A15 C9 01
        beq     @calcYPos                       ; 8A17 F0 13
        lda     generalCounter3                 ; 8A19 A5 AA
        sec                                     ; 8A1B 38
        sbc     #$40                            ; 8A1C E9 40
        sta     generalCounter3                 ; 8A1E 85 AA
        lda     activePlayer                    ; 8A20 A5 B7
        cmp     #$01                            ; 8A22 C9 01
        beq     @calcYPos                       ; 8A24 F0 06
        lda     generalCounter3                 ; 8A26 A5 AA
        adc     #$6F                            ; 8A28 69 6F
        sta     generalCounter3                 ; 8A2A 85 AA
; generalCounter4=tetrimino y pos
@calcYPos:
        clc                                     ; 8A2C 18
        lda     tetriminoY                      ; 8A2D A5 41
        rol     a                               ; 8A2F 2A
        rol     a                               ; 8A30 2A
        rol     a                               ; 8A31 2A
        adc     #$2F                            ; 8A32 69 2F
        sta     generalCounter4                 ; 8A34 85 AB
; x=currentPiece*12
@calcOrientationTableOffset:
        lda     currentPiece                    ; 8A36 A5 42
        sta     generalCounter5                 ; 8A38 85 AC
        clc                                     ; 8A3A 18
        lda     generalCounter5                 ; 8A3B A5 AC
        rol     a                               ; 8A3D 2A
        rol     a                               ; 8A3E 2A
        sta     generalCounter                  ; 8A3F 85 A8
        rol     a                               ; 8A41 2A
        adc     generalCounter                  ; 8A42 65 A8
        tax                                     ; 8A44 AA
        ldy     oamStagingLength                ; 8A45 A4 B3
        lda     #$04                            ; 8A47 A9 04
        sta     generalCounter2                 ; 8A49 85 A9
@copySprite:
        lda     orientationTable,x              ; 8A4B BD 9C 8A
        asl     a                               ; 8A4E 0A
        asl     a                               ; 8A4F 0A
        asl     a                               ; 8A50 0A
        clc                                     ; 8A51 18
        adc     generalCounter4                 ; 8A52 65 AB
        sta     oamStaging,y                    ; 8A54 99 00 02
        sta     originalY                       ; 8A57 85 AE
        inc     oamStagingLength                ; 8A59 E6 B3
        iny                                     ; 8A5B C8
        inx                                     ; 8A5C E8
        lda     orientationTable,x              ; 8A5D BD 9C 8A
        sta     oamStaging,y                    ; 8A60 99 00 02
        inc     oamStagingLength                ; 8A63 E6 B3
        iny                                     ; 8A65 C8
        inx                                     ; 8A66 E8
        lda     #$02                            ; 8A67 A9 02
        sta     oamStaging,y                    ; 8A69 99 00 02
        lda     originalY                       ; 8A6C A5 AE
        cmp     #$2F                            ; 8A6E C9 2F
        bcs     @spriteShown                    ; 8A70 B0 12
        inc     oamStagingLength                ; 8A72 E6 B3
        dey                                     ; 8A74 88
        lda     #$FF                            ; 8A75 A9 FF
        sta     oamStaging,y                    ; 8A77 99 00 02
        iny                                     ; 8A7A C8
        iny                                     ; 8A7B C8
        lda     #$00                            ; 8A7C A9 00
        sta     oamStaging,y                    ; 8A7E 99 00 02
        jmp     @inc                            ; 8A81 4C 93 8A

; ----------------------------------------------------------------------------
; If y <= 2F, then the sprite is shown. Calculate and set x pos
@spriteShown:
        inc     oamStagingLength                ; 8A84 E6 B3
        iny                                     ; 8A86 C8
        lda     orientationTable,x              ; 8A87 BD 9C 8A
        asl     a                               ; 8A8A 0A
        asl     a                               ; 8A8B 0A
        asl     a                               ; 8A8C 0A
        clc                                     ; 8A8D 18
        adc     generalCounter3                 ; 8A8E 65 AA
        sta     oamStaging,y                    ; 8A90 99 00 02
@inc:   inc     oamStagingLength                ; 8A93 E6 B3
        iny                                     ; 8A95 C8
        inx                                     ; 8A96 E8
        dec     generalCounter2                 ; 8A97 C6 A9
        bne     @copySprite                     ; 8A99 D0 B0
        rts                                     ; 8A9B 60

; ----------------------------------------------------------------------------
; 4 sprites per tetrimino. 3 bytes per sprite: signed y off, tile, signed x off
orientationTable:
        .byte   $00,$7B,$FF,$00,$7B,$00,$00,$7B ; 8A9C 00 7B FF 00 7B 00 00 7B
        .byte   $01,$FF,$7B,$00,$FF,$7B,$00,$00 ; 8AA4 01 FF 7B 00 FF 7B 00 00
        .byte   $7B,$00,$00,$7B,$01,$01,$7B,$00 ; 8AAC 7B 00 00 7B 01 01 7B 00
        .byte   $00,$7B,$FF,$00,$7B,$00,$00,$7B ; 8AB4 00 7B FF 00 7B 00 00 7B
        .byte   $01,$01,$7B,$00,$FF,$7B,$00,$00 ; 8ABC 01 01 7B 00 FF 7B 00 00
        .byte   $7B,$FF,$00,$7B,$00,$01,$7B,$00 ; 8AC4 7B FF 00 7B 00 01 7B 00
        .byte   $FF,$7D,$00,$00,$7D,$00,$01,$7D ; 8ACC FF 7D 00 00 7D 00 01 7D
        .byte   $FF,$01,$7D,$00,$FF,$7D,$FF,$00 ; 8AD4 FF 01 7D 00 FF 7D FF 00
        .byte   $7D,$FF,$00,$7D,$00,$00,$7D,$01 ; 8ADC 7D FF 00 7D 00 00 7D 01
        .byte   $FF,$7D,$00,$FF,$7D,$01,$00,$7D ; 8AE4 FF 7D 00 FF 7D 01 00 7D
        .byte   $00,$01,$7D,$00,$00,$7D,$FF,$00 ; 8AEC 00 01 7D 00 00 7D FF 00
        .byte   $7D,$00,$00,$7D,$01,$01,$7D,$01 ; 8AF4 7D 00 00 7D 01 01 7D 01
        .byte   $00,$7C,$FF,$00,$7C,$00,$01,$7C ; 8AFC 00 7C FF 00 7C 00 01 7C
        .byte   $00,$01,$7C,$01,$FF,$7C,$01,$00 ; 8B04 00 01 7C 01 FF 7C 01 00
        .byte   $7C,$00,$00,$7C,$01,$01,$7C,$00 ; 8B0C 7C 00 00 7C 01 01 7C 00
        .byte   $00,$7B,$FF,$00,$7B,$00,$01,$7B ; 8B14 00 7B FF 00 7B 00 01 7B
        .byte   $FF,$01,$7B,$00,$00,$7D,$00,$00 ; 8B1C FF 01 7B 00 00 7D 00 00
        .byte   $7D,$01,$01,$7D,$FF,$01,$7D,$00 ; 8B24 7D 01 01 7D FF 01 7D 00
        .byte   $FF,$7D,$00,$00,$7D,$00,$00,$7D ; 8B2C FF 7D 00 00 7D 00 00 7D
        .byte   $01,$01,$7D,$01,$FF,$7C,$00,$00 ; 8B34 01 01 7D 01 FF 7C 00 00
        .byte   $7C,$00,$01,$7C,$00,$01,$7C,$01 ; 8B3C 7C 00 01 7C 00 01 7C 01
        .byte   $00,$7C,$FF,$00,$7C,$00,$00,$7C ; 8B44 00 7C FF 00 7C 00 00 7C
        .byte   $01,$01,$7C,$FF,$FF,$7C,$FF,$FF ; 8B4C 01 01 7C FF FF 7C FF FF
        .byte   $7C,$00,$00,$7C,$00,$01,$7C,$00 ; 8B54 7C 00 00 7C 00 01 7C 00
        .byte   $FF,$7C,$01,$00,$7C,$FF,$00,$7C ; 8B5C FF 7C 01 00 7C FF 00 7C
        .byte   $00,$00,$7C,$01,$FE,$7B,$00,$FF ; 8B64 00 00 7C 01 FE 7B 00 FF
        .byte   $7B,$00,$00,$7B,$00,$01,$7B,$00 ; 8B6C 7B 00 00 7B 00 01 7B 00
        .byte   $00,$7B,$FE,$00,$7B,$FF,$00,$7B ; 8B74 00 7B FE 00 7B FF 00 7B
        .byte   $00,$00,$7B,$01,$00,$FF,$00,$00 ; 8B7C 00 00 7B 01 00 FF 00 00
        .byte   $FF,$00,$00,$FF,$00,$00,$FF,$00 ; 8B84 FF 00 00 FF 00 00 FF 00
; ----------------------------------------------------------------------------
unreferenced_func2:
        lda     spriteIndexInOamContentLookup   ; 8B8C A5 A2
        asl     a                               ; 8B8E 0A
        asl     a                               ; 8B8F 0A
        sta     generalCounter                  ; 8B90 85 A8
        asl     a                               ; 8B92 0A
        clc                                     ; 8B93 18
        adc     generalCounter                  ; 8B94 65 A8
        tay                                     ; 8B96 A8
        ldx     oamStagingLength                ; 8B97 A6 B3
        lda     #$04                            ; 8B99 A9 04
        sta     generalCounter2                 ; 8B9B 85 A9
@loop:  lda     orientationTable,y              ; 8B9D B9 9C 8A
        clc                                     ; 8BA0 18
        asl     a                               ; 8BA1 0A
        asl     a                               ; 8BA2 0A
        asl     a                               ; 8BA3 0A
        adc     spriteYOffset                   ; 8BA4 65 A1
        sta     oamStaging,x                    ; 8BA6 9D 00 02
        inx                                     ; 8BA9 E8
        iny                                     ; 8BAA C8
        lda     orientationTable,y              ; 8BAB B9 9C 8A
        sta     oamStaging,x                    ; 8BAE 9D 00 02
        inx                                     ; 8BB1 E8
        iny                                     ; 8BB2 C8
        lda     #$02                            ; 8BB3 A9 02
        sta     oamStaging,x                    ; 8BB5 9D 00 02
        inx                                     ; 8BB8 E8
        lda     orientationTable,y              ; 8BB9 B9 9C 8A
        clc                                     ; 8BBC 18
        asl     a                               ; 8BBD 0A
        asl     a                               ; 8BBE 0A
        asl     a                               ; 8BBF 0A
        adc     spriteXOffset                   ; 8BC0 65 A0
        sta     oamStaging,x                    ; 8BC2 9D 00 02
        inx                                     ; 8BC5 E8
        iny                                     ; 8BC6 C8
        dec     generalCounter2                 ; 8BC7 C6 A9
        bne     @loop                           ; 8BC9 D0 D2
        stx     oamStagingLength                ; 8BCB 86 B3
        rts                                     ; 8BCD 60

; ----------------------------------------------------------------------------
stageSpriteForNextPiece:
        lda     displayNextPiece                ; 8BCE A5 DF
        bne     @ret                            ; 8BD0 D0 12
        lda     #$C8                            ; 8BD2 A9 C8
        sta     spriteXOffset                   ; 8BD4 85 A0
        lda     #$77                            ; 8BD6 A9 77
        sta     spriteYOffset                   ; 8BD8 85 A1
        ldx     nextPiece                       ; 8BDA A6 BF
        lda     orientationToSpriteTable,x      ; 8BDC BD E5 8B
        sta     spriteIndexInOamContentLookup   ; 8BDF 85 A2
        jmp     loadSpriteIntoOamStaging        ; 8BE1 4C 27 8C

; ----------------------------------------------------------------------------
@ret:   rts                                     ; 8BE4 60

; ----------------------------------------------------------------------------
; Only cares about orientations selected by spawnTable
orientationToSpriteTable:
        .byte   $00,$00,$06,$00,$00,$00,$00,$09 ; 8BE5 00 00 06 00 00 00 00 09
        .byte   $08,$00,$0B,$07,$00,$00,$0A,$00 ; 8BED 08 00 0B 07 00 00 0A 00
        .byte   $00,$00,$0C                     ; 8BF5 00 00 0C
; Same as orientationToSpriteTable except sprites have different offsets
unreferenced_orientationToSpriteTable:
        .byte   $00,$00,$0F,$00,$00,$00,$00,$12 ; 8BF8 00 00 0F 00 00 00 00 12
        .byte   $11,$00,$14,$10,$00,$00,$13,$00 ; 8C00 11 00 14 10 00 00 13 00
        .byte   $00,$00,$15                     ; 8C08 00 00 15
unreferenced_data2:
        .byte   $00,$FF,$FE,$FD,$FC,$FD,$FE,$FF ; 8C0B 00 FF FE FD FC FD FE FF
        .byte   $00,$01,$02,$03,$04,$05,$06,$07 ; 8C13 00 01 02 03 04 05 06 07
        .byte   $08,$09,$0A,$0B,$0C,$0D,$0E,$0F ; 8C1B 08 09 0A 0B 0C 0D 0E 0F
        .byte   $10,$11,$12,$13                 ; 8C23 10 11 12 13
; ----------------------------------------------------------------------------
loadSpriteIntoOamStaging:
        clc                                     ; 8C27 18
        lda     spriteIndexInOamContentLookup   ; 8C28 A5 A2
        rol     a                               ; 8C2A 2A
        tax                                     ; 8C2B AA
        lda     oamContentLookup,x              ; 8C2C BD 6C 8C
        sta     generalCounter                  ; 8C2F 85 A8
        inx                                     ; 8C31 E8
        lda     oamContentLookup,x              ; 8C32 BD 6C 8C
        sta     generalCounter2                 ; 8C35 85 A9
        ldx     oamStagingLength                ; 8C37 A6 B3
        ldy     #$00                            ; 8C39 A0 00
@whileNotFF:
        lda     (generalCounter),y              ; 8C3B B1 A8
        cmp     #$FF                            ; 8C3D C9 FF
        beq     @ret                            ; 8C3F F0 2A
        clc                                     ; 8C41 18
        adc     spriteYOffset                   ; 8C42 65 A1
        sta     oamStaging,x                    ; 8C44 9D 00 02
        inx                                     ; 8C47 E8
        iny                                     ; 8C48 C8
        lda     (generalCounter),y              ; 8C49 B1 A8
        sta     oamStaging,x                    ; 8C4B 9D 00 02
        inx                                     ; 8C4E E8
        iny                                     ; 8C4F C8
        lda     (generalCounter),y              ; 8C50 B1 A8
        sta     oamStaging,x                    ; 8C52 9D 00 02
        inx                                     ; 8C55 E8
        iny                                     ; 8C56 C8
        lda     (generalCounter),y              ; 8C57 B1 A8
        clc                                     ; 8C59 18
        adc     spriteXOffset                   ; 8C5A 65 A0
        sta     oamStaging,x                    ; 8C5C 9D 00 02
        inx                                     ; 8C5F E8
        iny                                     ; 8C60 C8
        lda     #$04                            ; 8C61 A9 04
        clc                                     ; 8C63 18
        adc     oamStagingLength                ; 8C64 65 B3
        sta     oamStagingLength                ; 8C66 85 B3
        jmp     @whileNotFF                     ; 8C68 4C 3B 8C

; ----------------------------------------------------------------------------
@ret:   rts                                     ; 8C6B 60

; ----------------------------------------------------------------------------
oamContentLookup:
        .addr   sprite00LevelSelectCursor       ; 8C6C 20 8D
        .addr   sprite01GameTypeCursor          ; 8C6E 31 8D
        .addr   sprite02Blank                   ; 8C70 3A 8D
        .addr   sprite03PausePalette6           ; 8C72 3F 8D
        .addr   sprite05PausePalette4           ; 8C74 54 8D
        .addr   sprite05PausePalette4           ; 8C76 54 8D
        .addr   sprite06TPiece                  ; 8C78 69 8D
        .addr   sprite07SPiece                  ; 8C7A 7A 8D
        .addr   sprite08ZPiece                  ; 8C7C 8B 8D
        .addr   sprite09JPiece                  ; 8C7E 9C 8D
        .addr   sprite0ALPiece                  ; 8C80 AD 8D
        .addr   sprite0BOPiece                  ; 8C82 BE 8D
        .addr   sprite0CIPiece                  ; 8C84 CF 8D
        .addr   sprite0EHighScoreNameCursor     ; 8C86 E0 8D
        .addr   sprite0EHighScoreNameCursor     ; 8C88 E0 8D
        .addr   sprite0FTPieceOffset            ; 8C8A E5 8D
        .addr   sprite10SPieceOffset            ; 8C8C F6 8D
        .addr   sprite11ZPieceOffset            ; 8C8E 07 8E
        .addr   sprite12JPieceOffset            ; 8C90 18 8E
        .addr   sprite13LPieceOffset            ; 8C92 29 8E
        .addr   sprite14OPieceOffset            ; 8C94 3A 8E
        .addr   sprite15IPieceOffset            ; 8C96 4B 8E
        .addr   sprite16KidIcarus1              ; 8C98 5C 8E
        .addr   sprite17KidIcarus2              ; 8C9A 6D 8E
        .addr   sprite18Link1                   ; 8C9C 7A 8E
        .addr   sprite19Link2                   ; 8C9E 83 8E
        .addr   sprite1ASamus1                  ; 8CA0 8C 8E
        .addr   sprite1BSamus2                  ; 8CA2 A5 8E
        .addr   sprite1CDonkeyKong_armsClosed   ; 8CA4 BE 8E
        .addr   sprite1DDonkeyKong1             ; 8CA6 D7 8E
        .addr   sprite1EDonkeyKong2             ; 8CA8 F8 8E
        .addr   sprite1FBowser1                 ; 8CAA 19 8F
        .addr   sprite20Bowser2                 ; 8CAC 2E 8F
        .addr   sprite21PrincessPeach1          ; 8CAE 43 8F
        .addr   sprite22PrincessPeach2          ; 8CB0 4C 8F
        .addr   sprite23CathedralRocketJet1     ; 8CB2 55 8F
        .addr   sprite24CathedralRocketJet2     ; 8CB4 5E 8F
        .addr   sprite25CloudLarge              ; 8CB6 7F 8F
        .addr   sprite26CloudSmall              ; 8CB8 98 8F
        .addr   sprite27Mario1                  ; 8CBA A1 8F
        .addr   sprite28Mario2                  ; 8CBC C6 8F
        .addr   sprite29Luigi1                  ; 8CBE DF 8F
        .addr   sprite2ALuigi2                  ; 8CC0 04 90
        .addr   sprite2CDragonfly1              ; 8CC2 29 90
        .addr   sprite2CDragonfly1              ; 8CC4 29 90
        .addr   sprite2DDragonfly2              ; 8CC6 2E 90
        .addr   sprite2EDove1                   ; 8CC8 33 90
        .addr   sprite2FDove2                   ; 8CCA 44 90
        .addr   sprite30Airplane1               ; 8CCC 55 90
        .addr   sprite31Airplane2               ; 8CCE 66 90
        .addr   sprite32Ufo1                    ; 8CD0 77 90
        .addr   sprite33Ufo2                    ; 8CD2 88 90
        .addr   sprite34Pterosaur1              ; 8CD4 99 90
        .addr   sprite35Pterosaur2              ; 8CD6 B2 90
        .addr   sprite36Blimp1                  ; 8CD8 CB 90
        .addr   sprite37Blimp2                  ; 8CDA E4 90
        .addr   sprite38Dragon1                 ; 8CDC FD 90
        .addr   sprite39Dragon2                 ; 8CDE 26 91
        .addr   sprite3ABuran1                  ; 8CE0 4F 91
        .addr   sprite3BBuran2                  ; 8CE2 78 91
        .addr   sprite3CHelicopter1             ; 8CE4 9D 91
        .addr   sprite3DHelicopter2             ; 8CE6 B2 91
        .addr   sprite3ESmallRocket             ; 8CE8 C7 91
        .addr   sprite3FSmallRocketJet1         ; 8CEA CC 91
        .addr   sprite40SmallRocketJet2         ; 8CEC D1 91
        .addr   sprite41MediumRocket            ; 8CEE D6 91
        .addr   sprite42MediumRocketJet1        ; 8CF0 DF 91
        .addr   sprite43MediumRocketJet2        ; 8CF2 E4 91
        .addr   sprite44LargeRocket             ; 8CF4 E9 91
        .addr   sprite45LargeRocketJet1         ; 8CF6 0A 92
        .addr   sprite46LargeRocketJet2         ; 8CF8 13 92
        .addr   sprite47BuranRocket             ; 8CFA 1C 92
        .addr   sprite48BuranRocketJet1         ; 8CFC 75 92
        .addr   sprite49BuranRocketJet2         ; 8CFE 7E 92
        .addr   sprite4ACathedralRocket         ; 8D00 8F 92
        .addr   sprite4BOstrich1                ; 8D02 68 93
        .addr   sprite4COstrich2                ; 8D04 9D 93
        .addr   sprite4DCathedralEasternDome    ; 8D06 D2 93
        .addr   sprite4ECathedralNorthernDome   ; 8D08 E7 93
        .addr   sprite4FCathedralCentralDome    ; 8D0A FC 93
        .addr   sprite50CathedralWesternDome    ; 8D0C 11 94
        .addr   sprite51CathedralDomeRocketJet1 ; 8D0E 22 94
        .addr   sprite52CathedralDomeRocketJet2 ; 8D10 27 94
        .addr   sprite53MusicTypeCursor         ; 8D12 30 94
        .addr   sprite54Penguin1                ; 8D14 39 94
        .addr   sprite55Penguin2                ; 8D16 62 94
        .addr   isPositionValid                 ; 8D18 8B 94
        .addr   isPositionValid                 ; 8D1A 8B 94
        .addr   isPositionValid                 ; 8D1C 8B 94
        .addr   isPositionValid                 ; 8D1E 8B 94
; ----------------------------------------------------------------------------
; Sprites are sets of 4 bytes in the OAM format, terminated by FF. byte0=y, byte1=tile, byte2=attrs, byte3=x
sprite00LevelSelectCursor:
        .byte   $00,$FC,$20,$00,$00,$FC,$20,$08 ; 8D20 00 FC 20 00 00 FC 20 08
        .byte   $08,$FC,$20,$00,$08,$FC,$20,$08 ; 8D28 08 FC 20 00 08 FC 20 08
        .byte   $FF                             ; 8D30 FF
sprite01GameTypeCursor:
        .byte   $00,$27,$00,$00,$00,$27,$40,$3A ; 8D31 00 27 00 00 00 27 40 3A
        .byte   $FF                             ; 8D39 FF
; Used as a sort of NOOP for cursors
sprite02Blank:
        .byte   $00,$FF,$00,$00,$FF             ; 8D3A 00 FF 00 00 FF
sprite03PausePalette6:
        .byte   $00,$19,$02,$00,$00,$0A,$02,$08 ; 8D3F 00 19 02 00 00 0A 02 08
        .byte   $00,$1E,$02,$10,$00,$1C,$02,$18 ; 8D47 00 1E 02 10 00 1C 02 18
        .byte   $00,$0E,$02,$20,$FF             ; 8D4F 00 0E 02 20 FF
sprite05PausePalette4:
        .byte   $00,$19,$00,$00,$00,$0A,$00,$08 ; 8D54 00 19 00 00 00 0A 00 08
        .byte   $00,$1E,$00,$10,$00,$1C,$00,$18 ; 8D5C 00 1E 00 10 00 1C 00 18
        .byte   $00,$0E,$00,$20,$FF             ; 8D64 00 0E 00 20 FF
sprite06TPiece:
        .byte   $00,$7B,$02,$FC,$00,$7B,$02,$04 ; 8D69 00 7B 02 FC 00 7B 02 04
        .byte   $00,$7B,$02,$0C,$08,$7B,$02,$04 ; 8D71 00 7B 02 0C 08 7B 02 04
        .byte   $FF                             ; 8D79 FF
sprite07SPiece:
        .byte   $00,$7D,$02,$04,$00,$7D,$02,$0C ; 8D7A 00 7D 02 04 00 7D 02 0C
        .byte   $08,$7D,$02,$FC,$08,$7D,$02,$04 ; 8D82 08 7D 02 FC 08 7D 02 04
        .byte   $FF                             ; 8D8A FF
sprite08ZPiece:
        .byte   $00,$7C,$02,$FC,$00,$7C,$02,$04 ; 8D8B 00 7C 02 FC 00 7C 02 04
        .byte   $08,$7C,$02,$04,$08,$7C,$02,$0C ; 8D93 08 7C 02 04 08 7C 02 0C
        .byte   $FF                             ; 8D9B FF
sprite09JPiece:
        .byte   $00,$7D,$02,$FC,$00,$7D,$02,$04 ; 8D9C 00 7D 02 FC 00 7D 02 04
        .byte   $00,$7D,$02,$0C,$08,$7D,$02,$0C ; 8DA4 00 7D 02 0C 08 7D 02 0C
        .byte   $FF                             ; 8DAC FF
sprite0ALPiece:
        .byte   $00,$7C,$02,$FC,$00,$7C,$02,$04 ; 8DAD 00 7C 02 FC 00 7C 02 04
        .byte   $00,$7C,$02,$0C,$08,$7C,$02,$FC ; 8DB5 00 7C 02 0C 08 7C 02 FC
        .byte   $FF                             ; 8DBD FF
sprite0BOPiece:
        .byte   $00,$7B,$02,$00,$00,$7B,$02,$08 ; 8DBE 00 7B 02 00 00 7B 02 08
        .byte   $08,$7B,$02,$00,$08,$7B,$02,$08 ; 8DC6 08 7B 02 00 08 7B 02 08
        .byte   $FF                             ; 8DCE FF
sprite0CIPiece:
        .byte   $04,$7B,$02,$F8,$04,$7B,$02,$00 ; 8DCF 04 7B 02 F8 04 7B 02 00
        .byte   $04,$7B,$02,$08,$04,$7B,$02,$10 ; 8DD7 04 7B 02 08 04 7B 02 10
        .byte   $FF                             ; 8DDF FF
sprite0EHighScoreNameCursor:
        .byte   $00,$FC,$21,$00,$FF             ; 8DE0 00 FC 21 00 FF
; Unused, but referenced from unreferenced_orientationToSpriteTable
sprite0FTPieceOffset:
        .byte   $02,$7B,$02,$FC,$02,$7B,$02,$04 ; 8DE5 02 7B 02 FC 02 7B 02 04
        .byte   $02,$7B,$02,$0C,$0A,$7B,$02,$04 ; 8DED 02 7B 02 0C 0A 7B 02 04
        .byte   $FF                             ; 8DF5 FF
; Unused, but referenced from unreferenced_orientationToSpriteTable
sprite10SPieceOffset:
        .byte   $00,$7D,$02,$06,$00,$7D,$02,$0E ; 8DF6 00 7D 02 06 00 7D 02 0E
        .byte   $08,$7D,$02,$FE,$08,$7D,$02,$06 ; 8DFE 08 7D 02 FE 08 7D 02 06
        .byte   $FF                             ; 8E06 FF
; Unused, but referenced from unreferenced_orientationToSpriteTable
sprite11ZPieceOffset:
        .byte   $00,$7C,$02,$FA,$00,$7C,$02,$02 ; 8E07 00 7C 02 FA 00 7C 02 02
        .byte   $08,$7C,$02,$02,$08,$7C,$02,$0A ; 8E0F 08 7C 02 02 08 7C 02 0A
        .byte   $FF                             ; 8E17 FF
; Unused, but referenced from unreferenced_orientationToSpriteTable
sprite12JPieceOffset:
        .byte   $08,$7D,$02,$00,$08,$7D,$02,$08 ; 8E18 08 7D 02 00 08 7D 02 08
        .byte   $08,$7D,$02,$10,$10,$7D,$02,$10 ; 8E20 08 7D 02 10 10 7D 02 10
        .byte   $FF                             ; 8E28 FF
; Unused, but referenced from unreferenced_orientationToSpriteTable
sprite13LPieceOffset:
        .byte   $08,$7C,$02,$F8,$08,$7C,$02,$00 ; 8E29 08 7C 02 F8 08 7C 02 00
        .byte   $08,$7C,$02,$08,$10,$7C,$02,$F8 ; 8E31 08 7C 02 08 10 7C 02 F8
        .byte   $FF                             ; 8E39 FF
; Unused, but referenced from unreferenced_orientationToSpriteTable
sprite14OPieceOffset:
        .byte   $00,$7B,$02,$00,$00,$7B,$02,$08 ; 8E3A 00 7B 02 00 00 7B 02 08
        .byte   $08,$7B,$02,$00,$08,$7B,$02,$08 ; 8E42 08 7B 02 00 08 7B 02 08
        .byte   $FF                             ; 8E4A FF
; Unused, but referenced from unreferenced_orientationToSpriteTable
sprite15IPieceOffset:
        .byte   $08,$7B,$02,$F8,$08,$7B,$02,$00 ; 8E4B 08 7B 02 F8 08 7B 02 00
        .byte   $08,$7B,$02,$08,$08,$7B,$02,$10 ; 8E53 08 7B 02 08 08 7B 02 10
        .byte   $FF                             ; 8E5B FF
sprite16KidIcarus1:
        .byte   $F0,$95,$01,$10,$F8,$A3,$01,$00 ; 8E5C F0 95 01 10 F8 A3 01 00
        .byte   $F8,$A4,$01,$08,$F8,$A5,$01,$10 ; 8E64 F8 A4 01 08 F8 A5 01 10
        .byte   $FF                             ; 8E6C FF
sprite17KidIcarus2:
        .byte   $F8,$83,$01,$00,$F8,$84,$01,$08 ; 8E6D F8 83 01 00 F8 84 01 08
        .byte   $F8,$85,$01,$10,$FF             ; 8E75 F8 85 01 10 FF
sprite18Link1:
        .byte   $F0,$90,$00,$00,$F8,$A0,$00,$00 ; 8E7A F0 90 00 00 F8 A0 00 00
        .byte   $FF                             ; 8E82 FF
sprite19Link2:
        .byte   $F0,$C4,$00,$00,$F8,$D4,$00,$00 ; 8E83 F0 C4 00 00 F8 D4 00 00
        .byte   $FF                             ; 8E8B FF
sprite1ASamus1:
        .byte   $E8,$28,$00,$08,$E8,$2A,$00,$10 ; 8E8C E8 28 00 08 E8 2A 00 10
        .byte   $F0,$C8,$03,$10,$F8,$D6,$03,$00 ; 8E94 F0 C8 03 10 F8 D6 03 00
        .byte   $F8,$D7,$03,$08,$F8,$D8,$03,$10 ; 8E9C F8 D7 03 08 F8 D8 03 10
        .byte   $FF                             ; 8EA4 FF
sprite1BSamus2:
        .byte   $E8,$28,$00,$08,$E8,$2A,$00,$10 ; 8EA5 E8 28 00 08 E8 2A 00 10
        .byte   $F0,$B9,$03,$10,$F8,$F6,$03,$00 ; 8EAD F0 B9 03 10 F8 F6 03 00
        .byte   $F8,$F7,$03,$08,$F8,$F8,$03,$10 ; 8EB5 F8 F7 03 08 F8 F8 03 10
        .byte   $FF                             ; 8EBD FF
; Unused. Strange there isn't an unused arms open as well
sprite1CDonkeyKong_armsClosed:
        .byte   $E8,$C9,$02,$00,$E8,$CB,$02,$10 ; 8EBE E8 C9 02 00 E8 CB 02 10
        .byte   $F0,$D9,$02,$00,$F0,$DB,$02,$10 ; 8EC6 F0 D9 02 00 F0 DB 02 10
        .byte   $F8,$E9,$02,$00,$F8,$EB,$02,$10 ; 8ECE F8 E9 02 00 F8 EB 02 10
        .byte   $FF                             ; 8ED6 FF
sprite1DDonkeyKong1:
        .byte   $E8,$46,$02,$F8,$E8,$47,$02,$00 ; 8ED7 E8 46 02 F8 E8 47 02 00
        .byte   $E8,$CB,$02,$10,$F0,$56,$02,$F8 ; 8EDF E8 CB 02 10 F0 56 02 F8
        .byte   $F0,$57,$02,$00,$F0,$DB,$02,$10 ; 8EE7 F0 57 02 00 F0 DB 02 10
        .byte   $F8,$87,$02,$00,$F8,$EB,$02,$10 ; 8EEF F8 87 02 00 F8 EB 02 10
        .byte   $FF                             ; 8EF7 FF
sprite1EDonkeyKong2:
        .byte   $E8,$C9,$02,$00,$E8,$66,$02,$10 ; 8EF8 E8 C9 02 00 E8 66 02 10
        .byte   $E8,$67,$02,$18,$F0,$D9,$02,$00 ; 8F00 E8 67 02 18 F0 D9 02 00
        .byte   $F0,$76,$02,$10,$F0,$77,$02,$18 ; 8F08 F0 76 02 10 F0 77 02 18
        .byte   $F8,$E9,$02,$00,$F8,$86,$02,$10 ; 8F10 F8 E9 02 00 F8 86 02 10
        .byte   $FF                             ; 8F18 FF
sprite1FBowser1:
        .byte   $F8,$E1,$00,$08,$F8,$E2,$00,$10 ; 8F19 F8 E1 00 08 F8 E2 00 10
        .byte   $00,$F1,$00,$08,$00,$C5,$00,$10 ; 8F21 00 F1 00 08 00 C5 00 10
        .byte   $00,$D5,$00,$18,$FF             ; 8F29 00 D5 00 18 FF
sprite20Bowser2:
        .byte   $F8,$E4,$00,$08,$F8,$E5,$00,$10 ; 8F2E F8 E4 00 08 F8 E5 00 10
        .byte   $00,$F4,$00,$08,$00,$F5,$00,$10 ; 8F36 00 F4 00 08 00 F5 00 10
        .byte   $00,$F3,$00,$18,$FF             ; 8F3E 00 F3 00 18 FF
sprite21PrincessPeach1:
        .byte   $00,$63,$01,$00,$00,$64,$01,$08 ; 8F43 00 63 01 00 00 64 01 08
        .byte   $FF                             ; 8F4B FF
sprite22PrincessPeach2:
        .byte   $00,$73,$01,$00,$00,$74,$01,$08 ; 8F4C 00 73 01 00 00 74 01 08
        .byte   $FF                             ; 8F54 FF
sprite23CathedralRocketJet1:
        .byte   $08,$A8,$23,$18,$08,$A9,$23,$20 ; 8F55 08 A8 23 18 08 A9 23 20
        .byte   $FF                             ; 8F5D FF
sprite24CathedralRocketJet2:
        .byte   $08,$AA,$23,$10,$08,$AB,$23,$18 ; 8F5E 08 AA 23 10 08 AB 23 18
        .byte   $08,$AC,$23,$20,$08,$AD,$23,$28 ; 8F66 08 AC 23 20 08 AD 23 28
        .byte   $10,$BA,$23,$10,$10,$BB,$23,$18 ; 8F6E 10 BA 23 10 10 BB 23 18
        .byte   $10,$BC,$23,$20,$10,$BD,$23,$28 ; 8F76 10 BC 23 20 10 BD 23 28
        .byte   $FF                             ; 8F7E FF
; Seems unused
sprite25CloudLarge:
        .byte   $00,$60,$21,$00,$00,$61,$21,$08 ; 8F7F 00 60 21 00 00 61 21 08
        .byte   $00,$62,$21,$10,$08,$70,$21,$00 ; 8F87 00 62 21 10 08 70 21 00
        .byte   $08,$71,$21,$08,$08,$72,$21,$10 ; 8F8F 08 71 21 08 08 72 21 10
        .byte   $FF                             ; 8F97 FF
; Seems unused. Broken? Seems $81 should be $81
sprite26CloudSmall:
        .byte   $00,$80,$21,$00,$00,$81,$21,$08 ; 8F98 00 80 21 00 00 81 21 08
        .byte   $FF                             ; 8FA0 FF
sprite27Mario1:
        .byte   $F0,$30,$03,$00,$F0,$31,$03,$08 ; 8FA1 F0 30 03 00 F0 31 03 08
        .byte   $F0,$32,$03,$10,$F8,$40,$03,$00 ; 8FA9 F0 32 03 10 F8 40 03 00
        .byte   $F8,$41,$03,$08,$F8,$42,$03,$10 ; 8FB1 F8 41 03 08 F8 42 03 10
        .byte   $00,$50,$03,$00,$00,$51,$03,$08 ; 8FB9 00 50 03 00 00 51 03 08
        .byte   $00,$52,$03,$10,$FF             ; 8FC1 00 52 03 10 FF
sprite28Mario2:
        .byte   $F8,$23,$03,$00,$F8,$24,$03,$08 ; 8FC6 F8 23 03 00 F8 24 03 08
        .byte   $F8,$25,$03,$10,$00,$33,$03,$00 ; 8FCE F8 25 03 10 00 33 03 00
        .byte   $00,$34,$03,$08,$00,$35,$03,$10 ; 8FD6 00 34 03 08 00 35 03 10
        .byte   $FF                             ; 8FDE FF
sprite29Luigi1:
        .byte   $F0,$30,$00,$00,$F0,$31,$00,$08 ; 8FDF F0 30 00 00 F0 31 00 08
        .byte   $F0,$32,$00,$10,$F8,$29,$00,$00 ; 8FE7 F0 32 00 10 F8 29 00 00
        .byte   $F8,$41,$00,$08,$F8,$2B,$00,$10 ; 8FEF F8 41 00 08 F8 2B 00 10
        .byte   $00,$2C,$00,$00,$00,$2D,$00,$08 ; 8FF7 00 2C 00 00 00 2D 00 08
        .byte   $00,$2E,$00,$10,$FF             ; 8FFF 00 2E 00 10 FF
sprite2ALuigi2:
        .byte   $F0,$32,$40,$00,$F0,$31,$40,$08 ; 9004 F0 32 40 00 F0 31 40 08
        .byte   $F0,$30,$40,$10,$F8,$2B,$40,$00 ; 900C F0 30 40 10 F8 2B 40 00
        .byte   $F8,$41,$40,$08,$F8,$29,$40,$10 ; 9014 F8 41 40 08 F8 29 40 10
        .byte   $00,$2E,$40,$00,$00,$2D,$40,$08 ; 901C 00 2E 40 00 00 2D 40 08
        .byte   $00,$2C,$40,$10,$FF             ; 9024 00 2C 40 10 FF
sprite2CDragonfly1:
        .byte   $00,$20,$23,$00,$FF             ; 9029 00 20 23 00 FF
sprite2DDragonfly2:
        .byte   $00,$21,$23,$00,$FF             ; 902E 00 21 23 00 FF
sprite2EDove1:
        .byte   $F8,$22,$21,$00,$F8,$23,$21,$08 ; 9033 F8 22 21 00 F8 23 21 08
        .byte   $00,$32,$21,$00,$00,$33,$21,$08 ; 903B 00 32 21 00 00 33 21 08
        .byte   $FF                             ; 9043 FF
sprite2FDove2:
        .byte   $F8,$24,$21,$00,$F8,$25,$21,$08 ; 9044 F8 24 21 00 F8 25 21 08
        .byte   $00,$34,$21,$00,$00,$35,$21,$08 ; 904C 00 34 21 00 00 35 21 08
        .byte   $FF                             ; 9054 FF
; Unused
sprite30Airplane1:
        .byte   $F8,$26,$21,$F0,$F8,$27,$21,$F8 ; 9055 F8 26 21 F0 F8 27 21 F8
        .byte   $00,$36,$21,$F0,$00,$37,$21,$F8 ; 905D 00 36 21 F0 00 37 21 F8
        .byte   $FF                             ; 9065 FF
; Unused
sprite31Airplane2:
        .byte   $F8,$28,$21,$F0,$F8,$27,$21,$F8 ; 9066 F8 28 21 F0 F8 27 21 F8
        .byte   $00,$29,$21,$F0,$00,$37,$21,$F8 ; 906E 00 29 21 F0 00 37 21 F8
        .byte   $FF                             ; 9076 FF
sprite32Ufo1:
        .byte   $F8,$46,$21,$F0,$F8,$47,$21,$F8 ; 9077 F8 46 21 F0 F8 47 21 F8
        .byte   $00,$56,$21,$F0,$00,$57,$21,$F8 ; 907F 00 56 21 F0 00 57 21 F8
        .byte   $FF                             ; 9087 FF
sprite33Ufo2:
        .byte   $F8,$46,$21,$F0,$F8,$47,$21,$F8 ; 9088 F8 46 21 F0 F8 47 21 F8
        .byte   $00,$66,$21,$F0,$00,$67,$21,$F8 ; 9090 00 66 21 F0 00 67 21 F8
        .byte   $FF                             ; 9098 FF
sprite34Pterosaur1:
        .byte   $F8,$43,$22,$00,$F8,$44,$22,$08 ; 9099 F8 43 22 00 F8 44 22 08
        .byte   $F8,$45,$22,$10,$00,$53,$22,$00 ; 90A1 F8 45 22 10 00 53 22 00
        .byte   $00,$54,$22,$08,$00,$55,$22,$10 ; 90A9 00 54 22 08 00 55 22 10
        .byte   $FF                             ; 90B1 FF
sprite35Pterosaur2:
        .byte   $F8,$63,$22,$00,$F8,$64,$22,$08 ; 90B2 F8 63 22 00 F8 64 22 08
        .byte   $F8,$65,$22,$10,$00,$73,$22,$00 ; 90BA F8 65 22 10 00 73 22 00
        .byte   $00,$74,$22,$08,$00,$75,$22,$10 ; 90C2 00 74 22 08 00 75 22 10
        .byte   $FF                             ; 90CA FF
sprite36Blimp1:
        .byte   $F8,$40,$21,$E8,$F8,$41,$21,$F0 ; 90CB F8 40 21 E8 F8 41 21 F0
        .byte   $F8,$42,$21,$F8,$00,$50,$21,$E8 ; 90D3 F8 42 21 F8 00 50 21 E8
        .byte   $00,$51,$21,$F0,$00,$52,$21,$F8 ; 90DB 00 51 21 F0 00 52 21 F8
        .byte   $FF                             ; 90E3 FF
sprite37Blimp2:
        .byte   $F8,$40,$21,$E8,$F8,$41,$21,$F0 ; 90E4 F8 40 21 E8 F8 41 21 F0
        .byte   $F8,$42,$21,$F8,$00,$50,$21,$E8 ; 90EC F8 42 21 F8 00 50 21 E8
        .byte   $00,$30,$21,$F0,$00,$52,$21,$F8 ; 90F4 00 30 21 F0 00 52 21 F8
        .byte   $FF                             ; 90FC FF
sprite38Dragon1:
        .byte   $F8,$90,$23,$08,$F8,$A2,$23,$10 ; 90FD F8 90 23 08 F8 A2 23 10
        .byte   $00,$91,$23,$F0,$00,$92,$23,$F8 ; 9105 00 91 23 F0 00 92 23 F8
        .byte   $00,$B0,$23,$00,$00,$A0,$23,$08 ; 910D 00 B0 23 00 00 A0 23 08
        .byte   $00,$B2,$23,$10,$00,$B3,$23,$18 ; 9115 00 B2 23 10 00 B3 23 18
        .byte   $08,$C0,$23,$00,$08,$C1,$23,$08 ; 911D 08 C0 23 00 08 C1 23 08
        .byte   $FF                             ; 9125 FF
sprite39Dragon2:
        .byte   $F8,$A1,$23,$08,$F8,$A2,$23,$10 ; 9126 F8 A1 23 08 F8 A2 23 10
        .byte   $00,$91,$23,$F0,$00,$92,$23,$F8 ; 912E 00 91 23 F0 00 92 23 F8
        .byte   $00,$B0,$23,$00,$00,$B1,$23,$08 ; 9136 00 B0 23 00 00 B1 23 08
        .byte   $00,$B2,$23,$10,$00,$B3,$23,$18 ; 913E 00 B2 23 10 00 B3 23 18
        .byte   $08,$C0,$23,$00,$08,$C1,$23,$08 ; 9146 08 C0 23 00 08 C1 23 08
        .byte   $FF                             ; 914E FF
sprite3ABuran1:
        .byte   $F8,$D3,$21,$F0,$00,$E1,$21,$E0 ; 914F F8 D3 21 F0 00 E1 21 E0
        .byte   $00,$E2,$21,$E8,$00,$E3,$21,$F0 ; 9157 00 E2 21 E8 00 E3 21 F0
        .byte   $08,$F0,$21,$D8,$08,$F1,$21,$E0 ; 915F 08 F0 21 D8 08 F1 21 E0
        .byte   $08,$F2,$21,$E8,$08,$F3,$21,$F0 ; 9167 08 F2 21 E8 08 F3 21 F0
        .byte   $08,$D1,$21,$F8,$08,$D2,$21,$00 ; 916F 08 D1 21 F8 08 D2 21 00
        .byte   $FF                             ; 9177 FF
sprite3BBuran2:
        .byte   $F8,$D3,$21,$F0,$00,$E1,$21,$E0 ; 9178 F8 D3 21 F0 00 E1 21 E0
        .byte   $00,$E2,$21,$E8,$00,$E3,$21,$F0 ; 9180 00 E2 21 E8 00 E3 21 F0
        .byte   $08,$F0,$21,$D8,$08,$F1,$21,$E0 ; 9188 08 F0 21 D8 08 F1 21 E0
        .byte   $08,$F2,$21,$E8,$08,$F3,$21,$F0 ; 9190 08 F2 21 E8 08 F3 21 F0
        .byte   $08,$D0,$21,$F8,$FF             ; 9198 08 D0 21 F8 FF
; Unused
sprite3CHelicopter1:
        .byte   $F8,$83,$23,$E8,$F8,$84,$23,$F0 ; 919D F8 83 23 E8 F8 84 23 F0
        .byte   $F8,$85,$23,$F8,$00,$93,$23,$E8 ; 91A5 F8 85 23 F8 00 93 23 E8
        .byte   $00,$94,$23,$F0,$FF             ; 91AD 00 94 23 F0 FF
; Unused
sprite3DHelicopter2:
        .byte   $F8,$A3,$23,$E8,$F8,$A4,$23,$F0 ; 91B2 F8 A3 23 E8 F8 A4 23 F0
        .byte   $F8,$A5,$23,$F8,$00,$93,$23,$E8 ; 91BA F8 A5 23 F8 00 93 23 E8
        .byte   $00,$94,$23,$F0,$FF             ; 91C2 00 94 23 F0 FF
sprite3ESmallRocket:
        .byte   $00,$A6,$23,$00,$FF             ; 91C7 00 A6 23 00 FF
sprite3FSmallRocketJet1:
        .byte   $08,$A7,$23,$00,$FF             ; 91CC 08 A7 23 00 FF
sprite40SmallRocketJet2:
        .byte   $08,$F4,$23,$00,$FF             ; 91D1 08 F4 23 00 FF
sprite41MediumRocket:
        .byte   $F8,$B4,$21,$00,$00,$C4,$21,$00 ; 91D6 F8 B4 21 00 00 C4 21 00
        .byte   $FF                             ; 91DE FF
sprite42MediumRocketJet1:
        .byte   $08,$D4,$23,$00,$FF             ; 91DF 08 D4 23 00 FF
sprite43MediumRocketJet2:
        .byte   $08,$E4,$23,$00,$FF             ; 91E4 08 E4 23 00 FF
sprite44LargeRocket:
        .byte   $E8,$B5,$23,$00,$E8,$B6,$23,$08 ; 91E9 E8 B5 23 00 E8 B6 23 08
        .byte   $F0,$C5,$23,$00,$F0,$C6,$23,$08 ; 91F1 F0 C5 23 00 F0 C6 23 08
        .byte   $F8,$D5,$23,$00,$F8,$D6,$23,$08 ; 91F9 F8 D5 23 00 F8 D6 23 08
        .byte   $00,$E5,$23,$00,$00,$E6,$23,$08 ; 9201 00 E5 23 00 00 E6 23 08
        .byte   $FF                             ; 9209 FF
sprite45LargeRocketJet1:
        .byte   $08,$F5,$23,$00,$08,$F6,$23,$08 ; 920A 08 F5 23 00 08 F6 23 08
        .byte   $FF                             ; 9212 FF
sprite46LargeRocketJet2:
        .byte   $08,$B7,$23,$00,$08,$B8,$23,$08 ; 9213 08 B7 23 00 08 B8 23 08
        .byte   $FF                             ; 921B FF
sprite47BuranRocket:
        .byte   $D0,$C2,$21,$08,$D0,$C3,$21,$10 ; 921C D0 C2 21 08 D0 C3 21 10
        .byte   $D8,$CB,$21,$08,$D8,$EB,$21,$10 ; 9224 D8 CB 21 08 D8 EB 21 10
        .byte   $E0,$DB,$21,$08,$E0,$FB,$21,$10 ; 922C E0 DB 21 08 E0 FB 21 10
        .byte   $E8,$C7,$21,$00,$E8,$C8,$21,$08 ; 9234 E8 C7 21 00 E8 C8 21 08
        .byte   $E8,$C9,$21,$10,$E8,$CA,$21,$18 ; 923C E8 C9 21 10 E8 CA 21 18
        .byte   $F0,$D7,$21,$00,$F0,$D8,$21,$08 ; 9244 F0 D7 21 00 F0 D8 21 08
        .byte   $F0,$D9,$21,$10,$F0,$DA,$21,$18 ; 924C F0 D9 21 10 F0 DA 21 18
        .byte   $F8,$E7,$21,$00,$F8,$E8,$21,$08 ; 9254 F8 E7 21 00 F8 E8 21 08
        .byte   $F8,$E9,$21,$10,$F8,$EA,$21,$18 ; 925C F8 E9 21 10 F8 EA 21 18
        .byte   $00,$F7,$21,$00,$00,$F8,$21,$08 ; 9264 00 F7 21 00 00 F8 21 08
        .byte   $00,$F9,$21,$10,$00,$FA,$21,$18 ; 926C 00 F9 21 10 00 FA 21 18
        .byte   $FF                             ; 9274 FF
sprite48BuranRocketJet1:
        .byte   $08,$2A,$23,$08,$08,$2B,$23,$10 ; 9275 08 2A 23 08 08 2B 23 10
        .byte   $FF                             ; 927D FF
sprite49BuranRocketJet2:
        .byte   $08,$2C,$23,$08,$08,$2D,$23,$10 ; 927E 08 2C 23 08 08 2D 23 10
        .byte   $10,$2E,$23,$08,$10,$2F,$23,$10 ; 9286 10 2E 23 08 10 2F 23 10
        .byte   $FF                             ; 928E FF
sprite4ACathedralRocket:
        .byte   $C8,$38,$23,$20,$D0,$39,$23,$08 ; 928F C8 38 23 20 D0 39 23 08
        .byte   $D0,$3B,$23,$18,$D0,$3C,$23,$20 ; 9297 D0 3B 23 18 D0 3C 23 20
        .byte   $D0,$3E,$23,$30,$D0,$3F,$23,$38 ; 929F D0 3E 23 30 D0 3F 23 38
        .byte   $D8,$48,$23,$00,$D8,$49,$23,$08 ; 92A7 D8 48 23 00 D8 49 23 08
        .byte   $D8,$4A,$23,$10,$D8,$4B,$23,$18 ; 92AF D8 4A 23 10 D8 4B 23 18
        .byte   $D8,$4C,$23,$20,$D8,$4D,$23,$28 ; 92B7 D8 4C 23 20 D8 4D 23 28
        .byte   $D8,$4E,$20,$30,$D8,$4F,$20,$38 ; 92BF D8 4E 20 30 D8 4F 20 38
        .byte   $E0,$58,$23,$00,$E0,$59,$23,$08 ; 92C7 E0 58 23 00 E0 59 23 08
        .byte   $E0,$5A,$23,$10,$E0,$5B,$23,$18 ; 92CF E0 5A 23 10 E0 5B 23 18
        .byte   $E0,$5C,$23,$20,$E0,$5D,$23,$28 ; 92D7 E0 5C 23 20 E0 5D 23 28
        .byte   $E0,$5E,$20,$30,$E0,$5F,$20,$38 ; 92DF E0 5E 20 30 E0 5F 20 38
        .byte   $E8,$68,$23,$00,$E8,$69,$23,$08 ; 92E7 E8 68 23 00 E8 69 23 08
        .byte   $E8,$6A,$23,$10,$E8,$6B,$23,$18 ; 92EF E8 6A 23 10 E8 6B 23 18
        .byte   $E8,$6C,$23,$20,$E8,$6D,$23,$28 ; 92F7 E8 6C 23 20 E8 6D 23 28
        .byte   $E8,$6E,$23,$30,$E8,$6F,$23,$38 ; 92FF E8 6E 23 30 E8 6F 23 38
        .byte   $F0,$78,$23,$00,$F0,$79,$23,$08 ; 9307 F0 78 23 00 F0 79 23 08
        .byte   $F0,$7A,$23,$10,$F0,$7B,$23,$18 ; 930F F0 7A 23 10 F0 7B 23 18
        .byte   $F0,$7C,$23,$20,$F0,$7D,$23,$28 ; 9317 F0 7C 23 20 F0 7D 23 28
        .byte   $F0,$7E,$23,$30,$F0,$7F,$23,$38 ; 931F F0 7E 23 30 F0 7F 23 38
        .byte   $F8,$88,$20,$00,$F8,$89,$20,$08 ; 9327 F8 88 20 00 F8 89 20 08
        .byte   $F8,$8A,$20,$10,$F8,$8B,$20,$18 ; 932F F8 8A 20 10 F8 8B 20 18
        .byte   $F8,$8C,$20,$20,$F8,$8D,$20,$28 ; 9337 F8 8C 20 20 F8 8D 20 28
        .byte   $F8,$8E,$20,$30,$F8,$8F,$20,$38 ; 933F F8 8E 20 30 F8 8F 20 38
        .byte   $00,$98,$20,$00,$00,$99,$20,$08 ; 9347 00 98 20 00 00 99 20 08
        .byte   $00,$9A,$20,$10,$00,$9B,$20,$18 ; 934F 00 9A 20 10 00 9B 20 18
        .byte   $00,$9C,$20,$20,$00,$9D,$20,$28 ; 9357 00 9C 20 20 00 9D 20 28
        .byte   $00,$9E,$20,$30,$00,$9F,$20,$38 ; 935F 00 9E 20 30 00 9F 20 38
        .byte   $FF                             ; 9367 FF
sprite4BOstrich1:
        .byte   $E0,$91,$21,$08,$E0,$92,$21,$10 ; 9368 E0 91 21 08 E0 92 21 10
        .byte   $E8,$A0,$21,$00,$E8,$A1,$21,$08 ; 9370 E8 A0 21 00 E8 A1 21 08
        .byte   $E8,$A2,$21,$10,$F0,$B0,$21,$00 ; 9378 E8 A2 21 10 F0 B0 21 00
        .byte   $F0,$B1,$21,$08,$F0,$B2,$21,$10 ; 9380 F0 B1 21 08 F0 B2 21 10
        .byte   $F8,$C0,$21,$00,$F8,$C1,$21,$08 ; 9388 F8 C0 21 00 F8 C1 21 08
        .byte   $F8,$C2,$21,$10,$00,$D0,$21,$00 ; 9390 F8 C2 21 10 00 D0 21 00
        .byte   $00,$D2,$21,$10,$FF             ; 9398 00 D2 21 10 FF
sprite4COstrich2:
        .byte   $E0,$C4,$21,$08,$E0,$C5,$21,$10 ; 939D E0 C4 21 08 E0 C5 21 10
        .byte   $E8,$D3,$21,$00,$E8,$D4,$21,$08 ; 93A5 E8 D3 21 00 E8 D4 21 08
        .byte   $E8,$D5,$21,$10,$F0,$E3,$21,$00 ; 93AD E8 D5 21 10 F0 E3 21 00
        .byte   $F0,$E4,$21,$08,$F0,$E5,$21,$10 ; 93B5 F0 E4 21 08 F0 E5 21 10
        .byte   $F8,$F3,$21,$00,$F8,$F4,$21,$08 ; 93BD F8 F3 21 00 F8 F4 21 08
        .byte   $F8,$F5,$21,$10,$00,$B3,$21,$00 ; 93C5 F8 F5 21 10 00 B3 21 00
        .byte   $00,$B4,$21,$08,$FF             ; 93CD 00 B4 21 08 FF
; Saint Basil's is shown from the NNW. https://en.wikipedia.org/wiki/File:Sant_Vasily_cathedral_in_Moscow.JPG Use https://www.moscow-driver.com/photos/moscow_sightseeing/st_basil_cathedral/model_and_plan_of_cathedral_chapels to determine names of chapels
sprite4DCathedralEasternDome:
        .byte   $F0,$39,$22,$04,$F8,$AA,$22,$00 ; 93D2 F0 39 22 04 F8 AA 22 00
        .byte   $F8,$AB,$22,$08,$00,$BA,$22,$00 ; 93DA F8 AB 22 08 00 BA 22 00
        .byte   $00,$BB,$22,$08,$FF             ; 93E2 00 BB 22 08 FF
sprite4ECathedralNorthernDome:
        .byte   $F0,$3A,$23,$04,$F8,$AC,$23,$00 ; 93E7 F0 3A 23 04 F8 AC 23 00
        .byte   $F8,$AD,$23,$08,$00,$BC,$23,$00 ; 93EF F8 AD 23 08 00 BC 23 00
        .byte   $00,$BD,$23,$08,$FF             ; 93F7 00 BD 23 08 FF
sprite4FCathedralCentralDome:
        .byte   $F0,$38,$23,$08,$F8,$49,$23,$00 ; 93FC F0 38 23 08 F8 49 23 00
        .byte   $F8,$4A,$23,$08,$00,$3B,$23,$00 ; 9404 F8 4A 23 08 00 3B 23 00
        .byte   $00,$3C,$23,$08,$FF             ; 940C 00 3C 23 08 FF
sprite50CathedralWesternDome:
        .byte   $F8,$4E,$20,$00,$F8,$4F,$20,$08 ; 9411 F8 4E 20 00 F8 4F 20 08
        .byte   $00,$5E,$20,$00,$00,$5F,$20,$08 ; 9419 00 5E 20 00 00 5F 20 08
        .byte   $FF                             ; 9421 FF
sprite51CathedralDomeRocketJet1:
        .byte   $08,$5B,$23,$04,$FF             ; 9422 08 5B 23 04 FF
sprite52CathedralDomeRocketJet2:
        .byte   $08,$48,$23,$04,$10,$58,$23,$04 ; 9427 08 48 23 04 10 58 23 04
        .byte   $FF                             ; 942F FF
sprite53MusicTypeCursor:
        .byte   $00,$27,$00,$00,$00,$27,$40,$4A ; 9430 00 27 00 00 00 27 40 4A
        .byte   $FF                             ; 9438 FF
sprite54Penguin1:
        .byte   $E8,$A9,$21,$00,$E8,$AA,$21,$08 ; 9439 E8 A9 21 00 E8 AA 21 08
        .byte   $F0,$B8,$21,$F8,$F0,$B9,$21,$00 ; 9441 F0 B8 21 F8 F0 B9 21 00
        .byte   $F0,$BA,$21,$08,$F8,$C9,$21,$00 ; 9449 F0 BA 21 08 F8 C9 21 00
        .byte   $F8,$CA,$21,$08,$F8,$CB,$21,$10 ; 9451 F8 CA 21 08 F8 CB 21 10
        .byte   $00,$D9,$21,$00,$00,$DA,$21,$08 ; 9459 00 D9 21 00 00 DA 21 08
        .byte   $FF                             ; 9461 FF
sprite55Penguin2:
        .byte   $E8,$AD,$21,$00,$E8,$AE,$21,$08 ; 9462 E8 AD 21 00 E8 AE 21 08
        .byte   $F0,$BC,$21,$F8,$F0,$BD,$21,$00 ; 946A F0 BC 21 F8 F0 BD 21 00
        .byte   $F0,$BE,$21,$08,$F8,$CD,$21,$00 ; 9472 F0 BE 21 08 F8 CD 21 00
        .byte   $F8,$CE,$21,$08,$F8,$CF,$21,$10 ; 947A F8 CE 21 08 F8 CF 21 10
        .byte   $00,$DD,$21,$00,$00,$DE,$21,$08 ; 9482 00 DD 21 00 00 DE 21 08
        .byte   $FF                             ; 948A FF
; ----------------------------------------------------------------------------
isPositionValid:
        lda     tetriminoY                      ; 948B A5 41
        asl     a                               ; 948D 0A
        sta     generalCounter                  ; 948E 85 A8
        asl     a                               ; 9490 0A
        asl     a                               ; 9491 0A
        clc                                     ; 9492 18
        adc     generalCounter                  ; 9493 65 A8
        adc     tetriminoX                      ; 9495 65 40
        sta     generalCounter                  ; 9497 85 A8
        lda     currentPiece                    ; 9499 A5 42
        asl     a                               ; 949B 0A
        asl     a                               ; 949C 0A
        sta     generalCounter2                 ; 949D 85 A9
        asl     a                               ; 949F 0A
        clc                                     ; 94A0 18
        adc     generalCounter2                 ; 94A1 65 A9
        tax                                     ; 94A3 AA
        ldy     #$00                            ; 94A4 A0 00
        lda     #$04                            ; 94A6 A9 04
        sta     generalCounter3                 ; 94A8 85 AA
; Checks one square within the tetrimino
@checkSquare:
        lda     orientationTable,x              ; 94AA BD 9C 8A
        clc                                     ; 94AD 18
        adc     tetriminoY                      ; 94AE 65 41
        adc     #$02                            ; 94B0 69 02
        cmp     #$16                            ; 94B2 C9 16
        bcs     @invalid                        ; 94B4 B0 33
        lda     orientationTable,x              ; 94B6 BD 9C 8A
        asl     a                               ; 94B9 0A
        sta     generalCounter4                 ; 94BA 85 AB
        asl     a                               ; 94BC 0A
        asl     a                               ; 94BD 0A
        clc                                     ; 94BE 18
        adc     generalCounter4                 ; 94BF 65 AB
        clc                                     ; 94C1 18
        adc     generalCounter                  ; 94C2 65 A8
        sta     selectingLevelOrHeight          ; 94C4 85 AD
        inx                                     ; 94C6 E8
        inx                                     ; 94C7 E8
        lda     orientationTable,x              ; 94C8 BD 9C 8A
        clc                                     ; 94CB 18
        adc     selectingLevelOrHeight          ; 94CC 65 AD
        tay                                     ; 94CE A8
        lda     (playfieldAddr),y               ; 94CF B1 B8
        cmp     #$EF                            ; 94D1 C9 EF
        bcc     @invalid                        ; 94D3 90 14
        lda     orientationTable,x              ; 94D5 BD 9C 8A
        clc                                     ; 94D8 18
        adc     tetriminoX                      ; 94D9 65 40
        cmp     #$0A                            ; 94DB C9 0A
        bcs     @invalid                        ; 94DD B0 0A
        inx                                     ; 94DF E8
        dec     generalCounter3                 ; 94E0 C6 AA
        bne     @checkSquare                    ; 94E2 D0 C6
        lda     #$00                            ; 94E4 A9 00
        sta     generalCounter                  ; 94E6 85 A8
        rts                                     ; 94E8 60

; ----------------------------------------------------------------------------
@invalid:
        lda     #$FF                            ; 94E9 A9 FF
        sta     generalCounter                  ; 94EB 85 A8
        rts                                     ; 94ED 60

; ----------------------------------------------------------------------------
render_mode_play_and_demo:
        lda     player1_playState               ; 94EE A5 68
        cmp     #$04                            ; 94F0 C9 04
        bne     @playStateNotDisplayLineClearingAnimation; 94F2 D0 2E
        lda     #$04                            ; 94F4 A9 04
        sta     playfieldAddr+1                 ; 94F6 85 B9
        lda     player1_rowY                    ; 94F8 A5 72
        sta     rowY                            ; 94FA 85 52
        lda     player1_completedRow            ; 94FC A5 6A
        sta     completedRow                    ; 94FE 85 4A
        lda     player1_completedRow+1          ; 9500 A5 6B
        sta     completedRow+1                  ; 9502 85 4B
        lda     player1_completedRow+2          ; 9504 A5 6C
        sta     completedRow+2                  ; 9506 85 4C
        lda     player1_completedRow+3          ; 9508 A5 6D
        sta     completedRow+3                  ; 950A 85 4D
        lda     player1_playState               ; 950C A5 68
        sta     playState                       ; 950E 85 48
        jsr     updateLineClearingAnimation     ; 9510 20 7F 97
        lda     rowY                            ; 9513 A5 52
        sta     player1_rowY                    ; 9515 85 72
        lda     playState                       ; 9517 A5 48
        sta     player1_playState               ; 9519 85 68
        lda     #$00                            ; 951B A9 00
        sta     player1_vramRow                 ; 951D 85 69
        jmp     @renderPlayer2Playfield         ; 951F 4C 3A 95

; ----------------------------------------------------------------------------
@playStateNotDisplayLineClearingAnimation:
        lda     player1_vramRow                 ; 9522 A5 69
        sta     vramRow                         ; 9524 85 49
        lda     #$04                            ; 9526 A9 04
        sta     playfieldAddr+1                 ; 9528 85 B9
        jsr     copyPlayfieldRowToVRAM          ; 952A 20 25 97
        jsr     copyPlayfieldRowToVRAM          ; 952D 20 25 97
        jsr     copyPlayfieldRowToVRAM          ; 9530 20 25 97
        jsr     copyPlayfieldRowToVRAM          ; 9533 20 25 97
        lda     vramRow                         ; 9536 A5 49
        sta     player1_vramRow                 ; 9538 85 69
@renderPlayer2Playfield:
        lda     numberOfPlayers                 ; 953A A5 BE
        cmp     #$02                            ; 953C C9 02
        bne     @renderLines                    ; 953E D0 4C
        lda     player2_playState               ; 9540 A5 88
        cmp     #$04                            ; 9542 C9 04
        bne     @player2PlayStateNotDisplayLineClearingAnimation; 9544 D0 2E
        lda     #$05                            ; 9546 A9 05
        sta     playfieldAddr+1                 ; 9548 85 B9
        lda     player2_rowY                    ; 954A A5 92
        sta     rowY                            ; 954C 85 52
        lda     player2_completedRow            ; 954E A5 8A
        sta     completedRow                    ; 9550 85 4A
        lda     player2_completedRow+1          ; 9552 A5 8B
        sta     completedRow+1                  ; 9554 85 4B
        lda     player2_completedRow+2          ; 9556 A5 8C
        sta     completedRow+2                  ; 9558 85 4C
        lda     player2_completedRow+3          ; 955A A5 8D
        sta     completedRow+3                  ; 955C 85 4D
        lda     player2_playState               ; 955E A5 88
        sta     playState                       ; 9560 85 48
        jsr     updateLineClearingAnimation     ; 9562 20 7F 97
        lda     rowY                            ; 9565 A5 52
        sta     player2_rowY                    ; 9567 85 92
        lda     playState                       ; 9569 A5 48
        sta     player2_playState               ; 956B 85 88
        lda     #$00                            ; 956D A9 00
        sta     player2_vramRow                 ; 956F 85 89
        jmp     @renderLines                    ; 9571 4C 8C 95

; ----------------------------------------------------------------------------
@player2PlayStateNotDisplayLineClearingAnimation:
        lda     player2_vramRow                 ; 9574 A5 89
        sta     vramRow                         ; 9576 85 49
        lda     #$05                            ; 9578 A9 05
        sta     playfieldAddr+1                 ; 957A 85 B9
        jsr     copyPlayfieldRowToVRAM          ; 957C 20 25 97
        jsr     copyPlayfieldRowToVRAM          ; 957F 20 25 97
        jsr     copyPlayfieldRowToVRAM          ; 9582 20 25 97
        jsr     copyPlayfieldRowToVRAM          ; 9585 20 25 97
        lda     vramRow                         ; 9588 A5 49
        sta     player2_vramRow                 ; 958A 85 89
@renderLines:
        lda     outOfDateRenderFlags            ; 958C A5 A3
        and     #$01                            ; 958E 29 01
        beq     @renderLevel                    ; 9590 F0 51
        lda     numberOfPlayers                 ; 9592 A5 BE
        cmp     #$02                            ; 9594 C9 02
        beq     @renderLinesTwoPlayers          ; 9596 F0 1D
        lda     #$20                            ; 9598 A9 20
        sta     PPUADDR                         ; 959A 8D 06 20
        lda     #$73                            ; 959D A9 73
        sta     PPUADDR                         ; 959F 8D 06 20
        lda     player1_lines+1                 ; 95A2 A5 71
        sta     PPUDATA                         ; 95A4 8D 07 20
        lda     player1_lines                   ; 95A7 A5 70
        jsr     twoDigsToPPU                    ; 95A9 20 12 97
        lda     outOfDateRenderFlags            ; 95AC A5 A3
        and     #$FE                            ; 95AE 29 FE
        sta     outOfDateRenderFlags            ; 95B0 85 A3
        jmp     @renderLevel                    ; 95B2 4C E3 95

; ----------------------------------------------------------------------------
@renderLinesTwoPlayers:
        lda     #$20                            ; 95B5 A9 20
        sta     PPUADDR                         ; 95B7 8D 06 20
        lda     #$68                            ; 95BA A9 68
        sta     PPUADDR                         ; 95BC 8D 06 20
        lda     player1_lines+1                 ; 95BF A5 71
        sta     PPUDATA                         ; 95C1 8D 07 20
        lda     player1_lines                   ; 95C4 A5 70
        jsr     twoDigsToPPU                    ; 95C6 20 12 97
        lda     #$20                            ; 95C9 A9 20
        sta     PPUADDR                         ; 95CB 8D 06 20
        lda     #$7A                            ; 95CE A9 7A
        sta     PPUADDR                         ; 95D0 8D 06 20
        lda     player2_lines+1                 ; 95D3 A5 91
        sta     PPUDATA                         ; 95D5 8D 07 20
        lda     player2_lines                   ; 95D8 A5 90
        jsr     twoDigsToPPU                    ; 95DA 20 12 97
        lda     outOfDateRenderFlags            ; 95DD A5 A3
        and     #$FE                            ; 95DF 29 FE
        sta     outOfDateRenderFlags            ; 95E1 85 A3
@renderLevel:
        lda     outOfDateRenderFlags            ; 95E3 A5 A3
        and     #$02                            ; 95E5 29 02
        beq     @renderScore                    ; 95E7 F0 25
        lda     numberOfPlayers                 ; 95E9 A5 BE
        cmp     #$02                            ; 95EB C9 02
        beq     @renderScore                    ; 95ED F0 1F
        ldx     player1_levelNumber             ; 95EF A6 64
        lda     levelDisplayTable,x             ; 95F1 BD B8 96
        sta     generalCounter                  ; 95F4 85 A8
        lda     #$22                            ; 95F6 A9 22
        sta     PPUADDR                         ; 95F8 8D 06 20
        lda     #$BA                            ; 95FB A9 BA
        sta     PPUADDR                         ; 95FD 8D 06 20
        lda     generalCounter                  ; 9600 A5 A8
        jsr     twoDigsToPPU                    ; 9602 20 12 97
        jsr     updatePaletteForLevel           ; 9605 20 08 98
        lda     outOfDateRenderFlags            ; 9608 A5 A3
        and     #$FD                            ; 960A 29 FD
        sta     outOfDateRenderFlags            ; 960C 85 A3
@renderScore:
        lda     numberOfPlayers                 ; 960E A5 BE
        cmp     #$02                            ; 9610 C9 02
        beq     @renderStats                    ; 9612 F0 25
        lda     outOfDateRenderFlags            ; 9614 A5 A3
        and     #$04                            ; 9616 29 04
        beq     @renderStats                    ; 9618 F0 1F
        lda     #$21                            ; 961A A9 21
        sta     PPUADDR                         ; 961C 8D 06 20
        lda     #$18                            ; 961F A9 18
        sta     PPUADDR                         ; 9621 8D 06 20
        lda     player1_score+2                 ; 9624 A5 75
        jsr     twoDigsToPPU                    ; 9626 20 12 97
        lda     player1_score+1                 ; 9629 A5 74
        jsr     twoDigsToPPU                    ; 962B 20 12 97
        lda     player1_score                   ; 962E A5 73
        jsr     twoDigsToPPU                    ; 9630 20 12 97
        lda     outOfDateRenderFlags            ; 9633 A5 A3
        and     #$FB                            ; 9635 29 FB
        sta     outOfDateRenderFlags            ; 9637 85 A3
@renderStats:
        lda     numberOfPlayers                 ; 9639 A5 BE
        cmp     #$02                            ; 963B C9 02
        beq     @renderTetrisFlashAndSound      ; 963D F0 34
        lda     outOfDateRenderFlags            ; 963F A5 A3
        and     #$40                            ; 9641 29 40
        beq     @renderTetrisFlashAndSound      ; 9643 F0 2E
        lda     #$00                            ; 9645 A9 00
        sta     tmpCurrentPiece                 ; 9647 85 B0
@renderPieceStat:
        lda     tmpCurrentPiece                 ; 9649 A5 B0
        asl     a                               ; 964B 0A
        tax                                     ; 964C AA
        lda     pieceToPpuStatAddr,x            ; 964D BD AA 96
        sta     PPUADDR                         ; 9650 8D 06 20
        lda     pieceToPpuStatAddr+1,x          ; 9653 BD AB 96
        sta     PPUADDR                         ; 9656 8D 06 20
        lda     statsByType+1,x                 ; 9659 BD F1 03
        sta     PPUDATA                         ; 965C 8D 07 20
        lda     statsByType,x                   ; 965F BD F0 03
        jsr     twoDigsToPPU                    ; 9662 20 12 97
        inc     tmpCurrentPiece                 ; 9665 E6 B0
        lda     tmpCurrentPiece                 ; 9667 A5 B0
        cmp     #$07                            ; 9669 C9 07
        bne     @renderPieceStat                ; 966B D0 DC
        lda     outOfDateRenderFlags            ; 966D A5 A3
        and     #$BF                            ; 966F 29 BF
        sta     outOfDateRenderFlags            ; 9671 85 A3
@renderTetrisFlashAndSound:
        lda     #$3F                            ; 9673 A9 3F
        sta     PPUADDR                         ; 9675 8D 06 20
        lda     #$0E                            ; 9678 A9 0E
        sta     PPUADDR                         ; 967A 8D 06 20
        ldx     #$00                            ; 967D A2 00
        lda     completedLines                  ; 967F A5 56
        cmp     #$04                            ; 9681 C9 04
        bne     @setPaletteColor                ; 9683 D0 13
        lda     frameCounter                    ; 9685 A5 B1
        and     #$03                            ; 9687 29 03
        bne     @setPaletteColor                ; 9689 D0 0D
        ldx     #$30                            ; 968B A2 30
        lda     frameCounter                    ; 968D A5 B1
        and     #$07                            ; 968F 29 07
        bne     @setPaletteColor                ; 9691 D0 05
        lda     #$09                            ; 9693 A9 09
        sta     soundEffectSlot1Init            ; 9695 8D F1 06
@setPaletteColor:
        stx     PPUDATA                         ; 9698 8E 07 20
        ldy     #$00                            ; 969B A0 00
        sty     ppuScrollX                      ; 969D 84 FD
        sty     PPUSCROLL                       ; 969F 8C 05 20
        ldy     #$00                            ; 96A2 A0 00
        sty     ppuScrollY                      ; 96A4 84 FC
        sty     PPUSCROLL                       ; 96A6 8C 05 20
        rts                                     ; 96A9 60

; ----------------------------------------------------------------------------
pieceToPpuStatAddr:
        .dbyt   $2186,$21C6,$2206,$2246         ; 96AA 21 86 21 C6 22 06 22 46
        .dbyt   $2286,$22C6,$2306               ; 96B2 22 86 22 C6 23 06
; ----------------------------------------------------------------------------
levelDisplayTable:
        .byte   $00,$01,$02,$03,$04,$05,$06,$07 ; 96B8 00 01 02 03 04 05 06 07
        .byte   $08,$09,$10,$11,$12,$13,$14,$15 ; 96C0 08 09 10 11 12 13 14 15
        .byte   $16,$17,$18,$19,$20,$21,$22,$23 ; 96C8 16 17 18 19 20 21 22 23
        .byte   $24,$25,$26,$27,$28,$29         ; 96D0 24 25 26 27 28 29
multBy10Table:
        .byte   $00,$0A,$14,$1E,$28,$32,$3C,$46 ; 96D6 00 0A 14 1E 28 32 3C 46
        .byte   $50,$5A,$64,$6E,$78,$82,$8C,$96 ; 96DE 50 5A 64 6E 78 82 8C 96
        .byte   $A0,$AA,$B4,$BE                 ; 96E6 A0 AA B4 BE
; ----------------------------------------------------------------------------
; addresses
vramPlayfieldRows:
        .word   $20C6,$20E6,$2106,$2126         ; 96EA C6 20 E6 20 06 21 26 21
        .word   $2146,$2166,$2186,$21A6         ; 96F2 46 21 66 21 86 21 A6 21
        .word   $21C6,$21E6,$2206,$2226         ; 96FA C6 21 E6 21 06 22 26 22
        .word   $2246,$2266,$2286,$22A6         ; 9702 46 22 66 22 86 22 A6 22
        .word   $22C6,$22E6,$2306,$2326         ; 970A C6 22 E6 22 06 23 26 23
; ----------------------------------------------------------------------------
twoDigsToPPU:
        sta     generalCounter                  ; 9712 85 A8
        and     #$F0                            ; 9714 29 F0
        lsr     a                               ; 9716 4A
        lsr     a                               ; 9717 4A
        lsr     a                               ; 9718 4A
        lsr     a                               ; 9719 4A
        sta     PPUDATA                         ; 971A 8D 07 20
        lda     generalCounter                  ; 971D A5 A8
        and     #$0F                            ; 971F 29 0F
        sta     PPUDATA                         ; 9721 8D 07 20
        rts                                     ; 9724 60

; ----------------------------------------------------------------------------
copyPlayfieldRowToVRAM:
        ldx     vramRow                         ; 9725 A6 49
        cpx     #$15                            ; 9727 E0 15
        bpl     @ret                            ; 9729 10 53
        lda     multBy10Table,x                 ; 972B BD D6 96
        tay                                     ; 972E A8
        txa                                     ; 972F 8A
        asl     a                               ; 9730 0A
        tax                                     ; 9731 AA
        inx                                     ; 9732 E8
        lda     vramPlayfieldRows,x             ; 9733 BD EA 96
        sta     PPUADDR                         ; 9736 8D 06 20
        dex                                     ; 9739 CA
        lda     numberOfPlayers                 ; 973A A5 BE
        cmp     #$01                            ; 973C C9 01
        beq     @onePlayer                      ; 973E F0 1E
        lda     playfieldAddr+1                 ; 9740 A5 B9
        cmp     #$05                            ; 9742 C9 05
        beq     @playerTwo                      ; 9744 F0 0C
        lda     vramPlayfieldRows,x             ; 9746 BD EA 96
        sec                                     ; 9749 38
        sbc     #$02                            ; 974A E9 02
        sta     PPUADDR                         ; 974C 8D 06 20
        jmp     @copyRow                        ; 974F 4C 67 97

; ----------------------------------------------------------------------------
@playerTwo:
        lda     vramPlayfieldRows,x             ; 9752 BD EA 96
        clc                                     ; 9755 18
        adc     #$0C                            ; 9756 69 0C
        sta     PPUADDR                         ; 9758 8D 06 20
        jmp     @copyRow                        ; 975B 4C 67 97

; ----------------------------------------------------------------------------
@onePlayer:
        lda     vramPlayfieldRows,x             ; 975E BD EA 96
        clc                                     ; 9761 18
        adc     #$06                            ; 9762 69 06
        sta     PPUADDR                         ; 9764 8D 06 20
@copyRow:
        ldx     #$0A                            ; 9767 A2 0A
@copyByte:
        lda     (playfieldAddr),y               ; 9769 B1 B8
        sta     PPUDATA                         ; 976B 8D 07 20
        iny                                     ; 976E C8
        dex                                     ; 976F CA
        bne     @copyByte                       ; 9770 D0 F7
        inc     vramRow                         ; 9772 E6 49
        lda     vramRow                         ; 9774 A5 49
        cmp     #$14                            ; 9776 C9 14
        bmi     @ret                            ; 9778 30 04
        lda     #$20                            ; 977A A9 20
        sta     vramRow                         ; 977C 85 49
@ret:   rts                                     ; 977E 60

; ----------------------------------------------------------------------------
updateLineClearingAnimation:
        lda     frameCounter                    ; 977F A5 B1
        and     #$03                            ; 9781 29 03
        bne     @ret                            ; 9783 D0 78
        lda     #$00                            ; 9785 A9 00
        sta     generalCounter3                 ; 9787 85 AA
@whileCounter3LessThan4:
        ldx     generalCounter3                 ; 9789 A6 AA
        lda     completedRow,x                  ; 978B B5 4A
        beq     @nextRow                        ; 978D F0 5C
        asl     a                               ; 978F 0A
        tay                                     ; 9790 A8
        lda     vramPlayfieldRows,y             ; 9791 B9 EA 96
        sta     generalCounter                  ; 9794 85 A8
        lda     numberOfPlayers                 ; 9796 A5 BE
        cmp     #$01                            ; 9798 C9 01
        bne     @twoPlayers                     ; 979A D0 0A
        lda     generalCounter                  ; 979C A5 A8
        clc                                     ; 979E 18
        adc     #$06                            ; 979F 69 06
        sta     generalCounter                  ; 97A1 85 A8
        jmp     @updateVRAM                     ; 97A3 4C BD 97

; ----------------------------------------------------------------------------
@twoPlayers:
        lda     playfieldAddr+1                 ; 97A6 A5 B9
        cmp     #$04                            ; 97A8 C9 04
        bne     @player2                        ; 97AA D0 0A
        lda     generalCounter                  ; 97AC A5 A8
        sec                                     ; 97AE 38
        sbc     #$02                            ; 97AF E9 02
        sta     generalCounter                  ; 97B1 85 A8
        jmp     @updateVRAM                     ; 97B3 4C BD 97

; ----------------------------------------------------------------------------
@player2:
        lda     generalCounter                  ; 97B6 A5 A8
        clc                                     ; 97B8 18
        adc     #$0C                            ; 97B9 69 0C
        sta     generalCounter                  ; 97BB 85 A8
@updateVRAM:
        iny                                     ; 97BD C8
        lda     vramPlayfieldRows,y             ; 97BE B9 EA 96
        sta     generalCounter2                 ; 97C1 85 A9
        sta     PPUADDR                         ; 97C3 8D 06 20
        ldx     rowY                            ; 97C6 A6 52
        lda     leftColumns,x                   ; 97C8 BD FE 97
        clc                                     ; 97CB 18
        adc     generalCounter                  ; 97CC 65 A8
        sta     PPUADDR                         ; 97CE 8D 06 20
        lda     #$FF                            ; 97D1 A9 FF
        sta     PPUDATA                         ; 97D3 8D 07 20
        lda     generalCounter2                 ; 97D6 A5 A9
        sta     PPUADDR                         ; 97D8 8D 06 20
        ldx     rowY                            ; 97DB A6 52
        lda     rightColumns,x                  ; 97DD BD 03 98
        clc                                     ; 97E0 18
        adc     generalCounter                  ; 97E1 65 A8
        sta     PPUADDR                         ; 97E3 8D 06 20
        lda     #$FF                            ; 97E6 A9 FF
        sta     PPUDATA                         ; 97E8 8D 07 20
@nextRow:
        inc     generalCounter3                 ; 97EB E6 AA
        lda     generalCounter3                 ; 97ED A5 AA
        cmp     #$04                            ; 97EF C9 04
        bne     @whileCounter3LessThan4         ; 97F1 D0 96
        inc     rowY                            ; 97F3 E6 52
        lda     rowY                            ; 97F5 A5 52
        cmp     #$05                            ; 97F7 C9 05
        bmi     @ret                            ; 97F9 30 02
        inc     playState                       ; 97FB E6 48
@ret:   rts                                     ; 97FD 60

; ----------------------------------------------------------------------------
leftColumns:
        .byte   $04,$03,$02,$01,$00             ; 97FE 04 03 02 01 00
rightColumns:
        .byte   $05,$06,$07,$08,$09             ; 9803 05 06 07 08 09
; ----------------------------------------------------------------------------
; Set Background palette 2 and Sprite palette 2
updatePaletteForLevel:
        lda     player1_levelNumber             ; 9808 A5 64
@mod10: cmp     #$0A                            ; 980A C9 0A
        bmi     @copyPalettes                   ; 980C 30 06
        sec                                     ; 980E 38
        sbc     #$0A                            ; 980F E9 0A
        jmp     @mod10                          ; 9811 4C 0A 98

; ----------------------------------------------------------------------------
@copyPalettes:
        asl     a                               ; 9814 0A
        asl     a                               ; 9815 0A
        tax                                     ; 9816 AA
        lda     #$00                            ; 9817 A9 00
        sta     generalCounter                  ; 9819 85 A8
@copyPalette:
        lda     #$3F                            ; 981B A9 3F
        sta     PPUADDR                         ; 981D 8D 06 20
        lda     #$08                            ; 9820 A9 08
        clc                                     ; 9822 18
        adc     generalCounter                  ; 9823 65 A8
        sta     PPUADDR                         ; 9825 8D 06 20
        lda     colorTable,x                    ; 9828 BD 4C 98
        sta     PPUDATA                         ; 982B 8D 07 20
        lda     colorTable+1,x                  ; 982E BD 4D 98
        sta     PPUDATA                         ; 9831 8D 07 20
        lda     colorTable+1+1,x                ; 9834 BD 4E 98
        sta     PPUDATA                         ; 9837 8D 07 20
        lda     colorTable+1+1+1,x              ; 983A BD 4F 98
        sta     PPUDATA                         ; 983D 8D 07 20
        lda     generalCounter                  ; 9840 A5 A8
        clc                                     ; 9842 18
        adc     #$10                            ; 9843 69 10
        sta     generalCounter                  ; 9845 85 A8
        cmp     #$20                            ; 9847 C9 20
        bne     @copyPalette                    ; 9849 D0 D0
        rts                                     ; 984B 60

; ----------------------------------------------------------------------------
; 4 bytes per level (bg, fg, c3, c4)
colorTable:
        .dbyt   $0F30,$2112,$0F30,$291A         ; 984C 0F 30 21 12 0F 30 29 1A
        .dbyt   $0F30,$2414,$0F30,$2A12         ; 9854 0F 30 24 14 0F 30 2A 12
        .dbyt   $0F30,$2B15,$0F30,$222B         ; 985C 0F 30 2B 15 0F 30 22 2B
        .dbyt   $0F30,$0016,$0F30,$0513         ; 9864 0F 30 00 16 0F 30 05 13
        .dbyt   $0F30,$1612,$0F30,$2716         ; 986C 0F 30 16 12 0F 30 27 16
; ----------------------------------------------------------------------------
; This increment and clamping is performed in copyPlayfieldRowToVRAM instead of here
noop_disabledVramRowIncr:
        rts                                     ; 9874 60

; ----------------------------------------------------------------------------
        inc     player1_vramRow                 ; 9875 E6 69
        lda     player1_vramRow                 ; 9877 A5 69
        cmp     #$14                            ; 9879 C9 14
        bmi     @player2                        ; 987B 30 04
        lda     #$20                            ; 987D A9 20
        sta     player1_vramRow                 ; 987F 85 69
@player2:
        inc     player2_vramRow                 ; 9881 E6 89
        lda     player2_vramRow                 ; 9883 A5 89
        cmp     #$14                            ; 9885 C9 14
        bmi     @ret                            ; 9887 30 04
        lda     #$20                            ; 9889 A9 20
        sta     player2_vramRow                 ; 988B 85 89
@ret:   rts                                     ; 988D 60

; ----------------------------------------------------------------------------
playState_spawnNextTetrimino:
        lda     vramRow                         ; 988E A5 49
        cmp     #$20                            ; 9890 C9 20
        bmi     @ret                            ; 9892 30 56
        lda     numberOfPlayers                 ; 9894 A5 BE
        cmp     #$01                            ; 9896 C9 01
        beq     @spawnPiece                     ; 9898 F0 20
        lda     twoPlayerPieceDelayCounter      ; 989A A5 A4
        cmp     #$00                            ; 989C C9 00
        bne     @twoPlayerWaiting               ; 989E D0 0E
        inc     twoPlayerPieceDelayCounter      ; 98A0 E6 A4
        lda     activePlayer                    ; 98A2 A5 B7
        sta     twoPlayerPieceDelayPlayer       ; 98A4 85 A5
        jsr     chooseNextTetrimino             ; 98A6 20 EB 98
        sta     twoPlayerPieceDelayPiece        ; 98A9 85 A6
        jmp     @ret                            ; 98AB 4C EA 98

; ----------------------------------------------------------------------------
@twoPlayerWaiting:
        lda     twoPlayerPieceDelayPlayer       ; 98AE A5 A5
        cmp     activePlayer                    ; 98B0 C5 B7
        bne     @ret                            ; 98B2 D0 36
        lda     twoPlayerPieceDelayCounter      ; 98B4 A5 A4
        cmp     #$1C                            ; 98B6 C9 1C
        bne     @ret                            ; 98B8 D0 30
@spawnPiece:
        lda     #$00                            ; 98BA A9 00
        sta     twoPlayerPieceDelayCounter      ; 98BC 85 A4
        sta     fallTimer                       ; 98BE 85 45
        sta     tetriminoY                      ; 98C0 85 41
        lda     #$01                            ; 98C2 A9 01
        sta     playState                       ; 98C4 85 48
        lda     #$05                            ; 98C6 A9 05
        sta     tetriminoX                      ; 98C8 85 40
        ldx     nextPiece                       ; 98CA A6 BF
        lda     spawnOrientationFromOrientation,x; 98CC BD 56 99
        sta     currentPiece                    ; 98CF 85 42
        jsr     incrementPieceStat              ; 98D1 20 69 99
        lda     numberOfPlayers                 ; 98D4 A5 BE
        cmp     #$01                            ; 98D6 C9 01
        beq     @onePlayerPieceSelection        ; 98D8 F0 07
        lda     twoPlayerPieceDelayPiece        ; 98DA A5 A6
        sta     nextPiece                       ; 98DC 85 BF
        jmp     @resetDownHold                  ; 98DE 4C E6 98

; ----------------------------------------------------------------------------
@onePlayerPieceSelection:
        jsr     chooseNextTetrimino             ; 98E1 20 EB 98
        sta     nextPiece                       ; 98E4 85 BF
@resetDownHold:
        lda     #$00                            ; 98E6 A9 00
        sta     autorepeatY                     ; 98E8 85 4E
@ret:   rts                                     ; 98EA 60

; ----------------------------------------------------------------------------
chooseNextTetrimino:
        lda     gameMode                        ; 98EB A5 C0
        cmp     #$05                            ; 98ED C9 05
        bne     pickRandomTetrimino             ; 98EF D0 12
        ldx     demoIndex                       ; 98F1 A6 D3
        inc     demoIndex                       ; 98F3 E6 D3
        lda     demoTetriminoTypeTable,x        ; 98F5 BD 00 DF
        lsr     a                               ; 98F8 4A
        lsr     a                               ; 98F9 4A
        lsr     a                               ; 98FA 4A
        lsr     a                               ; 98FB 4A
        and     #$07                            ; 98FC 29 07
        tax                                     ; 98FE AA
        lda     spawnTable,x                    ; 98FF BD 4E 99
        rts                                     ; 9902 60

; ----------------------------------------------------------------------------
pickRandomTetrimino:
        jsr     @realStart                      ; 9903 20 07 99
        rts                                     ; 9906 60

; ----------------------------------------------------------------------------
@realStart:
        inc     spawnCount                      ; 9907 E6 1A
        lda     rng_seed                        ; 9909 A5 17
        clc                                     ; 990B 18
        adc     spawnCount                      ; 990C 65 1A
        and     #$07                            ; 990E 29 07
        cmp     #$07                            ; 9910 C9 07
        beq     @invalidIndex                   ; 9912 F0 08
        tax                                     ; 9914 AA
        lda     spawnTable,x                    ; 9915 BD 4E 99
        cmp     spawnID                         ; 9918 C5 19
        bne     @useNewSpawnID                  ; 991A D0 1C
@invalidIndex:
        ldx     #$17                            ; 991C A2 17
        ldy     #$02                            ; 991E A0 02
        jsr     generateNextPseudorandomNumber  ; 9920 20 47 AB
        lda     rng_seed                        ; 9923 A5 17
        and     #$07                            ; 9925 29 07
        clc                                     ; 9927 18
        adc     spawnID                         ; 9928 65 19
@mod7:  cmp     #$07                            ; 992A C9 07
        bcc     @useRem                         ; 992C 90 06
        sec                                     ; 992E 38
        sbc     #$07                            ; 992F E9 07
        jmp     @mod7                           ; 9931 4C 2A 99

; ----------------------------------------------------------------------------
@useRem:tax                                     ; 9934 AA
        lda     spawnTable,x                    ; 9935 BD 4E 99
@useNewSpawnID:
        sta     spawnID                         ; 9938 85 19
        rts                                     ; 993A 60

; ----------------------------------------------------------------------------
tetriminoTypeFromOrientation:
        .byte   $00,$00,$00,$00,$01,$01,$01,$01 ; 993B 00 00 00 00 01 01 01 01
        .byte   $02,$02,$03,$04,$04,$05,$05,$05 ; 9943 02 02 03 04 04 05 05 05
        .byte   $05,$06,$06                     ; 994B 05 06 06
spawnTable:
        .byte   $02,$07,$08,$0A,$0B,$0E,$12     ; 994E 02 07 08 0A 0B 0E 12
; ----------------------------------------------------------------------------
        .byte   $02                             ; 9955 02
spawnOrientationFromOrientation:
        .byte   $02,$02,$02,$02,$07,$07,$07,$07 ; 9956 02 02 02 02 07 07 07 07
        .byte   $08,$08,$0A,$0B,$0B,$0E,$0E,$0E ; 995E 08 08 0A 0B 0B 0E 0E 0E
        .byte   $0E,$12,$12                     ; 9966 0E 12 12
; ----------------------------------------------------------------------------
incrementPieceStat:
        tax                                     ; 9969 AA
        lda     tetriminoTypeFromOrientation,x  ; 996A BD 3B 99
        asl     a                               ; 996D 0A
        tax                                     ; 996E AA
        lda     statsByType,x                   ; 996F BD F0 03
        clc                                     ; 9972 18
        adc     #$01                            ; 9973 69 01
        sta     generalCounter                  ; 9975 85 A8
        and     #$0F                            ; 9977 29 0F
        cmp     #$0A                            ; 9979 C9 0A
        bmi     @storeStat                      ; 997B 30 19
        lda     generalCounter                  ; 997D A5 A8
        clc                                     ; 997F 18
        adc     #$06                            ; 9980 69 06
        sta     generalCounter                  ; 9982 85 A8
        cmp     #$A0                            ; 9984 C9 A0
        bcc     @storeStat                      ; 9986 90 0E
        clc                                     ; 9988 18
        adc     #$60                            ; 9989 69 60
        sta     generalCounter                  ; 998B 85 A8
        lda     statsByType+1,x                 ; 998D BD F1 03
        clc                                     ; 9990 18
        adc     #$01                            ; 9991 69 01
        sta     statsByType+1,x                 ; 9993 9D F1 03
@storeStat:
        lda     generalCounter                  ; 9996 A5 A8
        sta     statsByType,x                   ; 9998 9D F0 03
        lda     outOfDateRenderFlags            ; 999B A5 A3
        ora     #$40                            ; 999D 09 40
        sta     outOfDateRenderFlags            ; 999F 85 A3
        rts                                     ; 99A1 60

; ----------------------------------------------------------------------------
playState_lockTetrimino:
        jsr     isPositionValid                 ; 99A2 20 8B 94
        beq     @notGameOver                    ; 99A5 F0 11
        lda     #$02                            ; 99A7 A9 02
        sta     soundEffectSlot0Init            ; 99A9 8D F0 06
        lda     #$0A                            ; 99AC A9 0A
        sta     playState                       ; 99AE 85 48
        lda     #$F0                            ; 99B0 A9 F0
        sta     curtainRow                      ; 99B2 85 58
        jsr     updateAudio2                    ; 99B4 20 03 E0
        rts                                     ; 99B7 60

; ----------------------------------------------------------------------------
@notGameOver:
        lda     vramRow                         ; 99B8 A5 49
        cmp     #$20                            ; 99BA C9 20
        bmi     @ret                            ; 99BC 30 52
        lda     tetriminoY                      ; 99BE A5 41
        asl     a                               ; 99C0 0A
        sta     generalCounter                  ; 99C1 85 A8
        asl     a                               ; 99C3 0A
        asl     a                               ; 99C4 0A
        clc                                     ; 99C5 18
        adc     generalCounter                  ; 99C6 65 A8
        adc     tetriminoX                      ; 99C8 65 40
        sta     generalCounter                  ; 99CA 85 A8
        lda     currentPiece                    ; 99CC A5 42
        asl     a                               ; 99CE 0A
        asl     a                               ; 99CF 0A
        sta     generalCounter2                 ; 99D0 85 A9
        asl     a                               ; 99D2 0A
        clc                                     ; 99D3 18
        adc     generalCounter2                 ; 99D4 65 A9
        tax                                     ; 99D6 AA
        ldy     #$00                            ; 99D7 A0 00
        lda     #$04                            ; 99D9 A9 04
        sta     generalCounter3                 ; 99DB 85 AA
; Copies a single square of the tetrimino to the playfield
@lockSquare:
        lda     orientationTable,x              ; 99DD BD 9C 8A
        asl     a                               ; 99E0 0A
        sta     generalCounter4                 ; 99E1 85 AB
        asl     a                               ; 99E3 0A
        asl     a                               ; 99E4 0A
        clc                                     ; 99E5 18
        adc     generalCounter4                 ; 99E6 65 AB
        clc                                     ; 99E8 18
        adc     generalCounter                  ; 99E9 65 A8
        sta     selectingLevelOrHeight          ; 99EB 85 AD
        inx                                     ; 99ED E8
        lda     orientationTable,x              ; 99EE BD 9C 8A
        sta     generalCounter5                 ; 99F1 85 AC
        inx                                     ; 99F3 E8
        lda     orientationTable,x              ; 99F4 BD 9C 8A
        clc                                     ; 99F7 18
        adc     selectingLevelOrHeight          ; 99F8 65 AD
        tay                                     ; 99FA A8
        lda     generalCounter5                 ; 99FB A5 AC
        sta     (playfieldAddr),y               ; 99FD 91 B8
        inx                                     ; 99FF E8
        dec     generalCounter3                 ; 9A00 C6 AA
        bne     @lockSquare                     ; 9A02 D0 D9
        lda     #$00                            ; 9A04 A9 00
        sta     lineIndex                       ; 9A06 85 57
        jsr     updatePlayfield                 ; 9A08 20 AF 9C
        jsr     updateMusicSpeed                ; 9A0B 20 17 9D
        inc     playState                       ; 9A0E E6 48
@ret:   rts                                     ; 9A10 60

; ----------------------------------------------------------------------------
playState_updateGameOverCurtain:
        lda     curtainRow                      ; 9A11 A5 58
        cmp     #$14                            ; 9A13 C9 14
        beq     @curtainFinished                ; 9A15 F0 30
        lda     frameCounter                    ; 9A17 A5 B1
        and     #$03                            ; 9A19 29 03
        bne     @ret                            ; 9A1B D0 29
        ldx     curtainRow                      ; 9A1D A6 58
        bmi     @incrementCurtainRow            ; 9A1F 30 1D
        lda     multBy10Table,x                 ; 9A21 BD D6 96
        tay                                     ; 9A24 A8
        lda     #$00                            ; 9A25 A9 00
        sta     generalCounter3                 ; 9A27 85 AA
        lda     #$13                            ; 9A29 A9 13
        sta     currentPiece                    ; 9A2B 85 42
@drawCurtainRow:
        lda     #$4F                            ; 9A2D A9 4F
        sta     (playfieldAddr),y               ; 9A2F 91 B8
        iny                                     ; 9A31 C8
        inc     generalCounter3                 ; 9A32 E6 AA
        lda     generalCounter3                 ; 9A34 A5 AA
        cmp     #$0A                            ; 9A36 C9 0A
        bne     @drawCurtainRow                 ; 9A38 D0 F3
        lda     curtainRow                      ; 9A3A A5 58
        sta     vramRow                         ; 9A3C 85 49
@incrementCurtainRow:
        inc     curtainRow                      ; 9A3E E6 58
        lda     curtainRow                      ; 9A40 A5 58
        cmp     #$14                            ; 9A42 C9 14
        bne     @ret                            ; 9A44 D0 00
@ret:   rts                                     ; 9A46 60

; ----------------------------------------------------------------------------
@curtainFinished:
        lda     numberOfPlayers                 ; 9A47 A5 BE
        cmp     #$02                            ; 9A49 C9 02
        beq     @exitGame                       ; 9A4B F0 17
        lda     player1_score+2                 ; 9A4D A5 75
        cmp     #$03                            ; 9A4F C9 03
        bcc     @checkForStartButton            ; 9A51 90 0B
        lda     #$80                            ; 9A53 A9 80
        jsr     sleep_for_a_vblanks             ; 9A55 20 59 A4
        jsr     endingAnimation_maybe           ; 9A58 20 3A 9E
        jmp     @exitGame                       ; 9A5B 4C 64 9A

; ----------------------------------------------------------------------------
@checkForStartButton:
        lda     newlyPressedButtons_player1     ; 9A5E A5 F5
        cmp     #$10                            ; 9A60 C9 10
        bne     @ret2                           ; 9A62 D0 06
@exitGame:
        lda     #$00                            ; 9A64 A9 00
        sta     playState                       ; 9A66 85 48
        sta     newlyPressedButtons_player1     ; 9A68 85 F5
@ret2:  rts                                     ; 9A6A 60

; ----------------------------------------------------------------------------
playState_checkForCompletedRows:
        lda     vramRow                         ; 9A6B A5 49
        cmp     #$20                            ; 9A6D C9 20
        bpl     @updatePlayfieldComplete        ; 9A6F 10 03
        jmp     @ret                            ; 9A71 4C 02 9B

; ----------------------------------------------------------------------------
@updatePlayfieldComplete:
        lda     tetriminoY                      ; 9A74 A5 41
        sec                                     ; 9A76 38
        sbc     #$02                            ; 9A77 E9 02
        bpl     @yInRange                       ; 9A79 10 02
        lda     #$00                            ; 9A7B A9 00
@yInRange:
        clc                                     ; 9A7D 18
        adc     lineIndex                       ; 9A7E 65 57
        sta     generalCounter2                 ; 9A80 85 A9
        asl     a                               ; 9A82 0A
        sta     generalCounter                  ; 9A83 85 A8
        asl     a                               ; 9A85 0A
        asl     a                               ; 9A86 0A
        clc                                     ; 9A87 18
        adc     generalCounter                  ; 9A88 65 A8
        sta     generalCounter                  ; 9A8A 85 A8
        tay                                     ; 9A8C A8
        ldx     #$0A                            ; 9A8D A2 0A
@checkIfRowComplete:
        lda     (playfieldAddr),y               ; 9A8F B1 B8
        cmp     #$EF                            ; 9A91 C9 EF
        beq     @rowNotComplete                 ; 9A93 F0 37
        iny                                     ; 9A95 C8
        dex                                     ; 9A96 CA
        bne     @checkIfRowComplete             ; 9A97 D0 F6
        lda     #$0A                            ; 9A99 A9 0A
        sta     soundEffectSlot1Init            ; 9A9B 8D F1 06
        inc     completedLines                  ; 9A9E E6 56
        ldx     lineIndex                       ; 9AA0 A6 57
        lda     generalCounter2                 ; 9AA2 A5 A9
        sta     completedRow,x                  ; 9AA4 95 4A
        ldy     generalCounter                  ; 9AA6 A4 A8
        dey                                     ; 9AA8 88
@movePlayfieldDownOneRow:
        lda     (playfieldAddr),y               ; 9AA9 B1 B8
        ldx     #$0A                            ; 9AAB A2 0A
        stx     playfieldAddr                   ; 9AAD 86 B8
        sta     (playfieldAddr),y               ; 9AAF 91 B8
        lda     #$00                            ; 9AB1 A9 00
        sta     playfieldAddr                   ; 9AB3 85 B8
        dey                                     ; 9AB5 88
        cpy     #$FF                            ; 9AB6 C0 FF
        bne     @movePlayfieldDownOneRow        ; 9AB8 D0 EF
        lda     #$EF                            ; 9ABA A9 EF
        ldy     #$00                            ; 9ABC A0 00
@clearRowTopRow:
        sta     (playfieldAddr),y               ; 9ABE 91 B8
        iny                                     ; 9AC0 C8
        cpy     #$0A                            ; 9AC1 C0 0A
        bne     @clearRowTopRow                 ; 9AC3 D0 F9
        lda     #$13                            ; 9AC5 A9 13
        sta     currentPiece                    ; 9AC7 85 42
        jmp     @incrementLineIndex             ; 9AC9 4C D2 9A

; ----------------------------------------------------------------------------
@rowNotComplete:
        ldx     lineIndex                       ; 9ACC A6 57
        lda     #$00                            ; 9ACE A9 00
        sta     completedRow,x                  ; 9AD0 95 4A
@incrementLineIndex:
        inc     lineIndex                       ; 9AD2 E6 57
        lda     lineIndex                       ; 9AD4 A5 57
        cmp     #$04                            ; 9AD6 C9 04
        bmi     @ret                            ; 9AD8 30 28
        ldy     completedLines                  ; 9ADA A4 56
        lda     garbageLines,y                  ; 9ADC B9 53 9B
        clc                                     ; 9ADF 18
        adc     pendingGarbageInactivePlayer    ; 9AE0 65 BC
        sta     pendingGarbageInactivePlayer    ; 9AE2 85 BC
        lda     #$00                            ; 9AE4 A9 00
        sta     vramRow                         ; 9AE6 85 49
        sta     rowY                            ; 9AE8 85 52
        lda     completedLines                  ; 9AEA A5 56
        cmp     #$04                            ; 9AEC C9 04
        bne     @skipTetrisSoundEffect          ; 9AEE D0 05
        lda     #$04                            ; 9AF0 A9 04
        sta     soundEffectSlot1Init            ; 9AF2 8D F1 06
@skipTetrisSoundEffect:
        inc     playState                       ; 9AF5 E6 48
        lda     completedLines                  ; 9AF7 A5 56
        bne     @ret                            ; 9AF9 D0 07
        inc     playState                       ; 9AFB E6 48
        lda     #$07                            ; 9AFD A9 07
        sta     soundEffectSlot1Init            ; 9AFF 8D F1 06
@ret:   rts                                     ; 9B02 60

; ----------------------------------------------------------------------------
playState_receiveGarbage:
        lda     numberOfPlayers                 ; 9B03 A5 BE
        cmp     #$01                            ; 9B05 C9 01
        beq     @ret                            ; 9B07 F0 47
        ldy     pendingGarbage                  ; 9B09 A4 BB
        beq     @ret                            ; 9B0B F0 43
        lda     vramRow                         ; 9B0D A5 49
        cmp     #$20                            ; 9B0F C9 20
        bmi     @delay                          ; 9B11 30 3F
        lda     multBy10Table,y                 ; 9B13 B9 D6 96
        sta     generalCounter2                 ; 9B16 85 A9
        lda     #$00                            ; 9B18 A9 00
        sta     generalCounter                  ; 9B1A 85 A8
@shiftPlayfieldUp:
        ldy     generalCounter2                 ; 9B1C A4 A9
        lda     (playfieldAddr),y               ; 9B1E B1 B8
        ldy     generalCounter                  ; 9B20 A4 A8
        sta     (playfieldAddr),y               ; 9B22 91 B8
        inc     generalCounter                  ; 9B24 E6 A8
        inc     generalCounter2                 ; 9B26 E6 A9
        lda     generalCounter2                 ; 9B28 A5 A9
        cmp     #$C8                            ; 9B2A C9 C8
        bne     @shiftPlayfieldUp               ; 9B2C D0 EE
        iny                                     ; 9B2E C8
        ldx     #$00                            ; 9B2F A2 00
@fillGarbage:
        cpx     garbageHole                     ; 9B31 E4 5A
        beq     @hole                           ; 9B33 F0 05
        lda     #$78                            ; 9B35 A9 78
        jmp     @set                            ; 9B37 4C 3C 9B

; ----------------------------------------------------------------------------
@hole:  lda     #$FF                            ; 9B3A A9 FF
@set:   sta     (playfieldAddr),y               ; 9B3C 91 B8
        inx                                     ; 9B3E E8
        cpx     #$0A                            ; 9B3F E0 0A
        bne     @inc                            ; 9B41 D0 02
        ldx     #$00                            ; 9B43 A2 00
@inc:   iny                                     ; 9B45 C8
        cpy     #$C8                            ; 9B46 C0 C8
        bne     @fillGarbage                    ; 9B48 D0 E7
        lda     #$00                            ; 9B4A A9 00
        sta     pendingGarbage                  ; 9B4C 85 BB
        sta     vramRow                         ; 9B4E 85 49
@ret:   inc     playState                       ; 9B50 E6 48
@delay: rts                                     ; 9B52 60

; ----------------------------------------------------------------------------
garbageLines:
        .byte   $00,$00,$01,$02,$04             ; 9B53 00 00 01 02 04
; ----------------------------------------------------------------------------
playState_updateLinesAndStatistics:
        jsr     updateMusicSpeed                ; 9B58 20 17 9D
        lda     completedLines                  ; 9B5B A5 56
        bne     @linesCleared                   ; 9B5D D0 03
        jmp     @addHoldDownPoints              ; 9B5F 4C FE 9B

; ----------------------------------------------------------------------------
@linesCleared:
        tax                                     ; 9B62 AA
        dex                                     ; 9B63 CA
        lda     lineClearStatsByType,x          ; 9B64 B5 D8
        clc                                     ; 9B66 18
        adc     #$01                            ; 9B67 69 01
        sta     lineClearStatsByType,x          ; 9B69 95 D8
        and     #$0F                            ; 9B6B 29 0F
        cmp     #$0A                            ; 9B6D C9 0A
        bmi     @noCarry                        ; 9B6F 30 07
        lda     lineClearStatsByType,x          ; 9B71 B5 D8
        clc                                     ; 9B73 18
        adc     #$06                            ; 9B74 69 06
        sta     lineClearStatsByType,x          ; 9B76 95 D8
@noCarry:
        lda     outOfDateRenderFlags            ; 9B78 A5 A3
        ora     #$01                            ; 9B7A 09 01
        sta     outOfDateRenderFlags            ; 9B7C 85 A3
        lda     gameType                        ; 9B7E A5 C1
        beq     @gameTypeA                      ; 9B80 F0 24
        lda     completedLines                  ; 9B82 A5 56
        sta     generalCounter                  ; 9B84 85 A8
        lda     lines                           ; 9B86 A5 50
        sec                                     ; 9B88 38
        sbc     generalCounter                  ; 9B89 E5 A8
        sta     lines                           ; 9B8B 85 50
        bpl     @checkForBorrow                 ; 9B8D 10 07
        lda     #$00                            ; 9B8F A9 00
        sta     lines                           ; 9B91 85 50
        jmp     @addHoldDownPoints              ; 9B93 4C FE 9B

; ----------------------------------------------------------------------------
@checkForBorrow:
        and     #$0F                            ; 9B96 29 0F
        cmp     #$0A                            ; 9B98 C9 0A
        bmi     @addHoldDownPoints              ; 9B9A 30 62
        lda     lines                           ; 9B9C A5 50
        sec                                     ; 9B9E 38
        sbc     #$06                            ; 9B9F E9 06
        sta     lines                           ; 9BA1 85 50
        jmp     @addHoldDownPoints              ; 9BA3 4C FE 9B

; ----------------------------------------------------------------------------
@gameTypeA:
        ldx     completedLines                  ; 9BA6 A6 56
@incrementLines:
        inc     lines                           ; 9BA8 E6 50
        lda     lines                           ; 9BAA A5 50
        and     #$0F                            ; 9BAC 29 0F
        cmp     #$0A                            ; 9BAE C9 0A
        bmi     @checkLevelUp                   ; 9BB0 30 15
        lda     lines                           ; 9BB2 A5 50
        clc                                     ; 9BB4 18
        adc     #$06                            ; 9BB5 69 06
        sta     lines                           ; 9BB7 85 50
        and     #$F0                            ; 9BB9 29 F0
        cmp     #$A0                            ; 9BBB C9 A0
        bcc     @checkLevelUp                   ; 9BBD 90 08
        lda     lines                           ; 9BBF A5 50
        and     #$0F                            ; 9BC1 29 0F
        sta     lines                           ; 9BC3 85 50
        inc     lines+1                         ; 9BC5 E6 51
@checkLevelUp:
        lda     lines                           ; 9BC7 A5 50
        and     #$0F                            ; 9BC9 29 0F
        bne     @lineLoop                       ; 9BCB D0 2E
        jmp     @compareLinesAndLevel           ; 9BCD 4C D0 9B

; ----------------------------------------------------------------------------
@compareLinesAndLevel:
        lda     lines+1                         ; 9BD0 A5 51
        sta     generalCounter2                 ; 9BD2 85 A9
        lda     lines                           ; 9BD4 A5 50
        sta     generalCounter                  ; 9BD6 85 A8
        lsr     generalCounter2                 ; 9BD8 46 A9
        ror     generalCounter                  ; 9BDA 66 A8
        lsr     generalCounter2                 ; 9BDC 46 A9
        ror     generalCounter                  ; 9BDE 66 A8
        lsr     generalCounter2                 ; 9BE0 46 A9
        ror     generalCounter                  ; 9BE2 66 A8
        lsr     generalCounter2                 ; 9BE4 46 A9
        ror     generalCounter                  ; 9BE6 66 A8
        lda     levelNumber                     ; 9BE8 A5 44
        cmp     generalCounter                  ; 9BEA C5 A8
        bpl     @lineLoop                       ; 9BEC 10 0D
        inc     levelNumber                     ; 9BEE E6 44
        lda     #$06                            ; 9BF0 A9 06
        sta     soundEffectSlot1Init            ; 9BF2 8D F1 06
        lda     outOfDateRenderFlags            ; 9BF5 A5 A3
        ora     #$02                            ; 9BF7 09 02
        sta     outOfDateRenderFlags            ; 9BF9 85 A3
@lineLoop:
        dex                                     ; 9BFB CA
        bne     @incrementLines                 ; 9BFC D0 AA
@addHoldDownPoints:
        lda     holdDownPoints                  ; 9BFE A5 4F
        cmp     #$02                            ; 9C00 C9 02
        bmi     @addLineClearPoints             ; 9C02 30 29
        clc                                     ; 9C04 18
        dec     score                           ; 9C05 C6 53
        adc     score                           ; 9C07 65 53
        sta     score                           ; 9C09 85 53
        and     #$0F                            ; 9C0B 29 0F
        cmp     #$0A                            ; 9C0D C9 0A
        bcc     @score0High                     ; 9C0F 90 07
        lda     score                           ; 9C11 A5 53
        clc                                     ; 9C13 18
        adc     #$06                            ; 9C14 69 06
        sta     score                           ; 9C16 85 53
@score0High:
        lda     score                           ; 9C18 A5 53
        and     #$F0                            ; 9C1A 29 F0
        cmp     #$A0                            ; 9C1C C9 A0
        bcc     @markRenderOutOfDate            ; 9C1E 90 07
        clc                                     ; 9C20 18
        adc     #$60                            ; 9C21 69 60
        sta     score                           ; 9C23 85 53
        inc     score+1                         ; 9C25 E6 54
@markRenderOutOfDate:
        lda     outOfDateRenderFlags            ; 9C27 A5 A3
        ora     #$04                            ; 9C29 09 04
        sta     outOfDateRenderFlags            ; 9C2B 85 A3
@addLineClearPoints:
        lda     #$00                            ; 9C2D A9 00
        sta     holdDownPoints                  ; 9C2F 85 4F
        lda     levelNumber                     ; 9C31 A5 44
        sta     generalCounter                  ; 9C33 85 A8
        inc     generalCounter                  ; 9C35 E6 A8
@levelLoop:
        lda     completedLines                  ; 9C37 A5 56
        asl     a                               ; 9C39 0A
        tax                                     ; 9C3A AA
        lda     pointsTable,x                   ; 9C3B BD A5 9C
        clc                                     ; 9C3E 18
        adc     score                           ; 9C3F 65 53
        sta     score                           ; 9C41 85 53
        cmp     #$A0                            ; 9C43 C9 A0
        bcc     @score1AddPoints                ; 9C45 90 07
        clc                                     ; 9C47 18
        adc     #$60                            ; 9C48 69 60
        sta     score                           ; 9C4A 85 53
        inc     score+1                         ; 9C4C E6 54
@score1AddPoints:
        inx                                     ; 9C4E E8
        lda     pointsTable,x                   ; 9C4F BD A5 9C
        clc                                     ; 9C52 18
        adc     score+1                         ; 9C53 65 54
        sta     score+1                         ; 9C55 85 54
        and     #$0F                            ; 9C57 29 0F
        cmp     #$0A                            ; 9C59 C9 0A
        bcc     @score1High                     ; 9C5B 90 07
        lda     score+1                         ; 9C5D A5 54
        clc                                     ; 9C5F 18
        adc     #$06                            ; 9C60 69 06
        sta     score+1                         ; 9C62 85 54
@score1High:
        lda     score+1                         ; 9C64 A5 54
        and     #$F0                            ; 9C66 29 F0
        cmp     #$A0                            ; 9C68 C9 A0
        bcc     @score2Low                      ; 9C6A 90 09
        lda     score+1                         ; 9C6C A5 54
        clc                                     ; 9C6E 18
        adc     #$60                            ; 9C6F 69 60
        sta     score+1                         ; 9C71 85 54
        inc     score+2                         ; 9C73 E6 55
@score2Low:
        lda     score+2                         ; 9C75 A5 55
        and     #$0F                            ; 9C77 29 0F
        cmp     #$0A                            ; 9C79 C9 0A
        bcc     @score2High                     ; 9C7B 90 07
        lda     score+2                         ; 9C7D A5 55
        clc                                     ; 9C7F 18
        adc     #$06                            ; 9C80 69 06
        sta     score+2                         ; 9C82 85 55
@score2High:
        lda     score+2                         ; 9C84 A5 55
        and     #$F0                            ; 9C86 29 F0
        cmp     #$A0                            ; 9C88 C9 A0
        bcc     @levelLoopCheck                 ; 9C8A 90 08
        lda     #$99                            ; 9C8C A9 99
        sta     score                           ; 9C8E 85 53
        sta     score+1                         ; 9C90 85 54
        sta     score+2                         ; 9C92 85 55
@levelLoopCheck:
        dec     generalCounter                  ; 9C94 C6 A8
        bne     @levelLoop                      ; 9C96 D0 9F
        lda     outOfDateRenderFlags            ; 9C98 A5 A3
        ora     #$04                            ; 9C9A 09 04
        sta     outOfDateRenderFlags            ; 9C9C 85 A3
        lda     #$00                            ; 9C9E A9 00
        sta     completedLines                  ; 9CA0 85 56
        inc     playState                       ; 9CA2 E6 48
        rts                                     ; 9CA4 60

; ----------------------------------------------------------------------------
pointsTable:
        .word   $0000,$0040,$0100,$0300         ; 9CA5 00 00 40 00 00 01 00 03
        .word   $1200                           ; 9CAD 00 12
; ----------------------------------------------------------------------------
updatePlayfield:
        ldx     tetriminoY                      ; 9CAF A6 41
        dex                                     ; 9CB1 CA
        dex                                     ; 9CB2 CA
        txa                                     ; 9CB3 8A
        bpl     @rowInRange                     ; 9CB4 10 02
        lda     #$00                            ; 9CB6 A9 00
@rowInRange:
        cmp     vramRow                         ; 9CB8 C5 49
        bpl     @ret                            ; 9CBA 10 02
        sta     vramRow                         ; 9CBC 85 49
@ret:   rts                                     ; 9CBE 60

; ----------------------------------------------------------------------------
gameModeState_handleGameOver:
        lda     #$05                            ; 9CBF A9 05
        sta     generalCounter2                 ; 9CC1 85 A9
        lda     player1_playState               ; 9CC3 A5 68
        cmp     #$00                            ; 9CC5 C9 00
        beq     @gameOver                       ; 9CC7 F0 10
        lda     numberOfPlayers                 ; 9CC9 A5 BE
        cmp     #$01                            ; 9CCB C9 01
        beq     @ret                            ; 9CCD F0 45
        lda     #$04                            ; 9CCF A9 04
        sta     generalCounter2                 ; 9CD1 85 A9
        lda     player2_playState               ; 9CD3 A5 88
        cmp     #$00                            ; 9CD5 C9 00
        bne     @ret                            ; 9CD7 D0 3B
@gameOver:
        lda     numberOfPlayers                 ; 9CD9 A5 BE
        cmp     #$01                            ; 9CDB C9 01
        beq     @onePlayerGameOver              ; 9CDD F0 05
        lda     #$09                            ; 9CDF A9 09
        sta     gameModeState                   ; 9CE1 85 A7
        rts                                     ; 9CE3 60

; ----------------------------------------------------------------------------
@onePlayerGameOver:
        lda     #$03                            ; 9CE4 A9 03
        sta     renderMode                      ; 9CE6 85 BD
        lda     numberOfPlayers                 ; 9CE8 A5 BE
        cmp     #$01                            ; 9CEA C9 01
        bne     @resetGameState                 ; 9CEC D0 03
        jsr     handleHighScoreIfNecessary      ; 9CEE 20 EE A0
@resetGameState:
        lda     #$01                            ; 9CF1 A9 01
        sta     player1_playState               ; 9CF3 85 68
        sta     player2_playState               ; 9CF5 85 88
        lda     #$EF                            ; 9CF7 A9 EF
        ldx     #$04                            ; 9CF9 A2 04
        ldy     #$05                            ; 9CFB A0 05
        jsr     memset_page                     ; 9CFD 20 6A AC
        lda     #$00                            ; 9D00 A9 00
        sta     player1_vramRow                 ; 9D02 85 69
        sta     player2_vramRow                 ; 9D04 85 89
        lda     #$01                            ; 9D06 A9 01
        sta     player1_playState               ; 9D08 85 68
        sta     player2_playState               ; 9D0A 85 88
        jsr     updateAudioWaitForNmiAndResetOamStaging; 9D0C 20 2F AA
        lda     #$03                            ; 9D0F A9 03
        sta     gameMode                        ; 9D11 85 C0
        rts                                     ; 9D13 60

; ----------------------------------------------------------------------------
@ret:   inc     gameModeState                   ; 9D14 E6 A7
        rts                                     ; 9D16 60

; ----------------------------------------------------------------------------
updateMusicSpeed:
        ldx     #$05                            ; 9D17 A2 05
        lda     multBy10Table,x                 ; 9D19 BD D6 96
        tay                                     ; 9D1C A8
        ldx     #$0A                            ; 9D1D A2 0A
@checkForBlockInRow:
        lda     (playfieldAddr),y               ; 9D1F B1 B8
        cmp     #$EF                            ; 9D21 C9 EF
        bne     @foundBlockInRow                ; 9D23 D0 17
        iny                                     ; 9D25 C8
        dex                                     ; 9D26 CA
        bne     @checkForBlockInRow             ; 9D27 D0 F6
        lda     allegro                         ; 9D29 A5 BA
        beq     @ret                            ; 9D2B F0 23
        lda     #$00                            ; 9D2D A9 00
        sta     allegro                         ; 9D2F 85 BA
        ldx     musicType                       ; 9D31 A6 C2
        lda     musicSelectionTable,x           ; 9D33 BD D2 85
        jsr     setMusicTrack                   ; 9D36 20 07 9E
        jmp     @ret                            ; 9D39 4C 50 9D

; ----------------------------------------------------------------------------
@foundBlockInRow:
        lda     allegro                         ; 9D3C A5 BA
        bne     @ret                            ; 9D3E D0 10
        lda     #$FF                            ; 9D40 A9 FF
        sta     allegro                         ; 9D42 85 BA
        lda     musicType                       ; 9D44 A5 C2
        clc                                     ; 9D46 18
        adc     #$04                            ; 9D47 69 04
        tax                                     ; 9D49 AA
        lda     musicSelectionTable,x           ; 9D4A BD D2 85
        jsr     setMusicTrack                   ; 9D4D 20 07 9E
@ret:   rts                                     ; 9D50 60

; ----------------------------------------------------------------------------
pollControllerButtons:
        lda     gameMode                        ; 9D51 A5 C0
        cmp     #$05                            ; 9D53 C9 05
        beq     @demoGameMode                   ; 9D55 F0 04
        jsr     pollController                  ; 9D57 20 9D AB
        rts                                     ; 9D5A 60

; ----------------------------------------------------------------------------
@demoGameMode:
        lda     demo_recording                  ; 9D5B A5 D0
        cmp     #$FF                            ; 9D5D C9 FF
        beq     @recording                      ; 9D5F F0 4F
        jsr     pollController                  ; 9D61 20 9D AB
        lda     newlyPressedButtons_player1     ; 9D64 A5 F5
        cmp     #$10                            ; 9D66 C9 10
        beq     @startButtonPressed             ; 9D68 F0 39
        lda     demo_repeats                    ; 9D6A A5 CF
        beq     @finishedMove                   ; 9D6C F0 05
        dec     demo_repeats                    ; 9D6E C6 CF
        jmp     @moveInProgress                 ; 9D70 4C 9A 9D

; ----------------------------------------------------------------------------
@finishedMove:
        ldx     #$00                            ; 9D73 A2 00
        lda     (demoButtonsAddr,x)             ; 9D75 A1 D1
        sta     generalCounter                  ; 9D77 85 A8
        jsr     demoButtonsTable_indexIncr      ; 9D79 20 E8 9D
        lda     demo_heldButtons                ; 9D7C A5 CE
        eor     generalCounter                  ; 9D7E 45 A8
        and     generalCounter                  ; 9D80 25 A8
        sta     newlyPressedButtons_player1     ; 9D82 85 F5
        lda     generalCounter                  ; 9D84 A5 A8
        sta     demo_heldButtons                ; 9D86 85 CE
        ldx     #$00                            ; 9D88 A2 00
        lda     (demoButtonsAddr,x)             ; 9D8A A1 D1
        sta     demo_repeats                    ; 9D8C 85 CF
        jsr     demoButtonsTable_indexIncr      ; 9D8E 20 E8 9D
        lda     demoButtonsAddr+1               ; 9D91 A5 D2
        cmp     #$DF                            ; 9D93 C9 DF
        beq     @ret                            ; 9D95 F0 0B
        jmp     @holdButtons                    ; 9D97 4C 9E 9D

; ----------------------------------------------------------------------------
@moveInProgress:
        lda     #$00                            ; 9D9A A9 00
        sta     newlyPressedButtons_player1     ; 9D9C 85 F5
@holdButtons:
        lda     demo_heldButtons                ; 9D9E A5 CE
        sta     heldButtons_player1             ; 9DA0 85 F7
@ret:   rts                                     ; 9DA2 60

; ----------------------------------------------------------------------------
@startButtonPressed:
        lda     #$DD                            ; 9DA3 A9 DD
        sta     demoButtonsAddr+1               ; 9DA5 85 D2
        lda     #$00                            ; 9DA7 A9 00
        sta     frameCounter+1                  ; 9DA9 85 B2
        lda     #$01                            ; 9DAB A9 01
        sta     gameMode                        ; 9DAD 85 C0
        rts                                     ; 9DAF 60

; ----------------------------------------------------------------------------
@recording:
        jsr     pollController                  ; 9DB0 20 9D AB
        lda     gameMode                        ; 9DB3 A5 C0
        cmp     #$05                            ; 9DB5 C9 05
        bne     @ret2                           ; 9DB7 D0 2E
        lda     demo_recording                  ; 9DB9 A5 D0
        cmp     #$FF                            ; 9DBB C9 FF
        bne     @ret2                           ; 9DBD D0 28
        lda     heldButtons_player1             ; 9DBF A5 F7
        cmp     demo_heldButtons                ; 9DC1 C5 CE
        beq     @buttonsNotChanged              ; 9DC3 F0 1F
        ldx     #$00                            ; 9DC5 A2 00
        lda     demo_heldButtons                ; 9DC7 A5 CE
        sta     (demoButtonsAddr,x)             ; 9DC9 81 D1
        jsr     demoButtonsTable_indexIncr      ; 9DCB 20 E8 9D
        lda     demo_repeats                    ; 9DCE A5 CF
        sta     (demoButtonsAddr,x)             ; 9DD0 81 D1
        jsr     demoButtonsTable_indexIncr      ; 9DD2 20 E8 9D
        lda     demoButtonsAddr+1               ; 9DD5 A5 D2
        cmp     #$DF                            ; 9DD7 C9 DF
        beq     @ret2                           ; 9DD9 F0 0C
        lda     heldButtons_player1             ; 9DDB A5 F7
        sta     demo_heldButtons                ; 9DDD 85 CE
        lda     #$00                            ; 9DDF A9 00
        sta     demo_repeats                    ; 9DE1 85 CF
        rts                                     ; 9DE3 60

; ----------------------------------------------------------------------------
@buttonsNotChanged:
        inc     demo_repeats                    ; 9DE4 E6 CF
        rts                                     ; 9DE6 60

; ----------------------------------------------------------------------------
@ret2:  rts                                     ; 9DE7 60

; ----------------------------------------------------------------------------
demoButtonsTable_indexIncr:
        lda     demoButtonsAddr                 ; 9DE8 A5 D1
        clc                                     ; 9DEA 18
        adc     #$01                            ; 9DEB 69 01
        sta     demoButtonsAddr                 ; 9DED 85 D1
        lda     #$00                            ; 9DEF A9 00
        adc     demoButtonsAddr+1               ; 9DF1 65 D2
        sta     demoButtonsAddr+1               ; 9DF3 85 D2
        rts                                     ; 9DF5 60

; ----------------------------------------------------------------------------
gameMode_startDemo:
        lda     #$00                            ; 9DF6 A9 00
        sta     gameType                        ; 9DF8 85 C1
        sta     player1_startLevel              ; 9DFA 85 67
        sta     gameModeState                   ; 9DFC 85 A7
        sta     player1_playState               ; 9DFE 85 68
        lda     #$05                            ; 9E00 A9 05
        sta     gameMode                        ; 9E02 85 C0
        jmp     gameMode_playAndEndingHighScore_jmp; 9E04 4C 5D 81

; ----------------------------------------------------------------------------
; canon is adjustMusicSpeed
setMusicTrack:
        sta     musicTrack                      ; 9E07 8D F5 06
        lda     gameMode                        ; 9E0A A5 C0
        cmp     #$05                            ; 9E0C C9 05
        bne     @ret                            ; 9E0E D0 05
        lda     #$FF                            ; 9E10 A9 FF
        sta     musicTrack                      ; 9E12 8D F5 06
@ret:   rts                                     ; 9E15 60

; ----------------------------------------------------------------------------
; A+B+Select+Start
gameModeState_checkForResetKeyCombo:
        lda     heldButtons_player1             ; 9E16 A5 F7
        cmp     #$F0                            ; 9E18 C9 F0
        beq     @reset                          ; 9E1A F0 03
        inc     gameModeState                   ; 9E1C E6 A7
        rts                                     ; 9E1E 60

; ----------------------------------------------------------------------------
@reset: jsr     updateAudio2                    ; 9E1F 20 03 E0
        lda     #$00                            ; 9E22 A9 00
        sta     gameMode                        ; 9E24 85 C0
        rts                                     ; 9E26 60

; ----------------------------------------------------------------------------
; It looks like the jsr _must_ do nothing, otherwise reg a != gameModeState in mainLoop and there would not be any waiting on vsync
gameModeState_vblankThenRunState2:
        lda     #$02                            ; 9E27 A9 02
        sta     gameModeState                   ; 9E29 85 A7
        jsr     noop_disabledVramRowIncr        ; 9E2B 20 74 98
        rts                                     ; 9E2E 60

; ----------------------------------------------------------------------------
playState_unassignOrientationId:
        lda     #$13                            ; 9E2F A9 13
        sta     currentPiece                    ; 9E31 85 42
        rts                                     ; 9E33 60

; ----------------------------------------------------------------------------
        inc     gameModeState                   ; 9E34 E6 A7
        rts                                     ; 9E36 60

; ----------------------------------------------------------------------------
playState_incrementPlayState:
        inc     playState                       ; 9E37 E6 48
playState_noop:
        rts                                     ; 9E39 60

; ----------------------------------------------------------------------------
endingAnimation_maybe:
        lda     #$02                            ; 9E3A A9 02
        sta     spriteIndexInOamContentLookup   ; 9E3C 85 A2
        lda     #$04                            ; 9E3E A9 04
        sta     renderMode                      ; 9E40 85 BD
        lda     gameType                        ; 9E42 A5 C1
        bne     L9E49                           ; 9E44 D0 03
        jmp     LA926                           ; 9E46 4C 26 A9

; ----------------------------------------------------------------------------
L9E49:  ldx     player1_levelNumber             ; 9E49 A6 64
        lda     levelDisplayTable,x             ; 9E4B BD B8 96
        and     #$0F                            ; 9E4E 29 0F
        sta     levelNumber                     ; 9E50 85 44
        lda     #$00                            ; 9E52 A9 00
        sta     totalScore+2                    ; 9E54 85 DE
        sta     totalScore+1                    ; 9E56 85 DD
        sta     totalScore                      ; 9E58 85 DC
        lda     levelNumber                     ; 9E5A A5 44
        asl     a                               ; 9E5C 0A
        asl     a                               ; 9E5D 0A
        asl     a                               ; 9E5E 0A
        asl     a                               ; 9E5F 0A
        sta     generalCounter4                 ; 9E60 85 AB
        lda     player1_startHeight             ; 9E62 A5 79
        asl     a                               ; 9E64 0A
        asl     a                               ; 9E65 0A
        asl     a                               ; 9E66 0A
        asl     a                               ; 9E67 0A
        sta     generalCounter5                 ; 9E68 85 AC
        jsr     updateAudioWaitForNmiAndDisablePpuRendering; 9E6A 20 52 AA
        jsr     disableNmi                      ; 9E6D 20 78 AA
        lda     levelNumber                     ; 9E70 A5 44
        cmp     #$09                            ; 9E72 C9 09
        bne     L9E88                           ; 9E74 D0 12
        lda     #$01                            ; 9E76 A9 01
        jsr     changeCHRBank0                  ; 9E78 20 B7 AC
        lda     #$01                            ; 9E7B A9 01
        jsr     changeCHRBank1                  ; 9E7D 20 CB AC
        jsr     bulkCopyToPpu                   ; 9E80 20 98 AA
        .addr   type_b_lvl9_ending_nametable    ; 9E83 A6 C9
; ----------------------------------------------------------------------------
        jmp     L9EA4                           ; 9E85 4C A4 9E

; ----------------------------------------------------------------------------
L9E88:  ldx     #$03                            ; 9E88 A2 03
        lda     levelNumber                     ; 9E8A A5 44
        cmp     #$02                            ; 9E8C C9 02
        beq     L9E96                           ; 9E8E F0 06
        cmp     #$06                            ; 9E90 C9 06
        beq     L9E96                           ; 9E92 F0 02
        ldx     #$02                            ; 9E94 A2 02
L9E96:  txa                                     ; 9E96 8A
        jsr     changeCHRBank0                  ; 9E97 20 B7 AC
        lda     #$02                            ; 9E9A A9 02
        jsr     changeCHRBank1                  ; 9E9C 20 CB AC
        jsr     bulkCopyToPpu                   ; 9E9F 20 98 AA
        .addr   type_b_ending_nametable         ; 9EA2 07 CE
; ----------------------------------------------------------------------------
L9EA4:  jsr     bulkCopyToPpu                   ; 9EA4 20 98 AA
        .addr   ending_palette                  ; 9EA7 43 AD
; ----------------------------------------------------------------------------
        jsr     ending_initTypeBVars            ; 9EA9 20 63 A4
        jsr     waitForVBlankAndEnableNmi       ; 9EAC 20 6B AA
        jsr     updateAudioWaitForNmiAndResetOamStaging; 9EAF 20 2F AA
        jsr     updateAudioWaitForNmiAndEnablePpuRendering; 9EB2 20 5F AA
        jsr     updateAudioWaitForNmiAndResetOamStaging; 9EB5 20 2F AA
        lda     #$04                            ; 9EB8 A9 04
        sta     renderMode                      ; 9EBA 85 BD
        lda     #$0A                            ; 9EBC A9 0A
        jsr     setMusicTrack                   ; 9EBE 20 07 9E
        lda     #$80                            ; 9EC1 A9 80
        jsr     render_endingUnskippable        ; 9EC3 20 FD A7
        lda     player1_score                   ; 9EC6 A5 73
        sta     totalScore                      ; 9EC8 85 DC
        lda     player1_score+1                 ; 9ECA A5 74
        sta     totalScore+1                    ; 9ECC 85 DD
        lda     player1_score+2                 ; 9ECE A5 75
        sta     totalScore+2                    ; 9ED0 85 DE
        lda     #$02                            ; 9ED2 A9 02
        sta     soundEffectSlot1Init            ; 9ED4 8D F1 06
        lda     #$00                            ; 9ED7 A9 00
        sta     player1_score                   ; 9ED9 85 73
        sta     player1_score+1                 ; 9EDB 85 74
        sta     player1_score+2                 ; 9EDD 85 75
        lda     #$40                            ; 9EDF A9 40
        jsr     render_endingUnskippable        ; 9EE1 20 FD A7
        lda     generalCounter4                 ; 9EE4 A5 AB
        beq     L9F12                           ; 9EE6 F0 2A
L9EE8:  dec     generalCounter4                 ; 9EE8 C6 AB
        lda     generalCounter4                 ; 9EEA A5 AB
        and     #$0F                            ; 9EEC 29 0F
        cmp     #$0F                            ; 9EEE C9 0F
        bne     L9EFA                           ; 9EF0 D0 08
        lda     generalCounter4                 ; 9EF2 A5 AB
        and     #$F0                            ; 9EF4 29 F0
        ora     #$09                            ; 9EF6 09 09
        sta     generalCounter4                 ; 9EF8 85 AB
L9EFA:  lda     generalCounter4                 ; 9EFA A5 AB
        jsr     L9F62                           ; 9EFC 20 62 9F
        lda     #$01                            ; 9EFF A9 01
        sta     soundEffectSlot1Init            ; 9F01 8D F1 06
        lda     #$02                            ; 9F04 A9 02
        jsr     render_endingUnskippable        ; 9F06 20 FD A7
        lda     generalCounter4                 ; 9F09 A5 AB
        bne     L9EE8                           ; 9F0B D0 DB
        lda     #$40                            ; 9F0D A9 40
        jsr     render_endingUnskippable        ; 9F0F 20 FD A7
L9F12:  lda     generalCounter5                 ; 9F12 A5 AC
        beq     L9F45                           ; 9F14 F0 2F
L9F16:  dec     generalCounter5                 ; 9F16 C6 AC
        lda     generalCounter5                 ; 9F18 A5 AC
        and     #$0F                            ; 9F1A 29 0F
        cmp     #$0F                            ; 9F1C C9 0F
        bne     L9F28                           ; 9F1E D0 08
        lda     generalCounter5                 ; 9F20 A5 AC
        and     #$F0                            ; 9F22 29 F0
        ora     #$09                            ; 9F24 09 09
        sta     generalCounter5                 ; 9F26 85 AC
L9F28:  lda     generalCounter5                 ; 9F28 A5 AC
        jsr     L9F62                           ; 9F2A 20 62 9F
        lda     #$01                            ; 9F2D A9 01
        sta     soundEffectSlot1Init            ; 9F2F 8D F1 06
        lda     #$02                            ; 9F32 A9 02
        jsr     render_endingUnskippable        ; 9F34 20 FD A7
        lda     generalCounter5                 ; 9F37 A5 AC
        bne     L9F16                           ; 9F39 D0 DB
        lda     #$02                            ; 9F3B A9 02
        sta     soundEffectSlot1Init            ; 9F3D 8D F1 06
        lda     #$40                            ; 9F40 A9 40
        jsr     render_endingUnskippable        ; 9F42 20 FD A7
L9F45:  jsr     render_ending                   ; 9F45 20 27 A5
        jsr     updateAudioWaitForNmiAndResetOamStaging; 9F48 20 2F AA
        lda     newlyPressedButtons_player1     ; 9F4B A5 F5
        cmp     #$10                            ; 9F4D C9 10
        bne     L9F45                           ; 9F4F D0 F4
        lda     player1_levelNumber             ; 9F51 A5 64
        sta     levelNumber                     ; 9F53 85 44
        lda     totalScore                      ; 9F55 A5 DC
        sta     score                           ; 9F57 85 53
        lda     totalScore+1                    ; 9F59 A5 DD
        sta     score+1                         ; 9F5B 85 54
        lda     totalScore+2                    ; 9F5D A5 DE
        sta     score+2                         ; 9F5F 85 55
        rts                                     ; 9F61 60

; ----------------------------------------------------------------------------
L9F62:  lda     #$01                            ; 9F62 A9 01
        clc                                     ; 9F64 18
        adc     totalScore+1                    ; 9F65 65 DD
        sta     totalScore+1                    ; 9F67 85 DD
        and     #$0F                            ; 9F69 29 0F
        cmp     #$0A                            ; 9F6B C9 0A
        bcc     L9F76                           ; 9F6D 90 07
        lda     totalScore+1                    ; 9F6F A5 DD
        clc                                     ; 9F71 18
        adc     #$06                            ; 9F72 69 06
        sta     totalScore+1                    ; 9F74 85 DD
L9F76:  and     #$F0                            ; 9F76 29 F0
        cmp     #$A0                            ; 9F78 C9 A0
        bcc     L9F85                           ; 9F7A 90 09
        lda     totalScore+1                    ; 9F7C A5 DD
        clc                                     ; 9F7E 18
        adc     #$60                            ; 9F7F 69 60
        sta     totalScore+1                    ; 9F81 85 DD
        inc     totalScore+2                    ; 9F83 E6 DE
L9F85:  lda     totalScore+2                    ; 9F85 A5 DE
        and     #$0F                            ; 9F87 29 0F
        cmp     #$0A                            ; 9F89 C9 0A
        bcc     L9F94                           ; 9F8B 90 07
        lda     totalScore+2                    ; 9F8D A5 DE
        clc                                     ; 9F8F 18
        adc     #$06                            ; 9F90 69 06
        sta     totalScore+2                    ; 9F92 85 DE
L9F94:  rts                                     ; 9F94 60

; ----------------------------------------------------------------------------
render_mode_ending_animation:
        lda     #$20                            ; 9F95 A9 20
        sta     PPUADDR                         ; 9F97 8D 06 20
        lda     #$8E                            ; 9F9A A9 8E
        sta     PPUADDR                         ; 9F9C 8D 06 20
        lda     player1_score+2                 ; 9F9F A5 75
        jsr     twoDigsToPPU                    ; 9FA1 20 12 97
        lda     player1_score+1                 ; 9FA4 A5 74
        jsr     twoDigsToPPU                    ; 9FA6 20 12 97
        lda     player1_score                   ; 9FA9 A5 73
        jsr     twoDigsToPPU                    ; 9FAB 20 12 97
        lda     gameType                        ; 9FAE A5 C1
        beq     @done                           ; 9FB0 F0 37
        lda     #$20                            ; 9FB2 A9 20
        sta     PPUADDR                         ; 9FB4 8D 06 20
        lda     #$B0                            ; 9FB7 A9 B0
        sta     PPUADDR                         ; 9FB9 8D 06 20
        lda     generalCounter4                 ; 9FBC A5 AB
        jsr     twoDigsToPPU                    ; 9FBE 20 12 97
        lda     #$20                            ; 9FC1 A9 20
        sta     PPUADDR                         ; 9FC3 8D 06 20
        lda     #$D0                            ; 9FC6 A9 D0
        sta     PPUADDR                         ; 9FC8 8D 06 20
        lda     generalCounter5                 ; 9FCB A5 AC
        jsr     twoDigsToPPU                    ; 9FCD 20 12 97
        lda     #$21                            ; 9FD0 A9 21
        sta     PPUADDR                         ; 9FD2 8D 06 20
        lda     #$2E                            ; 9FD5 A9 2E
        sta     PPUADDR                         ; 9FD7 8D 06 20
        lda     totalScore+2                    ; 9FDA A5 DE
        jsr     twoDigsToPPU                    ; 9FDC 20 12 97
        lda     totalScore+1                    ; 9FDF A5 DD
        jsr     twoDigsToPPU                    ; 9FE1 20 12 97
        lda     totalScore                      ; 9FE4 A5 DC
        jsr     twoDigsToPPU                    ; 9FE6 20 12 97
@done:  ldy     #$00                            ; 9FE9 A0 00
        sty     PPUSCROLL                       ; 9FEB 8C 05 20
        sty     PPUSCROLL                       ; 9FEE 8C 05 20
        rts                                     ; 9FF1 60

; ----------------------------------------------------------------------------
showHighScores:
        lda     numberOfPlayers                 ; 9FF2 A5 BE
        cmp     #$01                            ; 9FF4 C9 01
        beq     showHighScores_real             ; 9FF6 F0 03
        jmp     showHighScores_ret              ; 9FF8 4C 85 A0

; ----------------------------------------------------------------------------
; not using @-label due to MMC1_Control in PAL
showHighScores_real:
        jsr     bulkCopyToPpu                   ; 9FFB 20 98 AA
MMC1_Control    := * + 1
        .addr   high_scores_nametable           ; 9FFE FE C7
; ----------------------------------------------------------------------------
        lda     #$00                            ; A000 A9 00
        sta     generalCounter2                 ; A002 85 A9
        lda     gameType                        ; A004 A5 C1
        beq     @copyEntry                      ; A006 F0 04
        lda     #$04                            ; A008 A9 04
        sta     generalCounter2                 ; A00A 85 A9
@copyEntry:
        lda     generalCounter2                 ; A00C A5 A9
        and     #$03                            ; A00E 29 03
        asl     a                               ; A010 0A
        tax                                     ; A011 AA
        lda     highScorePpuAddrTable,x         ; A012 BD 86 A0
        sta     PPUADDR                         ; A015 8D 06 20
        lda     generalCounter2                 ; A018 A5 A9
        and     #$03                            ; A01A 29 03
        asl     a                               ; A01C 0A
        tax                                     ; A01D AA
        inx                                     ; A01E E8
        lda     highScorePpuAddrTable,x         ; A01F BD 86 A0
        sta     PPUADDR                         ; A022 8D 06 20
        lda     generalCounter2                 ; A025 A5 A9
        asl     a                               ; A027 0A
        sta     generalCounter                  ; A028 85 A8
        asl     a                               ; A02A 0A
        clc                                     ; A02B 18
        adc     generalCounter                  ; A02C 65 A8
        tay                                     ; A02E A8
        ldx     #$06                            ; A02F A2 06
@copyChar:
        lda     highScoreNames,y                ; A031 B9 00 07
        sty     generalCounter                  ; A034 84 A8
        tay                                     ; A036 A8
        lda     highScoreCharToTile,y           ; A037 B9 8C A0
        ldy     generalCounter                  ; A03A A4 A8
        sta     PPUDATA                         ; A03C 8D 07 20
        iny                                     ; A03F C8
        dex                                     ; A040 CA
        bne     @copyChar                       ; A041 D0 EE
        lda     #$FF                            ; A043 A9 FF
        sta     PPUDATA                         ; A045 8D 07 20
        lda     generalCounter2                 ; A048 A5 A9
        sta     generalCounter                  ; A04A 85 A8
        asl     a                               ; A04C 0A
        clc                                     ; A04D 18
        adc     generalCounter                  ; A04E 65 A8
        tay                                     ; A050 A8
        lda     highScoreScoresA,y              ; A051 B9 30 07
        jsr     twoDigsToPPU                    ; A054 20 12 97
        iny                                     ; A057 C8
        lda     highScoreScoresA,y              ; A058 B9 30 07
        jsr     twoDigsToPPU                    ; A05B 20 12 97
        iny                                     ; A05E C8
        lda     highScoreScoresA,y              ; A05F B9 30 07
        jsr     twoDigsToPPU                    ; A062 20 12 97
        lda     #$FF                            ; A065 A9 FF
        sta     PPUDATA                         ; A067 8D 07 20
        ldy     generalCounter2                 ; A06A A4 A9
        lda     highScoreLevels,y               ; A06C B9 48 07
        tax                                     ; A06F AA
        lda     byteToBcdTable,x                ; A070 BD BC A0
        jsr     twoDigsToPPU                    ; A073 20 12 97
        inc     generalCounter2                 ; A076 E6 A9
        lda     generalCounter2                 ; A078 A5 A9
        cmp     #$03                            ; A07A C9 03
        beq     showHighScores_ret              ; A07C F0 07
        cmp     #$07                            ; A07E C9 07
        beq     showHighScores_ret              ; A080 F0 03
        jmp     @copyEntry                      ; A082 4C 0C A0

; ----------------------------------------------------------------------------
showHighScores_ret:
        rts                                     ; A085 60

; ----------------------------------------------------------------------------
highScorePpuAddrTable:
        .dbyt   $2289,$22C9,$2309               ; A086 22 89 22 C9 23 09
; ----------------------------------------------------------------------------
highScoreCharToTile:
        .byte   $24,$0A,$0B,$0C,$0D,$0E,$0F,$10 ; A08C 24 0A 0B 0C 0D 0E 0F 10
        .byte   $11,$12,$13,$14,$15,$16,$17,$18 ; A094 11 12 13 14 15 16 17 18
        .byte   $19,$1A,$1B,$1C,$1D,$1E,$1F,$20 ; A09C 19 1A 1B 1C 1D 1E 1F 20
        .byte   $21,$22,$23,$00,$01,$02,$03,$04 ; A0A4 21 22 23 00 01 02 03 04
        .byte   $05,$06,$07,$08,$09,$25,$4F,$5E ; A0AC 05 06 07 08 09 25 4F 5E
        .byte   $5F,$6E,$6F,$FF                 ; A0B4 5F 6E 6F FF
unreferenced_data7:
        .byte   $00,$00,$00,$00                 ; A0B8 00 00 00 00
; maxes out at 49
byteToBcdTable:
        .byte   $00,$01,$02,$03,$04,$05,$06,$07 ; A0BC 00 01 02 03 04 05 06 07
        .byte   $08,$09,$10,$11,$12,$13,$14,$15 ; A0C4 08 09 10 11 12 13 14 15
        .byte   $16,$17,$18,$19,$20,$21,$22,$23 ; A0CC 16 17 18 19 20 21 22 23
        .byte   $24,$25,$26,$27,$28,$29,$30,$31 ; A0D4 24 25 26 27 28 29 30 31
        .byte   $32,$33,$34,$35,$36,$37,$38,$39 ; A0DC 32 33 34 35 36 37 38 39
        .byte   $40,$41,$42,$43,$44,$45,$46,$47 ; A0E4 40 41 42 43 44 45 46 47
        .byte   $48,$49                         ; A0EC 48 49
; ----------------------------------------------------------------------------
; Adjusts high score table and handles data entry, if necessary
handleHighScoreIfNecessary:
        lda     #$00                            ; A0EE A9 00
        sta     highScoreEntryRawPos            ; A0F0 85 D5
        lda     gameType                        ; A0F2 A5 C1
        beq     @compareWithPos                 ; A0F4 F0 04
        lda     #$04                            ; A0F6 A9 04
        sta     highScoreEntryRawPos            ; A0F8 85 D5
@compareWithPos:
        lda     highScoreEntryRawPos            ; A0FA A5 D5
        sta     generalCounter2                 ; A0FC 85 A9
        asl     a                               ; A0FE 0A
        clc                                     ; A0FF 18
        adc     generalCounter2                 ; A100 65 A9
        tay                                     ; A102 A8
        lda     highScoreScoresA,y              ; A103 B9 30 07
        cmp     player1_score+2                 ; A106 C5 75
        beq     @checkHundredsByte              ; A108 F0 04
        bcs     @tooSmall                       ; A10A B0 18
        bcc     adjustHighScores                ; A10C 90 26
@checkHundredsByte:
        iny                                     ; A10E C8
        lda     highScoreScoresA,y              ; A10F B9 30 07
        cmp     player1_score+1                 ; A112 C5 74
        beq     @checkOnesByte                  ; A114 F0 04
        bcs     @tooSmall                       ; A116 B0 0C
        bcc     adjustHighScores                ; A118 90 1A
; This breaks ties by prefering the new score
@checkOnesByte:
        iny                                     ; A11A C8
        lda     highScoreScoresA,y              ; A11B B9 30 07
        cmp     player1_score                   ; A11E C5 73
        beq     adjustHighScores                ; A120 F0 12
        bcc     adjustHighScores                ; A122 90 10
@tooSmall:
        inc     highScoreEntryRawPos            ; A124 E6 D5
        lda     highScoreEntryRawPos            ; A126 A5 D5
        cmp     #$03                            ; A128 C9 03
        beq     @ret                            ; A12A F0 07
        cmp     #$07                            ; A12C C9 07
        beq     @ret                            ; A12E F0 03
        jmp     @compareWithPos                 ; A130 4C FA A0

; ----------------------------------------------------------------------------
@ret:   rts                                     ; A133 60

; ----------------------------------------------------------------------------
adjustHighScores:
        lda     highScoreEntryRawPos            ; A134 A5 D5
        and     #$03                            ; A136 29 03
        cmp     #$02                            ; A138 C9 02
        bpl     @doneMovingOldScores            ; A13A 10 24
        lda     #$06                            ; A13C A9 06
        jsr     copyHighScoreNameToNextIndex    ; A13E 20 92 A1
        lda     #$03                            ; A141 A9 03
        jsr     copyHighScoreScoreToNextIndex   ; A143 20 C1 A1
        lda     #$01                            ; A146 A9 01
        jsr     copyHighScoreLevelToNextIndex   ; A148 20 E0 A1
        lda     highScoreEntryRawPos            ; A14B A5 D5
        and     #$03                            ; A14D 29 03
        bne     @doneMovingOldScores            ; A14F D0 0F
        lda     #$00                            ; A151 A9 00
        jsr     copyHighScoreNameToNextIndex    ; A153 20 92 A1
        lda     #$00                            ; A156 A9 00
        jsr     copyHighScoreScoreToNextIndex   ; A158 20 C1 A1
        lda     #$00                            ; A15B A9 00
        jsr     copyHighScoreLevelToNextIndex   ; A15D 20 E0 A1
@doneMovingOldScores:
        ldx     highScoreEntryRawPos            ; A160 A6 D5
        lda     highScoreIndexToHighScoreNamesOffset,x; A162 BD F1 A1
        tax                                     ; A165 AA
        ldy     #$06                            ; A166 A0 06
        lda     #$00                            ; A168 A9 00
@clearNameLetter:
        sta     highScoreNames,x                ; A16A 9D 00 07
        inx                                     ; A16D E8
        dey                                     ; A16E 88
        bne     @clearNameLetter                ; A16F D0 F9
        ldx     highScoreEntryRawPos            ; A171 A6 D5
        lda     highScoreIndexToHighScoreScoresOffset,x; A173 BD F9 A1
        tax                                     ; A176 AA
        lda     player1_score+2                 ; A177 A5 75
        sta     highScoreScoresA,x              ; A179 9D 30 07
        inx                                     ; A17C E8
        lda     player1_score+1                 ; A17D A5 74
        sta     highScoreScoresA,x              ; A17F 9D 30 07
        inx                                     ; A182 E8
        lda     player1_score                   ; A183 A5 73
        sta     highScoreScoresA,x              ; A185 9D 30 07
        ldx     highScoreEntryRawPos            ; A188 A6 D5
        lda     player1_levelNumber             ; A18A A5 64
        sta     highScoreLevels,x               ; A18C 9D 48 07
        jmp     highScoreEntryScreen            ; A18F 4C 01 A2

; ----------------------------------------------------------------------------
; reg a: start byte to copy
copyHighScoreNameToNextIndex:
        sta     generalCounter                  ; A192 85 A8
        lda     gameType                        ; A194 A5 C1
        beq     @offsetAdjustedForGameType      ; A196 F0 07
        lda     #$18                            ; A198 A9 18
        clc                                     ; A19A 18
        adc     generalCounter                  ; A19B 65 A8
        sta     generalCounter                  ; A19D 85 A8
@offsetAdjustedForGameType:
        lda     #$05                            ; A19F A9 05
        sta     generalCounter2                 ; A1A1 85 A9
@copyLetter:
        lda     generalCounter                  ; A1A3 A5 A8
        clc                                     ; A1A5 18
        adc     generalCounter2                 ; A1A6 65 A9
        tax                                     ; A1A8 AA
        lda     highScoreNames,x                ; A1A9 BD 00 07
        sta     generalCounter3                 ; A1AC 85 AA
        txa                                     ; A1AE 8A
        clc                                     ; A1AF 18
        adc     #$06                            ; A1B0 69 06
        tax                                     ; A1B2 AA
        lda     generalCounter3                 ; A1B3 A5 AA
        sta     highScoreNames,x                ; A1B5 9D 00 07
        dec     generalCounter2                 ; A1B8 C6 A9
        lda     generalCounter2                 ; A1BA A5 A9
        cmp     #$FF                            ; A1BC C9 FF
        bne     @copyLetter                     ; A1BE D0 E3
        rts                                     ; A1C0 60

; ----------------------------------------------------------------------------
; reg a: start byte to copy
copyHighScoreScoreToNextIndex:
        tax                                     ; A1C1 AA
        lda     gameType                        ; A1C2 A5 C1
        beq     @xAdjustedForGameType           ; A1C4 F0 05
        txa                                     ; A1C6 8A
        clc                                     ; A1C7 18
        adc     #$0C                            ; A1C8 69 0C
        tax                                     ; A1CA AA
@xAdjustedForGameType:
        lda     highScoreScoresA,x              ; A1CB BD 30 07
        sta     highScoreScoresA+3,x            ; A1CE 9D 33 07
        inx                                     ; A1D1 E8
        lda     highScoreScoresA,x              ; A1D2 BD 30 07
        sta     highScoreScoresA+3,x            ; A1D5 9D 33 07
        inx                                     ; A1D8 E8
        lda     highScoreScoresA,x              ; A1D9 BD 30 07
        sta     highScoreScoresA+3,x            ; A1DC 9D 33 07
        rts                                     ; A1DF 60

; ----------------------------------------------------------------------------
; reg a: start byte to copy
copyHighScoreLevelToNextIndex:
        tax                                     ; A1E0 AA
        lda     gameType                        ; A1E1 A5 C1
        beq     @xAdjustedForGameType           ; A1E3 F0 05
        txa                                     ; A1E5 8A
        clc                                     ; A1E6 18
        adc     #$04                            ; A1E7 69 04
        tax                                     ; A1E9 AA
@xAdjustedForGameType:
        lda     highScoreLevels,x               ; A1EA BD 48 07
        sta     highScoreLevels+1,x             ; A1ED 9D 49 07
        rts                                     ; A1F0 60

; ----------------------------------------------------------------------------
highScoreIndexToHighScoreNamesOffset:
        .byte   $00,$06,$0C,$12,$18,$1E,$24,$2A ; A1F1 00 06 0C 12 18 1E 24 2A
highScoreIndexToHighScoreScoresOffset:
        .byte   $00,$03,$06,$09,$0C,$0F,$12,$15 ; A1F9 00 03 06 09 0C 0F 12 15
; ----------------------------------------------------------------------------
highScoreEntryScreen:
        inc     initRam                         ; A201 EE 00 80
        lda     #$10                            ; A204 A9 10
        jsr     setMMC1Control                  ; A206 20 A3 AC
        lda     #$09                            ; A209 A9 09
        jsr     setMusicTrack                   ; A20B 20 07 9E
        lda     #$02                            ; A20E A9 02
        sta     renderMode                      ; A210 85 BD
        jsr     updateAudioWaitForNmiAndDisablePpuRendering; A212 20 52 AA
        jsr     disableNmi                      ; A215 20 78 AA
        lda     #$00                            ; A218 A9 00
        jsr     changeCHRBank0                  ; A21A 20 B7 AC
        lda     #$00                            ; A21D A9 00
        jsr     changeCHRBank1                  ; A21F 20 CB AC
        jsr     bulkCopyToPpu                   ; A222 20 98 AA
        .addr   menu_palette                    ; A225 2B AD
; ----------------------------------------------------------------------------
        jsr     bulkCopyToPpu                   ; A227 20 98 AA
        .addr   enter_high_score_nametable      ; A22A 9D C3
; ----------------------------------------------------------------------------
        lda     #$20                            ; A22C A9 20
        sta     PPUADDR                         ; A22E 8D 06 20
        lda     #$6D                            ; A231 A9 6D
        sta     PPUADDR                         ; A233 8D 06 20
        lda     #$0A                            ; A236 A9 0A
        clc                                     ; A238 18
        adc     gameType                        ; A239 65 C1
        sta     PPUDATA                         ; A23B 8D 07 20
        jsr     showHighScores                  ; A23E 20 F2 9F
        lda     #$02                            ; A241 A9 02
        sta     renderMode                      ; A243 85 BD
        jsr     waitForVBlankAndEnableNmi       ; A245 20 6B AA
        jsr     updateAudioWaitForNmiAndResetOamStaging; A248 20 2F AA
        jsr     updateAudioWaitForNmiAndEnablePpuRendering; A24B 20 5F AA
        jsr     updateAudioWaitForNmiAndResetOamStaging; A24E 20 2F AA
        lda     highScoreEntryRawPos            ; A251 A5 D5
        asl     a                               ; A253 0A
        sta     generalCounter                  ; A254 85 A8
        asl     a                               ; A256 0A
        clc                                     ; A257 18
        adc     generalCounter                  ; A258 65 A8
        sta     highScoreEntryNameOffsetForRow  ; A25A 85 D6
        lda     #$00                            ; A25C A9 00
        sta     highScoreEntryNameOffsetForLetter; A25E 85 D4
        sta     oamStaging                      ; A260 8D 00 02
        lda     highScoreEntryRawPos            ; A263 A5 D5
        and     #$03                            ; A265 29 03
        tax                                     ; A267 AA
        lda     highScorePosToY,x               ; A268 BD 3B A3
        sta     spriteYOffset                   ; A26B 85 A1
@renderFrame:
        lda     #$00                            ; A26D A9 00
        sta     oamStaging                      ; A26F 8D 00 02
        ldx     highScoreEntryNameOffsetForLetter; A272 A6 D4
        lda     highScoreNamePosToX,x           ; A274 BD 3E A3
        sta     spriteXOffset                   ; A277 85 A0
        lda     #$0E                            ; A279 A9 0E
        sta     spriteIndexInOamContentLookup   ; A27B 85 A2
        lda     frameCounter                    ; A27D A5 B1
        and     #$03                            ; A27F 29 03
        bne     @flickerStateSelected_checkForStartPressed; A281 D0 04
        lda     #$02                            ; A283 A9 02
        sta     spriteIndexInOamContentLookup   ; A285 85 A2
@flickerStateSelected_checkForStartPressed:
        jsr     loadSpriteIntoOamStaging        ; A287 20 27 8C
        lda     newlyPressedButtons_player1     ; A28A A5 F5
        and     #$10                            ; A28C 29 10
        beq     @checkForAOrRightPressed        ; A28E F0 08
        lda     #$02                            ; A290 A9 02
        sta     soundEffectSlot1Init            ; A292 8D F1 06
        jmp     @ret                            ; A295 4C 37 A3

; ----------------------------------------------------------------------------
@checkForAOrRightPressed:
        lda     newlyPressedButtons_player1     ; A298 A5 F5
        and     #$81                            ; A29A 29 81
        beq     @checkForBOrLeftPressed         ; A29C F0 11
        lda     #$01                            ; A29E A9 01
        sta     soundEffectSlot1Init            ; A2A0 8D F1 06
        inc     highScoreEntryNameOffsetForLetter; A2A3 E6 D4
        lda     highScoreEntryNameOffsetForLetter; A2A5 A5 D4
        cmp     #$06                            ; A2A7 C9 06
        bmi     @checkForBOrLeftPressed         ; A2A9 30 04
        lda     #$00                            ; A2AB A9 00
        sta     highScoreEntryNameOffsetForLetter; A2AD 85 D4
@checkForBOrLeftPressed:
        lda     newlyPressedButtons_player1     ; A2AF A5 F5
        and     #$42                            ; A2B1 29 42
        beq     @checkForDownPressed            ; A2B3 F0 0F
        lda     #$01                            ; A2B5 A9 01
        sta     soundEffectSlot1Init            ; A2B7 8D F1 06
        dec     highScoreEntryNameOffsetForLetter; A2BA C6 D4
        lda     highScoreEntryNameOffsetForLetter; A2BC A5 D4
        bpl     @checkForDownPressed            ; A2BE 10 04
        lda     #$05                            ; A2C0 A9 05
        sta     highScoreEntryNameOffsetForLetter; A2C2 85 D4
@checkForDownPressed:
        lda     heldButtons_player1             ; A2C4 A5 F7
        and     #$04                            ; A2C6 29 04
        beq     @checkForUpPressed              ; A2C8 F0 28
        lda     frameCounter                    ; A2CA A5 B1
        and     #$07                            ; A2CC 29 07
        bne     @checkForUpPressed              ; A2CE D0 22
        lda     #$01                            ; A2D0 A9 01
        sta     soundEffectSlot1Init            ; A2D2 8D F1 06
        lda     highScoreEntryNameOffsetForRow  ; A2D5 A5 D6
        sta     generalCounter                  ; A2D7 85 A8
        clc                                     ; A2D9 18
        adc     highScoreEntryNameOffsetForLetter; A2DA 65 D4
        tax                                     ; A2DC AA
        lda     highScoreNames,x                ; A2DD BD 00 07
        sta     generalCounter                  ; A2E0 85 A8
        dec     generalCounter                  ; A2E2 C6 A8
        lda     generalCounter                  ; A2E4 A5 A8
        bpl     @letterDoesNotUnderflow         ; A2E6 10 05
        clc                                     ; A2E8 18
        adc     #$2C                            ; A2E9 69 2C
        sta     generalCounter                  ; A2EB 85 A8
@letterDoesNotUnderflow:
        lda     generalCounter                  ; A2ED A5 A8
        sta     highScoreNames,x                ; A2EF 9D 00 07
@checkForUpPressed:
        lda     heldButtons_player1             ; A2F2 A5 F7
        and     #$08                            ; A2F4 29 08
        beq     @waitForVBlank                  ; A2F6 F0 2A
        lda     frameCounter                    ; A2F8 A5 B1
        and     #$07                            ; A2FA 29 07
        bne     @waitForVBlank                  ; A2FC D0 24
        lda     #$01                            ; A2FE A9 01
        sta     soundEffectSlot1Init            ; A300 8D F1 06
        lda     highScoreEntryNameOffsetForRow  ; A303 A5 D6
        sta     generalCounter                  ; A305 85 A8
        clc                                     ; A307 18
        adc     highScoreEntryNameOffsetForLetter; A308 65 D4
        tax                                     ; A30A AA
        lda     highScoreNames,x                ; A30B BD 00 07
        sta     generalCounter                  ; A30E 85 A8
        inc     generalCounter                  ; A310 E6 A8
        lda     generalCounter                  ; A312 A5 A8
        cmp     #$2C                            ; A314 C9 2C
        bmi     @letterDoesNotOverflow          ; A316 30 05
        sec                                     ; A318 38
        sbc     #$2C                            ; A319 E9 2C
        sta     generalCounter                  ; A31B 85 A8
@letterDoesNotOverflow:
        lda     generalCounter                  ; A31D A5 A8
        sta     highScoreNames,x                ; A31F 9D 00 07
@waitForVBlank:
        lda     highScoreEntryNameOffsetForRow  ; A322 A5 D6
        clc                                     ; A324 18
        adc     highScoreEntryNameOffsetForLetter; A325 65 D4
        tax                                     ; A327 AA
        lda     highScoreNames,x                ; A328 BD 00 07
        sta     highScoreEntryCurrentLetter     ; A32B 85 D7
        lda     #$80                            ; A32D A9 80
        sta     outOfDateRenderFlags            ; A32F 85 A3
        jsr     updateAudioWaitForNmiAndResetOamStaging; A331 20 2F AA
        jmp     @renderFrame                    ; A334 4C 6D A2

; ----------------------------------------------------------------------------
@ret:   jsr     updateAudioWaitForNmiAndResetOamStaging; A337 20 2F AA
        rts                                     ; A33A 60

; ----------------------------------------------------------------------------
highScorePosToY:
        .byte   $9F,$AF,$BF                     ; A33B 9F AF BF
highScoreNamePosToX:
        .byte   $48,$50,$58,$60,$68,$70         ; A33E 48 50 58 60 68 70
; ----------------------------------------------------------------------------
render_mode_congratulations_screen:
        lda     outOfDateRenderFlags            ; A344 A5 A3
        and     #$80                            ; A346 29 80
        beq     @ret                            ; A348 F0 34
        lda     highScoreEntryRawPos            ; A34A A5 D5
        and     #$03                            ; A34C 29 03
        asl     a                               ; A34E 0A
        tax                                     ; A34F AA
        lda     highScorePpuAddrTable,x         ; A350 BD 86 A0
        sta     PPUADDR                         ; A353 8D 06 20
        lda     highScoreEntryRawPos            ; A356 A5 D5
        and     #$03                            ; A358 29 03
        asl     a                               ; A35A 0A
        tax                                     ; A35B AA
        inx                                     ; A35C E8
        lda     highScorePpuAddrTable,x         ; A35D BD 86 A0
        sta     generalCounter                  ; A360 85 A8
        clc                                     ; A362 18
        adc     highScoreEntryNameOffsetForLetter; A363 65 D4
        sta     PPUADDR                         ; A365 8D 06 20
        ldx     highScoreEntryCurrentLetter     ; A368 A6 D7
        lda     highScoreCharToTile,x           ; A36A BD 8C A0
        sta     PPUDATA                         ; A36D 8D 07 20
        lda     #$00                            ; A370 A9 00
        sta     ppuScrollX                      ; A372 85 FD
        sta     PPUSCROLL                       ; A374 8D 05 20
        sta     ppuScrollY                      ; A377 85 FC
        sta     PPUSCROLL                       ; A379 8D 05 20
        sta     outOfDateRenderFlags            ; A37C 85 A3
@ret:   rts                                     ; A37E 60

; ----------------------------------------------------------------------------
; Handles pausing and exiting demo
gameModeState_startButtonHandling:
        lda     gameMode                        ; A37F A5 C0
        cmp     #$05                            ; A381 C9 05
        bne     @checkIfInGame                  ; A383 D0 0D
        lda     newlyPressedButtons_player1     ; A385 A5 F5
        cmp     #$10                            ; A387 C9 10
        bne     @checkIfInGame                  ; A389 D0 07
        lda     #$01                            ; A38B A9 01
        sta     gameMode                        ; A38D 85 C0
        jmp     @ret                            ; A38F 4C EF A3

; ----------------------------------------------------------------------------
@checkIfInGame:
        lda     renderMode                      ; A392 A5 BD
        cmp     #$03                            ; A394 C9 03
        bne     @ret                            ; A396 D0 57
        lda     newlyPressedButtons_player1     ; A398 A5 F5
        and     #$10                            ; A39A 29 10
        bne     @startPressed                   ; A39C D0 03
        jmp     @ret                            ; A39E 4C EF A3

; ----------------------------------------------------------------------------
; Do nothing if curtain is being lowered
@startPressed:
        lda     player1_playState               ; A3A1 A5 68
        cmp     #$0A                            ; A3A3 C9 0A
        bne     @pause                          ; A3A5 D0 03
        jmp     @ret                            ; A3A7 4C EF A3

; ----------------------------------------------------------------------------
@pause: lda     #$05                            ; A3AA A9 05
        sta     musicPauseScreen                ; A3AC 8D 8D 06
        lda     #$00                            ; A3AF A9 00
        sta     renderMode                      ; A3B1 85 BD
        jsr     updateAudioAndWaitForNmi        ; A3B3 20 45 AA
        lda     #$16                            ; A3B6 A9 16
        sta     PPUMASK                         ; A3B8 8D 01 20
        lda     #$FF                            ; A3BB A9 FF
        ldx     #$02                            ; A3BD A2 02
        ldy     #$02                            ; A3BF A0 02
        jsr     memset_page                     ; A3C1 20 6A AC
@pauseLoop:
        lda     #$70                            ; A3C4 A9 70
        sta     spriteXOffset                   ; A3C6 85 A0
        lda     #$77                            ; A3C8 A9 77
        sta     spriteYOffset                   ; A3CA 85 A1
        lda     #$05                            ; A3CC A9 05
        sta     spriteIndexInOamContentLookup   ; A3CE 85 A2
        jsr     loadSpriteIntoOamStaging        ; A3D0 20 27 8C
        lda     newlyPressedButtons_player1     ; A3D3 A5 F5
        cmp     #$10                            ; A3D5 C9 10
        beq     @resume                         ; A3D7 F0 06
        jsr     updateAudioWaitForNmiAndResetOamStaging; A3D9 20 2F AA
        jmp     @pauseLoop                      ; A3DC 4C C4 A3

; ----------------------------------------------------------------------------
@resume:lda     #$1E                            ; A3DF A9 1E
        sta     PPUMASK                         ; A3E1 8D 01 20
        lda     #$00                            ; A3E4 A9 00
        sta     musicPauseScreen                ; A3E6 8D 8D 06
        sta     player1_vramRow                 ; A3E9 85 69
        lda     #$03                            ; A3EB A9 03
        sta     renderMode                      ; A3ED 85 BD
@ret:   inc     gameModeState                   ; A3EF E6 A7
        rts                                     ; A3F1 60

; ----------------------------------------------------------------------------
playState_bTypeGoalCheck:
        lda     gameType                        ; A3F2 A5 C1
        beq     @ret                            ; A3F4 F0 35
        lda     lines                           ; A3F6 A5 50
        bne     @ret                            ; A3F8 D0 31
        lda     #$02                            ; A3FA A9 02
        jsr     setMusicTrack                   ; A3FC 20 07 9E
        ldy     #$46                            ; A3FF A0 46
        ldx     #$00                            ; A401 A2 00
@copySuccessGraphic:
        lda     typebSuccessGraphic,x           ; A403 BD 2E A4
        cmp     #$80                            ; A406 C9 80
        beq     @graphicCopied                  ; A408 F0 07
        sta     (playfieldAddr),y               ; A40A 91 B8
        inx                                     ; A40C E8
        iny                                     ; A40D C8
        jmp     @copySuccessGraphic             ; A40E 4C 03 A4

; ----------------------------------------------------------------------------
@graphicCopied:
        lda     #$00                            ; A411 A9 00
        sta     player1_vramRow                 ; A413 85 69
        jsr     sleep_for_14_vblanks            ; A415 20 4D A4
        lda     #$00                            ; A418 A9 00
        sta     renderMode                      ; A41A 85 BD
        lda     #$80                            ; A41C A9 80
        jsr     sleep_for_a_vblanks             ; A41E 20 59 A4
        jsr     endingAnimation_maybe           ; A421 20 3A 9E
        lda     #$00                            ; A424 A9 00
        sta     playState                       ; A426 85 48
        inc     gameModeState                   ; A428 E6 A7
        rts                                     ; A42A 60

; ----------------------------------------------------------------------------
@ret:   inc     playState                       ; A42B E6 48
        rts                                     ; A42D 60

; ----------------------------------------------------------------------------
typebSuccessGraphic:
        .byte   $38,$39,$39,$39,$39,$39,$39,$39 ; A42E 38 39 39 39 39 39 39 39
        .byte   $39,$3A,$3B,$1C,$1E,$0C,$0C,$0E ; A436 39 3A 3B 1C 1E 0C 0C 0E
        .byte   $1C,$1C,$28,$3C,$3D,$3E,$3E,$3E ; A43E 1C 1C 28 3C 3D 3E 3E 3E
        .byte   $3E,$3E,$3E,$3E,$3E,$3F,$80     ; A446 3E 3E 3E 3E 3E 3F 80
; ----------------------------------------------------------------------------
sleep_for_14_vblanks:
        lda     #$14                            ; A44D A9 14
        sta     sleepCounter                    ; A44F 85 C3
@loop:  jsr     updateAudioWaitForNmiAndResetOamStaging; A451 20 2F AA
        lda     sleepCounter                    ; A454 A5 C3
        bne     @loop                           ; A456 D0 F9
        rts                                     ; A458 60

; ----------------------------------------------------------------------------
sleep_for_a_vblanks:
        sta     sleepCounter                    ; A459 85 C3
@loop:  jsr     updateAudioWaitForNmiAndResetOamStaging; A45B 20 2F AA
        lda     sleepCounter                    ; A45E A5 C3
        bne     @loop                           ; A460 D0 F9
        rts                                     ; A462 60

; ----------------------------------------------------------------------------
ending_initTypeBVars:
        lda     #$00                            ; A463 A9 00
        sta     ending                          ; A465 85 C4
        sta     ending_customVars               ; A467 85 C5
        sta     ending_typeBCathedralFrameDelayCounter; A469 85 CD
        lda     #$02                            ; A46B A9 02
        sta     spriteIndexInOamContentLookup   ; A46D 85 A2
        lda     levelNumber                     ; A46F A5 44
        cmp     #$09                            ; A471 C9 09
        bne     @notLevel9                      ; A473 D0 25
        lda     player1_startHeight             ; A475 A5 79
        clc                                     ; A477 18
        adc     #$01                            ; A478 69 01
        sta     ending                          ; A47A 85 C4
        jsr     ending_typeBConcertPatchToPpuForHeight; A47C 20 B1 A4
        lda     #$00                            ; A47F A9 00
        sta     ending                          ; A481 85 C4
        sta     ending_customVars+2             ; A483 85 C7
        lda     LA73D                           ; A485 AD 3D A7
        sta     ending_customVars+3             ; A488 85 C8
        lda     LA73E                           ; A48A AD 3E A7
        sta     ending_customVars+4             ; A48D 85 C9
        lda     LA73F                           ; A48F AD 3F A7
        sta     ending_customVars+5             ; A492 85 CA
        lda     LA740                           ; A494 AD 40 A7
        sta     ending_customVars+6             ; A497 85 CB
        rts                                     ; A499 60

; ----------------------------------------------------------------------------
@notLevel9:
        ldx     levelNumber                     ; A49A A6 44
        lda     LA767,x                         ; A49C BD 67 A7
        sta     ending_customVars+2             ; A49F 85 C7
        sta     ending_customVars+3             ; A4A1 85 C8
        sta     ending_customVars+4             ; A4A3 85 C9
        sta     ending_customVars+5             ; A4A5 85 CA
        sta     ending_customVars+6             ; A4A7 85 CB
        ldx     levelNumber                     ; A4A9 A6 44
        lda     LA75D,x                         ; A4AB BD 5D A7
        sta     ending_customVars+1             ; A4AE 85 C6
        rts                                     ; A4B0 60

; ----------------------------------------------------------------------------
ending_typeBConcertPatchToPpuForHeight:
        lda     ending                          ; A4B1 A5 C4
        jsr     switchOnA                       ; A4B3 20 82 AC
        .addr   @heightUnused                   ; A4B6 C4 A4
        .addr   @height0                        ; A4B8 CF A4
        .addr   @height1                        ; A4BA DA A4
        .addr   @height2                        ; A4BC E5 A4
        .addr   @height3                        ; A4BE F0 A4
        .addr   @height4                        ; A4C0 FB A4
        .addr   @height5                        ; A4C2 06 A5
; ----------------------------------------------------------------------------
@heightUnused:
        lda     #$A8                            ; A4C4 A9 A8
        sta     patchToPpuAddr+1                ; A4C6 85 15
        lda     #$22                            ; A4C8 A9 22
        sta     patchToPpuAddr                  ; A4CA 85 14
        jsr     patchToPpu                      ; A4CC 20 07 A5
@height0:
        lda     #$A8                            ; A4CF A9 A8
        sta     patchToPpuAddr+1                ; A4D1 85 15
        lda     #$34                            ; A4D3 A9 34
        sta     patchToPpuAddr                  ; A4D5 85 14
        jsr     patchToPpu                      ; A4D7 20 07 A5
@height1:
        lda     #$A8                            ; A4DA A9 A8
        sta     patchToPpuAddr+1                ; A4DC 85 15
        lda     #$4A                            ; A4DE A9 4A
        sta     patchToPpuAddr                  ; A4E0 85 14
        jsr     patchToPpu                      ; A4E2 20 07 A5
@height2:
        lda     #$A8                            ; A4E5 A9 A8
        sta     patchToPpuAddr+1                ; A4E7 85 15
        lda     #$62                            ; A4E9 A9 62
        sta     patchToPpuAddr                  ; A4EB 85 14
        jsr     patchToPpu                      ; A4ED 20 07 A5
@height3:
        lda     #$A8                            ; A4F0 A9 A8
        sta     patchToPpuAddr+1                ; A4F2 85 15
        lda     #$7A                            ; A4F4 A9 7A
        sta     patchToPpuAddr                  ; A4F6 85 14
        jsr     patchToPpu                      ; A4F8 20 07 A5
@height4:
        lda     #$A8                            ; A4FB A9 A8
        sta     patchToPpuAddr+1                ; A4FD 85 15
        lda     #$96                            ; A4FF A9 96
        sta     patchToPpuAddr                  ; A501 85 14
        jsr     patchToPpu                      ; A503 20 07 A5
@height5:
        rts                                     ; A506 60

; ----------------------------------------------------------------------------
patchToPpu:
        ldy     #$00                            ; A507 A0 00
@patchAddr:
        lda     (patchToPpuAddr),y              ; A509 B1 14
        sta     PPUADDR                         ; A50B 8D 06 20
        iny                                     ; A50E C8
        lda     (patchToPpuAddr),y              ; A50F B1 14
        sta     PPUADDR                         ; A511 8D 06 20
        iny                                     ; A514 C8
@patchValue:
        lda     (patchToPpuAddr),y              ; A515 B1 14
        iny                                     ; A517 C8
        cmp     #$FE                            ; A518 C9 FE
        beq     @patchAddr                      ; A51A F0 ED
        cmp     #$FD                            ; A51C C9 FD
        beq     @ret                            ; A51E F0 06
        sta     PPUDATA                         ; A520 8D 07 20
        jmp     @patchValue                     ; A523 4C 15 A5

; ----------------------------------------------------------------------------
@ret:   rts                                     ; A526 60

; ----------------------------------------------------------------------------
render_ending:
        lda     gameType                        ; A527 A5 C1
        bne     ending_typeB                    ; A529 D0 03
        jmp     ending_typeA                    ; A52B 4C B1 A9

; ----------------------------------------------------------------------------
ending_typeB:
        lda     levelNumber                     ; A52E A5 44
        cmp     #$09                            ; A530 C9 09
        beq     @typeBConcert                   ; A532 F0 03
        jmp     ending_typeBCathedral           ; A534 4C 25 A6

; ----------------------------------------------------------------------------
@typeBConcert:
        jsr     ending_typeBConcert             ; A537 20 3B A5
        rts                                     ; A53A 60

; ----------------------------------------------------------------------------
ending_typeBConcert:
        lda     player1_startHeight             ; A53B A5 79
        jsr     switchOnA                       ; A53D 20 82 AC
        .addr   @kidIcarus                      ; A540 09 A6
        .addr   @link                           ; A542 F1 A5
        .addr   @samus                          ; A544 D9 A5
        .addr   @donkeyKong                     ; A546 C1 A5
        .addr   @bowser                         ; A548 A9 A5
        .addr   @marioLuigiPeach                ; A54A 4C A5
; ----------------------------------------------------------------------------
@marioLuigiPeach:
        lda     #$C8                            ; A54C A9 C8
        sta     spriteXOffset                   ; A54E 85 A0
        lda     #$47                            ; A550 A9 47
        sta     spriteYOffset                   ; A552 85 A1
        lda     frameCounter                    ; A554 A5 B1
        and     #$08                            ; A556 29 08
        lsr     a                               ; A558 4A
        lsr     a                               ; A559 4A
        lsr     a                               ; A55A 4A
        clc                                     ; A55B 18
        adc     #$21                            ; A55C 69 21
        sta     spriteIndexInOamContentLookup   ; A55E 85 A2
        jsr     loadSpriteIntoOamStaging        ; A560 20 27 8C
        lda     #$A0                            ; A563 A9 A0
        sta     spriteXOffset                   ; A565 85 A0
        lda     #$27                            ; A567 A9 27
        sta     spriteIndexInOamContentLookup   ; A569 85 A2
        lda     frameCounter                    ; A56B A5 B1
        and     #$18                            ; A56D 29 18
        lsr     a                               ; A56F 4A
        lsr     a                               ; A570 4A
        lsr     a                               ; A571 4A
        tax                                     ; A572 AA
        lda     marioFrameToYOffsetTable,x      ; A573 BD 0A A8
        sta     spriteYOffset                   ; A576 85 A1
        cmp     #$97                            ; A578 C9 97
        beq     @marioFrame1                    ; A57A F0 04
        lda     #$28                            ; A57C A9 28
        sta     spriteIndexInOamContentLookup   ; A57E 85 A2
@marioFrame1:
        jsr     loadSpriteIntoOamStaging        ; A580 20 27 8C
@luigiCalculateFrame:
        lda     #$C0                            ; A583 A9 C0
        sta     spriteXOffset                   ; A585 85 A0
        lda     ending                          ; A587 A5 C4
        lsr     a                               ; A589 4A
        lsr     a                               ; A58A 4A
        lsr     a                               ; A58B 4A
        cmp     #$0A                            ; A58C C9 0A
        bne     @luigiFrameCalculated           ; A58E D0 09
        lda     #$00                            ; A590 A9 00
        sta     ending                          ; A592 85 C4
        inc     ending_customVars               ; A594 E6 C5
        jmp     @luigiCalculateFrame            ; A596 4C 83 A5

; ----------------------------------------------------------------------------
@luigiFrameCalculated:
        tax                                     ; A599 AA
        lda     luigiFrameToYOffsetTable,x      ; A59A BD 0E A8
        sta     spriteYOffset                   ; A59D 85 A1
        lda     luigiFrameToSpriteTable,x       ; A59F BD 18 A8
        sta     spriteIndexInOamContentLookup   ; A5A2 85 A2
        jsr     loadSpriteIntoOamStaging        ; A5A4 20 27 8C
        inc     ending                          ; A5A7 E6 C4
@bowser:lda     #$30                            ; A5A9 A9 30
        sta     spriteXOffset                   ; A5AB 85 A0
        lda     #$A7                            ; A5AD A9 A7
        sta     spriteYOffset                   ; A5AF 85 A1
        lda     frameCounter                    ; A5B1 A5 B1
        and     #$10                            ; A5B3 29 10
        lsr     a                               ; A5B5 4A
        lsr     a                               ; A5B6 4A
        lsr     a                               ; A5B7 4A
        lsr     a                               ; A5B8 4A
        clc                                     ; A5B9 18
        adc     #$1F                            ; A5BA 69 1F
        sta     spriteIndexInOamContentLookup   ; A5BC 85 A2
        jsr     loadSpriteIntoOamStaging        ; A5BE 20 27 8C
@donkeyKong:
        lda     #$40                            ; A5C1 A9 40
        sta     spriteXOffset                   ; A5C3 85 A0
        lda     #$77                            ; A5C5 A9 77
        sta     spriteYOffset                   ; A5C7 85 A1
        lda     frameCounter                    ; A5C9 A5 B1
        and     #$10                            ; A5CB 29 10
        lsr     a                               ; A5CD 4A
        lsr     a                               ; A5CE 4A
        lsr     a                               ; A5CF 4A
        lsr     a                               ; A5D0 4A
        clc                                     ; A5D1 18
        adc     #$1D                            ; A5D2 69 1D
        sta     spriteIndexInOamContentLookup   ; A5D4 85 A2
        jsr     loadSpriteIntoOamStaging        ; A5D6 20 27 8C
@samus: lda     #$A8                            ; A5D9 A9 A8
        sta     spriteXOffset                   ; A5DB 85 A0
        lda     #$D7                            ; A5DD A9 D7
        sta     spriteYOffset                   ; A5DF 85 A1
        lda     frameCounter                    ; A5E1 A5 B1
        and     #$10                            ; A5E3 29 10
        lsr     a                               ; A5E5 4A
        lsr     a                               ; A5E6 4A
        lsr     a                               ; A5E7 4A
        lsr     a                               ; A5E8 4A
        clc                                     ; A5E9 18
        adc     #$1A                            ; A5EA 69 1A
        sta     spriteIndexInOamContentLookup   ; A5EC 85 A2
        jsr     loadSpriteIntoOamStaging        ; A5EE 20 27 8C
@link:  lda     #$C8                            ; A5F1 A9 C8
        sta     spriteXOffset                   ; A5F3 85 A0
        lda     #$D7                            ; A5F5 A9 D7
        sta     spriteYOffset                   ; A5F7 85 A1
        lda     frameCounter                    ; A5F9 A5 B1
        and     #$10                            ; A5FB 29 10
        lsr     a                               ; A5FD 4A
        lsr     a                               ; A5FE 4A
        lsr     a                               ; A5FF 4A
        lsr     a                               ; A600 4A
        clc                                     ; A601 18
        adc     #$18                            ; A602 69 18
        sta     spriteIndexInOamContentLookup   ; A604 85 A2
        jsr     loadSpriteIntoOamStaging        ; A606 20 27 8C
@kidIcarus:
        lda     #$28                            ; A609 A9 28
        sta     spriteXOffset                   ; A60B 85 A0
        lda     #$77                            ; A60D A9 77
        sta     spriteYOffset                   ; A60F 85 A1
        lda     frameCounter                    ; A611 A5 B1
        and     #$10                            ; A613 29 10
        lsr     a                               ; A615 4A
        lsr     a                               ; A616 4A
        lsr     a                               ; A617 4A
        lsr     a                               ; A618 4A
        clc                                     ; A619 18
        adc     #$16                            ; A61A 69 16
        sta     spriteIndexInOamContentLookup   ; A61C 85 A2
        jsr     loadSpriteIntoOamStaging        ; A61E 20 27 8C
        jsr     LA6BC                           ; A621 20 BC A6
        rts                                     ; A624 60

; ----------------------------------------------------------------------------
ending_typeBCathedral:
        jsr     ending_typeBCathedralSetSprite  ; A625 20 90 A6
        inc     ending_typeBCathedralFrameDelayCounter; A628 E6 CD
        lda     #$00                            ; A62A A9 00
        sta     ending_currentSprite            ; A62C 85 CC
@spriteLoop:
        ldx     levelNumber                     ; A62E A6 44
        lda     LA767,x                         ; A630 BD 67 A7
        sta     generalCounter                  ; A633 85 A8
        ldx     ending_currentSprite            ; A635 A6 CC
        lda     ending_customVars+1,x           ; A637 B5 C6
        cmp     generalCounter                  ; A639 C5 A8
        beq     @continue                       ; A63B F0 38
        sta     spriteXOffset                   ; A63D 85 A0
        jsr     ending_computeTypeBCathedralYTableIndex; A63F 20 AE A6
        lda     ending_typeBCathedralYTable,x   ; A642 BD B7 A7
        sta     spriteYOffset                   ; A645 85 A1
        jsr     loadSpriteIntoOamStaging        ; A647 20 27 8C
        ldx     levelNumber                     ; A64A A6 44
        lda     ending_typeBCathedralFrameDelayTable,x; A64C BD 53 A7
        cmp     ending_typeBCathedralFrameDelayCounter; A64F C5 CD
        bne     @continue                       ; A651 D0 22
        ldx     levelNumber                     ; A653 A6 44
        lda     ending_typeBCathedralVectorTable,x; A655 BD 71 A7
        clc                                     ; A658 18
        adc     spriteXOffset                   ; A659 65 A0
        sta     spriteXOffset                   ; A65B 85 A0
        ldx     ending_currentSprite            ; A65D A6 CC
        sta     ending_customVars+1,x           ; A65F 95 C6
        jsr     ending_computeTypeBCathedralYTableIndex; A661 20 AE A6
        lda     ending_typeBCathedralXTable,x   ; A664 BD 7B A7
        cmp     spriteXOffset                   ; A667 C5 A0
        bne     @continue                       ; A669 D0 0A
        ldx     levelNumber                     ; A66B A6 44
        lda     LA75D,x                         ; A66D BD 5D A7
        ldx     ending_currentSprite            ; A670 A6 CC
        inx                                     ; A672 E8
        sta     ending_customVars+1,x           ; A673 95 C6
@continue:
        lda     ending_currentSprite            ; A675 A5 CC
        sta     generalCounter                  ; A677 85 A8
        cmp     startHeight                     ; A679 C5 59
        beq     @done                           ; A67B F0 05
        inc     ending_currentSprite            ; A67D E6 CC
        jmp     @spriteLoop                     ; A67F 4C 2E A6

; ----------------------------------------------------------------------------
@done:  ldx     levelNumber                     ; A682 A6 44
        lda     ending_typeBCathedralFrameDelayTable,x; A684 BD 53 A7
        cmp     ending_typeBCathedralFrameDelayCounter; A687 C5 CD
        bne     @ret                            ; A689 D0 04
        lda     #$00                            ; A68B A9 00
        sta     ending_typeBCathedralFrameDelayCounter; A68D 85 CD
@ret:   rts                                     ; A68F 60

; ----------------------------------------------------------------------------
ending_typeBCathedralSetSprite:
        inc     ending                          ; A690 E6 C4
        ldx     levelNumber                     ; A692 A6 44
        lda     ending_typeBCathedralAnimSpeed,x; A694 BD 49 A7
        cmp     ending                          ; A697 C5 C4
        bne     @skipAnimSpriteChange           ; A699 D0 0A
        lda     ending_customVars               ; A69B A5 C5
        eor     #$01                            ; A69D 49 01
        sta     ending_customVars               ; A69F 85 C5
        lda     #$00                            ; A6A1 A9 00
        sta     ending                          ; A6A3 85 C4
@skipAnimSpriteChange:
        lda     ending_typeBCathedralSpriteTable,x; A6A5 BD F3 A7
        clc                                     ; A6A8 18
        adc     ending_customVars               ; A6A9 65 C5
        sta     spriteIndexInOamContentLookup   ; A6AB 85 A2
        rts                                     ; A6AD 60

; ----------------------------------------------------------------------------
; levelNumber * 6 + currentEndingBSprite
ending_computeTypeBCathedralYTableIndex:
        lda     levelNumber                     ; A6AE A5 44
        asl     a                               ; A6B0 0A
        sta     generalCounter                  ; A6B1 85 A8
        asl     a                               ; A6B3 0A
        clc                                     ; A6B4 18
        adc     generalCounter                  ; A6B5 65 A8
        clc                                     ; A6B7 18
        adc     ending_currentSprite            ; A6B8 65 CC
        tax                                     ; A6BA AA
        rts                                     ; A6BB 60

; ----------------------------------------------------------------------------
LA6BC:  ldx     #$00                            ; A6BC A2 00
LA6BE:  lda     LA735,x                         ; A6BE BD 35 A7
        cmp     ending_customVars               ; A6C1 C5 C5
        bne     LA6D0                           ; A6C3 D0 0B
        lda     ending_customVars+3,x           ; A6C5 B5 C8
        beq     LA6D0                           ; A6C7 F0 07
        sec                                     ; A6C9 38
        sbc     #$01                            ; A6CA E9 01
        sta     ending_customVars+3,x           ; A6CC 95 C8
        inc     ending_customVars               ; A6CE E6 C5
LA6D0:  inx                                     ; A6D0 E8
        cpx     #$04                            ; A6D1 E0 04
        bne     LA6BE                           ; A6D3 D0 E9
        lda     #$00                            ; A6D5 A9 00
        sta     ending_currentSprite            ; A6D7 85 CC
LA6D9:  ldx     ending_currentSprite            ; A6D9 A6 CC
        lda     ending_customVars+3,x           ; A6DB B5 C8
        beq     LA72C                           ; A6DD F0 4D
        sta     generalCounter                  ; A6DF 85 A8
        lda     LA73D,x                         ; A6E1 BD 3D A7
        cmp     generalCounter                  ; A6E4 C5 A8
        beq     LA6F7                           ; A6E6 F0 0F
        lda     #$03                            ; A6E8 A9 03
        sta     soundEffectSlot0Init            ; A6EA 8D F0 06
        dec     generalCounter                  ; A6ED C6 A8
        lda     generalCounter                  ; A6EF A5 A8
        cmp     #$A0                            ; A6F1 C9 A0
        bcs     LA6F7                           ; A6F3 B0 02
        dec     generalCounter                  ; A6F5 C6 A8
LA6F7:  lda     generalCounter                  ; A6F7 A5 A8
        sta     ending_customVars+3,x           ; A6F9 95 C8
        sta     spriteYOffset                   ; A6FB 85 A1
        lda     domeNumberToXOffsetTable,x      ; A6FD BD 39 A7
        sta     spriteXOffset                   ; A700 85 A0
        lda     domeNumberToSpriteTable,x       ; A702 BD 41 A7
        sta     spriteIndexInOamContentLookup   ; A705 85 A2
        jsr     loadSpriteIntoOamStaging        ; A707 20 27 8C
        ldx     ending_currentSprite            ; A70A A6 CC
        lda     ending_customVars+3,x           ; A70C B5 C8
        sta     generalCounter                  ; A70E 85 A8
        lda     LA73D,x                         ; A710 BD 3D A7
        cmp     generalCounter                  ; A713 C5 A8
        beq     LA72C                           ; A715 F0 15
        lda     LA745,x                         ; A717 BD 45 A7
        clc                                     ; A71A 18
        adc     spriteXOffset                   ; A71B 65 A0
        sta     spriteXOffset                   ; A71D 85 A0
        lda     frameCounter                    ; A71F A5 B1
        and     #$02                            ; A721 29 02
        lsr     a                               ; A723 4A
        clc                                     ; A724 18
        adc     #$51                            ; A725 69 51
        sta     spriteIndexInOamContentLookup   ; A727 85 A2
        jsr     loadSpriteIntoOamStaging        ; A729 20 27 8C
LA72C:  inc     ending_currentSprite            ; A72C E6 CC
        lda     ending_currentSprite            ; A72E A5 CC
        cmp     #$04                            ; A730 C9 04
        bne     LA6D9                           ; A732 D0 A5
        rts                                     ; A734 60

; ----------------------------------------------------------------------------
LA735:  .byte   $05,$07,$09,$0B                 ; A735 05 07 09 0B
domeNumberToXOffsetTable:
        .byte   $60,$90,$70,$7E                 ; A739 60 90 70 7E
LA73D:  .byte   $BC                             ; A73D BC
LA73E:  .byte   $B8                             ; A73E B8
LA73F:  .byte   $BC                             ; A73F BC
LA740:  .byte   $B3                             ; A740 B3
domeNumberToSpriteTable:
        .byte   $4D,$50,$4E,$4F                 ; A741 4D 50 4E 4F
LA745:  .byte   $00,$00,$00,$02                 ; A745 00 00 00 02
; Frames before changing to next frame's sprite
ending_typeBCathedralAnimSpeed:
        .byte   $02,$04,$06,$03,$10,$03,$05,$06 ; A749 02 04 06 03 10 03 05 06
        .byte   $02,$05                         ; A751 02 05
; Number of frames to keep sprites in same position (inverse of vector table)
ending_typeBCathedralFrameDelayTable:
        .byte   $03,$01,$01,$01,$02,$05,$01,$02 ; A753 03 01 01 01 02 05 01 02
        .byte   $01,$01                         ; A75B 01 01
LA75D:  .byte   $02,$02,$FE,$FE,$02,$FE,$02,$02 ; A75D 02 02 FE FE 02 FE 02 02
        .byte   $FE,$02                         ; A765 FE 02
LA767:  .byte   $00,$00,$00,$02,$F0,$10,$F0,$F0 ; A767 00 00 00 02 F0 10 F0 F0
        .byte   $20,$F0                         ; A76F 20 F0
ending_typeBCathedralVectorTable:
        .byte   $01,$01,$FF,$FC,$01,$FF,$02,$02 ; A771 01 01 FF FC 01 FF 02 02
        .byte   $FE,$02                         ; A779 FE 02
ending_typeBCathedralXTable:
        .byte   $3A,$24,$0A,$4A,$3A,$FF,$22,$44 ; A77B 3A 24 0A 4A 3A FF 22 44
        .byte   $12,$32,$4A,$FF,$AE,$6E,$8E,$6E ; A783 12 32 4A FF AE 6E 8E 6E
        .byte   $1E,$02,$42,$42,$42,$42,$42,$02 ; A78B 1E 02 42 42 42 42 42 02
        .byte   $22,$0A,$1A,$04,$0A,$FF,$EE,$DE ; A793 22 0A 1A 04 0A FF EE DE
        .byte   $FC,$FC,$F6,$02,$80,$80,$80,$80 ; A79B FC FC F6 02 80 80 80 80
        .byte   $80,$FF,$E8,$E8,$E8,$E8,$48,$FF ; A7A3 80 FF E8 E8 E8 E8 48 FF
        .byte   $80,$AE,$9E,$90,$80,$02,$80,$80 ; A7AB 80 AE 9E 90 80 02 80 80
        .byte   $80,$80,$80,$FF                 ; A7B3 80 80 80 FF
ending_typeBCathedralYTable:
        .byte   $98,$A8,$C0,$A8,$90,$B0,$B0,$B8 ; A7B7 98 A8 C0 A8 90 B0 B0 B8
        .byte   $A0,$B8,$A8,$A0,$C8,$C8,$C8,$C8 ; A7BF A0 B8 A8 A0 C8 C8 C8 C8
        .byte   $C8,$C8,$30,$20,$40,$28,$A0,$80 ; A7C7 C8 C8 30 20 40 28 A0 80
        .byte   $A8,$88,$68,$A8,$48,$78,$58,$68 ; A7CF A8 88 68 A8 48 78 58 68
        .byte   $18,$48,$78,$38,$C8,$C8,$C8,$C8 ; A7D7 18 48 78 38 C8 C8 C8 C8
        .byte   $C8,$C8,$90,$58,$70,$A8,$40,$38 ; A7DF C8 C8 90 58 70 A8 40 38
        .byte   $68,$88,$78,$18,$48,$A8,$C8,$C8 ; A7E7 68 88 78 18 48 A8 C8 C8
        .byte   $C8,$C8,$C8,$C8                 ; A7EF C8 C8 C8 C8
ending_typeBCathedralSpriteTable:
        .byte   $2C,$2E,$54,$32,$34,$36,$4B,$38 ; A7F3 2C 2E 54 32 34 36 4B 38
        .byte   $3A,$4B                         ; A7FB 3A 4B
; ----------------------------------------------------------------------------
render_endingUnskippable:
        sta     sleepCounter                    ; A7FD 85 C3
@loopUntilEnoughFrames:
        jsr     render_ending                   ; A7FF 20 27 A5
        jsr     updateAudioWaitForNmiAndResetOamStaging; A802 20 2F AA
        lda     sleepCounter                    ; A805 A5 C3
        bne     @loopUntilEnoughFrames          ; A807 D0 F6
        rts                                     ; A809 60

; ----------------------------------------------------------------------------
marioFrameToYOffsetTable:
        .byte   $97,$8F,$87,$8F                 ; A80A 97 8F 87 8F
luigiFrameToYOffsetTable:
        .byte   $97,$8F,$87,$87,$8F,$97,$8F,$87 ; A80E 97 8F 87 87 8F 97 8F 87
        .byte   $87,$8F                         ; A816 87 8F
luigiFrameToSpriteTable:
        .byte   $29,$29,$29,$2A,$2A,$2A,$2A,$2A ; A818 29 29 29 2A 2A 2A 2A 2A
        .byte   $29,$29                         ; A820 29 29
; Used by patchToPpu. Address followed by bytes to write. $FE to start next address. $FD to end
ending_patchToPpu_typeBConcertHeightUnused:
        .byte   $21,$A5,$FF,$FF,$FF,$FE,$21,$C5 ; A822 21 A5 FF FF FF FE 21 C5
        .byte   $FF,$FF,$FF,$FE,$21,$E5,$FF,$FF ; A82A FF FF FF FE 21 E5 FF FF
        .byte   $FF,$FD                         ; A832 FF FD
ending_patchToPpu_typeBConcertHeight0:
        .byte   $23,$1A,$FF,$FE,$23,$39,$FF,$FF ; A834 23 1A FF FE 23 39 FF FF
        .byte   $FF,$FE,$23,$59,$FF,$FF,$FF,$FE ; A83C FF FE 23 59 FF FF FF FE
        .byte   $23,$79,$FF,$FF,$FF,$FD         ; A844 23 79 FF FF FF FD
ending_patchToPpu_typeBConcertHeight1:
        .byte   $23,$15,$FF,$FF,$FF,$FE,$23,$35 ; A84A 23 15 FF FF FF FE 23 35
        .byte   $FF,$FF,$FF,$FE,$23,$55,$FF,$FF ; A852 FF FF FF FE 23 55 FF FF
        .byte   $FF,$FE,$23,$75,$FF,$FF,$FF,$FD ; A85A FF FE 23 75 FF FF FF FD
ending_patchToPpu_typeBConcertHeight2:
        .byte   $21,$88,$FF,$FF,$FF,$FE,$21,$A8 ; A862 21 88 FF FF FF FE 21 A8
        .byte   $FF,$FF,$FF,$FE,$21,$C8,$FF,$FF ; A86A FF FF FF FE 21 C8 FF FF
        .byte   $FF,$FE,$21,$E8,$FF,$FF,$FF,$FD ; A872 FF FE 21 E8 FF FF FF FD
ending_patchToPpu_typeBConcertHeight3:
        .byte   $22,$46,$FF,$FF,$FF,$FF,$FE,$22 ; A87A 22 46 FF FF FF FF FE 22
        .byte   $66,$FF,$FF,$FF,$FF,$FE,$22,$86 ; A882 66 FF FF FF FF FE 22 86
        .byte   $FF,$FF,$FF,$FF,$FE,$22,$A6,$FF ; A88A FF FF FF FF FE 22 A6 FF
        .byte   $FF,$FF,$FF,$FD                 ; A892 FF FF FF FD
ending_patchToPpu_typeBConcertHeight4:
        .byte   $20,$F9,$FF,$FF,$FF,$FE,$21,$19 ; A896 20 F9 FF FF FF FE 21 19
        .byte   $FF,$FF,$FF,$FE,$21,$39,$FF,$FF ; A89E FF FF FF FE 21 39 FF FF
        .byte   $FF,$FD                         ; A8A6 FF FD
unreferenced_patchToPpu0:
        .byte   $23,$35,$FF,$FF,$FF,$FE,$23,$55 ; A8A8 23 35 FF FF FF FE 23 55
        .byte   $FF,$FF,$FF,$FE,$23,$75,$FF,$FF ; A8B0 FF FF FF FE 23 75 FF FF
        .byte   $FF,$FD                         ; A8B8 FF FD
unreferenced_patchToPpu1:
        .byte   $23,$39,$FF,$FF,$FF,$FE,$23,$59 ; A8BA 23 39 FF FF FF FE 23 59
        .byte   $FF,$FF,$FF,$FE,$23,$79,$FF,$FF ; A8C2 FF FF FF FE 23 79 FF FF
        .byte   $FF,$FD                         ; A8CA FF FD
ending_patchToPpu_typeAOver120k:
        .byte   $22,$58,$FF,$FE,$22,$75,$FF,$FF ; A8CC 22 58 FF FE 22 75 FF FF
        .byte   $FF,$FF,$FF,$FF,$FE,$22,$94,$FF ; A8D4 FF FF FF FF FE 22 94 FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FE ; A8DC FF FF FF FF FF FF FF FE
        .byte   $22,$B4,$FF,$FF,$FF,$FF,$FF,$FF ; A8E4 22 B4 FF FF FF FF FF FF
        .byte   $FF,$FF,$FE,$22,$D4,$FF,$FF,$FF ; A8EC FF FF FE 22 D4 FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FE,$22,$F4 ; A8F4 FF FF FF FF FF FE 22 F4
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A8FC FF FF FF FF FF FF FF FF
        .byte   $FE,$23,$14,$FF,$FF,$FF,$FF,$FF ; A904 FE 23 14 FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FE,$23,$34,$FF,$FF ; A90C FF FF FF FE 23 34 FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FE,$22 ; A914 FF FF FF FF FF FF FE 22
        .byte   $CA,$46,$47,$FE,$22,$EA,$56,$57 ; A91C CA 46 47 FE 22 EA 56 57
        .byte   $FD                             ; A924 FD
unreferenced_data6:
        .byte   $FC                             ; A925 FC
; ----------------------------------------------------------------------------
LA926:  jsr     updateAudioWaitForNmiAndDisablePpuRendering; A926 20 52 AA
        jsr     disableNmi                      ; A929 20 78 AA
        lda     #$02                            ; A92C A9 02
        jsr     changeCHRBank0                  ; A92E 20 B7 AC
        lda     #$02                            ; A931 A9 02
        jsr     changeCHRBank1                  ; A933 20 CB AC
        jsr     bulkCopyToPpu                   ; A936 20 98 AA
        .addr   type_a_ending_nametable         ; A939 68 D2
; ----------------------------------------------------------------------------
        jsr     bulkCopyToPpu                   ; A93B 20 98 AA
        .addr   ending_palette                  ; A93E 43 AD
; ----------------------------------------------------------------------------
        jsr     LA96E                           ; A940 20 6E A9
        jsr     waitForVBlankAndEnableNmi       ; A943 20 6B AA
        jsr     updateAudioWaitForNmiAndResetOamStaging; A946 20 2F AA
        jsr     updateAudioWaitForNmiAndEnablePpuRendering; A949 20 5F AA
        jsr     updateAudioWaitForNmiAndResetOamStaging; A94C 20 2F AA
        lda     #$04                            ; A94F A9 04
        sta     renderMode                      ; A951 85 BD
        lda     #$0A                            ; A953 A9 0A
        jsr     setMusicTrack                   ; A955 20 07 9E
        lda     #$80                            ; A958 A9 80
        jsr     render_endingUnskippable        ; A95A 20 FD A7
LA95D:  jsr     render_ending                   ; A95D 20 27 A5
        jsr     updateAudioWaitForNmiAndResetOamStaging; A960 20 2F AA
        lda     ending_customVars               ; A963 A5 C5
        bne     LA95D                           ; A965 D0 F6
        lda     newlyPressedButtons_player1     ; A967 A5 F5
        cmp     #$10                            ; A969 C9 10
        bne     LA95D                           ; A96B D0 F0
        rts                                     ; A96D 60

; ----------------------------------------------------------------------------
LA96E:  lda     #$00                            ; A96E A9 00
        sta     ending                          ; A970 85 C4
        lda     player1_score+2                 ; A972 A5 75
        cmp     #$05                            ; A974 C9 05
        bcc     ending_selected                 ; A976 90 2D
        lda     #$01                            ; A978 A9 01
        sta     ending                          ; A97A 85 C4
        lda     player1_score+2                 ; A97C A5 75
        cmp     #$07                            ; A97E C9 07
        bcc     ending_selected                 ; A980 90 23
        lda     #$02                            ; A982 A9 02
        sta     ending                          ; A984 85 C4
        lda     player1_score+2                 ; A986 A5 75
        cmp     #$10                            ; A988 C9 10
        bcc     ending_selected                 ; A98A 90 19
        lda     #$03                            ; A98C A9 03
        sta     ending                          ; A98E 85 C4
        lda     player1_score+2                 ; A990 A5 75
        cmp     #$12                            ; A992 C9 12
        bcc     ending_selected                 ; A994 90 0F
        lda     #$04                            ; A996 A9 04
        sta     ending                          ; A998 85 C4
        lda     #$A8                            ; A99A A9 A8
        sta     patchToPpuAddr+1                ; A99C 85 15
        lda     #$CC                            ; A99E A9 CC
        sta     patchToPpuAddr                  ; A9A0 85 14
        jsr     patchToPpu                      ; A9A2 20 07 A5
ending_selected:
        ldx     ending                          ; A9A5 A6 C4
        lda     ending_customVars_init,x        ; A9A7 BD 2A AA
        sta     ending_customVars               ; A9AA 85 C5
        lda     #$00                            ; A9AC A9 00
        sta     ending_customVars+1             ; A9AE 85 C6
        rts                                     ; A9B0 60

; ----------------------------------------------------------------------------
ending_typeA:
        lda     ending_customVars               ; A9B1 A5 C5
        cmp     #$00                            ; A9B3 C9 00
        beq     LAA10                           ; A9B5 F0 59
        sta     spriteYOffset                   ; A9B7 85 A1
        lda     #$58                            ; A9B9 A9 58
        ldx     ending                          ; A9BB A6 C4
        lda     rocketToXOffsetTable,x          ; A9BD BD 25 AA
        sta     spriteXOffset                   ; A9C0 85 A0
        lda     rocketToSpriteTable,x           ; A9C2 BD 11 AA
        sta     spriteIndexInOamContentLookup   ; A9C5 85 A2
        jsr     loadSpriteIntoOamStaging        ; A9C7 20 27 8C
        lda     ending                          ; A9CA A5 C4
        asl     a                               ; A9CC 0A
        sta     generalCounter                  ; A9CD 85 A8
        lda     frameCounter                    ; A9CF A5 B1
        and     #$02                            ; A9D1 29 02
        lsr     a                               ; A9D3 4A
        clc                                     ; A9D4 18
        adc     generalCounter                  ; A9D5 65 A8
        tax                                     ; A9D7 AA
        lda     rocketToJetSpriteTable,x        ; A9D8 BD 16 AA
        sta     spriteIndexInOamContentLookup   ; A9DB 85 A2
        ldx     ending                          ; A9DD A6 C4
        lda     rocketToJetXOffsetTable,x       ; A9DF BD 20 AA
        clc                                     ; A9E2 18
        adc     spriteXOffset                   ; A9E3 65 A0
        sta     spriteXOffset                   ; A9E5 85 A0
        jsr     loadSpriteIntoOamStaging        ; A9E7 20 27 8C
        lda     ending_customVars+1             ; A9EA A5 C6
        cmp     #$F0                            ; A9EC C9 F0
        bne     LAA0E                           ; A9EE D0 1E
        lda     ending_customVars               ; A9F0 A5 C5
        cmp     #$B0                            ; A9F2 C9 B0
        bcc     LA9FC                           ; A9F4 90 06
        lda     frameCounter                    ; A9F6 A5 B1
        and     #$01                            ; A9F8 29 01
        bne     LAA0B                           ; A9FA D0 0F
LA9FC:  lda     #$03                            ; A9FC A9 03
        sta     soundEffectSlot0Init            ; A9FE 8D F0 06
        dec     ending_customVars               ; AA01 C6 C5
        lda     ending_customVars               ; AA03 A5 C5
        cmp     #$80                            ; AA05 C9 80
        bcs     LAA0B                           ; AA07 B0 02
        dec     ending_customVars               ; AA09 C6 C5
LAA0B:  jmp     LAA10                           ; AA0B 4C 10 AA

; ----------------------------------------------------------------------------
LAA0E:  inc     ending_customVars+1             ; AA0E E6 C6
LAA10:  rts                                     ; AA10 60

; ----------------------------------------------------------------------------
rocketToSpriteTable:
        .byte   $3E,$41,$44,$47,$4A             ; AA11 3E 41 44 47 4A
rocketToJetSpriteTable:
        .byte   $3F,$40,$42,$43,$45,$46,$48,$49 ; AA16 3F 40 42 43 45 46 48 49
        .byte   $23,$24                         ; AA1E 23 24
rocketToJetXOffsetTable:
        .byte   $00,$00,$00,$00,$00             ; AA20 00 00 00 00 00
rocketToXOffsetTable:
        .byte   $54,$54,$50,$48,$A0             ; AA25 54 54 50 48 A0
ending_customVars_init:
        .byte   $BF,$BF,$BF,$BF,$C7             ; AA2A BF BF BF BF C7
; ----------------------------------------------------------------------------
; canon is waitForVerticalBlankingInterval
updateAudioWaitForNmiAndResetOamStaging:
        jsr     updateAudio_jmp                 ; AA2F 20 00 E0
        lda     #$00                            ; AA32 A9 00
        sta     verticalBlankingInterval        ; AA34 85 33
        nop                                     ; AA36 EA
@checkForNmi:
        lda     verticalBlankingInterval        ; AA37 A5 33
        beq     @checkForNmi                    ; AA39 F0 FC
        lda     #$FF                            ; AA3B A9 FF
        ldx     #$02                            ; AA3D A2 02
        ldy     #$02                            ; AA3F A0 02
        jsr     memset_page                     ; AA41 20 6A AC
        rts                                     ; AA44 60

; ----------------------------------------------------------------------------
updateAudioAndWaitForNmi:
        jsr     updateAudio_jmp                 ; AA45 20 00 E0
        lda     #$00                            ; AA48 A9 00
        sta     verticalBlankingInterval        ; AA4A 85 33
        nop                                     ; AA4C EA
@checkForNmi:
        lda     verticalBlankingInterval        ; AA4D A5 33
        beq     @checkForNmi                    ; AA4F F0 FC
        rts                                     ; AA51 60

; ----------------------------------------------------------------------------
updateAudioWaitForNmiAndDisablePpuRendering:
        jsr     updateAudioAndWaitForNmi        ; AA52 20 45 AA
        lda     currentPpuMask                  ; AA55 A5 FE
        and     #$E1                            ; AA57 29 E1
_updatePpuMask:
        sta     PPUMASK                         ; AA59 8D 01 20
        sta     currentPpuMask                  ; AA5C 85 FE
        rts                                     ; AA5E 60

; ----------------------------------------------------------------------------
updateAudioWaitForNmiAndEnablePpuRendering:
        jsr     updateAudioAndWaitForNmi        ; AA5F 20 45 AA
        jsr     copyCurrentScrollAndCtrlToPPU   ; AA62 20 8A AA
        lda     currentPpuMask                  ; AA65 A5 FE
        ora     #$1E                            ; AA67 09 1E
        bne     _updatePpuMask                  ; AA69 D0 EE
waitForVBlankAndEnableNmi:
        lda     PPUSTATUS                       ; AA6B AD 02 20
        and     #$80                            ; AA6E 29 80
        bne     waitForVBlankAndEnableNmi       ; AA70 D0 F9
        lda     currentPpuCtrl                  ; AA72 A5 FF
        ora     #$80                            ; AA74 09 80
        bne     _updatePpuCtrl                  ; AA76 D0 04
disableNmi:
        lda     currentPpuCtrl                  ; AA78 A5 FF
        and     #$7F                            ; AA7A 29 7F
_updatePpuCtrl:
        sta     PPUCTRL                         ; AA7C 8D 00 20
        sta     currentPpuCtrl                  ; AA7F 85 FF
        rts                                     ; AA81 60

; ----------------------------------------------------------------------------
LAA82:  ldx     #$FF                            ; AA82 A2 FF
        ldy     #$00                            ; AA84 A0 00
        jsr     memset_ppu_page                 ; AA86 20 1C AC
        rts                                     ; AA89 60

; ----------------------------------------------------------------------------
copyCurrentScrollAndCtrlToPPU:
        lda     #$00                            ; AA8A A9 00
        sta     PPUSCROLL                       ; AA8C 8D 05 20
        sta     PPUSCROLL                       ; AA8F 8D 05 20
        lda     currentPpuCtrl                  ; AA92 A5 FF
        sta     PPUCTRL                         ; AA94 8D 00 20
        rts                                     ; AA97 60

; ----------------------------------------------------------------------------
; Return address should contain data address; ret addr+2 is actual return. $80-$FF end. $4C recurse, 2 byte cpu addr. $60 unrecurse. Otherwise NES data stripe, 2 byte ppu addr, 1 byte length, data. length controls RLE and write direction
bulkCopyToPpu:
        jsr     bulkCopyToPpu_reworkReturnAddress; AA98 20 21 AB
        jmp     @processInst                    ; AA9B 4C F2 AA

; ----------------------------------------------------------------------------
@processStripe:
        pha                                     ; AA9E 48
        sta     PPUADDR                         ; AA9F 8D 06 20
        iny                                     ; AAA2 C8
        lda     (tmp1),y                        ; AAA3 B1 00
        sta     PPUADDR                         ; AAA5 8D 06 20
        iny                                     ; AAA8 C8
        lda     (tmp1),y                        ; AAA9 B1 00
        asl     a                               ; AAAB 0A
        pha                                     ; AAAC 48
        lda     currentPpuCtrl                  ; AAAD A5 FF
        ora     #$04                            ; AAAF 09 04
        bcs     @setDirection                   ; AAB1 B0 02
        and     #$FB                            ; AAB3 29 FB
; Bit 7 of length: 0-right, 1-down
@setDirection:
        sta     PPUCTRL                         ; AAB5 8D 00 20
        sta     currentPpuCtrl                  ; AAB8 85 FF
        pla                                     ; AABA 68
        asl     a                               ; AABB 0A
        php                                     ; AABC 08
        bcc     @checkForZeroLength             ; AABD 90 03
        ora     #$02                            ; AABF 09 02
        iny                                     ; AAC1 C8
; Bit 6 of length: 0-literal, 1-run. If bits 0-5 are zero, length is 64
@checkForZeroLength:
        plp                                     ; AAC2 28
        clc                                     ; AAC3 18
        bne     @clearLengthFlagBits            ; AAC4 D0 01
        sec                                     ; AAC6 38
@clearLengthFlagBits:
        ror     a                               ; AAC7 6A
        lsr     a                               ; AAC8 4A
        tax                                     ; AAC9 AA
@copyByteLoop:
        bcs     @copyByte                       ; AACA B0 01
        iny                                     ; AACC C8
@copyByte:
        lda     (tmp1),y                        ; AACD B1 00
        sta     PPUDATA                         ; AACF 8D 07 20
        dex                                     ; AAD2 CA
        bne     @copyByteLoop                   ; AAD3 D0 F5
        pla                                     ; AAD5 68
        cmp     #$3F                            ; AAD6 C9 3F
        bne     @pointToNext                    ; AAD8 D0 0C
        sta     PPUADDR                         ; AADA 8D 06 20
        stx     PPUADDR                         ; AADD 8E 06 20
        stx     PPUADDR                         ; AAE0 8E 06 20
        stx     PPUADDR                         ; AAE3 8E 06 20
@pointToNext:
        sec                                     ; AAE6 38
        tya                                     ; AAE7 98
        adc     tmp1                            ; AAE8 65 00
        sta     tmp1                            ; AAEA 85 00
        lda     #$00                            ; AAEC A9 00
        adc     tmp2                            ; AAEE 65 01
        sta     tmp2                            ; AAF0 85 01
; Address to read from stored in tmp1/2
@processInst:
        ldx     PPUSTATUS                       ; AAF2 AE 02 20
        ldy     #$00                            ; AAF5 A0 00
        lda     (tmp1),y                        ; AAF7 B1 00
        bpl     @checkUnrecurse                 ; AAF9 10 01
        rts                                     ; AAFB 60

; ----------------------------------------------------------------------------
@checkUnrecurse:
        cmp     #$60                            ; AAFC C9 60
        bne     @checkRecurse                   ; AAFE D0 0A
        pla                                     ; AB00 68
        sta     tmp2                            ; AB01 85 01
        pla                                     ; AB03 68
        sta     tmp1                            ; AB04 85 00
        ldy     #$02                            ; AB06 A0 02
        bne     @pointToNext                    ; AB08 D0 DC
@checkRecurse:
        cmp     #$4C                            ; AB0A C9 4C
        bne     @processStripe                  ; AB0C D0 90
        lda     tmp1                            ; AB0E A5 00
        pha                                     ; AB10 48
        lda     tmp2                            ; AB11 A5 01
        pha                                     ; AB13 48
        iny                                     ; AB14 C8
        lda     (tmp1),y                        ; AB15 B1 00
        tax                                     ; AB17 AA
        iny                                     ; AB18 C8
        lda     (tmp1),y                        ; AB19 B1 00
        sta     tmp2                            ; AB1B 85 01
        stx     tmp1                            ; AB1D 86 00
        bcs     @processInst                    ; AB1F B0 D1
; Copies address at return to tmp0/tmp1. Increments return by two
bulkCopyToPpu_reworkReturnAddress:
        tsx                                     ; AB21 BA
        lda     stack+3,x                       ; AB22 BD 03 01
        sta     tmpBulkCopyToPpuReturnAddr      ; AB25 85 05
        lda     stack+4,x                       ; AB27 BD 04 01
        sta     tmpBulkCopyToPpuReturnAddr+1    ; AB2A 85 06
        ldy     #$01                            ; AB2C A0 01
        lda     (tmpBulkCopyToPpuReturnAddr),y  ; AB2E B1 05
        sta     tmp1                            ; AB30 85 00
        iny                                     ; AB32 C8
        lda     (tmpBulkCopyToPpuReturnAddr),y  ; AB33 B1 05
        sta     tmp2                            ; AB35 85 01
        clc                                     ; AB37 18
        lda     #$02                            ; AB38 A9 02
        adc     tmpBulkCopyToPpuReturnAddr      ; AB3A 65 05
        sta     stack+3,x                       ; AB3C 9D 03 01
        lda     #$00                            ; AB3F A9 00
        adc     tmpBulkCopyToPpuReturnAddr+1    ; AB41 65 06
        sta     stack+4,x                       ; AB43 9D 04 01
        rts                                     ; AB46 60

; ----------------------------------------------------------------------------
; reg x: zeropage addr of seed; reg y: size of seed
generateNextPseudorandomNumber:
        lda     tmp1,x                          ; AB47 B5 00
        and     #$02                            ; AB49 29 02
        sta     tmp1                            ; AB4B 85 00
        lda     tmp2,x                          ; AB4D B5 01
        and     #$02                            ; AB4F 29 02
        eor     tmp1                            ; AB51 45 00
        clc                                     ; AB53 18
        beq     @updateNextByteInSeed           ; AB54 F0 01
        sec                                     ; AB56 38
@updateNextByteInSeed:
        ror     tmp1,x                          ; AB57 76 00
        inx                                     ; AB59 E8
        dey                                     ; AB5A 88
        bne     @updateNextByteInSeed           ; AB5B D0 FA
        rts                                     ; AB5D 60

; ----------------------------------------------------------------------------
; canon is initializeOAM
copyOamStagingToOam:
        lda     #$00                            ; AB5E A9 00
        sta     OAMADDR                         ; AB60 8D 03 20
        lda     #$02                            ; AB63 A9 02
        sta     OAMDMA                          ; AB65 8D 14 40
        rts                                     ; AB68 60

; ----------------------------------------------------------------------------
pollController_actualRead:
        ldx     joy1Location                    ; AB69 A6 FB
        inx                                     ; AB6B E8
        stx     JOY1                            ; AB6C 8E 16 40
        dex                                     ; AB6F CA
        stx     JOY1                            ; AB70 8E 16 40
        ldx     #$08                            ; AB73 A2 08
@readNextBit:
        lda     JOY1                            ; AB75 AD 16 40
        lsr     a                               ; AB78 4A
        rol     newlyPressedButtons_player1     ; AB79 26 F5
        lsr     a                               ; AB7B 4A
        rol     tmp1                            ; AB7C 26 00
        lda     JOY2_APUFC                      ; AB7E AD 17 40
        lsr     a                               ; AB81 4A
        rol     newlyPressedButtons_player2     ; AB82 26 F6
        lsr     a                               ; AB84 4A
        rol     tmp2                            ; AB85 26 01
        dex                                     ; AB87 CA
        bne     @readNextBit                    ; AB88 D0 EB
        rts                                     ; AB8A 60

; ----------------------------------------------------------------------------
addExpansionPortInputAsControllerInput:
        lda     tmp1                            ; AB8B A5 00
        ora     newlyPressedButtons_player1     ; AB8D 05 F5
        sta     newlyPressedButtons_player1     ; AB8F 85 F5
        lda     tmp2                            ; AB91 A5 01
        ora     newlyPressedButtons_player2     ; AB93 05 F6
        sta     newlyPressedButtons_player2     ; AB95 85 F6
        rts                                     ; AB97 60

; ----------------------------------------------------------------------------
        jsr     pollController_actualRead       ; AB98 20 69 AB
        beq     diffOldAndNewButtons            ; AB9B F0 20
pollController:
        jsr     pollController_actualRead       ; AB9D 20 69 AB
        jsr     addExpansionPortInputAsControllerInput; ABA0 20 8B AB
        lda     newlyPressedButtons_player1     ; ABA3 A5 F5
        sta     generalCounter2                 ; ABA5 85 A9
        lda     newlyPressedButtons_player2     ; ABA7 A5 F6
        sta     generalCounter3                 ; ABA9 85 AA
        jsr     pollController_actualRead       ; ABAB 20 69 AB
        jsr     addExpansionPortInputAsControllerInput; ABAE 20 8B AB
        lda     newlyPressedButtons_player1     ; ABB1 A5 F5
        and     generalCounter2                 ; ABB3 25 A9
        sta     newlyPressedButtons_player1     ; ABB5 85 F5
        lda     newlyPressedButtons_player2     ; ABB7 A5 F6
        and     generalCounter3                 ; ABB9 25 AA
        sta     newlyPressedButtons_player2     ; ABBB 85 F6
diffOldAndNewButtons:
        ldx     #$01                            ; ABBD A2 01
@diffForPlayer:
        lda     newlyPressedButtons_player1,x   ; ABBF B5 F5
        tay                                     ; ABC1 A8
        eor     heldButtons_player1,x           ; ABC2 55 F7
        and     newlyPressedButtons_player1,x   ; ABC4 35 F5
        sta     newlyPressedButtons_player1,x   ; ABC6 95 F5
        sty     heldButtons_player1,x           ; ABC8 94 F7
        dex                                     ; ABCA CA
        bpl     @diffForPlayer                  ; ABCB 10 F2
        rts                                     ; ABCD 60

; ----------------------------------------------------------------------------
unreferenced_func1:
        jsr     pollController_actualRead       ; ABCE 20 69 AB
LABD1:  ldy     newlyPressedButtons_player1     ; ABD1 A4 F5
        lda     newlyPressedButtons_player2     ; ABD3 A5 F6
        pha                                     ; ABD5 48
        jsr     pollController_actualRead       ; ABD6 20 69 AB
        pla                                     ; ABD9 68
        cmp     newlyPressedButtons_player2     ; ABDA C5 F6
        bne     LABD1                           ; ABDC D0 F3
        cpy     newlyPressedButtons_player1     ; ABDE C4 F5
        bne     LABD1                           ; ABE0 D0 EF
        beq     diffOldAndNewButtons            ; ABE2 F0 D9
        jsr     pollController_actualRead       ; ABE4 20 69 AB
        jsr     addExpansionPortInputAsControllerInput; ABE7 20 8B AB
LABEA:  ldy     newlyPressedButtons_player1     ; ABEA A4 F5
        lda     newlyPressedButtons_player2     ; ABEC A5 F6
        pha                                     ; ABEE 48
        jsr     pollController_actualRead       ; ABEF 20 69 AB
        jsr     addExpansionPortInputAsControllerInput; ABF2 20 8B AB
        pla                                     ; ABF5 68
        cmp     newlyPressedButtons_player2     ; ABF6 C5 F6
        bne     LABEA                           ; ABF8 D0 F0
        cpy     newlyPressedButtons_player1     ; ABFA C4 F5
        bne     LABEA                           ; ABFC D0 EC
        beq     diffOldAndNewButtons            ; ABFE F0 BD
        jsr     pollController_actualRead       ; AC00 20 69 AB
        lda     tmp1                            ; AC03 A5 00
        sta     heldButtons_player1             ; AC05 85 F7
        lda     tmp2                            ; AC07 A5 01
        sta     heldButtons_player2             ; AC09 85 F8
        ldx     #$03                            ; AC0B A2 03
LAC0D:  lda     newlyPressedButtons_player1,x   ; AC0D B5 F5
        tay                                     ; AC0F A8
        eor     unreferenced_buttonMirror,x     ; AC10 55 F1
        and     newlyPressedButtons_player1,x   ; AC12 35 F5
        sta     newlyPressedButtons_player1,x   ; AC14 95 F5
        sty     unreferenced_buttonMirror,x     ; AC16 94 F1
        dex                                     ; AC18 CA
        bpl     LAC0D                           ; AC19 10 F2
        rts                                     ; AC1B 60

; ----------------------------------------------------------------------------
; reg a: ppu addr hi; reg x: (preserved) value to set; reg y: (preserved) if pattern table: number of pages, else (nametable): value of attribute table to set (number of pages assumed 4)
memset_ppu_page:
        sta     tmp1                            ; AC1C 85 00
        stx     tmp2                            ; AC1E 86 01
        sty     tmp3                            ; AC20 84 02
        lda     PPUSTATUS                       ; AC22 AD 02 20
        lda     currentPpuCtrl                  ; AC25 A5 FF
        and     #$FB                            ; AC27 29 FB
        sta     PPUCTRL                         ; AC29 8D 00 20
        sta     currentPpuCtrl                  ; AC2C 85 FF
        lda     tmp1                            ; AC2E A5 00
        sta     PPUADDR                         ; AC30 8D 06 20
        ldy     #$00                            ; AC33 A0 00
        sty     PPUADDR                         ; AC35 8C 06 20
        ldx     #$04                            ; AC38 A2 04
        cmp     #$20                            ; AC3A C9 20
        bcs     @loopInit                       ; AC3C B0 02
        ldx     tmp3                            ; AC3E A6 02
@loopInit:
        ldy     #$00                            ; AC40 A0 00
        lda     tmp2                            ; AC42 A5 01
@storeByte:
        sta     PPUDATA                         ; AC44 8D 07 20
        dey                                     ; AC47 88
        bne     @storeByte                      ; AC48 D0 FA
        dex                                     ; AC4A CA
        bne     @storeByte                      ; AC4B D0 F7
        ldy     tmp3                            ; AC4D A4 02
        lda     tmp1                            ; AC4F A5 00
        cmp     #$20                            ; AC51 C9 20
        bcc     @ret                            ; AC53 90 12
        adc     #$02                            ; AC55 69 02
        sta     PPUADDR                         ; AC57 8D 06 20
        lda     #$C0                            ; AC5A A9 C0
        sta     PPUADDR                         ; AC5C 8D 06 20
        ldx     #$40                            ; AC5F A2 40
@storeAttributeTableByte:
        sty     PPUDATA                         ; AC61 8C 07 20
        dex                                     ; AC64 CA
        bne     @storeAttributeTableByte        ; AC65 D0 FA
@ret:   ldx     tmp2                            ; AC67 A6 01
        rts                                     ; AC69 60

; ----------------------------------------------------------------------------
; reg a: value; reg x: start page; reg y: end page (inclusive)
memset_page:
        pha                                     ; AC6A 48
        txa                                     ; AC6B 8A
        sty     tmp2                            ; AC6C 84 01
        clc                                     ; AC6E 18
        sbc     tmp2                            ; AC6F E5 01
        tax                                     ; AC71 AA
        pla                                     ; AC72 68
        ldy     #$00                            ; AC73 A0 00
        sty     tmp1                            ; AC75 84 00
@setByte:
        sta     (tmp1),y                        ; AC77 91 00
        dey                                     ; AC79 88
        bne     @setByte                        ; AC7A D0 FB
        dec     tmp2                            ; AC7C C6 01
        inx                                     ; AC7E E8
        bne     @setByte                        ; AC7F D0 F6
        rts                                     ; AC81 60

; ----------------------------------------------------------------------------
; Jumps to the address stored at the return address + 'reg a'*2
switchOnA:
        asl     a                               ; AC82 0A
        tay                                     ; AC83 A8
        iny                                     ; AC84 C8
        pla                                     ; AC85 68
        sta     tmp1                            ; AC86 85 00
        pla                                     ; AC88 68
        sta     tmp2                            ; AC89 85 01
        lda     (tmp1),y                        ; AC8B B1 00
        tax                                     ; AC8D AA
        iny                                     ; AC8E C8
        lda     (tmp1),y                        ; AC8F B1 00
        sta     tmp2                            ; AC91 85 01
        stx     tmp1                            ; AC93 86 00
        jmp     (tmp1)                          ; AC95 6C 00 00

; ----------------------------------------------------------------------------
unreferenced_func3:
        sei                                     ; AC98 78
        inc     initRam                         ; AC99 EE 00 80
        lda     #$1A                            ; AC9C A9 1A
        jsr     setMMC1Control                  ; AC9E 20 A3 AC
        rts                                     ; ACA1 60

; ----------------------------------------------------------------------------
        rts                                     ; ACA2 60

; ----------------------------------------------------------------------------
setMMC1Control:
        sta     MMC1_Control                    ; ACA3 8D FF 9F
        lsr     a                               ; ACA6 4A
        sta     MMC1_Control                    ; ACA7 8D FF 9F
        lsr     a                               ; ACAA 4A
        sta     MMC1_Control                    ; ACAB 8D FF 9F
        lsr     a                               ; ACAE 4A
        sta     MMC1_Control                    ; ACAF 8D FF 9F
        lsr     a                               ; ACB2 4A
        sta     MMC1_Control                    ; ACB3 8D FF 9F
        rts                                     ; ACB6 60

; ----------------------------------------------------------------------------
changeCHRBank0:
        sta     MMC1_CHR0                       ; ACB7 8D FF BF
        lsr     a                               ; ACBA 4A
        sta     MMC1_CHR0                       ; ACBB 8D FF BF
        lsr     a                               ; ACBE 4A
        sta     MMC1_CHR0                       ; ACBF 8D FF BF
        lsr     a                               ; ACC2 4A
        sta     MMC1_CHR0                       ; ACC3 8D FF BF
        lsr     a                               ; ACC6 4A
        sta     MMC1_CHR0                       ; ACC7 8D FF BF
        rts                                     ; ACCA 60

; ----------------------------------------------------------------------------
changeCHRBank1:
        sta     MMC1_CHR1                       ; ACCB 8D FF DF
        lsr     a                               ; ACCE 4A
        sta     MMC1_CHR1                       ; ACCF 8D FF DF
        lsr     a                               ; ACD2 4A
        sta     MMC1_CHR1                       ; ACD3 8D FF DF
        lsr     a                               ; ACD6 4A
        sta     MMC1_CHR1                       ; ACD7 8D FF DF
        lsr     a                               ; ACDA 4A
        sta     MMC1_CHR1                       ; ACDB 8D FF DF
        rts                                     ; ACDE 60

; ----------------------------------------------------------------------------
changePRGBank:
        sta     MMC1_PRG                        ; ACDF 8D F0 FF
        lsr     a                               ; ACE2 4A
        sta     MMC1_PRG                        ; ACE3 8D F0 FF
        lsr     a                               ; ACE6 4A
        sta     MMC1_PRG                        ; ACE7 8D F0 FF
        lsr     a                               ; ACEA 4A
        sta     MMC1_PRG                        ; ACEB 8D F0 FF
        lsr     a                               ; ACEE 4A
        sta     MMC1_PRG                        ; ACEF 8D F0 FF
        rts                                     ; ACF2 60

; ----------------------------------------------------------------------------
game_palette:
        .byte   $3F,$00,$20,$0F,$30,$12,$16,$0F ; ACF3 3F 00 20 0F 30 12 16 0F
        .byte   $20,$12,$18,$0F,$2C,$16,$29,$0F ; ACFB 20 12 18 0F 2C 16 29 0F
        .byte   $3C,$00,$30,$0F,$35,$15,$22,$0F ; AD03 3C 00 30 0F 35 15 22 0F
        .byte   $35,$29,$26,$0F,$2C,$16,$29,$0F ; AD0B 35 29 26 0F 2C 16 29 0F
        .byte   $3C,$00,$30,$FF                 ; AD13 3C 00 30 FF
legal_screen_palette:
        .byte   $3F,$00,$10,$0F,$27,$2A,$2B,$0F ; AD17 3F 00 10 0F 27 2A 2B 0F
        .byte   $3C,$2A,$22,$0F,$27,$2C,$29,$0F ; AD1F 3C 2A 22 0F 27 2C 29 0F
        .byte   $30,$3A,$15,$FF                 ; AD27 30 3A 15 FF
menu_palette:
        .byte   $3F,$00,$14,$0F,$30,$38,$00,$0F ; AD2B 3F 00 14 0F 30 38 00 0F
        .byte   $30,$16,$00,$0F,$30,$21,$00,$0F ; AD33 30 16 00 0F 30 21 00 0F
        .byte   $16,$2A,$28,$0F,$30,$29,$27,$FF ; AD3B 16 2A 28 0F 30 29 27 FF
ending_palette:
        .byte   $3F,$00,$20,$12,$0F,$29,$37,$12 ; AD43 3F 00 20 12 0F 29 37 12
        .byte   $0F,$30,$27,$12,$0F,$17,$27,$12 ; AD4B 0F 30 27 12 0F 17 27 12
        .byte   $0F,$15,$37,$12,$0F,$29,$37,$12 ; AD53 0F 15 37 12 0F 29 37 12
        .byte   $0F,$30,$27,$12,$0F,$17,$27,$12 ; AD5B 0F 30 27 12 0F 17 27 12
        .byte   $0F,$15,$37,$FF                 ; AD63 0F 15 37 FF
defaultHighScoresTable:
        .byte   $08,$0F,$17,$01,$12,$04,$0F,$14 ; AD67 08 0F 17 01 12 04 0F 14
        .byte   $01,$13,$01,$0E,$0C,$01,$0E,$03 ; AD6F 01 13 01 0E 0C 01 0E 03
        .byte   $05,$2B,$00,$00,$00,$00,$00,$00 ; AD77 05 2B 00 00 00 00 00 00
        .byte   $01,$0C,$05,$18,$2B,$2B,$14,$0F ; AD7F 01 0C 05 18 2B 2B 14 0F
        .byte   $0E,$19,$2B,$2B,$0E,$09,$0E,$14 ; AD87 0E 19 2B 2B 0E 09 0E 14
        .byte   $05,$0E,$00,$00,$00,$00,$00,$00 ; AD8F 05 0E 00 00 00 00 00 00
        .byte   $01,$00,$00,$00,$75,$00,$00,$50 ; AD97 01 00 00 00 75 00 00 50
        .byte   $00,$00,$00,$00,$00,$20,$00,$00 ; AD9F 00 00 00 00 00 20 00 00
        .byte   $10,$00,$00,$05,$00,$00,$00,$00 ; ADA7 10 00 00 05 00 00 00 00
        .byte   $09,$05,$00,$00,$09,$05,$00,$00 ; ADAF 09 05 00 00 09 05 00 00
        .byte   $FF                             ; ADB7 FF

; End of "PRG_chunk1" segment
; ----------------------------------------------------------------------------
.code


.segment        "legal_screen_nametable": absolute

legal_screen_nametable:
        .byte   $20,$00,$20,$FF,$FF,$FF,$FF,$FF ; ADB8 20 00 20 FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ADC0 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ADC8 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ADD0 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$20,$20,$20,$FF,$FF ; ADD8 FF FF FF 20 20 20 FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ADE0 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ADE8 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ADF0 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$20,$40 ; ADF8 FF FF FF FF FF FF 20 40
        .byte   $20,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AE00 20 FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AE08 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AE10 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AE18 FF FF FF FF FF FF FF FF
        .byte   $FF,$20,$60,$20,$FF,$FF,$FF,$FF ; AE20 FF 20 60 20 FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AE28 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AE30 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AE38 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$20,$80,$20,$FF ; AE40 FF FF FF FF 20 80 20 FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AE48 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AE50 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AE58 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$20 ; AE60 FF FF FF FF FF FF FF 20
        .byte   $A0,$20,$FF,$FF,$FF,$FF,$FF,$FF ; AE68 A0 20 FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AE70 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AE78 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AE80 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$20,$C0,$20,$FF,$FF,$FF ; AE88 FF FF 20 C0 20 FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$1D,$16 ; AE90 FF FF FF FF FF FF 1D 16
        .byte   $FF,$0A,$17,$0D,$FF,$F5,$FF,$01 ; AE98 FF 0A 17 0D FF F5 FF 01
        .byte   $09,$08,$07,$FF,$FF,$FF,$FF,$FF ; AEA0 09 08 07 FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$20,$E0,$20 ; AEA8 FF FF FF FF FF 20 E0 20
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AEB0 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AEB8 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AEC0 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AEC8 FF FF FF FF FF FF FF FF
        .byte   $21,$00,$20,$FF,$FF,$FF,$FF,$FF ; AED0 21 00 20 FF FF FF FF FF
        .byte   $1F,$4F,$18,$FF,$0E,$15,$0E,$0C ; AED8 1F 4F 18 FF 0E 15 0E 0C
        .byte   $1D,$1B,$18,$17,$18,$1B,$10,$1D ; AEE0 1D 1B 18 17 18 1B 10 1D
        .byte   $0E,$0C,$11,$17,$12,$0C,$0A,$FF ; AEE8 0E 0C 11 17 12 0C 0A FF
        .byte   $FF,$FF,$FF,$21,$20,$20,$FF,$FF ; AEF0 FF FF FF 21 20 20 FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AEF8 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AF00 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AF08 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$21,$40 ; AF10 FF FF FF FF FF FF 21 40
        .byte   $20,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AF18 20 FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$5E,$6E,$0E,$15 ; AF20 FF FF FF FF 5E 6E 0E 15
        .byte   $18,$1B,$10,$6E,$5F,$FF,$FF,$FF ; AF28 18 1B 10 6E 5F FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AF30 FF FF FF FF FF FF FF FF
        .byte   $FF,$21,$60,$20,$FF,$FF,$FF,$FF ; AF38 FF 21 60 20 FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AF40 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AF48 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AF50 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$21,$80,$20,$FF ; AF58 FF FF FF FF 21 80 20 FF
        .byte   $FF,$FF,$1D,$0E,$1D,$1B,$12,$1C ; AF60 FF FF 1D 0E 1D 1B 12 1C
        .byte   $FF,$15,$12,$0C,$0E,$17,$1C,$0E ; AF68 FF 15 12 0C 0E 17 1C 0E
        .byte   $0D,$FF,$1D,$18,$FF,$17,$12,$17 ; AF70 0D FF 1D 18 FF 17 12 17
        .byte   $1D,$0E,$17,$0D,$18,$FF,$FF,$21 ; AF78 1D 0E 17 0D 18 FF FF 21
        .byte   $A0,$20,$FF,$FF,$FF,$FF,$FF,$FF ; AF80 A0 20 FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AF88 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AF90 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AF98 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$21,$C0,$20,$FF,$FF,$FF ; AFA0 FF FF 21 C0 20 FF FF FF
        .byte   $FF,$FF,$FF,$FF,$F5,$FF,$01,$09 ; AFA8 FF FF FF FF F5 FF 01 09
        .byte   $08,$09,$FF,$17,$12,$17,$1D,$0E ; AFB0 08 09 FF 17 12 17 1D 0E
        .byte   $17,$0D,$18,$FF,$FF,$FF,$FF,$FF ; AFB8 17 0D 18 FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$21,$E0,$20 ; AFC0 FF FF FF FF FF 21 E0 20
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AFC8 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AFD0 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AFD8 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AFE0 FF FF FF FF FF FF FF FF
        .byte   $22,$00,$20,$FF,$FF,$FF,$FF,$FF ; AFE8 22 00 20 FF FF FF FF FF
        .byte   $FF,$0A,$15,$15,$FF,$1B,$12,$10 ; AFF0 FF 0A 15 15 FF 1B 12 10
        .byte   $11,$1D,$1C,$FF,$1B,$0E,$1C,$0E ; AFF8 11 1D 1C FF 1B 0E 1C 0E
        .byte   $1B,$1F,$0E,$0D,$FF,$FF,$FF,$FF ; B000 1B 1F 0E 0D FF FF FF FF
        .byte   $FF,$FF,$FF,$22,$20,$20,$FF,$FF ; B008 FF FF FF 22 20 20 FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B010 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B018 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B020 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$22,$40 ; B028 FF FF FF FF FF FF 22 40
        .byte   $20,$FF,$FF,$FF,$FF,$18,$1B,$12 ; B030 20 FF FF FF FF 18 1B 12
        .byte   $10,$12,$17,$0A,$15,$FF,$0C,$18 ; B038 10 12 17 0A 15 FF 0C 18
        .byte   $17,$0C,$0E,$19,$1D,$25,$0D,$0E ; B040 17 0C 0E 19 1D 25 0D 0E
        .byte   $1C,$12,$10,$17,$FF,$FF,$FF,$FF ; B048 1C 12 10 17 FF FF FF FF
        .byte   $FF,$22,$60,$20,$FF,$FF,$FF,$FF ; B050 FF 22 60 20 FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B058 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B060 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B068 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$22,$80,$20,$FF ; B070 FF FF FF FF 22 80 20 FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B078 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$0A,$17,$0D,$FF,$19,$1B ; B080 FF FF 0A 17 0D FF 19 1B
        .byte   $18,$10,$1B,$0A,$16,$FF,$FF,$FF ; B088 18 10 1B 0A 16 FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$22 ; B090 FF FF FF FF FF FF FF 22
        .byte   $A0,$20,$FF,$FF,$FF,$FF,$FF,$FF ; B098 A0 20 FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B0A0 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B0A8 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B0B0 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$22,$C0,$20,$FF,$FF,$FF ; B0B8 FF FF 22 C0 20 FF FF FF
        .byte   $FF,$FF,$FF,$FF,$0B,$22,$FF,$0A ; B0C0 FF FF FF FF 0B 22 FF 0A
        .byte   $15,$0E,$21,$0E,$22,$FF,$19,$0A ; B0C8 15 0E 21 0E 22 FF 19 0A
        .byte   $23,$11,$12,$1D,$17,$18,$1F,$FF ; B0D0 23 11 12 1D 17 18 1F FF
        .byte   $FF,$FF,$FF,$FF,$FF,$22,$E0,$20 ; B0D8 FF FF FF FF FF 22 E0 20
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B0E0 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B0E8 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B0F0 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B0F8 FF FF FF FF FF FF FF FF
        .byte   $23,$00,$20,$FF,$FF,$FF,$FF,$FF ; B100 23 00 20 FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B108 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B110 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B118 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$23,$20,$20,$FF,$FF ; B120 FF FF FF 23 20 20 FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B128 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B130 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B138 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$23,$40 ; B140 FF FF FF FF FF FF 23 40
        .byte   $20,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B148 20 FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B150 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B158 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B160 FF FF FF FF FF FF FF FF
        .byte   $FF,$23,$60,$20,$FF,$FF,$FF,$FF ; B168 FF 23 60 20 FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B170 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B178 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B180 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$23,$80,$20,$FF ; B188 FF FF FF FF 23 80 20 FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B190 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B198 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B1A0 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$23 ; B1A8 FF FF FF FF FF FF FF 23
        .byte   $A0,$20,$FF,$FF,$FF,$FF,$FF,$FF ; B1B0 A0 20 FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B1B8 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B1C0 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B1C8 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$23,$C0,$20,$FF,$FF,$FF ; B1D0 FF FF 23 C0 20 FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B1D8 FF FF FF FF FF FF FF FF
        .byte   $FF,$5F,$DF,$FF,$FF,$BF,$00,$00 ; B1E0 FF 5F DF FF FF BF 00 00
        .byte   $00,$00,$00,$00,$CC,$F7,$45,$5D ; B1E8 00 00 00 00 CC F7 45 5D
        .byte   $1F,$0F,$03,$00,$0C,$23,$E0,$20 ; B1F0 1F 0F 03 00 0C 23 E0 20
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B1F8 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$BF,$AF,$AF,$AF,$AF,$FF ; B200 FF FF BF AF AF AF AF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B208 FF FF FF FF FF FF FF FF
        .byte   $0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F ; B210 0F 0F 0F 0F 0F 0F 0F 0F
        .byte   $FF                             ; B218 FF

; End of "legal_screen_nametable" segment
; ----------------------------------------------------------------------------
.code


.segment        "PRG_chunk2": absolute

title_screen_nametable:
        .byte   $20,$00,$20,$83,$90,$83,$90,$81 ; B219 20 00 20 83 90 83 90 81
        .byte   $83,$62,$72,$80,$81,$91,$82,$90 ; B221 83 62 72 80 81 91 82 90
        .byte   $83,$70,$71,$62,$80,$41,$83,$60 ; B229 83 70 71 62 80 41 83 60
        .byte   $61,$62,$62,$80,$91,$62,$A0,$83 ; B231 61 62 62 80 91 62 A0 83
        .byte   $80,$81,$91,$20,$20,$20,$80,$A1 ; B239 80 81 91 20 20 20 80 A1
        .byte   $62,$82,$80,$81,$A1,$82,$60,$61 ; B241 62 82 80 81 A1 82 60 61
        .byte   $82,$80,$A1,$90,$73,$90,$A1,$80 ; B249 82 80 A1 90 73 90 A1 80
        .byte   $81,$91,$70,$71,$72,$40,$83,$72 ; B251 81 91 70 71 72 40 83 72
        .byte   $72,$80,$81,$81,$83,$82,$20,$40 ; B259 72 80 81 81 83 82 20 40
        .byte   $20,$80,$81,$A1,$80,$43,$83,$90 ; B261 20 80 81 A1 80 43 83 90
        .byte   $83,$70,$71,$80,$81,$91,$72,$62 ; B269 83 70 71 80 81 91 72 62
        .byte   $82,$62,$60,$61,$82,$62,$80,$A1 ; B271 82 62 60 61 82 62 80 A1
        .byte   $82,$62,$82,$A0,$83,$FF,$60,$61 ; B279 82 62 82 A0 83 FF 60 61
        .byte   $62,$20,$60,$20,$90,$81,$83,$62 ; B281 62 20 60 20 90 81 83 62
        .byte   $82,$80,$A1,$FF,$80,$81,$81,$83 ; B289 82 80 A1 FF 80 81 81 83
        .byte   $82,$82,$72,$80,$42,$70,$71,$90 ; B291 82 82 72 80 42 70 71 90
        .byte   $A1,$FF,$FF,$80,$41,$83,$FF,$FF ; B299 A1 FF FF 80 41 83 FF FF
        .byte   $FF,$70,$71,$40,$20,$80,$20,$82 ; B2A1 FF 70 71 40 20 80 20 82
        .byte   $62,$80,$41,$83,$FF,$FF,$FF,$FF ; B2A9 62 80 41 83 FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$80,$A1,$FF,$82 ; B2B1 FF FF FF FF 80 A1 FF 82
        .byte   $FF,$FF,$82,$FF,$FF,$FF,$FF,$FF ; B2B9 FF FF 82 FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$62,$82,$20 ; B2C1 FF FF FF FF FF 62 82 20
        .byte   $A0,$20,$90,$A1,$FF,$FF,$FF,$FF ; B2C9 A0 20 90 A1 FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B2D1 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B2D9 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B2E1 FF FF FF FF FF FF FF FF
        .byte   $A0,$91,$20,$C0,$20,$82,$FF,$FF ; B2E9 A0 91 20 C0 20 82 FF FF
        .byte   $C3,$C4,$C5,$C6,$C7,$C5,$C8,$C9 ; B2F1 C3 C4 C5 C6 C7 C5 C8 C9
        .byte   $CA,$C3,$C4,$C5,$C6,$C7,$C5,$BC ; B2F9 CA C3 C4 C5 C6 C7 C5 BC
        .byte   $C0,$C1,$C5,$FF,$CB,$CC,$BE,$BF ; B301 C0 C1 C5 FF CB CC BE BF
        .byte   $B0,$B1,$FF,$62,$82,$20,$E0,$20 ; B309 B0 B1 FF 62 82 20 E0 20
        .byte   $90,$73,$FF,$D3,$D4,$D5,$D6,$D7 ; B311 90 73 FF D3 D4 D5 D6 D7
        .byte   $D5,$FF,$D9,$DA,$D3,$D4,$D5,$D6 ; B319 D5 FF D9 DA D3 D4 D5 D6
        .byte   $D7,$D5,$9C,$D0,$D1,$D5,$FF,$E8 ; B321 D7 D5 9C D0 D1 D5 FF E8
        .byte   $E9,$CE,$CF,$FF,$FF,$FF,$72,$62 ; B329 E9 CE CF FF FF FF 72 62
        .byte   $21,$00,$20,$72,$FF,$FF,$E3,$FF ; B331 21 00 20 72 FF FF E3 FF
        .byte   $D5,$FF,$E7,$D5,$FF,$C2,$EA,$E3 ; B339 D5 FF E7 D5 FF C2 EA E3
        .byte   $FF,$D5,$FF,$E7,$D5,$9C,$E0,$E1 ; B341 FF D5 FF E7 D5 9C E0 E1
        .byte   $D5,$FF,$AF,$FD,$5C,$DF,$FF,$FF ; B349 D5 FF AF FD 5C DF FF FF
        .byte   $FF,$72,$72,$21,$20,$20,$82,$FF ; B351 FF 72 72 21 20 20 82 FF
        .byte   $FF,$FF,$FF,$D5,$FF,$FF,$D5,$E4 ; B359 FF FF FF D5 FF FF D5 E4
        .byte   $D2,$FF,$FF,$FF,$D5,$FF,$FF,$D5 ; B361 D2 FF FF FF D5 FF FF D5
        .byte   $AC,$F0,$F1,$D5,$FF,$B3,$FD,$6C ; B369 AC F0 F1 D5 FF B3 FD 6C
        .byte   $7E,$FF,$FF,$62,$82,$72,$21,$40 ; B371 7E FF FF 62 82 72 21 40
        .byte   $20,$90,$81,$83,$FF,$FF,$D5,$FF ; B379 20 90 81 83 FF FF D5 FF
        .byte   $FF,$D5,$F4,$E2,$FF,$FF,$FF,$D5 ; B381 FF D5 F4 E2 FF FF FF D5
        .byte   $FF,$FF,$D5,$7C,$FF,$FF,$D5,$FF ; B389 FF FF D5 7C FF FF D5 FF
        .byte   $7D,$5D,$FD,$A3,$FF,$FF,$A0,$91 ; B391 7D 5D FD A3 FF FF A0 91
        .byte   $82,$21,$60,$20,$82,$62,$FF,$FF ; B399 82 21 60 20 82 62 FF FF
        .byte   $FF,$D5,$FF,$FF,$D5,$FF,$F2,$CD ; B3A1 FF D5 FF FF D5 FF F2 CD
        .byte   $FF,$FF,$D5,$FF,$FF,$D5,$8C,$8D ; B3A9 FF FF D5 FF FF D5 8C 8D
        .byte   $FF,$D5,$FF,$8C,$6D,$FD,$7F,$FF ; B3B1 FF D5 FF 8C 6D FD 7F FF
        .byte   $FF,$FF,$82,$62,$21,$80,$20,$80 ; B3B9 FF FF 82 62 21 80 20 80
        .byte   $43,$83,$FF,$FF,$D5,$FF,$FF,$D5 ; B3C1 43 83 FF FF D5 FF FF D5
        .byte   $FF,$DC,$DD,$FF,$FF,$D5,$FF,$FF ; B3C9 FF DC DD FF FF D5 FF FF
        .byte   $D5,$9C,$9D,$FF,$D5,$FF,$9C,$9D ; B3D1 D5 9C 9D FF D5 FF 9C 9D
        .byte   $8E,$8F,$FF,$FF,$FF,$62,$40,$21 ; B3D9 8E 8F FF FF FF 62 40 21
        .byte   $A0,$20,$83,$82,$FF,$FF,$FF,$E5 ; B3E1 A0 20 83 82 FF FF FF E5
        .byte   $FF,$FF,$E5,$EB,$EC,$ED,$FF,$FF ; B3E9 FF FF E5 EB EC ED FF FF
        .byte   $E5,$FF,$FF,$E5,$AC,$AD,$AE,$E5 ; B3F1 E5 FF FF E5 AC AD AE E5
        .byte   $FF,$AC,$AD,$9E,$9F,$FF,$FF,$FF ; B3F9 FF AC AD 9E 9F FF FF FF
        .byte   $72,$82,$21,$C0,$20,$60,$61,$FF ; B401 72 82 21 C0 20 60 61 FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B409 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B411 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B419 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$A0,$83,$21,$E0,$20 ; B421 FF FF FF A0 83 21 E0 20
        .byte   $70,$71,$FF,$FF,$FF,$FF,$FF,$FF ; B429 70 71 FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B431 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B439 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$80,$81,$91 ; B441 FF FF FF FF FF 80 81 91
        .byte   $22,$00,$20,$90,$73,$FF,$FF,$FF ; B449 22 00 20 90 73 FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B451 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B459 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$93,$FF,$FF,$FF,$80 ; B461 FF FF FF 93 FF FF FF 80
        .byte   $43,$83,$82,$22,$20,$20,$72,$62 ; B469 43 83 82 22 20 20 72 62
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B471 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B479 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$55,$56,$57,$58,$59 ; B481 FF FF FF 55 56 57 58 59
        .byte   $5A,$FF,$FF,$82,$80,$91,$22,$40 ; B489 5A FF FF 82 80 91 22 40
        .byte   $20,$82,$A0,$91,$FF,$FF,$FF,$FF ; B491 20 82 A0 91 FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B499 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$64,$65,$66 ; B4A1 FF FF FF FF FF 64 65 66
        .byte   $67,$68,$69,$6A,$6B,$FF,$FF,$62 ; B4A9 67 68 69 6A 6B FF FF 62
        .byte   $72,$22,$60,$20,$81,$62,$82,$FF ; B4B1 72 22 60 20 81 62 82 FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B4B9 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B4C1 FF FF FF FF FF FF FF FF
        .byte   $74,$75,$76,$77,$78,$79,$7A,$7B ; B4C9 74 75 76 77 78 79 7A 7B
        .byte   $FF,$90,$A1,$82,$22,$80,$20,$62 ; B4D1 FF 90 A1 82 22 80 20 62
        .byte   $40,$83,$FF,$FF,$FF,$FF,$19,$1E ; B4D9 40 83 FF FF FF FF 19 1E
        .byte   $1C,$11,$FF,$1C,$1D,$0A,$1B,$1D ; B4E1 1C 11 FF 1C 1D 0A 1B 1D
        .byte   $FF,$FF,$FF,$84,$85,$86,$87,$88 ; B4E9 FF FF FF 84 85 86 87 88
        .byte   $89,$8A,$8B,$FF,$82,$90,$73,$22 ; B4F1 89 8A 8B FF 82 90 73 22
        .byte   $A0,$20,$72,$82,$FF,$FF,$FF,$FF ; B4F9 A0 20 72 82 FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B501 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$94,$95 ; B509 FF FF FF FF FF FF 94 95
        .byte   $96,$97,$98,$99,$9A,$9B,$FF,$FF ; B511 96 97 98 99 9A 9B FF FF
        .byte   $72,$80,$22,$C0,$20,$A0,$83,$FF ; B519 72 80 22 C0 20 A0 83 FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B521 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B529 FF FF FF FF FF FF FF FF
        .byte   $FF,$A4,$A5,$A6,$A7,$A8,$A9,$AA ; B531 FF A4 A5 A6 A7 A8 A9 AA
        .byte   $AB,$FF,$FF,$82,$62,$22,$E0,$20 ; B539 AB FF FF 82 62 22 E0 20
        .byte   $81,$81,$83,$FF,$FF,$FF,$FF,$FF ; B541 81 81 83 FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B549 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$B4,$B5,$B6,$B7 ; B551 FF FF FF FF B4 B5 B6 B7
        .byte   $B8,$B9,$BA,$BB,$FF,$FF,$90,$A1 ; B559 B8 B9 BA BB FF FF 90 A1
        .byte   $23,$00,$20,$61,$62,$FF,$FF,$FF ; B561 23 00 20 61 62 FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B569 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B571 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B579 FF FF FF FF FF FF FF FF
        .byte   $FF,$82,$62,$23,$20,$20,$71,$72 ; B581 FF 82 62 23 20 20 71 72
        .byte   $FF,$80,$43,$83,$FF,$FF,$FF,$F5 ; B589 FF 80 43 83 FF FF FF F5
        .byte   $FF,$01,$09,$08,$09,$FF,$FF,$F6 ; B591 FF 01 09 08 09 FF FF F6
        .byte   $F7,$F8,$F9,$FA,$FB,$FF,$FF,$FF ; B599 F7 F8 F9 FA FB FF FF FF
        .byte   $FF,$FF,$FF,$80,$81,$A1,$23,$40 ; B5A1 FF FF FF 80 81 A1 23 40
        .byte   $20,$91,$72,$FF,$FF,$82,$FF,$FF ; B5A9 20 91 72 FF FF 82 FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B5B1 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B5B9 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$62,$FF,$FF,$FF,$60 ; B5C1 FF FF FF 62 FF FF FF 60
        .byte   $61,$23,$60,$20,$82,$82,$62,$FF ; B5C9 61 23 60 20 82 82 62 FF
        .byte   $FF,$FF,$80,$91,$FF,$FF,$FF,$FF ; B5D1 FF FF 80 91 FF FF FF FF
        .byte   $62,$80,$81,$91,$FF,$90,$73,$90 ; B5D9 62 80 81 91 FF 90 73 90
        .byte   $83,$62,$FF,$62,$62,$80,$42,$90 ; B5E1 83 62 FF 62 62 80 42 90
        .byte   $81,$83,$70,$71,$23,$80,$20,$60 ; B5E9 81 83 70 71 23 80 20 60
        .byte   $61,$40,$83,$FF,$62,$62,$A0,$83 ; B5F1 61 40 83 FF 62 62 A0 83
        .byte   $80,$43,$83,$72,$80,$91,$82,$62 ; B5F9 80 43 83 72 80 91 82 62
        .byte   $72,$80,$A1,$80,$42,$90,$A1,$A0 ; B601 72 80 A1 80 42 90 A1 A0
        .byte   $91,$82,$82,$62,$80,$91,$80,$23 ; B609 91 82 82 62 80 91 80 23
        .byte   $A0,$20,$70,$71,$82,$80,$81,$A1 ; B611 A0 20 70 71 82 80 81 A1
        .byte   $A0,$81,$83,$62,$82,$80,$A1,$62 ; B619 A0 81 83 62 82 80 A1 62
        .byte   $72,$80,$42,$82,$90,$81,$83,$82 ; B621 72 80 42 82 90 81 83 82
        .byte   $82,$60,$61,$82,$62,$80,$41,$83 ; B629 82 60 61 82 62 80 41 83
        .byte   $A0,$83,$23,$C0,$20,$AA,$AA,$AA ; B631 A0 83 23 C0 20 AA AA AA
        .byte   $AA,$AA,$AA,$AA,$AA,$EA,$FA,$FA ; B639 AA AA AA AA AA EA FA FA
        .byte   $FA,$FA,$FA,$FA,$BA,$A6,$A5,$A5 ; B641 FA FA FA FA BA A6 A5 A5
        .byte   $A5,$A5,$A5,$A5,$AA,$2A,$00,$00 ; B649 A5 A5 A5 A5 AA 2A 00 00
        .byte   $00,$00,$00,$00,$AA,$23,$E0,$20 ; B651 00 00 00 00 AA 23 E0 20
        .byte   $A2,$00,$00,$00,$00,$FF,$FF,$AA ; B659 A2 00 00 00 00 FF FF AA
        .byte   $AA,$00,$00,$00,$00,$FF,$FF,$AA ; B661 AA 00 00 00 00 FF FF AA
        .byte   $AA,$A2,$A7,$A5,$A0,$A0,$A0,$AA ; B669 AA A2 A7 A5 A0 A0 A0 AA
        .byte   $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A ; B671 0A 0A 0A 0A 0A 0A 0A 0A
        .byte   $FF                             ; B679 FF
game_type_menu_nametable:
        .byte   $20,$00,$20,$62,$90,$73,$80,$41 ; B67A 20 00 20 62 90 73 80 41
        .byte   $83,$62,$72,$80,$61,$80,$91,$80 ; B682 83 62 72 80 61 80 91 80
        .byte   $43,$73,$62,$80,$81,$81,$83,$90 ; B68A 43 73 62 80 81 81 83 90
        .byte   $81,$83,$62,$62,$80,$81,$61,$80 ; B692 81 83 62 62 80 81 61 80
        .byte   $61,$90,$73,$20,$20,$20,$72,$72 ; B69A 61 90 73 20 20 20 72 72
        .byte   $62,$60,$61,$90,$A1,$82,$62,$72 ; B6A2 62 60 61 90 A1 82 62 72
        .byte   $62,$A0,$83,$82,$80,$41,$83,$62 ; B6AA 62 A0 83 82 80 41 83 62
        .byte   $80,$61,$82,$80,$81,$A1,$72,$60 ; B6B2 80 61 82 80 81 A1 72 60
        .byte   $61,$82,$62,$72,$72,$62,$20,$40 ; B6BA 61 82 62 72 72 62 20 40
        .byte   $20,$72,$82,$72,$70,$71,$82,$80 ; B6C2 20 72 82 72 70 71 82 80
        .byte   $81,$A1,$82,$A0,$81,$83,$80,$81 ; B6CA 81 A1 82 A0 81 83 80 81
        .byte   $81,$83,$A0,$91,$72,$80,$43,$73 ; B6D2 81 83 A0 91 72 80 43 73
        .byte   $80,$A1,$70,$71,$90,$A1,$82,$82 ; B6DA 80 A1 70 71 90 A1 82 82
        .byte   $72,$20,$60,$20,$82,$62,$72,$30 ; B6E2 72 20 60 20 82 62 72 30
        .byte   $31,$31,$31,$31,$31,$31,$31,$31 ; B6EA 31 31 31 31 31 31 31 31
        .byte   $31,$31,$31,$31,$32,$62,$82,$82 ; B6F2 31 31 31 31 32 62 82 82
        .byte   $62,$82,$60,$61,$62,$60,$61,$82 ; B6FA 62 82 60 61 62 60 61 82
        .byte   $80,$91,$80,$A1,$20,$80,$20,$80 ; B702 80 91 80 A1 20 80 20 80
        .byte   $42,$82,$33,$FF,$10,$0A,$16,$0E ; B70A 42 82 33 FF 10 0A 16 0E
        .byte   $FF,$FF,$1D,$22,$19,$0E,$FF,$34 ; B712 FF FF 1D 22 19 0E FF 34
        .byte   $A0,$81,$83,$A0,$91,$70,$71,$72 ; B71A A0 81 83 A0 91 70 71 72
        .byte   $70,$71,$90,$73,$A0,$83,$62,$20 ; B722 70 71 90 73 A0 83 62 20
        .byte   $A0,$20,$62,$82,$62,$35,$36,$36 ; B72A A0 20 62 82 62 35 36 36
        .byte   $36,$36,$36,$36,$36,$36,$36,$36 ; B732 36 36 36 36 36 36 36 36
        .byte   $36,$36,$37,$90,$73,$80,$91,$82 ; B73A 36 36 37 90 73 80 91 82
        .byte   $62,$80,$A1,$60,$61,$72,$60,$61 ; B742 62 80 A1 60 61 72 60 61
        .byte   $80,$42,$20,$C0,$20,$40,$73,$A0 ; B74A 80 42 20 C0 20 40 73 A0
        .byte   $81,$83,$80,$43,$73,$80,$81,$81 ; B752 81 83 80 43 73 80 81 81
        .byte   $83,$80,$81,$81,$83,$80,$A1,$90 ; B75A 83 80 81 81 83 80 A1 90
        .byte   $73,$A0,$83,$A0,$81,$83,$70,$71 ; B762 73 A0 83 A0 81 83 70 71
        .byte   $82,$70,$71,$62,$82,$20,$E0,$20 ; B76A 82 70 71 62 82 20 E0 20
        .byte   $82,$90,$73,$90,$73,$62,$82,$38 ; B772 82 90 73 90 73 62 82 38
        .byte   $39,$39,$39,$39,$39,$39,$39,$39 ; B77A 39 39 39 39 39 39 39 39
        .byte   $3A,$62,$72,$38,$39,$39,$39,$39 ; B782 3A 62 72 38 39 39 39 39
        .byte   $39,$39,$39,$39,$3A,$90,$A1,$62 ; B78A 39 39 39 39 3A 90 A1 62
        .byte   $21,$00,$20,$80,$A1,$80,$A1,$80 ; B792 21 00 20 80 A1 80 A1 80
        .byte   $41,$83,$3B,$FF,$0A,$24,$1D,$22 ; B79A 41 83 3B FF 0A 24 1D 22
        .byte   $19,$0E,$FF,$3C,$72,$82,$3B,$FF ; B7A2 19 0E FF 3C 72 82 3B FF
        .byte   $0B,$24,$1D,$22,$19,$0E,$FF,$3C ; B7AA 0B 24 1D 22 19 0E FF 3C
        .byte   $82,$80,$42,$21,$20,$20,$90,$73 ; B7B2 82 80 42 21 20 20 90 73
        .byte   $62,$80,$81,$61,$62,$3D,$3E,$3E ; B7BA 62 80 81 61 62 3D 3E 3E
        .byte   $3E,$3E,$3E,$3E,$3E,$3E,$3F,$A0 ; B7C2 3E 3E 3E 3E 3E 3E 3F A0
        .byte   $73,$3D,$3E,$3E,$3E,$3E,$3E,$3E ; B7CA 73 3D 3E 3E 3E 3E 3E 3E
        .byte   $3E,$3E,$3F,$90,$73,$82,$21,$40 ; B7D2 3E 3E 3F 90 73 82 21 40
        .byte   $20,$72,$80,$41,$83,$62,$82,$A0 ; B7DA 20 72 80 41 83 62 82 A0
        .byte   $91,$60,$61,$60,$61,$62,$80,$81 ; B7E2 91 60 61 60 61 62 80 81
        .byte   $61,$60,$61,$80,$81,$81,$83,$62 ; B7EA 61 60 61 80 81 81 83 62
        .byte   $80,$61,$90,$81,$83,$80,$A1,$80 ; B7F2 80 61 90 81 83 80 A1 80
        .byte   $61,$21,$60,$20,$82,$90,$81,$83 ; B7FA 61 21 60 20 82 90 81 83
        .byte   $A0,$81,$83,$82,$70,$71,$70,$71 ; B802 A0 81 83 82 70 71 70 71
        .byte   $A0,$81,$83,$82,$70,$71,$62,$80 ; B80A A0 81 83 82 70 71 62 80
        .byte   $81,$61,$A0,$91,$72,$82,$62,$80 ; B812 81 61 A0 91 72 82 62 80
        .byte   $81,$81,$83,$72,$21,$80,$20,$62 ; B81A 81 81 83 72 21 80 20 62
        .byte   $82,$62,$30,$31,$31,$31,$31,$31 ; B822 82 62 30 31 31 31 31 31
        .byte   $31,$31,$31,$31,$31,$31,$31,$32 ; B82A 31 31 31 31 31 31 31 32
        .byte   $80,$41,$83,$62,$82,$62,$82,$82 ; B832 80 41 83 62 82 62 82 82
        .byte   $80,$42,$90,$73,$80,$91,$82,$21 ; B83A 80 42 90 73 80 91 82 21
        .byte   $A0,$20,$72,$80,$42,$33,$FF,$16 ; B842 A0 20 72 80 42 33 FF 16
        .byte   $1E,$1C,$12,$0C,$FF,$1D,$22,$19 ; B84A 1E 1C 12 0C FF 1D 22 19
        .byte   $0E,$FF,$34,$80,$43,$73,$A0,$91 ; B852 0E FF 34 80 43 73 A0 91
        .byte   $72,$80,$81,$61,$82,$72,$90,$73 ; B85A 72 80 81 61 82 72 90 73
        .byte   $A0,$83,$21,$C0,$20,$A0,$73,$82 ; B862 A0 83 21 C0 20 A0 73 82
        .byte   $35,$36,$36,$36,$36,$36,$36,$36 ; B86A 35 36 36 36 36 36 36 36
        .byte   $36,$36,$36,$36,$36,$37,$62,$82 ; B872 36 36 36 36 36 37 62 82
        .byte   $80,$91,$82,$72,$60,$61,$82,$62 ; B87A 80 91 82 72 60 61 82 62
        .byte   $82,$72,$80,$81,$61,$21,$E0,$20 ; B882 82 72 80 81 61 21 E0 20
        .byte   $60,$61,$62,$80,$81,$61,$80,$43 ; B88A 60 61 62 80 81 61 80 43
        .byte   $73,$80,$81,$81,$83,$80,$81,$81 ; B892 73 80 81 81 83 80 81 81
        .byte   $83,$A0,$81,$83,$A0,$83,$82,$70 ; B89A 83 A0 81 83 A0 83 82 70
        .byte   $71,$80,$41,$83,$82,$80,$91,$82 ; B8A2 71 80 41 83 82 80 91 82
        .byte   $22,$00,$20,$70,$71,$A0,$81,$83 ; B8AA 22 00 20 70 71 A0 81 83
        .byte   $82,$62,$82,$80,$81,$61,$62,$28 ; B8B2 82 62 82 80 81 61 62 28
        .byte   $29,$29,$29,$29,$29,$29,$29,$29 ; B8BA 29 29 29 29 29 29 29 29
        .byte   $29,$29,$2A,$80,$81,$81,$83,$60 ; B8C2 29 29 2A 80 81 81 83 60
        .byte   $61,$A0,$83,$22,$20,$20,$81,$83 ; B8CA 61 A0 83 22 20 20 81 83
        .byte   $60,$61,$62,$62,$A0,$81,$83,$62 ; B8D2 60 61 62 62 A0 81 83 62
        .byte   $82,$72,$2B,$FF,$FF,$FF,$FF,$FF ; B8DA 82 72 2B FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$2C,$80,$81 ; B8E2 FF FF FF FF FF 2C 80 81
        .byte   $81,$83,$70,$71,$80,$81,$22,$40 ; B8EA 81 83 70 71 80 81 22 40
        .byte   $20,$61,$62,$70,$71,$72,$40,$73 ; B8F2 20 61 62 70 71 72 40 73
        .byte   $90,$73,$40,$73,$72,$2B,$FF,$16 ; B8FA 90 73 40 73 72 2B FF 16
        .byte   $1E,$1C,$12,$0C,$53,$54,$01,$FF ; B902 1E 1C 12 0C 53 54 01 FF
        .byte   $2C,$62,$80,$61,$60,$61,$90,$81 ; B90A 2C 62 80 61 60 61 90 81
        .byte   $83,$22,$60,$20,$82,$A0,$91,$62 ; B912 83 22 60 20 82 A0 91 62
        .byte   $72,$82,$62,$72,$62,$82,$62,$82 ; B91A 72 82 62 72 62 82 62 82
        .byte   $2B,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B922 2B FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$2C,$A0,$91,$72,$70 ; B92A FF FF FF 2C A0 91 72 70
        .byte   $71,$82,$62,$62,$22,$80,$20,$73 ; B932 71 82 62 62 22 80 20 73
        .byte   $62,$82,$72,$82,$90,$A1,$82,$40 ; B93A 62 82 72 82 90 A1 82 40
        .byte   $73,$A0,$91,$2B,$FF,$16,$1E,$1C ; B942 73 A0 91 2B FF 16 1E 1C
        .byte   $12,$0C,$53,$54,$02,$FF,$2C,$62 ; B94A 12 0C 53 54 02 FF 2C 62
        .byte   $82,$82,$62,$60,$61,$72,$A0,$22 ; B952 82 82 62 60 61 72 A0 22
        .byte   $A0,$20,$83,$40,$73,$A0,$73,$82 ; B95A A0 20 83 40 73 A0 73 82
        .byte   $60,$61,$82,$60,$61,$82,$2B,$FF ; B962 60 61 82 60 61 82 2B FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B96A FF FF FF FF FF FF FF FF
        .byte   $FF,$2C,$40,$73,$80,$42,$70,$71 ; B972 FF 2C 40 73 80 42 70 71
        .byte   $A0,$73,$22,$C0,$20,$61,$82,$80 ; B97A A0 73 22 C0 20 61 82 80
        .byte   $81,$81,$83,$70,$71,$62,$70,$71 ; B982 81 81 83 70 71 62 70 71
        .byte   $62,$2B,$FF,$16,$1E,$1C,$12,$0C ; B98A 62 2B FF 16 1E 1C 12 0C
        .byte   $53,$54,$03,$FF,$2C,$82,$90,$73 ; B992 53 54 03 FF 2C 82 90 73
        .byte   $82,$62,$80,$81,$61,$22,$E0,$20 ; B99A 82 62 80 81 61 22 E0 20
        .byte   $71,$90,$81,$83,$80,$81,$61,$80 ; B9A2 71 90 81 83 80 81 61 80
        .byte   $42,$80,$81,$A1,$2B,$FF,$FF,$FF ; B9AA 42 80 81 A1 2B FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$2C ; B9B2 FF FF FF FF FF FF FF 2C
        .byte   $80,$A1,$80,$81,$A1,$90,$73,$82 ; B9BA 80 A1 80 81 A1 90 73 82
        .byte   $23,$00,$20,$61,$82,$80,$43,$73 ; B9C2 23 00 20 61 82 80 43 73
        .byte   $62,$82,$62,$82,$80,$81,$61,$2B ; B9CA 62 82 62 82 80 81 61 2B
        .byte   $FF,$FF,$FF,$18,$0F,$0F,$FF,$FF ; B9D2 FF FF FF 18 0F 0F FF FF
        .byte   $FF,$FF,$2C,$80,$81,$81,$83,$80 ; B9DA FF FF 2C 80 81 81 83 80
        .byte   $A1,$60,$61,$23,$20,$20,$82,$60 ; B9E2 A1 60 61 23 20 20 82 60
        .byte   $61,$82,$90,$A1,$80,$41,$83,$62 ; B9EA 61 82 90 A1 80 41 83 62
        .byte   $62,$82,$2B,$FF,$FF,$FF,$FF,$FF ; B9F2 62 82 2B FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$2C,$60,$61 ; B9FA FF FF FF FF FF 2C 60 61
        .byte   $62,$62,$80,$61,$70,$71,$23,$40 ; BA02 62 62 80 61 70 71 23 40
        .byte   $20,$62,$70,$71,$62,$82,$90,$81 ; BA0A 20 62 70 71 62 82 90 81
        .byte   $83,$62,$72,$40,$73,$2D,$2E,$2E ; BA12 83 62 72 40 73 2D 2E 2E
        .byte   $2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E ; BA1A 2E 2E 2E 2E 2E 2E 2E 2E
        .byte   $2F,$70,$71,$72,$40,$73,$72,$80 ; BA22 2F 70 71 72 40 73 72 80
        .byte   $81,$23,$60,$20,$72,$62,$80,$41 ; BA2A 81 23 60 20 72 62 80 41
        .byte   $83,$82,$60,$61,$72,$72,$82,$62 ; BA32 83 82 60 61 72 72 82 62
        .byte   $80,$81,$81,$83,$62,$80,$61,$90 ; BA3A 80 81 81 83 62 80 61 90
        .byte   $81,$83,$90,$73,$60,$61,$72,$82 ; BA42 81 83 90 73 60 61 72 82
        .byte   $62,$82,$62,$62,$23,$80,$20,$72 ; BA4A 62 82 62 62 23 80 20 72
        .byte   $A0,$81,$83,$62,$62,$70,$71,$72 ; BA52 A0 81 83 62 62 70 71 72
        .byte   $82,$90,$A1,$62,$60,$61,$80,$41 ; BA5A 82 90 A1 62 60 61 80 41
        .byte   $83,$72,$82,$62,$80,$A1,$62,$70 ; BA62 83 72 82 62 80 A1 62 70
        .byte   $71,$82,$80,$42,$90,$A1,$72,$23 ; BA6A 71 82 80 42 90 A1 72 23
        .byte   $A0,$20,$82,$80,$81,$61,$72,$72 ; BA72 A0 20 82 80 81 61 72 72
        .byte   $90,$73,$82,$62,$82,$62,$72,$70 ; BA7A 90 73 82 62 82 62 72 70
        .byte   $71,$80,$43,$73,$82,$80,$41,$83 ; BA82 71 80 43 73 82 80 41 83
        .byte   $80,$41,$83,$80,$81,$61,$82,$82 ; BA8A 80 41 83 80 81 61 82 82
        .byte   $80,$A1,$23,$C0,$20,$2A,$0A,$0A ; BA92 80 A1 23 C0 20 2A 0A 0A
        .byte   $0A,$8A,$AA,$AA,$AA,$A2,$60,$50 ; BA9A 0A 8A AA AA AA A2 60 50
        .byte   $50,$98,$AA,$AA,$AA,$6A,$56,$55 ; BAA2 50 98 AA AA AA 6A 56 55
        .byte   $55,$19,$0A,$0A,$8A,$22,$00,$00 ; BAAA 55 19 0A 0A 8A 22 00 00
        .byte   $00,$88,$AA,$AA,$AA,$23,$E0,$20 ; BAB2 00 88 AA AA AA 23 E0 20
        .byte   $AA,$AA,$AA,$00,$00,$00,$AA,$AA ; BABA AA AA AA 00 00 00 AA AA
        .byte   $AA,$AA,$AA,$00,$00,$00,$AA,$AA ; BAC2 AA AA AA 00 00 00 AA AA
        .byte   $AA,$AA,$AA,$00,$00,$00,$AA,$AA ; BACA AA AA AA 00 00 00 AA AA
        .byte   $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A ; BAD2 0A 0A 0A 0A 0A 0A 0A 0A
        .byte   $FF                             ; BADA FF
level_menu_nametable:
        .byte   $20,$00,$20,$60,$61,$60,$61,$62 ; BADB 20 00 20 60 61 60 61 62
        .byte   $82,$62,$90,$83,$62,$62,$62,$82 ; BAE3 82 62 90 83 62 62 62 82
        .byte   $80,$91,$80,$91,$70,$71,$62,$82 ; BAEB 80 91 80 91 70 71 62 82
        .byte   $80,$81,$81,$83,$90,$83,$62,$62 ; BAF3 80 81 81 83 90 83 62 62
        .byte   $80,$81,$91,$20,$20,$20,$70,$71 ; BAFB 80 81 91 20 20 20 70 71
        .byte   $70,$71,$72,$80,$42,$72,$90,$A1 ; BB03 70 71 72 80 42 72 90 A1
        .byte   $72,$A0,$81,$83,$A0,$83,$A0,$83 ; BB0B 72 A0 81 83 A0 83 A0 83
        .byte   $80,$41,$83,$90,$81,$83,$80,$A1 ; BB13 80 41 83 90 81 83 80 A1
        .byte   $90,$A1,$A0,$81,$83,$82,$20,$40 ; BB1B 90 A1 A0 81 83 82 20 40
        .byte   $20,$80,$81,$81,$83,$A0,$83,$82 ; BB23 20 80 81 81 83 A0 83 82
        .byte   $82,$82,$80,$A1,$38,$39,$39,$39 ; BB2B 82 82 80 A1 38 39 39 39
        .byte   $39,$39,$39,$39,$39,$3A,$82,$80 ; BB33 39 39 39 39 39 3A 82 80
        .byte   $81,$81,$83,$82,$80,$81,$91,$60 ; BB3B 81 81 83 82 80 81 91 60
        .byte   $61,$20,$60,$20,$80,$91,$62,$38 ; BB43 61 20 60 20 80 91 62 38
        .byte   $39,$39,$39,$39,$39,$39,$39,$3B ; BB4B 39 39 39 39 39 39 39 3B
        .byte   $FF,$0B,$24,$1D,$22,$19,$0E,$FF ; BB53 FF 0B 24 1D 22 19 0E FF
        .byte   $3C,$39,$39,$39,$39,$39,$39,$39 ; BB5B 3C 39 39 39 39 39 39 39
        .byte   $3A,$82,$70,$71,$20,$80,$20,$62 ; BB63 3A 82 70 71 20 80 20 62
        .byte   $72,$72,$3B,$FF,$FF,$FF,$FF,$FF ; BB6B 72 72 3B FF FF FF FF FF
        .byte   $FF,$FF,$3D,$3E,$3E,$3E,$3E,$3E ; BB73 FF FF 3D 3E 3E 3E 3E 3E
        .byte   $3E,$3E,$3E,$3F,$FF,$FF,$FF,$FF ; BB7B 3E 3E 3E 3F FF FF FF FF
        .byte   $FF,$FF,$FF,$3C,$90,$81,$83,$20 ; BB83 FF FF FF 3C 90 81 83 20
        .byte   $A0,$20,$72,$82,$72,$3B,$FF,$FF ; BB8B A0 20 72 82 72 3B FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BB93 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BB9B FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$3C,$82 ; BBA3 FF FF FF FF FF FF 3C 82
        .byte   $80,$91,$20,$C0,$20,$A0,$83,$82 ; BBAB 80 91 20 C0 20 A0 83 82
        .byte   $3B,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BBB3 3B FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BBBB FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BBC3 FF FF FF FF FF FF FF FF
        .byte   $FF,$3C,$60,$61,$72,$20,$E0,$20 ; BBCB FF 3C 60 61 72 20 E0 20
        .byte   $90,$81,$83,$3B,$FF,$FF,$FF,$FF ; BBD3 90 81 83 3B FF FF FF FF
        .byte   $44,$45,$45,$45,$45,$45,$46,$FF ; BBDB 44 45 45 45 45 45 46 FF
        .byte   $FF,$FF,$FF,$44,$45,$45,$45,$45 ; BBE3 FF FF FF 44 45 45 45 45
        .byte   $45,$45,$46,$FF,$3C,$70,$71,$82 ; BBEB 45 45 46 FF 3C 70 71 82
        .byte   $21,$00,$20,$82,$80,$91,$3B,$FF ; BBF3 21 00 20 82 80 91 3B FF
        .byte   $FF,$FF,$FF,$47,$15,$0E,$1F,$0E ; BBFB FF FF FF 47 15 0E 1F 0E
        .byte   $15,$48,$FF,$FF,$FF,$FF,$47,$11 ; BC03 15 48 FF FF FF FF 47 11
        .byte   $0E,$12,$10,$11,$1D,$48,$FF,$3C ; BC0B 0E 12 10 11 1D 48 FF 3C
        .byte   $80,$81,$91,$21,$20,$20,$60,$61 ; BC13 80 81 91 21 20 20 60 61
        .byte   $72,$3B,$FF,$FF,$FF,$FF,$49,$4A ; BC1B 72 3B FF FF FF FF 49 4A
        .byte   $4A,$4A,$4A,$4A,$4B,$FF,$FF,$FF ; BC23 4A 4A 4A 4A 4B FF FF FF
        .byte   $FF,$49,$4A,$4A,$4A,$4A,$4A,$4A ; BC2B FF 49 4A 4A 4A 4A 4A 4A
        .byte   $4B,$FF,$3C,$62,$62,$82,$21,$40 ; BC33 4B FF 3C 62 62 82 21 40
        .byte   $20,$70,$71,$82,$3B,$FF,$FF,$28 ; BC3B 20 70 71 82 3B FF FF 28
        .byte   $29,$50,$29,$50,$29,$50,$29,$50 ; BC43 29 50 29 50 29 50 29 50
        .byte   $29,$2A,$FF,$FF,$28,$29,$50,$29 ; BC4B 29 2A FF FF 28 29 50 29
        .byte   $50,$29,$2A,$FF,$FF,$3C,$72,$A0 ; BC53 50 29 2A FF FF 3C 72 A0
        .byte   $91,$21,$60,$20,$80,$81,$91,$3B ; BC5B 91 21 60 20 80 81 91 3B
        .byte   $FF,$FF,$2B,$00,$2B,$01,$2B,$02 ; BC63 FF FF 2B 00 2B 01 2B 02
        .byte   $2B,$03,$2B,$04,$2C,$FF,$FF,$2B ; BC6B 2B 03 2B 04 2C FF FF 2B
        .byte   $00,$2B,$01,$2B,$02,$2C,$FF,$FF ; BC73 00 2B 01 2B 02 2C FF FF
        .byte   $3C,$72,$62,$82,$21,$80,$20,$62 ; BC7B 3C 72 62 82 21 80 20 62
        .byte   $62,$82,$3B,$FF,$FF,$4C,$2E,$4D ; BC83 62 82 3B FF FF 4C 2E 4D
        .byte   $2E,$4D,$2E,$4D,$2E,$4D,$2E,$4E ; BC8B 2E 4D 2E 4D 2E 4D 2E 4E
        .byte   $FF,$FF,$4C,$2E,$4D,$2E,$4D,$2E ; BC93 FF FF 4C 2E 4D 2E 4D 2E
        .byte   $4E,$FF,$FF,$3C,$82,$72,$80,$21 ; BC9B 4E FF FF 3C 82 72 80 21
        .byte   $A0,$20,$72,$A0,$91,$3B,$FF,$FF ; BCA3 A0 20 72 A0 91 3B FF FF
        .byte   $2B,$05,$2B,$06,$2B,$07,$2B,$08 ; BCAB 2B 05 2B 06 2B 07 2B 08
        .byte   $2B,$09,$2C,$FF,$FF,$2B,$03,$2B ; BCB3 2B 09 2C FF FF 2B 03 2B
        .byte   $04,$2B,$05,$2C,$FF,$FF,$3C,$62 ; BCBB 04 2B 05 2C FF FF 3C 62
        .byte   $A0,$83,$21,$C0,$20,$72,$62,$82 ; BCC3 A0 83 21 C0 20 72 62 82
        .byte   $3B,$FF,$FF,$2D,$2E,$51,$2E,$51 ; BCCB 3B FF FF 2D 2E 51 2E 51
        .byte   $2E,$51,$2E,$51,$2E,$2F,$FF,$FF ; BCD3 2E 51 2E 51 2E 2F FF FF
        .byte   $2D,$2E,$51,$2E,$51,$2E,$2F,$FF ; BCDB 2D 2E 51 2E 51 2E 2F FF
        .byte   $FF,$3C,$A0,$81,$83,$21,$E0,$20 ; BCE3 FF 3C A0 81 83 21 E0 20
        .byte   $82,$72,$80,$3B,$FF,$FF,$FF,$FF ; BCEB 82 72 80 3B FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BCF3 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BCFB FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$3C,$90,$81,$83 ; BD03 FF FF FF FF 3C 90 81 83
        .byte   $22,$00,$20,$62,$A0,$83,$3B,$FF ; BD0B 22 00 20 62 A0 83 3B FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BD13 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BD1B FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$3C ; BD23 FF FF FF FF FF FF FF 3C
        .byte   $82,$80,$91,$22,$20,$20,$A0,$81 ; BD2B 82 80 91 22 20 20 A0 81
        .byte   $83,$3B,$FF,$28,$29,$29,$29,$29 ; BD33 83 3B FF 28 29 29 29 29
        .byte   $29,$29,$29,$29,$29,$29,$29,$29 ; BD3B 29 29 29 29 29 29 29 29
        .byte   $29,$29,$29,$29,$29,$29,$29,$29 ; BD43 29 29 29 29 29 29 29 29
        .byte   $2A,$FF,$3C,$60,$61,$72,$22,$40 ; BD4B 2A FF 3C 60 61 72 22 40
        .byte   $20,$62,$80,$91,$3B,$FF,$2B,$FF ; BD53 20 62 80 91 3B FF 2B FF
        .byte   $FF,$FF,$FF,$17,$0A,$16,$0E,$FF ; BD5B FF FF FF 17 0A 16 0E FF
        .byte   $FF,$1C,$0C,$18,$1B,$0E,$FF,$FF ; BD63 FF 1C 0C 18 1B 0E FF FF
        .byte   $15,$1F,$FF,$2C,$FF,$3C,$70,$71 ; BD6B 15 1F FF 2C FF 3C 70 71
        .byte   $82,$22,$60,$20,$42,$62,$72,$3B ; BD73 82 22 60 20 42 62 72 3B
        .byte   $FF,$4C,$2E,$2E,$2E,$2E,$2E,$2E ; BD7B FF 4C 2E 2E 2E 2E 2E 2E
        .byte   $2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E ; BD83 2E 2E 2E 2E 2E 2E 2E 2E
        .byte   $2E,$2E,$2E,$2E,$2E,$2E,$4E,$FF ; BD8B 2E 2E 2E 2E 2E 2E 4E FF
        .byte   $3C,$80,$81,$91,$22,$80,$20,$82 ; BD93 3C 80 81 91 22 80 20 82
        .byte   $72,$82,$3B,$FF,$2B,$FF,$01,$FF ; BD9B 72 82 3B FF 2B FF 01 FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BDA3 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BDAB FF FF FF FF FF FF FF FF
        .byte   $FF,$2C,$FF,$3C,$62,$62,$82,$22 ; BDB3 FF 2C FF 3C 62 62 82 22
        .byte   $A0,$20,$80,$A1,$62,$3B,$FF,$2B ; BDBB A0 20 80 A1 62 3B FF 2B
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BDC3 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BDCB FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$2C,$FF,$3C,$72 ; BDD3 FF FF FF FF 2C FF 3C 72
        .byte   $A0,$91,$22,$C0,$20,$60,$61,$72 ; BDDB A0 91 22 C0 20 60 61 72
        .byte   $3B,$FF,$2B,$FF,$02,$FF,$FF,$FF ; BDE3 3B FF 2B FF 02 FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BDEB FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$2C ; BDF3 FF FF FF FF FF FF FF 2C
        .byte   $FF,$3C,$72,$62,$82,$22,$E0,$20 ; BDFB FF 3C 72 62 82 22 E0 20
        .byte   $70,$71,$72,$3B,$FF,$2B,$FF,$FF ; BE03 70 71 72 3B FF 2B FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BE0B FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BE13 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$2C,$FF,$3C,$82,$72,$80 ; BE1B FF FF 2C FF 3C 82 72 80
        .byte   $23,$00,$20,$62,$62,$82,$3B,$FF ; BE23 23 00 20 62 62 82 3B FF
        .byte   $2B,$FF,$03,$FF,$FF,$FF,$FF,$FF ; BE2B 2B FF 03 FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BE33 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$2C,$FF,$3C ; BE3B FF FF FF FF FF 2C FF 3C
        .byte   $62,$A0,$83,$23,$20,$20,$72,$40 ; BE43 62 A0 83 23 20 20 72 40
        .byte   $73,$3B,$FF,$2D,$2E,$2E,$2E,$2E ; BE4B 73 3B FF 2D 2E 2E 2E 2E
        .byte   $2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E ; BE53 2E 2E 2E 2E 2E 2E 2E 2E
        .byte   $2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E ; BE5B 2E 2E 2E 2E 2E 2E 2E 2E
        .byte   $2F,$FF,$3C,$A0,$81,$83,$23,$40 ; BE63 2F FF 3C A0 81 83 23 40
        .byte   $20,$72,$82,$62,$3B,$FF,$FF,$FF ; BE6B 20 72 82 62 3B FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BE73 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; BE7B FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$3C,$62,$60 ; BE83 FF FF FF FF FF 3C 62 60
        .byte   $61,$23,$60,$20,$82,$90,$A1,$3D ; BE8B 61 23 60 20 82 90 A1 3D
        .byte   $3E,$3E,$3E,$3E,$3E,$3E,$3E,$3E ; BE93 3E 3E 3E 3E 3E 3E 3E 3E
        .byte   $3E,$3E,$3E,$3E,$3E,$3E,$3E,$3E ; BE9B 3E 3E 3E 3E 3E 3E 3E 3E
        .byte   $3E,$3E,$3E,$3E,$3E,$3E,$3E,$3E ; BEA3 3E 3E 3E 3E 3E 3E 3E 3E
        .byte   $3F,$72,$70,$71,$23,$80,$20,$62 ; BEAB 3F 72 70 71 23 80 20 62
        .byte   $82,$90,$83,$62,$80,$81,$91,$80 ; BEB3 82 90 83 62 80 81 91 80
        .byte   $81,$81,$83,$90,$83,$90,$83,$60 ; BEBB 81 81 83 90 83 90 83 60
        .byte   $61,$90,$81,$83,$62,$80,$43,$83 ; BEC3 61 90 81 83 62 80 43 83
        .byte   $80,$91,$80,$91,$A0,$83,$62,$23 ; BECB 80 91 80 91 A0 83 62 23
        .byte   $A0,$20,$72,$80,$A1,$80,$41,$83 ; BED3 A0 20 72 80 A1 80 41 83
        .byte   $62,$82,$80,$43,$83,$80,$A1,$62 ; BEDB 62 82 80 43 83 80 A1 62
        .byte   $72,$62,$70,$71,$82,$80,$81,$A1 ; BEE3 72 62 70 71 82 80 81 A1
        .byte   $62,$82,$60,$61,$A0,$83,$A0,$83 ; BEEB 62 82 60 61 A0 83 A0 83
        .byte   $80,$41,$23,$C0,$20,$AA,$AA,$AA ; BEF3 80 41 23 C0 20 AA AA AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$55,$A9 ; BEFB AA AA AA AA AA AA 55 A9
        .byte   $AA,$9A,$A6,$A5,$AA,$AA,$D5,$FA ; BF03 AA 9A A6 A5 AA AA D5 FA
        .byte   $FA,$F8,$FA,$7A,$AA,$AA,$DD,$FF ; BF0B FA F8 FA 7A AA AA DD FF
        .byte   $FF,$FF,$FF,$77,$AA,$23,$E0,$20 ; BF13 FF FF FF 77 AA 23 E0 20
        .byte   $AA,$00,$00,$00,$00,$00,$00,$AA ; BF1B AA 00 00 00 00 00 00 AA
        .byte   $AA,$00,$00,$00,$00,$00,$00,$AA ; BF23 AA 00 00 00 00 00 00 AA
        .byte   $AA,$A0,$A0,$A0,$A0,$A0,$A0,$AA ; BF2B AA A0 A0 A0 A0 A0 A0 AA
        .byte   $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A ; BF33 0A 0A 0A 0A 0A 0A 0A 0A
        .byte   $FF                             ; BF3B FF
game_nametable:
        .byte   $20,$00,$20,$7A,$67,$77,$77,$72 ; BF3C 20 00 20 7A 67 77 77 72
        .byte   $79,$7A,$78,$75,$7A,$67,$77,$78 ; BF44 79 7A 78 75 7A 67 77 78
        .byte   $83,$78,$83,$77,$87,$67,$78,$73 ; BF4C 83 78 83 77 87 67 78 73
        .byte   $87,$70,$71,$67,$87,$78,$75,$7A ; BF54 87 70 71 67 87 78 75 7A
        .byte   $72,$7A,$67,$20,$20,$20,$72,$83 ; BF5C 72 7A 67 20 20 20 72 83
        .byte   $87,$77,$87,$67,$78,$73,$87,$72 ; BF64 87 77 87 67 78 73 87 72
        .byte   $83,$87,$78,$79,$79,$7A,$87,$78 ; BF6C 83 87 78 79 79 7A 87 78
        .byte   $84,$7A,$82,$7A,$80,$81,$82,$79 ; BF74 84 7A 82 7A 80 81 82 79
        .byte   $7A,$87,$78,$83,$78,$85,$20,$40 ; BF7C 7A 87 78 83 78 85 20 40
        .byte   $20,$87,$72,$7A,$87,$78,$84,$7A ; BF84 20 87 72 7A 87 78 84 7A
        .byte   $82,$7A,$87,$67,$38,$39,$39,$39 ; BF8C 82 7A 87 67 38 39 39 39
        .byte   $39,$39,$39,$39,$39,$39,$39,$3A ; BF94 39 39 39 39 39 39 39 3A
        .byte   $38,$39,$39,$39,$39,$39,$39,$3A ; BF9C 38 39 39 39 39 39 39 3A
        .byte   $87,$20,$60,$20,$67,$77,$38,$39 ; BFA4 87 20 60 20 67 77 38 39
        .byte   $39,$39,$39,$39,$39,$3A,$77,$3B ; BFAC 39 39 39 39 39 3A 77 3B
        .byte   $FF,$15,$12,$17,$0E,$1C,$24,$FF ; BFB4 FF 15 12 17 0E 1C 24 FF
        .byte   $FF,$FF,$3C,$3B,$FF,$FF,$FF,$FF ; BFBC FF FF 3C 3B FF FF FF FF
        .byte   $FF,$FF,$3C,$67,$20,$80,$20,$77 ; BFC4 FF FF 3C 67 20 80 20 77
        .byte   $87,$3B,$FF,$24,$1D,$22,$19,$0E ; BFCC 87 3B FF 24 1D 22 19 0E
        .byte   $3C,$77,$3D,$3E,$3E,$3E,$3E,$3E ; BFD4 3C 77 3D 3E 3E 3E 3E 3E
        .byte   $3E,$3E,$3E,$3E,$3E,$3F,$3B,$1D ; BFDC 3E 3E 3E 3E 3E 3F 3B 1D
        .byte   $18,$19,$FF,$FF,$FF,$3C,$77,$20 ; BFE4 18 19 FF FF FF 3C 77 20
        .byte   $A0,$20,$80,$7A,$3D,$3E,$3E,$3E ; BFEC A0 20 80 7A 3D 3E 3E 3E
        .byte   $3E,$3E,$3E,$3F,$87,$30,$31,$31 ; BFF4 3E 3E 3E 3F 87 30 31 31
        .byte   $31,$31,$31                     ; BFFC 31 31 31
MMC1_CHR0:
        .byte   $31                             ; BFFF 31
; Referenced from DMC_START. Size $71. Not actual DMC data
dmc0:   .byte   $31,$31,$31,$31,$32,$3B,$00,$00 ; C000 31 31 31 31 32 3B 00 00
        .byte   $00,$00,$00,$00,$3C,$77,$20,$C0 ; C008 00 00 00 00 3C 77 20 C0
        .byte   $20,$78,$79,$79,$7A,$67,$70,$71 ; C010 20 78 79 79 7A 67 70 71
        .byte   $67,$78,$79,$73,$33,$FF,$FF,$FF ; C018 67 78 79 73 33 FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$34 ; C020 FF FF FF FF FF FF FF 34
        .byte   $3B,$FF,$FF,$FF,$FF,$FF,$FF,$3C ; C028 3B FF FF FF FF FF FF 3C
        .byte   $87,$20,$E0,$20,$79,$7A,$78,$79 ; C030 87 20 E0 20 79 7A 78 79
        .byte   $83,$80,$81,$82,$79,$7A,$87,$33 ; C038 83 80 81 82 79 7A 87 33
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C040 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$34,$3B,$1C,$0C,$18,$1B ; C048 FF FF 34 3B 1C 0C 18 1B
        .byte   $0E,$FF,$3C,$67,$21,$00,$20,$73 ; C050 0E FF 3C 67 21 00 20 73
        .byte   $38,$39,$39,$39,$39,$39,$39,$39 ; C058 38 39 39 39 39 39 39 39
        .byte   $39,$3A,$33,$FF,$FF,$FF,$FF,$FF ; C060 39 3A 33 FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$34,$3B,$00 ; C068 FF FF FF FF FF 34 3B 00
        .byte   $00,$00,$00,$00,$00,$3C,$82,$21 ; C070 00 00 00 00 00 3C 82 21
        .byte   $20,$20,$77,$3B,$69,$6A,$6B,$6C ; C078 20 20 77 3B 69 6A 6B 6C
; Referenced from DMC_START. Size $F1. Not actual DMC data
dmc1:   .byte   $6D,$6E,$6F,$5F,$3C,$33,$FF,$FF ; C080 6D 6E 6F 5F 3C 33 FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C088 FF FF FF FF FF FF FF FF
        .byte   $34,$3B,$FF,$FF,$FF,$FF,$FF,$FF ; C090 34 3B FF FF FF FF FF FF
        .byte   $3C,$67,$21,$40,$20,$87,$3B,$FF ; C098 3C 67 21 40 20 87 3B FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$3C ; C0A0 FF FF FF FF FF FF FF 3C
        .byte   $33,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C0A8 33 FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$34,$3D,$3E,$3E,$3E ; C0B0 FF FF FF 34 3D 3E 3E 3E
        .byte   $3E,$3E,$3E,$3F,$77,$21,$60,$20 ; C0B8 3E 3E 3E 3F 77 21 60 20
        .byte   $7A,$3B,$FF,$40,$41,$42,$FF,$FF ; C0C0 7A 3B FF 40 41 42 FF FF
        .byte   $FF,$FF,$3C,$33,$FF,$FF,$FF,$FF ; C0C8 FF FF 3C 33 FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$34,$78 ; C0D0 FF FF FF FF FF FF 34 78
        .byte   $79,$79,$7A,$78,$79,$73,$78,$83 ; C0D8 79 79 7A 78 79 73 78 83
        .byte   $21,$80,$20,$7A,$3B,$FF,$50,$51 ; C0E0 21 80 20 7A 3B FF 50 51
        .byte   $52,$00,$00,$00,$FF,$3C,$33,$FF ; C0E8 52 00 00 00 FF 3C 33 FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C0F0 FF FF FF FF FF FF FF FF
        .byte   $FF,$34,$30,$31,$31,$31,$31,$32 ; C0F8 FF 34 30 31 31 31 31 32
        .byte   $87,$67,$78,$21,$A0,$20,$7A,$3B ; C100 87 67 78 21 A0 20 7A 3B
        .byte   $FF,$49,$4A,$4B,$FF,$FF,$FF,$FF ; C108 FF 49 4A 4B FF FF FF FF
        .byte   $3C,$33,$FF,$FF,$FF,$FF,$FF,$FF ; C110 3C 33 FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$34,$33,$17,$0E ; C118 FF FF FF FF 34 33 17 0E
        .byte   $21,$1D,$34,$72,$83,$78,$21,$C0 ; C120 21 1D 34 72 83 78 21 C0
        .byte   $20,$67,$3B,$FF,$59,$5A,$5B,$00 ; C128 20 67 3B FF 59 5A 5B 00
        .byte   $00,$00,$FF,$3C,$33,$FF,$FF,$FF ; C130 00 00 FF 3C 33 FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$34 ; C138 FF FF FF FF FF FF FF 34
        .byte   $33,$FF,$FF,$FF,$FF,$34,$87,$72 ; C140 33 FF FF FF FF 34 87 72
        .byte   $7A,$21,$E0,$20,$77,$3B,$FF,$46 ; C148 7A 21 E0 20 77 3B FF 46
        .byte   $47,$FF,$FF,$FF,$FF,$FF,$3C,$33 ; C150 47 FF FF FF FF FF 3C 33
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C158 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$34,$33,$FF,$FF,$FF,$FF ; C160 FF FF 34 33 FF FF FF FF
        .byte   $34,$78,$83,$70,$22,$00,$20,$77 ; C168 34 78 83 70 22 00 20 77
        .byte   $3B,$FF,$56,$57,$58,$00,$00,$00 ; C170 3B FF 56 57 58 00 00 00
        .byte   $FF,$3C,$33,$FF,$FF,$FF,$FF,$FF ; C178 FF 3C 33 FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$34,$33,$FF ; C180 FF FF FF FF FF 34 33 FF
        .byte   $FF,$FF,$FF,$34,$72,$7A,$80,$22 ; C188 FF FF FF 34 72 7A 80 22
        .byte   $20,$20,$87,$3B,$FF,$60,$61,$FF ; C190 20 20 87 3B FF 60 61 FF
        .byte   $FF,$FF,$FF,$FF,$3C,$33,$FF,$FF ; C198 FF FF FF FF 3C 33 FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C1A0 FF FF FF FF FF FF FF FF
        .byte   $34,$33,$FF,$FF,$FF,$FF,$34,$77 ; C1A8 34 33 FF FF FF FF 34 77
        .byte   $78,$73,$22,$40,$20,$71,$3B,$FF ; C1B0 78 73 22 40 20 71 3B FF
        .byte   $62,$63,$FF,$00,$00,$00,$FF,$3C ; C1B8 62 63 FF 00 00 00 FF 3C
        .byte   $33,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C1C0 33 FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$34,$35,$36,$36,$36 ; C1C8 FF FF FF 34 35 36 36 36
        .byte   $36,$37,$87,$67,$77,$22,$60,$20 ; C1D0 36 37 87 67 77 22 60 20
        .byte   $81,$3B,$FF,$43,$44,$45,$FF,$FF ; C1D8 81 3B FF 43 44 45 FF FF
        .byte   $FF,$FF,$3C,$33,$FF,$FF,$FF,$FF ; C1E0 FF FF 3C 33 FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$34,$38 ; C1E8 FF FF FF FF FF FF 34 38
        .byte   $39,$39,$39,$39,$39,$3A,$77,$87 ; C1F0 39 39 39 39 39 3A 77 87
        .byte   $22,$80,$20,$7A,$3B,$FF,$53,$54 ; C1F8 22 80 20 7A 3B FF 53 54
        .byte   $55,$00,$00,$00,$FF,$3C,$33,$FF ; C200 55 00 00 00 FF 3C 33 FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C208 FF FF FF FF FF FF FF FF
        .byte   $FF,$34,$3B,$15,$0E,$1F,$0E,$15 ; C210 FF 34 3B 15 0E 1F 0E 15
        .byte   $3C,$77,$78,$22,$A0,$20,$7A,$3B ; C218 3C 77 78 22 A0 20 7A 3B
        .byte   $FF,$4C,$4D,$4E,$FF,$FF,$FF,$FF ; C220 FF 4C 4D 4E FF FF FF FF
        .byte   $3C,$33,$FF,$FF,$FF,$FF,$FF,$FF ; C228 3C 33 FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$34,$3B,$FF,$FF ; C230 FF FF FF FF 34 3B FF FF
        .byte   $FF,$FF,$FF,$3C,$87,$67,$22,$C0 ; C238 FF FF FF 3C 87 67 22 C0
        .byte   $20,$67,$3B,$FF,$5C,$5D,$5E,$00 ; C240 20 67 3B FF 5C 5D 5E 00
        .byte   $00,$00,$FF,$3C,$33,$FF,$FF,$FF ; C248 00 00 FF 3C 33 FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$34 ; C250 FF FF FF FF FF FF FF 34
        .byte   $3D,$3E,$3E,$3E,$3E,$3E,$3F,$78 ; C258 3D 3E 3E 3E 3E 3E 3F 78
        .byte   $85,$22,$E0,$20,$83,$3B,$FF,$FF ; C260 85 22 E0 20 83 3B FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$3C,$33 ; C268 FF FF FF FF FF FF 3C 33
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C270 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$34,$67,$78,$75,$7A,$67 ; C278 FF FF 34 67 78 75 7A 67
        .byte   $72,$79,$7A,$87,$23,$00,$20,$73 ; C280 72 79 7A 87 23 00 20 73
        .byte   $3B,$FF,$64,$65,$66,$00,$00,$00 ; C288 3B FF 64 65 66 00 00 00
        .byte   $FF,$3C,$33,$FF,$FF,$FF,$FF,$FF ; C290 FF 3C 33 FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$34,$74,$7A ; C298 FF FF FF FF FF 34 74 7A
        .byte   $87,$78,$85,$87,$67,$78,$79,$23 ; C2A0 87 78 85 87 67 78 79 23
        .byte   $20,$20,$77,$3B,$FF,$FF,$FF,$FF ; C2A8 20 20 77 3B FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$3C,$33,$FF,$FF ; C2B0 FF FF FF FF 3C 33 FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C2B8 FF FF FF FF FF FF FF FF
        .byte   $34,$87,$78,$79,$73,$87,$72,$83 ; C2C0 34 87 78 79 73 87 72 83
        .byte   $72,$7A,$23,$40,$20,$87,$3D,$3E ; C2C8 72 7A 23 40 20 87 3D 3E
        .byte   $3E,$3E,$3E,$3E,$3E,$3E,$3E,$3F ; C2D0 3E 3E 3E 3E 3E 3E 3E 3F
        .byte   $35,$36,$36,$36,$36,$36,$36,$36 ; C2D8 35 36 36 36 36 36 36 36
        .byte   $36,$36,$36,$37,$67,$70,$71,$87 ; C2E0 36 36 36 37 67 70 71 87
        .byte   $67,$87,$78,$83,$67,$23,$60,$20 ; C2E8 67 87 78 83 67 23 60 20
        .byte   $67,$67,$78,$75,$7A,$72,$79,$7A ; C2F0 67 67 78 75 7A 72 79 7A
        .byte   $67,$78,$73,$78,$73,$67,$72,$7A ; C2F8 67 78 73 78 73 67 72 7A
        .byte   $72,$79,$7A,$78,$79,$79,$7A,$77 ; C300 72 79 7A 78 79 79 7A 77
        .byte   $80,$81,$78,$85,$67,$78,$79,$83 ; C308 80 81 78 85 67 78 79 83
        .byte   $23,$80,$20,$77,$82,$73,$87,$67 ; C310 23 80 20 77 82 73 87 67
        .byte   $87,$67,$72,$83,$67,$82,$7A,$77 ; C318 87 67 72 83 67 82 7A 77
        .byte   $77,$77,$67,$87,$67,$70,$71,$72 ; C320 77 77 67 87 67 70 71 72
        .byte   $7A,$67,$80,$7A,$78,$73,$87,$77 ; C328 7A 67 80 7A 78 73 87 77
        .byte   $78,$79,$79,$23,$A0,$20,$80,$7A ; C330 78 79 79 23 A0 20 80 7A
        .byte   $87,$78,$84,$7A,$77,$87,$78,$84 ; C338 87 78 84 7A 77 87 78 84
        .byte   $7A,$67,$87,$77,$87,$77,$72,$83 ; C340 7A 67 87 77 87 77 72 83
        .byte   $80,$81,$77,$67,$82,$79,$7A,$67 ; C348 80 81 77 67 82 79 7A 67
        .byte   $77,$78,$83,$72,$7A,$67,$23,$C0 ; C350 77 78 83 72 7A 67 23 C0
        .byte   $20,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C358 20 FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$AF,$AF,$EF,$FF ; C360 FF FF FF FF AF AF EF FF
        .byte   $FF,$BF,$2F,$CF,$AA,$AA,$EE,$FF ; C368 FF BF 2F CF AA AA EE FF
        .byte   $FF,$BB,$22,$CC,$AA,$AA,$EE,$FF ; C370 FF BB 22 CC AA AA EE FF
        .byte   $FF,$23,$E0,$20,$BB,$22,$CC,$AA ; C378 FF 23 E0 20 BB 22 CC AA
        .byte   $AA,$EE,$FF,$FF,$BB,$22,$CC,$AA ; C380 AA EE FF FF BB 22 CC AA
        .byte   $AA,$EE,$FF,$FF,$FB,$F2,$FC,$FA ; C388 AA EE FF FF FB F2 FC FA
        .byte   $FA,$FE,$FF,$FF,$0F,$0F,$0F,$0F ; C390 FA FE FF FF 0F 0F 0F 0F
        .byte   $0F,$0F,$0F,$0F,$FF             ; C398 0F 0F 0F 0F FF
enter_high_score_nametable:
        .byte   $20,$00,$20,$72,$82,$62,$62,$62 ; C39D 20 00 20 72 82 62 62 62
        .byte   $80,$91,$80,$43,$83,$62,$72,$60 ; C3A5 80 91 80 43 83 62 72 60
        .byte   $61,$82,$90,$83,$72,$90,$81,$83 ; C3AD 61 82 90 83 72 90 81 83
        .byte   $82,$62,$82,$62,$72,$62,$80,$81 ; C3B5 82 62 82 62 72 62 80 81
        .byte   $81,$83,$72,$20,$20,$20,$72,$80 ; C3BD 81 83 72 20 20 20 72 80
        .byte   $42,$72,$A0,$91,$72,$62,$82,$80 ; C3C5 42 72 A0 91 72 62 82 80
        .byte   $42,$82,$70,$71,$80,$A1,$80,$A1 ; C3CD 42 82 70 71 80 A1 80 A1
        .byte   $82,$80,$81,$91,$72,$80,$42,$72 ; C3D5 82 80 81 91 72 80 42 72
        .byte   $40,$83,$90,$83,$80,$A1,$20,$40 ; C3DD 40 83 90 83 80 A1 20 40
        .byte   $20,$82,$62,$82,$A0,$83,$82,$82 ; C3E5 20 82 62 82 A0 83 82 82
        .byte   $A0,$81,$83,$82,$38,$39,$39,$39 ; C3ED A0 81 83 82 38 39 39 39
        .byte   $39,$39,$39,$39,$39,$3A,$82,$A0 ; C3F5 39 39 39 39 39 3A 82 A0
        .byte   $83,$82,$82,$82,$80,$A1,$90,$83 ; C3FD 83 82 82 82 80 A1 90 83
        .byte   $62,$20,$60,$20,$80,$41,$83,$38 ; C405 62 20 60 20 80 41 83 38
        .byte   $39,$39,$39,$39,$39,$39,$39,$3B ; C40D 39 39 39 39 39 39 39 3B
        .byte   $FF,$FF,$24,$1D,$22,$19,$0E,$FF ; C415 FF FF 24 1D 22 19 0E FF
        .byte   $3C,$39,$39,$39,$39,$39,$39,$39 ; C41D 3C 39 39 39 39 39 39 39
        .byte   $3A,$72,$90,$A1,$20,$80,$20,$62 ; C425 3A 72 90 A1 20 80 20 62
        .byte   $80,$91,$3B,$FF,$FF,$FF,$FF,$FF ; C42D 80 91 3B FF FF FF FF FF
        .byte   $FF,$FF,$3D,$3E,$3E,$3E,$3E,$3E ; C435 FF FF 3D 3E 3E 3E 3E 3E
        .byte   $3E,$3E,$3E,$3F,$FF,$FF,$FF,$FF ; C43D 3E 3E 3E 3F FF FF FF FF
        .byte   $FF,$FF,$FF,$3C,$82,$82,$62,$20 ; C445 FF FF FF 3C 82 82 62 20
        .byte   $A0,$20,$42,$62,$72,$3B,$FF,$FF ; C44D A0 20 42 62 72 3B FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C455 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C45D FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$3C,$80 ; C465 FF FF FF FF FF FF 3C 80
        .byte   $81,$A1,$20,$C0,$20,$82,$72,$82 ; C46D 81 A1 20 C0 20 82 72 82
        .byte   $3B,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C475 3B FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C47D FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C485 FF FF FF FF FF FF FF FF
        .byte   $FF,$3C,$90,$83,$80,$20,$E0,$20 ; C48D FF 3C 90 83 80 20 E0 20
        .byte   $62,$A0,$83,$3B,$FF,$FF,$FF,$FF ; C495 62 A0 83 3B FF FF FF FF
        .byte   $FF,$0C,$18,$17,$10,$1B,$0A,$1D ; C49D FF 0C 18 17 10 1B 0A 1D
        .byte   $1E,$15,$0A,$1D,$12,$18,$17,$1C ; C4A5 1E 15 0A 1D 12 18 17 1C
        .byte   $FF,$FF,$FF,$FF,$3C,$72,$60,$61 ; C4AD FF FF FF FF 3C 72 60 61
        .byte   $21,$00,$20,$40,$83,$62,$3B,$FF ; C4B5 21 00 20 40 83 62 3B FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C4BD FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C4C5 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$3C ; C4CD FF FF FF FF FF FF FF 3C
        .byte   $82,$70,$71,$21,$20,$20,$82,$80 ; C4D5 82 70 71 21 20 20 82 80
        .byte   $42,$3B,$FF,$FF,$FF,$FF,$FF,$FF ; C4DD 42 3B FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C4E5 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C4ED FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$3C,$80,$91,$80,$21,$40 ; C4F5 FF FF 3C 80 91 80 21 40
        .byte   $20,$60,$61,$82,$3B,$FF,$FF,$FF ; C4FD 20 60 61 82 3B FF FF FF
        .byte   $FF,$FF,$FF,$FF,$22,$18,$1E,$FF ; C505 FF FF FF FF 22 18 1E FF
        .byte   $0A,$1B,$0E,$FF,$0A,$FF,$FF,$FF ; C50D 0A 1B 0E FF 0A FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$3C,$62,$A0 ; C515 FF FF FF FF FF 3C 62 A0
        .byte   $83,$21,$60,$20,$70,$71,$62,$3B ; C51D 83 21 60 20 70 71 62 3B
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C525 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C52D FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C535 FF FF FF FF FF FF FF FF
        .byte   $3C,$A0,$81,$83,$21,$80,$20,$60 ; C53D 3C A0 81 83 21 80 20 60
        .byte   $61,$72,$3B,$FF,$FF,$FF,$FF,$FF ; C545 61 72 3B FF FF FF FF FF
        .byte   $1D,$0E,$1D,$1B,$12,$1C,$FF,$16 ; C54D 1D 0E 1D 1B 12 1C FF 16
        .byte   $0A,$1C,$1D,$0E,$1B,$6F,$FF,$FF ; C555 0A 1C 1D 0E 1B 6F FF FF
        .byte   $FF,$FF,$FF,$3C,$62,$62,$62,$21 ; C55D FF FF FF 3C 62 62 62 21
        .byte   $A0,$20,$70,$71,$72,$3B,$FF,$FF ; C565 A0 20 70 71 72 3B FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C56D FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C575 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$3C,$72 ; C57D FF FF FF FF FF FF 3C 72
        .byte   $72,$40,$21,$C0,$20,$80,$91,$82 ; C585 72 40 21 C0 20 80 91 82
        .byte   $3B,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C58D 3B FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C595 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C59D FF FF FF FF FF FF FF FF
        .byte   $FF,$3C,$72,$72,$82,$21,$E0,$20 ; C5A5 FF 3C 72 72 82 21 E0 20
        .byte   $62,$A0,$83,$3B,$FF,$19,$15,$0E ; C5AD 62 A0 83 3B FF 19 15 0E
        .byte   $0A,$1C,$0E,$FF,$0E,$17,$1D,$0E ; C5B5 0A 1C 0E FF 0E 17 1D 0E
        .byte   $1B,$FF,$22,$18,$1E,$1B,$FF,$17 ; C5BD 1B FF 22 18 1E 1B FF 17
        .byte   $0A,$16,$0E,$FF,$3C,$82,$82,$62 ; C5C5 0A 16 0E FF 3C 82 82 62
        .byte   $22,$00,$20,$40,$83,$62,$3B,$FF ; C5CD 22 00 20 40 83 62 3B FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C5D5 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C5DD FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$3C ; C5E5 FF FF FF FF FF FF FF 3C
        .byte   $80,$91,$72,$22,$20,$20,$82,$90 ; C5ED 80 91 72 22 20 20 82 90
        .byte   $A1,$3B,$FF,$28,$29,$29,$29,$29 ; C5F5 A1 3B FF 28 29 29 29 29
        .byte   $29,$29,$29,$29,$29,$29,$29,$29 ; C5FD 29 29 29 29 29 29 29 29
        .byte   $29,$29,$29,$29,$29,$29,$29,$29 ; C605 29 29 29 29 29 29 29 29
        .byte   $2A,$FF,$3C,$62,$72,$72,$22,$40 ; C60D 2A FF 3C 62 72 72 22 40
        .byte   $20,$83,$82,$62,$3B,$FF,$2B,$FF ; C615 20 83 82 62 3B FF 2B FF
        .byte   $FF,$FF,$FF,$17,$0A,$16,$0E,$FF ; C61D FF FF FF 17 0A 16 0E FF
        .byte   $FF,$1C,$0C,$18,$1B,$0E,$FF,$FF ; C625 FF 1C 0C 18 1B 0E FF FF
        .byte   $15,$1F,$FF,$2C,$FF,$3C,$72,$82 ; C62D 15 1F FF 2C FF 3C 72 82
        .byte   $82,$22,$60,$20,$80,$81,$A1,$3B ; C635 82 22 60 20 80 81 A1 3B
        .byte   $FF,$4C,$2E,$2E,$2E,$2E,$2E,$2E ; C63D FF 4C 2E 2E 2E 2E 2E 2E
        .byte   $2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E ; C645 2E 2E 2E 2E 2E 2E 2E 2E
        .byte   $2E,$2E,$2E,$2E,$2E,$2E,$4E,$FF ; C64D 2E 2E 2E 2E 2E 2E 4E FF
        .byte   $3C,$A0,$83,$80,$22,$80,$20,$80 ; C655 3C A0 83 80 22 80 20 80
        .byte   $81,$91,$3B,$FF,$2B,$FF,$01,$FF ; C65D 81 91 3B FF 2B FF 01 FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C665 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C66D FF FF FF FF FF FF FF FF
        .byte   $FF,$2C,$FF,$3C,$80,$43,$83,$22 ; C675 FF 2C FF 3C 80 43 83 22
        .byte   $A0,$20,$90,$83,$82,$3B,$FF,$2B ; C67D A0 20 90 83 82 3B FF 2B
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C685 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C68D FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$2C,$FF,$3C,$62 ; C695 FF FF FF FF 2C FF 3C 62
        .byte   $82,$80,$22,$C0,$20,$72,$60,$61 ; C69D 82 80 22 C0 20 72 60 61
        .byte   $3B,$FF,$2B,$FF,$02,$FF,$FF,$FF ; C6A5 3B FF 2B FF 02 FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C6AD FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$2C ; C6B5 FF FF FF FF FF FF FF 2C
        .byte   $FF,$3C,$A0,$81,$83,$22,$E0,$20 ; C6BD FF 3C A0 81 83 22 E0 20
        .byte   $82,$70,$71,$3B,$FF,$2B,$FF,$FF ; C6C5 82 70 71 3B FF 2B FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C6CD FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C6D5 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$2C,$FF,$3C,$60,$61,$80 ; C6DD FF FF 2C FF 3C 60 61 80
        .byte   $23,$00,$20,$83,$90,$83,$3B,$FF ; C6E5 23 00 20 83 90 83 3B FF
        .byte   $2B,$FF,$03,$FF,$FF,$FF,$FF,$FF ; C6ED 2B FF 03 FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C6F5 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$2C,$FF,$3C ; C6FD FF FF FF FF FF 2C FF 3C
        .byte   $70,$71,$80,$23,$20,$20,$80,$A1 ; C705 70 71 80 23 20 20 80 A1
        .byte   $62,$3B,$FF,$2D,$2E,$2E,$2E,$2E ; C70D 62 3B FF 2D 2E 2E 2E 2E
        .byte   $2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E ; C715 2E 2E 2E 2E 2E 2E 2E 2E
        .byte   $2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E ; C71D 2E 2E 2E 2E 2E 2E 2E 2E
        .byte   $2F,$FF,$3C,$62,$60,$61,$23,$40 ; C725 2F FF 3C 62 60 61 23 40
        .byte   $20,$80,$81,$A1,$3B,$FF,$FF,$FF ; C72D 20 80 81 A1 3B FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C735 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C73D FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$3C,$72,$70 ; C745 FF FF FF FF FF 3C 72 70
        .byte   $71,$23,$60,$20,$81,$81,$83,$3D ; C74D 71 23 60 20 81 81 83 3D
        .byte   $3E,$3E,$3E,$3E,$3E,$3E,$3E,$3E ; C755 3E 3E 3E 3E 3E 3E 3E 3E
        .byte   $3E,$3E,$3E,$3E,$3E,$3E,$3E,$3E ; C75D 3E 3E 3E 3E 3E 3E 3E 3E
        .byte   $3E,$3E,$3E,$3E,$3E,$3E,$3E,$3E ; C765 3E 3E 3E 3E 3E 3E 3E 3E
        .byte   $3F,$A0,$83,$62,$23,$80,$20,$60 ; C76D 3F A0 83 62 23 80 20 60
        .byte   $61,$60,$61,$80,$81,$81,$83,$62 ; C775 61 60 61 80 81 81 83 62
        .byte   $62,$62,$80,$81,$91,$62,$80,$43 ; C77D 62 62 80 81 91 62 80 43
        .byte   $83,$62,$62,$80,$81,$81,$83,$62 ; C785 83 62 62 80 81 81 83 62
        .byte   $90,$83,$60,$61,$62,$90,$A1,$23 ; C78D 90 83 60 61 62 90 A1 23
        .byte   $A0,$20,$70,$71,$70,$71,$90,$83 ; C795 A0 20 70 71 70 71 90 83
        .byte   $80,$81,$A1,$72,$A0,$81,$83,$82 ; C79D 80 81 A1 72 A0 81 83 82
        .byte   $40,$83,$82,$80,$42,$40,$83,$80 ; C7A5 40 83 82 80 42 40 83 80
        .byte   $91,$80,$42,$72,$62,$70,$71,$72 ; C7AD 91 80 42 72 62 70 71 72
        .byte   $82,$62,$23,$C0,$20,$AA,$AA,$AA ; C7B5 82 62 23 C0 20 AA AA AA
        .byte   $AA,$AA,$AA,$AA,$AA,$AA,$0A,$FA ; C7BD AA AA AA AA AA AA 0A FA
        .byte   $FA,$FA,$FA,$0A,$AA,$AA,$00,$00 ; C7C5 FA FA FA 0A AA AA 00 00
        .byte   $00,$00,$00,$00,$AA,$AA,$00,$00 ; C7CD 00 00 00 00 AA AA 00 00
        .byte   $00,$00,$00,$00,$AA,$23,$E0,$20 ; C7D5 00 00 00 00 AA 23 E0 20
        .byte   $AA,$00,$00,$00,$00,$00,$00,$AA ; C7DD AA 00 00 00 00 00 00 AA
        .byte   $AA,$00,$00,$00,$00,$00,$00,$AA ; C7E5 AA 00 00 00 00 00 00 AA
        .byte   $AA,$A0,$A0,$A0,$A0,$A0,$A0,$AA ; C7ED AA A0 A0 A0 A0 A0 A0 AA
        .byte   $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A ; C7F5 0A 0A 0A 0A 0A 0A 0A 0A
        .byte   $FF                             ; C7FD FF
high_scores_nametable:
        .byte   $22,$20,$20,$A0,$81,$83,$3B,$FF ; C7FE 22 20 20 A0 81 83 3B FF
        .byte   $28,$29,$29,$29,$29,$29,$29,$29 ; C806 28 29 29 29 29 29 29 29
        .byte   $29,$29,$29,$29,$29,$29,$29,$29 ; C80E 29 29 29 29 29 29 29 29
        .byte   $29,$29,$29,$29,$29,$2A,$FF,$3C ; C816 29 29 29 29 29 2A FF 3C
        .byte   $60,$61,$72,$22,$40,$20,$62,$80 ; C81E 60 61 72 22 40 20 62 80
        .byte   $91,$3B,$FF,$2B,$FF,$FF,$FF,$FF ; C826 91 3B FF 2B FF FF FF FF
        .byte   $17,$0A,$16,$0E,$FF,$FF,$1C,$0C ; C82E 17 0A 16 0E FF FF 1C 0C
        .byte   $18,$1B,$0E,$FF,$FF,$15,$1F,$FF ; C836 18 1B 0E FF FF 15 1F FF
        .byte   $2C,$FF,$3C,$70,$71,$82,$22,$60 ; C83E 2C FF 3C 70 71 82 22 60
        .byte   $20,$42,$62,$72,$3B,$FF,$4C,$2E ; C846 20 42 62 72 3B FF 4C 2E
        .byte   $2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E ; C84E 2E 2E 2E 2E 2E 2E 2E 2E
        .byte   $2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E ; C856 2E 2E 2E 2E 2E 2E 2E 2E
        .byte   $2E,$2E,$2E,$4E,$FF,$3C,$80,$81 ; C85E 2E 2E 2E 4E FF 3C 80 81
        .byte   $91,$22,$80,$20,$82,$72,$82,$3B ; C866 91 22 80 20 82 72 82 3B
        .byte   $FF,$2B,$FF,$01,$FF,$FF,$FF,$FF ; C86E FF 2B FF 01 FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C876 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$2C,$FF ; C87E FF FF FF FF FF FF 2C FF
        .byte   $3C,$62,$62,$82,$22,$A0,$20,$80 ; C886 3C 62 62 82 22 A0 20 80
        .byte   $A1,$62,$3B,$FF,$2B,$FF,$FF,$FF ; C88E A1 62 3B FF 2B FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C896 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C89E FF FF FF FF FF FF FF FF
        .byte   $FF,$2C,$FF,$3C,$72,$A0,$91,$22 ; C8A6 FF 2C FF 3C 72 A0 91 22
        .byte   $C0,$20,$60,$61,$72,$3B,$FF,$2B ; C8AE C0 20 60 61 72 3B FF 2B
        .byte   $FF,$02,$FF,$FF,$FF,$FF,$FF,$FF ; C8B6 FF 02 FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C8BE FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$2C,$FF,$3C,$72 ; C8C6 FF FF FF FF 2C FF 3C 72
        .byte   $62,$82,$22,$E0,$20,$70,$71,$72 ; C8CE 62 82 22 E0 20 70 71 72
        .byte   $3B,$FF,$2B,$FF,$FF,$FF,$FF,$FF ; C8D6 3B FF 2B FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C8DE FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$2C ; C8E6 FF FF FF FF FF FF FF 2C
        .byte   $FF,$3C,$82,$72,$80,$23,$00,$20 ; C8EE FF 3C 82 72 80 23 00 20
        .byte   $62,$62,$82,$3B,$FF,$2B,$FF,$03 ; C8F6 62 62 82 3B FF 2B FF 03
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C8FE FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C906 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$2C,$FF,$3C,$62,$A0,$83 ; C90E FF FF 2C FF 3C 62 A0 83
        .byte   $23,$20,$20,$72,$40,$73,$3B,$FF ; C916 23 20 20 72 40 73 3B FF
        .byte   $2D,$2E,$2E,$2E,$2E,$2E,$2E,$2E ; C91E 2D 2E 2E 2E 2E 2E 2E 2E
        .byte   $2E,$2E,$2E,$2E,$2E,$2E,$2E,$2E ; C926 2E 2E 2E 2E 2E 2E 2E 2E
        .byte   $2E,$2E,$2E,$2E,$2E,$2F,$FF,$3C ; C92E 2E 2E 2E 2E 2E 2F FF 3C
        .byte   $A0,$81,$83,$23,$E0,$20,$AA,$00 ; C936 A0 81 83 23 E0 20 AA 00
        .byte   $00,$00,$00,$00,$00,$AA,$AA,$00 ; C93E 00 00 00 00 00 AA AA 00
        .byte   $00,$00,$00,$00,$00,$AA,$AA,$A0 ; C946 00 00 00 00 00 AA AA A0
        .byte   $A0,$A0,$A0,$A0,$A0,$AA,$0A,$0A ; C94E A0 A0 A0 A0 A0 AA 0A 0A
        .byte   $0A,$0A,$0A,$0A,$0A,$0A,$FF     ; C956 0A 0A 0A 0A 0A 0A FF
height_menu_nametablepalette_patch:
        .byte   $3F,$0A,$01,$16,$20,$6D,$01,$0A ; C95D 3F 0A 01 16 20 6D 01 0A
        .byte   $20,$F3,$48,$FF,$21,$13,$48,$FF ; C965 20 F3 48 FF 21 13 48 FF
        .byte   $21,$33,$48,$FF,$21,$53,$47,$FF ; C96D 21 33 48 FF 21 53 47 FF
        .byte   $21,$73,$47,$FF,$21,$93,$47,$FF ; C975 21 73 47 FF 21 93 47 FF
        .byte   $21,$B3,$47,$FF,$21,$D3,$47,$FF ; C97D 21 B3 47 FF 21 D3 47 FF
        .byte   $22,$33,$48,$FF,$22,$53,$48,$FF ; C985 22 33 48 FF 22 53 48 FF
        .byte   $22,$73,$48,$FF,$22,$93,$47,$FF ; C98D 22 73 48 FF 22 93 47 FF
        .byte   $22,$B3,$47,$FF,$22,$D3,$47,$FF ; C995 22 B3 47 FF 22 D3 47 FF
        .byte   $22,$F3,$47,$FF,$23,$13,$47,$FF ; C99D 22 F3 47 FF 23 13 47 FF
        .byte   $FF                             ; C9A5 FF
type_b_lvl9_ending_nametable:
        .byte   $20,$00,$20,$FF,$FF,$FF,$FF,$FF ; C9A6 20 00 20 FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C9AE FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C9B6 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C9BE FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$20,$20,$20,$FF,$FF ; C9C6 FF FF FF 20 20 20 FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C9CE FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C9D6 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C9DE FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$20,$40 ; C9E6 FF FF FF FF FF FF 20 40
        .byte   $20,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C9EE 20 FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C9F6 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; C9FE FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; CA06 FF FF FF FF FF FF FF FF
        .byte   $FF,$20,$60,$20,$FF,$FF,$FF,$FF ; CA0E FF 20 60 20 FF FF FF FF
        .byte   $FF,$18,$19,$19,$19,$19,$19,$19 ; CA16 FF 18 19 19 19 19 19 19
        .byte   $19,$19,$19,$19,$19,$19,$19,$19 ; CA1E 19 19 19 19 19 19 19 19
        .byte   $19,$1A,$FF,$FF,$FF,$FF,$FF,$FF ; CA26 19 1A FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$20,$80,$20,$FF ; CA2E FF FF FF FF 20 80 20 FF
        .byte   $FF,$FF,$FF,$FF,$1B,$FF,$0A,$0B ; CA36 FF FF FF FF 1B FF 0A 0B
        .byte   $0C,$0D,$0E,$FF,$FF,$00,$00,$00 ; CA3E 0C 0D 0E FF FF 00 00 00
        .byte   $00,$00,$00,$FF,$1C,$FF,$FF,$FF ; CA46 00 00 00 FF 1C FF FF FF
        .byte   $FF,$FF,$FF,$BE,$BF,$BE,$BF,$20 ; CA4E FF FF FF BE BF BE BF 20
        .byte   $A0,$20,$FF,$FF,$FF,$FF,$FF,$1B ; CA56 A0 20 FF FF FF FF FF 1B
        .byte   $FF,$0F,$0E,$10,$0E,$0F,$FF,$FF ; CA5E FF 0F 0E 10 0E 0F FF FF
        .byte   $FF,$00,$00,$00,$00,$00,$FF,$1C ; CA66 FF 00 00 00 00 00 FF 1C
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$AE,$AF ; CA6E FF FF FF FF FF FF AE AF
        .byte   $AE,$AF,$20,$C0,$20,$FF,$FF,$FF ; CA76 AE AF 20 C0 20 FF FF FF
        .byte   $FF,$FF,$1B,$FF,$11,$0E,$12,$13 ; CA7E FF FF 1B FF 11 0E 12 13
        .byte   $11,$14,$FF,$FF,$00,$00,$00,$00 ; CA86 11 14 FF FF 00 00 00 00
        .byte   $00,$FF,$1C,$FF,$FF,$FF,$FF,$FF ; CA8E 00 FF 1C FF FF FF FF FF
        .byte   $FF,$AE,$AF,$AE,$AF,$20,$E0,$20 ; CA96 FF AE AF AE AF 20 E0 20
        .byte   $FF,$FF,$FF,$FF,$FF,$1B,$FF,$FF ; CA9E FF FF FF FF FF 1B FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; CAA6 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$1C,$FF,$FF ; CAAE FF FF FF FF FF 1C FF FF
        .byte   $FF,$43,$44,$45,$CE,$CF,$AE,$AF ; CAB6 FF 43 44 45 CE CF AE AF
        .byte   $21,$00,$20,$BE,$BF,$BE,$BF,$FF ; CABE 21 00 20 BE BF BE BF FF
        .byte   $1B,$FF,$16,$16,$16,$16,$16,$16 ; CAC6 1B FF 16 16 16 16 16 16
        .byte   $16,$16,$16,$16,$16,$16,$16,$FF ; CACE 16 16 16 16 16 16 16 FF
        .byte   $1C,$FF,$FF,$FF,$53,$54,$55,$DE ; CAD6 1C FF FF FF 53 54 55 DE
        .byte   $DF,$AE,$AF,$21,$20,$20,$AE,$AF ; CADE DF AE AF 21 20 20 AE AF
        .byte   $AE,$AF,$FF,$1B,$FF,$14,$0C,$14 ; CAE6 AE AF FF 1B FF 14 0C 14
        .byte   $15,$0F,$FF,$FF,$00,$00,$00,$00 ; CAEE 15 0F FF FF 00 00 00 00
        .byte   $00,$00,$FF,$1C,$FF,$FF,$FF,$FF ; CAF6 00 00 FF 1C FF FF FF FF
        .byte   $FF,$65,$EE,$EF,$AE,$AF,$21,$40 ; CAFE FF 65 EE EF AE AF 21 40
        .byte   $20,$AE,$AF,$AE,$AF,$FF,$1D,$1E ; CB06 20 AE AF AE AF FF 1D 1E
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; CB0E 1E 1E 1E 1E 1E 1E 1E 1E
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1F,$FF ; CB16 1E 1E 1E 1E 1E 1E 1F FF
        .byte   $FF,$BE,$BF,$BE,$BF,$BE,$AF,$AE ; CB1E FF BE BF BE BF BE AF AE
        .byte   $AF,$21,$60,$20,$AE,$AF,$AE,$AF ; CB26 AF 21 60 20 AE AF AE AF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; CB2E FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; CB36 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$AE,$AF,$AE,$AF ; CB3E FF FF FF FF AE AF AE AF
        .byte   $AE,$AF,$AE,$AF,$21,$80,$20,$AE ; CB46 AE AF AE AF 21 80 20 AE
        .byte   $AF,$CC,$CD,$FF,$FF,$FF,$FF,$FF ; CB4E AF CC CD FF FF FF FF FF
        .byte   $CA,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; CB56 CA FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$AE ; CB5E FF FF FF FF FF FF FF AE
        .byte   $AF,$AE,$AF,$AE,$AF,$AE,$AF,$21 ; CB66 AF AE AF AE AF AE AF 21
        .byte   $A0,$20,$AE,$AF,$DC,$DD,$FF,$93 ; CB6E A0 20 AE AF DC DD FF 93
        .byte   $94,$FF,$FF,$DA,$FF,$FF,$FF,$FF ; CB76 94 FF FF DA FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; CB7E FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$AE,$AF,$AE,$AF,$AE,$AF ; CB86 FF FF AE AF AE AF AE AF
        .byte   $AE,$AF,$21,$C0,$20,$AE,$AF,$EC ; CB8E AE AF 21 C0 20 AE AF EC
        .byte   $ED,$FF,$FF,$FF,$FF,$FF,$EA,$FF ; CB96 ED FF FF FF FF FF EA FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; CB9E FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; CBA6 FF FF FF FF FF FF FF FF
        .byte   $FF,$AE,$AF,$AE,$AF,$21,$E0,$20 ; CBAE FF AE AF AE AF 21 E0 20
        .byte   $AE,$AF,$EC,$ED,$FF,$B3,$B4,$B5 ; CBB6 AE AF EC ED FF B3 B4 B5
        .byte   $F9,$FA,$FB,$FF,$FF,$FF,$FF,$FF ; CBBE F9 FA FB FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; CBC6 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$AE,$AF,$AE,$AF ; CBCE FF FF FF FF AE AF AE AF
        .byte   $22,$00,$20,$AE,$AF,$AE,$BF,$BE ; CBD6 22 00 20 AE AF AE BF BE
        .byte   $BF,$BE,$BF,$BE,$BF,$BE,$BF,$FF ; CBDE BF BE BF BE BF BE BF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; CBE6 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$CE ; CBEE FF FF FF FF FF FF FF CE
        .byte   $CF,$AE,$AF,$22,$20,$20,$AE,$AF ; CBF6 CF AE AF 22 20 20 AE AF
        .byte   $AE,$AF,$AE,$AF,$AE,$AF,$AE,$AF ; CBFE AE AF AE AF AE AF AE AF
        .byte   $AE,$AF,$FF,$FF,$FF,$FF,$FF,$FF ; CC06 AE AF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; CC0E FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$DE,$DF,$AE,$AF,$22,$40 ; CC16 FF FF DE DF AE AF 22 40
        .byte   $20,$AE,$AF,$DC,$CD,$FF,$FF,$C0 ; CC1E 20 AE AF DC CD FF FF C0
        .byte   $C1,$C2,$C3,$FF,$FF,$FF,$FF,$FF ; CC26 C1 C2 C3 FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; CC2E FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$EE,$EF,$AE ; CC36 FF FF FF FF FF EE EF AE
        .byte   $AF,$22,$60,$20,$AE,$AF,$EC,$DD ; CC3E AF 22 60 20 AE AF EC DD
        .byte   $FF,$FF,$D0,$D1,$D2,$D3,$FF,$FF ; CC46 FF FF D0 D1 D2 D3 FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; CC4E FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; CC56 FF FF FF FF FF FF FF FF
        .byte   $EE,$EF,$AE,$AF,$22,$80,$20,$AE ; CC5E EE EF AE AF 22 80 20 AE
        .byte   $AF,$EC,$ED,$FF,$FF,$E0,$FF,$FF ; CC66 AF EC ED FF FF E0 FF FF
        .byte   $E3,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; CC6E E3 FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$BE,$BF,$BE,$BF,$BE ; CC76 FF FF FF BE BF BE BF BE
        .byte   $BF,$BE,$BF,$BE,$AF,$AE,$AF,$22 ; CC7E BF BE BF BE AF AE AF 22
        .byte   $A0,$20,$AE,$AF,$EC,$ED,$FF,$FF ; CC86 A0 20 AE AF EC ED FF FF
        .byte   $F0,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; CC8E F0 FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$AE,$AF ; CC96 FF FF FF FF FF FF AE AF
        .byte   $AE,$AF,$AE,$AF,$AE,$AF,$AE,$AF ; CC9E AE AF AE AF AE AF AE AF
        .byte   $AE,$AF,$22,$C0,$20,$AE,$AF,$AE ; CCA6 AE AF 22 C0 20 AE AF AE
        .byte   $BF,$BE,$BF,$BE,$BF,$BE,$BF,$FF ; CCAE BF BE BF BE BF BE BF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$4D,$FF ; CCB6 FF FF FF FF FF FF 4D FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; CCBE FF FF FF FF FF FF FF FF
        .byte   $FF,$CE,$CF,$AE,$AF,$22,$E0,$20 ; CCC6 FF CE CF AE AF 22 E0 20
        .byte   $AE,$AF,$AE,$AF,$AE,$AF,$AE,$AF ; CCCE AE AF AE AF AE AF AE AF
        .byte   $AE,$AF,$FF,$FF,$FF,$59,$5A,$FF ; CCD6 AE AF FF FF FF 59 5A FF
        .byte   $5C,$5D,$FF,$FF,$FF,$FF,$FF,$FF ; CCDE 5C 5D FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$DE,$DF,$AE,$AF ; CCE6 FF FF FF FF DE DF AE AF
        .byte   $23,$00,$20,$AE,$AF,$AE,$AF,$AE ; CCEE 23 00 20 AE AF AE AF AE
        .byte   $AF,$AE,$AF,$AE,$AF,$FF,$FF,$68 ; CCF6 AF AE AF AE AF FF FF 68
        .byte   $69,$6A,$6B,$6C,$6D,$6E,$6F,$FF ; CCFE 69 6A 6B 6C 6D 6E 6F FF
        .byte   $B6,$B7,$B8,$FF,$FF,$81,$FF,$EE ; CD06 B6 B7 B8 FF FF 81 FF EE
        .byte   $EF,$AE,$AF,$23,$20,$20,$AE,$AF ; CD0E EF AE AF 23 20 20 AE AF
        .byte   $AE,$AF,$AE,$AF,$AE,$AF,$AE,$AF ; CD16 AE AF AE AF AE AF AE AF
        .byte   $FF,$FF,$78,$79,$7A,$7B,$7C,$7D ; CD1E FF FF 78 79 7A 7B 7C 7D
        .byte   $7E,$7F,$FF,$C6,$C7,$FF,$FF,$90 ; CD26 7E 7F FF C6 C7 FF FF 90
        .byte   $91,$92,$EE,$EF,$AE,$AF,$23,$40 ; CD2E 91 92 EE EF AE AF 23 40
        .byte   $20,$AE,$AF,$AE,$AF,$AE,$AF,$AE ; CD36 20 AE AF AE AF AE AF AE
        .byte   $AF,$AE,$AF,$FF,$FF,$88,$89,$8A ; CD3E AF AE AF FF FF 88 89 8A
        .byte   $8B,$8C,$8D,$8E,$8F,$FF,$FF,$FF ; CD46 8B 8C 8D 8E 8F FF FF FF
        .byte   $FF,$FF,$A0,$A1,$A2,$EE,$EF,$AE ; CD4E FF FF A0 A1 A2 EE EF AE
        .byte   $AF,$23,$60,$20,$AE,$AF,$AE,$AF ; CD56 AF 23 60 20 AE AF AE AF
        .byte   $AE,$AF,$AE,$AF,$AE,$AF,$FF,$FF ; CD5E AE AF AE AF AE AF FF FF
        .byte   $98,$99,$9A,$9B,$9C,$9D,$9E,$9F ; CD66 98 99 9A 9B 9C 9D 9E 9F
        .byte   $FF,$E6,$E7,$E8,$FF,$B0,$B1,$B2 ; CD6E FF E6 E7 E8 FF B0 B1 B2
        .byte   $EE,$EF,$AE,$AF,$23,$80,$20,$96 ; CD76 EE EF AE AF 23 80 20 96
        .byte   $97,$96,$97,$96,$97,$96,$97,$96 ; CD7E 97 96 97 96 97 96 97 96
        .byte   $97,$96,$97,$96,$97,$96,$97,$96 ; CD86 97 96 97 96 97 96 97 96
        .byte   $97,$96,$97,$96,$97,$96,$97,$96 ; CD8E 97 96 97 96 97 96 97 96
        .byte   $97,$96,$97,$96,$97,$96,$97,$23 ; CD96 97 96 97 96 97 96 97 23
        .byte   $A0,$20,$A6,$A7,$A6,$A7,$A6,$A7 ; CD9E A0 20 A6 A7 A6 A7 A6 A7
        .byte   $A6,$A7,$A6,$A7,$A6,$A7,$A6,$A7 ; CDA6 A6 A7 A6 A7 A6 A7 A6 A7
        .byte   $A6,$A7,$A6,$A7,$A6,$A7,$A6,$A7 ; CDAE A6 A7 A6 A7 A6 A7 A6 A7
        .byte   $A6,$A7,$A6,$A7,$A6,$A7,$A6,$A7 ; CDB6 A6 A7 A6 A7 A6 A7 A6 A7
        .byte   $A6,$A7,$23,$C0,$20,$AA,$FA,$FA ; CDBE A6 A7 23 C0 20 AA FA FA
        .byte   $FA,$FA,$BA,$AA,$AA,$AA,$77,$55 ; CDC6 FA FA BA AA AA AA 77 55
        .byte   $55,$55,$BB,$5A,$AA,$AA,$F7,$F5 ; CDCE 55 55 BB 5A AA AA F7 F5
        .byte   $F5,$F5,$BB,$A5,$AA,$AA,$55,$AA ; CDD6 F5 F5 BB A5 AA AA 55 AA
        .byte   $00,$00,$AA,$AA,$AA,$23,$E0,$20 ; CDDE 00 00 AA AA AA 23 E0 20
        .byte   $AA,$2A,$8A,$00,$00,$00,$00,$AA ; CDE6 AA 2A 8A 00 00 00 00 AA
        .byte   $AA,$A2,$A8,$00,$00,$AA,$AA,$AA ; CDEE AA A2 A8 00 00 AA AA AA
        .byte   $AA,$AA,$AA,$0F,$0F,$FF,$00,$AA ; CDF6 AA AA AA 0F 0F FF 00 AA
        .byte   $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A ; CDFE 0A 0A 0A 0A 0A 0A 0A 0A
        .byte   $FF                             ; CE06 FF
type_b_ending_nametable:
        .byte   $20,$00,$20,$76,$77,$76,$77,$76 ; CE07 20 00 20 76 77 76 77 76
        .byte   $77,$76,$77,$76,$77,$76,$77,$76 ; CE0F 77 76 77 76 77 76 77 76
        .byte   $77,$76,$77,$76,$77,$76,$77,$76 ; CE17 77 76 77 76 77 76 77 76
        .byte   $77,$76,$77,$76,$77,$76,$77,$76 ; CE1F 77 76 77 76 77 76 77 76
        .byte   $77,$76,$77,$20,$20,$20,$76,$77 ; CE27 77 76 77 20 20 20 76 77
        .byte   $76,$77,$76,$77,$76,$77,$76,$77 ; CE2F 76 77 76 77 76 77 76 77
        .byte   $76,$77,$76,$77,$76,$77,$76,$77 ; CE37 76 77 76 77 76 77 76 77
        .byte   $76,$77,$76,$77,$76,$77,$76,$77 ; CE3F 76 77 76 77 76 77 76 77
        .byte   $76,$77,$76,$77,$76,$77,$20,$40 ; CE47 76 77 76 77 76 77 20 40
        .byte   $20,$76,$77,$FF,$FF,$FF,$FF,$FF ; CE4F 20 76 77 FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; CE57 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; CE5F FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$76 ; CE67 FF FF FF FF FF FF FF 76
        .byte   $77,$20,$60,$20,$76,$77,$FF,$FF ; CE6F 77 20 60 20 76 77 FF FF
        .byte   $FF,$18,$19,$19,$19,$19,$19,$19 ; CE77 FF 18 19 19 19 19 19 19
        .byte   $19,$19,$19,$19,$19,$19,$19,$19 ; CE7F 19 19 19 19 19 19 19 19
        .byte   $19,$1A,$FF,$FF,$FF,$FF,$FF,$FF ; CE87 19 1A FF FF FF FF FF FF
        .byte   $FF,$FF,$76,$77,$20,$80,$20,$76 ; CE8F FF FF 76 77 20 80 20 76
        .byte   $77,$FF,$FF,$FF,$1B,$FF,$0A,$0B ; CE97 77 FF FF FF 1B FF 0A 0B
        .byte   $0C,$0D,$0E,$FF,$FF,$00,$00,$00 ; CE9F 0C 0D 0E FF FF 00 00 00
        .byte   $00,$00,$00,$FF,$1C,$FF,$FF,$FF ; CEA7 00 00 00 FF 1C FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$76,$77,$20 ; CEAF FF FF FF FF FF 76 77 20
        .byte   $A0,$20,$76,$77,$FF,$FF,$FF,$1B ; CEB7 A0 20 76 77 FF FF FF 1B
        .byte   $FF,$0F,$0E,$10,$0E,$0F,$FF,$FF ; CEBF FF 0F 0E 10 0E 0F FF FF
        .byte   $FF,$00,$00,$00,$00,$00,$FF,$1C ; CEC7 FF 00 00 00 00 00 FF 1C
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; CECF FF FF FF FF FF FF FF FF
        .byte   $76,$77,$20,$C0,$20,$76,$77,$FF ; CED7 76 77 20 C0 20 76 77 FF
        .byte   $FF,$FF,$1B,$FF,$11,$0E,$12,$13 ; CEDF FF FF 1B FF 11 0E 12 13
        .byte   $11,$14,$FF,$FF,$00,$00,$00,$00 ; CEE7 11 14 FF FF 00 00 00 00
        .byte   $00,$FF,$1C,$FF,$FF,$FF,$FF,$FF ; CEEF 00 FF 1C FF FF FF FF FF
        .byte   $FF,$FF,$FF,$76,$77,$20,$E0,$20 ; CEF7 FF FF FF 76 77 20 E0 20
        .byte   $76,$77,$FF,$FF,$FF,$1B,$FF,$FF ; CEFF 76 77 FF FF FF 1B FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; CF07 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$1C,$FF,$FF ; CF0F FF FF FF FF FF 1C FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$76,$77 ; CF17 FF FF FF FF FF FF 76 77
        .byte   $21,$00,$20,$76,$77,$FF,$FF,$FF ; CF1F 21 00 20 76 77 FF FF FF
        .byte   $1B,$FF,$16,$16,$16,$16,$16,$16 ; CF27 1B FF 16 16 16 16 16 16
        .byte   $16,$16,$16,$16,$16,$16,$16,$FF ; CF2F 16 16 16 16 16 16 16 FF
        .byte   $1C,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; CF37 1C FF FF FF FF FF FF FF
        .byte   $FF,$76,$77,$21,$20,$20,$76,$77 ; CF3F FF 76 77 21 20 20 76 77
        .byte   $FF,$FF,$FF,$1B,$FF,$14,$0C,$14 ; CF47 FF FF FF 1B FF 14 0C 14
        .byte   $15,$0F,$FF,$FF,$00,$00,$00,$00 ; CF4F 15 0F FF FF 00 00 00 00
        .byte   $00,$00,$FF,$1C,$FF,$FF,$FF,$FF ; CF57 00 00 FF 1C FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$76,$77,$21,$40 ; CF5F FF FF FF FF 76 77 21 40
        .byte   $20,$76,$77,$FF,$FF,$FF,$1D,$1E ; CF67 20 76 77 FF FF FF 1D 1E
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; CF6F 1E 1E 1E 1E 1E 1E 1E 1E
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1F,$FF ; CF77 1E 1E 1E 1E 1E 1E 1F FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$76 ; CF7F FF FF FF FF FF FF FF 76
        .byte   $77,$21,$60,$20,$76,$77,$FF,$FF ; CF87 77 21 60 20 76 77 FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; CF8F FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; CF97 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; CF9F FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$76,$77,$21,$80,$20,$76 ; CFA7 FF FF 76 77 21 80 20 76
        .byte   $77,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; CFAF 77 FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; CFB7 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; CFBF FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$76,$77,$21 ; CFC7 FF FF FF FF FF 76 77 21
        .byte   $A0,$20,$76,$77,$FF,$FF,$FF,$FF ; CFCF A0 20 76 77 FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; CFD7 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; CFDF FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; CFE7 FF FF FF FF FF FF FF FF
        .byte   $76,$77,$21,$C0,$20,$76,$77,$FF ; CFEF 76 77 21 C0 20 76 77 FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; CFF7 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; CFFF FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D007 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$76,$77,$21,$E0,$20 ; D00F FF FF FF 76 77 21 E0 20
        .byte   $76,$77,$FF,$FF,$FF,$FF,$FF,$FF ; D017 76 77 FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D01F FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D027 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$76,$77 ; D02F FF FF FF FF FF FF 76 77
        .byte   $22,$00,$20,$76,$77,$FF,$FF,$FF ; D037 22 00 20 76 77 FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D03F FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D047 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D04F FF FF FF FF FF FF FF FF
        .byte   $FF,$76,$77,$22,$20,$20,$76,$77 ; D057 FF 76 77 22 20 20 76 77
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D05F FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D067 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D06F FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$76,$77,$22,$40 ; D077 FF FF FF FF 76 77 22 40
        .byte   $20,$76,$77,$FF,$FF,$FF,$FF,$FF ; D07F 20 76 77 FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D087 FF FF FF FF FF FF FF FF
        .byte   $FF,$38,$FF,$FF,$FF,$FF,$FF,$FF ; D08F FF 38 FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$76 ; D097 FF FF FF FF FF FF FF 76
        .byte   $77,$22,$60,$20,$76,$77,$FF,$FF ; D09F 77 22 60 20 76 77 FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D0A7 FF FF FF FF FF FF FF FF
        .byte   $FF,$39,$FF,$3B,$3C,$FF,$3E,$FF ; D0AF FF 39 FF 3B 3C FF 3E FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D0B7 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$76,$77,$22,$80,$20,$76 ; D0BF FF FF 76 77 22 80 20 76
        .byte   $77,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D0C7 77 FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$48,$49,$4A,$4B,$4C ; D0CF FF FF FF 48 49 4A 4B 4C
        .byte   $4D,$4E,$4F,$FF,$FF,$FF,$FF,$FF ; D0D7 4D 4E 4F FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$76,$77,$22 ; D0DF FF FF FF FF FF 76 77 22
        .byte   $A0,$20,$76,$77,$FF,$FF,$FF,$FF ; D0E7 A0 20 76 77 FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$58,$59 ; D0EF FF FF FF FF FF FF 58 59
        .byte   $5A,$5B,$5C,$5D,$5E,$5F,$FF,$FF ; D0F7 5A 5B 5C 5D 5E 5F FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D0FF FF FF FF FF FF FF FF FF
        .byte   $76,$77,$22,$C0,$20,$76,$77,$FF ; D107 76 77 22 C0 20 76 77 FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D10F FF FF FF FF FF FF FF FF
        .byte   $FF,$68,$69,$6A,$6B,$6C,$6D,$6E ; D117 FF 68 69 6A 6B 6C 6D 6E
        .byte   $6F,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D11F 6F FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$76,$77,$22,$E0,$20 ; D127 FF FF FF 76 77 22 E0 20
        .byte   $76,$77,$FF,$FF,$FF,$FF,$FF,$FF ; D12F 76 77 FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$78,$79,$7A,$7B ; D137 FF FF FF FF 78 79 7A 7B
        .byte   $7C,$7D,$7E,$7F,$FF,$FF,$FF,$FF ; D13F 7C 7D 7E 7F FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$76,$77 ; D147 FF FF FF FF FF FF 76 77
        .byte   $23,$00,$20,$76,$77,$FF,$FF,$FF ; D14F 23 00 20 76 77 FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$88 ; D157 FF FF FF FF FF FF FF 88
        .byte   $89,$8A,$8B,$8C,$8D,$8E,$8F,$FF ; D15F 89 8A 8B 8C 8D 8E 8F FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D167 FF FF FF FF FF FF FF FF
        .byte   $FF,$76,$77,$23,$20,$20,$76,$77 ; D16F FF 76 77 23 20 20 76 77
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D177 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$98,$99,$9A,$9B,$9C,$9D ; D17F FF FF 98 99 9A 9B 9C 9D
        .byte   $9E,$9F,$FF,$FF,$FF,$FF,$FF,$FF ; D187 9E 9F FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$76,$77,$23,$40 ; D18F FF FF FF FF 76 77 23 40
        .byte   $20,$76,$77,$86,$87,$86,$87,$86 ; D197 20 76 77 86 87 86 87 86
        .byte   $87,$86,$87,$86,$87,$86,$87,$86 ; D19F 87 86 87 86 87 86 87 86
        .byte   $87,$86,$87,$86,$87,$86,$87,$86 ; D1A7 87 86 87 86 87 86 87 86
        .byte   $87,$86,$87,$86,$87,$86,$87,$76 ; D1AF 87 86 87 86 87 86 87 76
        .byte   $77,$23,$60,$20,$76,$77,$96,$97 ; D1B7 77 23 60 20 76 77 96 97
        .byte   $96,$97,$96,$97,$96,$97,$96,$97 ; D1BF 96 97 96 97 96 97 96 97
        .byte   $96,$97,$96,$97,$96,$97,$96,$97 ; D1C7 96 97 96 97 96 97 96 97
        .byte   $96,$97,$96,$97,$96,$97,$96,$97 ; D1CF 96 97 96 97 96 97 96 97
        .byte   $96,$97,$76,$77,$23,$80,$20,$76 ; D1D7 96 97 76 77 23 80 20 76
        .byte   $77,$76,$77,$76,$77,$76,$77,$76 ; D1DF 77 76 77 76 77 76 77 76
        .byte   $77,$76,$77,$76,$77,$76,$77,$76 ; D1E7 77 76 77 76 77 76 77 76
        .byte   $77,$76,$77,$76,$77,$76,$77,$76 ; D1EF 77 76 77 76 77 76 77 76
        .byte   $77,$76,$77,$76,$77,$76,$77,$23 ; D1F7 77 76 77 76 77 76 77 23
        .byte   $A0,$20,$76,$77,$76,$77,$76,$77 ; D1FF A0 20 76 77 76 77 76 77
        .byte   $76,$77,$76,$77,$76,$77,$76,$77 ; D207 76 77 76 77 76 77 76 77
        .byte   $76,$77,$76,$77,$76,$77,$76,$77 ; D20F 76 77 76 77 76 77 76 77
        .byte   $76,$77,$76,$77,$76,$77,$76,$77 ; D217 76 77 76 77 76 77 76 77
        .byte   $76,$77,$23,$C0,$20,$AA,$FA,$FA ; D21F 76 77 23 C0 20 AA FA FA
        .byte   $FA,$FA,$FA,$AA,$AA,$AA,$77,$55 ; D227 FA FA FA AA AA AA 77 55
        .byte   $55,$55,$FF,$00,$88,$22,$F7,$F5 ; D22F 55 55 FF 00 88 22 F7 F5
        .byte   $F5,$F5,$FF,$00,$88,$22,$00,$00 ; D237 F5 F5 FF 00 88 22 00 00
        .byte   $6A,$5A,$0A,$00,$88,$23,$E0,$20 ; D23F 6A 5A 0A 00 88 23 E0 20
        .byte   $22,$00,$00,$F6,$F4,$00,$00,$88 ; D247 22 00 00 F6 F4 00 00 88
        .byte   $22,$00,$00,$FF,$F3,$00,$00,$88 ; D24F 22 00 00 FF F3 00 00 88
        .byte   $22,$00,$00,$00,$00,$00,$00,$88 ; D257 22 00 00 00 00 00 00 88
        .byte   $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A ; D25F 0A 0A 0A 0A 0A 0A 0A 0A
        .byte   $FF                             ; D267 FF
type_a_ending_nametable:
        .byte   $20,$00,$20,$76,$77,$76,$77,$76 ; D268 20 00 20 76 77 76 77 76
        .byte   $77,$76,$77,$76,$77,$76,$77,$76 ; D270 77 76 77 76 77 76 77 76
        .byte   $77,$76,$77,$76,$77,$76,$77,$76 ; D278 77 76 77 76 77 76 77 76
        .byte   $77,$76,$77,$76,$77,$76,$77,$76 ; D280 77 76 77 76 77 76 77 76
        .byte   $77,$76,$77,$20,$20,$20,$76,$77 ; D288 77 76 77 20 20 20 76 77
        .byte   $76,$77,$76,$77,$76,$77,$76,$77 ; D290 76 77 76 77 76 77 76 77
        .byte   $76,$77,$76,$77,$76,$77,$76,$77 ; D298 76 77 76 77 76 77 76 77
        .byte   $76,$77,$76,$77,$76,$77,$76,$77 ; D2A0 76 77 76 77 76 77 76 77
        .byte   $76,$77,$76,$77,$76,$77,$20,$40 ; D2A8 76 77 76 77 76 77 20 40
        .byte   $20,$76,$77,$FF,$FF,$FF,$FF,$FF ; D2B0 20 76 77 FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D2B8 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D2C0 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$76 ; D2C8 FF FF FF FF FF FF FF 76
        .byte   $77,$20,$60,$20,$76,$77,$FF,$FF ; D2D0 77 20 60 20 76 77 FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D2D8 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D2E0 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D2E8 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$76,$77,$20,$80,$20,$76 ; D2F0 FF FF 76 77 20 80 20 76
        .byte   $77,$FF,$FF,$FF,$FF,$FF,$0A,$0B ; D2F8 77 FF FF FF FF FF 0A 0B
        .byte   $0C,$0D,$0E,$FF,$FF,$00,$00,$00 ; D300 0C 0D 0E FF FF 00 00 00
        .byte   $00,$00,$00,$FF,$FF,$FF,$FF,$FF ; D308 00 00 00 FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$76,$77,$20 ; D310 FF FF FF FF FF 76 77 20
        .byte   $A0,$20,$76,$77,$FF,$FF,$FF,$FF ; D318 A0 20 76 77 FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D320 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D328 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D330 FF FF FF FF FF FF FF FF
        .byte   $76,$77,$20,$C0,$20,$76,$77,$FF ; D338 76 77 20 C0 20 76 77 FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D340 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D348 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D350 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$76,$77,$20,$E0,$20 ; D358 FF FF FF 76 77 20 E0 20
        .byte   $76,$77,$FF,$FF,$FF,$FF,$FF,$FF ; D360 76 77 FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D368 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D370 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$76,$77 ; D378 FF FF FF FF FF FF 76 77
        .byte   $21,$00,$20,$76,$77,$FF,$FF,$FF ; D380 21 00 20 76 77 FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D388 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D390 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D398 FF FF FF FF FF FF FF FF
        .byte   $FF,$76,$77,$21,$20,$20,$76,$77 ; D3A0 FF 76 77 21 20 20 76 77
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D3A8 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D3B0 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D3B8 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$76,$77,$21,$40 ; D3C0 FF FF FF FF 76 77 21 40
        .byte   $20,$76,$77,$FF,$FF,$FF,$FF,$FF ; D3C8 20 76 77 FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D3D0 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D3D8 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$76 ; D3E0 FF FF FF FF FF FF FF 76
        .byte   $77,$21,$60,$20,$76,$77,$FF,$FF ; D3E8 77 21 60 20 76 77 FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D3F0 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D3F8 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D400 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$76,$77,$21,$80,$20,$76 ; D408 FF FF 76 77 21 80 20 76
        .byte   $77,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D410 77 FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D418 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D420 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$76,$77,$21 ; D428 FF FF FF FF FF 76 77 21
        .byte   $A0,$20,$76,$77,$FF,$FF,$FF,$FF ; D430 A0 20 76 77 FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D438 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D440 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D448 FF FF FF FF FF FF FF FF
        .byte   $76,$77,$21,$C0,$20,$76,$77,$FF ; D450 76 77 21 C0 20 76 77 FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D458 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$60,$61,$62 ; D460 FF FF FF FF FF 60 61 62
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D468 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$76,$77,$21,$E0,$20 ; D470 FF FF FF 76 77 21 E0 20
        .byte   $76,$77,$FF,$FF,$FF,$FF,$FF,$FF ; D478 76 77 FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D480 FF FF FF FF FF FF FF FF
        .byte   $70,$71,$72,$FF,$FF,$FF,$FF,$FF ; D488 70 71 72 FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$76,$77 ; D490 FF FF FF FF FF FF 76 77
        .byte   $22,$00,$20,$76,$77,$FF,$FF,$FF ; D498 22 00 20 76 77 FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D4A0 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D4A8 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D4B0 FF FF FF FF FF FF FF FF
        .byte   $FF,$76,$77,$22,$20,$20,$76,$77 ; D4B8 FF 76 77 22 20 20 76 77
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D4C0 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D4C8 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D4D0 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$76,$77,$22,$40 ; D4D8 FF FF FF FF 76 77 22 40
        .byte   $20,$76,$77,$FF,$FF,$80,$82,$FF ; D4E0 20 76 77 FF FF 80 82 FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D4E8 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D4F0 FF FF FF FF FF FF FF FF
        .byte   $FF,$38,$FF,$FF,$FF,$FF,$FF,$76 ; D4F8 FF 38 FF FF FF FF FF 76
        .byte   $77,$22,$60,$20,$76,$77,$FF,$FF ; D500 77 22 60 20 76 77 FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D508 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D510 FF FF FF FF FF FF FF FF
        .byte   $FF,$39,$FF,$3B,$3C,$FF,$3E,$FF ; D518 FF 39 FF 3B 3C FF 3E FF
        .byte   $FF,$FF,$76,$77,$22,$80,$20,$76 ; D520 FF FF 76 77 22 80 20 76
        .byte   $77,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D528 77 FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D530 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$48,$49,$4A,$4B,$4C ; D538 FF FF FF 48 49 4A 4B 4C
        .byte   $4D,$4E,$4F,$FF,$FF,$76,$77,$22 ; D540 4D 4E 4F FF FF 76 77 22
        .byte   $A0,$20,$76,$77,$FF,$FF,$FF,$FF ; D548 A0 20 76 77 FF FF FF FF
        .byte   $FF,$AE,$AE,$FF,$FF,$FF,$FF,$FF ; D550 FF AE AE FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$58,$59 ; D558 FF FF FF FF FF FF 58 59
        .byte   $5A,$5B,$5C,$5D,$5E,$5F,$FF,$FF ; D560 5A 5B 5C 5D 5E 5F FF FF
        .byte   $76,$77,$22,$C0,$20,$76,$77,$FF ; D568 76 77 22 C0 20 76 77 FF
        .byte   $FF,$FF,$FF,$CF,$DE,$BE,$EF,$FF ; D570 FF FF FF CF DE BE EF FF
        .byte   $FF,$AF,$AF,$FF,$FF,$FF,$FF,$FF ; D578 FF AF AF FF FF FF FF FF
        .byte   $FF,$68,$69,$6A,$6B,$6C,$6D,$6E ; D580 FF 68 69 6A 6B 6C 6D 6E
        .byte   $6F,$FF,$FF,$76,$77,$22,$E0,$20 ; D588 6F FF FF 76 77 22 E0 20
        .byte   $76,$77,$CD,$CD,$CD,$CD,$CD,$BE ; D590 76 77 CD CD CD CD CD BE
        .byte   $CE,$FF,$FF,$FF,$DF,$DF,$FF,$FF ; D598 CE FF FF FF DF DF FF FF
        .byte   $FF,$FF,$FF,$FF,$78,$79,$7A,$7B ; D5A0 FF FF FF FF 78 79 7A 7B
        .byte   $7C,$7D,$7E,$7F,$FF,$FF,$76,$77 ; D5A8 7C 7D 7E 7F FF FF 76 77
        .byte   $23,$00,$20,$76,$77,$FF,$DD,$CC ; D5B0 23 00 20 76 77 FF DD CC
        .byte   $CD,$CD,$CE,$DE,$FF,$FF,$FF,$DF ; D5B8 CD CD CE DE FF FF FF DF
        .byte   $DF,$FF,$FF,$FF,$FF,$FF,$FF,$88 ; D5C0 DF FF FF FF FF FF FF 88
        .byte   $89,$8A,$8B,$8C,$8D,$8E,$8F,$FF ; D5C8 89 8A 8B 8C 8D 8E 8F FF
        .byte   $FF,$76,$77,$23,$20,$20,$76,$77 ; D5D0 FF 76 77 23 20 20 76 77
        .byte   $CD,$CD,$DC,$DD,$EC,$ED,$ED,$ED ; D5D8 CD CD DC DD EC ED ED ED
        .byte   $ED,$ED,$ED,$ED,$EE,$FF,$FF,$FF ; D5E0 ED ED ED ED EE FF FF FF
        .byte   $FF,$FF,$98,$99,$9A,$9B,$9C,$9D ; D5E8 FF FF 98 99 9A 9B 9C 9D
        .byte   $9E,$9F,$FF,$FF,$76,$77,$23,$40 ; D5F0 9E 9F FF FF 76 77 23 40
        .byte   $20,$76,$77,$86,$87,$86,$87,$86 ; D5F8 20 76 77 86 87 86 87 86
        .byte   $87,$86,$87,$86,$87,$86,$87,$86 ; D600 87 86 87 86 87 86 87 86
        .byte   $87,$86,$87,$86,$87,$86,$87,$86 ; D608 87 86 87 86 87 86 87 86
        .byte   $87,$86,$87,$86,$87,$86,$87,$76 ; D610 87 86 87 86 87 86 87 76
        .byte   $77,$23,$60,$20,$76,$77,$96,$97 ; D618 77 23 60 20 76 77 96 97
        .byte   $96,$97,$96,$97,$96,$97,$96,$97 ; D620 96 97 96 97 96 97 96 97
        .byte   $96,$97,$96,$97,$96,$97,$96,$97 ; D628 96 97 96 97 96 97 96 97
        .byte   $96,$97,$96,$97,$96,$97,$96,$97 ; D630 96 97 96 97 96 97 96 97
        .byte   $96,$97,$76,$77,$23,$80,$20,$76 ; D638 96 97 76 77 23 80 20 76
        .byte   $77,$76,$77,$76,$77,$76,$77,$76 ; D640 77 76 77 76 77 76 77 76
        .byte   $77,$76,$77,$76,$77,$76,$77,$76 ; D648 77 76 77 76 77 76 77 76
        .byte   $77,$76,$77,$76,$77,$76,$77,$76 ; D650 77 76 77 76 77 76 77 76
        .byte   $77,$76,$77,$76,$77,$76,$77,$23 ; D658 77 76 77 76 77 76 77 23
        .byte   $A0,$20,$76,$77,$76,$77,$76,$77 ; D660 A0 20 76 77 76 77 76 77
        .byte   $76,$77,$76,$77,$76,$77,$76,$77 ; D668 76 77 76 77 76 77 76 77
        .byte   $76,$77,$76,$77,$76,$77,$76,$77 ; D670 76 77 76 77 76 77 76 77
        .byte   $76,$77,$76,$77,$76,$77,$76,$77 ; D678 76 77 76 77 76 77 76 77
        .byte   $76,$77,$23,$C0,$20,$AA,$5A,$5A ; D680 76 77 23 C0 20 AA 5A 5A
        .byte   $5A,$5A,$5A,$AA,$AA,$AA,$55,$55 ; D688 5A 5A 5A AA AA AA 55 55
        .byte   $55,$55,$55,$00,$88,$22,$55,$11 ; D690 55 55 55 00 88 22 55 11
        .byte   $55,$55,$55,$00,$88,$22,$11,$00 ; D698 55 55 55 00 88 22 11 00
        .byte   $0A,$52,$00,$00,$88,$23,$E0,$20 ; D6A0 0A 52 00 00 88 23 E0 20
        .byte   $22,$90,$20,$00,$00,$00,$30,$88 ; D6A8 22 90 20 00 00 00 30 88
        .byte   $AA,$AA,$6A,$AA,$00,$FF,$F3,$88 ; D6B0 AA AA 6A AA 00 FF F3 88
        .byte   $2A,$0A,$0A,$0A,$00,$00,$00,$88 ; D6B8 2A 0A 0A 0A 00 00 00 88
        .byte   $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A ; D6C0 0A 0A 0A 0A 0A 0A 0A 0A
        .byte   $FF                             ; D6C8 FF

; End of "PRG_chunk2" segment
; ----------------------------------------------------------------------------
.code


.segment        "unreferenced_data1": absolute

unreferenced_data1:
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D6C9 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D6D1 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$00 ; D6D9 FF FF FF FF FF FF FF 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D6E1 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D6E9 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D6F1 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$FF ; D6F9 00 00 00 00 00 00 00 FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D701 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D709 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D711 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$00 ; D719 FF FF FF FF FF FF FF 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D721 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D729 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D731 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$FF ; D739 00 00 00 00 00 00 00 FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D741 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D749 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D751 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$00 ; D759 FF FF FF FF FF FF FF 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D761 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D769 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D771 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$FF ; D779 00 00 00 00 00 00 00 FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D781 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D789 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D791 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$00 ; D799 FF FF FF FF FF FF FF 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D7A1 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D7A9 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D7B1 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$FF ; D7B9 00 00 00 00 00 00 00 FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D7C1 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D7C9 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D7D1 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$00 ; D7D9 FF FF FF FF FF FF FF 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D7E1 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D7E9 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D7F1 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$FF ; D7F9 00 00 00 00 00 00 00 FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D801 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D809 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D811 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$00 ; D819 FF FF FF FF FF FF FF 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D821 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D829 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D831 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$02,$00,$00,$00,$FF ; D839 00 00 00 02 00 00 00 FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D841 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D849 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D851 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$00 ; D859 FF FF FF FF FF FF FF 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D861 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D869 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D871 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$FF ; D879 00 00 00 00 00 00 00 FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D881 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D889 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D891 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$00 ; D899 FF FF FF FF FF FF FF 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D8A1 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D8A9 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D8B1 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$FF ; D8B9 00 00 00 00 00 00 00 FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D8C1 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D8C9 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D8D1 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$00 ; D8D9 FF FF FF FF FF FF FF 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D8E1 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D8E9 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D8F1 00 00 00 00 00 00 00 00
        .byte   $10,$00,$00,$00,$00,$00,$00,$FF ; D8F9 10 00 00 00 00 00 00 FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D901 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D909 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D911 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$00 ; D919 FF FF FF FF FF FF FF 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D921 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D929 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D931 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$FF ; D939 00 00 00 00 00 00 00 FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D941 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D949 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D951 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$00 ; D959 FF FF FF FF FF FF FF 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D961 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D969 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D971 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$FF ; D979 00 00 00 00 00 00 00 FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D981 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D989 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D991 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$00 ; D999 FF FF FF FF FF FF FF 00
        .byte   $00,$00,$00,$80,$00,$00,$00,$00 ; D9A1 00 00 00 80 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D9A9 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D9B1 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$FF ; D9B9 00 00 00 00 00 00 00 FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D9C1 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D9C9 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; D9D1 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$00 ; D9D9 FF FF FF FF FF FF FF 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D9E1 00 00 00 00 00 00 00 00
        .byte   $10,$00,$00,$00,$00,$00,$00,$00 ; D9E9 10 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; D9F1 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$FF ; D9F9 00 00 00 00 00 00 00 FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DA01 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DA09 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DA11 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$00 ; DA19 FF FF FF FF FF FF FF 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DA21 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$08,$00,$00,$00,$00 ; DA29 00 00 00 08 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DA31 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$FF ; DA39 00 00 00 00 00 00 00 FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DA41 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DA49 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DA51 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$00 ; DA59 FF FF FF FF FF FF FF 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DA61 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DA69 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DA71 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$FF ; DA79 00 00 00 00 00 00 00 FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DA81 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DA89 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DA91 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$00 ; DA99 FF FF FF FF FF FF FF 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DAA1 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DAA9 00 00 00 00 00 00 00 00
        .byte   $10,$00,$00,$00,$00,$00,$00,$00 ; DAB1 10 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$04,$00,$00,$FF ; DAB9 00 00 00 00 04 00 00 FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DAC1 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DAC9 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DAD1 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$00 ; DAD9 FF FF FF FF FF FF FF 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DAE1 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DAE9 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DAF1 00 00 00 00 00 00 00 00
        .byte   $00,$40,$00,$00,$00,$00,$00,$FF ; DAF9 00 40 00 00 00 00 00 FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DB01 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DB09 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DB11 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$00 ; DB19 FF FF FF FF FF FF FF 00
        .byte   $00,$10,$00,$00,$00,$00,$00,$00 ; DB21 00 10 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DB29 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DB31 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$04,$00,$FF ; DB39 00 00 00 00 00 04 00 FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DB41 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DB49 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DB51 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$00 ; DB59 FF FF FF FF FF FF FF 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DB61 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DB69 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DB71 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$FF ; DB79 00 00 00 00 00 00 00 FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DB81 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DB89 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DB91 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$00 ; DB99 FF FF FF FF FF FF FF 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DBA1 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DBA9 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DBB1 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$FF ; DBB9 00 00 00 00 00 00 00 FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DBC1 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DBC9 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DBD1 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$00 ; DBD9 FF FF FF FF FF FF FF 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DBE1 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DBE9 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DBF1 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$C0,$60,$FF ; DBF9 00 00 00 00 00 C0 60 FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DC01 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$F7,$FF,$FF,$FF,$FF ; DC09 FF FF FF F7 FF FF FF FF
        .byte   $FF,$FF,$FF,$FB,$FF,$FF,$FF,$FF ; DC11 FF FF FF FB FF FF FF FF
        .byte   $FF,$FF,$7F,$FF,$DF,$FF,$FF,$00 ; DC19 FF FF 7F FF DF FF FF 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DC21 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DC29 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DC31 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$DF ; DC39 00 00 00 00 00 00 00 DF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DC41 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DC49 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DC51 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FB,$FF,$FF,$00 ; DC59 FF FF FF FF FB FF FF 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DC61 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DC69 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DC71 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$FF ; DC79 00 00 00 00 00 00 00 FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DC81 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DC89 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DC91 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FE,$FF,$00 ; DC99 FF FF FF FF FF FE FF 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DCA1 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DCA9 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DCB1 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$FF ; DCB9 00 00 00 00 00 00 00 FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DCC1 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DCC9 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; DCD1 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$00 ; DCD9 FF FF FF FF FF FF FF 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DCE1 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DCE9 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; DCF1 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00         ; DCF9 00 00 00 00 00 00
        .byte   $00                             ; DCFF 00

; End of "unreferenced_data1" segment
; ----------------------------------------------------------------------------
.code


.segment        "PRG_chunk3": absolute

demoButtonsTable:
        .byte   $00,$31,$40,$06,$00,$04,$40,$07 ; DD00 00 31 40 06 00 04 40 07
        .byte   $00,$5D,$04,$2E,$00,$05,$01,$08 ; DD08 00 5D 04 2E 00 05 01 08
        .byte   $81,$05,$80,$00,$00,$04,$80,$04 ; DD10 81 05 80 00 00 04 80 04
        .byte   $81,$01,$01,$1C,$00,$00,$04,$2D ; DD18 81 01 01 1C 00 00 04 2D
        .byte   $00,$06,$02,$02,$42,$06,$02,$04 ; DD20 00 06 02 02 42 06 02 04
        .byte   $42,$04,$00,$1B,$02,$00,$00,$18 ; DD28 42 04 00 1B 02 00 00 18
        .byte   $02,$0B,$00,$05,$04,$2E,$00,$01 ; DD30 02 0B 00 05 04 2E 00 01
        .byte   $02,$04,$42,$09,$02,$0A,$00,$11 ; DD38 02 04 42 09 02 0A 00 11
        .byte   $04,$2A,$00,$48,$02,$05,$82,$07 ; DD40 04 2A 00 48 02 05 82 07
        .byte   $02,$18,$00,$04,$04,$2A,$00,$03 ; DD48 02 18 00 04 04 2A 00 03
        .byte   $01,$06,$81,$0C,$01,$11,$00,$01 ; DD50 01 06 81 0C 01 11 00 01
        .byte   $04,$2D,$00,$08,$01,$0A,$00,$04 ; DD58 04 2D 00 08 01 0A 00 04
        .byte   $01,$01,$00,$3D,$04,$1A,$00,$01 ; DD60 01 01 00 3D 04 1A 00 01
        .byte   $02,$05,$00,$08,$04,$12,$00,$14 ; DD68 02 05 00 08 04 12 00 14
        .byte   $02,$03,$42,$0B,$02,$03,$00,$10 ; DD70 02 03 42 0B 02 03 00 10
        .byte   $04,$2D,$00,$1C,$02,$12,$82,$16 ; DD78 04 2D 00 1C 02 12 82 16
        .byte   $02,$02,$00,$06,$04,$28,$00,$07 ; DD80 02 02 00 06 04 28 00 07
        .byte   $01,$0F,$00,$08,$01,$05,$00,$09 ; DD88 01 0F 00 08 01 05 00 09
        .byte   $04,$2F,$00,$2F,$04,$07,$00,$0A ; DD90 04 2F 00 2F 04 07 00 0A
        .byte   $04,$26,$00,$04,$02,$03,$82,$0B ; DD98 04 26 00 04 02 03 82 0B
        .byte   $02,$03,$00,$10,$02,$04,$00,$05 ; DDA0 02 03 00 10 02 04 00 05
        .byte   $04,$2F,$00,$5F,$04,$16,$00,$17 ; DDA8 04 2F 00 5F 04 16 00 17
        .byte   $04,$18,$00,$02,$02,$0A,$82,$18 ; DDB0 04 18 00 02 02 0A 82 18
        .byte   $02,$02,$00,$03,$04,$2A,$00,$02 ; DDB8 02 02 00 03 04 2A 00 02
        .byte   $01,$07,$81,$02,$01,$02,$81,$02 ; DDC0 01 07 81 02 01 02 81 02
        .byte   $01,$05,$00,$36,$40,$07,$00,$06 ; DDC8 01 05 00 36 40 07 00 06
        .byte   $04,$30,$00,$03,$02,$0D,$00,$04 ; DDD0 04 30 00 03 02 0D 00 04
        .byte   $01,$0D,$81,$05,$01,$05,$00,$11 ; DDD8 01 0D 81 05 01 05 00 11
        .byte   $04,$2A,$00,$04,$02,$03,$42,$0B ; DDE0 04 2A 00 04 02 03 42 0B
        .byte   $02,$07,$00,$11,$04,$2F,$00,$21 ; DDE8 02 07 00 11 04 2F 00 21
        .byte   $04,$26,$00,$1A,$02,$04,$42,$12 ; DDF0 04 26 00 1A 02 04 42 12
        .byte   $02,$12,$00,$10,$04,$24,$00,$07 ; DDF8 02 12 00 10 04 24 00 07
        .byte   $01,$06,$81,$05,$01,$02,$00,$14 ; DE00 01 06 81 05 01 02 00 14
        .byte   $01,$0A,$00,$1C,$01,$05,$00,$04 ; DE08 01 0A 00 1C 01 05 00 04
        .byte   $04,$26,$00,$05,$02,$05,$00,$16 ; DE10 04 26 00 05 02 05 00 16
        .byte   $04,$27,$00,$69,$81,$03,$01,$04 ; DE18 04 27 00 69 81 03 01 04
        .byte   $00,$16,$04,$20,$00,$03,$02,$14 ; DE20 00 16 04 20 00 03 02 14
        .byte   $00,$0D,$02,$05,$00,$09,$04,$0F ; DE28 00 0D 02 05 00 09 04 0F
        .byte   $00,$09,$04,$19,$00,$1B,$02,$05 ; DE30 00 09 04 19 00 1B 02 05
        .byte   $00,$31,$04,$1E,$00,$43,$01,$02 ; DE38 00 31 04 1E 00 43 01 02
        .byte   $81,$08,$00,$09,$01,$05,$00,$11 ; DE40 81 08 00 09 01 05 00 11
        .byte   $04,$24,$00,$05,$02,$03,$82,$0E ; DE48 04 24 00 05 02 03 82 0E
        .byte   $02,$06,$00,$0B,$02,$04,$00,$1E ; DE50 02 06 00 0B 02 04 00 1E
        .byte   $04,$21,$00,$1D,$02,$01,$42,$11 ; DE58 04 21 00 1D 02 01 42 11
        .byte   $02,$1A,$00,$13,$01,$11,$81,$0C ; DE60 02 1A 00 13 01 11 81 0C
        .byte   $01,$14,$80,$06,$00,$09,$01,$04 ; DE68 01 14 80 06 00 09 01 04
        .byte   $00,$09,$04,$20,$00,$01,$01,$05 ; DE70 00 09 04 20 00 01 01 05
        .byte   $41,$1D,$01,$04,$00,$01,$04,$31 ; DE78 41 1D 01 04 00 01 04 31
        .byte   $00,$1C,$02,$2A,$00,$16,$04,$28 ; DE80 00 1C 02 2A 00 16 04 28
        .byte   $00,$18,$02,$09,$00,$4B,$02,$0B ; DE88 00 18 02 09 00 4B 02 0B
        .byte   $42,$0B,$02,$0C,$00,$07,$04,$1F ; DE90 42 0B 02 0C 00 07 04 1F
        .byte   $00,$0B,$02,$08,$00,$04,$02,$07 ; DE98 00 0B 02 08 00 04 02 07
        .byte   $00,$17,$04,$26,$00,$05,$01,$02 ; DEA0 00 17 04 26 00 05 01 02
        .byte   $81,$03,$80,$00,$00,$12,$02,$03 ; DEA8 81 03 80 00 00 12 02 03
        .byte   $00,$08,$04,$2A,$00,$02,$01,$08 ; DEB0 00 08 04 2A 00 02 01 08
        .byte   $41,$12,$01,$14,$00,$00,$04,$30 ; DEB8 41 12 01 14 00 00 04 30
        .byte   $00,$34,$02,$08,$00,$09,$02,$03 ; DEC0 00 34 02 08 00 09 02 03
        .byte   $00,$21,$04,$28,$00,$2A,$04,$2E ; DEC8 00 21 04 28 00 2A 04 2E
        .byte   $00,$06,$01,$13,$81,$07,$01,$13 ; DED0 00 06 01 13 81 07 01 13
        .byte   $00,$02,$04,$2D,$00,$29,$41,$0C ; DED8 00 02 04 2D 00 29 41 0C
        .byte   $01,$00,$00,$21,$04,$2C,$00,$29 ; DEE0 01 00 00 21 04 2C 00 29
        .byte   $01,$07,$41,$16,$01,$0E,$00,$09 ; DEE8 01 07 41 16 01 0E 00 09
        .byte   $04,$2B,$00,$0D,$01,$05,$81,$05 ; DEF0 04 2B 00 0D 01 05 81 05
        .byte   $01,$06,$00,$0B,$01,$05,$00,$1D ; DEF8 01 06 00 0B 01 05 00 1D
; unknown size
demoTetriminoTypeTable:
        .byte   $00,$14,$8A,$45,$22,$11,$88,$44 ; DF00 00 14 8A 45 22 11 88 44
        .byte   $22,$91,$48,$A4,$52,$29,$14,$0A ; DF08 22 91 48 A4 52 29 14 0A
        .byte   $85,$C2,$E1,$70,$38,$9C,$4E,$A7 ; DF10 85 C2 E1 70 38 9C 4E A7
        .byte   $53,$A9,$D4,$6A,$B5,$5A,$AD,$D6 ; DF18 53 A9 D4 6A B5 5A AD D6
        .byte   $6B,$35,$1A,$8D,$C6,$E3,$71,$38 ; DF20 6B 35 1A 8D C6 E3 71 38
        .byte   $9C,$CE,$E7,$73,$B9,$DC,$EE,$F7 ; DF28 9C CE E7 73 B9 DC EE F7
        .byte   $FB,$FD,$FE,$7F,$3F,$9F,$CF,$67 ; DF30 FB FD FE 7F 3F 9F CF 67
        .byte   $33,$19,$0C,$86,$43,$21,$90,$C8 ; DF38 33 19 0C 86 43 21 90 C8
        .byte   $E4,$F2,$F9,$7C,$BE,$5F,$AF,$D7 ; DF40 E4 F2 F9 7C BE 5F AF D7
        .byte   $EB,$F5,$FA,$FD,$7E,$3F,$1F,$0F ; DF48 EB F5 FA FD 7E 3F 1F 0F
        .byte   $07,$03,$81,$C0,$60,$B0,$D8,$EC ; DF50 07 03 81 C0 60 B0 D8 EC
        .byte   $F6,$7B,$3D,$1E,$8F,$C7,$E3,$F1 ; DF58 F6 7B 3D 1E 8F C7 E3 F1
        .byte   $78,$BC,$DE,$EF,$77,$3B,$1D,$8E ; DF60 78 BC DE EF 77 3B 1D 8E
        .byte   $C7,$E3,$F1,$F8,$FC,$FE,$7F,$BF ; DF68 C7 E3 F1 F8 FC FE 7F BF
        .byte   $5F,$2F,$17,$8B,$C5,$62,$31,$98 ; DF70 5F 2F 17 8B C5 62 31 98
        .byte   $CC,$E6,$73,$39,$9C,$4E,$27,$93 ; DF78 CC E6 73 39 9C 4E 27 93
        .byte   $C9,$64,$B2,$59,$2C,$16,$0B,$05 ; DF80 C9 64 B2 59 2C 16 0B 05
        .byte   $82,$C1,$60,$B0,$58,$2C,$96,$4B ; DF88 82 C1 60 B0 58 2C 96 4B
        .byte   $A5,$D2,$E9,$74,$3A,$9D,$4E,$27 ; DF90 A5 D2 E9 74 3A 9D 4E 27
        .byte   $13,$89,$C4,$62,$B1,$D8,$6C,$B6 ; DF98 13 89 C4 62 B1 D8 6C B6
        .byte   $5B,$2D,$16,$8B,$45,$22,$91,$48 ; DFA0 5B 2D 16 8B 45 22 91 48
        .byte   $A4,$D2,$E9,$F4,$FA,$FD,$FE,$FF ; DFA8 A4 D2 E9 F4 FA FD FE FF
        .byte   $FF,$FF,$7F,$BF,$DF,$6F,$B7,$5B ; DFB0 FF FF 7F BF DF 6F B7 5B
        .byte   $2D,$96,$4B,$25,$92,$49,$A4,$D2 ; DFB8 2D 96 4B 25 92 49 A4 D2
        .byte   $69,$34,$9A,$4D,$26,$13,$89,$44 ; DFC0 69 34 9A 4D 26 13 89 44
        .byte   $A2,$D1,$68,$B4,$5A,$2D,$96,$CB ; DFC8 A2 D1 68 B4 5A 2D 96 CB
        .byte   $E5,$F2,$F9,$7C,$3E,$1F,$8F,$47 ; DFD0 E5 F2 F9 7C 3E 1F 8F 47
        .byte   $23,$91,$C8,$64,$32,$19,$8C,$C6 ; DFD8 23 91 C8 64 32 19 8C C6
        .byte   $63,$31,$18,$0C,$06,$03,$81,$40 ; DFE0 63 31 18 0C 06 03 81 40
        .byte   $A0,$D0,$68,$34,$1A,$0D,$86,$C3 ; DFE8 A0 D0 68 34 1A 0D 86 C3
        .byte   $78,$BC,$DE,$EF,$77,$3B,$1D,$8E ; DFF0 78 BC DE EF 77 3B 1D 8E
        .byte   $C7,$E3,$F1,$F8,$FC,$FE,$7F     ; DFF8 C7 E3 F1 F8 FC FE 7F
MMC1_CHR1:
        .byte   $BF                             ; DFFF BF
; ----------------------------------------------------------------------------
; canon is updateAudio
updateAudio_jmp:
        jmp     updateAudio                     ; E000 4C 16 E2

; ----------------------------------------------------------------------------
; canon is updateAudio
updateAudio2:
        jmp     soundEffectSlot2_makesNoSound   ; E003 4C 44 E2

; ----------------------------------------------------------------------------
LE006:  jmp     LE1D8                           ; E006 4C D8 E1

; ----------------------------------------------------------------------------
; Referenced via updateSoundEffectSlotShared
soundEffectSlot0Init_table:
        .addr   soundEffectSlot0_makesNoSound   ; E009 DD E2
        .addr   soundEffectSlot0_gameOverCurtainInit; E00B F8 E2
        .addr   soundEffectSlot0_endingRocketInit; E00D CC E2
soundEffectSlot0Playing_table:
        .addr   advanceSoundEffectSlot0WithoutUpdate; E00F E4 E2
        .addr   updateSoundEffectSlot0_apu      ; E011 FF E2
        .addr   advanceSoundEffectSlot0WithoutUpdate; E013 E4 E2
soundEffectSlot1Init_table:
        .addr   soundEffectSlot1_menuOptionSelectInit; E015 CA E3
        .addr   soundEffectSlot1_menuScreenSelectInit; E017 73 E4
        .addr   soundEffectSlot1_shiftTetriminoInit; E019 90 E3
        .addr   soundEffectSlot1_tetrisAchievedInit; E01B 03 E4
        .addr   soundEffectSlot1_rotateTetriminoInit; E01D D1 E3
        .addr   soundEffectSlot1_levelUpInit    ; E01F EC E4
        .addr   soundEffectSlot1_lockTetriminoInit; E021 84 E3
        .addr   soundEffectSlot1_chirpChirpInit ; E023 7F E3
        .addr   soundEffectSlot1_lineClearingInit; E025 2E E4
        .addr   soundEffectSlot1_lineCompletedInit; E027 1A E4
soundEffectSlot1Playing_table:
        .addr   soundEffectSlot1_menuOptionSelectPlaying; E029 B3 E3
        .addr   soundEffectSlot1_menuScreenSelectPlaying; E02B 81 E4
        .addr   soundEffectSlot1Playing_advance ; E02D 9C E3
        .addr   soundEffectSlot1_tetrisAchievedPlaying; E02F 0E E4
        .addr   soundEffectSlot1_rotateTetriminoPlaying; E031 DD E3
        .addr   soundEffectSlot1_levelUpPlaying ; E033 D1 E4
        .addr   soundEffectSlot1Playing_advance ; E035 9C E3
        .addr   soundEffectSlot1_chirpChirpPlaying; E037 4F E3
        .addr   soundEffectSlot1_lineClearingPlaying; E039 3B E4
        .addr   soundEffectSlot1_lineCompletedPlaying; E03B 25 E4
soundEffectSlot3Init_table:
        .addr   soundEffectSlot3_fallingAlien   ; E03D 6E E5
        .addr   soundEffectSlot3_donk           ; E03F 34 E5
soundEffectSlot3Playing_table:
        .addr   updateSoundEffectSlot3_apu      ; E041 51 E5
        .addr   soundEffectSlot3Playing_advance ; E043 3B E5
; Referenced by unused slot 4 as well
soundEffectSlot2Init_table:
        .addr   soundEffectSlot2_makesNoSound   ; E045 44 E2
        .addr   soundEffectSlot2_lowBuzz        ; E047 13 E5
        .addr   soundEffectSlot2_mediumBuzz     ; E049 0B E5
; ----------------------------------------------------------------------------
; input y: $E100+y source addr
copyToSq1Channel:
        lda     #$00                            ; E04B A9 00
        beq     copyToApuChannel                ; E04D F0 0A
copyToTriChannel:
        lda     #$08                            ; E04F A9 08
        bne     copyToApuChannel                ; E051 D0 06
copyToNoiseChannel:
        lda     #$0C                            ; E053 A9 0C
        bne     copyToApuChannel                ; E055 D0 02
copyToSq2Channel:
        lda     #$04                            ; E057 A9 04
; input a: $4000+a APU addr; input y: $E100+y source; copies 4 bytes
copyToApuChannel:
        sta     AUDIOTMP1                       ; E059 85 E0
        lda     #$40                            ; E05B A9 40
        sta     AUDIOTMP2                       ; E05D 85 E1
        sty     AUDIOTMP3                       ; E05F 84 E2
        lda     #$E1                            ; E061 A9 E1
        sta     AUDIOTMP4                       ; E063 85 E3
        ldy     #$00                            ; E065 A0 00
@copyByte:
        lda     (AUDIOTMP3),y                   ; E067 B1 E2
        sta     (AUDIOTMP1),y                   ; E069 91 E0
        iny                                     ; E06B C8
        tya                                     ; E06C 98
        cmp     #$04                            ; E06D C9 04
        bne     @copyByte                       ; E06F D0 F6
        rts                                     ; E071 60

; ----------------------------------------------------------------------------
; input a: index-1 into table at $E000+AUDIOTMP1; output AUDIOTMP3/4: address; $EF set to a
computeSoundEffMethod:
        sta     currentAudioSlot                ; E072 85 EF
        pha                                     ; E074 48
        ldy     #$E0                            ; E075 A0 E0
        sty     AUDIOTMP2                       ; E077 84 E1
        ldy     #$00                            ; E079 A0 00
@whileYNot2TimesA:
        dec     currentAudioSlot                ; E07B C6 EF
        beq     @copyAddr                       ; E07D F0 13
        iny                                     ; E07F C8
        iny                                     ; E080 C8
        tya                                     ; E081 98
        cmp     #$22                            ; E082 C9 22
        bne     @whileYNot2TimesA               ; E084 D0 F5
        lda     #$91                            ; E086 A9 91
        sta     AUDIOTMP3                       ; E088 85 E2
        lda     #$E0                            ; E08A A9 E0
        sta     AUDIOTMP4                       ; E08C 85 E3
@ret:   pla                                     ; E08E 68
        sta     currentAudioSlot                ; E08F 85 EF
        rts                                     ; E091 60

; ----------------------------------------------------------------------------
@copyAddr:
        lda     (AUDIOTMP1),y                   ; E092 B1 E0
        sta     AUDIOTMP3                       ; E094 85 E2
        iny                                     ; E096 C8
        lda     (AUDIOTMP1),y                   ; E097 B1 E0
        sta     AUDIOTMP4                       ; E099 85 E3
        jmp     @ret                            ; E09B 4C 8E E0

; ----------------------------------------------------------------------------
unreferenced_soundRng:
        lda     soundRngSeed                    ; E09E A5 EB
        and     #$02                            ; E0A0 29 02
        sta     unreferenced_soundRngTmp        ; E0A2 8D FF 06
        lda     soundRngSeed+1                  ; E0A5 A5 EC
        and     #$02                            ; E0A7 29 02
        eor     unreferenced_soundRngTmp        ; E0A9 4D FF 06
        clc                                     ; E0AC 18
        beq     @insertRandomBit                ; E0AD F0 01
        sec                                     ; E0AF 38
@insertRandomBit:
        ror     soundRngSeed                    ; E0B0 66 EB
        ror     soundRngSeed+1                  ; E0B2 66 EC
        rts                                     ; E0B4 60

; ----------------------------------------------------------------------------
; Z=0 when returned means disabled
advanceAudioSlotFrame:
        ldx     currentSoundEffectSlot          ; E0B5 A6 ED
        inc     soundEffectSlot0FrameCounter,x  ; E0B7 FE DA 06
        lda     soundEffectSlot0FrameCounter,x  ; E0BA BD DA 06
        cmp     soundEffectSlot0FrameCount,x    ; E0BD DD D5 06
        bne     @ret                            ; E0C0 D0 05
        lda     #$00                            ; E0C2 A9 00
        sta     soundEffectSlot0FrameCounter,x  ; E0C4 9D DA 06
@ret:   rts                                     ; E0C7 60

; ----------------------------------------------------------------------------
unreferenced_data3:
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E0C8 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E0D0 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; E0D8 FF FF FF FF FF FF FF FF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E0E0 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E0E8 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E0F0 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E0F8 00 00 00 00 00 00 00 00
        .byte   $03,$7F,$0F,$C0                 ; E100 03 7F 0F C0
; Referenced by initSoundEffectShared
soundEffectSlot0_gameOverCurtainInitData:
        .byte   $1F,$7F,$0F,$C0                 ; E104 1F 7F 0F C0
soundEffectSlot0_endingRocketInitData:
        .byte   $08,$7F,$0E,$C0                 ; E108 08 7F 0E C0
; Referenced at updateAudio_pause
music_pause_sq1_even:
        .byte   $9D,$7F,$7A,$28                 ; E10C 9D 7F 7A 28
; Referenced at updateAudio_pause
music_pause_sq1_odd:
        .byte   $9D,$7F,$40,$28                 ; E110 9D 7F 40 28
soundEffectSlot1_rotateTetriminoInitData:
        .byte   $9E,$7F,$C0,$28                 ; E114 9E 7F C0 28
soundEffectSlot1Playing_rotateTetriminoStage3:
        .byte   $B2,$7F,$C0,$08                 ; E118 B2 7F C0 08
soundEffectSlot1_levelUpInitData:
        .byte   $DE,$7F,$A8,$18                 ; E11C DE 7F A8 18
soundEffectSlot1_lockTetriminoInitData:
        .byte   $9F,$84,$FF,$0B                 ; E120 9F 84 FF 0B
soundEffectSlot1_menuOptionSelectInitData:
        .byte   $DB,$7F,$40,$28                 ; E124 DB 7F 40 28
soundEffectSlot1Playing_menuOptionSelectStage2:
        .byte   $D2,$7F,$40,$28                 ; E128 D2 7F 40 28
soundEffectSlot1_menuScreenSelectInitData:
        .byte   $D9,$7F,$84,$28                 ; E12C D9 7F 84 28
soundEffectSlot1_tetrisAchievedInitData:
        .byte   $9E,$9D,$C0,$08                 ; E130 9E 9D C0 08
soundEffectSlot1_lineCompletedInitData:
        .byte   $9C,$9A,$A0,$09                 ; E134 9C 9A A0 09
soundEffectSlot1_lineClearingInitData:
        .byte   $9E,$7F,$69,$08                 ; E138 9E 7F 69 08
soundEffectSlot1_chirpChirpInitData:
        .byte   $96,$7F,$36,$20                 ; E13C 96 7F 36 20
soundEffectSlot1Playing_chirpChirpStage2:
        .byte   $82,$7F,$30,$F8                 ; E140 82 7F 30 F8
soundEffectSlot1_shiftTetriminoInitData:
        .byte   $98,$7F,$80,$38                 ; E144 98 7F 80 38
soundEffectSlot3_unknown1InitData:
        .byte   $30,$7F,$70,$08                 ; E148 30 7F 70 08
soundEffectSlot3_unknown2InitData:
        .byte   $03,$7F,$3D,$18                 ; E14C 03 7F 3D 18
soundEffectSlot1_chirpChirpSq1Vol_table:
        .byte   $14,$93,$94,$D3                 ; E150 14 93 94 D3
; See getSoundEffectNoiseNibble
noiselo_table:
        .byte   $7A,$DE,$FF,$EF,$FD,$DF,$FE,$EF ; E154 7A DE FF EF FD DF FE EF
        .byte   $EF,$FD,$EF,$FE,$DF,$FF,$EE,$EE ; E15C EF FD EF FE DF FF EE EE
        .byte   $FF,$EF,$FF,$FF,$FF,$EF,$EF,$FF ; E164 FF EF FF FF FF EF EF FF
        .byte   $FD,$DF,$DF,$EF,$FE,$DF,$EF,$FF ; E16C FD DF DF EF FE DF EF FF
; Similar to noiselo_table. Nibble set to NOISE_VOL bits 0-3 with bit 4 set to 1
noisevol_table:
        .byte   $BF,$FF,$EE,$EF,$EF,$EF,$DF,$FB ; E174 BF FF EE EF EF EF DF FB
        .byte   $BB,$AA,$AA,$99,$98,$87,$76,$66 ; E17C BB AA AA 99 98 87 76 66
        .byte   $55,$44,$44,$44,$44,$43,$33,$33 ; E184 55 44 44 44 44 43 33 33
        .byte   $22,$22,$22,$22,$21,$11,$11,$11 ; E18C 22 22 22 22 21 11 11 11
; ----------------------------------------------------------------------------
updateSoundEffectSlot2:
        ldx     #$02                            ; E194 A2 02
        lda     #$45                            ; E196 A9 45
        ldy     #$45                            ; E198 A0 45
        bne     updateSoundEffectSlotShared     ; E19A D0 23
updateSoundEffectSlot3:
        ldx     #$03                            ; E19C A2 03
        lda     #$3D                            ; E19E A9 3D
        ldy     #$41                            ; E1A0 A0 41
        bne     updateSoundEffectSlotShared     ; E1A2 D0 1B
updateSoundEffectSlot4_unused:
        ldx     #$04                            ; E1A4 A2 04
        lda     #$45                            ; E1A6 A9 45
        ldy     #$45                            ; E1A8 A0 45
        bne     updateSoundEffectSlotShared     ; E1AA D0 13
updateSoundEffectSlot1:
        lda     soundEffectSlot4Playing         ; E1AC AD FC 06
        bne     updateSoundEffectSlotShared_rts ; E1AF D0 26
        ldx     #$01                            ; E1B1 A2 01
        lda     #$15                            ; E1B3 A9 15
        ldy     #$29                            ; E1B5 A0 29
        bne     updateSoundEffectSlotShared     ; E1B7 D0 06
updateSoundEffectSlot0:
        ldx     #$00                            ; E1B9 A2 00
        lda     #$09                            ; E1BB A9 09
        ldy     #$0F                            ; E1BD A0 0F
; x: sound effect slot; a: low byte addr, for $E0 high byte; y: low byte addr, for $E0 high byte, if slot unused
updateSoundEffectSlotShared:
        sta     AUDIOTMP1                       ; E1BF 85 E0
        stx     currentSoundEffectSlot          ; E1C1 86 ED
        lda     soundEffectSlot0Init,x          ; E1C3 BD F0 06
        beq     @primaryIsEmpty                 ; E1C6 F0 06
@computeAndExecute:
        jsr     computeSoundEffMethod           ; E1C8 20 72 E0
        jmp     (AUDIOTMP3)                     ; E1CB 6C E2 00

; ----------------------------------------------------------------------------
@primaryIsEmpty:
        lda     soundEffectSlot0Playing,x       ; E1CE BD F8 06
        beq     updateSoundEffectSlotShared_rts ; E1D1 F0 04
        sty     AUDIOTMP1                       ; E1D3 84 E0
        bne     @computeAndExecute              ; E1D5 D0 F1
updateSoundEffectSlotShared_rts:
        rts                                     ; E1D7 60

; ----------------------------------------------------------------------------
LE1D8:  lda     #$0F                            ; E1D8 A9 0F
        sta     SND_CHN                         ; E1DA 8D 15 40
        lda     #$55                            ; E1DD A9 55
        sta     soundRngSeed                    ; E1DF 85 EB
        jsr     soundEffectSlot2_makesNoSound   ; E1E1 20 44 E2
        rts                                     ; E1E4 60

; ----------------------------------------------------------------------------
initAudioAndMarkInited:
        inc     audioInitialized                ; E1E5 EE 82 06
        jsr     muteAudio                       ; E1E8 20 71 E2
        sta     musicPauseSoundEffectLengthCounter; E1EB 8D 83 06
        rts                                     ; E1EE 60

; ----------------------------------------------------------------------------
updateAudio_pause:
        lda     audioInitialized                ; E1EF AD 82 06
        beq     initAudioAndMarkInited          ; E1F2 F0 F1
        lda     musicPauseSoundEffectLengthCounter; E1F4 AD 83 06
        cmp     #$12                            ; E1F7 C9 12
        beq     @ret                            ; E1F9 F0 1A
        and     #$03                            ; E1FB 29 03
        cmp     #$03                            ; E1FD C9 03
        bne     @incAndRet                      ; E1FF D0 11
        inc     musicPauseSoundEffectCounter    ; E201 EE 8B 06
        ldy     #$10                            ; E204 A0 10
        lda     musicPauseSoundEffectCounter    ; E206 AD 8B 06
        and     #$01                            ; E209 29 01
        bne     @tableChosen                    ; E20B D0 02
        ldy     #$0C                            ; E20D A0 0C
@tableChosen:
        jsr     copyToSq1Channel                ; E20F 20 4B E0
@incAndRet:
        inc     musicPauseSoundEffectLengthCounter; E212 EE 83 06
@ret:   rts                                     ; E215 60

; ----------------------------------------------------------------------------
; Disables APU frame interrupt
updateAudio:
        lda     #$C0                            ; E216 A9 C0
        sta     JOY2_APUFC                      ; E218 8D 17 40
        lda     musicPauseScreen                ; E21B AD 8D 06
        cmp     #$05                            ; E21E C9 05
        beq     updateAudio_pause               ; E220 F0 CD
        lda     #$00                            ; E222 A9 00
        sta     audioInitialized                ; E224 8D 82 06
        sta     musicPauseSoundEffectCounter    ; E227 8D 8B 06
        jsr     updateSoundEffectSlot2          ; E22A 20 94 E1
        jsr     updateSoundEffectSlot0          ; E22D 20 B9 E1
        jsr     updateSoundEffectSlot3          ; E230 20 9C E1
        jsr     updateSoundEffectSlot1          ; E233 20 AC E1
        jsr     updateMusic                     ; E236 20 83 E5
        lda     #$00                            ; E239 A9 00
        ldx     #$06                            ; E23B A2 06
@clearSoundEffectSlotsInit:
        sta     $06EF,x                         ; E23D 9D EF 06
        dex                                     ; E240 CA
        bne     @clearSoundEffectSlotsInit      ; E241 D0 FA
        rts                                     ; E243 60

; ----------------------------------------------------------------------------
soundEffectSlot2_makesNoSound:
        jsr     LE253                           ; E244 20 53 E2
muteAudioAndClearTriControl:
        jsr     muteAudio                       ; E247 20 71 E2
        lda     #$00                            ; E24A A9 00
        sta     DMC_RAW                         ; E24C 8D 11 40
        sta     musicChanControl+2              ; E24F 8D 9C 06
        rts                                     ; E252 60

; ----------------------------------------------------------------------------
LE253:  lda     #$00                            ; E253 A9 00
        sta     musicChanInhibit                ; E255 8D C8 06
        sta     musicChanInhibit+1              ; E258 8D C9 06
        sta     musicChanInhibit+2              ; E25B 8D CA 06
        sta     music_unused                    ; E25E 8D 8C 06
        sta     resetSq12ForMusic               ; E261 8D 8A 06
        tay                                     ; E264 A8
LE265:  lda     #$00                            ; E265 A9 00
        sta     soundEffectSlot0Playing,y       ; E267 99 F8 06
        iny                                     ; E26A C8
        tya                                     ; E26B 98
        cmp     #$06                            ; E26C C9 06
        bne     LE265                           ; E26E D0 F5
        rts                                     ; E270 60

; ----------------------------------------------------------------------------
muteAudio:
        lda     #$00                            ; E271 A9 00
        sta     DMC_RAW                         ; E273 8D 11 40
        lda     #$10                            ; E276 A9 10
        sta     SQ1_VOL                         ; E278 8D 00 40
        sta     SQ2_VOL                         ; E27B 8D 04 40
        sta     NOISE_VOL                       ; E27E 8D 0C 40
        lda     #$00                            ; E281 A9 00
        sta     TRI_LINEAR                      ; E283 8D 08 40
        rts                                     ; E286 60

; ----------------------------------------------------------------------------
; inits currentSoundEffectSlot; input y: $E100+y to init APU channel (leaves alone if 0); input a: number of frames
initSoundEffectShared:
        ldx     currentSoundEffectSlot          ; E287 A6 ED
        sta     soundEffectSlot0FrameCount,x    ; E289 9D D5 06
        txa                                     ; E28C 8A
        sta     musicChanInhibitSetter,x        ; E28D 9D C7 06
        tya                                     ; E290 98
        beq     @continue                       ; E291 F0 22
        txa                                     ; E293 8A
        beq     @slot0                          ; E294 F0 1C
        cmp     #$01                            ; E296 C9 01
        beq     @slot1                          ; E298 F0 09
        cmp     #$02                            ; E29A C9 02
        beq     @slot2                          ; E29C F0 0A
        cmp     #$03                            ; E29E C9 03
        beq     @slot3                          ; E2A0 F0 0B
        rts                                     ; E2A2 60

; ----------------------------------------------------------------------------
@slot1: jsr     copyToSq1Channel                ; E2A3 20 4B E0
        beq     @continue                       ; E2A6 F0 0D
@slot2: jsr     copyToSq2Channel                ; E2A8 20 57 E0
        beq     @continue                       ; E2AB F0 08
@slot3: jsr     copyToTriChannel                ; E2AD 20 4F E0
        beq     @continue                       ; E2B0 F0 03
@slot0: jsr     copyToNoiseChannel              ; E2B2 20 53 E0
@continue:
        lda     currentAudioSlot                ; E2B5 A5 EF
        sta     soundEffectSlot0Playing,x       ; E2B7 9D F8 06
        lda     #$00                            ; E2BA A9 00
        sta     soundEffectSlot0FrameCounter,x  ; E2BC 9D DA 06
        sta     soundEffectSlot0SecondaryCounter,x; E2BF 9D DF 06
        sta     soundEffectSlot0TertiaryCounter,x; E2C2 9D E3 06
        sta     soundEffectSlot0Tmp,x           ; E2C5 9D E7 06
        sta     resetSq12ForMusic               ; E2C8 8D 8A 06
        rts                                     ; E2CB 60

; ----------------------------------------------------------------------------
soundEffectSlot0_endingRocketInit:
        lda     #$20                            ; E2CC A9 20
        ldy     #$08                            ; E2CE A0 08
        jmp     initSoundEffectShared           ; E2D0 4C 87 E2

; ----------------------------------------------------------------------------
setNoiseLo:
        sta     NOISE_LO                        ; E2D3 8D 0E 40
        rts                                     ; E2D6 60

; ----------------------------------------------------------------------------
loadNoiseLo:
        jsr     getSoundEffectNoiseNibble       ; E2D7 20 1A E3
        jmp     setNoiseLo                      ; E2DA 4C D3 E2

; ----------------------------------------------------------------------------
soundEffectSlot0_makesNoSound:
        lda     #$10                            ; E2DD A9 10
        ldy     #$00                            ; E2DF A0 00
        jmp     initSoundEffectShared           ; E2E1 4C 87 E2

; ----------------------------------------------------------------------------
advanceSoundEffectSlot0WithoutUpdate:
        jsr     advanceAudioSlotFrame           ; E2E4 20 B5 E0
        bne     updateSoundEffectSlot0WithoutUpdate_ret; E2E7 D0 0A
stopSoundEffectSlot0:
        lda     #$00                            ; E2E9 A9 00
        sta     soundEffectSlot0Playing         ; E2EB 8D F8 06
        lda     #$10                            ; E2EE A9 10
        sta     NOISE_VOL                       ; E2F0 8D 0C 40
updateSoundEffectSlot0WithoutUpdate_ret:
        rts                                     ; E2F3 60

; ----------------------------------------------------------------------------
unreferenced_code2:
        lda     #$02                            ; E2F4 A9 02
        sta     currentAudioSlot                ; E2F6 85 EF
soundEffectSlot0_gameOverCurtainInit:
        lda     #$40                            ; E2F8 A9 40
        ldy     #$04                            ; E2FA A0 04
        jmp     initSoundEffectShared           ; E2FC 4C 87 E2

; ----------------------------------------------------------------------------
updateSoundEffectSlot0_apu:
        jsr     advanceAudioSlotFrame           ; E2FF 20 B5 E0
        bne     updateSoundEffectNoiseAudio     ; E302 D0 03
        jmp     stopSoundEffectSlot0            ; E304 4C E9 E2

; ----------------------------------------------------------------------------
updateSoundEffectNoiseAudio:
        ldx     #$54                            ; E307 A2 54
        jsr     loadNoiseLo                     ; E309 20 D7 E2
        ldx     #$74                            ; E30C A2 74
        jsr     getSoundEffectNoiseNibble       ; E30E 20 1A E3
        ora     #$10                            ; E311 09 10
        sta     NOISE_VOL                       ; E313 8D 0C 40
        inc     soundEffectSlot0SecondaryCounter; E316 EE DF 06
        rts                                     ; E319 60

; ----------------------------------------------------------------------------
; Loads from noiselo_table(x=$54)/noisevol_table(x=$74)
getSoundEffectNoiseNibble:
        stx     AUDIOTMP1                       ; E31A 86 E0
        ldy     #$E1                            ; E31C A0 E1
        sty     AUDIOTMP2                       ; E31E 84 E1
        ldx     soundEffectSlot0SecondaryCounter; E320 AE DF 06
        txa                                     ; E323 8A
        lsr     a                               ; E324 4A
        tay                                     ; E325 A8
        lda     (AUDIOTMP1),y                   ; E326 B1 E0
        sta     AUDIOTMP5                       ; E328 85 E4
        txa                                     ; E32A 8A
        and     #$01                            ; E32B 29 01
        beq     @shift4                         ; E32D F0 05
        lda     AUDIOTMP5                       ; E32F A5 E4
        and     #$0F                            ; E331 29 0F
        rts                                     ; E333 60

; ----------------------------------------------------------------------------
@shift4:lda     AUDIOTMP5                       ; E334 A5 E4
        lsr     a                               ; E336 4A
        lsr     a                               ; E337 4A
        lsr     a                               ; E338 4A
        lsr     a                               ; E339 4A
        rts                                     ; E33A 60

; ----------------------------------------------------------------------------
LE33B:  lda     soundEffectSlot1Playing         ; E33B AD F9 06
        cmp     #$04                            ; E33E C9 04
        beq     LE34E                           ; E340 F0 0C
        cmp     #$06                            ; E342 C9 06
        beq     LE34E                           ; E344 F0 08
        cmp     #$09                            ; E346 C9 09
        beq     LE34E                           ; E348 F0 04
        cmp     #$0A                            ; E34A C9 0A
        beq     LE34E                           ; E34C F0 00
LE34E:  rts                                     ; E34E 60

; ----------------------------------------------------------------------------
soundEffectSlot1_chirpChirpPlaying:
        lda     soundEffectSlot1TertiaryCounter ; E34F AD E4 06
        beq     @stage1                         ; E352 F0 0D
        inc     soundEffectSlot1SecondaryCounter; E354 EE E0 06
        lda     soundEffectSlot1SecondaryCounter; E357 AD E0 06
        cmp     #$16                            ; E35A C9 16
        bne     soundEffectSlot1Playing_ret     ; E35C D0 53
        jmp     soundEffectSlot1Playing_stop    ; E35E 4C A1 E3

; ----------------------------------------------------------------------------
@stage1:lda     soundEffectSlot1SecondaryCounter; E361 AD E0 06
        and     #$03                            ; E364 29 03
        tay                                     ; E366 A8
        lda     soundEffectSlot1_chirpChirpSq1Vol_table,y; E367 B9 50 E1
        sta     SQ1_VOL                         ; E36A 8D 00 40
        inc     soundEffectSlot1SecondaryCounter; E36D EE E0 06
        lda     soundEffectSlot1SecondaryCounter; E370 AD E0 06
        cmp     #$08                            ; E373 C9 08
        bne     soundEffectSlot1Playing_ret     ; E375 D0 3A
        inc     soundEffectSlot1TertiaryCounter ; E377 EE E4 06
        ldy     #$40                            ; E37A A0 40
        jmp     copyToSq1Channel                ; E37C 4C 4B E0

; ----------------------------------------------------------------------------
; Unused.
soundEffectSlot1_chirpChirpInit:
        ldy     #$3C                            ; E37F A0 3C
        jmp     initSoundEffectShared           ; E381 4C 87 E2

; ----------------------------------------------------------------------------
soundEffectSlot1_lockTetriminoInit:
        jsr     LE33B                           ; E384 20 3B E3
        beq     soundEffectSlot1Playing_ret     ; E387 F0 28
        lda     #$0F                            ; E389 A9 0F
        ldy     #$20                            ; E38B A0 20
        jmp     initSoundEffectShared           ; E38D 4C 87 E2

; ----------------------------------------------------------------------------
soundEffectSlot1_shiftTetriminoInit:
        jsr     LE33B                           ; E390 20 3B E3
        beq     soundEffectSlot1Playing_ret     ; E393 F0 1C
        lda     #$02                            ; E395 A9 02
        ldy     #$44                            ; E397 A0 44
        jmp     initSoundEffectShared           ; E399 4C 87 E2

; ----------------------------------------------------------------------------
soundEffectSlot1Playing_advance:
        jsr     advanceAudioSlotFrame           ; E39C 20 B5 E0
        bne     soundEffectSlot1Playing_ret     ; E39F D0 10
soundEffectSlot1Playing_stop:
        lda     #$10                            ; E3A1 A9 10
        sta     SQ1_VOL                         ; E3A3 8D 00 40
        lda     #$00                            ; E3A6 A9 00
        sta     musicChanInhibit                ; E3A8 8D C8 06
        sta     soundEffectSlot1Playing         ; E3AB 8D F9 06
        inc     resetSq12ForMusic               ; E3AE EE 8A 06
soundEffectSlot1Playing_ret:
        rts                                     ; E3B1 60

; ----------------------------------------------------------------------------
soundEffectSlot1_menuOptionSelectPlaying_ret:
        rts                                     ; E3B2 60

; ----------------------------------------------------------------------------
soundEffectSlot1_menuOptionSelectPlaying:
        jsr     advanceAudioSlotFrame           ; E3B3 20 B5 E0
        bne     soundEffectSlot1_menuOptionSelectPlaying_ret; E3B6 D0 FA
        inc     soundEffectSlot1SecondaryCounter; E3B8 EE E0 06
        lda     soundEffectSlot1SecondaryCounter; E3BB AD E0 06
        cmp     #$02                            ; E3BE C9 02
        bne     @stage2                         ; E3C0 D0 03
        jmp     soundEffectSlot1Playing_stop    ; E3C2 4C A1 E3

; ----------------------------------------------------------------------------
@stage2:ldy     #$28                            ; E3C5 A0 28
        jmp     copyToSq1Channel                ; E3C7 4C 4B E0

; ----------------------------------------------------------------------------
soundEffectSlot1_menuOptionSelectInit:
        lda     #$03                            ; E3CA A9 03
        ldy     #$24                            ; E3CC A0 24
        bne     LE417                           ; E3CE D0 47
soundEffectSlot1_rotateTetrimino_ret:
        rts                                     ; E3D0 60

; ----------------------------------------------------------------------------
soundEffectSlot1_rotateTetriminoInit:
        jsr     LE33B                           ; E3D1 20 3B E3
        beq     soundEffectSlot1_rotateTetrimino_ret; E3D4 F0 FA
        lda     #$04                            ; E3D6 A9 04
        ldy     #$14                            ; E3D8 A0 14
        jsr     LE417                           ; E3DA 20 17 E4
soundEffectSlot1_rotateTetriminoPlaying:
        jsr     advanceAudioSlotFrame           ; E3DD 20 B5 E0
        bne     soundEffectSlot1_rotateTetrimino_ret; E3E0 D0 EE
        lda     soundEffectSlot1SecondaryCounter; E3E2 AD E0 06
        inc     soundEffectSlot1SecondaryCounter; E3E5 EE E0 06
        beq     @stage3                         ; E3E8 F0 14
        cmp     #$01                            ; E3EA C9 01
        beq     @stage2                         ; E3EC F0 0B
        cmp     #$02                            ; E3EE C9 02
        beq     @stage3                         ; E3F0 F0 0C
        cmp     #$03                            ; E3F2 C9 03
        bne     soundEffectSlot1_rotateTetrimino_ret; E3F4 D0 DA
        jmp     soundEffectSlot1Playing_stop    ; E3F6 4C A1 E3

; ----------------------------------------------------------------------------
@stage2:ldy     #$14                            ; E3F9 A0 14
        jmp     copyToSq1Channel                ; E3FB 4C 4B E0

; ----------------------------------------------------------------------------
; On first glance it appears this is used twice, but the first beq does nothing because the inc result will never be 0
@stage3:ldy     #$18                            ; E3FE A0 18
        jmp     copyToSq1Channel                ; E400 4C 4B E0

; ----------------------------------------------------------------------------
soundEffectSlot1_tetrisAchievedInit:
        lda     #$05                            ; E403 A9 05
        ldy     #$30                            ; E405 A0 30
        jsr     LE417                           ; E407 20 17 E4
        lda     #$10                            ; E40A A9 10
        bne     LE437                           ; E40C D0 29
soundEffectSlot1_tetrisAchievedPlaying:
        jsr     advanceAudioSlotFrame           ; E40E 20 B5 E0
        bne     LE43A                           ; E411 D0 27
        ldy     #$30                            ; E413 A0 30
        bne     LE442                           ; E415 D0 2B
LE417:  jmp     initSoundEffectShared           ; E417 4C 87 E2

; ----------------------------------------------------------------------------
soundEffectSlot1_lineCompletedInit:
        lda     #$05                            ; E41A A9 05
        ldy     #$34                            ; E41C A0 34
        jsr     LE417                           ; E41E 20 17 E4
        lda     #$08                            ; E421 A9 08
        bne     LE437                           ; E423 D0 12
soundEffectSlot1_lineCompletedPlaying:
        jsr     advanceAudioSlotFrame           ; E425 20 B5 E0
        bne     LE43A                           ; E428 D0 10
        ldy     #$34                            ; E42A A0 34
        bne     LE442                           ; E42C D0 14
soundEffectSlot1_lineClearingInit:
        lda     #$04                            ; E42E A9 04
        ldy     #$38                            ; E430 A0 38
        jsr     LE417                           ; E432 20 17 E4
        lda     #$00                            ; E435 A9 00
LE437:  sta     soundEffectSlot1TertiaryCounter ; E437 8D E4 06
LE43A:  rts                                     ; E43A 60

; ----------------------------------------------------------------------------
soundEffectSlot1_lineClearingPlaying:
        jsr     advanceAudioSlotFrame           ; E43B 20 B5 E0
        bne     LE43A                           ; E43E D0 FA
        ldy     #$38                            ; E440 A0 38
LE442:  jsr     copyToSq1Channel                ; E442 20 4B E0
        clc                                     ; E445 18
        lda     soundEffectSlot1TertiaryCounter ; E446 AD E4 06
        adc     soundEffectSlot1SecondaryCounter; E449 6D E0 06
        tay                                     ; E44C A8
        lda     soundEffectSlot1_lineClearing_lo,y; E44D B9 B9 E4
        sta     SQ1_LO                          ; E450 8D 02 40
        ldy     soundEffectSlot1SecondaryCounter; E453 AC E0 06
        lda     soundEffectSlot1_lineClearing_vol,y; E456 B9 B0 E4
        sta     SQ1_VOL                         ; E459 8D 00 40
        bne     LE46F                           ; E45C D0 11
        lda     soundEffectSlot1Playing         ; E45E AD F9 06
        cmp     #$04                            ; E461 C9 04
        bne     LE46C                           ; E463 D0 07
        lda     #$09                            ; E465 A9 09
        sta     currentAudioSlot                ; E467 85 EF
        jmp     soundEffectSlot1_lineClearingInit; E469 4C 2E E4

; ----------------------------------------------------------------------------
LE46C:  jmp     soundEffectSlot1Playing_stop    ; E46C 4C A1 E3

; ----------------------------------------------------------------------------
LE46F:  inc     soundEffectSlot1SecondaryCounter; E46F EE E0 06
LE472:  rts                                     ; E472 60

; ----------------------------------------------------------------------------
soundEffectSlot1_menuScreenSelectInit:
        lda     #$03                            ; E473 A9 03
        ldy     #$2C                            ; E475 A0 2C
        jsr     initSoundEffectShared           ; E477 20 87 E2
        lda     soundEffectSlot1_menuScreenSelectInitData+2; E47A AD 2E E1
        sta     soundEffectSlot1SecondaryCounter; E47D 8D E0 06
        rts                                     ; E480 60

; ----------------------------------------------------------------------------
soundEffectSlot1_menuScreenSelectPlaying:
        jsr     advanceAudioSlotFrame           ; E481 20 B5 E0
        bne     LE472                           ; E484 D0 EC
        inc     soundEffectSlot1TertiaryCounter ; E486 EE E4 06
        lda     soundEffectSlot1TertiaryCounter ; E489 AD E4 06
        cmp     #$04                            ; E48C C9 04
        bne     LE493                           ; E48E D0 03
        jmp     soundEffectSlot1Playing_stop    ; E490 4C A1 E3

; ----------------------------------------------------------------------------
LE493:  lda     soundEffectSlot1SecondaryCounter; E493 AD E0 06
        lsr     a                               ; E496 4A
        lsr     a                               ; E497 4A
        lsr     a                               ; E498 4A
        lsr     a                               ; E499 4A
        sta     soundEffectSlot1Tmp             ; E49A 8D E8 06
        lda     soundEffectSlot1SecondaryCounter; E49D AD E0 06
        clc                                     ; E4A0 18
        sbc     soundEffectSlot1Tmp             ; E4A1 ED E8 06
        sta     soundEffectSlot1SecondaryCounter; E4A4 8D E0 06
        sta     SQ1_LO                          ; E4A7 8D 02 40
        lda     #$28                            ; E4AA A9 28
LE4AC:  sta     SQ1_HI                          ; E4AC 8D 03 40
LE4AF:  rts                                     ; E4AF 60

; ----------------------------------------------------------------------------
soundEffectSlot1_lineClearing_vol:
        .byte   $9E,$9B,$99,$96,$94,$93,$92,$91 ; E4B0 9E 9B 99 96 94 93 92 91
        .byte   $00                             ; E4B8 00
soundEffectSlot1_lineClearing_lo:
        .byte   $46,$37,$46,$37,$46,$37,$46,$37 ; E4B9 46 37 46 37 46 37 46 37
        .byte   $70,$80,$90,$A0,$B0,$C0,$D0,$E0 ; E4C1 70 80 90 A0 B0 C0 D0 E0
        .byte   $C0,$89,$B8,$68,$A0,$50,$90,$40 ; E4C9 C0 89 B8 68 A0 50 90 40
; ----------------------------------------------------------------------------
soundEffectSlot1_levelUpPlaying:
        jsr     advanceAudioSlotFrame           ; E4D1 20 B5 E0
        bne     LE4AF                           ; E4D4 D0 D9
        ldy     soundEffectSlot1SecondaryCounter; E4D6 AC E0 06
        inc     soundEffectSlot1SecondaryCounter; E4D9 EE E0 06
        lda     soundEffectSlot1_levelUp_lo,y   ; E4DC B9 F3 E4
        beq     LE4E9                           ; E4DF F0 08
        sta     SQ1_LO                          ; E4E1 8D 02 40
        lda     #$28                            ; E4E4 A9 28
        jmp     LE4AC                           ; E4E6 4C AC E4

; ----------------------------------------------------------------------------
LE4E9:  jmp     soundEffectSlot1Playing_stop    ; E4E9 4C A1 E3

; ----------------------------------------------------------------------------
soundEffectSlot1_levelUpInit:
        lda     #$06                            ; E4EC A9 06
        ldy     #$1C                            ; E4EE A0 1C
        jmp     initSoundEffectShared           ; E4F0 4C 87 E2

; ----------------------------------------------------------------------------
soundEffectSlot1_levelUp_lo:
        .byte   $69,$A8,$69,$A8,$8D,$53,$8D,$53 ; E4F3 69 A8 69 A8 8D 53 8D 53
        .byte   $8D,$00                         ; E4FB 8D 00
; ----------------------------------------------------------------------------
unreferenced_code_soundEffectSlot1:
        lda     #$10                            ; E4FD A9 10
        sta     SQ2_VOL                         ; E4FF 8D 04 40
        lda     #$00                            ; E502 A9 00
        sta     musicChanInhibit+1              ; E504 8D C9 06
        sta     soundEffectSlot2Playing         ; E507 8D FA 06
        rts                                     ; E50A 60

; ----------------------------------------------------------------------------
; Unused
soundEffectSlot2_mediumBuzz:
        lda     #$3F                            ; E50B A9 3F
        ldy     #$60                            ; E50D A0 60
        ldx     #$0F                            ; E50F A2 0F
        bne     soundEffectSlot2_start          ; E511 D0 08
; Unused
soundEffectSlot2_lowBuzz:
        lda     #$3F                            ; E513 A9 3F
        ldy     #$60                            ; E515 A0 60
        ldx     #$0E                            ; E517 A2 0E
        bne     soundEffectSlot2_start          ; E519 D0 00
soundEffectSlot2_start:
        sta     DMC_LEN                         ; E51B 8D 13 40
        sty     DMC_START                       ; E51E 8C 12 40
        stx     DMC_FREQ                        ; E521 8E 10 40
        lda     #$0F                            ; E524 A9 0F
        sta     SND_CHN                         ; E526 8D 15 40
        lda     #$00                            ; E529 A9 00
        sta     DMC_RAW                         ; E52B 8D 11 40
        lda     #$1F                            ; E52E A9 1F
        sta     SND_CHN                         ; E530 8D 15 40
        rts                                     ; E533 60

; ----------------------------------------------------------------------------
; Unused
soundEffectSlot3_donk:
        lda     #$02                            ; E534 A9 02
        ldy     #$4C                            ; E536 A0 4C
        jmp     initSoundEffectShared           ; E538 4C 87 E2

; ----------------------------------------------------------------------------
soundEffectSlot3Playing_advance:
        jsr     advanceAudioSlotFrame           ; E53B 20 B5 E0
        bne     soundEffectSlot3Playing_ret     ; E53E D0 10
soundEffectSlot3Playing_stop:
        lda     #$00                            ; E540 A9 00
        sta     TRI_LINEAR                      ; E542 8D 08 40
        sta     musicChanInhibit+2              ; E545 8D CA 06
        sta     soundEffectSlot3Playing         ; E548 8D FB 06
        lda     #$18                            ; E54B A9 18
        sta     TRI_HI                          ; E54D 8D 0B 40
soundEffectSlot3Playing_ret:
        rts                                     ; E550 60

; ----------------------------------------------------------------------------
updateSoundEffectSlot3_apu:
        jsr     advanceAudioSlotFrame           ; E551 20 B5 E0
        bne     soundEffectSlot3Playing_ret     ; E554 D0 FA
        ldy     soundEffectSlot3SecondaryCounter; E556 AC E2 06
        inc     soundEffectSlot3SecondaryCounter; E559 EE E2 06
        lda     trilo_table,y                   ; E55C B9 7C E5
        beq     soundEffectSlot3Playing_stop    ; E55F F0 DF
        sta     TRI_LO                          ; E561 8D 0A 40
        sta     soundEffectSlot3TertiaryCounter ; E564 8D E6 06
        lda     soundEffectSlot3_unknown1InitData+3; E567 AD 4B E1
        sta     TRI_HI                          ; E56A 8D 0B 40
        rts                                     ; E56D 60

; ----------------------------------------------------------------------------
; Unused
soundEffectSlot3_fallingAlien:
        lda     #$06                            ; E56E A9 06
        ldy     #$48                            ; E570 A0 48
        jsr     initSoundEffectShared           ; E572 20 87 E2
        lda     soundEffectSlot3_unknown1InitData+2; E575 AD 4A E1
        sta     soundEffectSlot3TertiaryCounter ; E578 8D E6 06
        rts                                     ; E57B 60

; ----------------------------------------------------------------------------
trilo_table:
        .byte   $72,$74,$77,$00                 ; E57C 72 74 77 00
; ----------------------------------------------------------------------------
updateMusic_noSoundJmp:
        jmp     soundEffectSlot2_makesNoSound   ; E580 4C 44 E2

; ----------------------------------------------------------------------------
updateMusic:
        lda     musicTrack                      ; E583 AD F5 06
        tay                                     ; E586 A8
        cmp     #$FF                            ; E587 C9 FF
        beq     updateMusic_noSoundJmp          ; E589 F0 F5
        cmp     #$00                            ; E58B C9 00
        beq     @checkIfAlreadyPlaying          ; E58D F0 16
        sta     currentAudioSlot                ; E58F 85 EF
        sta     musicTrack_dec                  ; E591 8D CC 06
        dec     musicTrack_dec                  ; E594 CE CC 06
        lda     #$7F                            ; E597 A9 7F
        sta     musicStagingSq1Sweep            ; E599 8D C0 06
        sta     musicStagingSq1Sweep+1          ; E59C 8D C1 06
        jsr     loadMusicTrack                  ; E59F 20 D7 E6
@updateFrame:
        jmp     updateMusicFrame                ; E5A2 4C 40 E8

; ----------------------------------------------------------------------------
@checkIfAlreadyPlaying:
        lda     currentlyPlayingMusicTrack      ; E5A5 AD FD 06
        bne     @updateFrame                    ; E5A8 D0 F8
        rts                                     ; E5AA 60

; ----------------------------------------------------------------------------
; triples of bytes, one for each MMIO
noises_table:
        .byte   $00,$10,$01,$18,$00,$01,$38,$00 ; E5AB 00 10 01 18 00 01 38 00
        .byte   $03,$40,$00,$06,$58,$00,$0A,$38 ; E5B3 03 40 00 06 58 00 0A 38
        .byte   $02,$04,$40,$13,$05,$40,$14,$0A ; E5BB 02 04 40 13 05 40 14 0A
        .byte   $40,$14,$08,$40,$12,$0E,$08,$16 ; E5C3 40 14 08 40 12 0E 08 16
        .byte   $0E,$28,$16,$0B,$18             ; E5CB 0E 28 16 0B 18
; ----------------------------------------------------------------------------
; input x: channel number (0-3). Does nothing for track 1 and NOISE
updateMusicFrame_setChanLo:
        lda     currentlyPlayingMusicTrack      ; E5D0 AD FD 06
        cmp     #$01                            ; E5D3 C9 01
        beq     @ret                            ; E5D5 F0 22
        txa                                     ; E5D7 8A
        cmp     #$03                            ; E5D8 C9 03
        beq     @ret                            ; E5DA F0 1D
        lda     musicChanControl,x              ; E5DC BD 9A 06
        and     #$E0                            ; E5DF 29 E0
        beq     @ret                            ; E5E1 F0 16
        sta     AUDIOTMP1                       ; E5E3 85 E0
        lda     musicChanNote,x                 ; E5E5 BD C3 06
        cmp     #$02                            ; E5E8 C9 02
        beq     @incAndRet                      ; E5EA F0 0A
        ldy     musicChannelOffset              ; E5EC A4 EE
        lda     musicStagingSq1Lo,y             ; E5EE B9 80 06
        sta     AUDIOTMP2                       ; E5F1 85 E1
        jsr     updateMusicFrame_setChanLoOffset; E5F3 20 37 E6
@incAndRet:
        inc     musicChanLoFrameCounter,x       ; E5F6 FE D1 06
@ret:   rts                                     ; E5F9 60

; ----------------------------------------------------------------------------
musicLoOffset_8AndC:
        lda     AUDIOTMP3                       ; E5FA A5 E2
        cmp     #$31                            ; E5FC C9 31
        bne     @lessThan31                     ; E5FE D0 02
        lda     #$27                            ; E600 A9 27
@lessThan31:
        tay                                     ; E602 A8
        lda     loOff9To0FallTable,y            ; E603 B9 89 E6
        pha                                     ; E606 48
        lda     musicChanNote,x                 ; E607 BD C3 06
        cmp     #$46                            ; E60A C9 46
        bne     LE613                           ; E60C D0 05
        pla                                     ; E60E 68
        lda     #$00                            ; E60F A9 00
        beq     musicLoOffset_setLoAndSaveFrameCounter; E611 F0 5E
LE613:  pla                                     ; E613 68
        jmp     musicLoOffset_setLoAndSaveFrameCounter; E614 4C 71 E6

; ----------------------------------------------------------------------------
; Doesn't loop
musicLoOffset_4:
        lda     AUDIOTMP3                       ; E617 A5 E2
        tay                                     ; E619 A8
        cmp     #$10                            ; E61A C9 10
        bcs     @outOfRange                     ; E61C B0 06
        lda     loOffDescendToNeg11BounceToNeg9Table,y; E61E B9 C0 E6
        jmp     musicLoOffset_setLo             ; E621 4C 77 E6

; ----------------------------------------------------------------------------
@outOfRange:
        lda     #$F6                            ; E624 A9 F6
        bne     musicLoOffset_setLo             ; E626 D0 4F
; Every frame is the same
musicLoOffset_minus2_6:
        lda     musicChanNote,x                 ; E628 BD C3 06
        cmp     #$4C                            ; E62B C9 4C
        bcc     @unnecessaryBranch              ; E62D 90 04
        lda     #$FE                            ; E62F A9 FE
        bne     musicLoOffset_setLo             ; E631 D0 44
@unnecessaryBranch:
        lda     #$FE                            ; E633 A9 FE
        bne     musicLoOffset_setLo             ; E635 D0 40
; input x: channel number (0-2). input AUDIOTMP1: musicChanControl masked by #$E0. input AUDIOTMP2: base LO
updateMusicFrame_setChanLoOffset:
        lda     musicChanLoFrameCounter,x       ; E637 BD D1 06
        sta     AUDIOTMP3                       ; E63A 85 E2
        lda     AUDIOTMP1                       ; E63C A5 E0
        cmp     #$20                            ; E63E C9 20
        beq     @2AndE                          ; E640 F0 14
        cmp     #$A0                            ; E642 C9 A0
        beq     @A                              ; E644 F0 1F
        cmp     #$60                            ; E646 C9 60
        beq     musicLoOffset_minus2_6          ; E648 F0 DE
        cmp     #$40                            ; E64A C9 40
        beq     musicLoOffset_4                 ; E64C F0 C9
        cmp     #$80                            ; E64E C9 80
        beq     musicLoOffset_8AndC             ; E650 F0 A8
        cmp     #$C0                            ; E652 C9 C0
        beq     musicLoOffset_8AndC             ; E654 F0 A4
; Loops between 0-9
@2AndE: lda     AUDIOTMP3                       ; E656 A5 E2
        cmp     #$0A                            ; E658 C9 0A
        bne     @2AndE_lessThanA                ; E65A D0 02
        lda     #$00                            ; E65C A9 00
@2AndE_lessThanA:
        tay                                     ; E65E A8
        lda     loOffTrillNeg2To2Table,y        ; E65F B9 B6 E6
        jmp     musicLoOffset_setLoAndSaveFrameCounter; E662 4C 71 E6

; ----------------------------------------------------------------------------
; Ends by looping in 2 and E table
@A:     lda     AUDIOTMP3                       ; E665 A5 E2
        cmp     #$2B                            ; E667 C9 2B
        bne     @A_lessThan2B                   ; E669 D0 02
        lda     #$21                            ; E66B A9 21
@A_lessThan2B:
        tay                                     ; E66D A8
        lda     loOffSlowStartTrillTable,y      ; E66E B9 95 E6
musicLoOffset_setLoAndSaveFrameCounter:
        pha                                     ; E671 48
        tya                                     ; E672 98
        sta     musicChanLoFrameCounter,x       ; E673 9D D1 06
        pla                                     ; E676 68
musicLoOffset_setLo:
        pha                                     ; E677 48
        lda     musicChanInhibit,x              ; E678 BD C8 06
        bne     @ret                            ; E67B D0 0A
        pla                                     ; E67D 68
        clc                                     ; E67E 18
        adc     AUDIOTMP2                       ; E67F 65 E1
        ldy     musicChannelOffset              ; E681 A4 EE
        sta     SQ1_LO,y                        ; E683 99 02 40
        rts                                     ; E686 60

; ----------------------------------------------------------------------------
@ret:   pla                                     ; E687 68
        rts                                     ; E688 60

; ----------------------------------------------------------------------------
; Values are signed
loOff9To0FallTable:
        .byte   $09,$08,$07,$06,$05,$04,$03,$02 ; E689 09 08 07 06 05 04 03 02
        .byte   $02,$01,$01,$00                 ; E691 02 01 01 00
; Includes next table
loOffSlowStartTrillTable:
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; E695 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$01 ; E69D 00 00 00 00 00 00 00 01
        .byte   $00,$00,$00,$00,$FF,$00,$00,$00 ; E6A5 00 00 00 00 FF 00 00 00
        .byte   $00,$01,$01,$00,$00,$00,$FF,$FF ; E6AD 00 01 01 00 00 00 FF FF
        .byte   $00                             ; E6B5 00
loOffTrillNeg2To2Table:
        .byte   $00,$01,$01,$02,$01,$00,$FF,$FF ; E6B6 00 01 01 02 01 00 FF FF
        .byte   $FE,$FF                         ; E6BE FE FF
loOffDescendToNeg11BounceToNeg9Table:
        .byte   $00,$FF,$FE,$FD,$FC,$FB,$FA,$F9 ; E6C0 00 FF FE FD FC FB FA F9
        .byte   $F8,$F7,$F6,$F5,$F6,$F7,$F6,$F5 ; E6C8 F8 F7 F6 F5 F6 F7 F6 F5
; ----------------------------------------------------------------------------
copyFFFFToDeref:
        lda     #$FF                            ; E6D0 A9 FF
        sta     musicDataChanPtrDeref,x         ; E6D2 9D A0 06
        bne     storeDeref1AndContinue          ; E6D5 D0 53
loadMusicTrack:
        jsr     muteAudioAndClearTriControl     ; E6D7 20 47 E2
        lda     currentAudioSlot                ; E6DA A5 EF
        sta     currentlyPlayingMusicTrack      ; E6DC 8D FD 06
        lda     musicTrack_dec                  ; E6DF AD CC 06
        tay                                     ; E6E2 A8
        lda     musicDataTableIndex,y           ; E6E3 B9 23 EC
        tay                                     ; E6E6 A8
        ldx     #$00                            ; E6E7 A2 00
@copyByteToMusicData:
        lda     musicDataTable,y                ; E6E9 B9 2D EC
        sta     musicDataNoteTableOffset,x      ; E6EC 9D 90 06
        iny                                     ; E6EF C8
        inx                                     ; E6F0 E8
        txa                                     ; E6F1 8A
        cmp     #$0A                            ; E6F2 C9 0A
        bne     @copyByteToMusicData            ; E6F4 D0 F3
        lda     #$01                            ; E6F6 A9 01
        sta     musicChanNoteDurationRemaining  ; E6F8 8D B4 06
        sta     musicChanNoteDurationRemaining+1; E6FB 8D B5 06
        sta     musicChanNoteDurationRemaining+2; E6FE 8D B6 06
        sta     musicChanNoteDurationRemaining+3; E701 8D B7 06
        lda     #$00                            ; E704 A9 00
        sta     music_unused2                   ; E706 85 EA
        ldy     #$08                            ; E708 A0 08
@zeroFillDeref:
        sta     musicDataChanPtrDeref+7,y       ; E70A 99 A7 06
        dey                                     ; E70D 88
        bne     @zeroFillDeref                  ; E70E D0 FA
        tax                                     ; E710 AA
derefNextAddr:
        lda     musicDataChanPtr,x              ; E711 BD 92 06
        sta     musicChanTmpAddr                ; E714 85 E6
        lda     musicDataChanPtr+1,x            ; E716 BD 93 06
        cmp     #$FF                            ; E719 C9 FF
        beq     copyFFFFToDeref                 ; E71B F0 B3
        sta     musicChanTmpAddr+1              ; E71D 85 E7
        ldy     musicDataChanPtrOff             ; E71F AC A8 06
        lda     (musicChanTmpAddr),y            ; E722 B1 E6
        sta     musicDataChanPtrDeref,x         ; E724 9D A0 06
        iny                                     ; E727 C8
        lda     (musicChanTmpAddr),y            ; E728 B1 E6
storeDeref1AndContinue:
        sta     musicDataChanPtrDeref+1,x       ; E72A 9D A1 06
        inx                                     ; E72D E8
        inx                                     ; E72E E8
        txa                                     ; E72F 8A
        cmp     #$08                            ; E730 C9 08
        bne     derefNextAddr                   ; E732 D0 DD
        rts                                     ; E734 60

; ----------------------------------------------------------------------------
initSq12IfTrashedBySoundEffect:
        lda     resetSq12ForMusic               ; E735 AD 8A 06
        beq     initSq12IfTrashedBySoundEffect_ret; E738 F0 2B
        cmp     #$01                            ; E73A C9 01
        beq     @setSq1                         ; E73C F0 11
        lda     #$7F                            ; E73E A9 7F
        sta     SQ2_SWEEP                       ; E740 8D 05 40
        lda     musicStagingSq2Lo               ; E743 AD 84 06
        sta     SQ2_LO                          ; E746 8D 06 40
        lda     musicStagingSq2Hi               ; E749 AD 85 06
        sta     SQ2_HI                          ; E74C 8D 07 40
@setSq1:lda     #$7F                            ; E74F A9 7F
        sta     SQ1_SWEEP                       ; E751 8D 01 40
        lda     musicStagingSq1Lo               ; E754 AD 80 06
        sta     SQ1_LO                          ; E757 8D 02 40
        lda     musicStagingSq1Hi               ; E75A AD 81 06
        sta     SQ1_HI                          ; E75D 8D 03 40
        lda     #$00                            ; E760 A9 00
        sta     resetSq12ForMusic               ; E762 8D 8A 06
initSq12IfTrashedBySoundEffect_ret:
        rts                                     ; E765 60

; ----------------------------------------------------------------------------
; input x: channel number (0-3). Does nothing for SQ1/2
updateMusicFrame_setChanVol:
        txa                                     ; E766 8A
        cmp     #$02                            ; E767 C9 02
        bcs     initSq12IfTrashedBySoundEffect_ret; E769 B0 FA
        lda     musicChanControl,x              ; E76B BD 9A 06
        and     #$1F                            ; E76E 29 1F
        beq     @ret                            ; E770 F0 59
        sta     AUDIOTMP2                       ; E772 85 E1
        lda     musicChanNote,x                 ; E774 BD C3 06
        cmp     #$02                            ; E777 C9 02
        beq     @muteAndAdvanceFrame            ; E779 F0 5A
        ldy     #$00                            ; E77B A0 00
@controlMinus1Times2_storeToY:
        dec     AUDIOTMP2                       ; E77D C6 E1
        beq     @loadFromTable                  ; E77F F0 04
        iny                                     ; E781 C8
        iny                                     ; E782 C8
        bne     @controlMinus1Times2_storeToY   ; E783 D0 F8
@loadFromTable:
        lda     musicChanVolControlTable,y      ; E785 B9 4A EA
        sta     AUDIOTMP3                       ; E788 85 E2
        lda     musicChanVolControlTable+1,y    ; E78A B9 4B EA
        sta     AUDIOTMP4                       ; E78D 85 E3
        lda     musicChanVolFrameCounter,x      ; E78F BD CD 06
        lsr     a                               ; E792 4A
        tay                                     ; E793 A8
        lda     (AUDIOTMP3),y                   ; E794 B1 E2
        sta     AUDIOTMP5                       ; E796 85 E4
        cmp     #$FF                            ; E798 C9 FF
        beq     @constVolAtEnd                  ; E79A F0 30
        cmp     #$F0                            ; E79C C9 F0
        beq     @muteAtEnd                      ; E79E F0 31
        lda     musicChanVolFrameCounter,x      ; E7A0 BD CD 06
        and     #$01                            ; E7A3 29 01
        bne     @useNibbleFromTable             ; E7A5 D0 08
        lsr     AUDIOTMP5                       ; E7A7 46 E4
        lsr     AUDIOTMP5                       ; E7A9 46 E4
        lsr     AUDIOTMP5                       ; E7AB 46 E4
        lsr     AUDIOTMP5                       ; E7AD 46 E4
@useNibbleFromTable:
        lda     AUDIOTMP5                       ; E7AF A5 E4
        and     #$0F                            ; E7B1 29 0F
        sta     AUDIOTMP1                       ; E7B3 85 E0
        lda     musicChanVolume,x               ; E7B5 BD 9D 06
        and     #$F0                            ; E7B8 29 F0
        ora     AUDIOTMP1                       ; E7BA 05 E0
        tay                                     ; E7BC A8
@advanceFrameAndSetVol:
        inc     musicChanVolFrameCounter,x      ; E7BD FE CD 06
@setVol:lda     musicChanInhibit,x              ; E7C0 BD C8 06
        bne     @ret                            ; E7C3 D0 06
        tya                                     ; E7C5 98
        ldy     musicChannelOffset              ; E7C6 A4 EE
        sta     SQ1_VOL,y                       ; E7C8 99 00 40
@ret:   rts                                     ; E7CB 60

; ----------------------------------------------------------------------------
@constVolAtEnd:
        ldy     musicChanVolume,x               ; E7CC BC 9D 06
        bne     @setVol                         ; E7CF D0 EF
; Only seems valid for NOISE
@muteAtEnd:
        ldy     #$10                            ; E7D1 A0 10
        bne     @setVol                         ; E7D3 D0 EB
; Only seems valid for NOISE
@muteAndAdvanceFrame:
        ldy     #$10                            ; E7D5 A0 10
        bne     @advanceFrameAndSetVol          ; E7D7 D0 E4
;  
updateMusicFrame_progLoadNextScript:
        iny                                     ; E7D9 C8
        lda     (musicChanTmpAddr),y            ; E7DA B1 E6
        sta     musicDataChanPtr,x              ; E7DC 9D 92 06
        iny                                     ; E7DF C8
        lda     (musicChanTmpAddr),y            ; E7E0 B1 E6
        sta     musicDataChanPtr+1,x            ; E7E2 9D 93 06
        lda     musicDataChanPtr,x              ; E7E5 BD 92 06
        sta     musicChanTmpAddr                ; E7E8 85 E6
        lda     musicDataChanPtr+1,x            ; E7EA BD 93 06
        sta     musicChanTmpAddr+1              ; E7ED 85 E7
        txa                                     ; E7EF 8A
        lsr     a                               ; E7F0 4A
        tax                                     ; E7F1 AA
        lda     #$00                            ; E7F2 A9 00
        tay                                     ; E7F4 A8
        sta     musicDataChanPtrOff,x           ; E7F5 9D A8 06
        jmp     updateMusicFrame_progLoadRoutine; E7F8 4C 18 E8

; ----------------------------------------------------------------------------
updateMusicFrame_progEnd:
        jsr     soundEffectSlot2_makesNoSound   ; E7FB 20 44 E2
updateMusicFrame_ret:
        rts                                     ; E7FE 60

; ----------------------------------------------------------------------------
updateMusicFrame_progNextRoutine:
        txa                                     ; E7FF 8A
        asl     a                               ; E800 0A
        tax                                     ; E801 AA
        lda     musicDataChanPtr,x              ; E802 BD 92 06
        sta     musicChanTmpAddr                ; E805 85 E6
        lda     musicDataChanPtr+1,x            ; E807 BD 93 06
        sta     musicChanTmpAddr+1              ; E80A 85 E7
        txa                                     ; E80C 8A
        lsr     a                               ; E80D 4A
        tax                                     ; E80E AA
        inc     musicDataChanPtrOff,x           ; E80F FE A8 06
        inc     musicDataChanPtrOff,x           ; E812 FE A8 06
        ldy     musicDataChanPtrOff,x           ; E815 BC A8 06
; input musicChanTmpAddr: current channel's musicDataChanPtr. input y: offset. input x: channel number (0-3)
updateMusicFrame_progLoadRoutine:
        txa                                     ; E818 8A
        asl     a                               ; E819 0A
        tax                                     ; E81A AA
        lda     (musicChanTmpAddr),y            ; E81B B1 E6
        sta     musicDataChanPtrDeref,x         ; E81D 9D A0 06
        iny                                     ; E820 C8
        lda     (musicChanTmpAddr),y            ; E821 B1 E6
        sta     musicDataChanPtrDeref+1,x       ; E823 9D A1 06
        cmp     #$00                            ; E826 C9 00
        beq     updateMusicFrame_progEnd        ; E828 F0 D1
        cmp     #$FF                            ; E82A C9 FF
        beq     updateMusicFrame_progLoadNextScript; E82C F0 AB
        txa                                     ; E82E 8A
        lsr     a                               ; E82F 4A
        tax                                     ; E830 AA
        lda     #$00                            ; E831 A9 00
        sta     musicDataChanInstructionOffset,x; E833 9D AC 06
        lda     #$01                            ; E836 A9 01
        sta     musicChanNoteDurationRemaining,x; E838 9D B4 06
        bne     updateMusicFrame_updateChannel  ; E83B D0 1D
;  
updateMusicFrame_progNextRoutine_jmp:
        jmp     updateMusicFrame_progNextRoutine; E83D 4C FF E7

; ----------------------------------------------------------------------------
updateMusicFrame:
        jsr     initSq12IfTrashedBySoundEffect  ; E840 20 35 E7
        lda     #$00                            ; E843 A9 00
        tax                                     ; E845 AA
        sta     musicChannelOffset              ; E846 85 EE
        beq     updateMusicFrame_updateChannel  ; E848 F0 10
; input x: channel number * 2
updateMusicFrame_incSlotFromOffset:
        txa                                     ; E84A 8A
        lsr     a                               ; E84B 4A
        tax                                     ; E84C AA
; input x: channel number (0-3)
updateMusicFrame_incSlot:
        inx                                     ; E84D E8
        txa                                     ; E84E 8A
        cmp     #$04                            ; E84F C9 04
        beq     updateMusicFrame_ret            ; E851 F0 AB
        lda     musicChannelOffset              ; E853 A5 EE
        clc                                     ; E855 18
        adc     #$04                            ; E856 69 04
        sta     musicChannelOffset              ; E858 85 EE
; input x: channel number (0-3)
updateMusicFrame_updateChannel:
        txa                                     ; E85A 8A
        asl     a                               ; E85B 0A
        tax                                     ; E85C AA
        lda     musicDataChanPtrDeref,x         ; E85D BD A0 06
        sta     musicChanTmpAddr                ; E860 85 E6
        lda     musicDataChanPtrDeref+1,x       ; E862 BD A1 06
        sta     musicChanTmpAddr+1              ; E865 85 E7
        lda     musicDataChanPtrDeref+1,x       ; E867 BD A1 06
        cmp     #$FF                            ; E86A C9 FF
        beq     updateMusicFrame_incSlotFromOffset; E86C F0 DC
        txa                                     ; E86E 8A
        lsr     a                               ; E86F 4A
        tax                                     ; E870 AA
        dec     musicChanNoteDurationRemaining,x; E871 DE B4 06
        bne     @updateChannelFrame             ; E874 D0 49
        lda     #$00                            ; E876 A9 00
        sta     musicChanVolFrameCounter,x      ; E878 9D CD 06
        sta     musicChanLoFrameCounter,x       ; E87B 9D D1 06
@processChannelInstruction:
        jsr     musicGetNextInstructionByte     ; E87E 20 41 EA
        beq     updateMusicFrame_progNextRoutine_jmp; E881 F0 BA
        cmp     #$9F                            ; E883 C9 9F
        beq     @setControlAndVolume            ; E885 F0 47
        cmp     #$9E                            ; E887 C9 9E
        beq     @setDurationOffset              ; E889 F0 5B
        cmp     #$9C                            ; E88B C9 9C
        beq     @setNoteOffset                  ; E88D F0 60
        tay                                     ; E88F A8
        cmp     #$FF                            ; E890 C9 FF
        beq     @endLoop                        ; E892 F0 09
        and     #$C0                            ; E894 29 C0
        cmp     #$C0                            ; E896 C9 C0
        beq     @startForLoop                   ; E898 F0 13
        jmp     @noteAndMaybeDuration           ; E89A 4C F8 E8

; ----------------------------------------------------------------------------
@endLoop:
        lda     musicChanProgLoopCounter,x      ; E89D BD BC 06
        beq     @processChannelInstruction_jmp  ; E8A0 F0 1A
        dec     musicChanProgLoopCounter,x      ; E8A2 DE BC 06
        lda     musicDataChanInstructionOffsetBackup,x; E8A5 BD B0 06
        sta     musicDataChanInstructionOffset,x; E8A8 9D AC 06
        bne     @processChannelInstruction_jmp  ; E8AB D0 0F
; Low 6 bits are number of times to run loop (1 == run code once)
@startForLoop:
        tya                                     ; E8AD 98
        and     #$3F                            ; E8AE 29 3F
        sta     musicChanProgLoopCounter,x      ; E8B0 9D BC 06
        dec     musicChanProgLoopCounter,x      ; E8B3 DE BC 06
        lda     musicDataChanInstructionOffset,x; E8B6 BD AC 06
        sta     musicDataChanInstructionOffsetBackup,x; E8B9 9D B0 06
@processChannelInstruction_jmp:
        jmp     @processChannelInstruction      ; E8BC 4C 7E E8

; ----------------------------------------------------------------------------
@updateChannelFrame:
        jsr     updateMusicFrame_setChanVol     ; E8BF 20 66 E7
        jsr     updateMusicFrame_setChanLo      ; E8C2 20 D0 E5
        jmp     updateMusicFrame_incSlot        ; E8C5 4C 4D E8

; ----------------------------------------------------------------------------
@playDmcAndNoise_jmp:
        jmp     @playDmcAndNoise                ; E8C8 4C DC E9

; ----------------------------------------------------------------------------
@applyDurationForTri_jmp:
        jmp     @applyDurationForTri            ; E8CB 4C B2 E9

; ----------------------------------------------------------------------------
@setControlAndVolume:
        jsr     musicGetNextInstructionByte     ; E8CE 20 41 EA
        sta     musicChanControl,x              ; E8D1 9D 9A 06
        jsr     musicGetNextInstructionByte     ; E8D4 20 41 EA
        sta     musicChanVolume,x               ; E8D7 9D 9D 06
        jmp     @processChannelInstruction      ; E8DA 4C 7E E8

; ----------------------------------------------------------------------------
@unreferenced_code3:
        jsr     musicGetNextInstructionByte     ; E8DD 20 41 EA
        jsr     musicGetNextInstructionByte     ; E8E0 20 41 EA
        jmp     @processChannelInstruction      ; E8E3 4C 7E E8

; ----------------------------------------------------------------------------
@setDurationOffset:
        jsr     musicGetNextInstructionByte     ; E8E6 20 41 EA
        sta     musicDataDurationTableOffset    ; E8E9 8D 91 06
        jmp     @processChannelInstruction      ; E8EC 4C 7E E8

; ----------------------------------------------------------------------------
@setNoteOffset:
        jsr     musicGetNextInstructionByte     ; E8EF 20 41 EA
        sta     musicDataNoteTableOffset        ; E8F2 8D 90 06
        jmp     @processChannelInstruction      ; E8F5 4C 7E E8

; ----------------------------------------------------------------------------
; Duration, if present, is first
@noteAndMaybeDuration:
        tya                                     ; E8F8 98
        and     #$B0                            ; E8F9 29 B0
        cmp     #$B0                            ; E8FB C9 B0
        bne     @processNote                    ; E8FD D0 18
        tya                                     ; E8FF 98
        and     #$0F                            ; E900 29 0F
        clc                                     ; E902 18
        adc     musicDataDurationTableOffset    ; E903 6D 91 06
        tay                                     ; E906 A8
        lda     noteDurationTable,y             ; E907 B9 AF EB
        sta     musicChanNoteDuration,x         ; E90A 9D B8 06
        tay                                     ; E90D A8
        txa                                     ; E90E 8A
        cmp     #$02                            ; E90F C9 02
        beq     @applyDurationForTri_jmp        ; E911 F0 B8
@loadNextAsNote:
        jsr     musicGetNextInstructionByte     ; E913 20 41 EA
        tay                                     ; E916 A8
@processNote:
        tya                                     ; E917 98
        sta     musicChanNote,x                 ; E918 9D C3 06
        txa                                     ; E91B 8A
        cmp     #$03                            ; E91C C9 03
        beq     @playDmcAndNoise_jmp            ; E91E F0 A8
        pha                                     ; E920 48
        ldx     musicChannelOffset              ; E921 A6 EE
        lda     noteToWaveTable+1,y             ; E923 B9 14 EB
        beq     @determineVolume                ; E926 F0 24
        lda     musicDataNoteTableOffset        ; E928 AD 90 06
        bpl     @signMagnitudeIsPositive        ; E92B 10 0B
        and     #$7F                            ; E92D 29 7F
        sta     AUDIOTMP4                       ; E92F 85 E3
        tya                                     ; E931 98
        clc                                     ; E932 18
        sbc     AUDIOTMP4                       ; E933 E5 E3
        jmp     @noteOffsetApplied              ; E935 4C 3D E9

; ----------------------------------------------------------------------------
@signMagnitudeIsPositive:
        tya                                     ; E938 98
        clc                                     ; E939 18
        adc     musicDataNoteTableOffset        ; E93A 6D 90 06
@noteOffsetApplied:
        tay                                     ; E93D A8
        lda     noteToWaveTable+1,y             ; E93E B9 14 EB
        sta     musicStagingSq1Lo,x             ; E941 9D 80 06
        lda     noteToWaveTable,y               ; E944 B9 13 EB
        ora     #$08                            ; E947 09 08
        sta     musicStagingSq1Hi,x             ; E949 9D 81 06
; Complicated way to determine if we skipped setting lo/hi, maybe because of the needed pla. If we set lo/hi (by falling through from above), then we'll go to @loadVolume. If we jmp'ed here, then we'll end up muting the volume
@determineVolume:
        tay                                     ; E94C A8
        pla                                     ; E94D 68
        tax                                     ; E94E AA
        tya                                     ; E94F 98
        bne     @loadVolume                     ; E950 D0 0F
        lda     #$00                            ; E952 A9 00
        sta     AUDIOTMP1                       ; E954 85 E0
        txa                                     ; E956 8A
        cmp     #$02                            ; E957 C9 02
        beq     @checkChanControl               ; E959 F0 0B
        lda     #$10                            ; E95B A9 10
        sta     AUDIOTMP1                       ; E95D 85 E0
        bne     @checkChanControl               ; E95F D0 05
;  
@loadVolume:
        lda     musicChanVolume,x               ; E961 BD 9D 06
        sta     AUDIOTMP1                       ; E964 85 E0
; If any of 5 low bits of control is non-zero, then mute
@checkChanControl:
        txa                                     ; E966 8A
        dec     musicChanInhibit,x              ; E967 DE C8 06
        cmp     musicChanInhibit,x              ; E96A DD C8 06
        beq     @channelInhibited               ; E96D F0 3D
        inc     musicChanInhibit,x              ; E96F FE C8 06
        ldy     musicChannelOffset              ; E972 A4 EE
        txa                                     ; E974 8A
        cmp     #$02                            ; E975 C9 02
        beq     @useDirectVolume                ; E977 F0 13
        lda     musicChanControl,x              ; E979 BD 9A 06
        and     #$1F                            ; E97C 29 1F
        beq     @useDirectVolume                ; E97E F0 0C
        lda     AUDIOTMP1                       ; E980 A5 E0
        cmp     #$10                            ; E982 C9 10
        beq     @setMmio                        ; E984 F0 08
        and     #$F0                            ; E986 29 F0
        ora     #$00                            ; E988 09 00
        bne     @setMmio                        ; E98A D0 02
@useDirectVolume:
        lda     AUDIOTMP1                       ; E98C A5 E0
@setMmio:
        sta     SQ1_VOL,y                       ; E98E 99 00 40
        lda     musicStagingSq1Sweep,x          ; E991 BD C0 06
        sta     SQ1_SWEEP,y                     ; E994 99 01 40
        lda     musicStagingSq1Lo,y             ; E997 B9 80 06
        sta     SQ1_LO,y                        ; E99A 99 02 40
        lda     musicStagingSq1Hi,y             ; E99D B9 81 06
        sta     SQ1_HI,y                        ; E9A0 99 03 40
@copyDurationToRemaining:
        lda     musicChanNoteDuration,x         ; E9A3 BD B8 06
        sta     musicChanNoteDurationRemaining,x; E9A6 9D B4 06
        jmp     updateMusicFrame_incSlot        ; E9A9 4C 4D E8

; ----------------------------------------------------------------------------
@channelInhibited:
        inc     musicChanInhibit,x              ; E9AC FE C8 06
        jmp     @copyDurationToRemaining        ; E9AF 4C A3 E9

; ----------------------------------------------------------------------------
; input y: duration of 60Hz frames. TRI has no volume control. The volume MMIO for TRI goes to a linear counter. While the length counter can be disabled, that doesn't appear possible for the linear counter.
@applyDurationForTri:
        lda     musicChanControl+2              ; E9B2 AD 9C 06
        and     #$1F                            ; E9B5 29 1F
        bne     @setTriVolume                   ; E9B7 D0 1D
        lda     musicChanControl+2              ; E9B9 AD 9C 06
        and     #$C0                            ; E9BC 29 C0
        bne     @highCtrlImpliesOn              ; E9BE D0 03
@useDuration:
        tya                                     ; E9C0 98
        bne     @durationToLinearClock          ; E9C1 D0 08
@highCtrlImpliesOn:
        cmp     #$C0                            ; E9C3 C9 C0
        beq     @useDuration                    ; E9C5 F0 F9
        lda     #$FF                            ; E9C7 A9 FF
        bne     @setTriVolume                   ; E9C9 D0 0B
; Not quite clear what the -1 is for. Times 4 because the linear clock counts quarter frames
@durationToLinearClock:
        clc                                     ; E9CB 18
        adc     #$FF                            ; E9CC 69 FF
        asl     a                               ; E9CE 0A
        asl     a                               ; E9CF 0A
        cmp     #$3C                            ; E9D0 C9 3C
        bcc     @setTriVolume                   ; E9D2 90 02
        lda     #$3C                            ; E9D4 A9 3C
@setTriVolume:
        sta     musicChanVolume+2               ; E9D6 8D 9F 06
        jmp     @loadNextAsNote                 ; E9D9 4C 13 E9

; ----------------------------------------------------------------------------
@playDmcAndNoise:
        tya                                     ; E9DC 98
        pha                                     ; E9DD 48
        jsr     playDmc                         ; E9DE 20 03 EA
        pla                                     ; E9E1 68
        and     #$3F                            ; E9E2 29 3F
        tay                                     ; E9E4 A8
        jsr     playNoise                       ; E9E5 20 EB E9
        jmp     @copyDurationToRemaining        ; E9E8 4C A3 E9

; ----------------------------------------------------------------------------
; Weird that it references slot 0. Slot 3 would make most sense as NOISE channel and slot 1 would make sense if the point was to avoid noise during a sound effect. But slot 0 isn't used very often
playNoise:
        lda     soundEffectSlot0Playing         ; E9EB AD F8 06
        bne     @ret                            ; E9EE D0 12
        lda     noises_table,y                  ; E9F0 B9 AB E5
        sta     NOISE_VOL                       ; E9F3 8D 0C 40
        lda     noises_table+1,y                ; E9F6 B9 AC E5
        sta     NOISE_LO                        ; E9F9 8D 0E 40
        lda     noises_table+2,y                ; E9FC B9 AD E5
        sta     NOISE_HI                        ; E9FF 8D 0F 40
@ret:   rts                                     ; EA02 60

; ----------------------------------------------------------------------------
playDmc:tya                                     ; EA03 98
        and     #$C0                            ; EA04 29 C0
        cmp     #$40                            ; EA06 C9 40
        beq     @loadDmc0                       ; EA08 F0 05
        cmp     #$80                            ; EA0A C9 80
        beq     @loadDmc1                       ; EA0C F0 0B
        rts                                     ; EA0E 60

; ----------------------------------------------------------------------------
; dmc0
@loadDmc0:
        lda     #$0E                            ; EA0F A9 0E
        sta     AUDIOTMP2                       ; EA11 85 E1
        lda     #$07                            ; EA13 A9 07
        ldy     #$00                            ; EA15 A0 00
        beq     @loadIntoDmc                    ; EA17 F0 08
; dmc1
@loadDmc1:
        lda     #$0E                            ; EA19 A9 0E
        sta     AUDIOTMP2                       ; EA1B 85 E1
        lda     #$0F                            ; EA1D A9 0F
        ldy     #$02                            ; EA1F A0 02
; Note that bit 4 in SND_CHN is 0. That disables DMC. It enables all channels but DMC
@loadIntoDmc:
        sta     DMC_LEN                         ; EA21 8D 13 40
        sty     DMC_START                       ; EA24 8C 12 40
        lda     musicDmcGapless                 ; EA27 AD F7 06
        bne     @ret                            ; EA2A D0 14
        lda     AUDIOTMP2                       ; EA2C A5 E1
        sta     DMC_FREQ                        ; EA2E 8D 10 40
        lda     #$0F                            ; EA31 A9 0F
        sta     SND_CHN                         ; EA33 8D 15 40
        lda     #$00                            ; EA36 A9 00
        sta     DMC_RAW                         ; EA38 8D 11 40
        lda     #$1F                            ; EA3B A9 1F
        sta     SND_CHN                         ; EA3D 8D 15 40
@ret:   rts                                     ; EA40 60

; ----------------------------------------------------------------------------
; input x: music channel. output a: next value
musicGetNextInstructionByte:
        ldy     musicDataChanInstructionOffset,x; EA41 BC AC 06
        inc     musicDataChanInstructionOffset,x; EA44 FE AC 06
        lda     (musicChanTmpAddr),y            ; EA47 B1 E6
        rts                                     ; EA49 60

; ----------------------------------------------------------------------------
musicChanVolControlTable:
        .addr   LEA76                           ; EA4A 76 EA
        .addr   LEA82                           ; EA4C 82 EA
        .addr   LEA8B                           ; EA4E 8B EA
        .addr   LEA91                           ; EA50 91 EA
        .addr   LEA9A                           ; EA52 9A EA
        .addr   LEAA2                           ; EA54 A2 EA
        .addr   LEAA5                           ; EA56 A5 EA
        .addr   LEAA8                           ; EA58 A8 EA
        .addr   LEAAC                           ; EA5A AC EA
        .addr   LEABA                           ; EA5C BA EA
        .addr   LEAC7                           ; EA5E C7 EA
        .addr   LEAD4                           ; EA60 D4 EA
        .addr   LEADE                           ; EA62 DE EA
        .addr   LEAE8                           ; EA64 E8 EA
        .addr   LEAF2                           ; EA66 F2 EA
        .addr   LEAF7                           ; EA68 F7 EA
        .addr   LEAFC                           ; EA6A FC EA
        .addr   LEB01                           ; EA6C 01 EB
        .addr   LEB05                           ; EA6E 05 EB
        .addr   LEB0A                           ; EA70 0A EB
        .addr   LEB0D                           ; EA72 0D EB
        .addr   LEB10                           ; EA74 10 EB
; ----------------------------------------------------------------------------
LEA76:  .byte   $46,$89,$87,$76,$66,$55,$44,$33 ; EA76 46 89 87 76 66 55 44 33
        .byte   $22,$21,$11,$F0                 ; EA7E 22 21 11 F0
LEA82:  .byte   $86,$55,$44,$44,$31,$11,$11,$11 ; EA82 86 55 44 44 31 11 11 11
        .byte   $F0                             ; EA8A F0
LEA8B:  .byte   $54,$43,$33,$22,$11,$F0         ; EA8B 54 43 33 22 11 F0
LEA91:  .byte   $23,$45,$77,$66,$55,$44,$44,$44 ; EA91 23 45 77 66 55 44 44 44
        .byte   $FF                             ; EA99 FF
LEA9A:  .byte   $32,$22,$22,$22,$22,$22,$22,$FF ; EA9A 32 22 22 22 22 22 22 FF
LEAA2:  .byte   $99,$81,$FF                     ; EAA2 99 81 FF
LEAA5:  .byte   $58,$71,$FF                     ; EAA5 58 71 FF
LEAA8:  .byte   $E7,$99,$81,$FF                 ; EAA8 E7 99 81 FF
LEAAC:  .byte   $A8,$66,$55,$54,$43,$43,$32,$22 ; EAAC A8 66 55 54 43 43 32 22
        .byte   $22,$21,$11,$11,$11,$F0         ; EAB4 22 21 11 11 11 F0
LEABA:  .byte   $97,$65,$44,$33,$33,$33,$22,$22 ; EABA 97 65 44 33 33 33 22 22
        .byte   $11,$11,$11,$11,$F0             ; EAC2 11 11 11 11 F0
LEAC7:  .byte   $65,$44,$44,$33,$22,$22,$11,$11 ; EAC7 65 44 44 33 22 22 11 11
        .byte   $11,$11,$11,$11,$F0             ; EACF 11 11 11 11 F0
LEAD4:  .byte   $44,$33,$22,$22,$11,$11,$11,$11 ; EAD4 44 33 22 22 11 11 11 11
        .byte   $11,$F0                         ; EADC 11 F0
LEADE:  .byte   $22,$22,$11,$11,$11,$11,$11,$11 ; EADE 22 22 11 11 11 11 11 11
        .byte   $11,$F0                         ; EAE6 11 F0
LEAE8:  .byte   $97,$65,$32,$43,$21,$11,$32,$21 ; EAE8 97 65 32 43 21 11 32 21
        .byte   $11,$FF                         ; EAF0 11 FF
LEAF2:  .byte   $D8,$76,$54,$32,$FF             ; EAF2 D8 76 54 32 FF
LEAF7:  .byte   $B8,$76,$53,$21,$FF             ; EAF7 B8 76 53 21 FF
LEAFC:  .byte   $85,$43,$21,$11,$FF             ; EAFC 85 43 21 11 FF
LEB01:  .byte   $53,$22,$11,$FF                 ; EB01 53 22 11 FF
LEB05:  .byte   $EB,$97,$53,$21,$FF             ; EB05 EB 97 53 21 FF
LEB0A:  .byte   $A9,$91,$F0                     ; EB0A A9 91 F0
LEB0D:  .byte   $85,$51,$F0                     ; EB0D 85 51 F0
LEB10:  .byte   $63,$31,$F0                     ; EB10 63 31 F0
; ----------------------------------------------------------------------------
; Rounds slightly differently, but can use for reference: https://web.archive.org/web/20180315161431if_/http://www.freewebs.com:80/the_bott/NotesTableNTSC.txt
noteToWaveTable:
        .dbyt   $07F0,$0000,$06AE,$064E         ; EB13 07 F0 00 00 06 AE 06 4E
        .dbyt   $05F3,$059E,$054D,$0501         ; EB1B 05 F3 05 9E 05 4D 05 01
        .dbyt   $04B9,$0475,$0435,$03F8         ; EB23 04 B9 04 75 04 35 03 F8
        .dbyt   $03BF,$0389,$0357,$0327         ; EB2B 03 BF 03 89 03 57 03 27
        .dbyt   $02F9,$02CF,$02A6,$0280         ; EB33 02 F9 02 CF 02 A6 02 80
        .dbyt   $025C,$023A,$021A,$01FC         ; EB3B 02 5C 02 3A 02 1A 01 FC
        .dbyt   $01DF,$01C4,$01AB,$0193         ; EB43 01 DF 01 C4 01 AB 01 93
        .dbyt   $017C,$0167,$0152,$013F         ; EB4B 01 7C 01 67 01 52 01 3F
        .dbyt   $012D,$011C,$010C,$00FD         ; EB53 01 2D 01 1C 01 0C 00 FD
        .dbyt   $00EE,$00E1,$00D4,$00C8         ; EB5B 00 EE 00 E1 00 D4 00 C8
        .dbyt   $00BD,$00B2,$00A8,$009F         ; EB63 00 BD 00 B2 00 A8 00 9F
        .dbyt   $0096,$008D,$0085,$007E         ; EB6B 00 96 00 8D 00 85 00 7E
        .dbyt   $0076,$0070,$0069,$0063         ; EB73 00 76 00 70 00 69 00 63
        .dbyt   $005E,$0058,$0053,$004F         ; EB7B 00 5E 00 58 00 53 00 4F
        .dbyt   $004A,$0046,$0042,$003E         ; EB83 00 4A 00 46 00 42 00 3E
        .dbyt   $003A,$0037,$0034,$0031         ; EB8B 00 3A 00 37 00 34 00 31
        .dbyt   $002E,$002B,$0029,$0027         ; EB93 00 2E 00 2B 00 29 00 27
        .dbyt   $0001,$0024,$0022,$0020         ; EB9B 00 01 00 24 00 22 00 20
        .dbyt   $001E,$001C,$001A,$000A         ; EBA3 00 1E 00 1C 00 1A 00 0A
        .dbyt   $0010,$0019                     ; EBAB 00 10 00 19
; ----------------------------------------------------------------------------
noteDurationTable:
        .byte   $03,$06,$0C,$18,$30,$12,$24,$09 ; EBAF 03 06 0C 18 30 12 24 09
        .byte   $08,$04,$02,$01,$04,$08,$10,$20 ; EBB7 08 04 02 01 04 08 10 20
        .byte   $40,$18,$30,$0C,$0A,$05,$02,$01 ; EBBF 40 18 30 0C 0A 05 02 01
        .byte   $05,$0A,$14,$28,$50,$1E,$3C,$0F ; EBC7 05 0A 14 28 50 1E 3C 0F
        .byte   $0D,$06,$02,$01,$06,$0C,$18,$30 ; EBCF 0D 06 02 01 06 0C 18 30
        .byte   $60,$24,$48,$12,$10,$08,$03,$01 ; EBD7 60 24 48 12 10 08 03 01
        .byte   $04,$02,$00,$90,$07,$0E,$1C,$38 ; EBDF 04 02 00 90 07 0E 1C 38
        .byte   $70,$2A,$54,$15,$12,$09,$03,$01 ; EBE7 70 2A 54 15 12 09 03 01
        .byte   $02,$08,$10,$20,$40,$80,$30,$60 ; EBEF 02 08 10 20 40 80 30 60
        .byte   $18,$15,$0A,$04,$01,$02,$C0,$09 ; EBF7 18 15 0A 04 01 02 C0 09
        .byte   $12,$24,$48,$90,$36,$6C,$1B,$18 ; EBFF 12 24 48 90 36 6C 1B 18
        .byte   $0A,$14,$28,$50,$A0,$3C,$78,$1E ; EC07 0A 14 28 50 A0 3C 78 1E
        .byte   $1A,$0D,$05,$01,$02,$17,$0B,$16 ; EC0F 1A 0D 05 01 02 17 0B 16
        .byte   $2C,$58,$B0,$42,$84,$21,$1D,$0E ; EC17 2C 58 B0 42 84 21 1D 0E
        .byte   $05,$01,$02,$17                 ; EC1F 05 01 02 17
musicDataTableIndex:
        .byte   $00,$0A,$14,$1E,$28,$32,$3C,$46 ; EC23 00 0A 14 1E 28 32 3C 46
        .byte   $50,$5A                         ; EC2B 50 5A
musicDataTable:
        .byte   $0A,$24                         ; EC2D 0A 24
; ----------------------------------------------------------------------------
        .addr   music_titleScreen_sq1Script     ; EC2F F1 EC
        .addr   music_titleScreen_sq2Script     ; EC31 F5 EC
        .addr   music_titleScreen_triScript     ; EC33 F7 EC
        .addr   music_titleScreen_noiseScript   ; EC35 F9 EC
; ----------------------------------------------------------------------------
        .byte   $83,$00                         ; EC37 83 00
; ----------------------------------------------------------------------------
        .addr   music_bTypeGoalAchieved_sq1Script; EC39 91 EC
        .addr   music_bTypeGoalAchieved_sq2Script; EC3B 95 EC
        .addr   music_bTypeGoalAchieved_triScript; EC3D 97 EC
        .addr   music_bTypeGoalAchieved_noiseScript; EC3F 99 EC
; ----------------------------------------------------------------------------
        .byte   $81,$24                         ; EC41 81 24
; ----------------------------------------------------------------------------
        .addr   music_music1_sq1Script          ; EC43 BF EE
        .addr   music_music1_sq2Script          ; EC45 C9 EE
        .addr   music_music1_triScript          ; EC47 D3 EE
        .addr   music_music1_noiseScript        ; EC49 DD EE
; ----------------------------------------------------------------------------
        .byte   $83,$24                         ; EC4B 83 24
; ----------------------------------------------------------------------------
        .addr   music_music2_sq1Script          ; EC4D C2 F5
        .addr   music_music2_sq2Script          ; EC4F D0 F5
        .addr   music_music2_triScript          ; EC51 DE F5
        .addr   music_music2_noiseScript        ; EC53 EC F5
; ----------------------------------------------------------------------------
        .byte   $81,$24                         ; EC55 81 24
; ----------------------------------------------------------------------------
        .addr   music_music3_sq1Script          ; EC57 B1 F2
        .addr   music_music3_sq2Script          ; EC59 B9 F2
        .addr   music_music3_triScript          ; EC5B BF F2
        .addr   LFFFF                           ; EC5D FF FF
; ----------------------------------------------------------------------------
        .byte   $81,$00                         ; EC5F 81 00
; ----------------------------------------------------------------------------
        .addr   music_music1_sq1Script          ; EC61 BF EE
        .addr   music_music1_sq2Script          ; EC63 C9 EE
        .addr   music_music1_triScript          ; EC65 D3 EE
        .addr   music_music1_noiseScript        ; EC67 DD EE
; ----------------------------------------------------------------------------
        .byte   $83,$0C                         ; EC69 83 0C
; ----------------------------------------------------------------------------
        .addr   music_music2_sq1Script          ; EC6B C2 F5
        .addr   music_music2_sq2Script          ; EC6D D0 F5
        .addr   music_music2_triScript          ; EC6F DE F5
        .addr   music_music2_noiseScript        ; EC71 EC F5
; ----------------------------------------------------------------------------
        .byte   $81,$0C                         ; EC73 81 0C
; ----------------------------------------------------------------------------
        .addr   music_music3_sq1Script          ; EC75 B1 F2
        .addr   music_music3_sq2Script          ; EC77 B9 F2
        .addr   music_music3_triScript          ; EC79 BF F2
        .addr   LFFFF                           ; EC7B FF FF
; ----------------------------------------------------------------------------
        .byte   $00,$18                         ; EC7D 00 18
; ----------------------------------------------------------------------------
        .addr   music_congratulations_sq1Script ; EC7F A4 F3
        .addr   music_congratulations_sq2Script ; EC81 AA F3
        .addr   music_congratulations_triScript ; EC83 B0 F3
        .addr   music_congratulations_noiseScript; EC85 B6 F3
; ----------------------------------------------------------------------------
        .byte   $8F,$24                         ; EC87 8F 24
; ----------------------------------------------------------------------------
        .addr   music_endings_sq1Script         ; EC89 9E F8
        .addr   music_endings_sq2Script         ; EC8B AA F8
        .addr   music_endings_triScript         ; EC8D B6 F8
        .addr   music_endings_noiseScript       ; EC8F C2 F8
music_bTypeGoalAchieved_sq1Script:
        .addr   music_bTypeGoalAchieved_sq1Routine1; EC91 9B EC
        .addr   tmp1                            ; EC93 00 00
music_bTypeGoalAchieved_sq2Script:
        .addr   music_bTypeGoalAchieved_triRoutine1; EC95 C7 EC
music_bTypeGoalAchieved_triScript:
        .addr   music_bTypeGoalAchieved_sq2Routine1; EC97 B1 EC
music_bTypeGoalAchieved_noiseScript:
        .addr   music_bTypeGoalAchieved_noiseRoutine1; EC99 DD EC
; ----------------------------------------------------------------------------
music_bTypeGoalAchieved_sq1Routine1:
        .byte   $9F,$A4,$B3,$B1,$50,$02,$50,$B5 ; EC9B 9F A4 B3 B1 50 02 50 B5
        .byte   $54,$B1,$5A,$58,$50,$B5,$54,$B1 ; ECA3 54 B1 5A 58 50 B5 54 B1
        .byte   $5A,$5E,$60,$B4,$62,$00         ; ECAB 5A 5E 60 B4 62 00
music_bTypeGoalAchieved_sq2Routine1:
        .byte   $9F,$A0,$00,$B1,$4A,$02,$4A,$B5 ; ECB1 9F A0 00 B1 4A 02 4A B5
        .byte   $4E,$B1,$50,$50,$46,$B5,$4E,$B1 ; ECB9 4E B1 50 50 46 B5 4E B1
        .byte   $50,$54,$56,$B4,$5C,$00         ; ECC1 50 54 56 B4 5C 00
music_bTypeGoalAchieved_triRoutine1:
        .byte   $9F,$A4,$B3,$B1,$42,$02,$42,$B5 ; ECC7 9F A4 B3 B1 42 02 42 B5
        .byte   $46,$B1,$4A,$46,$40,$B5,$46,$B1 ; ECCF 46 B1 4A 46 40 B5 46 B1
        .byte   $4A,$4C,$50,$B4,$54,$00         ; ECD7 4A 4C 50 B4 54 00
music_bTypeGoalAchieved_noiseRoutine1:
        .byte   $B1,$04,$01,$04,$B5,$04,$B1,$04 ; ECDD B1 04 01 04 B5 04 B1 04
        .byte   $04,$04,$B5,$04,$B1,$04,$04,$04 ; ECE5 04 04 B5 04 B1 04 04 04
        .byte   $E0,$B0,$04,$FF                 ; ECED E0 B0 04 FF
; ----------------------------------------------------------------------------
music_titleScreen_sq1Script:
        .addr   music_titleScreen_sq1Routine1   ; ECF1 FF EC
        .addr   tmp1                            ; ECF3 00 00
music_titleScreen_sq2Script:
        .addr   music_titleScreen_sq2Routine1   ; ECF5 6F ED
music_titleScreen_triScript:
        .addr   music_titleScreen_triRoutine1   ; ECF7 E2 ED
music_titleScreen_noiseScript:
        .addr   music_titleScreen_noiseRoutine1 ; ECF9 6F EE
        .addr   LFFFF                           ; ECFB FF FF
        .addr   music_titleScreen_noiseScript   ; ECFD F9 EC
; ----------------------------------------------------------------------------
music_titleScreen_sq1Routine1:
        .byte   $9F,$14,$B1,$B9,$02,$02,$42,$B2 ; ECFF 9F 14 B1 B9 02 02 42 B2
        .byte   $5A,$42,$46,$4A,$4C,$50,$54,$B3 ; ED07 5A 42 46 4A 4C 50 54 B3
        .byte   $56,$B8,$56,$56,$56,$B4,$54,$B9 ; ED0F 56 B8 56 56 56 B4 54 B9
        .byte   $02,$02,$B2,$5E,$B9,$02,$B2,$46 ; ED17 02 02 B2 5E B9 02 B2 46
        .byte   $4A,$B2,$4C,$4A,$4C,$4E,$B9,$50 ; ED1F 4A B2 4C 4A 4C 4E B9 50
        .byte   $02,$9F,$15,$B1,$B9,$70,$B6,$02 ; ED27 02 9F 15 B1 B9 70 B6 02
        .byte   $B2,$40,$B8,$02,$28,$02,$B2,$02 ; ED2F B2 40 B8 02 28 02 B2 02
        .byte   $9F,$14,$B1,$B9,$02,$02,$42,$B2 ; ED37 9F 14 B1 B9 02 02 42 B2
        .byte   $5A,$42,$46,$4A,$4C,$50,$54,$B3 ; ED3F 5A 42 46 4A 4C 50 54 B3
        .byte   $54,$B8,$54,$54,$54,$B4,$4C,$B9 ; ED47 54 B8 54 54 54 B4 4C B9
        .byte   $02,$02,$B2,$56,$B9,$02,$B2,$54 ; ED4F 02 02 B2 56 B9 02 B2 54
        .byte   $4C,$B2,$54,$50,$46,$4A,$B1,$02 ; ED57 4C B2 54 50 46 4A B1 02
        .byte   $B5,$2E,$B8,$2A,$B9,$28,$B8,$26 ; ED5F B5 2E B8 2A B9 28 B8 26
        .byte   $B9,$24,$B2,$02,$04,$B3,$02,$00 ; ED67 B9 24 B2 02 04 B3 02 00
music_titleScreen_sq2Routine1:
        .byte   $9F,$15,$B1,$B9,$02,$02,$3C,$B2 ; ED6F 9F 15 B1 B9 02 02 3C B2
        .byte   $54,$3C,$3C,$44,$44,$4A,$4E,$B3 ; ED77 54 3C 3C 44 44 4A 4E B3
        .byte   $4E,$B8,$4E,$46,$4E,$B4,$4E,$B9 ; ED7F 4E B8 4E 46 4E B4 4E B9
        .byte   $02,$02,$B2,$56,$B9,$02,$B2,$3E ; ED87 02 02 B2 56 B9 02 B2 3E
        .byte   $4A,$B2,$46,$44,$46,$48,$B9,$3E ; ED8F 4A B2 46 44 46 48 B9 3E
        .byte   $02,$9F,$15,$B1,$B9,$72,$B2,$02 ; ED97 02 9F 15 B1 B9 72 B2 02
        .byte   $5A,$02,$B9,$42,$02,$02,$02,$02 ; ED9F 5A 02 B9 42 02 02 02 02
        .byte   $2A,$B3,$02,$9F,$15,$B1,$B9,$02 ; EDA7 2A B3 02 9F 15 B1 B9 02
        .byte   $02,$3C,$B2,$54,$3C,$3C,$44,$44 ; EDAF 02 3C B2 54 3C 3C 44 44
        .byte   $4A,$4E,$B3,$4C,$B8,$4C,$4C,$4C ; EDB7 4A 4E B3 4C B8 4C 4C 4C
        .byte   $B4,$46,$B9,$02,$02,$B2,$46,$B9 ; EDBF B4 46 B9 02 02 B2 46 B9
        .byte   $02,$B2,$42,$3C,$B2,$42,$3E,$3E ; EDC7 02 B2 42 3C B2 42 3E 3E
        .byte   $38,$B1,$02,$B5,$34,$B8,$34,$B9 ; EDCF 38 B1 02 B5 34 B8 34 B9
        .byte   $34,$B8,$34,$B9,$34,$B2,$02,$1C ; EDD7 34 B8 34 B9 34 B2 02 1C
        .byte   $B3,$02,$00                     ; EDDF B3 02 00
music_titleScreen_triRoutine1:
        .byte   $9F,$00,$00,$B1,$34,$02,$B8,$34 ; EDE2 9F 00 00 B1 34 02 B8 34
        .byte   $B9,$2A,$B1,$34,$02,$36,$02,$38 ; EDEA B9 2A B1 34 02 36 02 38
        .byte   $02,$3C,$02,$3E,$02,$40,$02,$42 ; EDF2 02 3C 02 3E 02 40 02 42
        .byte   $02,$B2,$02,$B8,$42,$42,$42,$B8 ; EDFA 02 B2 02 B8 42 42 42 B8
        .byte   $46,$B9,$46,$B1,$42,$02,$B8,$3E ; EE02 46 B9 46 B1 42 02 B8 3E
        .byte   $B9,$2E,$B1,$3C,$02,$38,$02,$38 ; EE0A B9 2E B1 3C 02 38 02 38
        .byte   $02,$B8,$38,$B9,$38,$B1,$3C,$02 ; EE12 02 B8 38 B9 38 B1 3C 02
        .byte   $3E,$02,$3C,$02,$3E,$02,$40,$02 ; EE1A 3E 02 3C 02 3E 02 40 02
        .byte   $42,$02,$B6,$02,$B4,$02,$B1,$34 ; EE22 42 02 B6 02 B4 02 B1 34
        .byte   $02,$34,$02,$34,$02,$36,$02,$38 ; EE2A 02 34 02 34 02 36 02 38
        .byte   $02,$3C,$02,$3E,$02,$3E,$02,$B3 ; EE32 02 3C 02 3E 02 3E 02 B3
        .byte   $40,$B8,$40,$40,$40,$B1,$40,$B5 ; EE3A 40 B8 40 40 40 B1 40 B5
        .byte   $3E,$B8,$3C,$B9,$38,$B1,$34,$02 ; EE42 3E B8 3C B9 38 B1 34 02
        .byte   $38,$02,$38,$02,$3C,$02,$3E,$02 ; EE4A 38 02 38 02 3C 02 3E 02
        .byte   $42,$02,$42,$02,$42,$02,$42,$02 ; EE52 42 02 42 02 42 02 42 02
        .byte   $9F,$00,$00,$B1,$02,$B5,$3E,$B8 ; EE5A 9F 00 00 B1 02 B5 3E B8
        .byte   $3C,$B9,$3A,$B8,$38,$B9,$34,$B2 ; EE62 3C B9 3A B8 38 B9 34 B2
        .byte   $02,$1C,$02,$02,$00             ; EE6A 02 1C 02 02 00
music_titleScreen_noiseRoutine1:
        .byte   $C6,$B9,$04,$01,$04,$B2,$07,$B9 ; EE6F C6 B9 04 01 04 B2 07 B9
        .byte   $04,$04,$04,$B2,$07,$FF,$C4,$B9 ; EE77 04 04 04 B2 07 FF C4 B9
        .byte   $04,$01,$04,$07,$01,$04,$FF,$C2 ; EE7F 04 01 04 07 01 04 FF C2
        .byte   $B9,$04,$01,$04,$B2,$07,$B9,$04 ; EE87 B9 04 01 04 B2 07 B9 04
        .byte   $01,$04,$07,$01,$04,$FF,$B2,$07 ; EE8F 01 04 07 01 04 FF B2 07
        .byte   $01,$B8,$07,$07,$07,$C3,$B9,$04 ; EE97 01 B8 07 07 07 C3 B9 04
        .byte   $01,$04,$07,$01,$04,$B9,$01,$04 ; EE9F 01 04 07 01 04 B9 01 04
        .byte   $04,$07,$01,$04,$FF,$B1,$01,$BA ; EEA7 04 07 01 04 FF B1 01 BA
        .byte   $07,$CB,$04,$FF,$C2,$B8,$07,$B9 ; EEAF 07 CB 04 FF C2 B8 07 B9
        .byte   $07,$FF,$B2,$01,$0A,$01,$01,$00 ; EEB7 07 FF B2 01 0A 01 01 00
; ----------------------------------------------------------------------------
music_music1_sq1Script:
        .addr   music_music1_sq1Routine1        ; EEBF E3 EE
        .addr   music_music1_sq1Routine2        ; EEC1 F0 F0
        .addr   music_music1_sq1Routine3        ; EEC3 DE F1
        .addr   LFFFF                           ; EEC5 FF FF
        .addr   music_music1_sq1Script          ; EEC7 BF EE
music_music1_sq2Script:
        .addr   music_music1_sq2Routine1        ; EEC9 B1 EF
        .addr   music_music1_sq2Routine2        ; EECB 47 F1
        .addr   music_music1_sq2Routine3        ; EECD F7 F1
        .addr   LFFFF                           ; EECF FF FF
        .addr   music_music1_sq2Script          ; EED1 C9 EE
music_music1_triScript:
        .addr   music_music1_triRoutine1        ; EED3 4F F0
        .addr   music_music1_triRoutine2        ; EED5 96 F1
        .addr   music_music1_triRoutine3        ; EED7 42 F2
        .addr   LFFFF                           ; EED9 FF FF
        .addr   music_music1_triScript          ; EEDB D3 EE
music_music1_noiseScript:
        .addr   music_music1_noiseRoutine1      ; EEDD 58 F2
        .addr   LFFFF                           ; EEDF FF FF
        .addr   music_music1_noiseScript        ; EEE1 DD EE
; ----------------------------------------------------------------------------
music_music1_sq1Routine1:
        .byte   $9F,$0A,$F1,$B2,$20,$38,$20,$38 ; EEE3 9F 0A F1 B2 20 38 20 38
        .byte   $9F,$0D,$F1,$B2,$20,$38,$20,$38 ; EEEB 9F 0D F1 B2 20 38 20 38
        .byte   $9F,$0A,$F1,$B2,$20,$B1,$46,$3E ; EEF3 9F 0A F1 B2 20 B1 46 3E
        .byte   $B2,$46,$42,$3C,$3E,$B1,$40,$40 ; EEFB B2 46 42 3C 3E B1 40 40
        .byte   $B2,$40,$B1,$42,$42,$B2,$42,$B1 ; EF03 B2 40 B1 42 42 B2 42 B1
        .byte   $3C,$3C,$B2,$3C,$B1,$3E,$3E,$42 ; EF0B 3C 3C B2 3C B1 3E 3E 42
        .byte   $42,$B2,$3E,$9F,$0A,$F1,$B0,$56 ; EF13 42 B2 3E 9F 0A F1 B0 56
        .byte   $9F,$0B,$F1,$B0,$54,$9F,$0C,$F1 ; EF1B 9F 0B F1 B0 54 9F 0C F1
        .byte   $B0,$50,$9F,$0D,$F1,$B0,$4C,$9F ; EF23 B0 50 9F 0D F1 B0 4C 9F
        .byte   $0D,$F1,$B2,$4A,$38,$50,$4E,$4E ; EF2B 0D F1 B2 4A 38 50 4E 4E
        .byte   $50,$9F,$09,$F1,$B1,$50,$50,$B2 ; EF33 50 9F 09 F1 B1 50 50 B2
        .byte   $50,$B1,$4C,$4C,$B2,$4C,$B1,$4A ; EF3B 50 B1 4C 4C B2 4C B1 4A
        .byte   $4A,$B2,$4A,$B1,$46,$46,$4A,$4A ; EF43 4A B2 4A B1 46 46 4A 4A
        .byte   $B2,$46,$9F,$0D,$F1,$B0,$44,$9F ; EF4B B2 46 9F 0D F1 B0 44 9F
        .byte   $0C,$F1,$B0,$46,$9F,$0B,$F1,$B0 ; EF53 0C F1 B0 46 9F 0B F1 B0
        .byte   $4A,$9F,$0A,$F1,$B0,$4E,$9F,$09 ; EF5B 4A 9F 0A F1 B0 4E 9F 09
        .byte   $F1,$B2,$50,$B1,$46,$3E,$B2,$46 ; EF63 F1 B2 50 B1 46 3E B2 46
        .byte   $42,$3C,$3E,$B1,$40,$40,$B2,$40 ; EF6B 42 3C 3E B1 40 40 B2 40
        .byte   $B1,$42,$42,$B2,$42,$B1,$3C,$3C ; EF73 B1 42 42 B2 42 B1 3C 3C
        .byte   $B2,$3C,$B1,$3E,$3E,$42,$42,$B2 ; EF7B B2 3C B1 3E 3E 42 42 B2
        .byte   $3E,$B0,$50,$4C,$4A,$46,$B2,$44 ; EF83 3E B0 50 4C 4A 46 B2 44
        .byte   $B1,$44,$44,$B2,$44,$B0,$46,$4A ; EF8B B1 44 44 B2 44 B0 46 4A
        .byte   $46,$42,$B2,$40,$B1,$40,$40,$B2 ; EF93 46 42 B2 40 B1 40 40 B2
        .byte   $40,$B0,$42,$46,$42,$3E,$B2,$3C ; EF9B 40 B0 42 46 42 3E B2 3C
        .byte   $B1,$3C,$3C,$B2,$3C,$3E,$02,$3C ; EFA3 B1 3C 3C B2 3C 3E 02 3C
        .byte   $9F,$09,$F1,$3E,$02,$00         ; EFAB 9F 09 F1 3E 02 00
music_music1_sq2Routine1:
        .byte   $9F,$0A,$F1,$B2,$20,$3E,$20,$3E ; EFB1 9F 0A F1 B2 20 3E 20 3E
        .byte   $9F,$0B,$F1,$B2,$20,$3E,$20,$3E ; EFB9 9F 0B F1 B2 20 3E 20 3E
        .byte   $9F,$09,$F1,$B2,$02,$B1,$56,$50 ; EFC1 9F 09 F1 B2 02 B1 56 50
        .byte   $B2,$56,$54,$4E,$50,$B1,$4C,$4C ; EFC9 B2 56 54 4E 50 B1 4C 4C
        .byte   $B2,$4C,$B1,$4A,$4A,$B2,$4A,$B1 ; EFD1 B2 4C B1 4A 4A B2 4A B1
        .byte   $48,$48,$B2,$48,$B1,$46,$50,$48 ; EFD9 48 48 B2 48 B1 46 50 48
        .byte   $50,$B2,$46,$02,$9F,$0C,$F1,$02 ; EFE1 50 B2 46 02 9F 0C F1 02
        .byte   $B1,$50,$4A,$B2,$50,$B1,$54,$46 ; EFE9 B1 50 4A B2 50 B1 54 46
        .byte   $B2,$54,$50,$9F,$09,$F1,$B1,$56 ; EFF1 B2 54 50 9F 09 F1 B1 56
        .byte   $56,$B2,$56,$B1,$54,$54,$B2,$54 ; EFF9 56 B2 56 B1 54 54 B2 54
        .byte   $B1,$50,$50,$B2,$50,$B1,$4E,$54 ; F001 B1 50 50 B2 50 B1 4E 54
        .byte   $50,$54,$B3,$4E,$9F,$09,$F1,$B2 ; F009 50 54 B3 4E 9F 09 F1 B2
        .byte   $02,$B1,$56,$50,$B2,$56,$54,$4E ; F011 02 B1 56 50 B2 56 54 4E
        .byte   $50,$B1,$4C,$4C,$B2,$4C,$B1,$4A ; F019 50 B1 4C 4C B2 4C B1 4A
        .byte   $4A,$B2,$4A,$B1,$48,$48,$B2,$48 ; F021 4A B2 4A B1 48 48 B2 48
        .byte   $B1,$46,$50,$48,$50,$B2,$46,$02 ; F029 B1 46 50 48 50 B2 46 02
        .byte   $B2,$02,$B1,$50,$4A,$B2,$50,$4E ; F031 B2 02 B1 50 4A B2 50 4E
        .byte   $02,$B1,$4C,$46,$B2,$4C,$4A,$02 ; F039 02 B1 4C 46 B2 4C 4A 02
        .byte   $B1,$48,$42,$B2,$48,$46,$02,$46 ; F041 B1 48 42 B2 48 46 02 46
        .byte   $9F,$09,$F1,$50,$02,$00         ; F049 9F 09 F1 50 02 00
music_music1_triRoutine1:
        .byte   $9F,$00,$00,$C4,$B2,$20,$B1,$46 ; F04F 9F 00 00 C4 B2 20 B1 46
        .byte   $02,$FF,$B2,$38,$B1,$50,$02,$B2 ; F057 02 FF B2 38 B1 50 02 B2
        .byte   $38,$B1,$4A,$02,$B2,$38,$B1,$44 ; F05F 38 B1 4A 02 B2 38 B1 44
        .byte   $02,$B2,$38,$B1,$50,$02,$B2,$38 ; F067 02 B2 38 B1 50 02 B2 38
        .byte   $B1,$50,$02,$B2,$38,$B1,$50,$02 ; F06F B1 50 02 B2 38 B1 50 02
        .byte   $C3,$38,$02,$FF,$B0,$56,$54,$50 ; F077 C3 38 02 FF B0 56 54 50
        .byte   $4C,$B2,$44,$B1,$4A,$02,$B2,$42 ; F07F 4C B2 44 B1 4A 02 B2 42
        .byte   $B1,$5E,$02,$B2,$3E,$B1,$5E,$02 ; F087 B1 5E 02 B2 3E B1 5E 02
        .byte   $B2,$3C,$B1,$62,$02,$B2,$3C,$B1 ; F08F B2 3C B1 62 02 B2 3C B1
        .byte   $5E,$02,$B2,$3C,$B1,$5C,$02,$C3 ; F097 5E 02 B2 3C B1 5C 02 C3
        .byte   $B1,$46,$02,$FF,$B2,$02,$B2,$38 ; F09F B1 46 02 FF B2 02 B2 38
        .byte   $B1,$50,$02,$B2,$38,$B1,$62,$02 ; F0A7 B1 50 02 B2 38 B1 62 02
        .byte   $B2,$38,$B1,$5C,$02,$B2,$38,$B1 ; F0AF B2 38 B1 5C 02 B2 38 B1
        .byte   $5E,$02,$B2,$38,$B1,$50,$02,$B2 ; F0B7 5E 02 B2 38 B1 50 02 B2
        .byte   $38,$B1,$60,$02,$C3,$38,$02,$FF ; F0BF 38 B1 60 02 C3 38 02 FF
        .byte   $B0,$50,$4C,$4A,$46,$B2,$3C,$B1 ; F0C7 B0 50 4C 4A 46 B2 3C B1
        .byte   $62,$02,$B2,$62,$B1,$46,$02,$B2 ; F0CF 62 02 B2 62 B1 46 02 B2
        .byte   $38,$B1,$5E,$02,$B2,$46,$B1,$2A ; F0D7 38 B1 5E 02 B2 46 B1 2A
        .byte   $02,$B2,$34,$B1,$42,$02,$B2,$42 ; F0DF 02 B2 34 B1 42 02 B2 42
        .byte   $B1,$46,$02,$B2,$02,$46,$38,$02 ; F0E7 B1 46 02 B2 02 46 38 02
        .byte   $00                             ; F0EF 00
music_music1_sq1Routine2:
        .byte   $C2,$B1,$46,$46,$4A,$4A,$4E,$4E ; F0F0 C2 B1 46 46 4A 4A 4E 4E
        .byte   $50,$50,$50,$50,$4A,$4A,$B2,$4E ; F0F8 50 50 50 50 4A 4A B2 4E
        .byte   $76,$B9,$38,$3E,$46,$38,$3E,$46 ; F100 76 B9 38 3E 46 38 3E 46
        .byte   $38,$3E,$46,$38,$3E,$46,$34,$3C ; F108 38 3E 46 38 3E 46 34 3C
        .byte   $42,$34,$3C,$42,$B1,$42,$02,$64 ; F110 42 34 3C 42 B1 42 02 64
        .byte   $02,$FF,$9F,$0C,$F1,$B1,$5E,$5E ; F118 02 FF 9F 0C F1 B1 5E 5E
        .byte   $62,$62,$B2,$66,$B1,$46,$02,$9F ; F120 62 62 B2 66 B1 46 02 9F
        .byte   $0B,$F1,$B1,$68,$68,$6C,$6C,$B2 ; F128 0B F1 B1 68 68 6C 6C B2
        .byte   $6E,$B1,$46,$02,$9F,$09,$F1,$B1 ; F130 6E B1 46 02 9F 09 F1 B1
        .byte   $6C,$6C,$6E,$6E,$B2,$72,$B1,$46 ; F138 6C 6C 6E 6E B2 72 B1 46
        .byte   $02,$B1,$6E,$6E,$72,$72,$00     ; F140 02 B1 6E 6E 72 72 00
music_music1_sq2Routine2:
        .byte   $C2,$B1,$4E,$4E,$50,$50,$54,$54 ; F147 C2 B1 4E 4E 50 50 54 54
        .byte   $56,$56,$5A,$5A,$50,$50,$B2,$54 ; F14F 56 56 5A 5A 50 50 B2 54
        .byte   $02,$9F,$09,$F1,$02,$B1,$4E,$02 ; F157 02 9F 09 F1 02 B1 4E 02
        .byte   $B3,$50,$B2,$02,$B1,$4A,$02,$B3 ; F15F B3 50 B2 02 B1 4A 02 B3
        .byte   $4C,$FF,$9F,$0C,$F1,$B1,$66,$66 ; F167 4C FF 9F 0C F1 B1 66 66
        .byte   $68,$68,$B2,$6C,$B1,$46,$02,$9F ; F16F 68 68 B2 6C B1 46 02 9F
        .byte   $0B,$F1,$B1,$5E,$62,$66,$66,$B2 ; F177 0B F1 B1 5E 62 66 66 B2
        .byte   $68,$B1,$46,$02,$9F,$09,$F1,$B1 ; F17F 68 B1 46 02 9F 09 F1 B1
        .byte   $5E,$66,$68,$68,$B2,$6C,$B1,$46 ; F187 5E 66 68 68 B2 6C B1 46
        .byte   $02,$B1,$5E,$68,$6C,$6C,$00     ; F18F 02 B1 5E 68 6C 6C 00
music_music1_triRoutine2:
        .byte   $C2,$B1,$46,$46,$46,$46,$5E,$5E ; F196 C2 B1 46 46 46 46 5E 5E
        .byte   $5E,$5E,$62,$62,$62,$62,$5E,$02 ; F19E 5E 5E 62 62 62 62 5E 02
        .byte   $46,$02,$B2,$38,$38,$B1,$38,$02 ; F1A6 46 02 B2 38 38 B1 38 02
        .byte   $38,$02,$B3,$34,$B1,$34,$02,$4C ; F1AE 38 02 B3 34 B1 34 02 4C
        .byte   $02,$FF,$C4,$B1,$46,$FF,$B2,$46 ; F1B6 02 FF C4 B1 46 FF B2 46
        .byte   $B0,$5C,$5E,$02,$02,$C4,$B1,$5E ; F1BE B0 5C 5E 02 02 C4 B1 5E
        .byte   $FF,$B2,$5E,$B0,$5C,$5E,$02,$02 ; F1C6 FF B2 5E B0 5C 5E 02 02
        .byte   $C4,$B1,$5E,$FF,$B2,$5E,$B0,$5C ; F1CE C4 B1 5E FF B2 5E B0 5C
        .byte   $5E,$02,$02,$C4,$B1,$76,$FF,$00 ; F1D6 5E 02 02 C4 B1 76 FF 00
music_music1_sq1Routine3:
        .byte   $9F,$0E,$F1,$B2,$6E,$4E,$4C,$4E ; F1DE 9F 0E F1 B2 6E 4E 4C 4E
        .byte   $4C,$56,$54,$56,$54,$62,$5E,$62 ; F1E6 4C 56 54 56 54 62 5E 62
        .byte   $5E,$62,$5A,$62,$5A,$76,$B2,$2E ; F1EE 5E 62 5A 62 5A 76 B2 2E
        .byte   $00                             ; F1F6 00
music_music1_sq2Routine3:
        .byte   $9F,$0F,$F1,$B2,$76,$B0,$02,$54 ; F1F7 9F 0F F1 B2 76 B0 02 54
        .byte   $5A,$60,$02,$54,$5A,$5E,$02,$54 ; F1FF 5A 60 02 54 5A 5E 02 54
        .byte   $5A,$60,$02,$54,$5A,$5E,$02,$5A ; F207 5A 60 02 54 5A 5E 02 5A
        .byte   $62,$68,$02,$5A,$62,$66,$02,$66 ; F20F 62 68 02 5A 62 66 02 66
        .byte   $72,$78,$02,$5A,$62,$66,$02,$5A ; F217 72 78 02 5A 62 66 02 5A
        .byte   $62,$66,$02,$66,$72,$76,$02,$66 ; F21F 62 66 02 66 72 76 02 66
        .byte   $72,$78,$02,$66,$72,$76,$02,$6C ; F227 72 78 02 66 72 76 02 6C
        .byte   $72,$80,$02,$6C,$72,$7E,$02,$6C ; F22F 72 80 02 6C 72 7E 02 6C
        .byte   $72,$80,$02,$6C,$72,$7E,$B2,$76 ; F237 72 80 02 6C 72 7E B2 76
        .byte   $B2,$2E,$00                     ; F23F B2 2E 00
music_music1_triRoutine3:
        .byte   $B2,$76,$02,$02,$02,$02,$02,$02 ; F242 B2 76 02 02 02 02 02 02
        .byte   $02,$02,$6C,$66,$6C,$66,$6C,$5E ; F24A 02 02 6C 66 6C 66 6C 5E
        .byte   $6C,$5E,$76,$B2,$02,$00         ; F252 6C 5E 76 B2 02 00
music_music1_noiseRoutine1:
        .byte   $C4,$B2,$01,$04,$FF,$C6,$01,$04 ; F258 C4 B2 01 04 FF C6 01 04
        .byte   $FF,$01,$07,$07,$01,$C6,$01,$04 ; F260 FF 01 07 07 01 C6 01 04
        .byte   $FF,$01,$07,$07,$01,$C6,$01,$04 ; F268 FF 01 07 07 01 C6 01 04
        .byte   $FF,$01,$07,$07,$01,$C2,$01,$07 ; F270 FF 01 07 07 01 C2 01 07
        .byte   $07,$01,$FF,$01,$04,$01,$04,$01 ; F278 07 01 FF 01 04 01 04 01
        .byte   $07,$07,$01,$C2,$B4,$04,$FF,$C2 ; F280 07 07 01 C2 B4 04 FF C2
        .byte   $B2,$01,$04,$04,$04,$FF,$C2,$B4 ; F288 B2 01 04 04 04 FF C2 B4
        .byte   $04,$FF,$C2,$B2,$01,$04,$04,$04 ; F290 04 FF C2 B2 01 04 04 04
        .byte   $FF,$C3,$B1,$04,$04,$04,$04,$B2 ; F298 FF C3 B1 04 04 04 04 B2
        .byte   $04,$01,$FF,$B1,$04,$04,$04,$04 ; F2A0 04 01 FF B1 04 04 04 04
        .byte   $B2,$04,$C4,$B4,$01,$FF,$B3,$01 ; F2A8 B2 04 C4 B4 01 FF B3 01
        .byte   $00                             ; F2B0 00
; ----------------------------------------------------------------------------
music_music3_sq1Script:
        .addr   music_music3_sq1Routine1        ; F2B1 CB F2
music_music3_sq1ScriptLoop:
        .addr   music_music3_sq1Routine2        ; F2B3 D4 F2
        .addr   LFFFF                           ; F2B5 FF FF
        .addr   music_music3_sq1ScriptLoop      ; F2B7 B3 F2
music_music3_sq2Script:
        .addr   music_music3_sq2Routine1        ; F2B9 D1 F2
        .addr   LFFFF                           ; F2BB FF FF
        .addr   music_music3_sq2Script          ; F2BD B9 F2
music_music3_triScript:
        .addr   music_music3_triRoutine1        ; F2BF 4D F3
        .addr   LFFFF                           ; F2C1 FF FF
        .addr   music_music3_triScript          ; F2C3 BF F2
; unreferenced
music_music3_noiseScript:
        .addr   music_music3_noiseRoutine1      ; F2C5 A0 F3
        .addr   LFFFF                           ; F2C7 FF FF
        .addr   music_music3_noiseScript        ; F2C9 C5 F2
; ----------------------------------------------------------------------------
music_music3_sq1Routine1:
        .byte   $9F,$A5,$B1,$B8,$02,$00         ; F2CB 9F A5 B1 B8 02 00
music_music3_sq2Routine1:
        .byte   $9F,$A4,$B3                     ; F2D1 9F A4 B3
music_music3_sq1Routine2:
        .byte   $B1,$02,$42,$48,$42,$4C,$42,$56 ; F2D4 B1 02 42 48 42 4C 42 56
        .byte   $42,$54,$42,$50,$42,$54,$42,$4C ; F2DC 42 54 42 50 42 54 42 4C
        .byte   $42,$02,$42,$02,$42,$48,$42,$4C ; F2E4 42 02 42 02 42 48 42 4C
        .byte   $42,$02,$3E,$48,$3E,$4C,$3E,$50 ; F2EC 42 02 3E 48 3E 4C 3E 50
        .byte   $3E,$52,$3E,$50,$3E,$4C,$3E,$48 ; F2F4 3E 52 3E 50 3E 4C 3E 48
        .byte   $3E,$50,$3E,$02,$3E,$48,$3E,$50 ; F2FC 3E 50 3E 02 3E 48 3E 50
        .byte   $3E,$B1,$02,$42,$48,$42,$4C,$42 ; F304 3E B1 02 42 48 42 4C 42
        .byte   $56,$42,$54,$42,$50,$42,$54,$42 ; F30C 56 42 54 42 50 42 54 42
        .byte   $4C,$42,$02,$42,$02,$42,$48,$42 ; F314 4C 42 02 42 02 42 48 42
        .byte   $4C,$42,$B1,$02,$42,$48,$42,$50 ; F31C 4C 42 B1 02 42 48 42 50
        .byte   $42,$56,$42,$54,$42,$50,$42,$46 ; F324 42 56 42 54 42 50 42 46
        .byte   $42,$50,$42,$4C,$42,$02,$42,$B2 ; F32C 42 50 42 4C 42 02 42 B2
        .byte   $42,$02,$B1,$5A,$42,$48,$4C,$50 ; F334 42 02 B1 5A 42 48 4C 50
        .byte   $56,$B3,$5A,$B2,$02,$B1,$42,$5A ; F33C 56 B3 5A B2 02 B1 42 5A
        .byte   $60,$5E,$5A,$56,$B3,$5A,$B2,$42 ; F344 60 5E 5A 56 B3 5A B2 42
        .byte   $00                             ; F34C 00
music_music3_triRoutine1:
        .byte   $9F,$00,$00,$B5,$4C,$B1,$4C,$B2 ; F34D 9F 00 00 B5 4C B1 4C B2
        .byte   $34,$B5,$42,$B1,$42,$B2,$42,$4C ; F355 34 B5 42 B1 42 B2 42 4C
        .byte   $42,$4C,$42,$4C,$42,$B5,$48,$B1 ; F35D 42 4C 42 4C 42 B5 48 B1
        .byte   $48,$B2,$48,$B5,$3E,$B1,$3E,$B2 ; F365 48 B2 48 B5 3E B1 3E B2
        .byte   $3E,$48,$3E,$48,$3E,$48,$3E,$B3 ; F36D 3E 48 3E 48 3E 48 3E B3
        .byte   $4C,$B2,$42,$4C,$42,$4C,$42,$4C ; F375 4C B2 42 4C 42 4C 42 4C
        .byte   $42,$4C,$42,$4C,$B5,$48,$B1,$48 ; F37D 42 4C 42 4C B5 48 B1 48
        .byte   $B2,$48,$B5,$3E,$B1,$3E,$B2,$3E ; F385 B2 48 B5 3E B1 3E B2 3E
        .byte   $48,$3E,$48,$3E,$48,$3E,$4C,$42 ; F38D 48 3E 48 3E 48 3E 4C 42
        .byte   $4C,$48,$3E,$48,$4C,$42,$4C,$48 ; F395 4C 48 3E 48 4C 42 4C 48
        .byte   $3E,$48,$00                     ; F39D 3E 48 00
; unreferenced
music_music3_noiseRoutine1:
        .byte   $B2,$04,$04,$00                 ; F3A0 B2 04 04 00
; ----------------------------------------------------------------------------
music_congratulations_sq1Script:
        .addr   music_congratulations_sq1Routine1; F3A4 BC F3
        .addr   LFFFF                           ; F3A6 FF FF
        .addr   music_congratulations_sq1Script ; F3A8 A4 F3
music_congratulations_sq2Script:
        .addr   music_congratulations_sq2Routine1; F3AA 58 F4
        .addr   LFFFF                           ; F3AC FF FF
        .addr   music_congratulations_sq2Script ; F3AE AA F3
music_congratulations_triScript:
        .addr   music_congratulations_triRoutine1; F3B0 30 F5
        .addr   LFFFF                           ; F3B2 FF FF
        .addr   music_congratulations_triScript ; F3B4 B0 F3
music_congratulations_noiseScript:
        .addr   music_congratulations_noiseRoutine1; F3B6 7F F5
        .addr   LFFFF                           ; F3B8 FF FF
        .addr   music_congratulations_noiseScript; F3BA B6 F3
; ----------------------------------------------------------------------------
music_congratulations_sq1Routine1:
        .byte   $9F,$07,$B1,$B2,$42,$40,$3E,$C2 ; F3BC 9F 07 B1 B2 42 40 3E C2
        .byte   $B1,$1C,$02,$B2,$3C,$B1,$12,$02 ; F3C4 B1 1C 02 B2 3C B1 12 02
        .byte   $B2,$3C,$B1,$1C,$02,$B2,$3C,$B1 ; F3CC B2 3C B1 1C 02 B2 3C B1
        .byte   $12,$02,$B2,$3C,$B1,$20,$02,$B2 ; F3D4 12 02 B2 3C B1 20 02 B2
        .byte   $3E,$B1,$1E,$02,$B2,$3E,$B1,$1C ; F3DC 3E B1 1E 02 B2 3E B1 1C
        .byte   $02,$B2,$3E,$B1,$1E,$02,$B2,$3E ; F3E4 02 B2 3E B1 1E 02 B2 3E
        .byte   $B1,$20,$02,$B2,$3E,$B1,$16,$02 ; F3EC B1 20 02 B2 3E B1 16 02
        .byte   $B2,$3E,$B1,$12,$02,$B2,$38,$B1 ; F3F4 B2 3E B1 12 02 B2 38 B1
        .byte   $12,$02,$B2,$38,$B1,$1C,$02,$B2 ; F3FC 12 02 B2 38 B1 1C 02 B2
        .byte   $3C,$B1,$12,$02,$B2,$3C,$B1,$1C ; F404 3C B1 12 02 B2 3C B1 1C
        .byte   $02,$B6,$02,$FF,$B1,$20,$02,$B2 ; F40C 02 B6 02 FF B1 20 02 B2
        .byte   $46,$B1,$1E,$02,$B2,$46,$B1,$1C ; F414 46 B1 1E 02 B2 46 B1 1C
        .byte   $02,$B2,$46,$B1,$16,$02,$B2,$46 ; F41C 02 B2 46 B1 16 02 B2 46
        .byte   $B1,$1C,$02,$B2,$3C,$B1,$12,$02 ; F424 B1 1C 02 B2 3C B1 12 02
        .byte   $B2,$3C,$B1,$1C,$02,$B2,$3C,$B1 ; F42C B2 3C B1 1C 02 B2 3C B1
        .byte   $12,$02,$B2,$3C,$B1,$20,$02,$B2 ; F434 12 02 B2 3C B1 20 02 B2
        .byte   $46,$B1,$16,$02,$B2,$46,$B1,$20 ; F43C 46 B1 16 02 B2 46 B1 20
        .byte   $02,$B2,$46,$B1,$16,$02,$B2,$46 ; F444 02 B2 46 B1 16 02 B2 46
        .byte   $C2,$B8,$4C,$4C,$4C,$BB,$02,$FF ; F44C C2 B8 4C 4C 4C BB 02 FF
        .byte   $B1,$38,$02,$00                 ; F454 B1 38 02 00
music_congratulations_sq2Routine1:
        .byte   $9F,$A6,$B1,$B2,$42,$46,$48,$B1 ; F458 9F A6 B1 B2 42 46 48 B1
        .byte   $4A,$02,$B7,$4A,$B0,$48,$B1,$4A ; F460 4A 02 B7 4A B0 48 B1 4A
        .byte   $02,$B7,$4A,$B0,$48,$B1,$4A,$02 ; F468 02 B7 4A B0 48 B1 4A 02
        .byte   $B7,$4A,$B0,$48,$B2,$4A,$48,$B4 ; F470 B7 4A B0 48 B2 4A 48 B4
        .byte   $46,$B1,$02,$B0,$02,$3C,$B7,$38 ; F478 46 B1 02 B0 02 3C B7 38
        .byte   $B0,$34,$B1,$02,$B0,$02,$46,$B7 ; F480 B0 34 B1 02 B0 02 46 B7
        .byte   $4A,$B0,$4C,$B2,$4C,$4C,$B1,$4C ; F488 4A B0 4C B2 4C 4C B1 4C
        .byte   $4C,$B0,$02,$4C,$50,$52,$B2,$54 ; F490 4C B0 02 4C 50 52 B2 54
        .byte   $50,$4A,$46,$B4,$42,$B2,$02,$3C ; F498 50 4A 46 B4 42 B2 02 3C
        .byte   $3E,$B7,$40,$B0,$42,$B1,$4A,$02 ; F4A0 3E B7 40 B0 42 B1 4A 02
        .byte   $B7,$4A,$B0,$48,$B1,$4A,$02,$B7 ; F4A8 B7 4A B0 48 B1 4A 02 B7
        .byte   $4A,$B0,$48,$B1,$4A,$02,$B7,$4A ; F4B0 4A B0 48 B1 4A 02 B7 4A
        .byte   $B0,$48,$B2,$4A,$48,$B4,$46,$B1 ; F4B8 B0 48 B2 4A 48 B4 46 B1
        .byte   $02,$B0,$02,$3C,$B7,$38,$B0,$34 ; F4C0 02 B0 02 3C B7 38 B0 34
        .byte   $B1,$02,$B0,$02,$46,$B7,$4A,$B0 ; F4C8 B1 02 B0 02 46 B7 4A B0
        .byte   $4C,$B2,$4C,$4C,$B8,$4C,$4C,$4C ; F4D0 4C B2 4C 4C B8 4C 4C 4C
        .byte   $BB,$02,$B2,$54,$50,$46,$4A,$B4 ; F4D8 BB 02 B2 54 50 46 4A B4
        .byte   $4C,$B2,$02,$4C,$4A,$48,$B1,$46 ; F4E0 4C B2 02 4C 4A 48 B1 46
        .byte   $B5,$3C,$B2,$38,$34,$B7,$46,$B0 ; F4E8 B5 3C B2 38 34 B7 46 B0
        .byte   $3C,$B7,$38,$B5,$34,$B0,$02,$46 ; F4F0 3C B7 38 B5 34 B0 02 46
        .byte   $48,$B1,$4A,$02,$B7,$4A,$B0,$48 ; F4F8 48 B1 4A 02 B7 4A B0 48
        .byte   $B1,$4A,$02,$B7,$4A,$B0,$48,$B1 ; F500 B1 4A 02 B7 4A B0 48 B1
        .byte   $4A,$02,$B7,$4A,$B0,$48,$B2,$4A ; F508 4A 02 B7 4A B0 48 B2 4A
        .byte   $B9,$4A,$4C,$4E,$BA,$02,$B2,$50 ; F510 B9 4A 4C 4E BA 02 B2 50
        .byte   $4C,$46,$B3,$3E,$B2,$46,$4C,$50 ; F518 4C 46 B3 3E B2 46 4C 50
        .byte   $B8,$52,$52,$52,$BB,$02,$B8,$52 ; F520 B8 52 52 52 BB 02 B8 52
        .byte   $50,$4C,$BB,$02,$B1,$50,$02,$00 ; F528 50 4C BB 02 B1 50 02 00
music_congratulations_triRoutine1:
        .byte   $9F,$0F,$00,$C3,$B2,$02,$FF,$C2 ; F530 9F 0F 00 C3 B2 02 FF C2
        .byte   $B2,$34,$5A,$2A,$5A,$34,$5A,$2A ; F538 B2 34 5A 2A 5A 34 5A 2A
        .byte   $5A,$38,$5E,$36,$5E,$34,$5E,$36 ; F540 5A 38 5E 36 5E 34 5E 36
        .byte   $5E,$38,$5E,$2E,$5E,$2A,$56,$2A ; F548 5E 38 5E 2E 5E 2A 56 2A
        .byte   $56,$34,$5A,$2A,$5A,$B4,$34,$FF ; F550 56 34 5A 2A 5A B4 34 FF
        .byte   $9F,$10,$00,$B2,$38,$56,$36,$56 ; F558 9F 10 00 B2 38 56 36 56
        .byte   $34,$56,$2E,$56,$34,$5A,$2A,$5A ; F560 34 56 2E 56 34 5A 2A 5A
        .byte   $34,$5A,$2A,$5A,$38,$56,$2E,$56 ; F568 34 5A 2A 5A 38 56 2E 56
        .byte   $38,$56,$2E,$56,$C2,$B8,$2A,$2A ; F570 38 56 2E 56 C2 B8 2A 2A
        .byte   $2A,$BB,$02,$FF,$B2,$42,$00     ; F578 2A BB 02 FF B2 42 00
music_congratulations_noiseRoutine1:
        .byte   $B2,$01,$01,$01,$C7,$B2,$04,$B7 ; F57F B2 01 01 01 C7 B2 04 B7
        .byte   $04,$B0,$04,$B2,$07,$B7,$04,$B0 ; F587 04 B0 04 B2 07 B7 04 B0
        .byte   $04,$FF,$B4,$04,$C7,$B2,$04,$B7 ; F58F 04 FF B4 04 C7 B2 04 B7
        .byte   $04,$B0,$04,$B2,$07,$B7,$04,$B0 ; F597 04 B0 04 B2 07 B7 04 B0
        .byte   $04,$FF,$B4,$04,$C6,$B7,$04,$B0 ; F59F 04 FF B4 04 C6 B7 04 B0
        .byte   $04,$B2,$07,$B7,$04,$B0,$04,$B2 ; F5A7 04 B2 07 B7 04 B0 04 B2
        .byte   $07,$FF,$C2,$B9,$04,$04,$04,$BA ; F5AF 07 FF C2 B9 04 04 04 BA
        .byte   $01,$B9,$07,$04,$04,$BA,$01,$FF ; F5B7 01 B9 07 04 04 BA 01 FF
        .byte   $B2,$07,$00                     ; F5BF B2 07 00
; ----------------------------------------------------------------------------
music_music2_sq1Script:
        .addr   music_music2_sq1Routine1        ; F5C2 F8 F5
        .addr   music_music2_sq1Routine2        ; F5C4 6A F6
        .addr   music_music2_sq1Routine3        ; F5C6 86 F6
        .addr   music_music2_sq1Routine3        ; F5C8 86 F6
        .addr   music_music2_sq1Routine4        ; F5CA F2 F6
        .addr   LFFFF                           ; F5CC FF FF
        .addr   music_music2_sq1Script          ; F5CE C2 F5
music_music2_sq2Script:
        .addr   music_music2_sq2Routine1        ; F5D0 F2 F5
        .addr   music_music2_sq2Routine2        ; F5D2 67 F6
        .addr   music_music2_sq2Routine3        ; F5D4 AC F6
        .addr   music_music2_sq2Routine3        ; F5D6 AC F6
        .addr   music_music2_sq2Routine4        ; F5D8 95 F7
        .addr   LFFFF                           ; F5DA FF FF
        .addr   music_music2_sq2Script          ; F5DC D0 F5
music_music2_triScript:
        .addr   music_music2_triRoutine1        ; F5DE 06 F6
        .addr   music_music2_triRoutine2        ; F5E0 78 F6
        .addr   music_music2_triRoutine3        ; F5E2 D2 F6
        .addr   music_music2_triRoutine3        ; F5E4 D2 F6
        .addr   music_music2_triRoutine4        ; F5E6 33 F8
        .addr   LFFFF                           ; F5E8 FF FF
        .addr   music_music2_triScript          ; F5EA DE F5
music_music2_noiseScript:
        .addr   music_music2_noiseRoutine1      ; F5EC 14 F6
        .addr   LFFFF                           ; F5EE FF FF
        .addr   music_music2_noiseScript        ; F5F0 EC F5
; ----------------------------------------------------------------------------
music_music2_sq2Routine1:
        .byte   $9F,$10,$31,$B4,$02,$00         ; F5F2 9F 10 31 B4 02 00
music_music2_sq1Routine1:
        .byte   $9F,$10,$31,$C2,$B1,$3C,$B0,$3C ; F5F8 9F 10 31 C2 B1 3C B0 3C
        .byte   $3C,$B1,$32,$32,$FF,$00         ; F600 3C B1 32 32 FF 00
music_music2_triRoutine1:
        .byte   $9F,$00,$00,$C2,$B1,$3C,$B0,$3C ; F606 9F 00 00 C2 B1 3C B0 3C
        .byte   $3C,$B1,$32,$32,$FF,$00         ; F60E 3C B1 32 32 FF 00
music_music2_noiseRoutine1:
        .byte   $C4,$B1,$04,$B0,$04,$04,$B1,$04 ; F614 C4 B1 04 B0 04 04 B1 04
        .byte   $04,$FF,$CF,$B1,$04,$B0,$04,$04 ; F61C 04 FF CF B1 04 B0 04 04
        .byte   $B1,$04,$04,$FF,$B1,$04,$B0,$04 ; F624 B1 04 04 FF B1 04 B0 04
        .byte   $04,$B1,$07,$01,$CC,$B1,$04,$B0 ; F62C 04 B1 07 01 CC B1 04 B0
        .byte   $04,$04,$B1,$04,$04,$FF,$C4,$B1 ; F634 04 04 B1 04 04 FF C4 B1
        .byte   $04,$B0,$04,$04,$B1,$04,$04,$FF ; F63C 04 B0 04 04 B1 04 04 FF
        .byte   $C2,$B1,$04,$B0,$04,$04,$B1,$04 ; F644 C2 B1 04 B0 04 04 B1 04
        .byte   $04,$01,$B0,$04,$04,$B1,$04,$04 ; F64C 04 01 B0 04 04 B1 04 04
        .byte   $FF,$C3,$B1,$04,$B0,$04,$04,$B1 ; F654 FF C3 B1 04 B0 04 04 B1
        .byte   $04,$04,$FF,$B1,$04,$B0,$04,$04 ; F65C 04 04 FF B1 04 B0 04 04
        .byte   $B2,$07,$00                     ; F664 B2 07 00
music_music2_sq2Routine2:
        .byte   $B4,$02,$00                     ; F667 B4 02 00
music_music2_sq1Routine2:
        .byte   $9F,$12,$31,$C2,$B1,$3C,$B0,$3C ; F66A 9F 12 31 C2 B1 3C B0 3C
        .byte   $3C,$B1,$32,$32,$FF,$00         ; F672 3C B1 32 32 FF 00
music_music2_triRoutine2:
        .byte   $9F,$00,$00,$C2,$B1,$3C,$B0,$3C ; F678 9F 00 00 C2 B1 3C B0 3C
        .byte   $3C,$B1,$32,$32,$FF,$00         ; F680 3C B1 32 32 FF 00
music_music2_sq1Routine3:
        .byte   $9F,$11,$31,$B1,$3C,$4A,$54,$52 ; F686 9F 11 31 B1 3C 4A 54 52
        .byte   $54,$B0,$4A,$4A,$B1,$4C,$46,$4A ; F68E 54 B0 4A 4A B1 4C 46 4A
        .byte   $B0,$42,$42,$B1,$46,$40,$42,$B0 ; F696 B0 42 42 B1 46 40 42 B0
        .byte   $3C,$3C,$B1,$40,$3A,$3C,$32,$34 ; F69E 3C 3C B1 40 3A 3C 32 34
        .byte   $3A,$3C,$32,$34,$40,$00         ; F6A6 3A 3C 32 34 40 00
music_music2_sq2Routine3:
        .byte   $9F,$10,$31,$B1,$32,$42,$42,$46 ; F6AC 9F 10 31 B1 32 42 42 46
        .byte   $42,$B0,$40,$42,$B1,$46,$40,$42 ; F6B4 42 B0 40 42 B1 46 40 42
        .byte   $B0,$3A,$3C,$B1,$40,$3A,$3C,$B0 ; F6BC B0 3A 3C B1 40 3A 3C B0
        .byte   $30,$32,$B1,$3A,$32,$32,$2A,$2E ; F6C4 30 32 B1 3A 32 32 2A 2E
        .byte   $2E,$32,$2A,$2E,$3A,$00         ; F6CC 2E 32 2A 2E 3A 00
music_music2_triRoutine3:
        .byte   $9F,$00,$00,$C2,$B1,$3C,$B0,$3C ; F6D2 9F 00 00 C2 B1 3C B0 3C
        .byte   $3C,$B1,$32,$32,$FF,$C2,$3C,$B0 ; F6DA 3C B1 32 32 FF C2 3C B0
        .byte   $3C,$3C,$B1,$32,$32,$FF,$C2,$3C ; F6E2 3C 3C B1 32 32 FF C2 3C
        .byte   $B0,$3C,$3C,$B1,$3A,$32,$FF,$00 ; F6EA B0 3C 3C B1 3A 32 FF 00
music_music2_sq1Routine4:
        .byte   $9F,$11,$31,$B1,$3C,$02,$B3,$02 ; F6F2 9F 11 31 B1 3C 02 B3 02
        .byte   $B1,$40,$3A,$3C,$02,$B3,$02,$B2 ; F6FA B1 40 3A 3C 02 B3 02 B2
        .byte   $40,$9F,$10,$31,$C2,$B1,$42,$B0 ; F702 40 9F 10 31 C2 B1 42 B0
        .byte   $42,$42,$B1,$46,$40,$FF,$B1,$42 ; F70A 42 42 B1 46 40 FF B1 42
        .byte   $02,$B3,$02,$B2,$46,$9F,$11,$31 ; F712 02 B3 02 B2 46 9F 11 31
        .byte   $C2,$B1,$4A,$B0,$4A,$4A,$B1,$4C ; F71A C2 B1 4A B0 4A 4A B1 4C
        .byte   $46,$FF,$4A,$02,$B3,$02,$B2,$4E ; F722 46 FF 4A 02 B3 02 B2 4E
        .byte   $9F,$10,$31,$B1,$50,$B0,$50,$50 ; F72A 9F 10 31 B1 50 B0 50 50
        .byte   $B1,$50,$50,$54,$50,$50,$4E,$50 ; F732 B1 50 50 54 50 50 4E 50
        .byte   $B0,$50,$50,$B1,$50,$50,$54,$50 ; F73A B0 50 50 B1 50 50 54 50
        .byte   $50,$4E,$9F,$11,$31,$B1,$50,$B0 ; F742 50 4E 9F 11 31 B1 50 B0
        .byte   $50,$50,$B1,$50,$50,$4E,$B0,$4E ; F74A 50 50 B1 50 50 4E B0 4E
        .byte   $4E,$B1,$4E,$4E,$4C,$B0,$4C,$4C ; F752 4E B1 4E 4E 4C B0 4C 4C
        .byte   $B1,$4C,$46,$40,$42,$46,$38,$9F ; F75A B1 4C 46 40 42 46 38 9F
        .byte   $10,$31,$B1,$46,$9F,$11,$31,$B0 ; F762 10 31 B1 46 9F 11 31 B0
        .byte   $42,$42,$B1,$38,$B2,$42,$B0,$38 ; F76A 42 42 B1 38 B2 42 B0 38
        .byte   $3C,$B1,$38,$32,$B0,$46,$02,$B0 ; F772 3C B1 38 32 B0 46 02 B0
        .byte   $42,$42,$B1,$38,$B2,$42,$B0,$38 ; F77A 42 42 B1 38 B2 42 B0 38
        .byte   $3C,$B1,$38,$30,$9F,$10,$31,$B1 ; F782 3C B1 38 30 9F 10 31 B1
        .byte   $38,$02,$B6,$02,$02,$9F,$13,$31 ; F78A 38 02 B6 02 02 9F 13 31
        .byte   $B2,$3A,$00                     ; F792 B2 3A 00
music_music2_sq2Routine4:
        .byte   $9F,$10,$31,$B1,$32,$02,$B3,$02 ; F795 9F 10 31 B1 32 02 B3 02
        .byte   $B1,$32,$32,$32,$02,$B3,$02,$B2 ; F79D B1 32 32 32 02 B3 02 B2
        .byte   $38,$9F,$11,$31,$B4,$02,$B6,$02 ; F7A5 38 9F 11 31 B4 02 B6 02
        .byte   $B2,$40,$C2,$B1,$42,$B0,$42,$42 ; F7AD B2 40 C2 B1 42 B0 42 42
        .byte   $B1,$46,$40,$FF,$B1,$38,$02,$B3 ; F7B5 B1 46 40 FF B1 38 02 B3
        .byte   $02,$9F,$13,$31,$B2,$3C,$9F,$10 ; F7BD 02 9F 13 31 B2 3C 9F 10
        .byte   $31,$B1,$40,$B0,$42,$46,$B1,$40 ; F7C5 31 B1 40 B0 42 46 B1 40
        .byte   $46,$4A,$4A,$4A,$3C,$40,$B0,$42 ; F7CD 46 4A 4A 4A 3C 40 B0 42
        .byte   $46,$B1,$40,$46,$48,$48,$48,$3C ; F7D5 46 B1 40 46 48 48 48 3C
        .byte   $40,$B0,$42,$46,$B1,$40,$46,$9F ; F7DD 40 B0 42 46 B1 40 46 9F
        .byte   $11,$31,$3C,$B0,$40,$42,$B1,$3C ; F7E5 11 31 3C B0 40 42 B1 3C
        .byte   $42,$9F,$12,$31,$3C,$B0,$40,$42 ; F7ED 42 9F 12 31 3C B0 40 42
        .byte   $B1,$40,$40,$2E,$3C,$40,$28,$9F ; F7F5 B1 40 40 2E 3C 40 28 9F
        .byte   $13,$31,$B1,$32,$9F,$10,$31,$B0 ; F7FD 13 31 B1 32 9F 10 31 B0
        .byte   $32,$32,$B1,$32,$B2,$32,$B0,$32 ; F805 32 32 B1 32 B2 32 B0 32
        .byte   $36,$B1,$32,$2A,$9F,$11,$31,$B0 ; F80D 36 B1 32 2A 9F 11 31 B0
        .byte   $30,$02,$30,$30,$B1,$30,$B2,$30 ; F815 30 02 30 30 B1 30 B2 30
        .byte   $B0,$30,$34,$B1,$30,$2A,$9F,$13 ; F81D B0 30 34 B1 30 2A 9F 13
        .byte   $31,$B1,$28,$02,$B6,$02,$02,$9F ; F825 31 B1 28 02 B6 02 02 9F
        .byte   $13,$31,$B2,$2E,$00,$00         ; F82D 13 31 B2 2E 00 00
music_music2_triRoutine4:
        .byte   $9F,$00,$00,$B1,$3C,$B0,$3C,$3C ; F833 9F 00 00 B1 3C B0 3C 3C
        .byte   $B1,$34,$2E,$3C,$B0,$3C,$3C,$B1 ; F83B B1 34 2E 3C B0 3C 3C B1
        .byte   $3A,$32,$3C,$B0,$3C,$3C,$B1,$34 ; F843 3A 32 3C B0 3C 3C B1 34
        .byte   $2E,$3C,$B0,$3C,$3C,$B1,$2E,$20 ; F84B 2E 3C B0 3C 3C B1 2E 20
        .byte   $C7,$2A,$B0,$42,$2A,$B1,$20,$38 ; F853 C7 2A B0 42 2A B1 20 38
        .byte   $FF,$2A,$B0,$42,$2A,$B1,$2E,$46 ; F85B FF 2A B0 42 2A B1 2E 46
        .byte   $C2,$20,$B0,$38,$20,$B1,$20,$38 ; F863 C2 20 B0 38 20 B1 20 38
        .byte   $2A,$B0,$42,$2A,$B1,$2A,$42,$FF ; F86B 2A B0 42 2A B1 2A 42 FF
        .byte   $FF,$C4,$20,$B0,$38,$20,$B1,$20 ; F873 FF C4 20 B0 38 20 B1 20
        .byte   $38,$FF,$C4,$24,$B0,$3C,$BA,$24 ; F87B 38 FF C4 24 B0 3C BA 24
        .byte   $02,$B1,$24,$3C,$FF,$C3,$B1,$20 ; F883 02 B1 24 3C FF C3 B1 20
        .byte   $BA,$38,$02,$20,$02,$B1,$20,$38 ; F88B BA 38 02 20 02 B1 20 38
        .byte   $FF,$20,$B0,$38,$20,$9F,$A0,$00 ; F893 FF 20 B0 38 20 9F A0 00
        .byte   $B2,$40,$00                     ; F89B B2 40 00
; ----------------------------------------------------------------------------
music_endings_sq1Script:
        .addr   music_endings_sq1Routine1       ; F89E F6 F8
        .addr   music_endings_sq1Routine2       ; F8A0 6D F9
        .addr   music_endings_sq1Routine1       ; F8A2 F6 F8
        .addr   music_endings_sq1Routine3       ; F8A4 B7 F9
        .addr   LFFFF                           ; F8A6 FF FF
        .addr   music_endings_sq1Script         ; F8A8 9E F8
music_endings_sq2Script:
        .addr   music_endings_sq2Routine1       ; F8AA CE F8
        .addr   music_endings_sq2Routine2       ; F8AC 47 F9
        .addr   music_endings_sq2Routine1       ; F8AE CE F8
        .addr   music_endings_sq2Routine3       ; F8B0 91 F9
        .addr   LFFFF                           ; F8B2 FF FF
        .addr   music_endings_sq2Script         ; F8B4 AA F8
music_endings_triScript:
        .addr   music_endings_triRoutine1       ; F8B6 0B F9
        .addr   music_endings_triRoutine2       ; F8B8 7F F9
        .addr   music_endings_triRoutine1       ; F8BA 0B F9
        .addr   music_endings_triRoutine3       ; F8BC D2 F9
        .addr   LFFFF                           ; F8BE FF FF
        .addr   music_endings_triScript         ; F8C0 B6 F8
music_endings_noiseScript:
        .addr   music_endings_noiseRoutine1     ; F8C2 20 F9
        .addr   music_endings_noiseRoutine1     ; F8C4 20 F9
        .addr   music_endings_noiseRoutine1     ; F8C6 20 F9
        .addr   music_endings_noiseRoutine2     ; F8C8 30 F9
        .addr   LFFFF                           ; F8CA FF FF
        .addr   music_endings_noiseScript       ; F8CC C2 F8
; ----------------------------------------------------------------------------
music_endings_sq2Routine1:
        .byte   $9F,$01,$B1,$B1,$56,$B0,$56,$56 ; F8CE 9F 01 B1 B1 56 B0 56 56
        .byte   $56,$4C,$48,$4C,$B1,$56,$B0,$56 ; F8D6 56 4C 48 4C B1 56 B0 56
        .byte   $56,$56,$5A,$5E,$5A,$B1,$56,$B0 ; F8DE 56 56 5A 5E 5A B1 56 B0
        .byte   $56,$56,$5A,$56,$54,$56,$B0,$5A ; F8E6 56 56 5A 56 54 56 B0 5A
        .byte   $5E,$5A,$5E,$5A,$02,$58,$5A,$00 ; F8EE 5E 5A 5E 5A 02 58 5A 00
music_endings_sq1Routine1:
        .byte   $9F,$02,$B1,$B1,$02,$46,$02,$42 ; F8F6 9F 02 B1 B1 02 46 02 42
        .byte   $02,$46,$02,$48,$02,$46,$02,$46 ; F8FE 02 46 02 48 02 46 02 46
        .byte   $02,$42,$02,$42,$00             ; F906 02 42 02 42 00
music_endings_triRoutine1:
        .byte   $9F,$00,$00,$B1,$56,$56,$4C,$54 ; F90B 9F 00 00 B1 56 56 4C 54
        .byte   $56,$56,$4C,$5A,$56,$56,$54,$56 ; F913 56 56 4C 5A 56 56 54 56
        .byte   $50,$56,$4C,$54,$00             ; F91B 50 56 4C 54 00
music_endings_noiseRoutine1:
        .byte   $C6,$B0,$04,$04,$0A,$04,$FF,$B1 ; F920 C6 B0 04 04 0A 04 FF B1
        .byte   $04,$0A,$B0,$04,$04,$B1,$0A,$00 ; F928 04 0A B0 04 04 B1 0A 00
music_endings_noiseRoutine2:
        .byte   $C4,$B0,$04,$04,$0A,$04,$FF,$B1 ; F930 C4 B0 04 04 0A 04 FF B1
        .byte   $01,$B0,$0A,$0A,$B1,$0A,$B0,$0A ; F938 01 B0 0A 0A B1 0A B0 0A
        .byte   $0A,$B2,$0A,$B1,$0A,$04,$00     ; F940 0A B2 0A B1 0A 04 00
music_endings_sq2Routine2:
        .byte   $B1,$60,$B0,$60,$60,$60,$56,$52 ; F947 B1 60 B0 60 60 60 56 52
        .byte   $56,$B1,$60,$B0,$60,$60,$60,$64 ; F94F 56 B1 60 B0 60 60 60 64
        .byte   $68,$64,$B1,$60,$B0,$60,$5E,$B1 ; F957 68 64 B1 60 B0 60 5E B1
        .byte   $5A,$B0,$5A,$56,$B0,$54,$56,$54 ; F95F 5A B0 5A 56 B0 54 56 54
        .byte   $56,$54,$02,$50,$54,$00         ; F967 56 54 02 50 54 00
music_endings_sq1Routine2:
        .byte   $B1,$02,$48,$02,$4C,$02,$48,$02 ; F96D B1 02 48 02 4C 02 48 02
        .byte   $4C,$02,$48,$02,$48,$02,$48,$02 ; F975 4C 02 48 02 48 02 48 02
        .byte   $48,$00                         ; F97D 48 00
music_endings_triRoutine2:
        .byte   $B1,$48,$56,$56,$56,$48,$56,$56 ; F97F B1 48 56 56 56 48 56 56
        .byte   $56,$48,$56,$54,$5A,$46,$54,$4C ; F987 56 48 56 54 5A 46 54 4C
        .byte   $5A,$00                         ; F98F 5A 00
music_endings_sq2Routine3:
        .byte   $9F,$01,$B1,$B1,$64,$B0,$64,$64 ; F991 9F 01 B1 B1 64 B0 64 64
        .byte   $64,$60,$5C,$60,$B1,$64,$B0,$64 ; F999 64 60 5C 60 B1 64 B0 64
        .byte   $64,$64,$60,$5C,$60,$B0,$64,$02 ; F9A1 64 64 60 5C 60 B0 64 02
        .byte   $4C,$50,$B1,$54,$B0,$4C,$5E,$B2 ; F9A9 4C 50 B1 54 B0 4C 5E B2
        .byte   $5A,$B0,$56,$B7,$6E,$00         ; F9B1 5A B0 56 B7 6E 00
music_endings_sq1Routine3:
        .byte   $9F,$01,$B1,$B1,$02,$4C,$02,$4C ; F9B7 9F 01 B1 B1 02 4C 02 4C
        .byte   $02,$4C,$02,$4C,$02,$B0,$48,$48 ; F9BF 02 4C 02 4C 02 B0 48 48
        .byte   $B1,$48,$B0,$48,$48,$B2,$48,$B1 ; F9C7 B1 48 B0 48 48 B2 48 B1
        .byte   $46,$02,$00                     ; F9CF 46 02 00
music_endings_triRoutine3:
        .byte   $B1,$44,$5C,$52,$5C,$44,$5C,$52 ; F9D2 B1 44 5C 52 5C 44 5C 52
        .byte   $5C,$B0,$4C,$02,$54,$54,$B1,$54 ; F9DA 5C B0 4C 02 54 54 B1 54
        .byte   $B0,$54,$54,$B2,$54,$B1,$56,$02 ; F9E2 B0 54 54 B2 54 B1 56 02
        .byte   $00                             ; F9EA 00

; End of "PRG_chunk3" segment
; ----------------------------------------------------------------------------
.code


.segment        "unreferenced_data4": absolute

unreferenced_data4:
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; F9EB 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; F9F3 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$FF,$FF,$FF ; F9FB 00 00 00 00 00 FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FA03 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FA0B FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FA13 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$00,$00,$00 ; FA1B FF FF FF FF FF 00 00 00
        .byte   $00,$00,$20,$00,$00,$00,$00,$00 ; FA23 00 00 20 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FA2B 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FA33 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$FF,$FF,$FF ; FA3B 00 00 00 00 00 FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FA43 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FA4B FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FA53 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$00,$00,$00 ; FA5B FF FF FF FF FF 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FA63 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FA6B 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FA73 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$FF,$FF,$FF ; FA7B 00 00 00 00 00 FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FA83 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FA8B FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FA93 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$00,$00,$00 ; FA9B FF FF FF FF FF 00 00 00
        .byte   $00,$00,$00,$10,$00,$00,$00,$00 ; FAA3 00 00 00 10 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FAAB 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FAB3 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$FF,$FF,$FF ; FABB 00 00 00 00 00 FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FAC3 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FACB FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FAD3 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$00,$00,$00 ; FADB FF FF FF FF FF 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FAE3 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FAEB 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FAF3 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$FF,$FF,$FF ; FAFB 00 00 00 00 00 FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FB03 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FB0B FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FB13 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$00,$00,$00 ; FB1B FF FF FF FF FF 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$40 ; FB23 00 00 00 00 00 00 00 40
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FB2B 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FB33 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$FF,$FF,$FF ; FB3B 00 00 00 00 00 FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FB43 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FB4B FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FB53 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$00,$00,$00 ; FB5B FF FF FF FF FF 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FB63 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FB6B 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FB73 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$FF,$FF,$FF ; FB7B 00 00 00 00 00 FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FB83 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FB8B FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FB93 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$00,$00,$00 ; FB9B FF FF FF FF FF 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FBA3 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FBAB 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FBB3 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$FF,$FF,$FF ; FBBB 00 00 00 00 00 FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FBC3 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FBCB FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FBD3 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$00,$00,$00 ; FBDB FF FF FF FF FF 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FBE3 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FBEB 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FBF3 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$81,$08,$FF,$FF,$FF ; FBFB 00 00 00 81 08 FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$DF,$FF ; FC03 FF FF FF FF FF FF DF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FC0B FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$BD,$FF ; FC13 FF FF FF FF FF FF BD FF
        .byte   $FF,$FF,$FF,$FF,$FF,$00,$00,$00 ; FC1B FF FF FF FF FF 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FC23 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FC2B 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FC33 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$FF,$FF,$FF ; FC3B 00 00 00 00 00 FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FC43 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FC4B FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FE,$FF,$FF,$7F,$FF,$FF ; FC53 FF FF FE FF FF 7F FF FF
        .byte   $F9,$FF,$FF,$EF,$FF,$00,$00,$00 ; FC5B F9 FF FF EF FF 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FC63 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FC6B 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FC73 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$FF,$FF,$FF ; FC7B 00 00 00 00 00 FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FC83 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FC8B FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$7F,$FF,$FF ; FC93 FF FF FF FF FF 7F FF FF
        .byte   $DF,$FF,$FF,$BF,$FF,$00,$00,$00 ; FC9B DF FF FF BF FF 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FCA3 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FCAB 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FCB3 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$FF,$FF,$FF ; FCBB 00 00 00 00 00 FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FCC3 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FCCB FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FCD3 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$00,$00,$00 ; FCDB FF FF FF FF FF 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FCE3 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FCEB 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FCF3 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$FF,$FF,$FF ; FCFB 00 00 00 00 00 FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FD03 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FB,$FF,$FF,$FF,$FD ; FD0B FF FF FF FB FF FF FF FD
        .byte   $FF,$FF,$FF,$FB,$FF,$FF,$FF,$FF ; FD13 FF FF FF FB FF FF FF FF
        .byte   $FF,$FF,$7D,$7F,$FF,$00,$00,$00 ; FD1B FF FF 7D 7F FF 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FD23 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FD2B 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FD33 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$FF,$FF,$FF ; FD3B 00 00 00 00 00 FF FF FF
        .byte   $FF,$FF,$FF,$FB,$FF,$FF,$FF,$FF ; FD43 FF FF FF FB FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FB,$FF,$FF ; FD4B FF FF FF FF FF FB FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FD53 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FD,$AF,$FB,$00,$00,$00 ; FD5B FF FF FD AF FB 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FD63 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FD6B 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FD73 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$FF,$FF,$FF ; FD7B 00 00 00 00 00 FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$EF ; FD83 FF FF FF FF FF FF FF EF
        .byte   $FF,$FF,$FF,$7F,$FE,$F7,$FF,$FF ; FD8B FF FF FF 7F FE F7 FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FD93 FF FF FF FF FF FF FF FF
        .byte   $FF,$FE,$FE,$FF,$FF,$00,$00,$00 ; FD9B FF FE FE FF FF 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FDA3 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FDAB 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FDB3 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$FF,$FF,$FF ; FDBB 00 00 00 00 00 FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FDC3 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$7F,$FF,$FF,$FF,$FF ; FDCB FF FF FF 7F FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FDD3 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$00,$00,$00 ; FDDB FF FF FF FF FF 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FDE3 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FDEB 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FDF3 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$FF,$FF,$FF ; FDFB 00 00 00 00 00 FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$F7 ; FE03 FF FF FF FF FF FF FF F7
        .byte   $FF,$FF,$FF,$F7,$FF,$FF,$FF,$FF ; FE0B FF FF FF F7 FF FF FF FF
        .byte   $FF,$FF,$FF,$FE,$FF,$FB,$FF,$FF ; FE13 FF FF FF FE FF FB FF FF
        .byte   $FF,$FF,$FF,$FF,$FA,$00,$00,$00 ; FE1B FF FF FF FF FA 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FE23 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FE2B 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FE33 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$FF,$FF,$FF ; FE3B 00 00 00 00 00 FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FE43 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FE4B FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FE53 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$00,$00,$00 ; FE5B FF FF FF FF FF 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FE63 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FE6B 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FE73 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$FF,$FF,$FF ; FE7B 00 00 00 00 00 FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FE83 FF FF FF FF FF FF FF FF
        .byte   $FD,$FE,$F7,$FF,$FF,$BF,$FF,$DF ; FE8B FD FE F7 FF FF BF FF DF
        .byte   $FF,$FF,$BF,$FF,$FF,$FF,$FD,$DF ; FE93 FF FF BF FF FF FF FD DF
        .byte   $FF,$BF,$FF,$FF,$FF,$00,$00,$00 ; FE9B FF BF FF FF FF 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FEA3 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FEAB 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FEB3 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$FF,$BF,$FF ; FEBB 00 00 00 00 00 FF BF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$EF ; FEC3 FF FF FF FF FF FF FF EF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FECB FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FED3 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$00,$00,$00 ; FEDB FF FF FF FF FF 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FEE3 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FEEB 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FEF3 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00                 ; FEFB 00 00 00 00
        .byte   $00                             ; FEFF 00
; ----------------------------------------------------------------------------

; End of "unreferenced_data4" segment
; ----------------------------------------------------------------------------
.code


.segment        "PRG_chunk4": absolute

; incremented to reset MMC1 reg
reset:  cld                                     ; FF00 D8
        sei                                     ; FF01 78
        ldx     #$00                            ; FF02 A2 00
        stx     PPUCTRL                         ; FF04 8E 00 20
        stx     PPUMASK                         ; FF07 8E 01 20
@vsyncWait1:
        lda     PPUSTATUS                       ; FF0A AD 02 20
        bpl     @vsyncWait1                     ; FF0D 10 FB
@vsyncWait2:
        lda     PPUSTATUS                       ; FF0F AD 02 20
        bpl     @vsyncWait2                     ; FF12 10 FB
        dex                                     ; FF14 CA
        txs                                     ; FF15 9A
        inc     reset                           ; FF16 EE 00 FF
        lda     #$10                            ; FF19 A9 10
        jsr     setMMC1Control                  ; FF1B 20 A3 AC
        lda     #$00                            ; FF1E A9 00
        jsr     changeCHRBank0                  ; FF20 20 B7 AC
        lda     #$00                            ; FF23 A9 00
        jsr     changeCHRBank1                  ; FF25 20 CB AC
        lda     #$00                            ; FF28 A9 00
        jsr     changePRGBank                   ; FF2A 20 DF AC
        jmp     initRam                         ; FF2D 4C 00 80

; ----------------------------------------------------------------------------
unreferenced_data5:
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FF30 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FF38 00 00 00 00 00 00 00 00
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FF40 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FF48 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FF50 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$BF,$FF,$FF,$FF,$EF,$FF ; FF58 FF FF BF FF FF FF EF FF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FF60 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FF68 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FF70 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FF78 00 00 00 00 00 00 00 00
        .byte   $FF,$FF,$FF,$FF,$EF,$7F,$FF,$FF ; FF80 FF FF FF FF EF 7F FF FF
        .byte   $FF,$FF,$7D,$FF,$FF,$FF,$FF,$FF ; FF88 FF FF 7D FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FF90 FF FF FF FF FF FF FF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FF98 FF FF FF FF FF FF FF FF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FFA0 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FFA8 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FFB0 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FFB8 00 00 00 00 00 00 00 00
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FFC0 FF FF FF FF FF FF FF FF
        .byte   $FF,$FB,$FF,$FF,$FF,$FF,$BF,$FF ; FFC8 FF FB FF FF FF FF BF FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; FFD0 FF FF FF FF FF FF FF FF
        .byte   $BF,$FF,$FF,$7F,$FF,$FF,$FF,$FF ; FFD8 BF FF FF 7F FF FF FF FF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FFE0 00 00 00 00 00 00 00 00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FFE8 00 00 00 00 00 00 00 00
MMC1_PRG:
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; FFF0 00 00 00 00 00 00 00 00
        .byte   $00                             ; FFF8 00
        .byte   $00                             ; FFF9 00
; ----------------------------------------------------------------------------

; End of "PRG_chunk4" segment
; ----------------------------------------------------------------------------
.code


.segment        "VECTORS": absolute

        .addr   nmi                             ; FFFA 05 80
        .addr   reset                           ; FFFC 00 FF
LFFFF           := * + 1
        .addr   irq                             ; FFFE 4A 80

; End of "VECTORS" segment
; ----------------------------------------------------------------------------
.code


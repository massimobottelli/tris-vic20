10 print chr$(147)
20 print " tris"
30 print
40 print "  B B "
50 print " -----"
60 print "  B B "
70 print " -----"
80 print "  B B "
90 clr: rem set constants
100 ox = 1: rem x offset
110 oy = 1: rem y offset
120 p = -1: rem player 1 human, -1 computer
130 c = 0: rem move counter
140 e = 0: rem empty
150 x = 24: rem X synmbol
160 o = 15: rem O symbol
170 s = 77: rem progress symbol
180 pt = 1000: rem pause tie
190 w$ = "": rem winner
200 rem initialize the board
210 for i = 1 to 3: for j = 1 to 3
220 b(i,j) = e: rem board symbol
230 v(i,j) = 1: rem value of symbol
240 next j: next i
250 rem  ----------------
260 rem main loop
270 m = 0: rem count 9 move
280 if p = 1 then gosub 1000: m = m + 1: rem human move
290 if p = -1 then gosub 2000: m = m + 1: rem computer move
300 rem draw the board
310 poke 7680+ox+2*(i-1)+22*oy+44*j,b(i,j): rem draw board
320 gosub 3000: rem check winner
330 p = p * -1: rem change player
340 if m < 9 then 280: rem next move
350 print: print "no winner!"
360 for t = 10 to pt: next t: goto 10: rem restart
370 goto 10
990 rem rem ----------------
1000 rem human move
1010 for k = 1 to 2: rem get row and col coord
1020 get m$(k): if m$(k) = "" then goto 1020: rem get key press
1030 if m$(k) <> "1" and m$(k) <> "2" and m$(k) <> "3" then goto 1020
1040 next k
1050 j = val(m$(1)): rem set row num
1060 i = val(m$(2)): rem set col num
1070 poke 7680+ox+22*(oy+8),(48+j): poke 38400+ox+22*(oy+8),6
1080 poke 7680+ox+22*(oy+8)+1,(48+i): poke 38400+ox+22*(oy+8)+1,6
1090 if b(i,j) <> e then goto 1000: rem if cell not empty get new coord
1100 if b(i,j) = e then b(i,j) = x: rem if cell empty set board symbol
1110 if b(i,j) = x then v(i,j) = 3: rem if cell empty set value to 3
1120 return
1990 rem ----------------
2000 rem computer move
2010 for t = 10 to pt/5: next t: rem pause
2020 bi = 0: rem reset best move
2030 tv = 5: gosub 4000: rem best move to win (5)
2040 if bi = 0 then tv = 3: rem if no win move then check block move
2050 if bi = 0 then gosub 4000: rem best move to block human (3)
2060 if bi = 0 then tv = 0: rem if no block move then random
2070 if bi = 0 then gosub 4000: rem random move
2080 i = bi: j = bj: rem get best move
2090 if b(i,j) <> e then goto 2000: rem if cell not empty get new coord
2100 if b(i,j) = e then b(i,j) = o: rem if cell empty set board symbol
2110 if b(i,j) = o then v(i,j) = 5: rem if cell empty set value to 5
2120 return
2990 rem ----------------
3000 rem check winner
3010 for k = 1 to 3
3020 if b(k,1) = b(k,2) and b(k,2) = b(k,3) and b(k,1) <> e then w$ = chr$(b(k,1))
3030 if b(1,k) = b(2,k) and b(2,k) = b(3,k) and b(1,k) <> e then w$ = chr$(b(1,k))
3040 next k
3050 if b(1,1) = b(2,2) and b(2,2) = b(3,3) and b(1,1) <> e then w$ = chr$(b(1,1))
3060 if b(1,3) = b(2,2) and b(2,2) = b(3,1) and b(1,3) <> e then w$ = chr$(b(1,3))
3070 if w$ <> "" then print
3080 if w$ = chr$(x) then print " you win!"
3090 if w$ = chr$(o) then print " computer wins!"
3100 if w$ = "" then return
3110 for t = 10 to pt: next t: goto 10: rem restart
3990 rem ----------------
4000 rem best move
4010 if s=77 then s=78: poke 7680+28, s: poke 38400+28,6: goto 4010
4020 if s=78 then s=77: poke 7680+28, s: poke 38400+28,6: rem progress symbol
4030 if tv = 0 then bi = int(rnd(1)*3)+1
4040 if tv = 0 then bj = int(rnd(1)*3)+1
4050 if tv = 0 then return: rem random return
4060 rem check rows for two target value (tv)
4070 for ic = 1 to 3
4080 c = 0
4090 for jc = 1 to 3
4100 if v(ic,jc) = tv then c = c + 1
4110 next jc
4120 if c = 2 then gosub 5000: rem find empty cell on row
4130 next ic
4140 rem check columns for two target value (tv)
4150 for jc = 1 to 3
4160 c = 0
4170 for ic = 1 to 3
4180 if v(ic,jc) = tv then c = c + 1
4190 next ic
4200 if c = 2 then gosub 6000: rem find empty cell on col
4210 next jc
4220 rem check diagonal for two target value (tv)
4230 c1 = 0: c2 = 0: p1 = 0: p2 = 0
4240 for ic = 1 to 3
4250 if v(ic,ic) = tv then c1 = c1 + 1 
4260 if v(ic,ic) = 1 then p1 = ic
4270 if v(ic,4-ic) = tv then c2 = c2 + 1 
4280 if v(ic,4-ic) = 1 then p2 = ic
4290 next ic
4300 if c1 = 2 then bi = p1
4310 if c1 = 2 then bj = p1
4320 if c2 = 2 then bi = p2
4330 if c2 = 2 then bj = 4-p2
4340 return
5000 rem sub find empty cell on row
5010 for jc = 1 to 3
5020 if v(ic,jc) = 1 then bi = ic
5030 if v(ic,jc) = 1 then bj = jc
5035 if v(ic,jc) = 1 then return
5040 next jc
5050 return
6000 rem sub find empty cell on col
6010 for ic = 1 to 3
6020 if v(ic,jc) = 1 then bi = ic
6030 if v(ic,jc) = 1 then bj = jc
6035 if v(ic,jc) = 1 then return
6040 next ic
6050 return

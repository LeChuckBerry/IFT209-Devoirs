.macro SAVE
  stp   x29, x30, [sp, -96]!
  mov   x29, sp
  stp   x27, x28, [sp, 16]
  stp   x25, x26, [sp, 32]
  stp   x23, x24, [sp, 48]
  stp   x21, x22, [sp, 64]
  stp   x19, x20, [sp, 80]
.endm

.macro RESTORE
  ldp   x27, x28, [sp, 16]
  ldp   x25, x26, [sp, 32]
  ldp   x23, x24, [sp, 48]
  ldp   x21, x22, [sp, 64]
  ldp   x19, x20, [sp, 80]
  ldp   x29, x30, [sp], 96
.endm

.global main
// Lecture de la chaine de caractere
main:
        adr     x0, fmtStr
        adr     x1, chaine
        bl      scanf
		adr x19, chaine
		mov x21, 0
// On compte le nombre de caractères dans
// la chaine
cptNbChar:
		ldrb 	w20, [x19], 1
		cbz 	w20, lireCodeOp
		add 	x21, x21 ,1
		b 		cptNbChar
// Lecture du code d'opération
lireCodeOp:
	    adr   	x0, fmtOpcode            	//
	   	adr   	x1, nombre              	//
	   	bl      scanf
		// Switch(nombre)
		adr 	x19, chaine
		ldr 	x20, nombre
		cmp 	x20, 0					  	//
		b.eq 	code0						//
		cmp 	x20, 1						//
		b.eq 	code1						//
		cmp 	x20, 2						//
		b.eq 	code2						//
		cmp 	x20, 3						//
		b.eq 	code3
		cmp 	x20, 4
		b.eq 	code4
		cmp 	x20, 5
		b.eq 	code5



// Registres
// -- x19 : adresse chaine
// -- x21 : nombre de caractères
// -- x22 : cpt
code0:
		adr 	x19, chaine
determineLongueur :
		ldrb 	w20, [x19]
		tbz 	w20, 7, UnOctet
		tbz 	w20, 5, DeuxOctets
		tbz 	w20, 4, TroisOctets
		tbz 	w20, 3, QuatreOctets

UnOctet:
		add 	x19, x19, 1
		b 		FinBoucle
DeuxOctets:
		add 	x19, x19, 2
		b 		FinBoucle
TroisOctets:
		add 	x19, x19, 3
		b 		FinBoucle
QuatreOctets:
		add 	x19, x19, 4
		b 		FinBoucle
FinBoucle:
		add 	x22, x22, 1
		cmp 	x22, x21
		b.lo 	determineLongueur
FinCode0:
		adr 	x0, fmtSortie0
		mov 	x1, x22
		bl 		printf
		b 		FinProgramme

code1:

		mov  x23, 0
		adr	 x19, chaine


code2:
		mov  x23, 0
		adr	 x19, chaine


code3:
		mov  	x23, 0
		mov  	x25, x21
		adr	 	x19, chaine
Boucle3:
		ldrb 	w20, [x19]
		cmp	 	w20, 48
		b.eq 	FinBoucle3

		sub 	x24, x21, 1
		mov 	x22, 1
		lsl	 	x22, x22, x24
		add 	x23, x23, x22


FinBoucle3:
		sub 	x21, x21, 1
		cmp 	x21, 0
		add 	x19, x19, 1
		b.hi 	Boucle3
// On étend le bit de signe
		mov 	x21, 64
		sub 	x25, x21, x25
		lsl		x23, x23, x25
		asr 	x23, x23, x25
FinCode3:
		adr x0, fmtSortie3
		mov x1, x23
		bl printf
		b FinProgramme
// Code 4
code4:
		mov  x23, 0
		adr	 x19, chaine
		// On change la prochaine valeur en mémoire
		// et on lui applique la décryption l fois
Boucle4 :
		ldrb 	w20, [x19], 1
		cbz w20, 	FinProgramme
		// On effectue la rotation inverse
		lsl 	x24, x20, 61
		lsr 	x20, x20, 3
		orr 	x20, x20, x24, lsr 56
		// On recule de 7 positions dans l'alphabet
		sub 	x20, x20, 7
		// On imprime un à un les caractères résultants
		adr 	x0, fmtChar
		mov 	x1, x20
		bl 		printf
		add		x23, x23, 1
		cmp  	x23, x21
		b.lo 	Boucle4

code5:
// Stockage d'un caractère d'espace
		mov 	x24, 10
		adr 	x25, espace
		str 	x24, [x25]
// Appel de la fonction permutation
		adr 	x0, chaine
		mov 	x1, 0
		sub 	x2, x21, 1
		bl 		Permutation
		b 		FinProgramme

// Sous-programme permutuation
// Entrées : 1 -­> adresse de la chaine de char,
// 		   : 2 -> indice de départ
//	   	   : 3 -> indice de fin du mot
// Sorties : Impression des permutations de la chaine
// Utilisation des registres
// x19 -- adresse de chaine
// x20 -- indice de depart string a traiter
// x21 -- indice de fin de la string a traiter
// x22 -- i
// w23 et w24 : tmp
Permutation	:
	SAVE
	 	// Si l'indice de départ est égal à celui de fin
		// On peut terminer la récursion

		mov 	x19, x0
		mov 	x20, x1
		mov 	x21, x2
		mov	 	x22, x20
		cmp 	x20, x21
		b.ne 	Boucle5
Imprimer :

		adr 	x0, fmtSortie5
		adr 	x1, chaine
		bl 		printf
		adr	 	x0, fmtSortie5
		adr	 	x1, espace
		bl 		printf
		b 		FinCode5
	Boucle5 :
		// On inverse les lettres aux bons indices
		ldrb 	w23, [x19, x20]
		ldrb  	w24, [x19, x22]
		strb	w23, [x19, x22]
		strb 	w24, [x19, x20]
		// On apelle récursivement la fonction
		adr 	x0, chaine
		add 	x1, x20, 1
		mov 	x2, x21
		bl		Permutation
		// On remet les lettres au bon endroit
		ldrb 	w23, [x19, x20]
		ldrb  	w24, [x19 , x22]
		strb	w23, [x19 , x22]
		strb 	w24, [x19, x20]
	FinBoucle5 :
		add 	x22, x22, 1
		cmp 	x22, x21
		b.lo 	Boucle5
FinCode5:
RESTORE
		ret


FinProgramme:

mov     x0, 0
bl      exit

.section ".data"
// Mémoire allouée pour une chaîne de caractères d'au plus 1024 octets
chaine:         .skip   1024
nombre: 		.skip 	64
espace: 		.skip 	8
.section ".rodata"
// Format pour lire une chaîne de caractères d'une ligne (incluant des espaces)
fmtStr:         .asciz  "%[^\n]s"
fmtOpcode:     	.asciz  "%lu"
fmtChar : 		.asciz 	"%c"
fmtSortie3: 	.asciz  "%ld"
fmtSortie0: 	.asciz  "%lu"
fmtSortie5: 	.asciz  "%s"

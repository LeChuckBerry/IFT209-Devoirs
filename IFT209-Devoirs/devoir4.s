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
main:										//
        adr     x0, fmtStr					//
        adr     x1, chaine					//
        bl      scanf						//
		adr x19, chaine						//
		mov x21, 0							//
// On compte le nombre de caractères dans	//
// la chaine								//
cptNbChar:									//
		ldrb 	w20, [x19], 1				//
		cbz 	w20, lireCodeOp				//
		add 	x21, x21 ,1					//
		b 		cptNbChar					//
// Lecture du code d'opération				//
lireCodeOp:									//
	    adr   	x0, fmtOpcode            	//
	   	adr   	x1, nombre              	//
	   	bl      scanf						//
		// Switch(nombre)					//
		adr 	x19, chaine					//
		ldr 	x20, nombre					//
		cmp 	x20, 0					  	//
		b.eq 	code0						//
		cmp 	x20, 1						//
		b.eq 	code1						//
		cmp 	x20, 2						//
		b.eq 	code2						//
		cmp 	x20, 3						//
		b.eq 	code3						//
		cmp 	x20, 4						//
		b.eq 	code4						//
		cmp 	x20, 5						//
		b.eq 	code5						//
											//
											//
// Registres								//
// -- x19 : adresse chaine					//
// -- x21 : nombre de caractères			//
// -- x22 : cpt								//
code0:										//
		adr 	x19, chaine					//
determineLongueur :							//
		ldrb 	w20, [x19]					//
		tbz 	w20, 7, UnOctet				//
		tbz 	w20, 5, DeuxOctets			//
		tbz 	w20, 4, TroisOctets			//
		tbz 	w20, 3, QuatreOctets		//
											//
UnOctet:									//
		add 	x19, x19, 1					//
		b 		FinBoucle					//
DeuxOctets:									//
		add 	x19, x19, 2					//
		b 		FinBoucle					//
TroisOctets:								//
		add 	x19, x19, 3					//
		b 		FinBoucle					//
QuatreOctets:								//
		add 	x19, x19, 4					//
		b 		FinBoucle					//
FinBoucle:									//
		add 	x22, x22, 1					//
		cmp 	x22, x21					//
		b.lo 	determineLongueur			//
FinCode0:									//
		adr 	x0, fmtSortie0				//
		mov 	x1, x22						//
		bl 		printf						//
		b 		FinProgramme				//
											//
											//
code1:										//
				mov  x23, 0					// i=0
				adr	 x19, chaine			//
											//
		loop1:								//
			udiv x24,x19,2					// test de valeur pair
			mul x24, x24,2					//
											//
			cmp x19,x24						//
			b.eq Paire						//
											//
		Impaire:							//
// le  6e octets de poids faible doit	 	//
//être 0 si il est 1 additionner 0100000	//
//rien fair si il est 0						//
			tbnz x19,6,Change-				//
			bl convertisseur				//
											//
		Paire:								//
			tbz x19,6,Change+				//
			bl Change+						//
			bl convertisseur				//
											//
		Change+:							// change la bit de signe
											//
			add x19,010000					// retire le bit de si
			bl convertisseur				//
		Change-:							// change la bit de signe
			sub x19,010000					// retir le bit de si
			bl convertisseur				//
			convertisseur:					//convertie les voyelles et valeur
			//si  la valeur est code 97 dec /61 hex
			//ou code 65 dec /41 hex remplace
			//par code  52 dec /34 (a,A) -> 4
			cmp x19,97						//
			b.eq quatre						//
			cmp x19,65						//
			b.eq quatre						//
			//si  la valeur est code 101 dec /65 hex | code 69 dec /45 hex
			//remplace par code  51 dec /33 (e,E) -> 3
			cmp x19,101 					//
			b.eq trois						//
			cmp x19,69						//
			b.eq trois						//
			//si  la valeur est code 105 dec /69 hex | code 73 dec /49 hex
			//remplace par code  49 dec /31 (i,I) ->1
			cmp x19,105						//
			b.eq un							//
			cmp x19,73						//
			b.eq un							//
			//si  la valeur est code 111 dec /6F hex | code 79 dec /4F hex
			//remplace par code  48 dec /30 (o,O)-> 0
			cmp x19,111						//
			b.eq zero						//
			cmp x19,79						//
			b.eq zero						//
			bl testfin						//si aucune valeur est remplacer vas a testfin
											//
		quatre:								//
			mov x19,52						// change la valeur pour 4
			bl testfin						//
		trois:								//
			mov x19,51						// change la valeur pour 3
			bl testfin						//
		un:									//
			mov x19,49						// change la valeur pour 1
			bl testfin						//
		zero:								//
			mov x19,48 						// change la valeur pour 0
			bl testfin						//
		testfin:							//
			cbz x19,printcode1				// test si la dernière valeur est vide
		---	ldrb x19, 	// je suis pas sur ici senser avance la position dans la chaine avant ou après tester 0
			bl loop1						// go to début de boucle
		printcode1:							//
		---	adr x0, fmtSortie3 // a modifier//
		---	mov x1, x23 	//a modifier	//
			bl printf						//
			b FinProgramme					//
											//
											//
code2:										//
		adr	 x19, chaine					//
		mov x23,0							// i=0
 loop2:		 								// While(tab[i] == 0)
		cbz x19,traitement 					// tab[i] == 0 (vide) go to  traitement
		ldr [x19,1]        					// tab[i+1]
		add x23,x23,1						//i++
		bl loop2            				//
											//
 traitement:								//
  // la  valeur qui le connecte  == vide 	//
 //alors avant le traitement -1 avant de commencer
	-- Manque sub							// tab[i-1]
	cmp x0,65  								// >= 65
	b.hs AtoF								//
											//
	sub x19,x19,48							//	code de chiffre - 48 ={0,1,...,9}
	bl Accumulateur							//
											//
 AtoF:										//
	sub  x19 ,x19, 55						//  code de chiffre - 55 ={10,11,...,15}
											//
 Accumulateur:								//
											//
		add x20,x20,x19						// additionne la valeur tab[0] ... tab[i-1]
		cmp x23,0  							// si t[actuel] == t[0]
		sub x23,x23,1						//
		b.eq FinCode2						// go to print
 		bl traitement 						// go to traitement
 FinCode2:									//
 		adr x0, fmtSortie2					//
 		mov x1, x23							//
 		bl printf							//
 		b FinProgramme						//
											//
											//
code3:										//
		mov  	x23, 0						//
		mov  	x25, x21					//
		adr	 	x19, chaine					//
Boucle3:									//
		ldrb 	w20, [x19]					//
		cmp	 	w20, 48						//
		b.eq 	FinBoucle3					//
											//
		sub 	x24, x21, 1					//
		mov 	x22, 1						//
		lsl	 	x22, x22, x24				//
		add 	x23, x23, x22				//
											//
											//
FinBoucle3:									//
		sub 	x21, x21, 1					//
		cmp 	x21, 0						//
		add 	x19, x19, 1					//
		b.hi 	Boucle3						//
// On étend le bit de signe					//
		mov 	x21, 64						//
		sub 	x25, x21, x25				//
		lsl		x23, x23, x25				//
		asr 	x23, x23, x25				//
FinCode3:									//
		adr x0, fmtSortie3					//
		mov x1, x23							//
		bl printf							//
		b FinProgramme						//
// Code 4									//
code4:										//
		mov  x23, 0							//
		adr	 x19, chaine					//
// On change la prochaine valeur en mémoire	//
// et on lui applique la décryption l fois	//
Boucle4 :									//
		ldrb 	w20, [x19], 1				//
		cbz w20, 	FinProgramme			//
		// On effectue la rotation inverse	//
		lsl 	x24, x20, 61				//
		lsr 	x20, x20, 3					//
		orr 	x20, x20, x24, lsr 56		//
// On recule de 7 positions dans l'alphabet	//
		sub 	x20, x20, 7					//
// On imprime un à un les caractères résultants	//
		adr 	x0, fmtChar					//
		mov 	x1, x20						//
		bl 		printf						//
		add		x23, x23, 1					//
											//
		cmp  	x23, x21					//
		b.lo 	Boucle4						//
											//
code5:										//
// Stockage d'un caractère d'espace			//
		mov 	x24, 10						//
		adr 	x25, espace					//
		str 	x24, [x25]					//
// Appel de la fonction permutation			//
		adr 	x0, chaine					//
		mov 	x1, 0						//
		sub 	x2, x21, 1					//
		bl 		Permutation					//
		b 		FinProgramme				//
											//
// Sous-programme permutuation				//
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
Permutation	:								//
	SAVE									//
	 	// Si l'indice de départ est égal à celui de fin
		// On peut terminer la récursion
											//
		mov 	x19, x0						//
		mov 	x20, x1						//
		mov 	x21, x2						//
		mov	 	x22, x20					//
		cmp 	x20, x21					//
		b.ne 	Boucle5						//
Imprimer :									//
											//
		adr 	x0, fmtSortie5				//
		adr 	x1, chaine					//
		bl 		printf						//
		adr	 	x0, fmtSortie5				//
		adr	 	x1, espace					//
		bl 		printf						//
		b 		FinCode5					//
	Boucle5 :								//
		// On inverse les lettres aux bons indices
		ldrb 	w23, [x19, x20]				//
		ldrb  	w24, [x19, x22]				//
		strb	w23, [x19, x22]				//
		strb 	w24, [x19, x20]				//
		// On apelle récursivement la fonction
		adr 	x0, chaine					//
		add 	x1, x20, 1					//
		mov 	x2, x21						//
		bl		Permutation					//
		// On remet les lettres au bon endroit
		ldrb 	w23, [x19, x20]				//
		ldrb  	w24, [x19 , x22]			//
		strb	w23, [x19 , x22]			//
		strb 	w24, [x19, x20]				//
	FinBoucle5 :							//
		add 	x22, x22, 1					//
		cmp 	x22, x21					//
		b.lo 	Boucle5						//
FinCode5:									//
RESTORE										//
		ret									//
											//
											//
FinProgramme:								//
											//
mov     x0, 0								//
bl      exit								//

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

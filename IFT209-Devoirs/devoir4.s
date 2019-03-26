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
		adr 	x19, chaine					//
		mov 	x21, 0						//
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
//==========================================//
//=================Code0====================//
//==========================================//
// Registres								//
// -- x19 : adresse chaine					//
// -- x21 : nombre de caractères			//
// -- x22 : cpt								//
code0:										//
		adr 	x19, chaine					//
determineLongueur :							//
		ldrb 	w20, [x19]					//
		cbz 	x20, FinCode0				//
		tbz 	w20, 7, UnOctet				//
		tbz 	w20, 5, DeuxOctets			//
		tbz 	w20, 4, TroisOctets			//
		tbz 	w20, 3, QuatreOctets		//
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
		b		determineLongueur			//
FinCode0:									//
		adr 	x0, fmtSortie0				//
		mov 	x1, x22						//
		bl 		printf						//
		b 		FinProgramme				//
//==========================================//
//=================Code1====================//
//==========================================//
code1:										//
		mov  	x23, 0						// for (i=0; i<chaine.size(), i++)
		adr		x20, chaine					//
											//
loop1:										//
		ldrb	w19, [x20, x23]				//
		tbz 	x23, 0, Pair 				//
Impair:										//
// le  6e bit de poids faible doit	 		//
//être 0,  sinon additionner 32				//
		tbnz 	x19, 5, ToMaj				//
		b 		convertisseur				//
Pair:										//
		tbz 	x19, 5, ToMin				//
		b 		convertisseur				//
ToMin:										//
		add 	x19, x19, 32				// change la lettre en min
		b		convertisseur				//
ToMaj:										// change la lettre en maj
		sub 	x19, x19, 32				// retir le bit de si
		b 		convertisseur				//
convertisseur:								//convertie les voyelles et valeur
// Si c'est A ou a (code 65 ou 97) -­>4 	 //
		cmp 	x19,97						//
		b.eq 	quatre						//
		cmp 	x19,65						//
		b.eq 	quatre						//
// Si c'est E ou e (code 69 ou 101) -> 3	//
		cmp 	x19,101 					//
		b.eq 	trois						//
		cmp 	x19,69						//
		b.eq 	trois						//
// Si c'est I ou i (code 73 ou 105) ->1		//
		cmp 	x19,105						//
		b.eq 	un							//
		cmp 	x19,73						//
		b.eq 	un							//
// Si c'est O ou o (code 79 ou 111)	->0 	//
		cmp 	x19,111						//
		b.eq 	zero						//
		cmp 	x19,79						//
		b.eq 	zero						//
		b 		testfin						// Si aucune valeur n'est remplacé, on a fini le traitement
quatre:										//
		mov 	x19,52						// change la valeur pour 4
		b 		testfin						//
trois:										//
		mov 	x19,51						// change la valeur pour 3
		b 		testfin						//
un:											//
		mov 	x19,49						// change la valeur pour 1
		b 		testfin						//
zero:										//
		mov 	x19,48 						// change la valeur pour 0
		bl 		testfin						//
testfin:									//
		strb	w19, [x20, x23] 			//
		add		x23, x23, 1					//
		cmp 	x23, x21 					// Si on est arrivé au dernier caractère
		b.lo 	loop1						// goto début de boucle
printcode1:									//
		adr 	x0, fmtSortie5				//
		adr 	x1, chaine 					//
		bl 		printf						//
		adr	 	x0, fmtSortie5				//
		adr	 	x1, espace					//
		bl 		printf						//
		b 		FinProgramme				//
//==========================================//
//=================Code2====================//
//==========================================//
code2:										//
		adr	 	x20, chaine					//
		sub 	x21, x21, 1					//
		add 	x20, x20, x21				//
		mov 	x23, 0						// i = 0
		mov		x24,0						// total = 0
Boucle2:									//
		mov 	x19, 0						//
		ldrb 	w19, [x20]					// x19 = tab[lenght-i]
		cmp 	x19, 65  					// Si la valeur est >=65, c'est une lettre
		b.hs 	AtoF						//
											//
		sub 	x19,x19,48					//	code de chiffre - 48 ={0,1,...,9}
		b 		CalculTotal					//
AtoF:										//
		sub  	x19 ,x19, 55				//  code de chiffre - 55 ={10,11,...,15}
CalculTotal:								//
		mov 	x22, 4 						//
		mul 	x22, x23, x22				//
		lsl		x19, x19, x22				// x19 = x19*(2^(i*4))
		add 	x24, x24, x19				// total += x19
											//
		add		x23, x23, 1					//
		sub		x20, x20, 1					//
		cmp		x23, x21					//
		b.ls 	Boucle2						//
FinCode2:									//
 		adr x0, fmtSortie0					//
 		mov x1, x24							//
 		bl printf							//
 		b FinProgramme						//
//==========================================//
//=================Code3====================//
//==========================================//
code3:										//
		mov  	x23, 0						//
		mov  	x25, x21					//
		adr	 	x19, chaine					//
Boucle3:									//
		ldrb 	w20, [x19]					//
		cmp	 	w20, 48						//
		b.eq 	FinBoucle3					//	Si c'est zéro, on ignore
											//
		sub 	x24, x21, 1					// On calcule la puissance de 2 courante
		mov 	x22, 1						//
		lsl	 	x22, x22, x24				// On la calcule et on l'aditionne
		add 	x23, x23, x22				//  aux précédentes
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
//==========================================//
//=================Code4====================//
//==========================================//
code4:										//
		mov  x23, 0							//
		adr	 x19, chaine					//
// On charge la prochaine valeur en mémoire	//
// et on lui applique la décryption l fois	//
Boucle4 :									//
		mov 	x20, 0						//
		ldrb 	w20, [x19], 1				//
											//
// On garde les 5 derniers bits dans x24  	//
		lsl 	x24, x20, 59				//
		lsr		x24, x24, 59				//
// On garde les 3premiers bits dans x20  	//
		sub 	x20, x20, x24				//
// On fait la rotation inverse des 5 bits	//
		lsr 	x25, x24, 3					//
		lsl		x24, x24, 61				//
		lsr		x24, x24, 59 				//
		add		x24, x24, x25				//
// On regroupe les 3 et 5 bits				//
		add  	x20, x24, x20				//
// On recule circulairement 				//
// de 7 positions dans l'alphabet			//
		cmp		x20, 72 					//Si la lettre est apres G
		b.lo 	AtoG						//on recule simplement de 7
		sub 	x20, x20, 7					// positions. Sinon, on
		b		Print4						// avance de 19 positions.
AtoG:										//
		add		x20, x20, 19				//
// On imprime un à un les caractères résultants	//
Print4:
		adr 	x0, fmtChar					//
		mov 	x1, x20						//
		bl 		printf						//
		add		x23, x23, 1					//
											//
		cmp  	x23, x21					//
		b.lo 	Boucle4						//
		b 		FinProgramme				//
//==========================================//
//=================Code5====================//
//==========================================//
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
		b.ls 	Boucle5						//
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
fmtSortie0: 	.asciz  "%lu"
fmtSortie3: 	.asciz  "%ld"
fmtSortie5: 	.asciz  "%s "

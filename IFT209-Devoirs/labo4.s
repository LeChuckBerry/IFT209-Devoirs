// Charles Coupal-Jetté - 14037151
// Martin Roy - 17069878
.global main

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

main:
        // Lire un entier signé x de 32 bits		//
        adr 	x0, fmtX							//
        adr 	x1, nombre							//
        bl 		scanf								// scanf(fmtX, &nombre)
		// Trouver X dans le premier tableau 		//
        adr 	x0, tab0							//
        mov 	x1, 5								//
        ldrsw 	x2, nombre							//
		bl 		find								// find(&tab0, 5, x)
		// Afficher le résultat de find(&tab0, 5, x)//
        adr 	x0, fmtSortie						//
        bl 		printf								// (prinff fmtSortie, x1)
		// Trouver X dans le second tableau 		//
        adr 	x0, tab1							//
        mov 	x1, 2								//
        ldrsw 	x2, nombre							//
		bl 		find								//find(&tab1, 2, x)
		// Afficher le résultat de find(&tab1, 2, x)//
        adr 	x0, fmtSortie						//
        bl 		printf								// (prinff fmtSortie, x1)
		// Trouver X dans le dernier tableau 		//
        adr 	x0, tab2							//
        mov 	x1, 13								//
        ldrsw 	x2, nombre							//
		bl 		find								//find(&tab2, 13,x)
		// Afficher le résultat de find(&tab2, 13,x)//
        adr 	x0, fmtSortie						//
        bl 		printf								//
		// Quitter le programme						//
		mov 	x0, 0								//
        bl      exit								//
// Sous-programme: print_tab                		//
// Entrées:                                 		//
//   - adresse d'un tableau tab             		//
//   - taille n de tab                      		//
// 	 - nombre x à trouver							//
// Effet:  affiche les éléments de tab      		//
// Sortie: mid ou n                           		//
// Utuilisation des registres 						//
// -- x19 : lo										//
// -- x20 : hi										//
// -- x21 : mid										//
// -- x22 : temp									//
// -- x23 : tab[mid]								//
// -- x25 : &tab+mid								//
find:												//
	SAVE											//
		mov 	x20, x1       						// X20 = hi
		mov 	x19, 0        						// lo = 0
		mov		x22, 2								//
find100:
		// Calcul de mid							//
		add 	x21, x20, x19						//
		udiv 	x21, x21, x22						// mid = (lo+hi)/2
		mov 	x25, 4								//
		mul 	x25, x25, x21						// x25 = &tab+mid
		// Lecture de la valeur tab[mid]			//
		ldrsw 	x23, [x0, x25]						// x23 = tab[mid]
		cmp 	x23, x2								//
		b.eq 	trouve 								// if (tab[mid] == x) goto trouve
		b.gt 	chercheGauche						// else if (tab[mid] > x) goto chercheGauche
chercheDroite:										// else chercheDroite
		add 	x21, x21, 1							//
		mov 	x19, x21							// lo = mid+1
		cmp 	x19, x20							//
		b.lt 	find100								// if (lo < hi)	goto find100
		b 		pasTrouve							//goto pasTrouve
chercheGauche:										//
		mov 	x20, x21							// hi = mid
		cmp 	x19, x20							//
		b.lt	 find100							// if (lo < hi)	goto find100
pasTrouve:											//
	RESTORE											//
		ret											// return n
trouve:												//
		mov 	x1, x21								//
	RESTORE											//
		ret											// return mid

.section ".bss"
			.align 4
nombre: 	.skip 4

.section ".data"
		  	.align 4
tab0:     	.word 2, 4, 6, 8, 10					// tableau tab0 ici
tab1:     	.word 4, 205							// tableau tab1 ici
tab2:     	.word -100, -28, -15, 0, 7, 10, 15, 43, 76, 99, 100, 205, 1000// tableau tab2 ici
fmtX: .asciz "%d"
fmtSortie: .asciz "%d\n"

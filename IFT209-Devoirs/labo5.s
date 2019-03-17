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

main:
        // Lire les deux mots à déchiffrer
        adr     x0, fmtEntree
        adr     x1, temp
        bl      scanf
        ldr     w19, temp

        adr     x0, fmtEntree
        adr     x1, temp
        bl      scanf
        ldr     w20, temp

        // Déchiffrer les deux mots
        mov     w0, w19
        mov     w1, w20
        ldr     w2, k0
        ldr     w3, k1
        ldr     w4, k2
        ldr     w5, k3
        bl      dechiffrer

        // Afficher le résultat
        mov     w19, w0
        mov     w20, w1

        adr     x0, fmtSortie
        mov     w1, w19
        mov     w2, w20
        bl      printf

        // Terminer le programme
        mov     x0, 0
        bl      exit

// Procédure de déchiffrement de l'algorithme TEA
// Entrées:
//   - mots w0 et w1 à déchiffrer (32 bits chacun)
//   - clés w2, w3, w4 et w5      (32 bits chacune)
// Sortie: mots w0 et w1 déchiffrés
// Utilisation des registres
// - w23 : i
// - w19 à w21 : temp
// - w22 : (33-i)*delta
dechiffrer:							// Char dechiffrer(w0,w1,w2,w3,w4,w5)
									//
		mov 	w23, 1 			    //
	Boucle : 						// do {
									//
	Calculw1:						//
// Calcul de w0 decal 4 gauche + w4	//
		lsl 	w19, w0, 4 			// tmp1 = w0 decal 4 gauche
		add 	w19, w19, w4 		// w19 += w4
// Calcul de (33-i)*delta + w0		//
		mov 	w22, 33 			// temp4 = 33
		sub 	w20, w22, w23 		// temp2 = 33 - i
		ldr		w22, delta			// temp4 = delta
		mul	 	w22, w22, w20    	// temp2 = delta*(33-i)
		add	 	w20, w22, w0 		// temp2 += w0
// Calcul de w0 decal 5 droite + w5 //
		lsr 	w21, w0, 5			//décalage logique Droite de 5
		add 	w21, w21, w5		//Addition w0 et w5
// Calcul final de w1 				//
//(premier XOR et soustraction)		//
		eor 	w19, w19, w20		//
		eor 	w19, w19, w21		//
		sub 	w1, w1, w19			//w1' = w1 - résultat de ou exclusif
	Calculw0:						//
// Calcul de w2 + w1' decal 4 gauche//
		lsl 	w19, w1, 4			// décalage logique gauche de 4
		add	 	w19, w19, w2		// addition w2 et w1
// Calcul de (33-i)*delta + w0'		//
		add 	w20, w22, w1		//
// Calcul de w0 decal 5 droite + w3 //
		lsr 	w21, w1, 5			//décalage logique Droite de 5
		add 	w21, w21, w3		//Addition w0 decal 5 droite + w3
// Calcul final de w0'				//
		eor 	w19, w19, w20		//
		eor 	w19, w19, w21		//
		sub 	w0, w0, w19			// w0' = w0 - résultat de ou exclusif
									//
									//
		add 	w23, w23, 1			// i++
		cmp		w23, 32				// 	}	
		b.ls	Boucle				// while ( i <= 32)
									//
        ret							// } return


.section ".rodata"
delta:      .word   0x9E3779B9
k0:         .word   0xABCDEF01
k1:         .word   0x11111111
k2:         .word   0x12345678
k3:         .word   0x90000000

fmtEntree:  .asciz  "%X"
fmtSortie:  .asciz  "%c %c\n"

.section ".data"
            .align  4
temp:       .skip   4

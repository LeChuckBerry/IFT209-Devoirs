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
// Utilisation des registres
// x19 -- OpCode
// x20 -- Operande
// x21 -- temp1
// x22 -- temp2
// x23 -- temp3
main:

lireCodeOp:
	    adr   	x0, fmtOpcode            	//
	   	adr   	x1, nombre              	//
	   	bl      scanf                   	//   scanf(&fmtOpcode, nombre)
	   	ldr     x19, nombre             	//   OpCode = nombre
		 cmp 	 x19, 5						 //
		b.eq 	finProgramme				//
lireOperande:								 //
		adr     x0, fmtOperande            	//
		adr     x1, nombre              	//
		bl      scanf                   	//   scanf(&fmtOperande, nombre)
		ldr     x20, nombre             	//   operande = nombre
											 //
SwitchCase:									// 	switch OpCode {
		cmp 	x19, 0						// 		case 0
		b.eq 	code0						// 		goto code0
											//
		cmp 	 x19, 1						//		case 1
		b.eq 	 code1						// 		goto code1
											//
		cmp 	 x19, 2						// 		case 2
		b.eq 	code2						// 		goto code2
											//
		cmp     x19, 3						// 		case 3
		b.eq 	code3						//		goto 3
											//
		cmp 	x19, 4						// 		case 4
		b.eq 	code4						// 		goto code4
											// }
// On stocke l'operande dans l'accumulateur	//
code0:										 //
		adr 	x21, acc					//
		str 	x20, [x21, 8]				// acc* = operande
		b 		afficherCalculatrice		//

// -----------------------------------------//
// ----------------Code 1-------------------//
// -----------------------------------------//
// On charge la valeur de l'accumulateur dans//
// la memoire correspondant a l'operande	//
code1:										//
// On met dans deux registres la valeur de 	//
// l'accumulateur							//
		adr 	x23, acc					 //
		ldr 	x21, [x23]					// x21 = acc[]
		ldr 	x22, [x23, 8]				// x22= acc[8]
// On stocke la valeur dans la memoire 		//
		mov   	x0, x20					 //
    	mov   	x1, x21					 //
    	mov   	x2, x22 				    //
    	bl    	storMem					 // storMem(&mem, val1, val2)
// On réinitialise l'accumulateur			//
		b 		afficherCalculatrice		 //
// -----------------------------------------//
// ----------------Code 2-------------------//
// -----------------------------------------//
// On déplace une valeur dans une cellule	//
// mémoire dans  l'acculumateur 			//
code2:									  //
    	mov   	x0, x20					 //
		bl    	loadMem					 //
// On recupere les valeurs renvoyees par la //
// fonction et on les stockent dans l'acc	 //
    	adr 	x23, acc					 //
    	str 	x0, [x23]					 //
    	str 	x1, [x23, 8]				 //
    	mov 	x0, x20					 //
		b 		afficherCalculatrice		//
// -----------------------------------------//
// ----------------Code 3-------------------//
// -----------------------------------------//
code3:
// Chargement de la valeur de l'accumulateur//
		adr   	x23, acc					 //
		ldr   	x21, [x23]					 //
		ldr   	x22, [x23, 8]				 //
// Chargement de la valeur en mémoire		 //
    	mov   	x0, x20				     //
    	bl    	loadMem					 // loadMem(Operande)
// Addition des nombres avec prise 		 //
    	mov   	x2, x21					 //
    	mov   	x3, x22					 //
    	bl    	Additionner				 // Additionner(val1, val2, val3, val4)
// Stockage dans la cellule du résultat	 //
    	mov   	x2, x0						 //
    	mov   	x0, x20					 //
    	bl  	storMem					 // storMem(Opreamde, val1, val2)
		b	   	afficherCalculatrice		// Connecte au module d'impressiom
// -----------------------------------------//
// ----------------Code 4-------------------//
// -----------------------------------------//
// Soustraction des valeurs en mémoire par 	//
// celle dans l'accumulateur				//
code4:
// Chargement de la valeur de l'accumulateur//
		adr   	x23, acc			 		//
		ldr   	x21, [x23]					//
		ldr   	x22, [x23, 8]				//
// On fait le complément à deux de la valeur//
		mvn		x22, x22 					//
		mvn 	x21, x21 					//
		adds 	x22, x22, 1					//
		mov		x23, 0						//
		adc		x21, x21, x23				//
// Chargement de la valeur en mémoire		//
    	mov   	x0, x20						//
    	bl    	loadMem						//
// Addition des nombres 		 		 	//
    	mov   	x2, x21			 			//
    	mov   	x3, x22	 					//
    	bl    	Additionner					// Additionner(val1, val2, val3, val4)
// Stockage dans la cellule du résultat	 	//
    	mov   	x2, x0						//
    	mov   	x0, x20						//
		bl  	storMem						// storMem(Opreamde, val1, val2)
		b	   	afficherCalculatrice		// Connecte au module d'impression
// Sous-programme: storMem                  //
// Entrées:                                 //
//   - numero de la memoire ou sauvegarder  //
//   - valeur a stocker					 //
//   - valeur a stocker					 //
// Effet: stocke dans la memoire specifiee  //
// les valeurs passees en parametre         //
// Sortie: aucune                           //
storMem:									 //
SAVE										//
    	mov     x20, x0					 // switch (Operande) {
    	cmp     x20, 0						 // 	case 0
	    b.eq    storeMem0					 // 	goto storeMem0
    	cmp     x20, 1						 // 	case 1
    	b.eq    storeMem1					 // 	goto storeMem1
    	cmp     x20, 2						//	case 2
    	b.eq    storeMem2					 // 	goto storeMem2
storeMem0:									 //
		adr 	x23, mem0					 //
		str 	x1, [x23]				 	 //
		str 	x2, [x23, 8]				//
		b 		ExitstorMem				 //
storeMem1:									 //
		adr 	x23, mem1					 //
		str 	x1, [x23]					 //
		str 	x2, [x23, 8]				//
		b 		ExitstorMem				 //
storeMem2:									 //
		adr 	x23, mem2					 //
		str 	x1, [x23]					 //
		str 	x2, [x23, 8]				 //
ExitstorMem:								//
RESTORE										//
		ret								 //
// Sous-programme: loadMem                  //
// Entrées:                                 //
//   - numero de la memoire a charger       //
// Effet: charge dans des registres la      //
// valeur stockee dans la cellule de memoi- //
// memoire specifie                         //
// Sortie: la valeur stockee en memoire     //
loadMem:									 //
SAVE										 //
    	mov 	x23, x0					 // switch case (n.mem)
    	cmp 	x23, 0						 // case 0
    	b.eq    loadMem0					 // goto loadMem0
    	cmp 	x23, 1						 // case 1
    	b.eq    loadMem1					 // goto loadMem1
    	cmp 	x23, 2						 // case 2
    	b.eq    loadMem2					 // goto loadMem2
// On charge la valeur de la mémoire		 //
// corresppondant au numéro					//
loadMem0:								 	 //
    	adr     x23, mem0					 //
    	ldr     x21, [x23]					 //
    	ldr     x22, [x23, 8]				 //
		b 		ExitloadMem				 //
loadMem1:									 //
    	adr 	x23, mem1					 //
    	ldr 	x21, [x23]					 //
    	ldr 	x22, [x23, 8]				//
		b 		ExitloadMem				 //
loadMem2:									 //
    	adr 	x23, mem2					 //
    	ldr 	x21, [x23]   				 //
    	ldr 	x22, [x23, 8]				//
ExitloadMem:							 	 //
    	mov 	x0, x21					 // retourne les deux valeurs
    	mov 	x1, x22					 // stockées dans l'adresse mémoire
RESTORE									 //
    	ret								 //
// Sous-programme: addGrandNombre           //
// Entrées:                                 //
//   - premiere moitie de l'operande 1      //
//   - seconde moitie de l'operande 1       //
// 	 - premiere moitie de l'operande 2      //
//   - seconde moitie de l'operande 2		//
// Effet: addition signée de deux nombres de//
// 128 bits 								//
// Sortie: aucune                           //
Additionner:								 //
SAVE										 // --addition des 64 bits de poids faible
		adds  	x23, x1, x3				 // en mettant à jour l'indicateur de report
		adc   	x26, x0, x2				 // --addition des 64 bits de poids faible
		mov   	x0, x23					 // en récupérant la retenue s'il y a a une
		mov   	x1, x26					 //
RESTORE									 //
		ret								 //
// Sous-programme: afficherCalculatrice     //
// Entrées:  aucune                         //
// Effet: affiche l'état du calculateur		//
// Sortie: calculateur à l'écran            //
afficherCalculatrice:						 //
// Affiche l'acumulateur					 //
		adr 	x0, fmtAcc					 //
		adr 	x21, acc 					 //
		ldr 	x1, [x21]					 //
		ldr 	x2, [x21, 8]				 //
		bl 		printf  					// printf(fmtAcc, acc, acc[8] )
// Affiche mem[0]						 	//
		adr 	x0, fmtMem					 //
		adr 	x21, mem0					 //
		mov 	x1, 0						 //
		ldr 	x2, [x21]					 //
		ldr 	x3, [x21, 8]				 //
		bl 		printf  					// printf(fmtMem, 0, mem0, mem0[8] )
// Affiche mem[1]							 //
		adr 	x0, fmtMem					 //
		adr 	x21, mem1					 //
		mov 	x1, 1						 //
		ldr 	x2, [x21]					 //
		ldr 	x3, [x21, 8]				 //
		bl 		printf  					// printf(fmtMem, 1, mem1, mem1[8] )
// Affiche mem[2]							 //
		adr 	x0, fmtMem					 //
		adr 	x21, mem2					 //
		mov 	x1, 2						 //
		ldr 	x2, [x21]					 //
		ldr 	x3, [x21, 8]				 //
		bl 		printf  					// printf(fmtMem, 2, mem2, mem2[8] )
		b main

finProgramme:								 //
		mov 	x0,0						 //
    	bl      exit						 // quitter le programme

.section ".rodata"
  		fmtOpcode:     .asciz  "%lu"
  		fmtOperande:   .asciz  "%lu"
  		fmtAcc:        .asciz  "acc:    %016lX %016lX\n"
  		fmtMem:        .asciz  "mem[%lu]: %016lX %016lX\n"


  .section ".bss"
  			 	.align 8
  	 	nombre:	.skip 8
  	 	acc:   	.skip 16
  	 	mem0: 	.skip 16
  	 	mem1: 	.skip 16
  	 	mem2: 	.skip 16

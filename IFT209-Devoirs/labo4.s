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
        // Lire un entier signé x de 32 bits
        adr x0, fmtX
        adr x1, nombre
        bl scanf
        // Afficher le résultat de find(&tab0, 5,  x)
        adr x0, tab0
        mov x1, 5
        ldr x2, nombre

        adr x0, fmtX
        bl printf
        // Afficher le résultat de find(&tab1, 2,  x)
        adr x0, tab1
        mov x1, 2
        ldr x2, nombre

        adr x0, fmtX
        bl printf
        // Afficher le résultat de find(&tab2, 13, x)
        adr x0, tab2
        mov x1, 13
        ldr x2, nombre

        adr x0, fmtX
        bl printf

        bl      exit



// x19 - lo
// x20 - hi
// x21 - mid
// x22 - temp
// x23 - tab[mid]
find:
SAVE
mov x20, x1       // x20 = hi
mov x19, 0        // lo = 0
mov x22, 2

find100:
// Calcul de mid
sub x21, x20, x19
udiv x21, x21, x22
// Lecture de la valeur tab[mid]
ldr x23, [x0, x21]
cmp x2, x23
b.eq trouve // if (tab[mid] == x) goto trouve
b.lo chercheGauche

chercheDroite:
  add x21, x21, 1
  mov x19, x21
  cmp x19, x20
  b.lo find100

  b pasTrouve
chercheGauche:
  mov x21, x20
  b find100
  cmp x19, x20
  b.lo find100

  pasTrouve:
  mov x1, x2
  ret


trouve:
mov x1, x21
ret
RESTORE
.section ".bss"
fmtX: .asciz "%d"
nombre : .skip 4


.section ".data"
tab0:    .hword 2, 4, 6, 8, 10// tableau tab0 ici
tab1:    .hword 4, 205// tableau tab1 ici
tab2:    .hword -100, -28, -15, 0, 7, 10, 15, 43, 76, 99, 100, 205, 1000// tableau tab2 ici

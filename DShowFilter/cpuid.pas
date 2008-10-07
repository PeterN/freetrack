unit cpuid;

interface

Function SupporteSEE:Boolean;Register;
Function SupporteSEE2:Boolean;Register;

implementation


Function LireFlagsProcesseur:Cardinal;Register;
// Résultat dans EAX
Asm
  PUSH  EBX
  PUSH  EDI

  // Test de la possiblité d'utiliser CPUID
  // Cette méthode est directement tirée de la doc Intel
  PUSHFD               // Obtentions des Etats actuels
  POP   EAX
  MOV   ECX,EAX        // Sauvegarde...
  XOR   EAX, 200000h   // Changement du bit ID
  PUSH  EAX            // Sauvegarde des Etats dans le proc
  POPFD                //
  PUSHFD               // Obtentions des Etats actuels
  POP   EAX            //
  XOR   EAX,ECX        // Test si le bit ID a été conservé
  JE    @@ERREUR       // Fin si le processeur ne supporte pas CPUID

  // La "fonction" 0 demande le numéro maximum de fonction
  // utilisable.
  MOV   EAX,0          // Fonctin 0 de CPUID
  CPUID
  CMP   EAX,1          // On veut la fonction 1 seulement
  JB    @@ERREUR       // Non supportée

  // Lecture des flags
  MOV   EAX,1          // Fonctin 1 de CPUID
  CPUID
  MOV   EAX,EDX        // Flags contenus dans EDX
  JMP   @@Fin

@@ERREUR:
  XOR   EAX,EAX

@@Fin:
  POP   EDI
  POP   EBX
End;



Function LireFlagsEtendusProcesseur:Cardinal;Register;
// Résultat dans EAX
Asm
  PUSH  EBX
  PUSH  EDI

  // Test de la possiblité d'utiliser CPUID
  // Cette méthode est directement tirée de la doc Intel
  PUSHFD               // Obtentions des Etats actuels
  POP   EAX
  MOV   ECX,EAX        // Sauvegarde...
  XOR   EAX, 200000h   // Changement du bit ID
  PUSH  EAX            // Sauvegarde des Etats dans le proc
  POPFD                //
  PUSHFD               // Obtentions des Etats actuels
  POP   EAX            //
  XOR   EAX,ECX        // Test si le bit ID a été conservé
  JE    @@ERREUR       // Fin si le processeur ne supporte pas CPUID

  // La "fonction" 0 demande le numéro maximum de fonction
  // utilisable.
  MOV   EAX,0          // Fonctin 0 de CPUID
  CPUID
  CMP   EAX,$80000001  // On veut la fonction étendue $80000001
  JB    @@ERREUR       // Non supportée

  // Lecture des flags
  MOV   EAX,$80000001  // Fonctin 1 de CPUID
  CPUID
  MOV   EAX,EDX        // Flags contenus dans EDX
  JMP   @@Fin

@@ERREUR:
  XOR   EAX,EAX

@@Fin:
  POP   EDI
  POP   EBX
End;

Function SupporteSEE:Boolean;Register;
Asm
  CALL  LireFlagsProcesseur // Lecture des flags
  SHR   EAX,25              // On ne garde que le bit 25
  AND   EAX,1               // dans le bit 0 de EAX
End;

Function SupporteSEE2:Boolean;Register;
Asm
  CALL  LireFlagsProcesseur // Lecture des flags
  SHR   EAX,26              // On ne garde que le bit 26
  AND   EAX,1               // dans le bit 0 de EAX
End;
end.
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

extern int yylex();
extern int yylineno;

void yyerror (char const *);
bool checkRepeated (char *array[], char *newName);
void resetArray (char *array[]);
void resetIntArray (int array[]);
void checkEVs(char *ev, int array[], int flag);

int countAttacks = 0;
int countPokemon = 0;

char* namesPokemon[6];
char* namesAttacks[4];

int evs[6];

char* namesObjects[6];

%}

%union{
	char* valString;
}

%token <valString> EOL
%token <valString> ARROBA
%token <valString> POKEMON
%token <valString> OBJECT
%token <valString> ABILITY
%token <valString> SHINY
%token <valString> EVS
%token <valString> DIVISION
%token <valString> HP
%token <valString> ATK
%token <valString> DEF
%token <valString> SPA
%token <valString> SPD
%token <valString> SPE
%token <valString> NATURE
%token <valString> ATTACK
%start S

%%
S	
	: pokemon {if(countPokemon == 0){yyerror("Debe haber como minimo un pokemon en el equipo");exit(0);} else {printf("El equipo esta bien formado\n");}}
	;
pokemon
	: pokemon name object ability shiny spread nature attacks
	| pokemon EOL {if(countAttacks == 0){yyerror("El pokemon debe tener como minimo un ataque");exit(0);}
															countAttacks = 0;resetArray(namesAttacks); resetIntArray(evs);} 
	| /* empty */ 
	;
name
	: POKEMON eol {if(!checkRepeated(namesPokemon, $1)){yyerror("No esta permitido llevar dos pokemon iguales en un equipo"); exit(0);}
				countPokemon++; if(countPokemon > 6){yyerror("El numero de pokemon no puede ser superior a 6"); exit(0);}}				
	| {yyerror("el nombre del pokemon no puede estar vacio"); exit(0);} 
ability
	: ABILITY EOL
	| {yyerror("Se debe especificar la habilidad del pokemon");}
	;
spread
	: EVS hp atk def spa spd spe EOL
	;
hp
    : HP DIVISION {checkEVs($1, evs, 0);}
    | {yyerror("Faltan los EVs en HP");exit(0);}
    ;
atk
    : ATK DIVISION {checkEVs($1, evs, 1);}
    | {yyerror("Faltan los EVs en Atk");exit(0);}
    ;
def
    : DEF DIVISION {checkEVs($1, evs, 2);}
    | {yyerror("Faltan los EVs en Def");exit(0);}
    ;
spa
    : SPA DIVISION {checkEVs($1, evs, 3);}
    | {yyerror("Faltan los EVs en SpA");exit(0);}
    ;
spd
    : SPD DIVISION {checkEVs($1, evs, 4);}
    | {yyerror("Faltan los EVs en SpD");exit(0);}
    ;
spe
    : SPE {checkEVs($1, evs, 5);}
    | {yyerror("Faltan los EVs en Spe");exit(0);}
    ;
nature
	: NATURE EOL
	| {yyerror("Se debe especificar la naturaleza del pokemon");}
attacks
	: attacks ATTACK EOL {countAttacks++; if(countAttacks > 4){printf("el pokemon numero %d tiene un numero invalido de ataques\n", countPokemon+1);
					yyerror("El numero de ataques no puede ser superior a 4"); exit(0);}
					if(!checkRepeated(namesAttacks, $2)){yyerror("Un pokemon no puede tener dos veces el mismo ataque"); exit(0);}}
	|
	;
object
	: ARROBA OBJECT EOL {;if(!checkRepeated(namesObjects, $2)){yyerror("No esta permitido llevar dos objetos iguales en un equipo"); exit(0);}}
	| 
	;
shiny
	: SHINY EOL
	|
	;
eol
	: EOL
	|
	;


%%
int main(int argc, char *argv[]) {
extern FILE *yyin;

	switch (argc) {
		case 1:	yyin=stdin;
			yyparse();
			break;
		case 2: yyin = fopen(argv[1], "r");
			if (yyin == NULL) {
				printf("ERROR: No se ha podido abrir el fichero.\n");
			}
			else {
				yyparse();
				fclose(yyin);
			}
			break;
		default: printf("ERROR: Demasiados argumentos.\nSintaxis: %s [fichero_entrada]\n\n", argv[0]);
	}

	return 0;
}
void yyerror (char const *message) { fprintf (stderr, "Linea %d: %s \n", yylineno, message);}

bool checkRepeated (char *array[], char *newName) {
	int i = 0;
	while (array[i] != NULL){
		if(strcmp(array[i], newName) == 0){
			printf("%s y %s estan repetidos\n", array[i], newName);
			return false;
		}
		i++;
	}
	
	array[i] = newName;
	return true;
}

void resetArray (char *array[]){
	int i = 0;
	while(array[i] != NULL){
		array[i] = '\0';
		i++;
	}
}

void resetIntArray (int array[]){
   for(int i = 0; i < 6; i++){
		array[i] = 0;
	}
}

void checkEVs(char *ev, int array[], int flag){
    int number = atoi(strtok(ev, " ")); 
    if(number > 252){
        yyerror("El numero mamximo de EVs en una caracteristica es 252");
        exit(0);
    }
    switch(flag){
        case 0:
            evs[0] = number;
        break;
        case 1:
            evs[1] = number;
        break;
        case 2:
            evs[2] = number;
        break;
        case 3:
            evs[3] = number;
        break;
        case 4:
            evs[4] = number;
        break;
        case 5:
            evs[5] = number;
        break;
        default:
         printf("Invalid flag on function checkEVs\n");
         exit(-1);
        break;
    }
    int totalEVs = 0;
    for(int i = 0; i < 6; i++){
        totalEVs += evs[i];
    }
    if(totalEVs > 510){
        yyerror("Los EVs totales no pueden superar 510");
        exit(0);
    }
}
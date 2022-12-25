%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

extern int yylex();
extern int yylineno;

void yyerror (char const *);
bool checkRepeated (char *array[], char *newName, int flag);
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
	: pokemon {if(countPokemon == 0){yyerror("Debe haber como minimo un pokemon en el equipo");} else {printf("Su equipo esta formado por %d pokemon, los datos en cada uno de ellos son correctos\n", countPokemon);}}
	;
pokemon
	: pokemon name object ability shiny spread nature attacks
	| pokemon EOL {if(countAttacks == 0){printf("El pokemon %d no tiene ataques\n", countPokemon);yyerror("Todos los pokemon deben tener como minimo un ataque");}
															countAttacks = 0;resetArray(namesAttacks); resetIntArray(evs);} 
	| /* empty */ 
	;
name
	: POKEMON eol {countPokemon++; if(countPokemon > 6){yyerror("El numero de pokemon no puede ser superior a 6");}
				if(!checkRepeated(namesPokemon, $1, 0)){yyerror("No esta permitido llevar dos pokemon iguales en un equipo");}
				}				
	| {yyerror("El nombre del pokemon no puede estar vacio");} 
ability
	: ABILITY EOL
	| {printf("El pokemon %d no tiene habilidad\n", countPokemon);yyerror("Se debe especificar la habilidad de todos los pokemon");}
	;
spread
	: EVS hp atk def spa spd spe EOL
	;
hp
    : HP DIVISION {checkEVs($1, evs, 0);}
    | {printf("Faltan los EVs en HP en el pokemon %d\n", countPokemon);yyerror("Se deben especificar los EVs en todas las caracteristicas");}
    ;
atk
    : ATK DIVISION {checkEVs($1, evs, 1);}
    | {printf("Faltan los EVs en Atk en el pokemon %d\n", countPokemon);yyerror("Se deben especificar los EVs en todas las caracteristicas");}
    ;
def
    : DEF DIVISION {checkEVs($1, evs, 2);}
    | {printf("Faltan los EVs en Def en el pokemon %d\n", countPokemon);yyerror("Se deben especificar los EVs en todas las caracteristicas");}
    ;
spa
    : SPA DIVISION {checkEVs($1, evs, 3);}
    | {printf("Faltan los EVs en SpA en el pokemon %d\n", countPokemon);yyerror("Se deben especificar los EVs en todas las caracteristicas");}
    ;
spd
    : SPD DIVISION {checkEVs($1, evs, 4);}
    | {printf("Faltan los EVs en SpD en el pokemon %d\n", countPokemon);yyerror("Se deben especificar los EVs en todas las caracteristicas");}
    ;
spe
    : SPE {checkEVs($1, evs, 5);}
    | {printf("Faltan los EVs en Spe en el pokemon %d\n", countPokemon);yyerror("Se deben especificar los EVs en todas las caracteristicas");}
    ;
nature
	: NATURE EOL
	| {yyerror("Se debe especificar la naturaleza del pokemon");}
attacks
	: attacks ATTACK eol {countAttacks++; if(countAttacks > 4){printf("El pokemon numero %d tiene un numero invalido de ataques\n", countPokemon);
					yyerror("El numero de ataques no puede ser superior a 4");}
					if(!checkRepeated(namesAttacks, $2, 1)){yyerror("Un pokemon no puede tener dos veces el mismo ataque");}}
	|
	;
object
	: ARROBA OBJECT EOL {;if(!checkRepeated(namesObjects, $2, 0)){yyerror("No esta permitido llevar dos objetos iguales en un equipo");}}
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
void yyerror (char const *message) { fprintf (stderr, "Error linea %d: %s \n", yylineno, message);exit(0);}

bool checkRepeated (char *array[], char *newName, int flag) {
	int i = 0;
	while (array[i] != NULL){
		if(strcmp(array[i], newName) == 0){
			if(flag == 0){
				printf("En los pokemon %d y %d se repite: %s\n", i+1, countPokemon, newName);
			}else{
				printf("En el pokemon %d se repite el ataque: %s\n", countPokemon, newName);
			}
			
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
	char *caracteristica; 
    switch(flag){
        case 0:
            evs[0] = number;
			caracteristica = "HP";
        break;
        case 1:
            evs[1] = number;
			caracteristica = "Atk";
        break;
        case 2:
            evs[2] = number;
			caracteristica = "Def";
        break;
        case 3:
            evs[3] = number;
			caracteristica = "SpA";
        break;
        case 4:
            evs[4] = number;
			caracteristica = "SpD";
        break;
        case 5:
            evs[5] = number;
			caracteristica = "Spe";
        break;
        default:
         printf("Invalid flag on function checkEVs\n");
         exit(-1);
        break;
    }
	if(number > 252){
		printf("Los EVs del pokemon %d en %s son %d\n", countPokemon, caracteristica, number);
        yyerror("El numero mamximo de EVs en una caracteristica es 252");
    }
    int totalEVs = 0;
    for(int i = 0; i < 6; i++){
        totalEVs += evs[i];
    }
    if(totalEVs > 510){
		printf("La suma total de los evs del pokemon %d es de %d\n", countPokemon, totalEVs);
        yyerror("Los EVs totales no pueden superar 510");
    }
}
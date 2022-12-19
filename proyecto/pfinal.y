%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern int yylineno;
void yyerror (char const *);
int countAttacks = 0;
int countPokemon = 0;
%}

%union{
	char* valString;
}

%token <valString> EOL
%token <valString> ARROBA
%token <valString> POKEMON
%token <valString> OBJECT
%token <valString> ABILITY
%token <valString> EVS
%token <valString> NATURE
%token <valString> ATTACK
%start S

%%
S	
	: pokemon {printf("El equipo esta bien formado\n");}
	;
pokemon
	: pokemon POKEMON ARROBA OBJECT ABILITY spread {countAttacks++; if(countPokemon > 6){yyerror("El numero de pokemon no puede ser superior a 6"); exit(0);}}
	| /* empty */ {yyerror("Los datos del pokemon no pueden estar vacios"); exit(0);}
	;
spread
	: EVS NATURE attacks
	;
attacks
	: ATTACK attacks {countAttacks++; if(countAttacks > 4){yyerror("El numero de ataques no puede ser superior a 4"); exit(0);}}
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
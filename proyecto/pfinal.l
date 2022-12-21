/* Xan Limia Garcia, Fernando Seara Romero */
%{
#include <stdlib.h>
#include <string.h>
#include "pfinal.tab.h"
void yyerror (char const *);
%}

%option yylineno

eol \n

ste [ \t]*

pokemon "Incineroar"|"Ferrothorn"|"Metagross"|"Lapras"|"Regieleki"|"Urshifu\-Gmax"

object "Light Clay"|"Magnet"|"Weakness Policy"|"Choice Band"|"Leftovers"|"Sitrus Berry"

arroba " @ "

abilityName "Water Absorb"|"Transistor"|"Clear Body"|"Unseen Fist"|"Iron Barbs"|"Intimidate"

ability "Ability: "{abilityName}

shinyFlag "Yes"|"No"
shiny "Shiny: "{shinyFlag}

division " / "

hp [0-9]+" HP" 
atk [0-9]+" Atk"
def [0-9]+" Def"
spa [0-9]+" SpA"
spd [0-9]+" SpD"
spe [0-9]+" Spe"

evs "EVs: "

natureName "Hardy"|"Lonely"|"Brave"|"Adamant"|"Naughty"|"Bold"|"Docile"|"Relaxed"|"Impish"|"Lax"|"Timid"|"Hasty"|"Serious"|"Jolly"|"Naive"|"Modest"|"Mild"|"Quiet"|"Bashful"|"Rash"|"Calm"|"Gentle"|"Sassy"|"Careful"|"Quirky"
nature {natureName}" Nature"{ste}?

attackName "Hydro Pump"|"Protect"|"Thunder"|"Freeze\-Dry"|"Thunderbolt"|"Volt Switch"|"Electroweb"|"Iron Head"|"Ice Punch"|"Zen Headbutt"|"Wicked Blow"|"Close Combat"|"Sucker Punch"|"Poison Jab"|"Body Press"|"Iron Defense"|"Leech Seed"|"Flare Blitz"|"Darkest Lariat"|"Parting Shot"|"Fake Out"|"Surf"
attack "\- "{attackName}


%%
{ste} {;}
{pokemon} {printf("a %s\n", yytext); yylval.valString = strdup(yytext); return POKEMON;}
{arroba} { printf("b %s\n", yytext); yylval.valString = strdup(yytext); return ARROBA;}
{object} {printf("c %s\n", yytext); yylval.valString = strdup(yytext); return OBJECT;}
{ability} {printf("d %s\n", yytext); yylval.valString = strdup(yytext); return ABILITY;}
{shiny} {yylval.valString = strdup(yytext); return SHINY;}
{evs} {printf("e %s\n", yytext); yylval.valString = strdup(yytext); return EVS;}
{division} {yylval.valString = strdup(yytext); return DIVISION;}
{hp} {yylval.valString = strdup(yytext); return HP;}
{atk} {yylval.valString = strdup(yytext); return ATK;}
{def} {yylval.valString = strdup(yytext); return DEF;}
{spa} {yylval.valString = strdup(yytext); return SPA;}
{spd} {yylval.valString = strdup(yytext); return SPD;}
{spe} {yylval.valString = strdup(yytext); return SPE;}
{nature} {printf("f %s\n", yytext); yylval.valString = strdup(yytext); return NATURE;}
{attack} {printf("g %s\n", yytext); yylval.valString = strdup(yytext); return ATTACK;}
{eol} {printf("h %s\n", yytext); yylval.valString = strdup(yytext); return EOL;}
. {yyerror("Error lexico"); exit(0);}

%%
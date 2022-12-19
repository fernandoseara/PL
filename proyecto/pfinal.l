/* Xan Limia Garcia, Fernando Seara Romero */
%{
#include <stdlib.h>
#include <string.h>
#include "pfinal.tab.h"
void yyerror (char const *);
%}

%option yylineno

eol \n

pokemon "Incineroar"|"Ferrothorn"|"Metagross"|"Lapras"|"Regieleki"|"Urshifu\-Gmax"

object "Light Clay"|"Magnet"|"Weakness Policy"|"Choice Band"|"Leftovers"|"Sitrus Berry"{eol}

arroba " @ "

abilityName "Water Absorb"|"Transistor"|"Clear Body"|"Unseen Fist"|"Iron Barbs"|"Intimidate"

ability {eol}?"Ability: "{abilityName}{eol}

hp [0-9]+" HP" 
atk [0-9]+" Atk"
def [0-9]+" Def"
spa [0-9]+" SpA"
spd [0-9]+" SpD"
spe [0-9]+" Spe"

evs "EVs: "{hp}" / "{atk}" / "{def}" / "{spa}" / "{spd}" / "{spe}{eol}

natureName "Hardy"|"Lonely"|"Brave"|"Adamant"|"Naughty"|"Bold"|"Docile"|"Relaxed"|"Impish"|"Lax"|"Timid"|"Hasty"|"Serious"|"Jolly"|"Naive"|"Modest"|"Mild"|"Quiet"|"Bashful"|"Rash"|"Calm"|"Gentle"|"Sassy"|"Careful"|"Quirky"
nature {natureName}" Nature"{eol}

attackName "Hydro Pump"|"Protect"|"Thunder"|"Freeze\-Dry"|"Thunderbolt"|"Volt Switch"|"Electroweb"|"Iron Head"|"Ice Punch"|"Zen Headbutt"|"Wicked Blow"|"Close Combat"|"Sucker Punch"|"Poison Jab"|"Body Press"|"Iron Defense"|"Leech Seed"
attack "\- "{attackName}{eol}?

invalidPokemon [^{pokemon}]

%%
{pokemon} {printf("a %s\n", yytext); yylval.valString = strdup(yytext); return POKEMON;}
{arroba} { printf("b %s\n", yytext); yylval.valString = strdup(yytext); return ARROBA;}
{object} {printf("c %s\n", yytext); yylval.valString = strdup(yytext); return OBJECT;}
{ability} {printf("d %s\n", yytext); yylval.valString = strdup(yytext); return ABILITY;}
{evs} {printf("e %s\n", yytext); yylval.valString = strdup(yytext); return EVS;}
{nature} {printf(" f%s\n", yytext); yylval.valString = strdup(yytext); return NATURE;}
{attack} {printf(" g%s\n", yytext); yylval.valString = strdup(yytext); return ATTACK;}
{eol} {printf("h %s\n", yytext); yylval.valString = strdup(yytext); return EOL;}
. {yyerror("Error lexico"); exit(0);}

%%
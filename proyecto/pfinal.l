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

pokemon "Incineroar"|"Ferrothorn"|"Metagross"|"Lapras"|"Regieleki"|"Urshifu"|"Raichu"|"Tapu Fini"|"Landorus-Therian"|"Celesteela"|"Rillaboom"|"Gigalith"|"Zacian\-Crowned"|"Kyogre"|"Zapdos"|"Grimmsnarl"|"Coalossal"|"Groudon"|"Gastrodon"|"Whimsicott"|"Arcanine"|"Venusaur"|"Charizard"|"Garchomp"|"Salamence"|"Tyranitar"|"Excadrill"|"Amoonguss"|"Sylveon"|"Umbreon"|"Lucario"|"Rotom-Wash"|"Rotom-Heat"|"Dragonite"|"Gyarados"|"Volcarona"|"Peliper"|"Gengar"|"Talonflame"|"Torkoal"

object "Light Clay"|"Magnet"|"Weakness Policy"|"Choice Band"|"Leftovers"|"Sitrus Berry"|"Focus Sash"|"Safety Goggles"|"Assault Vest"|"Rocky Helmet"|"Shuca Berry"|"Life Orb"|"Choice Scarf"|"Choice Specs"|"Lum Berry"|"Miracle Seed"|"Rusted Sword"|"Eviolite"|"White Herb"|"Laggin Tail"

arroba "@"

abilityName "Water Absorb"|"Transistor"|"Clear Body"|"Unseen Fist"|"Iron Barbs"|"Intimidate"|"Lightning Rod"|"Misty Surge"|"Beast Boost"|"Grassy Surge"|"Intrepid Sword"|"Sturdy"|"Drizzle"|"Prankster"|"Static"|"Steam Engine"|"Flame Body"|"Flash Fire"|"Drought"|"Solar Power"|"Blaze"|"Storm Drain"|"Sticky Hold"|"Sand Force"|"Infiltrator"|"Chlorophyll"|"Justified"|"Overgrow"|"Sand Veil"|"Rough Skin"|"Moxie"|"Sand Stream"|"Sand Rush"|"Mold Breaker"|"Effect Spore"|"Regenerator"|"Cute Charm"|"Pixilate"|"Inner Focus"|"Synchronize"|"Steadfast"|"Levitate"|"Multiscale"|"Swarm"|"Rain Dish"|"Cursed Body"|"Gale Wings"

ability "Ability: "{abilityName}

shinyFlag "Yes"|"No"
shiny "Shiny: "{shinyFlag}

division "/"

hp [0-9]+" HP" 
atk [0-9]+" Atk"
def [0-9]+" Def"
spa [0-9]+" SpA"
spd [0-9]+" SpD"
spe [0-9]+" Spe"

evs "EVs: "

natureName "Hardy"|"Lonely"|"Brave"|"Adamant"|"Naughty"|"Bold"|"Docile"|"Relaxed"|"Impish"|"Lax"|"Timid"|"Hasty"|"Serious"|"Jolly"|"Naive"|"Modest"|"Mild"|"Quiet"|"Bashful"|"Rash"|"Calm"|"Gentle"|"Sassy"|"Careful"|"Quirky"
nature {natureName}" Nature"{ste}?

attackName "Hydro Pump"|"Protect"|"Thunder"|"Freeze\-Dry"|"Thunderbolt"|"Volt Switch"|"Electroweb"|"Iron Head"|"Ice Punch"|"Zen Headbutt"|"Wicked Blow"|"Close Combat"|"Sucker Punch"|"Poison Jab"|"Body Press"|"Iron Defense"|"Leech Seed"|"Flare Blitz"|"Darkest Lariat"|"Parting Shot"|"Fake Out"|"Surf"|"Nuzzle"|"Eerie Impulse"|"Moonblast"|"Scald"|"Calm Mind"|"Swords Dance"|"Earthquake"|"Rock Slide"|"Fly"|"Taunt"|"Burning Jealousy"|"Flash Cannon"|"Meteor Beam"|"Air Slash"|"Grassy Glide"|"Wood Hammer"|"Substitute"|"Rapid Spin"|"Ancient Power"|"Behemoth Blade"|"Sacred Sword"|"Play Rough"|"Explosion"|"Earthquake"|"Stone Edge"|"Hurricane"|"Water Spout"|"Hyper Beam"|"Origin Pulse"|"Thunderbolt"|"Roost"|"Throat Chop"|"Spirit Break"|"Reflect"|"Light Screen"|"Thunder Wave"|"U\-turn"|"Solar Beam"|"Heat Wave"|"Dragon Pulse"|"Blast Burn"|"Earth Power"|"Frenzy Plant"|"Sleep Powder"|"Sludge Bomb"|"Ice Beam"|"Recover"|"Yawn"|"Dragon Claw"|"Draco Meteor"|"Tailwind"|"Dark Pulse"|"Spore"|"Giga Drain"|"Snarl"|"Will\-O\-Wisp"|"Extreme Speed"|"Flamethrower"|"Hyper Voice"|"Shadow Ball"|"Nasty Plot"|"Trick"|"Crunch"|"Dragon Dance"|"Brick Break"|"Waterfall"|"Brave Bird"|"Quiver Dance"|"Bug Buzz"|"Blizzard"
attack "\- "{attackName}


%%
{ste} {;}
{pokemon} {yylval.valString = strdup(yytext); return POKEMON;}
{arroba} {yylval.valString = strdup(yytext); return ARROBA;}
{object} {yylval.valString = strdup(yytext); return OBJECT;}
{ability} {yylval.valString = strdup(yytext); return ABILITY;}
{shiny} {yylval.valString = strdup(yytext); return SHINY;}
{evs} {yylval.valString = strdup(yytext); return EVS;}
{division} {yylval.valString = strdup(yytext); return DIVISION;}
{hp} {yylval.valString = strdup(yytext); return HP;}
{atk} {yylval.valString = strdup(yytext); return ATK;}
{def} {yylval.valString = strdup(yytext); return DEF;}
{spa} {yylval.valString = strdup(yytext); return SPA;}
{spd} {yylval.valString = strdup(yytext); return SPD;}
{spe} {yylval.valString = strdup(yytext); return SPE;}
{nature} {yylval.valString = strdup(yytext); return NATURE;}
{attack} {yylval.valString = strdup(yytext+2); return ATTACK;}
{eol} {yylval.valString = strdup(yytext); return EOL;}
. {printf("no se reconce la expresion: %s\n", yytext);yyerror("Error lexico");}

%%
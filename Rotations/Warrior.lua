local _, ns = ...
ns = ns or TacticsCoachNS
ns.builtin = ns.builtin or {}

-- IDs verificados contra el Spell.dbc 3.3.5a del servidor (rango maximo de cada uno).
-- Las posturas no se cambian: lo que no se puede usar en la postura actual se salta solo.

-- Furia (PvE): Sed de sangre > Torbellino > Embate con Ataque sanguinario > Ejecutar; Golpe heroico como volcado de ira.
table.insert(ns.builtin, {
en = [[
id: tc-warrior-fury
rotation: Fury
class: WARRIOR
spec: Fury
tree: 2
mode: pve
author: Tactics Coach
version: 1
description: Bloodthirst and Whirlwind on cooldown, instant Slam on every Bloodsurge proc, and Heroic Strike to spend extra rage so you never cap.

spell battle = 47436
spell commanding = 47440
spell deathwish = 12292
spell reck = 1719
spell berserker = 18499
spell bloodrage = 2687
spell hs = 47450
spell bt = 23881
spell ww = 1680
spell slam = 47475
spell execute = 47471
aura slamproc = 46916

action battle if buff.battle.down and buff.commanding.down -- No shout on you: Battle Shout gives the whole group attack power.
action deathwish if combat -- Death Wish: +20% damage for 30 seconds, use it on cooldown.
action reck if combat -- Recklessness: your next 3 special attacks crit, line it up with Death Wish.
action bloodrage if combat and rage < 50 -- Bloodrage: free rage when you are short of it.
action berserker if combat and rage < 50 -- Berserker Rage: enrage and extra rage from hits you take, on cooldown.
action hs if rage >= 75 -- Lots of rage: queue Heroic Strike (off the global cooldown) so the rage is not wasted.
action bt -- Bloodthirst is your strongest attack: use it every time it comes off cooldown.
action ww -- Whirlwind right after: hits up to 4 targets and has a short cooldown.
action slam if buff.slamproc.up -- Bloodsurge proc (Slam!): instant Slam, spend it before it expires.
action execute -- Below 20% health, Execute fills the gaps between Bloodthirst and Whirlwind.
action hs if rage >= 40 -- Nothing else ready: dump spare rage into Heroic Strike.
]],
es = [[
id: tc-warrior-fury
rotacion: Furia
clase: WARRIOR
especializacion: Furia
arbol: 2
modo: pve
autor: Tactics Coach
version: 1
descripcion: Sed de sangre y Torbellino en cuanto estén listos, Embate instantáneo con cada Ataque sanguinario y Golpe heroico para gastar la ira sobrante y no llegar al tope.

hechizo batalla = 47436
hechizo orden = 47440
hechizo deseo = 12292
hechizo temeridad = 1719
hechizo rabiosa = 18499
hechizo sangrienta = 2687
hechizo heroico = 47450
hechizo sed = 23881
hechizo torbellino = 1680
hechizo embate = 47475
hechizo ejecutar = 47471
aura sanguinario = 46916

accion batalla si beneficio.batalla.inactivo y beneficio.orden.inactivo -- Sin grito encima: Grito de batalla da poder de ataque a todo el grupo.
accion deseo si combate -- Deseo de muerte: +20% de daño durante 30 segundos, úsalo cada vez que esté listo.
accion temeridad si combate -- Temeridad: tus 3 siguientes ataques especiales son críticos, júntala con Deseo de muerte.
accion sangrienta si combate y ira < 50 -- Ira sangrienta: ira gratis cuando te falta.
accion rabiosa si combate y ira < 50 -- Ira rabiosa: te enfurece y te da más ira por los golpes que recibes, úsala cuando esté lista.
accion heroico si ira >= 75 -- Mucha ira: encola Golpe heroico (no usa el tiempo global) para no desperdiciarla.
accion sed -- Sed de sangre es tu ataque más fuerte: úsalo cada vez que salga de reutilización.
accion torbellino -- Torbellino justo después: golpea hasta a 4 objetivos y tiene reutilización corta.
accion embate si beneficio.sanguinario.activo -- Ataque sanguinario (¡Embate!): Embate instantáneo, gástalo antes de que se acabe.
accion ejecutar -- Por debajo del 20% de vida, Ejecutar rellena los huecos entre Sed de sangre y Torbellino.
accion heroico si ira >= 40 -- Nada más listo: gasta la ira que sobra en Golpe heroico.
]],
})

-- Armas (PvE): Desgarrar > Abrumar (Sabor de sangre) > Golpe mortal > Ejecutar (Muerte subita / <20%) > Filotormenta > Embate.
table.insert(ns.builtin, {
en = [[
id: tc-warrior-arms
rotation: Arms
class: WARRIOR
spec: Arms
tree: 1
mode: pve
author: Tactics Coach
version: 1
description: Keep Rend up to feed Taste for Blood, use every Overpower and Mortal Strike, Execute on Sudden Death procs, and fill with Slam.

spell battle = 47436
spell commanding = 47440
spell rend = 47465
spell overpower = 7384
spell ms = 47486
spell execute = 47471
spell bladestorm = 46924
spell hs = 47450
spell slam = 47475

action battle if buff.battle.down and buff.commanding.down -- No shout on you: Battle Shout gives the whole group attack power.
action rend if debuff.rend.remains < 2 -- Keep Rend on the target: it bleeds and makes Taste for Blood proc Overpower.
action overpower -- Overpower only lights up after a dodge or a Taste for Blood proc: it cannot be dodged and crits often.
action ms -- Mortal Strike on cooldown: your main hit.
action execute -- Execute below 20% health or on a Sudden Death proc.
action bladestorm if combat -- Bladestorm: 6 seconds of Whirlwinds, use it on cooldown when Mortal Strike is not ready.
action hs if rage >= 60 -- Spare rage: queue Heroic Strike (off the global cooldown) so it is not wasted.
action slam -- Nothing else ready: Slam is the filler (stand still, it has a cast time).
]],
es = [[
id: tc-warrior-arms
rotacion: Armas
clase: WARRIOR
especializacion: Armas
arbol: 1
modo: pve
autor: Tactics Coach
version: 1
descripcion: Mantén Desgarrar para que salte Sabor de sangre, usa cada Abrumar y Golpe mortal, Ejecutar con Muerte súbita y rellena con Embate.

hechizo batalla = 47436
hechizo orden = 47440
hechizo desgarrar = 47465
hechizo abrumar = 7384
hechizo mortal = 47486
hechizo ejecutar = 47471
hechizo filotormenta = 46924
hechizo heroico = 47450
hechizo embate = 47475

accion batalla si beneficio.batalla.inactivo y beneficio.orden.inactivo -- Sin grito encima: Grito de batalla da poder de ataque a todo el grupo.
accion desgarrar si perjuicio.desgarrar.restante < 2 -- Mantén Desgarrar en el objetivo: sangra y hace que Sabor de sangre active Abrumar.
accion abrumar -- Abrumar solo se enciende tras una esquiva o con Sabor de sangre: no se puede esquivar y critea mucho.
accion mortal -- Golpe mortal en cuanto esté listo: tu golpe principal.
accion ejecutar -- Ejecutar por debajo del 20% de vida o con Muerte súbita.
accion filotormenta si combate -- Filotormenta: 6 segundos de Torbellinos, úsala cuando esté lista y Golpe mortal no lo esté.
accion heroico si ira >= 60 -- Ira de sobra: encola Golpe heroico (no usa el tiempo global) para no desperdiciarla.
accion embate -- Nada más listo: Embate es el relleno (quieto, tiene tiempo de lanzamiento).
]],
})

-- Proteccion (PvE, tanque): Golpe con escudo > Revancha > Onda de choque > Golpe conmocionador > Atronar/Grito desmoralizador > Devastar.
table.insert(ns.builtin, {
en = [[
id: tc-warrior-protection
rotation: Protection
class: WARRIOR
spec: Protection
tree: 3
mode: pve
author: Tactics Coach
version: 1
description: Shield Slam and Revenge for threat, keep Thunder Clap and Demoralizing Shout on the target, and fill with Devastate. Heroic Strike spends extra rage.

spell commanding = 47440
spell battle = 47436
spell shieldwall = 871
spell laststand = 12975
spell block = 2565
spell slam = 47488
spell revenge = 57823
spell shockwave = 46968
spell concussion = 12809
spell thunder = 47502
spell demo = 47437
spell devastate = 47498
spell hs = 47450
aura sword = 50227

action shieldwall if combat and health < 25 -- Very low health: Shield Wall cuts the damage you take by 60%.
action laststand if combat and health < 35 -- Low health: Last Stand gives you 30% extra maximum health for 20 seconds.
action commanding if buff.commanding.down and buff.battle.down -- No shout on you: Commanding Shout gives the group extra health.
action block if combat -- Shield Block on cooldown: fewer hits get through and Shield Slam hits much harder.
action slam if buff.sword.up -- Sword and Board proc: free Shield Slam with no cooldown, use it now.
action slam -- Shield Slam is your biggest threat hit: use it on cooldown.
action revenge -- Revenge lights up after you block, dodge or parry: cheap and lots of threat.
action shockwave if combat -- Shockwave: frontal stun and strong area threat.
action concussion if combat -- Concussion Blow: stun plus good single-target threat.
action thunder if debuff.thunder.remains < 2 -- Keep Thunder Clap up: slows the enemies' attack speed and hits all around you.
action demo if debuff.demo.remains < 3 -- Keep Demoralizing Shout up: lowers the attack power of everything near you.
action hs if rage >= 60 -- Spare rage: queue Heroic Strike (off the global cooldown) for extra threat.
action devastate -- Filler: Devastate stacks Sunder Armor and keeps threat flowing.
]],
es = [[
id: tc-warrior-protection
rotacion: Protección
clase: WARRIOR
especializacion: Protección
arbol: 3
modo: pve
autor: Tactics Coach
version: 1
descripcion: Golpe con escudo y Revancha para la amenaza, mantén Atronar y Grito desmoralizador en el objetivo y rellena con Devastar. Golpe heroico gasta la ira sobrante.

hechizo orden = 47440
hechizo batalla = 47436
hechizo muro = 871
hechizo recurso = 12975
hechizo bloqueo = 2565
hechizo escudo = 47488
hechizo revancha = 57823
hechizo onda = 46968
hechizo conmocion = 12809
hechizo atronar = 47502
hechizo desmoralizador = 47437
hechizo devastar = 47498
hechizo heroico = 47450
aura espada = 50227

accion muro si combate y vida < 25 -- Muy poca vida: Muro de escudo reduce un 60% el daño que recibes.
accion recurso si combate y vida < 35 -- Poca vida: Último recurso te da un 30% más de vida máxima durante 20 segundos.
accion orden si beneficio.orden.inactivo y beneficio.batalla.inactivo -- Sin grito encima: Grito de orden da más vida al grupo.
accion bloqueo si combate -- Bloqueo con escudo cuando esté listo: entran menos golpes y Golpe con escudo pega mucho más.
accion escudo si beneficio.espada.activo -- Espada y escudo: Golpe con escudo gratis y sin reutilización, úsalo ya.
accion escudo -- Golpe con escudo es tu golpe de más amenaza: úsalo cada vez que esté listo.
accion revancha -- Revancha se enciende tras bloquear, esquivar o parar: barata y con mucha amenaza.
accion onda si combate -- Onda de choque: aturde en cono y genera mucha amenaza en área.
accion conmocion si combate -- Golpe conmocionador: aturde y da buena amenaza a un objetivo.
accion atronar si perjuicio.atronar.restante < 2 -- Mantén Atronar: ralentiza los ataques de los enemigos y golpea a todos a tu alrededor.
accion desmoralizador si perjuicio.desmoralizador.restante < 3 -- Mantén Grito desmoralizador: baja el poder de ataque de todo lo que tienes cerca.
accion heroico si ira >= 60 -- Ira de sobra: encola Golpe heroico (no usa el tiempo global) para más amenaza.
accion devastar -- Relleno: Devastar acumula Hender armadura y mantiene la amenaza.
]],
})

-- Armas (PvP, temporada 8): Golpe mortal siempre puesto, Seccionar tendon mantenido, Zurrar a los lanzamientos.
table.insert(ns.builtin, {
en = [[
id: tc-warrior-arms-pvp
rotation: Arms (PvP)
class: WARRIOR
spec: Arms
tree: 1
mode: pvp
author: Tactics Coach
version: 1
description: Keep Mortal Strike's healing reduction and Hamstring on your target, interrupt casts with Pummel, and burst with Overpower, Execute and Bladestorm.

spell regen = 55694
spell pummel = 6552
spell victory = 34428
spell hamstring = 1715
spell ms = 47486
spell overpower = 7384
spell execute = 47471
spell rend = 47465
spell bladestorm = 46924
spell battle = 47436
spell commanding = 47440
spell hs = 47450

action regen if health < 40 -- Low health while enraged: Enraged Regeneration heals 30% of your health.
action pummel if target.casting -- The target is casting: Pummel interrupts it and locks that school (Berserker Stance).
action victory if health < 80 -- After a killing blow: Victory Rush is a free hit that heals you.
action hamstring if target.player and debuff.hamstring.remains < 2 -- Keep Hamstring on players: a slowed target cannot kite you.
action ms if debuff.ms.remains < 2 -- Mortal Strike is falling off: renew the healing reduction first.
action overpower -- Overpower after a dodge or Taste for Blood: cannot be dodged and crits often.
action execute -- Execute below 20% health or on a Sudden Death proc: your kill shot.
action ms -- Mortal Strike on cooldown: your main hit and the 50% healing reduction.
action rend if debuff.rend.down and target.health > 30 -- Rend feeds Taste for Blood procs for more Overpowers.
action bladestorm if combat -- Bladestorm: big damage and immune to stuns and roots while it spins.
action battle if buff.battle.down and buff.commanding.down -- No shout on you: Battle Shout for more attack power.
action hs if rage >= 60 -- Spare rage: queue Heroic Strike (off the global cooldown).
]],
es = [[
id: tc-warrior-arms-pvp
rotacion: Armas (PvP)
clase: WARRIOR
especializacion: Armas
arbol: 1
modo: pvp
autor: Tactics Coach
version: 1
descripcion: Mantén la reducción de sanación de Golpe mortal y Seccionar tendón en tu objetivo, interrumpe con Zurrar y revienta con Abrumar, Ejecutar y Filotormenta.

hechizo regeneracion = 55694
hechizo zurrar = 6552
hechizo victoria = 34428
hechizo tendon = 1715
hechizo mortal = 47486
hechizo abrumar = 7384
hechizo ejecutar = 47471
hechizo desgarrar = 47465
hechizo filotormenta = 46924
hechizo batalla = 47436
hechizo orden = 47440
hechizo heroico = 47450

accion regeneracion si vida < 40 -- Poca vida y enfurecido: Regeneración enfurecida te cura un 30% de la vida.
accion zurrar si objetivo.lanzando -- El objetivo está lanzando: Zurrar lo interrumpe y le bloquea esa escuela (actitud rabiosa).
accion victoria si vida < 80 -- Tras dar un golpe mortal a un enemigo: Arremetida victoriosa es un golpe gratis que te cura.
accion tendon si objetivo.jugador y perjuicio.tendon.restante < 2 -- Mantén Seccionar tendón en los jugadores: si va lento no puede alejarse de ti.
accion mortal si perjuicio.mortal.restante < 2 -- Golpe mortal se acaba: renueva primero la reducción de sanación.
accion abrumar -- Abrumar tras una esquiva o con Sabor de sangre: no se puede esquivar y critea mucho.
accion ejecutar -- Ejecutar por debajo del 20% de vida o con Muerte súbita: tu golpe para rematar.
accion mortal -- Golpe mortal cuando esté listo: tu golpe principal y la reducción de sanación del 50%.
accion desgarrar si perjuicio.desgarrar.inactivo y objetivo.vida > 30 -- Desgarrar alimenta Sabor de sangre para tener más Abrumar.
accion filotormenta si combate -- Filotormenta: mucho daño e inmune a aturdimientos y raíces mientras gira.
accion batalla si beneficio.batalla.inactivo y beneficio.orden.inactivo -- Sin grito encima: Grito de batalla para más poder de ataque.
accion heroico si ira >= 60 -- Ira de sobra: encola Golpe heroico (no usa el tiempo global).
]],
})

local _, ns = ...
ns = ns or TacticsCoachNS
ns.builtin = ns.builtin or {}

-- IDs verificados contra el Spell.dbc 3.3.5a del servidor (rango maximo de cada uno).
-- La misma rotacion en los dos idiomas: el id fijo hace que cambiar de idioma no la vuelva otra.
-- En 3.3.5a no existe Poder Sagrado: todo es prioridad por reutilizaciones (FCFS) y mana.

-- Reprension PvE (ICC): FCFS de Elitist Jerks 3.3.
table.insert(ns.builtin, {
en = [[
id: tc-paladin-retribution
rotation: Retribution
class: PALADIN
spec: Retribution
tree: 3
mode: pve
author: Tactics Coach
version: 1
description: First come, first served: whatever is ready first, in this order. Judgement, Hammer of Wrath, Crusader Strike, Divine Storm, Consecration, and Exorcism only with The Art of War.

spell vengeance = 31801         # Seal of Vengeance (Alliance)
spell corruption = 53736        # Seal of Corruption (Horde)
spell avenging = 31884          # Avenging Wrath
spell plea = 54428              # Divine Plea
spell judgement = 53408         # Judgement of Wisdom
spell hammer = 48806            # Hammer of Wrath
spell crusader = 35395          # Crusader Strike
spell storm = 53385             # Divine Storm
spell consecration = 48819
spell exorcism = 48801
spell holywrath = 48817         # Holy Wrath
aura artofwar = 59578           # The Art of War (proc)

action vengeance if buff.vengeance.down and buff.corruption.down -- Seal of Vengeance always on: it stacks a DoT and is your best single-target seal.
action corruption if buff.vengeance.down and buff.corruption.down -- Seal of Corruption always on: it stacks a DoT and is your best single-target seal.
action avenging if combat -- Avenging Wrath on cooldown: +20% damage for 20 seconds.
action plea if mana < 70 -- Divine Plea whenever mana dips: you lose nothing as Ret and it keeps you from running dry.
action judgement -- Judgement on cooldown: big hit and it restores mana.
action hammer -- Hammer of Wrath only works below 20% health: in execute it goes before everything else.
action crusader -- Crusader Strike on cooldown: your main strike.
action storm -- Divine Storm on cooldown: hits up to 4 enemies, even on a single target it is pure damage.
action consecration if mana > 25 -- Consecration on cooldown while you have mana: free damage under the boss.
action exorcism if buff.artofwar.up -- The Art of War makes Exorcism instant: spend the proc before the next one.
action holywrath if mana > 40 -- Holy Wrath as the last filler when everything else is on cooldown.
]],
es = [[
id: tc-paladin-retribution
rotacion: Reprensión
clase: PALADIN
especializacion: Reprensión
arbol: 3
modo: pve
autor: Tactics Coach
version: 1
descripcion: El primero que esté listo, en este orden: Sentencia, Martillo de cólera, Golpe de cruzado, Tormenta divina, Consagración y Exorcismo solo con El arte de la guerra.

hechizo venganza = 31801        # Sello de venganza (Alianza)
hechizo corrupcion = 53736      # Sello de corrupción (Horda)
hechizo colera = 31884          # Cólera vengativa
hechizo suplica = 54428         # Súplica divina
hechizo sentencia = 53408       # Sentencia de sabiduría
hechizo martillo = 48806        # Martillo de cólera
hechizo cruzado = 35395         # Golpe de cruzado
hechizo tormenta = 53385        # Tormenta divina
hechizo consagracion = 48819
hechizo exorcismo = 48801
hechizo colerasagrada = 48817   # Cólera sagrada
aura artedelaguerra = 59578     # El arte de la guerra (proc)

accion venganza si beneficio.venganza.inactivo y beneficio.corrupcion.inactivo -- Sello de venganza siempre puesto: acumula un daño periódico y es tu mejor sello a un objetivo.
accion corrupcion si beneficio.venganza.inactivo y beneficio.corrupcion.inactivo -- Sello de corrupción siempre puesto: acumula un daño periódico y es tu mejor sello a un objetivo.
accion colera si combate -- Cólera vengativa en cuanto esté lista: +20% de daño durante 20 segundos.
accion suplica si mana < 70 -- Súplica divina cuando baje el maná: como Reprensión no pierdes nada y no te quedas seco.
accion sentencia -- Sentencia en cuanto esté lista: golpe fuerte y te devuelve maná.
accion martillo -- Martillo de cólera solo funciona por debajo del 20%: en esa fase va antes que todo.
accion cruzado -- Golpe de cruzado en cuanto esté listo: tu golpe principal.
accion tormenta -- Tormenta divina en cuanto esté lista: pega hasta a 4 enemigos y a uno solo también es puro daño.
accion consagracion si mana > 25 -- Consagración en cuanto esté lista si te sobra maná: daño gratis bajo el jefe.
accion exorcismo si beneficio.artedelaguerra.activo -- El arte de la guerra hace instantáneo el Exorcismo: gástalo antes de que salte el siguiente.
accion colerasagrada si mana > 40 -- Cólera sagrada de último relleno cuando todo lo demás está en reutilización.
]],
})

-- Proteccion PvE (tanque): la rotacion 969 sale sola de las reutilizaciones (6 s y 9 s alternadas).
table.insert(ns.builtin, {
en = [[
id: tc-paladin-protection
rotation: Protection
class: PALADIN
spec: Protection
tree: 2
mode: pve
author: Tactics Coach
version: 1
description: The 969 rotation: alternate a 6-second ability (Hammer of the Righteous, Shield of Righteousness) with a 9-second one (Holy Shield, Consecration, Judgement) so you never have an empty global cooldown.

spell fury = 25780              # Righteous Fury
spell vengeance = 31801         # Seal of Vengeance (Alliance)
spell corruption = 53736        # Seal of Corruption (Horde)
spell avenger = 48827           # Avenger's Shield
spell plea = 54428              # Divine Plea
spell hammer = 53595            # Hammer of the Righteous
spell shield = 61411            # Shield of Righteousness
spell holyshield = 48952        # Holy Shield
spell consecration = 48819
spell judgement = 53408         # Judgement of Wisdom
spell wrath = 48806             # Hammer of Wrath
spell holywrath = 48817         # Holy Wrath

action fury if buff.fury.down -- Righteous Fury always on: without it your Holy damage makes no extra threat.
action vengeance if buff.vengeance.down and buff.corruption.down -- Seal of Vengeance always on: steady single-target threat.
action corruption if buff.vengeance.down and buff.corruption.down -- Seal of Corruption always on: steady single-target threat.
action avenger if not combat -- Pull with Avenger's Shield: it bounces to 3 enemies and silences casters.
action plea if mana < 60 -- Divine Plea when mana dips: as a tank the healing penalty does not matter.
action hammer -- Hammer of the Righteous (6 s): hits 3 enemies, your AoE threat.
action shield -- Shield of Righteousness (6 s): heavy hit that scales with your block value.
action holyshield if buff.holyshield.remains < 2 -- Holy Shield (9 s): more block chance and damage on every block; never let it drop.
action consecration -- Consecration (9 s): threat on everything standing in it.
action judgement -- Judgement (9 s): threat and mana back.
action wrath -- Hammer of Wrath only below 20% health: fills a free gap.
action avenger -- Avenger's Shield if a global is still empty.
action holywrath -- Holy Wrath as the last filler (it also stuns undead and demons).
]],
es = [[
id: tc-paladin-protection
rotacion: Protección
clase: PALADIN
especializacion: Protección
arbol: 2
modo: pve
autor: Tactics Coach
version: 1
descripcion: La rotación 969: alterna una habilidad de 6 segundos (Martillo de los justos, Escudo de rectitud) con una de 9 (Escudo sagrado, Consagración, Sentencia) para no dejar ningún tiempo global vacío.

hechizo furia = 25780           # Furia recta
hechizo venganza = 31801        # Sello de venganza (Alianza)
hechizo corrupcion = 53736      # Sello de corrupción (Horda)
hechizo vengador = 48827        # Escudo de vengador
hechizo suplica = 54428         # Súplica divina
hechizo justos = 53595          # Martillo de los justos
hechizo rectitud = 61411        # Escudo de rectitud
hechizo escudosagrado = 48952   # Escudo sagrado (Holy Shield)
hechizo consagracion = 48819
hechizo sentencia = 53408       # Sentencia de sabiduría
hechizo martillo = 48806        # Martillo de cólera
hechizo colerasagrada = 48817   # Cólera sagrada

accion furia si beneficio.furia.inactivo -- Furia recta siempre activa: sin ella tu daño Sagrado no genera amenaza extra.
accion venganza si beneficio.venganza.inactivo y beneficio.corrupcion.inactivo -- Sello de venganza siempre puesto: amenaza constante a un objetivo.
accion corrupcion si beneficio.venganza.inactivo y beneficio.corrupcion.inactivo -- Sello de corrupción siempre puesto: amenaza constante a un objetivo.
accion vengador si no combate -- Abre con Escudo de vengador: rebota a 3 enemigos y silencia a los lanzadores.
accion suplica si mana < 60 -- Súplica divina cuando baje el maná: como tanque la penalización a la sanación no importa.
accion justos -- Martillo de los justos (6 s): pega a 3 enemigos, tu amenaza en área.
accion rectitud -- Escudo de rectitud (6 s): golpe fuerte que escala con tu valor de bloqueo.
accion escudosagrado si beneficio.escudosagrado.restante < 2 -- Escudo sagrado (9 s): más bloqueo y daño en cada bloqueo; que nunca se caiga.
accion consagracion -- Consagración (9 s): amenaza a todo lo que esté encima.
accion sentencia -- Sentencia (9 s): amenaza y te devuelve maná.
accion martillo -- Martillo de cólera solo por debajo del 20%: rellena un hueco libre.
accion vengador -- Escudo de vengador si aún queda un tiempo global vacío.
accion colerasagrada -- Cólera sagrada de último relleno (además aturde a no-muertos y demonios).
]],
})

-- Sagrado PvE (ICC): sanador de tanques. Señal de la Luz en un tanque y curas en el otro.
table.insert(ns.builtin, {
en = [[
id: tc-paladin-holy
rotation: Holy
class: PALADIN
spec: Holy
tree: 1
mode: pve
author: Tactics Coach
version: 1
description: Tank healer. Beacon of Light on one tank, Sacred Shield on the tank you heal, Holy Light as your main heal and Holy Shock for emergencies and Infusion of Light. Target the ally you are healing.

spell wisdom = 20166            # Seal of Wisdom
spell judgement = 20271         # Judgement of Light
spell lay = 48788               # Lay on Hands
spell beacon = 53563            # Beacon of Light
spell sacred = 53601            # Sacred Shield
spell illumination = 31842      # Divine Illumination
spell plea = 54428              # Divine Plea
spell shock = 48825             # Holy Shock
spell light = 48782             # Holy Light
spell flash = 48785             # Flash of Light
aura infusion = 54149           # Infusion of Light (proc)
aura pure = 54153               # Judgements of the Pure (haste)
aura forbearance = 25771

action wisdom if buff.wisdom.down -- Seal of Wisdom always on: mana back on your Judgements.
action judgement if not target.friendly and buff.pure.remains < 10 -- With an enemy targeted: Judgement to keep Judgements of the Pure (+15% haste).
action lay if target.friendly and target.health < 15 and debuff.forbearance.down -- Lay on Hands: a full heal for an ally about to die.
action beacon if target.friendly and not combat and target_buff.beacon.down and target_buff.sacred.down -- Before the pull, Beacon of Light on the tank you will NOT target: it copies your heals onto them.
action beacon if target.friendly and target_buff.beacon.up and target_buff.beacon.remains < 10 -- Refresh Beacon of Light before it runs out.
action sacred if target.friendly and target_buff.beacon.down and target_buff.sacred.remains < 5 -- Sacred Shield on the tank you heal (not the Beacon one): it absorbs hits.
action illumination if combat and mana < 75 -- Divine Illumination: half mana cost for 15 seconds.
action plea if mana < 50 -- Divine Plea when mana dips: lots of mana back for a small healing penalty.
action shock if target.friendly and target.health < 60 -- Holy Shock: instant heal for emergencies; a crit gives Infusion of Light.
action light if target.friendly and target.health < 90 and buff.infusion.up -- Infusion of Light: a 1-second Holy Light.
action shock if target.friendly and moving and target.health < 90 -- While moving, Holy Shock is your only heal.
action flash if target.friendly and target.health >= 80 and target.health < 95 -- Light damage: Flash of Light, cheap and fast.
action light if target.friendly and target.health < 95 -- Holy Light is your main heal (and it copies onto the Beacon).
]],
es = [[
id: tc-paladin-holy
rotacion: Sagrado
clase: PALADIN
especializacion: Sagrado
arbol: 1
modo: pve
autor: Tactics Coach
version: 1
descripcion: Sanador de tanques. Señal de la Luz en un tanque, Escudo consagrado en el que curas, Luz sagrada como cura principal y Choque sagrado para emergencias e Infusión de luz. Selecciona al aliado que curas.

hechizo sabiduria = 20166       # Sello de sabiduría
hechizo sentencia = 20271       # Sentencia de luz
hechizo imposicion = 48788      # Imposición de manos
hechizo senal = 53563           # Señal de la Luz
hechizo consagrado = 53601      # Escudo consagrado (Sacred Shield)
hechizo iluminacion = 31842     # Iluminación divina
hechizo suplica = 54428         # Súplica divina
hechizo choque = 48825          # Choque sagrado
hechizo luz = 48782             # Luz sagrada
hechizo destello = 48785        # Destello de Luz
aura infusion = 54149           # Infusión de luz (proc)
aura puro = 54153               # Sentencias del puro (celeridad)
aura abstinencia = 25771

accion sabiduria si beneficio.sabiduria.inactivo -- Sello de sabiduría siempre puesto: maná de vuelta con tus Sentencias.
accion sentencia si no objetivo.amistoso y beneficio.puro.restante < 10 -- Con un enemigo seleccionado: Sentencia para mantener Sentencias del puro (+15% de celeridad).
accion imposicion si objetivo.amistoso y objetivo.vida < 15 y perjuicio.abstinencia.inactivo -- Imposición de manos: cura completa a un aliado a punto de morir.
accion senal si objetivo.amistoso y no combate y beneficio_objetivo.senal.inactivo y beneficio_objetivo.consagrado.inactivo -- Antes del combate, Señal de la Luz en el tanque que NO vas a seleccionar: le copia tus curas.
accion senal si objetivo.amistoso y beneficio_objetivo.senal.activo y beneficio_objetivo.senal.restante < 10 -- Renueva la Señal de la Luz antes de que se acabe.
accion consagrado si objetivo.amistoso y beneficio_objetivo.senal.inactivo y beneficio_objetivo.consagrado.restante < 5 -- Escudo consagrado en el tanque que curas (no el de la Señal): absorbe golpes.
accion iluminacion si combate y mana < 75 -- Iluminación divina: tus hechizos cuestan la mitad durante 15 segundos.
accion suplica si mana < 50 -- Súplica divina cuando baje el maná: mucho maná a cambio de curar un poco menos.
accion choque si objetivo.amistoso y objetivo.vida < 60 -- Choque sagrado: cura instantánea para emergencias; un crítico te da Infusión de luz.
accion luz si objetivo.amistoso y objetivo.vida < 90 y beneficio.infusion.activo -- Infusión de luz: una Luz sagrada de 1 segundo.
accion choque si objetivo.amistoso y moviendo y objetivo.vida < 90 -- En movimiento, Choque sagrado es tu única cura.
accion destello si objetivo.amistoso y objetivo.vida >= 80 y objetivo.vida < 95 -- Daño ligero: Destello de Luz, barato y rápido.
accion luz si objetivo.amistoso y objetivo.vida < 95 -- Luz sagrada es tu cura principal (y se copia en la Señal).
]],
})

-- Reprension PvP (temporada 8): estallido, aturdir lanzamientos y curarse con El arte de la guerra.
table.insert(ns.builtin, {
en = [[
id: tc-paladin-retribution-pvp
rotation: Retribution (PvP)
class: PALADIN
spec: Retribution
tree: 3
mode: pvp
author: Tactics Coach
version: 1
description: Burst with Avenging Wrath, stop casts with Hammer of Justice and spend The Art of War on an instant Flash of Light when you are low, or on Exorcism when you are not.

spell bubble = 642              # Divine Shield
spell hoj = 10308               # Hammer of Justice
spell repentance = 20066
spell flash = 48785             # Flash of Light
spell command = 20375           # Seal of Command
spell righteousness = 21084     # Seal of Righteousness
spell avenging = 31884          # Avenging Wrath
spell judgement = 53407         # Judgement of Justice
spell hammer = 48806            # Hammer of Wrath
spell crusader = 35395          # Crusader Strike
spell storm = 53385             # Divine Storm
spell exorcism = 48801
spell plea = 54428              # Divine Plea
aura artofwar = 59578           # The Art of War (proc)
aura forbearance = 25771

action bubble if health < 20 and self_debuff.forbearance.down -- Divine Shield below 20%: immune for 12 seconds.
action hoj if target.casting and not target.friendly -- Hammer of Justice stops the cast: a 6-second stun (you have no real interrupt).
action repentance if target.casting and not target.friendly and target.player and cooldown.hoj.remains > 2 -- Hammer is on cooldown: Repentance to stop the cast.
action flash if buff.artofwar.up and health < 50 -- The Art of War also makes Flash of Light instant: heal yourself without stopping.
action command if buff.command.down and buff.righteousness.down -- Seal of Command always on: burst damage in every swing.
action righteousness if buff.command.down and buff.righteousness.down -- Without Seal of Command, Seal of Righteousness.
action avenging if target.player and target.health < 70 -- Avenging Wrath when you go for the kill: +20% damage.
action judgement -- Judgement of Justice on cooldown: damage and the target cannot run faster than normal.
action hammer -- Hammer of Wrath below 20%: your finisher, it even hits at range.
action crusader -- Crusader Strike on cooldown.
action storm -- Divine Storm on cooldown: it also heals your teammates.
action exorcism if buff.artofwar.up -- Instant Exorcism with The Art of War.
action plea if mana < 40 -- Divine Plea when mana runs low (better between bursts).
]],
es = [[
id: tc-paladin-retribution-pvp
rotacion: Reprensión (PvP)
clase: PALADIN
especializacion: Reprensión
arbol: 3
modo: pvp
autor: Tactics Coach
version: 1
descripcion: Estallido con Cólera vengativa, corta lanzamientos con Martillo de justicia y gasta El arte de la guerra en un Destello de Luz instantáneo si vas bajo, o en Exorcismo si no.

hechizo burbuja = 642           # Escudo divino
hechizo martillojusticia = 10308 # Martillo de justicia
hechizo arrepentimiento = 20066
hechizo destello = 48785        # Destello de Luz
hechizo orden = 20375           # Sello de orden
hechizo rectitud = 21084        # Sello de rectitud
hechizo colera = 31884          # Cólera vengativa
hechizo sentencia = 53407       # Sentencia de justicia
hechizo martillo = 48806        # Martillo de cólera
hechizo cruzado = 35395         # Golpe de cruzado
hechizo tormenta = 53385        # Tormenta divina
hechizo exorcismo = 48801
hechizo suplica = 54428         # Súplica divina
aura artedelaguerra = 59578     # El arte de la guerra (proc)
aura abstinencia = 25771

accion burbuja si vida < 20 y perjuicio_propio.abstinencia.inactivo -- Escudo divino por debajo del 20%: inmune 12 segundos.
accion martillojusticia si objetivo.lanzando y no objetivo.amistoso -- Martillo de justicia corta el lanzamiento: aturde 6 segundos (no tienes interrupción de verdad).
accion arrepentimiento si objetivo.lanzando y no objetivo.amistoso y objetivo.jugador y reutilizacion.martillojusticia.restante > 2 -- El Martillo está en reutilización: Arrepentimiento para cortar el lanzamiento.
accion destello si beneficio.artedelaguerra.activo y vida < 50 -- El arte de la guerra también hace instantáneo el Destello de Luz: cúrate sin pararte.
accion orden si beneficio.orden.inactivo y beneficio.rectitud.inactivo -- Sello de orden siempre puesto: daño de estallido en cada golpe.
accion rectitud si beneficio.orden.inactivo y beneficio.rectitud.inactivo -- Sin Sello de orden, Sello de rectitud.
accion colera si objetivo.jugador y objetivo.vida < 70 -- Cólera vengativa cuando vas a por la muerte: +20% de daño.
accion sentencia -- Sentencia de justicia en cuanto esté lista: daño y el objetivo no puede correr más rápido de lo normal.
accion martillo -- Martillo de cólera por debajo del 20%: tu remate, y pega a distancia.
accion cruzado -- Golpe de cruzado en cuanto esté listo.
accion tormenta -- Tormenta divina en cuanto esté lista: además cura a tus compañeros.
accion exorcismo si beneficio.artedelaguerra.activo -- Exorcismo instantáneo con El arte de la guerra.
accion suplica si mana < 40 -- Súplica divina cuando te quedes sin maná (mejor entre estallidos).
]],
})

-- Sagrado PvP (temporada 8): Destello de Luz como cura principal, Choque sagrado y Escudo consagrado.
table.insert(ns.builtin, {
en = [[
id: tc-paladin-holy-pvp
rotation: Holy (PvP)
class: PALADIN
spec: Holy
tree: 1
mode: pvp
author: Tactics Coach
version: 1
description: Flash of Light is your main heal in arena, Holy Shock your instant one. Beacon on your partner before the gates, Sacred Shield on whoever is being trained, and Hammer of Justice to stop enemy casts.

spell bubble = 642              # Divine Shield
spell hoj = 10308               # Hammer of Justice
spell judgement = 20271         # Judgement of Light
spell lay = 48788               # Lay on Hands
spell beacon = 53563            # Beacon of Light
spell sacred = 53601            # Sacred Shield
spell favor = 20216             # Divine Favor
spell shock = 48825             # Holy Shock
spell light = 48782             # Holy Light
spell flash = 48785             # Flash of Light
spell plea = 54428              # Divine Plea
aura infusion = 54149           # Infusion of Light (proc)
aura pure = 54153               # Judgements of the Pure (haste)
aura forbearance = 25771

action bubble if health < 20 and self_debuff.forbearance.down -- Divine Shield below 20%: immune, and you keep healing.
action hoj if not target.friendly and target.casting -- Enemy targeted and casting: Hammer of Justice stuns it for 6 seconds.
action judgement if not target.friendly and buff.pure.remains < 5 -- With an enemy targeted: Judgement to keep Judgements of the Pure (+15% haste).
action lay if target.friendly and target.health < 15 and debuff.forbearance.down -- Lay on Hands: a full heal for an ally about to die.
action favor if target.friendly and target.health < 40 -- Divine Favor: the next Holy Shock is a guaranteed crit and gives Infusion of Light.
action shock if target.friendly and target.health < 85 -- Holy Shock on cooldown: an instant heal they cannot interrupt.
action beacon if target.friendly and not combat and target_buff.beacon.down and target_buff.sacred.down -- Before the gates: Beacon of Light on your partner, it copies the heals you cast on yourself.
action beacon if target.friendly and target_buff.beacon.up and target_buff.beacon.remains < 10 -- Refresh Beacon of Light before it runs out.
action sacred if target.friendly and target_buff.beacon.down and target_buff.sacred.remains < 3 -- Sacred Shield on the one being trained (not the Beacon one): it absorbs hits.
action light if target.friendly and target.health < 60 and buff.infusion.up -- Infusion of Light: a fast Holy Light for a big heal.
action flash if target.friendly and target.health < 95 -- Flash of Light: fast and hard to interrupt, your main heal in arena.
action plea if mana < 50 -- Divine Plea when there is no pressure: a lot of mana back.
]],
es = [[
id: tc-paladin-holy-pvp
rotacion: Sagrado (PvP)
clase: PALADIN
especializacion: Sagrado
arbol: 1
modo: pvp
autor: Tactics Coach
version: 1
descripcion: Destello de Luz es tu cura principal en arena y Choque sagrado la instantánea. Señal en tu compañero antes de las puertas, Escudo consagrado en quien reciba la presión y Martillo de justicia para cortar lanzamientos enemigos.

hechizo burbuja = 642           # Escudo divino
hechizo martillojusticia = 10308 # Martillo de justicia
hechizo sentencia = 20271       # Sentencia de luz
hechizo imposicion = 48788      # Imposición de manos
hechizo senal = 53563           # Señal de la Luz
hechizo consagrado = 53601      # Escudo consagrado (Sacred Shield)
hechizo favor = 20216           # Favor divino
hechizo choque = 48825          # Choque sagrado
hechizo luz = 48782             # Luz sagrada
hechizo destello = 48785        # Destello de Luz
hechizo suplica = 54428         # Súplica divina
aura infusion = 54149           # Infusión de luz (proc)
aura puro = 54153               # Sentencias del puro (celeridad)
aura abstinencia = 25771

accion burbuja si vida < 20 y perjuicio_propio.abstinencia.inactivo -- Escudo divino por debajo del 20%: inmune, y sigues curando.
accion martillojusticia si no objetivo.amistoso y objetivo.lanzando -- Enemigo seleccionado lanzando: Martillo de justicia lo aturde 6 segundos.
accion sentencia si no objetivo.amistoso y beneficio.puro.restante < 5 -- Con un enemigo seleccionado: Sentencia para mantener Sentencias del puro (+15% de celeridad).
accion imposicion si objetivo.amistoso y objetivo.vida < 15 y perjuicio.abstinencia.inactivo -- Imposición de manos: cura completa a un aliado a punto de morir.
accion favor si objetivo.amistoso y objetivo.vida < 40 -- Favor divino: el siguiente Choque sagrado es crítico seguro y te da Infusión de luz.
accion choque si objetivo.amistoso y objetivo.vida < 85 -- Choque sagrado en cuanto esté listo: cura instantánea que no te pueden interrumpir.
accion senal si objetivo.amistoso y no combate y beneficio_objetivo.senal.inactivo y beneficio_objetivo.consagrado.inactivo -- Antes de las puertas: Señal de la Luz en tu compañero, le copia las curas que te lanzas a ti.
accion senal si objetivo.amistoso y beneficio_objetivo.senal.activo y beneficio_objetivo.senal.restante < 10 -- Renueva la Señal de la Luz antes de que se acabe.
accion consagrado si objetivo.amistoso y beneficio_objetivo.senal.inactivo y beneficio_objetivo.consagrado.restante < 3 -- Escudo consagrado en quien reciba la presión (no el de la Señal): absorbe golpes.
accion luz si objetivo.amistoso y objetivo.vida < 60 y beneficio.infusion.activo -- Infusión de luz: una Luz sagrada rápida para una cura grande.
accion destello si objetivo.amistoso y objetivo.vida < 95 -- Destello de Luz: rápido y difícil de cortar, tu cura principal en arena.
accion suplica si mana < 50 -- Súplica divina cuando no haya presión: mucho maná de vuelta.
]],
})

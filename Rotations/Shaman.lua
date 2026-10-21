local _, ns = ...
ns = ns or TacticsCoachNS
ns.builtin = ns.builtin or {}

-- IDs verificados contra el Spell.dbc 3.3.5a del servidor (rango maximo de cada uno).
-- Los totems normales (Abrasador, Colera, Magma, Fuerza de la tierra...) no se sugieren: el motor no
-- puede saber si ya estan puestos. Solo los que tienen reutilizacion propia (Elemental de fuego,
-- Marea de mana, Derribo), que se leen por su cooldown.

-- ===================================================================== PvE
table.insert(ns.builtin, {
en = [[
id: tc-shaman-elemental
rotation: Elemental
class: SHAMAN
spec: Elemental
tree: 1
mode: pve
author: Tactics Coach
version: 1
description: Keep Flame Shock ticking so every Lava Burst crits, Chain Lightning on cooldown and Lightning Bolt as filler. Water Shield and Thunderstorm keep your mana up.

spell wshield = 57960           # Water Shield
spell mastery = 16166           # Elemental Mastery
spell fireele = 2894            # Fire Elemental Totem
spell flameshock = 49233        # Flame Shock
spell lavaburst = 60043         # Lava Burst
spell chain = 49271             # Chain Lightning
spell thunder = 59159           # Thunderstorm
spell bolt = 49238              # Lightning Bolt

action wshield if buff.wshield.down -- Water Shield always on: it gives you mana back when you are hit and with your crits.
action mastery -- Elemental Mastery whenever it is ready: +15% haste and your next spell is instant.
action fireele if combat -- Fire Elemental Totem with Bloodlust: a big chunk of damage for 2 min (put your fire totem back after).
action flameshock if debuff.flameshock.down -- Flame Shock on the target: without it Lava Burst does not crit for sure.
action lavaburst if debuff.flameshock.remains > cast.lavaburst -- Lava Burst while Flame Shock is up: it is a guaranteed crit.
action chain -- Chain Lightning on cooldown: with Lightning Overload it beats Lightning Bolt even on one target.
action thunder if mana < 80 -- Thunderstorm on cooldown when you are missing mana: 8% back each time.
action bolt -- Lightning Bolt as filler.
]],
es = [[
id: tc-shaman-elemental
rotacion: Elemental
clase: SHAMAN
especializacion: Elemental
arbol: 1
modo: pve
autor: Tactics Coach
version: 1
descripcion: Mantén Choque de llamas para que cada Ráfaga de lava sea crítico, Cadena de relámpagos en cuanto esté lista y Descarga de relámpagos de relleno. Escudo de agua y Tormenta de truenos sostienen tu maná.

hechizo escudoagua = 57960      # Water Shield
hechizo maestria = 16166        # Elemental Mastery
hechizo elefuego = 2894         # Fire Elemental Totem
hechizo llamas = 49233          # Flame Shock
hechizo rafaga = 60043          # Lava Burst
hechizo cadena = 49271          # Chain Lightning
hechizo tormenta = 59159        # Thunderstorm
hechizo descarga = 49238        # Lightning Bolt

accion escudoagua si beneficio.escudoagua.inactivo -- Escudo de agua siempre puesto: te devuelve maná al recibir golpes y con tus críticos.
accion maestria -- Maestría elemental en cuanto esté lista: +15% de celeridad y tu siguiente hechizo es instantáneo.
accion elefuego si combate -- Tótem elemental de fuego junto con Ansia de sangre: mucho daño durante 2 min (vuelve a poner tu tótem de fuego después).
accion llamas si perjuicio.llamas.inactivo -- Choque de llamas en el objetivo: sin él Ráfaga de lava no es crítico asegurado.
accion rafaga si perjuicio.llamas.restante > lanzamiento.rafaga -- Ráfaga de lava mientras dure Choque de llamas: es un crítico asegurado.
accion cadena -- Cadena de relámpagos en cuanto esté lista: con Sobrecarga de relámpagos supera a la Descarga incluso contra un solo objetivo.
accion tormenta si mana < 80 -- Tormenta de truenos cuando te falte maná: te devuelve un 8% cada vez.
accion descarga -- Descarga de relámpagos de relleno.
]],
})

table.insert(ns.builtin, {
en = [[
id: tc-shaman-enhancement
rotation: Enhancement
class: SHAMAN
spec: Enhancement
tree: 2
mode: pve
author: Tactics Coach
version: 1
description: A priority, not a sequence: spend 5 Maelstrom Weapon stacks on an instant Lightning Bolt, then Stormstrike, shocks, Fire Nova and Lava Lash. Feral Spirit and Shamanistic Rage on cooldown.

spell lshield = 49281           # Lightning Shield
spell wolves = 51533            # Feral Spirit
spell fireele = 2894            # Fire Elemental Totem
spell bolt = 49238              # Lightning Bolt
spell stormstrike = 17364
spell flameshock = 49233        # Flame Shock
spell earthshock = 49231        # Earth Shock
spell rage = 30823              # Shamanistic Rage
spell nova = 61657              # Fire Nova
spell lavalash = 60103          # Lava Lash
aura maelstrom = 53817          # Maelstrom Weapon (the stacking buff)

action lshield if buff.lshield.down -- Lightning Shield always on: Static Shock turns its charges into damage.
action wolves -- Feral Spirit whenever it is ready: two wolves that hit hard and heal you.
action fireele if combat -- Fire Elemental Totem with Bloodlust: lots of damage for 2 min (put your fire totem back after).
action bolt if buff.maelstrom.stack >= 5 -- 5 Maelstrom Weapon stacks: instant Lightning Bolt, spend them right away.
action stormstrike -- Stormstrike on cooldown: your strongest hit and +20% to your next nature damage.
action flameshock if debuff.flameshock.down -- Flame Shock if it is not ticking on the target.
action earthshock if debuff.flameshock.remains > 6 -- Earth Shock with Flame Shock already up: the shocks share cooldown.
action rage if mana < 70 -- Shamanistic Rage when you are missing mana: your hits give it back for 15 s.
action nova if mana > 30 -- Fire Nova while your fire totem is placed (Magma or Searing): good damage while you have mana.
action lavalash -- Lava Lash as filler (needs a one-hand weapon in your off hand).
]],
es = [[
id: tc-shaman-enhancement
rotacion: Mejora
clase: SHAMAN
especializacion: Mejora
arbol: 2
modo: pve
autor: Tactics Coach
version: 1
descripcion: Una prioridad, no una secuencia: gasta 5 cargas de Arma vorágine en una Descarga de relámpagos instantánea, luego Golpe de tormenta, choques, Nova de Fuego y Latigazo de lava. Espíritu feral e Ira chamanística en cuanto estén listos.

hechizo escudorayo = 49281      # Lightning Shield
hechizo lobos = 51533           # Feral Spirit
hechizo elefuego = 2894         # Fire Elemental Totem
hechizo descarga = 49238        # Lightning Bolt
hechizo golpetormenta = 17364   # Stormstrike
hechizo llamas = 49233          # Flame Shock
hechizo tierra = 49231          # Earth Shock
hechizo ira = 30823             # Shamanistic Rage
hechizo nova = 61657            # Fire Nova
hechizo latigazo = 60103        # Lava Lash
aura voragine = 53817           # Maelstrom Weapon

accion escudorayo si beneficio.escudorayo.inactivo -- Escudo de relámpagos siempre puesto: Choque estático convierte sus cargas en daño.
accion lobos -- Espíritu feral en cuanto esté listo: dos lobos que pegan fuerte y te curan.
accion elefuego si combate -- Tótem elemental de fuego junto con Ansia de sangre: mucho daño durante 2 min (vuelve a poner tu tótem de fuego después).
accion descarga si beneficio.voragine.cargas >= 5 -- 5 cargas de Arma vorágine: Descarga de relámpagos instantánea, gástalas ya.
accion golpetormenta -- Golpe de tormenta en cuanto esté listo: tu golpe más fuerte y +20% a tu siguiente daño de naturaleza.
accion llamas si perjuicio.llamas.inactivo -- Choque de llamas si no está haciendo daño en el objetivo.
accion tierra si perjuicio.llamas.restante > 6 -- Choque de tierra con Choque de llamas ya puesto: los choques comparten reutilización.
accion ira si mana < 70 -- Ira chamanística cuando te falte maná: tus golpes te lo devuelven durante 15 s.
accion nova si mana > 30 -- Nova de Fuego con tu tótem de fuego puesto (Magma o Abrasador): buen daño mientras tengas maná.
accion latigazo -- Latigazo de lava de relleno (necesita un arma de una mano en la mano izquierda).
]],
})

table.insert(ns.builtin, {
en = [[
id: tc-shaman-restoration
rotation: Restoration
class: SHAMAN
spec: Restoration
tree: 3
mode: pve
author: Tactics Coach
version: 1
description: Select the ally you want to heal. Earth Shield on the tank, Riptide on cooldown for Tidal Waves, Chain Heal for raid damage and Healing Wave for big hits.

spell wshield = 57960           # Water Shield
spell manatide = 16190          # Mana Tide Totem
spell eshield = 49284           # Earth Shield
spell swift = 16188             # Nature's Swiftness
spell hwave = 49273             # Healing Wave
spell riptide = 61301
spell lhw = 49276               # Lesser Healing Wave
spell chainheal = 55459         # Chain Heal
aura tidal = 53390              # Tidal Waves (the proc)

action wshield if buff.wshield.down -- Water Shield always on: it is most of your mana regeneration.
action manatide if mana < 60 -- Mana Tide Totem below 60% mana: it restores mana to your whole group.
action eshield if target.friendly and target_buff.eshield.down -- Earth Shield on the tank: it heals them every time they are hit (only one target at a time).
action swift if target.friendly and target.health < 30 -- Emergency: Nature's Swiftness makes your next heal instant.
action hwave if target.friendly and buff.swift.up -- With Nature's Swiftness up, an instant Healing Wave saves them.
action riptide if target.friendly and target.health < 95 and target_buff.riptide.down -- Riptide on cooldown: instant heal, HoT and it triggers Tidal Waves.
action hwave if target.friendly and target.health < 50 and buff.tidal.up -- Big damage on one target: Healing Wave, faster with Tidal Waves.
action lhw if target.friendly and target.health < 60 -- Lesser Healing Wave when they need it fast.
action chainheal if target.friendly and target.health < 95 -- Chain Heal is your main raid heal: it jumps to wounded allies and Riptide boosts it.
]],
es = [[
id: tc-shaman-restoration
rotacion: Restauración
clase: SHAMAN
especializacion: Restauración
arbol: 3
modo: pve
autor: Tactics Coach
version: 1
descripcion: Selecciona al aliado que quieres curar. Escudo de tierra en el tanque, Mareas vivas en cuanto esté listo por Ondas de marea, Sanación en cadena para el daño de banda y Ola de sanación para los golpes grandes.

hechizo escudoagua = 57960      # Water Shield
hechizo mareamana = 16190       # Mana Tide Totem
hechizo escudotierra = 49284    # Earth Shield
hechizo presteza = 16188        # Nature's Swiftness
hechizo ola = 49273             # Healing Wave
hechizo mareas = 61301          # Riptide
hechizo olainferior = 49276     # Lesser Healing Wave
hechizo cadena = 55459          # Chain Heal
aura ondas = 53390              # Tidal Waves

accion escudoagua si beneficio.escudoagua.inactivo -- Escudo de agua siempre puesto: es la mayor parte de tu regeneración de maná.
accion mareamana si mana < 60 -- Tótem Marea de maná por debajo del 60% de maná: devuelve maná a todo tu grupo.
accion escudotierra si objetivo.amistoso y beneficio_objetivo.escudotierra.inactivo -- Escudo de tierra en el tanque: lo cura cada vez que lo golpean (solo uno a la vez).
accion presteza si objetivo.amistoso y objetivo.vida < 30 -- Emergencia: Presteza de la naturaleza hace instantánea tu siguiente sanación.
accion ola si objetivo.amistoso y beneficio.presteza.activo -- Con Presteza de la naturaleza activa, una Ola de sanación instantánea lo salva.
accion mareas si objetivo.amistoso y objetivo.vida < 95 y beneficio_objetivo.mareas.inactivo -- Mareas vivas en cuanto esté lista: sanación instantánea, cura periódica y activa Ondas de marea.
accion ola si objetivo.amistoso y objetivo.vida < 50 y beneficio.ondas.activo -- Mucho daño en un objetivo: Ola de sanación, más rápida con Ondas de marea.
accion olainferior si objetivo.amistoso y objetivo.vida < 60 -- Ola de sanación inferior cuando lo necesita rápido.
accion cadena si objetivo.amistoso y objetivo.vida < 95 -- Sanación en cadena es tu cura principal de banda: salta a los aliados heridos y Mareas vivas la potencia.
]],
})

-- ===================================================================== PvP
table.insert(ns.builtin, {
en = [[
id: tc-shaman-restoration-pvp
rotation: Restoration (PvP)
class: SHAMAN
spec: Restoration
tree: 3
mode: pvp
author: Tactics Coach
version: 1
description: Arena healer. On an enemy: Wind Shear their casts, Grounding Totem if it is on cooldown, Frost Shock melee. On an ally: Earth Shield, Riptide and fast heals, with Nature's Swiftness for emergencies.

spell shear = 57994             # Wind Shear
spell grounding = 8177          # Grounding Totem
spell wshield = 57960           # Water Shield
spell frostshock = 49236        # Frost Shock
spell eshield = 49284           # Earth Shield
spell swift = 16188             # Nature's Swiftness
spell hwave = 49273             # Healing Wave
spell riptide = 61301
spell lhw = 49276               # Lesser Healing Wave
spell chainheal = 55459         # Chain Heal
aura tidal = 53390              # Tidal Waves (the proc)

action shear if target.casting and not target.friendly -- Wind Shear their cast: it locks that school for 2 s and costs you no GCD time.
action grounding if target.casting and not target.friendly and cooldown.shear.remains > 1 -- Wind Shear is on cooldown: Grounding Totem eats the next harmful spell.
action wshield if buff.wshield.down -- Water Shield always on: your mana has to last the whole arena.
action swift if target.friendly and target.health < 35 -- Emergency: Nature's Swiftness makes your next heal instant.
action hwave if target.friendly and buff.swift.up -- With Nature's Swiftness up, an instant Healing Wave they cannot interrupt.
action eshield if target.friendly and target_buff.eshield.down -- Earth Shield on the ally being trained (or yourself): heals and resists pushback.
action riptide if target.friendly and target.health < 95 and target_buff.riptide.down -- Riptide on cooldown: instant heal, HoT and Tidal Waves.
action hwave if target.friendly and target.health < 50 and buff.tidal.up -- Big damage: Healing Wave, faster with Tidal Waves.
action lhw if target.friendly and target.health < 80 -- Lesser Healing Wave: short cast, hard to interrupt.
action chainheal if target.friendly and target.health < 90 -- Chain Heal tops up the whole team at once.
action frostshock if target.player and not target.friendly and debuff.frostshock.down -- On an enemy melee: Frost Shock slows them off your partner.
]],
es = [[
id: tc-shaman-restoration-pvp
rotacion: Restauración (PvP)
clase: SHAMAN
especializacion: Restauración
arbol: 3
modo: pvp
autor: Tactics Coach
version: 1
descripcion: Sanador de arenas. Sobre un enemigo: Cortavientos a sus lanzamientos, Tótem de derribo si está en reutilización, Choque de escarcha al cuerpo a cuerpo. Sobre un aliado: Escudo de tierra, Mareas vivas y curas rápidas, con Presteza de la naturaleza para emergencias.

hechizo cortavientos = 57994    # Wind Shear
hechizo derribo = 8177          # Grounding Totem
hechizo escudoagua = 57960      # Water Shield
hechizo escarcha = 49236        # Frost Shock
hechizo escudotierra = 49284    # Earth Shield
hechizo presteza = 16188        # Nature's Swiftness
hechizo ola = 49273             # Healing Wave
hechizo mareas = 61301          # Riptide
hechizo olainferior = 49276     # Lesser Healing Wave
hechizo cadena = 55459          # Chain Heal
aura ondas = 53390              # Tidal Waves

accion cortavientos si objetivo.lanzando y no objetivo.amistoso -- Cortavientos a su lanzamiento: bloquea esa escuela 2 s y casi no te cuesta tiempo.
accion derribo si objetivo.lanzando y no objetivo.amistoso y reutilizacion.cortavientos.restante > 1 -- Cortavientos en reutilización: el Tótem de derribo se traga el siguiente hechizo dañino.
accion escudoagua si beneficio.escudoagua.inactivo -- Escudo de agua siempre puesto: tu maná tiene que durar toda la arena.
accion presteza si objetivo.amistoso y objetivo.vida < 35 -- Emergencia: Presteza de la naturaleza hace instantánea tu siguiente sanación.
accion ola si objetivo.amistoso y beneficio.presteza.activo -- Con Presteza activa, una Ola de sanación instantánea que no pueden interrumpir.
accion escudotierra si objetivo.amistoso y beneficio_objetivo.escudotierra.inactivo -- Escudo de tierra en el aliado al que atacan (o en ti): cura y evita retrasos al lanzar.
accion mareas si objetivo.amistoso y objetivo.vida < 95 y beneficio_objetivo.mareas.inactivo -- Mareas vivas en cuanto esté lista: sanación instantánea, cura periódica y Ondas de marea.
accion ola si objetivo.amistoso y objetivo.vida < 50 y beneficio.ondas.activo -- Mucho daño: Ola de sanación, más rápida con Ondas de marea.
accion olainferior si objetivo.amistoso y objetivo.vida < 80 -- Ola de sanación inferior: lanzamiento corto, difícil de interrumpir.
accion cadena si objetivo.amistoso y objetivo.vida < 90 -- Sanación en cadena sube a todo el equipo a la vez.
accion escarcha si objetivo.jugador y no objetivo.amistoso y perjuicio.escarcha.inactivo -- Sobre un cuerpo a cuerpo enemigo: Choque de escarcha lo frena para que suelte a tu compañero.
]],
})

table.insert(ns.builtin, {
en = [[
id: tc-shaman-enhancement-pvp
rotation: Enhancement (PvP)
class: SHAMAN
spec: Enhancement
tree: 2
mode: pvp
author: Tactics Coach
version: 1
description: Burst with Stormstrike and Earth Shock, keep Frost Shock on your target, interrupt with Wind Shear and spend Maelstrom Weapon on a self-heal when you are low.

spell shear = 57994             # Wind Shear
spell rage = 30823              # Shamanistic Rage
spell lshield = 49281           # Lightning Shield
spell wolves = 51533            # Feral Spirit
spell hwave = 49273             # Healing Wave
spell bolt = 49238              # Lightning Bolt
spell stormstrike = 17364
spell frostshock = 49236        # Frost Shock
spell earthshock = 49231        # Earth Shock
spell lavalash = 60103          # Lava Lash
aura maelstrom = 53817          # Maelstrom Weapon (the stacking buff)

action shear if target.casting -- Wind Shear their cast: heals and CC get locked out for 2 s.
action rage if health < 50 -- Shamanistic Rage when you are under pressure: 30% less damage taken.
action lshield if buff.lshield.down -- Lightning Shield always on: extra damage when they hit you.
action wolves if target.player -- Feral Spirit to start your burst: the wolves hit, slow and heal you.
action hwave if buff.maelstrom.stack >= 5 and health < 40 -- Low health with 5 Maelstrom stacks: instant Healing Wave on yourself.
action bolt if buff.maelstrom.stack >= 5 -- 5 Maelstrom stacks: instant Lightning Bolt for burst.
action stormstrike -- Stormstrike on cooldown: big hit and your shocks hit harder.
action frostshock if target.player and debuff.frostshock.down -- Keep Frost Shock on the player you are chasing: they cannot kite you.
action earthshock -- Earth Shock for damage (it shares cooldown with Frost Shock).
action lavalash -- Lava Lash as filler.
]],
es = [[
id: tc-shaman-enhancement-pvp
rotacion: Mejora (PvP)
clase: SHAMAN
especializacion: Mejora
arbol: 2
modo: pvp
autor: Tactics Coach
version: 1
descripcion: Ráfaga de daño con Golpe de tormenta y Choque de tierra, mantén Choque de escarcha en tu objetivo, interrumpe con Cortavientos y usa Arma vorágine para curarte cuando estés bajo.

hechizo cortavientos = 57994    # Wind Shear
hechizo ira = 30823             # Shamanistic Rage
hechizo escudorayo = 49281      # Lightning Shield
hechizo lobos = 51533           # Feral Spirit
hechizo ola = 49273             # Healing Wave
hechizo descarga = 49238        # Lightning Bolt
hechizo golpetormenta = 17364   # Stormstrike
hechizo escarcha = 49236        # Frost Shock
hechizo tierra = 49231          # Earth Shock
hechizo latigazo = 60103        # Lava Lash
aura voragine = 53817           # Maelstrom Weapon

accion cortavientos si objetivo.lanzando -- Cortavientos a su lanzamiento: sanaciones y control bloqueados 2 s.
accion ira si vida < 50 -- Ira chamanística cuando te aprietan: recibes un 30% menos de daño.
accion escudorayo si beneficio.escudorayo.inactivo -- Escudo de relámpagos siempre puesto: daño extra cuando te golpean.
accion lobos si objetivo.jugador -- Espíritu feral para empezar tu ráfaga: los lobos pegan, ralentizan y te curan.
accion ola si beneficio.voragine.cargas >= 5 y vida < 40 -- Poca vida con 5 cargas de Arma vorágine: Ola de sanación instantánea sobre ti.
accion descarga si beneficio.voragine.cargas >= 5 -- 5 cargas de Arma vorágine: Descarga de relámpagos instantánea para la ráfaga.
accion golpetormenta -- Golpe de tormenta en cuanto esté listo: golpe fuerte y tus choques pegan más.
accion escarcha si objetivo.jugador y perjuicio.escarcha.inactivo -- Mantén Choque de escarcha en el jugador que persigues: así no se te escapa.
accion tierra -- Choque de tierra para hacer daño (comparte reutilización con Choque de escarcha).
accion latigazo -- Latigazo de lava de relleno.
]],
})

table.insert(ns.builtin, {
en = [[
id: tc-shaman-elemental-pvp
rotation: Elemental (PvP)
class: SHAMAN
spec: Elemental
tree: 1
mode: pvp
author: Tactics Coach
version: 1
description: Flame Shock into a guaranteed-crit Lava Burst is your burst, Elemental Mastery makes it instant. Interrupt with Wind Shear, push melee away with Thunderstorm and Frost Shock them on the move.

spell shear = 57994             # Wind Shear
spell thunder = 59159           # Thunderstorm
spell wshield = 57960           # Water Shield
spell mastery = 16166           # Elemental Mastery
spell flameshock = 49233        # Flame Shock
spell lavaburst = 60043         # Lava Burst
spell frostshock = 49236        # Frost Shock
spell chain = 49271             # Chain Lightning
spell bolt = 49238              # Lightning Bolt

action shear if target.casting -- Wind Shear their cast: heals and CC get locked out for 2 s.
action thunder if health < 60 and target.player -- A melee on you: Thunderstorm knocks them back and dazes them.
action wshield if buff.wshield.down -- Water Shield always on: mana every time they hit you.
action mastery if target.player -- Elemental Mastery to start your burst: your next Lava Burst is instant.
action flameshock if debuff.flameshock.down -- Flame Shock first: it makes your Lava Burst a guaranteed crit.
action lavaburst if debuff.flameshock.remains > cast.lavaburst -- Lava Burst with Flame Shock up: guaranteed crit, your hardest hit.
action frostshock if moving and debuff.frostshock.down -- On the move: Frost Shock slows them while you get distance.
action chain -- Chain Lightning on cooldown: fast damage and can hit pets.
action bolt -- Lightning Bolt as filler.
]],
es = [[
id: tc-shaman-elemental-pvp
rotacion: Elemental (PvP)
clase: SHAMAN
especializacion: Elemental
arbol: 1
modo: pvp
autor: Tactics Coach
version: 1
descripcion: Choque de llamas y luego Ráfaga de lava con crítico asegurado es tu ráfaga, y Maestría elemental la hace instantánea. Interrumpe con Cortavientos, aparta al cuerpo a cuerpo con Tormenta de truenos y ralentízalo con Choque de escarcha en movimiento.

hechizo cortavientos = 57994    # Wind Shear
hechizo tormenta = 59159        # Thunderstorm
hechizo escudoagua = 57960      # Water Shield
hechizo maestria = 16166        # Elemental Mastery
hechizo llamas = 49233          # Flame Shock
hechizo rafaga = 60043          # Lava Burst
hechizo escarcha = 49236        # Frost Shock
hechizo cadena = 49271          # Chain Lightning
hechizo descarga = 49238        # Lightning Bolt

accion cortavientos si objetivo.lanzando -- Cortavientos a su lanzamiento: sanaciones y control bloqueados 2 s.
accion tormenta si vida < 60 y objetivo.jugador -- Un cuerpo a cuerpo encima: Tormenta de truenos lo empuja y lo aturde.
accion escudoagua si beneficio.escudoagua.inactivo -- Escudo de agua siempre puesto: maná cada vez que te golpean.
accion maestria si objetivo.jugador -- Maestría elemental para empezar tu ráfaga: tu siguiente Ráfaga de lava es instantánea.
accion llamas si perjuicio.llamas.inactivo -- Primero Choque de llamas: hace que tu Ráfaga de lava sea crítico asegurado.
accion rafaga si perjuicio.llamas.restante > lanzamiento.rafaga -- Ráfaga de lava con Choque de llamas puesto: crítico asegurado, tu golpe más fuerte.
accion escarcha si moviendo y perjuicio.escarcha.inactivo -- En movimiento: Choque de escarcha lo ralentiza mientras ganas distancia.
accion cadena -- Cadena de relámpagos en cuanto esté lista: daño rápido y alcanza a las mascotas.
accion descarga -- Descarga de relámpagos de relleno.
]],
})

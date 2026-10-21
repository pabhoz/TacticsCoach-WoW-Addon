local _, ns = ...
ns = ns or TacticsCoachNS
ns.builtin = ns.builtin or {}

-- IDs verificados contra el Spell.dbc 3.3.5a del servidor (rango maximo de cada uno).
-- La misma rotacion en los dos idiomas: el id fijo hace que cambiar de idioma no la vuelva otra.
table.insert(ns.builtin, {
en = [[
id: tc-affliction
rotation: Affliction
class: WARLOCK
spec: Affliction
tree: 1
author: Tactics Coach
version: 1
description: Keep your DoTs up, Haunt whenever it is ready and Shadow Bolt as filler. Drain Soul below 25%.

spell armor = 47893             # Fel Armor
spell haunt = 59164
spell unstable = 47843          # Unstable Affliction
spell corruption = 47813
spell agony = 47864             # Curse of Agony
spell drain = 47855             # Drain Soul
spell tap = 57946               # Life Tap
spell bolt = 47809              # Shadow Bolt

action armor if buff.armor.down -- Fel Armor always on: more spell power.
action haunt -- Haunt whenever it is ready: damage and +20% to your DoTs.
action unstable if debuff.unstable.remains < cast.unstable -- Refresh Unstable Affliction right before it expires.
action corruption if debuff.corruption.down -- Corruption once: Everlasting Affliction refreshes it with your Shadow Bolts.
action agony if debuff.agony.down -- Curse of Agony if it has no other curse of yours.
action drain if target.health < 25 -- Below 25% health, Drain Soul deals four times the damage.
action tap if mana < 20 -- Life Tap when you run out of mana.
action bolt -- Shadow Bolt as filler.
]],
es = [[
id: tc-affliction
rotacion: Aflicción
clase: WARLOCK
especializacion: Aflicción
arbol: 1
autor: Tactics Coach
version: 1
descripcion: Mantén tus efectos periódicos, Poseer cada vez que esté listo y Descarga de las Sombras de relleno. Drenar alma por debajo del 25%.

hechizo armadura = 47893        # Fel Armor
hechizo poseer = 59164          # Haunt
hechizo inestable = 47843       # Unstable Affliction
hechizo corrupcion = 47813      # Corruption
hechizo agonia = 47864          # Curse of Agony
hechizo drenar = 47855          # Drain Soul
hechizo transfusion = 57946     # Life Tap
hechizo descarga = 47809        # Shadow Bolt

accion armadura si beneficio.armadura.inactivo -- Armadura vil siempre puesta: más poder con hechizos.
accion poseer -- Poseer (Haunt) en cuanto esté listo: daño y +20% a tus efectos periódicos.
accion inestable si perjuicio.inestable.restante < lanzamiento.inestable -- Renueva Aflicción inestable justo antes de que se acabe.
accion corrupcion si perjuicio.corrupcion.inactivo -- Corrupción una vez: Aflicción eterna la renueva con tus Descargas.
accion agonia si perjuicio.agonia.inactivo -- Maldición de agonía si no tiene otra maldición tuya.
accion drenar si objetivo.vida < 25 -- Por debajo del 25% de vida, Drenar alma hace cuatro veces más daño.
accion transfusion si mana < 20 -- Transfusión de vida cuando te quedes sin maná.
accion descarga -- Descarga de las Sombras de relleno.
]],
})

table.insert(ns.builtin, {
en = [[
id: tc-destruction
rotation: Destruction
class: WARLOCK
spec: Destruction
tree: 3
author: Tactics Coach
version: 1
description: Immolate always up, Conflagrate and Chaos Bolt whenever they are ready, and Incinerate as filler.

spell armor = 47893             # Fel Armor
spell doom = 47867              # Curse of Doom
spell immolate = 47811
spell conflagrate = 17962
spell chaos = 59172             # Chaos Bolt
spell tap = 57946               # Life Tap
spell incinerate = 47838

action armor if buff.armor.down -- Fel Armor always on: more spell power.
action doom if debuff.doom.down and target.health > 30 -- Curse of Doom on targets that will live longer than a minute.
action immolate if debuff.immolate.remains < cast.immolate -- Keep Immolate up: Conflagrate needs it and Incinerate hits harder.
action conflagrate if debuff.immolate.up -- Conflagrate whenever it is ready: it speeds up your next casts.
action chaos -- Chaos Bolt whenever it is ready.
action tap if mana < 15 -- Life Tap when you run out of mana.
action incinerate -- Incinerate as filler.
]],
es = [[
id: tc-destruction
rotacion: Destrucción
clase: WARLOCK
especializacion: Destrucción
arbol: 3
autor: Tactics Coach
version: 1
descripcion: Inmolar siempre activo, Conflagrar y Descarga de caos en cuanto estén listos, e Incinerar de relleno.

hechizo armadura = 47893        # Fel Armor
hechizo apocalipsis = 47867     # Curse of Doom
hechizo inmolar = 47811         # Immolate
hechizo conflagrar = 17962      # Conflagrate
hechizo caos = 59172            # Chaos Bolt
hechizo transfusion = 57946     # Life Tap
hechizo incinerar = 47838       # Incinerate

accion armadura si beneficio.armadura.inactivo -- Armadura vil siempre puesta: más poder con hechizos.
accion apocalipsis si perjuicio.apocalipsis.inactivo y objetivo.vida > 30 -- Maldición del apocalipsis en objetivos que vivirán más de un minuto.
accion inmolar si perjuicio.inmolar.restante < lanzamiento.inmolar -- Mantén Inmolar: Conflagrar lo necesita e Incinerar pega más fuerte.
accion conflagrar si perjuicio.inmolar.activo -- Conflagrar en cuanto esté listo: acelera tus siguientes lanzamientos.
accion caos -- Descarga de caos en cuanto esté lista.
accion transfusion si mana < 15 -- Transfusión de vida cuando te quedes sin maná.
accion incinerar -- Incinerar de relleno.
]],
})

table.insert(ns.builtin, {
en = [[
id: tc-warlock-demonology
rotation: Demonology
class: WARLOCK
spec: Demonology
tree: 2
mode: pve
author: Tactics Coach
version: 1
description: Metamorphosis and Immolation Aura on cooldown, Curse of Doom, Immolate and Corruption up, spend Decimation on Soul Fire and Molten Core on Incinerate, Shadow Bolt as filler.

spell armor = 47893             # Fel Armor
spell tap = 57946               # Life Tap (Glyph of Life Tap buff has the same name)
spell meta = 47241              # Metamorphosis
spell empower = 47193           # Demonic Empowerment
spell immolation = 50589        # Immolation Aura (only usable in Metamorphosis)
spell doom = 47867              # Curse of Doom
spell immolate = 47811
spell corruption = 47813
spell soulfire = 47825          # Soul Fire
spell incinerate = 47838
spell bolt = 47809              # Shadow Bolt
aura decimation = 63167         # Decimation (buff)
aura molten = 71165             # Molten Core (buff, 3 charges)

action armor if buff.armor.down -- Fel Armor always on: more spell power.
action tap if buff.tap.down and mana < 80 -- Life Tap to keep the Glyph of Life Tap buff: spell power from your Spirit.
action meta -- Metamorphosis on cooldown: +20% damage for 30 seconds.
action empower if pet -- Demonic Empowerment on cooldown: your Felguard hits faster.
action immolation if buff.meta.up -- Immolation Aura while in Metamorphosis: heavy fire damage around you.
action doom if debuff.doom.down and target.health > 30 -- Curse of Doom on targets that will live longer than a minute.
action immolate if debuff.immolate.remains < cast.immolate -- Keep Immolate up: Molten Core procs from it.
action corruption if debuff.corruption.down -- Keep Corruption up: cheap damage that also feeds Molten Core.
action soulfire if buff.decimation.up -- Decimation (target below 35%): Soul Fire is fast and needs no shard.
action incinerate if buff.molten.up -- Molten Core: Incinerate hits harder and casts faster, spend its charges.
action tap if mana < 15 -- Life Tap when you run out of mana.
action bolt -- Shadow Bolt as filler.
]],
es = [[
id: tc-warlock-demonology
rotacion: Demonología
clase: WARLOCK
especializacion: Demonología
arbol: 2
modo: pve
autor: Tactics Coach
version: 1
descripcion: Metamorfosis y Aura de inmolación en cuanto estén listas, Maldición del apocalipsis, Inmolar y Corrupción activas, gasta Diezmar en Fuego de alma y Núcleo fundido en Incinerar, Descarga de las Sombras de relleno.

hechizo armadura = 47893        # Fel Armor
hechizo transfusion = 57946     # Life Tap
hechizo metamorfosis = 47241    # Metamorphosis
hechizo potenciacion = 47193    # Demonic Empowerment
hechizo auraigni = 50589        # Immolation Aura
hechizo apocalipsis = 47867     # Curse of Doom
hechizo inmolar = 47811         # Immolate
hechizo corrupcion = 47813      # Corruption
hechizo fuegoalma = 47825       # Soul Fire
hechizo incinerar = 47838       # Incinerate
hechizo descarga = 47809        # Shadow Bolt
aura diezmar = 63167            # Decimation
aura nucleo = 71165             # Molten Core

accion armadura si beneficio.armadura.inactivo -- Armadura vil siempre puesta: más poder con hechizos.
accion transfusion si beneficio.transfusion.inactivo y mana < 80 -- Transfusión de vida para mantener el beneficio del glifo: poder con hechizos según tu espíritu.
accion metamorfosis -- Metamorfosis en cuanto esté lista: +20% de daño durante 30 segundos.
accion potenciacion si mascota -- Potenciación demoníaca en cuanto esté lista: tu guardia vil pega más rápido.
accion auraigni si beneficio.metamorfosis.activo -- Aura de inmolación durante la Metamorfosis: mucho daño de fuego a tu alrededor.
accion apocalipsis si perjuicio.apocalipsis.inactivo y objetivo.vida > 30 -- Maldición del apocalipsis en objetivos que vivirán más de un minuto.
accion inmolar si perjuicio.inmolar.restante < lanzamiento.inmolar -- Mantén Inmolar: de él salen las cargas de Núcleo fundido.
accion corrupcion si perjuicio.corrupcion.inactivo -- Mantén Corrupción: daño barato que también alimenta Núcleo fundido.
accion fuegoalma si beneficio.diezmar.activo -- Diezmar (objetivo bajo el 35%): Fuego de alma es rápido y no gasta fragmento.
accion incinerar si beneficio.nucleo.activo -- Núcleo fundido: Incinerar pega más y se lanza más rápido, gasta sus cargas.
accion transfusion si mana < 15 -- Transfusión de vida cuando te quedes sin maná.
accion descarga -- Descarga de las Sombras de relleno.
]],
})

table.insert(ns.builtin, {
en = [[
id: tc-warlock-affliction-pvp
rotation: Affliction (PvP)
class: WARLOCK
spec: Affliction
tree: 1
mode: pvp
author: Tactics Coach
version: 1
description: Pressure through DoTs: Haunt, Unstable Affliction, Corruption and Curse of Agony always up, Death Coil to stop casts or save yourself, Drain Life to outlast the enemy.

spell armor = 47893             # Fel Armor
spell coil = 47860              # Death Coil
spell howl = 17928              # Howl of Terror
spell haunt = 59164
spell unstable = 47843          # Unstable Affliction
spell corruption = 47813
spell agony = 47864             # Curse of Agony
spell bolt = 47809              # Shadow Bolt
spell drainlife = 47857         # Drain Life
spell tap = 57946               # Life Tap
aura trance = 17941             # Shadow Trance (Nightfall proc)

action armor if buff.armor.down -- Fel Armor always on: spell power and more healing received.
action coil if target.player and (target.casting or health < 35) -- Death Coil: a 3 s horror that stops the cast and heals you; DoT damage does not break it.
action howl if target.player and health < 30 -- Howl of Terror when melee are on you: fear everyone around and get room.
action unstable if debuff.unstable.remains < cast.unstable -- Unstable Affliction first: whoever dispels it is silenced and takes heavy damage.
action haunt -- Haunt whenever it is ready: damage, +20% to your DoTs and it heals you back.
action corruption if debuff.corruption.down -- Corruption always on: instant and the base of your pressure.
action agony if debuff.agony.down -- Curse of Agony for pressure; switch by hand to Tongues on casters or Exhaustion on melee.
action bolt if buff.trance.up -- Nightfall: instant Shadow Bolt, use it before it fades.
action drainlife if health < 60 -- Drain Life when you take damage: heals you while it hits.
action tap if mana < 25 and health > 60 -- Life Tap only with health to spare.
action bolt -- Shadow Bolt as filler: keeps Shadow Embrace up and lowers the target's healing.
]],
es = [[
id: tc-warlock-affliction-pvp
rotacion: Aflicción (PvP)
clase: WARLOCK
especializacion: Aflicción
arbol: 1
modo: pvp
autor: Tactics Coach
version: 1
descripcion: Presión con efectos periódicos: Poseer, Aflicción inestable, Corrupción y Maldición de agonía siempre puestas, Espiral de la muerte para cortar lanzamientos o salvarte y Drenar vida para aguantar más que el rival.

hechizo armadura = 47893        # Fel Armor
hechizo espiral = 47860         # Death Coil
hechizo aullido = 17928         # Howl of Terror
hechizo poseer = 59164          # Haunt
hechizo inestable = 47843       # Unstable Affliction
hechizo corrupcion = 47813      # Corruption
hechizo agonia = 47864          # Curse of Agony
hechizo descarga = 47809        # Shadow Bolt
hechizo drenarvida = 47857      # Drain Life
hechizo transfusion = 57946     # Life Tap
aura trance = 17941             # Shadow Trance

accion armadura si beneficio.armadura.inactivo -- Armadura vil siempre puesta: poder con hechizos y más curación recibida.
accion espiral si objetivo.jugador y (objetivo.lanzando o vida < 35) -- Espiral de la muerte: 3 s de terror que corta el lanzamiento y te cura; tus efectos periódicos no lo rompen.
accion aullido si objetivo.jugador y vida < 30 -- Aullido de terror cuando tienes cuerpo a cuerpo encima: asusta a todos los cercanos y ganas espacio.
accion inestable si perjuicio.inestable.restante < lanzamiento.inestable -- Aflicción inestable primero: quien la disipe queda silenciado y recibe mucho daño.
accion poseer -- Poseer en cuanto esté listo: daño, +20% a tus efectos periódicos y te cura al volver.
accion corrupcion si perjuicio.corrupcion.inactivo -- Corrupción siempre puesta: instantánea y la base de tu presión.
accion agonia si perjuicio.agonia.inactivo -- Maldición de agonía para presionar; cámbiala a mano por Lenguas contra lanzadores o Agotamiento contra cuerpo a cuerpo.
accion descarga si beneficio.trance.activo -- Trance de las Sombras (proc de Nightfall): Descarga de las Sombras instantánea, úsala antes de que se pierda.
accion drenarvida si vida < 60 -- Drenar vida cuando recibes daño: te cura mientras golpea.
accion transfusion si mana < 25 y vida > 60 -- Transfusión de vida solo si te sobra vida.
accion descarga -- Descarga de las Sombras de relleno: mantiene Abrazo de las Sombras y reduce la curación del objetivo.
]],
})

table.insert(ns.builtin, {
en = [[
id: tc-warlock-destruction-pvp
rotation: Destruction (PvP)
class: WARLOCK
spec: Destruction
tree: 3
mode: pvp
author: Tactics Coach
version: 1
description: Burst caster: Immolate, Conflagrate and Chaos Bolt for big hits, Shadowfury and Death Coil to stop casts, Shadowburn to finish.

spell armor = 47893             # Fel Armor
spell fury = 47847              # Shadowfury
spell coil = 47860              # Death Coil
spell elements = 47865          # Curse of the Elements
spell immolate = 47811
spell conflagrate = 17962
spell chaos = 59172             # Chaos Bolt
spell shadowburn = 47827
spell drainlife = 47857         # Drain Life
spell tap = 57946               # Life Tap
spell incinerate = 47838

action armor if buff.armor.down -- Fel Armor always on: spell power and more healing received.
action fury if target.player and target.casting -- Shadowfury: an instant stun that stops the cast.
action coil if target.player and (target.casting or health < 35) -- Death Coil: a 3 s horror that stops the cast and heals you.
action shadowburn if target.health < 20 and soul_shards >= 1 -- Shadowburn to finish: instant damage when the target is low.
action elements if target.player and debuff.elements.down -- Curse of the Elements: +13% to all your spell damage on the target.
action immolate if debuff.immolate.remains < cast.immolate -- Keep Immolate up: Conflagrate needs it and Incinerate hits harder.
action conflagrate if debuff.immolate.up -- Conflagrate whenever it is ready: instant hit and Backdraft for faster casts.
action chaos -- Chaos Bolt whenever it is ready: huge hit that cannot be absorbed by shields.
action drainlife if health < 50 -- Drain Life when you take damage: heals you while it hits.
action tap if mana < 20 and health > 60 -- Life Tap only with health to spare.
action incinerate -- Incinerate as filler.
]],
es = [[
id: tc-warlock-destruction-pvp
rotacion: Destrucción (PvP)
clase: WARLOCK
especializacion: Destrucción
arbol: 3
modo: pvp
autor: Tactics Coach
version: 1
descripcion: Daño explosivo: Inmolar, Conflagrar y Descarga de caos para golpes grandes, Furia de las Sombras y Espiral de la muerte para cortar lanzamientos y Quemadura de las Sombras para rematar.

hechizo armadura = 47893        # Fel Armor
hechizo furia = 47847           # Shadowfury
hechizo espiral = 47860         # Death Coil
hechizo elementos = 47865       # Curse of the Elements
hechizo inmolar = 47811         # Immolate
hechizo conflagrar = 17962      # Conflagrate
hechizo caos = 59172            # Chaos Bolt
hechizo quemadura = 47827       # Shadowburn
hechizo drenarvida = 47857      # Drain Life
hechizo transfusion = 57946     # Life Tap
hechizo incinerar = 47838       # Incinerate

accion armadura si beneficio.armadura.inactivo -- Armadura vil siempre puesta: poder con hechizos y más curación recibida.
accion furia si objetivo.jugador y objetivo.lanzando -- Furia de las Sombras: aturdimiento instantáneo que corta el lanzamiento.
accion espiral si objetivo.jugador y (objetivo.lanzando o vida < 35) -- Espiral de la muerte: 3 s de terror que corta el lanzamiento y te cura.
accion quemadura si objetivo.vida < 20 y fragmentos >= 1 -- Quemadura de las Sombras para rematar: daño instantáneo cuando el objetivo está bajo.
accion elementos si objetivo.jugador y perjuicio.elementos.inactivo -- Maldición de los elementos: +13% a todo tu daño con hechizos sobre el objetivo.
accion inmolar si perjuicio.inmolar.restante < lanzamiento.inmolar -- Mantén Inmolar: Conflagrar lo necesita e Incinerar pega más fuerte.
accion conflagrar si perjuicio.inmolar.activo -- Conflagrar en cuanto esté listo: golpe instantáneo y tus siguientes lanzamientos van más rápido.
accion caos -- Descarga de caos en cuanto esté lista: golpe enorme que los escudos no absorben.
accion drenarvida si vida < 50 -- Drenar vida cuando recibes daño: te cura mientras golpea.
accion transfusion si mana < 20 y vida > 60 -- Transfusión de vida solo si te sobra vida.
accion incinerar -- Incinerar de relleno.
]],
})

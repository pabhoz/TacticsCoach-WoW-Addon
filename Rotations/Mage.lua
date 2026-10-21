local _, ns = ...
ns = ns or TacticsCoachNS
ns.builtin = ns.builtin or {}

-- IDs verificados contra el Spell.dbc 3.3.5a del servidor (rango maximo de cada uno).
-- Meta de ICC: Arcano y Fuego (TTW) para daño; Escarcha de daño en PvE casi no se usaba.
-- Meta de la temporada 8: Escarcha (Congelación profunda, Dedos de escarcha, Congelación cerebral).
table.insert(ns.builtin, {
en = [[
id: tc-mage-arcane
rotation: Arcane
class: MAGE
spec: Arcane
tree: 1
mode: pve
author: Tactics Coach
version: 1
description: Build four Arcane Blast charges and keep blasting while your mana is high; spend Missile Barrage procs on Arcane Missiles. When mana runs low, release the charges with Arcane Missiles and Evocate.

spell armor = 43046             # Molten Armor
spell power = 12042             # Arcane Power
spell veins = 12472             # Icy Veins
spell image = 55342             # Mirror Image
spell pom = 12043               # Presence of Mind
spell evocation = 12051
spell blast = 42897             # Arcane Blast
spell missiles = 42846          # Arcane Missiles
spell barrage = 44781           # Arcane Barrage
aura charges = 36032            # Arcane Blast (debuff on you)
aura mb = 44401                 # Missile Barrage (buff)

action armor if buff.armor.down -- Molten Armor always on: more critical strike chance.
action power if self_debuff.charges.stack >= 3 -- Arcane Power with your charges up: +20% damage on your hardest blasts.
action veins -- Icy Veins whenever it is ready: 20% haste, more Arcane Blasts.
action image -- Mirror Image on cooldown: three copies that add damage.
action pom -- Presence of Mind on cooldown: your next Arcane Blast is instant.
action evocation if mana < 15 -- Out of mana: Evocation refills it, do it before you run dry.
action missiles if buff.mb.up and self_debuff.charges.stack >= 4 -- Missile Barrage at four charges: fast, free Arcane Missiles that hit hard.
action barrage if moving -- On the move: Arcane Barrage is instant.
action blast if self_debuff.charges.stack < 4 or mana > 35 -- Arcane Blast: each charge adds damage and cost; keep spamming while mana is above 35%.
action missiles -- Low on mana: Arcane Missiles to drop the charges and save mana.
]],
es = [[
id: tc-mage-arcane
rotacion: Arcano
clase: MAGE
especializacion: Arcano
arbol: 1
modo: pve
autor: Tactics Coach
version: 1
descripcion: Acumula cuatro cargas de Explosión Arcana y sigue lanzándola mientras tengas maná; gasta la Andanada de proyectiles en Misiles Arcanos. Con poco maná, suelta las cargas con Misiles Arcanos y usa Evocación.

hechizo armadura = 43046        # Molten Armor
hechizo poder = 12042           # Arcane Power
hechizo venas = 12472           # Icy Veins
hechizo reflejo = 55342         # Mirror Image
hechizo presencia = 12043       # Presence of Mind
hechizo evocacion = 12051       # Evocation
hechizo explosion = 42897       # Arcane Blast
hechizo misiles = 42846         # Arcane Missiles
hechizo tromba = 44781          # Arcane Barrage
aura cargas = 36032             # Arcane Blast (perjuicio sobre ti)
aura andanada = 44401           # Missile Barrage (beneficio)

accion armadura si beneficio.armadura.inactivo -- Armadura de arrabio siempre puesta: más probabilidad de crítico.
accion poder si perjuicio_propio.cargas.cargas >= 3 -- Poder Arcano con las cargas puestas: +20% de daño en tus explosiones más fuertes.
accion venas -- Venas heladas en cuanto esté lista: 20% de celeridad, más Explosiones Arcanas.
accion reflejo -- Reflejo exacto en cuanto esté listo: tres copias que suman daño.
accion presencia -- Presencia mental en cuanto esté lista: tu siguiente Explosión Arcana es instantánea.
accion evocacion si mana < 15 -- Sin maná: Evocación te lo recupera, úsala antes de quedarte seco.
accion misiles si beneficio.andanada.activo y perjuicio_propio.cargas.cargas >= 4 -- Andanada de proyectiles con cuatro cargas: Misiles Arcanos rápidos, gratis y muy fuertes.
accion tromba si moviendo -- En movimiento: Tromba Arcana es instantánea.
accion explosion si perjuicio_propio.cargas.cargas < 4 o mana > 35 -- Explosión Arcana: cada carga sube su daño y su coste; sigue mientras tengas más del 35% de maná.
accion misiles -- Con poco maná: Misiles Arcanos para soltar las cargas y ahorrar maná.
]],
})

table.insert(ns.builtin, {
en = [[
id: tc-mage-fire
rotation: Fire
class: MAGE
spec: Fire
tree: 2
mode: pve
author: Tactics Coach
version: 1
description: Keep Living Bomb and Improved Scorch on the target, spend every Hot Streak on an instant Pyroblast and cast Fireball as filler.

spell armor = 43046             # Molten Armor
spell combustion = 11129
spell image = 55342             # Mirror Image
spell pyro = 42891              # Pyroblast
spell bomb = 55360              # Living Bomb
spell scorch = 42859
spell blast = 42873             # Fire Blast
spell fireball = 42833
aura hot = 48108                # Hot Streak (buff)
aura iscorch = 22959            # Improved Scorch (debuff on target)

action armor if buff.armor.down -- Molten Armor always on: more critical strike chance.
action combustion -- Combustion whenever it is ready: more fire crits, more Hot Streaks.
action image -- Mirror Image on cooldown: three copies that add damage.
action pyro if buff.hot.up -- Hot Streak: instant Pyroblast, spend it right away before the next crit wastes it.
action bomb if debuff.bomb.down -- Keep Living Bomb ticking: it explodes at the end and can give you Hot Streak.
action scorch if debuff.iscorch.remains < 4 -- Improved Scorch: +5% spell crit on the target for the whole raid (skip it if a warlock covers it).
action blast if moving -- On the move: Fire Blast is instant.
action fireball -- Fireball as filler: its crits build Hot Streak.
]],
es = [[
id: tc-mage-fire
rotacion: Fuego
clase: MAGE
especializacion: Fuego
arbol: 2
modo: pve
autor: Tactics Coach
version: 1
descripcion: Mantén Bomba viva y Agostar mejorado en el objetivo, gasta cada Piroclasmo en una Piroexplosión instantánea y usa Bola de Fuego de relleno.

hechizo armadura = 43046        # Molten Armor
hechizo combustion = 11129      # Combustion
hechizo reflejo = 55342         # Mirror Image
hechizo piroexplosion = 42891   # Pyroblast
hechizo bomba = 55360           # Living Bomb
hechizo agostar = 42859         # Scorch
hechizo explosion = 42873       # Fire Blast
hechizo bola = 42833            # Fireball
aura piroclasmo = 48108         # Hot Streak (beneficio)
aura agostarmej = 22959         # Improved Scorch (perjuicio en el objetivo)

accion armadura si beneficio.armadura.inactivo -- Armadura de arrabio siempre puesta: más probabilidad de crítico.
accion combustion -- Combustión en cuanto esté lista: más críticos de fuego, más Piroclasmos.
accion reflejo -- Reflejo exacto en cuanto esté listo: tres copias que suman daño.
accion piroexplosion si beneficio.piroclasmo.activo -- Piroclasmo: Piroexplosión instantánea, gástalo ya antes de que el siguiente crítico lo desperdicie.
accion bomba si perjuicio.bomba.inactivo -- Mantén Bomba viva: explota al final y puede darte Piroclasmo.
accion agostar si perjuicio.agostarmej.restante < 4 -- Agostar mejorado: +5% de crítico con hechizos en el objetivo para toda la banda (sáltalo si un brujo ya lo cubre).
accion explosion si moviendo -- En movimiento: Explosión de fuego es instantánea.
accion bola -- Bola de Fuego de relleno: sus críticos generan Piroclasmo.
]],
})

table.insert(ns.builtin, {
en = [[
id: tc-mage-frost-pvp
rotation: Frost (PvP)
class: MAGE
spec: Frost
tree: 3
mode: pvp
author: Tactics Coach
version: 1
description: Survive with Ice Barrier and Ice Block, interrupt heals with Counterspell, and burst with Deep Freeze and Ice Lance on frozen targets or with Fingers of Frost; spend Fireball! on an instant Frostfire Bolt.

spell counterspell = 2139
spell block = 45438             # Ice Block
spell snap = 11958              # Cold Snap
spell barrier = 43039           # Ice Barrier
spell armor = 43046             # Molten Armor
spell elemental = 31687         # Summon Water Elemental
spell veins = 12472             # Icy Veins
spell deep = 44572              # Deep Freeze
spell ffb = 47610               # Frostfire Bolt
spell lance = 42914             # Ice Lance
spell frostbolt = 42842
aura fof = 44544                # Fingers of Frost (buff)
aura brain = 57761              # Fireball! (Brain Freeze buff)
aura nova = 42917               # Frost Nova (your root on the target)

action counterspell if target.casting -- Counterspell whatever they cast: it locks that school for several seconds.
action block if health < 20 -- About to die: Ice Block makes you immune for 10 seconds.
action snap if health < 40 and cooldown.barrier.remains > 5 -- Under pressure with Ice Barrier on cooldown: Cold Snap resets it (and Nova and Block).
action barrier if buff.barrier.down -- Ice Barrier always up: it absorbs damage and protects your casts from pushback.
action armor if buff.armor.down -- Molten Armor on: more crit for your Shatter combos.
action elemental if not pet -- Water Elemental out: its Freeze sets up Shatter and Deep Freeze.
action veins if target.player and target.health < 60 -- Icy Veins to burst when your target is going down.
action deep if buff.fof.up or debuff.nova.up -- Deep Freeze on a frozen target or with Fingers of Frost: 5 second stun and big damage.
action ffb if buff.brain.up -- Fireball!: instant, free Frostfire Bolt, ideal during the stun.
action lance if buff.fof.up or debuff.nova.up -- Ice Lance on a frozen target or with Fingers of Frost: triple damage with Shatter.
action lance if moving -- On the move: Ice Lance is instant.
action frostbolt -- Frostbolt as filler: slows and procs Fingers of Frost and Fireball!.
]],
es = [[
id: tc-mage-frost-pvp
rotacion: Escarcha (PvP)
clase: MAGE
especializacion: Escarcha
arbol: 3
modo: pvp
autor: Tactics Coach
version: 1
descripcion: Sobrevive con Barrera de hielo y Bloque de hielo, corta curaciones con Contrahechizo y revienta con Congelación profunda y Lanza de hielo sobre objetivos congelados o con Dedos de escarcha; gasta "¡Bola de Fuego!" en una Descarga de fuego helado instantánea.

hechizo contrahechizo = 2139    # Counterspell
hechizo bloque = 45438          # Ice Block
hechizo ola = 11958             # Cold Snap
hechizo barrera = 43039         # Ice Barrier
hechizo armadura = 43046        # Molten Armor
hechizo elemental = 31687       # Summon Water Elemental
hechizo venas = 12472           # Icy Veins
hechizo congelacion = 44572     # Deep Freeze
hechizo fuegohelado = 47610     # Frostfire Bolt
hechizo lanza = 42914           # Ice Lance
hechizo descarga = 42842        # Frostbolt
aura dedos = 44544              # Fingers of Frost (beneficio)
aura cerebral = 57761           # Fireball! (beneficio de Congelación cerebral)
aura nova = 42917               # Frost Nova (tu enraizamiento en el objetivo)

accion contrahechizo si objetivo.lanzando -- Contrahechizo a lo que lance: le bloquea esa escuela varios segundos.
accion bloque si vida < 20 -- A punto de morir: Bloque de hielo te hace inmune 10 segundos.
accion ola si vida < 40 y reutilizacion.barrera.restante > 5 -- Bajo presión y con Barrera de hielo en reutilización: Ola de frío la reinicia (y la Nova y el Bloque).
accion barrera si beneficio.barrera.inactivo -- Barrera de hielo siempre puesta: absorbe daño y evita que te retrasen los lanzamientos.
accion armadura si beneficio.armadura.inactivo -- Armadura de arrabio puesta: más crítico para tus combos de Hacer añicos.
accion elemental si no mascota -- Elemental de agua fuera: su Congelar prepara Hacer añicos y Congelación profunda.
accion venas si objetivo.jugador y objetivo.vida < 60 -- Venas heladas para rematar cuando tu objetivo está cayendo.
accion congelacion si beneficio.dedos.activo o perjuicio.nova.activo -- Congelación profunda sobre un objetivo congelado o con Dedos de escarcha: aturde 5 segundos y pega fuerte.
accion fuegohelado si beneficio.cerebral.activo -- ¡Bola de Fuego!: Descarga de fuego helado instantánea y gratis, ideal durante el aturdimiento.
accion lanza si beneficio.dedos.activo o perjuicio.nova.activo -- Lanza de hielo sobre un objetivo congelado o con Dedos de escarcha: triple de daño con Hacer añicos.
accion lanza si moviendo -- En movimiento: Lanza de hielo es instantánea.
accion descarga -- Descarga de Escarcha de relleno: ralentiza y activa Dedos de escarcha y ¡Bola de Fuego!.
]],
})

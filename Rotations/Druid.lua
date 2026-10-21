local _, ns = ...
ns = ns or TacticsCoachNS
ns.builtin = ns.builtin or {}

-- IDs verificados contra el Spell.dbc 3.3.5a del servidor (rango maximo de cada uno).
-- Feral gato y feral oso comparten el arbol 2: los nombres ("Feral Cat" < "Feral Tank",
-- "Feral felino" < "Feral tanque") hacen que la automatica elija la de gato. Los hechizos de la
-- otra forma se saltan solos porque no se pueden usar.

-- Equilibrio (PvE)
table.insert(ns.builtin, {
en = [[
id: tc-druid-balance
rotation: Balance
class: DRUID
spec: Balance
tree: 1
mode: pve
author: Tactics Coach
version: 1
description: Moonkin Form, Insect Swarm and Moonfire up, Starfall whenever it is ready. Wrath during Eclipse (Solar), Starfire during Eclipse (Lunar) and as filler.

spell moonkin = 24858           # Moonkin Form
spell ff = 770                  # Faerie Fire
spell starfall = 53201
spell fon = 33831               # Force of Nature
spell wrath = 48461
spell starfire = 48465
spell swarm = 48468             # Insect Swarm
spell moonfire = 48463
spell innervate = 29166
aura cat = 768                  # Cat Form
aura bear = 9634                # Dire Bear Form
aura solar = 48517              # Eclipse (Solar): +40% Wrath damage
aura lunar = 48518              # Eclipse (Lunar): +40% Starfire crit

action moonkin if buff.moonkin.down and buff.cat.down and buff.bear.down -- Moonkin Form always on: armor, crit for the raid and mana on crits.
action ff if debuff.ff.down -- Faerie Fire on the boss: with Improved Faerie Fire it gives the raid 3% spell hit.
action starfall -- Starfall whenever it is ready: big damage for free while you keep casting.
action wrath if buff.solar.up -- Eclipse (Solar): Wrath deals 40% more damage, spam it until it ends.
action starfire if buff.lunar.up -- Eclipse (Lunar): Starfire gets +40% crit, spam it until it ends.
action swarm if debuff.swarm.down -- Keep Insect Swarm up outside Eclipse: steady damage and it boosts Wrath.
action moonfire if debuff.moonfire.down -- Keep Moonfire up outside Eclipse: steady damage and it boosts Starfire.
action fon -- Force of Nature whenever it is ready: three treants for 30 seconds.
action innervate if mana < 30 -- Innervate yourself when your mana runs low.
action starfire -- Starfire as filler: its crits are what proc Eclipse (Solar). After a Solar ends, Wrath instead to proc the Lunar.
]],
es = [[
id: tc-druid-balance
rotacion: Equilibrio
clase: DRUID
especializacion: Equilibrio
arbol: 1
modo: pve
autor: Tactics Coach
version: 1
descripcion: Forma de lechúcico lunar, Enjambre de insectos y Fuego lunar activos, Lluvia de estrellas en cuanto esté lista. Cólera durante Eclipse (solar), Fuego estelar durante Eclipse (lunar) y de relleno.

hechizo lechucico = 24858       # Moonkin Form
hechizo feerico = 770           # Faerie Fire
hechizo lluvia = 53201          # Starfall
hechizo fuerza = 33831          # Force of Nature
hechizo colera = 48461          # Wrath
hechizo estelar = 48465         # Starfire
hechizo enjambre = 48468        # Insect Swarm
hechizo lunar = 48463           # Moonfire
hechizo estimular = 29166       # Innervate
aura felina = 768               # Cat Form
aura oso = 9634                 # Dire Bear Form
aura eclipsesolar = 48517       # Eclipse (Solar)
aura eclipselunar = 48518       # Eclipse (Lunar)

accion lechucico si beneficio.lechucico.inactivo y beneficio.felina.inactivo y beneficio.oso.inactivo -- Forma de lechúcico lunar siempre puesta: armadura, crítico para la banda y maná con tus críticos.
accion feerico si perjuicio.feerico.inactivo -- Fuego feérico en el jefe: con Fuego feérico mejorado da a la banda un 3% de golpe con hechizos.
accion lluvia -- Lluvia de estrellas en cuanto esté lista: mucho daño gratis mientras sigues lanzando.
accion colera si beneficio.eclipsesolar.activo -- Eclipse (solar): Cólera hace un 40% más de daño, lánzala sin parar hasta que se acabe.
accion estelar si beneficio.eclipselunar.activo -- Eclipse (lunar): Fuego estelar gana +40% de crítico, lánzalo sin parar hasta que se acabe.
accion enjambre si perjuicio.enjambre.inactivo -- Mantén Enjambre de insectos fuera del Eclipse: daño constante y mejora Cólera.
accion lunar si perjuicio.lunar.inactivo -- Mantén Fuego lunar fuera del Eclipse: daño constante y mejora Fuego estelar.
accion fuerza -- Fuerza de la naturaleza en cuanto esté lista: tres árboles durante 30 segundos.
accion estimular si mana < 30 -- Estimular sobre ti cuando te quede poco maná.
accion estelar -- Fuego estelar de relleno: sus críticos activan Eclipse (solar). Al acabar un Eclipse solar, usa Cólera para activar el lunar.
]],
})

-- Feral gato (PvE)
table.insert(ns.builtin, {
en = [[
id: tc-druid-feral-cat
rotation: Feral Cat
class: DRUID
spec: Feral Cat
tree: 2
mode: pve
author: Tactics Coach
version: 1
description: Cat Form. Keep Savage Roar, Rip, Mangle and Rake up, Shred as builder and Ferocious Bite only when Rip and Roar have time left.

spell cat = 768                 # Cat Form
spell fff = 16857               # Faerie Fire (Feral)
spell roar = 52610              # Savage Roar
spell tf = 50213                # Tiger's Fury
spell berserk = 50334
spell rip = 49800
spell bite = 48577              # Ferocious Bite
spell mangle = 48566            # Mangle (Cat)
spell rake = 48574
spell shred = 48572
aura bear = 9634                # Dire Bear Form
aura cc = 16870                 # Clearcasting (Omen of Clarity)

action cat if buff.cat.down and buff.bear.down -- Cat Form: all your damage abilities need it.
action shred if buff.cc.up -- Clearcasting: free Shred, spend it before anything else.
action roar if combo_points >= 1 and buff.roar.down -- Savage Roar first: +30% physical damage, even with 1 combo point.
action tf if energy < 40 and buff.berserk.down -- Tiger's Fury when low on energy: +60 energy with King of the Jungle.
action berserk if buff.tf.up -- Berserk right after Tiger's Fury: half energy cost for 15 seconds.
action rip if combo_points >= 5 and debuff.rip.remains < 2 and target.health > 10 -- At 5 points, refresh Rip before it falls off: your biggest damage.
action roar if combo_points >= 5 and buff.roar.remains < 6 -- At 5 points, extend Savage Roar if it is about to expire.
action bite if combo_points >= 5 and debuff.rip.remains > 10 and buff.roar.remains > 8 -- At 5 points with Rip and Roar safe, spend on Ferocious Bite.
action mangle if debuff.mangle.remains < 2 -- Keep Mangle up: +30% bleed damage (skip if a bear or Trauma warrior keeps it).
action rake if debuff.rake.remains < 1 -- Keep Rake up: cheap bleed that pays for itself.
action fff if debuff.fff.down -- Faerie Fire (Feral) when it is missing: armor debuff for the raid, costs no energy.
action shred -- Shred from behind to build combo points.
]],
es = [[
id: tc-druid-feral-cat
rotacion: Feral felino
clase: DRUID
especializacion: Feral felino
arbol: 2
modo: pve
autor: Tactics Coach
version: 1
descripcion: Forma felina. Mantén Rugido salvaje, Destripar, Destrozar y Arañazo, Triturar para generar y Mordedura feroz solo cuando Destripar y Rugido tengan tiempo de sobra.

hechizo felina = 768            # Cat Form
hechizo feerico = 16857         # Faerie Fire (Feral)
hechizo rugido = 52610          # Savage Roar
hechizo furia = 50213           # Tiger's Fury
hechizo rabiar = 50334          # Berserk
hechizo destripar = 49800       # Rip
hechizo mordedura = 48577       # Ferocious Bite
hechizo destrozar = 48566       # Mangle (Cat)
hechizo aranazo = 48574         # Rake
hechizo triturar = 48572        # Shred
aura oso = 9634                 # Dire Bear Form
aura libre = 16870              # Clearcasting

accion felina si beneficio.felina.inactivo y beneficio.oso.inactivo -- Forma felina: todas tus habilidades de daño la necesitan.
accion triturar si beneficio.libre.activo -- Libre de lanzamiento: Triturar gratis, gástalo antes que nada.
accion rugido si puntos >= 1 y beneficio.rugido.inactivo -- Rugido salvaje primero: +30% de daño físico, aunque sea con 1 punto.
accion furia si energia < 40 y beneficio.rabiar.inactivo -- Furia del tigre con poca energía: +60 de energía con Rey de la selva.
accion rabiar si beneficio.furia.activo -- Rabiar justo después de Furia del tigre: la mitad de coste de energía durante 15 segundos.
accion destripar si puntos >= 5 y perjuicio.destripar.restante < 2 y objetivo.vida > 10 -- Con 5 puntos, renueva Destripar antes de que se caiga: tu mayor daño.
accion rugido si puntos >= 5 y beneficio.rugido.restante < 6 -- Con 5 puntos, alarga Rugido salvaje si está a punto de acabarse.
accion mordedura si puntos >= 5 y perjuicio.destripar.restante > 10 y beneficio.rugido.restante > 8 -- Con 5 puntos y Destripar y Rugido seguros, gasta en Mordedura feroz.
accion destrozar si perjuicio.destrozar.restante < 2 -- Mantén Destrozar: +30% de daño de sangrado (sáltalo si un oso o un guerrero con Trauma lo mantiene).
accion aranazo si perjuicio.aranazo.restante < 1 -- Mantén Arañazo: sangrado barato que se paga solo.
accion feerico si perjuicio.feerico.inactivo -- Fuego feérico (feral) si falta: reduce la armadura para la banda y no cuesta energía.
accion triturar -- Triturar desde detrás para generar puntos de combo.
]],
})

-- Feral oso tanque (PvE)
table.insert(ns.builtin, {
en = [[
id: tc-druid-feral-bear
rotation: Feral Tank (Bear)
class: DRUID
spec: Feral Tank
tree: 2
mode: pve
author: Tactics Coach
version: 1
description: Dire Bear Form. Mangle on cooldown, Faerie Fire (Feral) and 5 stacks of Lacerate, Swipe as filler and Maul to dump extra rage. Cooldowns when your health drops.

spell bear = 9634               # Dire Bear Form
spell survival = 61336          # Survival Instincts
spell regen = 22842             # Frenzied Regeneration
spell barkskin = 22812
spell enrage = 5229
spell berserk = 50334
spell mangle = 48564            # Mangle (Bear)
spell fff = 16857               # Faerie Fire (Feral)
spell demo = 48560              # Demoralizing Roar
spell lacerate = 48568
spell maul = 48480
spell swipe = 48562             # Swipe (Bear)
aura cat = 768                  # Cat Form

action bear if buff.bear.down and buff.cat.down -- Dire Bear Form: armor, health and threat to tank.
action survival if health < 30 -- Survival Instincts below 30% health: +30% maximum health for 20 seconds.
action regen if health < 40 and buff.survival.up -- Frenzied Regeneration inside Survival Instincts: it heals for much more.
action barkskin if health < 60 -- Barkskin when you take heavy damage: 20% less damage taken, off the global cooldown.
action enrage if rage < 20 and combat -- Enrage when you lack rage: 20 rage plus more over 10 seconds.
action berserk -- Berserk whenever it is ready: Mangle hits 3 targets with no cooldown.
action mangle -- Mangle (Bear) on cooldown: your strongest threat ability.
action fff -- Faerie Fire (Feral) on cooldown: in bear form it deals damage and threat.
action demo if debuff.demo.down -- Demoralizing Roar if missing: the boss deals less physical damage.
action lacerate if debuff.lacerate.stack < 5 or debuff.lacerate.remains < 4 -- Build Lacerate to 5 stacks and refresh it before it falls off.
action maul if rage >= 50 -- Maul to dump extra rage: it hits on your next swing.
action swipe -- Swipe as filler: threat on everything in front of you.
]],
es = [[
id: tc-druid-feral-bear
rotacion: Feral tanque (oso)
clase: DRUID
especializacion: Feral tanque
arbol: 2
modo: pve
autor: Tactics Coach
version: 1
descripcion: Forma de oso temible. Destrozar en cuanto esté listo, Fuego feérico (feral) y 5 cargas de Lacerar, Flagelo de relleno y Magullar para gastar la ira de sobra. Defensivos cuando baje tu vida.

hechizo oso = 9634              # Dire Bear Form
hechizo instintos = 61336       # Survival Instincts
hechizo regeneracion = 22842    # Frenzied Regeneration
hechizo corteza = 22812         # Barkskin
hechizo enfurecer = 5229        # Enrage
hechizo rabiar = 50334          # Berserk
hechizo destrozar = 48564       # Mangle (Bear)
hechizo feerico = 16857         # Faerie Fire (Feral)
hechizo rugido = 48560          # Demoralizing Roar
hechizo lacerar = 48568         # Lacerate
hechizo magullar = 48480        # Maul
hechizo flagelo = 48562         # Swipe (Bear)
aura felina = 768               # Cat Form

accion oso si beneficio.oso.inactivo y beneficio.felina.inactivo -- Forma de oso temible: armadura, vida y amenaza para tanquear.
accion instintos si vida < 30 -- Instintos de supervivencia por debajo del 30%: +30% de vida máxima durante 20 segundos.
accion regeneracion si vida < 40 y beneficio.instintos.activo -- Regeneración frenética dentro de Instintos de supervivencia: cura mucho más.
accion corteza si vida < 60 -- Piel de corteza cuando recibes mucho daño: 20% menos de daño y no gasta tiempo global.
accion enfurecer si ira < 20 y combate -- Enfurecer cuando te falta ira: 20 de ira y más durante 10 segundos.
accion rabiar -- Rabiar en cuanto esté listo: Destrozar golpea a 3 objetivos y sin reutilización.
accion destrozar -- Destrozar (oso) en cuanto esté listo: tu habilidad de más amenaza.
accion feerico -- Fuego feérico (feral) en cuanto esté listo: en forma de oso hace daño y amenaza.
accion rugido si perjuicio.rugido.inactivo -- Rugido desmoralizador si falta: el jefe hace menos daño físico.
accion lacerar si perjuicio.lacerar.cargas < 5 o perjuicio.lacerar.restante < 4 -- Sube Lacerar a 5 cargas y renuévalo antes de que se caiga.
accion magullar si ira >= 50 -- Magullar para gastar la ira de sobra: golpea en tu siguiente ataque.
accion flagelo -- Flagelo de relleno: amenaza sobre todo lo que tienes delante.
]],
})

-- Restauracion (PvE): sobre el aliado que tienes seleccionado
table.insert(ns.builtin, {
en = [[
id: tc-druid-restoration
rotation: Restoration
class: DRUID
spec: Restoration
tree: 3
mode: pve
author: Tactics Coach
version: 1
description: Tree of Life. Roll Lifebloom on the tank, Rejuvenation and Wild Growth on whoever takes damage, Swiftmend and Nourish for big heals. Suggestions are for your selected ally.

spell tree = 33891              # Tree of Life
spell innervate = 29166
spell ns = 17116                # Nature's Swiftness
spell ht = 48378                # Healing Touch
spell swiftmend = 18562
spell lifebloom = 48451
spell wg = 53251                # Wild Growth
spell rejuv = 48441             # Rejuvenation
spell regrowth = 48443
spell nourish = 50464

action tree if buff.tree.down -- Tree of Life always on: cheaper HoTs and more healing for your group.
action innervate if mana < 25 -- Innervate yourself when your mana runs low.
action ns if target.health < 30 -- Emergency: Nature's Swiftness makes your next Healing Touch instant.
action ht if buff.ns.up -- With Nature's Swiftness up, an instant Healing Touch saves the ally.
action swiftmend if target.health < 60 and (target_buff.rejuv.up or target_buff.regrowth.up) -- Swiftmend on a hurt ally with your HoT: big instant heal.
action lifebloom if target_buff.lifebloom.up and (target_buff.lifebloom.stack < 3 or target_buff.lifebloom.remains < 2) -- Keep Lifebloom rolling at 3 stacks on the tank (start it yourself): refresh before it blooms.
action wg if target.health < 90 -- Wild Growth whenever it is ready and people take damage: heals 5 allies around the target.
action rejuv if target_buff.rejuv.down and target.health < 95 -- Rejuvenation on a hurt ally: cheap HoT that also enables Swiftmend.
action regrowth if target.health < 50 and target_buff.regrowth.down -- Regrowth on a badly hurt ally: direct heal plus HoT.
action nourish if target.health < 90 -- Nourish as filler: fast, and heals 20% more if the ally has your HoTs.
]],
es = [[
id: tc-druid-restoration
rotacion: Restauración
clase: DRUID
especializacion: Restauración
arbol: 3
modo: pve
autor: Tactics Coach
version: 1
descripcion: Árbol de vida. Flor de vida rodando sobre el tanque, Rejuvenecimiento y Crecimiento salvaje sobre quien recibe daño, Alivio presto y Nutrir para curar fuerte. Las sugerencias son sobre el aliado seleccionado.

hechizo arbol = 33891           # Tree of Life
hechizo estimular = 29166       # Innervate
hechizo presteza = 17116        # Nature's Swiftness
hechizo toque = 48378           # Healing Touch
hechizo alivio = 18562          # Swiftmend
hechizo flor = 48451            # Lifebloom
hechizo crecimiento = 53251     # Wild Growth
hechizo rejuve = 48441          # Rejuvenation
hechizo recrecimiento = 48443   # Regrowth
hechizo nutrir = 50464          # Nourish

accion arbol si beneficio.arbol.inactivo -- Árbol de vida siempre puesto: HoTs más baratos y más curación para tu grupo.
accion estimular si mana < 25 -- Estimular sobre ti cuando te quede poco maná.
accion presteza si objetivo.vida < 30 -- Emergencia: Presteza de la naturaleza hace instantáneo tu siguiente Toque de sanación.
accion toque si beneficio.presteza.activo -- Con Presteza de la naturaleza activa, un Toque de sanación instantáneo salva al aliado.
accion alivio si objetivo.vida < 60 y (beneficio_objetivo.rejuve.activo o beneficio_objetivo.recrecimiento.activo) -- Alivio presto sobre un aliado herido con tu HoT: gran curación instantánea.
accion flor si beneficio_objetivo.flor.activo y (beneficio_objetivo.flor.cargas < 3 o beneficio_objetivo.flor.restante < 2) -- Mantén Flor de vida rodando con 3 cargas en el tanque (empiézala tú): renuévala antes de que florezca.
accion crecimiento si objetivo.vida < 90 -- Crecimiento salvaje en cuanto esté listo y haya daño: cura a 5 aliados alrededor del objetivo.
accion rejuve si beneficio_objetivo.rejuve.inactivo y objetivo.vida < 95 -- Rejuvenecimiento sobre un aliado herido: HoT barato que además habilita Alivio presto.
accion recrecimiento si objetivo.vida < 50 y beneficio_objetivo.recrecimiento.inactivo -- Recrecimiento sobre un aliado muy herido: curación directa más HoT.
accion nutrir si objetivo.vida < 90 -- Nutrir de relleno: rápido, y cura un 20% más si el aliado tiene tus HoTs.
]],
})

-- Feral gato (PvP)
table.insert(ns.builtin, {
en = [[
id: tc-druid-feral-pvp
rotation: Feral (PvP)
class: DRUID
spec: Feral
tree: 2
mode: pvp
author: Tactics Coach
version: 1
description: Cat Form. Open with Pounce from Prowl, keep Rip, Rake and Mangle up, Maim to stun at 5 points and spend Predator's Swiftness on Cyclone or a self-heal.

spell cat = 768                 # Cat Form
spell pounce = 49803
spell survival = 61336          # Survival Instincts
spell barkskin = 22812
spell cyclone = 33786
spell ht = 48378                # Healing Touch
spell roar = 52610              # Savage Roar
spell tf = 50213                # Tiger's Fury
spell berserk = 50334
spell rip = 49800
spell bite = 48577              # Ferocious Bite
spell maim = 49802
spell fff = 16857               # Faerie Fire (Feral)
spell mangle = 48566            # Mangle (Cat)
spell rake = 48574
spell shred = 48572
aura bear = 9634                # Dire Bear Form
aura ps = 69369                 # Predator's Swiftness
aura cc = 16870                 # Clearcasting

action cat if buff.cat.down and buff.bear.down -- Cat Form: all your damage and control need it.
action pounce if stealthed -- From Prowl, Pounce: 3-second stun and a bleed to open.
action survival if health < 30 -- Survival Instincts below 30%: +30% maximum health, buys time for your healer.
action barkskin if health < 50 -- Barkskin under pressure: 20% less damage, usable while stunned.
action cyclone if buff.ps.up and target.casting -- Predator's Swiftness: instant Cyclone stops their cast.
action ht if buff.ps.up and health < 60 -- Predator's Swiftness: instant Healing Touch on yourself (it pulls you out of Cat Form).
action roar if combo_points >= 1 and buff.roar.down -- Savage Roar up first: +30% physical damage.
action tf if energy < 40 and buff.berserk.down -- Tiger's Fury when low on energy: +60 energy and more damage.
action berserk if target.health < 70 -- Berserk to burst a target: half energy cost, and it breaks fear.
action bite if combo_points >= 5 and target.health < 30 -- Target low: Ferocious Bite at 5 points to finish them.
action rip if combo_points >= 5 and debuff.rip.remains < 2 -- At 5 points, Rip: a strong bleed that pressures healers.
action maim if combo_points >= 5 -- At 5 points with Rip up, Maim: up to 5 seconds of stun to set up a kill or a Cyclone.
action mangle if debuff.mangle.remains < 2 -- Keep Mangle up: +30% bleed damage.
action rake if debuff.rake.remains < 1 -- Keep Rake up: cheap bleed, stops rogues and druids from going back into stealth.
action shred if buff.cc.up -- Clearcasting: free Shred if you are behind.
action fff if debuff.fff.down and target.player -- Faerie Fire (Feral) on players: they cannot stealth or turn invisible.
action mangle -- Mangle as builder: unlike Shred, it works from any side.
]],
es = [[
id: tc-druid-feral-pvp
rotacion: Feral (PvP)
clase: DRUID
especializacion: Feral
arbol: 2
modo: pvp
autor: Tactics Coach
version: 1
descripcion: Forma felina. Abre con Abalanzarse desde Acechar, mantén Destripar, Arañazo y Destrozar, Mutilar para aturdir con 5 puntos y gasta Presteza del depredador en Ciclón o en curarte.

hechizo felina = 768            # Cat Form
hechizo abalanzarse = 49803     # Pounce
hechizo instintos = 61336       # Survival Instincts
hechizo corteza = 22812         # Barkskin
hechizo ciclon = 33786          # Cyclone
hechizo toque = 48378           # Healing Touch
hechizo rugido = 52610          # Savage Roar
hechizo furia = 50213           # Tiger's Fury
hechizo rabiar = 50334          # Berserk
hechizo destripar = 49800       # Rip
hechizo mordedura = 48577       # Ferocious Bite
hechizo mutilar = 49802         # Maim
hechizo feerico = 16857         # Faerie Fire (Feral)
hechizo destrozar = 48566       # Mangle (Cat)
hechizo aranazo = 48574         # Rake
hechizo triturar = 48572        # Shred
aura oso = 9634                 # Dire Bear Form
aura presteza = 69369           # Predator's Swiftness
aura libre = 16870              # Clearcasting

accion felina si beneficio.felina.inactivo y beneficio.oso.inactivo -- Forma felina: todo tu daño y control la necesitan.
accion abalanzarse si sigilo -- Desde Acechar, Abalanzarse: 3 segundos de aturdimiento y un sangrado para abrir.
accion instintos si vida < 30 -- Instintos de supervivencia por debajo del 30%: +30% de vida máxima, da tiempo a tu sanador.
accion corteza si vida < 50 -- Piel de corteza bajo presión: 20% menos de daño, se puede usar aturdido.
accion ciclon si beneficio.presteza.activo y objetivo.lanzando -- Presteza del depredador: Ciclón instantáneo corta su lanzamiento.
accion toque si beneficio.presteza.activo y vida < 60 -- Presteza del depredador: Toque de sanación instantáneo sobre ti (te saca de la Forma felina).
accion rugido si puntos >= 1 y beneficio.rugido.inactivo -- Rugido salvaje primero: +30% de daño físico.
accion furia si energia < 40 y beneficio.rabiar.inactivo -- Furia del tigre con poca energía: +60 de energía y más daño.
accion rabiar si objetivo.vida < 70 -- Rabiar para reventar a un objetivo: la mitad de coste de energía, y rompe el miedo.
accion mordedura si puntos >= 5 y objetivo.vida < 30 -- Objetivo bajo: Mordedura feroz con 5 puntos para rematarlo.
accion destripar si puntos >= 5 y perjuicio.destripar.restante < 2 -- Con 5 puntos, Destripar: un sangrado fuerte que presiona a los sanadores.
accion mutilar si puntos >= 5 -- Con 5 puntos y Destripar activo, Mutilar: hasta 5 segundos de aturdimiento para matar o encadenar un Ciclón.
accion destrozar si perjuicio.destrozar.restante < 2 -- Mantén Destrozar: +30% de daño de sangrado.
accion aranazo si perjuicio.aranazo.restante < 1 -- Mantén Arañazo: sangrado barato que impide a pícaros y druidas volver al sigilo.
accion triturar si beneficio.libre.activo -- Libre de lanzamiento: Triturar gratis si estás detrás.
accion feerico si perjuicio.feerico.inactivo y objetivo.jugador -- Fuego feérico (feral) sobre jugadores: no pueden entrar en sigilo ni hacerse invisibles.
accion destrozar -- Destrozar para generar: a diferencia de Triturar, funciona desde cualquier lado.
]],
})

-- Restauracion (PvP)
table.insert(ns.builtin, {
en = [[
id: tc-druid-restoration-pvp
rotation: Restoration (PvP)
class: DRUID
spec: Restoration
tree: 3
mode: pvp
author: Tactics Coach
version: 1
description: Keep HoTs rolling on your teammates, Swiftmend and Nature's Swiftness for emergencies, and Cyclone or Entangling Roots on enemies when your team is safe.

spell tree = 33891              # Tree of Life
spell barkskin = 22812
spell ns = 17116                # Nature's Swiftness
spell ht = 48378                # Healing Touch
spell swiftmend = 18562
spell rejuv = 48441             # Rejuvenation
spell lifebloom = 48451
spell wg = 53251                # Wild Growth
spell regrowth = 48443
spell nourish = 50464
spell cyclone = 33786
spell roots = 53308             # Entangling Roots
aura cat = 768                  # Cat Form
aura bear = 9634                # Dire Bear Form

action barkskin if health < 50 -- Barkskin when you are focused: 20% less damage, usable while stunned.
action tree if buff.tree.down and buff.cat.down and buff.bear.down and target.friendly -- Tree of Life to heal: extra armor and cheaper HoTs.
action ns if target.friendly and target.health < 35 -- Emergency: Nature's Swiftness makes your next Healing Touch instant.
action ht if buff.ns.up and target.friendly -- With Nature's Swiftness up, an instant Healing Touch saves your teammate.
action swiftmend if target.friendly and target.health < 60 and (target_buff.rejuv.up or target_buff.regrowth.up) -- Swiftmend on a teammate in trouble: instant heal that cannot be interrupted.
action rejuv if target.friendly and target_buff.rejuv.down -- Rejuvenation on every teammate: instant, it heals while you move and enables Swiftmend.
action lifebloom if target.friendly and target.health < 90 and target_buff.lifebloom.stack < 3 -- Stack Lifebloom on the teammate under pressure: instant healing you can cast while kiting.
action wg if target.friendly and target.health < 90 -- Wild Growth whenever it is ready: instant HoT on the whole team.
action regrowth if target.friendly and target.health < 50 and target_buff.regrowth.down -- Regrowth on a badly hurt teammate, if you can cast safely.
action nourish if target.friendly and target.health < 80 -- Nourish when you are not being interrupted: fast heal boosted by your HoTs.
action cyclone if not target.friendly and target.player -- Enemy selected and team safe: Cyclone them for 6 seconds (leave Tree of Life first).
action roots if not target.friendly and debuff.roots.down -- Entangling Roots on melee chasing your team.
]],
es = [[
id: tc-druid-restoration-pvp
rotacion: Restauración (PvP)
clase: DRUID
especializacion: Restauración
arbol: 3
modo: pvp
autor: Tactics Coach
version: 1
descripcion: Mantén tus HoTs rodando sobre tu equipo, Alivio presto y Presteza de la naturaleza para emergencias, y Ciclón o Raíces enredadoras sobre enemigos cuando tu equipo esté a salvo.

hechizo arbol = 33891           # Tree of Life
hechizo corteza = 22812         # Barkskin
hechizo presteza = 17116        # Nature's Swiftness
hechizo toque = 48378           # Healing Touch
hechizo alivio = 18562          # Swiftmend
hechizo rejuve = 48441          # Rejuvenation
hechizo flor = 48451            # Lifebloom
hechizo crecimiento = 53251     # Wild Growth
hechizo recrecimiento = 48443   # Regrowth
hechizo nutrir = 50464          # Nourish
hechizo ciclon = 33786          # Cyclone
hechizo raices = 53308          # Entangling Roots
aura felina = 768               # Cat Form
aura oso = 9634                 # Dire Bear Form

accion corteza si vida < 50 -- Piel de corteza cuando te centran: 20% menos de daño, se puede usar aturdido.
accion arbol si beneficio.arbol.inactivo y beneficio.felina.inactivo y beneficio.oso.inactivo y objetivo.amistoso -- Árbol de vida para curar: armadura extra y HoTs más baratos.
accion presteza si objetivo.amistoso y objetivo.vida < 35 -- Emergencia: Presteza de la naturaleza hace instantáneo tu siguiente Toque de sanación.
accion toque si beneficio.presteza.activo y objetivo.amistoso -- Con Presteza de la naturaleza activa, un Toque de sanación instantáneo salva a tu compañero.
accion alivio si objetivo.amistoso y objetivo.vida < 60 y (beneficio_objetivo.rejuve.activo o beneficio_objetivo.recrecimiento.activo) -- Alivio presto sobre un compañero en apuros: curación instantánea que no se puede interrumpir.
accion rejuve si objetivo.amistoso y beneficio_objetivo.rejuve.inactivo -- Rejuvenecimiento en cada compañero: instantáneo, cura mientras te mueves y habilita Alivio presto.
accion flor si objetivo.amistoso y objetivo.vida < 90 y beneficio_objetivo.flor.cargas < 3 -- Acumula Flor de vida en el compañero bajo presión: curación instantánea que puedes lanzar mientras huyes.
accion crecimiento si objetivo.amistoso y objetivo.vida < 90 -- Crecimiento salvaje en cuanto esté listo: HoT instantáneo sobre todo el equipo.
accion recrecimiento si objetivo.amistoso y objetivo.vida < 50 y beneficio_objetivo.recrecimiento.inactivo -- Recrecimiento sobre un compañero muy herido, si puedes lanzarlo a salvo.
accion nutrir si objetivo.amistoso y objetivo.vida < 80 -- Nutrir cuando no te estén interrumpiendo: curación rápida potenciada por tus HoTs.
accion ciclon si no objetivo.amistoso y objetivo.jugador -- Enemigo seleccionado y equipo a salvo: Ciclón durante 6 segundos (sal antes del Árbol de vida).
accion raices si no objetivo.amistoso y perjuicio.raices.inactivo -- Raíces enredadoras sobre el cuerpo a cuerpo que persigue a tu equipo.
]],
})

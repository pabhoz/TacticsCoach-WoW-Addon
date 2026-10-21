local _, ns = ...
ns = ns or TacticsCoachNS
ns.builtin = ns.builtin or {}

-- IDs verificados contra el Spell.dbc 3.3.5a del servidor (rango maximo de cada uno).
-- La misma rotacion en los dos idiomas: el id fijo hace que cambiar de idioma no la vuelva otra.
table.insert(ns.builtin, {
en = [[
id: tc-subtlety
rotation: Subtlety
class: ROGUE
spec: Subtlety
tree: 3
author: Tactics Coach
version: 1
description: Hemorrhage as your builder. Keep Slice and Dice and Rupture up, and use Shadow Dance to chain Ambushes.

spell premeditation = 14183
spell ambush = 48691
spell slice = 6774
spell rupture = 48672
spell eviscerate = 48668
spell dance = 51713
spell hemorrhage = 48660

action premeditation if (stealthed or buff.dance.up) and combo_points <= 2 -- From stealth or Shadow Dance: 2 free combo points.
action ambush if stealthed or buff.dance.up -- In stealth or Shadow Dance, Ambush is your hardest hit (needs a dagger, from behind).
action slice if combo_points >= 2 and buff.slice.remains < 2 -- Keep Slice and Dice up: +40% attack speed.
action rupture if combo_points >= 5 and debuff.rupture.remains < 2 and target.health > 10 -- At 5 points, refresh Rupture before it falls off.
action eviscerate if combo_points >= 5 -- At 5 points with everything up, spend on Eviscerate.
action dance if energy >= 70 and combo_points <= 2 -- Shadow Dance with pooled energy to chain Ambushes.
action hemorrhage if debuff.hemorrhage.down -- Keep the Hemorrhage debuff on the target.
action hemorrhage -- Hemorrhage to build combo points.
]],
es = [[
id: tc-subtlety
rotacion: Sutileza
clase: ROGUE
especializacion: Sutileza
arbol: 3
autor: Tactics Coach
version: 1
descripcion: Hemorragia como generador. Mantén Hacer picadillo y Ruptura, y aprovecha Danza de las Sombras para encadenar Emboscadas.

hechizo premeditacion = 14183
hechizo emboscada = 48691
hechizo picadillo = 6774
hechizo ruptura = 48672
hechizo eviscerar = 48668
hechizo danza = 51713
hechizo hemorragia = 48660

accion premeditacion si (sigilo o beneficio.danza.activo) y puntos <= 2 -- Desde sigilo o en Danza: 2 puntos de combo gratis.
accion emboscada si sigilo o beneficio.danza.activo -- En sigilo o en Danza, Emboscada es tu golpe más fuerte (pide daga y estar detrás).
accion picadillo si puntos >= 2 y beneficio.picadillo.restante < 2 -- Hacer picadillo siempre activo: +40% de velocidad de ataque.
accion ruptura si puntos >= 5 y perjuicio.ruptura.restante < 2 y objetivo.vida > 10 -- Con 5 puntos, renueva Ruptura antes de que se caiga.
accion eviscerar si puntos >= 5 -- Con 5 puntos y todo activo, gasta en Eviscerar.
accion danza si energia >= 70 y puntos <= 2 -- Danza de las Sombras con energía guardada para encadenar Emboscadas.
accion hemorragia si perjuicio.hemorragia.inactivo -- Mantén el perjuicio de Hemorragia en el objetivo.
accion hemorragia -- Hemorragia para generar puntos de combo.
]],
})

table.insert(ns.builtin, {
en = [[
id: tc-rogue-assassination
rotation: Assassination
class: ROGUE
spec: Assassination
tree: 1
mode: pve
author: Tactics Coach
version: 1
description: Mutilate to build, Envenom at 4-5 points. Slice and Dice and Hunger for Blood always up, Rupture as the bleed that enables Hunger for Blood.

spell mutilate = 48666
spell slice = 6774              # Slice and Dice
spell rupture = 48672
spell hunger = 51662            # Hunger for Blood
spell coldblood = 14177         # Cold Blood
spell envenom = 57993
spell vanish = 26889
aura overkill = 58427

action mutilate if stealthed -- Open from stealth with Mutilate: Overkill gives you +30% energy regen for 20 s.
action slice if combo_points >= 1 and buff.slice.down -- Slice and Dice first, even at 1-2 points: Envenom keeps it up afterwards (Cut to the Chase).
action rupture if combo_points >= 4 and debuff.rupture.down -- Rupture is the bleed Hunger for Blood needs (skip it if a warrior or hunter already bleeds the boss).
action hunger if debuff.rupture.up and buff.hunger.remains < 3 -- Hunger for Blood always up: +5% damage while the target bleeds.
action coldblood if combo_points >= 4 -- Cold Blood right before Envenom: guaranteed critical hit.
action envenom if combo_points >= 4 and (buff.envenom.down or energy >= 90) -- Envenom at 4-5 points when its buff runs out (or if you are about to cap energy).
action vanish if buff.overkill.down and energy <= 60 -- Vanish to reopen from stealth and get Overkill again.
action mutilate if combo_points < 4 -- Mutilate to build combo points (2-3 per hit).
action envenom if combo_points >= 5 -- At 5 points there is nothing left to build: Envenom.
action mutilate -- At 4 points with Envenom's buff still up, one more Mutilate.
]],
es = [[
id: tc-rogue-assassination
rotacion: Asesinato
clase: ROGUE
especializacion: Asesinato
arbol: 1
modo: pve
autor: Tactics Coach
version: 1
descripcion: Mutilar para generar, Envenenar con 4-5 puntos. Hacer picadillo y Ansia de sangre siempre activos, con Ruptura como sangrado que habilita Ansia de sangre.

hechizo mutilar = 48666
hechizo picadillo = 6774        # Slice and Dice
hechizo ruptura = 48672
hechizo ansia = 51662           # Hunger for Blood
hechizo sangrefria = 14177      # Cold Blood
hechizo envenenar = 57993
hechizo esfumarse = 26889       # Vanish
aura exceso = 58427             # Overkill

accion mutilar si sigilo -- Abre desde sigilo con Mutilar: Exceso de muerte (Overkill) da +30% de energía durante 20 s.
accion picadillo si puntos >= 1 y beneficio.picadillo.inactivo -- Hacer picadillo primero, aunque sea con 1-2 puntos: luego Envenenar lo renueva solo (Ir al grano).
accion ruptura si puntos >= 4 y perjuicio.ruptura.inactivo -- Ruptura es el sangrado que pide Ansia de sangre (sáltala si un guerrero o cazador ya hace sangrar al jefe).
accion ansia si perjuicio.ruptura.activo y beneficio.ansia.restante < 3 -- Ansia de sangre siempre activa: +5% de daño mientras el objetivo sangra.
accion sangrefria si puntos >= 4 -- Sangre fría justo antes de Envenenar: crítico asegurado.
accion envenenar si puntos >= 4 y (beneficio.envenenar.inactivo o energia >= 90) -- Envenenar con 4-5 puntos cuando se acabe su beneficio (o si vas a llenar la energía).
accion esfumarse si beneficio.exceso.inactivo y energia <= 60 -- Esfúmate para volver a abrir desde sigilo y recuperar Exceso de muerte.
accion mutilar si puntos < 4 -- Mutilar para generar puntos de combo (2-3 por golpe).
accion envenenar si puntos >= 5 -- Con 5 puntos ya no hay nada que generar: Envenenar.
accion mutilar -- Con 4 puntos y el beneficio de Envenenar aún activo, un Mutilar más.
]],
})

table.insert(ns.builtin, {
en = [[
id: tc-rogue-combat
rotation: Combat
class: ROGUE
spec: Combat
tree: 2
mode: pve
author: Tactics Coach
version: 1
description: Sinister Strike to build. Slice and Dice always up, 5-point Rupture and Eviscerate, and Killing Spree and Adrenaline Rush when you are low on energy.

spell slice = 6774              # Slice and Dice
spell flurry = 13877            # Blade Flurry
spell spree = 51690             # Killing Spree
spell adrenaline = 13750        # Adrenaline Rush
spell rupture = 48672
spell eviscerate = 48668
spell sinister = 48638          # Sinister Strike

action slice if combo_points >= 1 and buff.slice.down -- Slice and Dice first, even at 1-2 points: +40% attack speed feeds Combat Potency.
action slice if combo_points >= 2 and buff.slice.remains < 2 -- Refresh Slice and Dice before it falls off.
action flurry -- Blade Flurry on cooldown: +20% attack speed (and it cleaves if there are two targets).
action spree if energy < 40 and buff.adrenaline.down -- Killing Spree when you are low on energy, never during Adrenaline Rush: energy refills while you jump.
action adrenaline if energy < 40 and buff.spree.down -- Adrenaline Rush when energy is low so none of the doubled regen is wasted.
action rupture if combo_points >= 5 and debuff.rupture.down and buff.slice.remains > 6 -- At 5 points, Rupture if it is down and Slice and Dice is safe.
action eviscerate if combo_points >= 5 -- At 5 points with everything up, spend on Eviscerate.
action sinister -- Sinister Strike to build combo points.
]],
es = [[
id: tc-rogue-combat
rotacion: Combate
clase: ROGUE
especializacion: Combate
arbol: 2
modo: pve
autor: Tactics Coach
version: 1
descripcion: Golpe siniestro para generar. Hacer picadillo siempre activo, Ruptura y Eviscerar con 5 puntos, y Juerga de matanza y Subidón de adrenalina cuando te falte energía.

hechizo picadillo = 6774        # Slice and Dice
hechizo aluvion = 13877         # Blade Flurry
hechizo juerga = 51690          # Killing Spree
hechizo subidon = 13750         # Adrenaline Rush
hechizo ruptura = 48672
hechizo eviscerar = 48668
hechizo siniestro = 48638       # Sinister Strike

accion picadillo si puntos >= 1 y beneficio.picadillo.inactivo -- Hacer picadillo primero, aunque sea con 1-2 puntos: +40% de velocidad de ataque que alimenta Potencia de combate.
accion picadillo si puntos >= 2 y beneficio.picadillo.restante < 2 -- Renueva Hacer picadillo antes de que se caiga.
accion aluvion -- Aluvión de acero en cuanto esté listo: +20% de velocidad de ataque (y golpea a un segundo objetivo si lo hay).
accion juerga si energia < 40 y beneficio.subidon.inactivo -- Juerga de matanza con poca energía y nunca durante Subidón: la energía se recupera mientras saltas.
accion subidon si energia < 40 y beneficio.juerga.inactivo -- Subidón de adrenalina con poca energía para no desperdiciar la regeneración doble.
accion ruptura si puntos >= 5 y perjuicio.ruptura.inactivo y beneficio.picadillo.restante > 6 -- Con 5 puntos, Ruptura si no está y Hacer picadillo no corre peligro.
accion eviscerar si puntos >= 5 -- Con 5 puntos y todo activo, gasta en Eviscerar.
accion siniestro -- Golpe siniestro para generar puntos de combo.
]],
})

table.insert(ns.builtin, {
en = [[
id: tc-rogue-subtlety-pvp
rotation: Subtlety (PvP)
class: ROGUE
spec: Subtlety
tree: 3
mode: pvp
author: Tactics Coach
version: 1
description: Open from stealth with Premeditation and Cheap Shot, chain into Kidney Shot, and use Shadow Dance for a second stun and Ambushes. Kick every cast and keep the target crippled.

spell kick = 1766
spell cloak = 31224             # Cloak of Shadows
spell evasion = 26669
spell premeditation = 14183
spell cheap = 1833              # Cheap Shot
spell ambush = 48691
spell kidney = 8643             # Kidney Shot
spell rupture = 48672
spell eviscerate = 48668
spell dance = 51713             # Shadow Dance
spell shiv = 5938
spell hemorrhage = 48660
aura crippling = 3409           # Crippling Poison (debuff)

action kick if target.casting -- Kick every cast: a heal or a Polymorph stopped is worth more than any hit.
action cloak if health < 35 -- Cloak of Shadows when you are going down: removes harmful spells and resists magic for 5 s.
action evasion if health < 50 and target.player -- Evasion against melee pressure: dodge most physical hits for 15 s.
action premeditation if (stealthed or buff.dance.up) and combo_points <= 2 -- From stealth or Shadow Dance: 2 free combo points for the stun chain.
action cheap if (stealthed or buff.dance.up) and target.player and debuff.cheap.down -- Open with Cheap Shot: 4 s stun that also builds points.
action ambush if stealthed or buff.dance.up -- In stealth or Shadow Dance, Ambush is your burst (dagger, from behind).
action kidney if combo_points >= 4 and target.player and debuff.cheap.down -- When Cheap Shot ends, Kidney Shot to keep the stun chain going.
action rupture if combo_points >= 5 and debuff.rupture.down and target.health > 35 -- Rupture keeps pressure and stops druids and rogues from restealthing.
action eviscerate if combo_points >= 5 -- At 5 points, Eviscerate for burst (go for it when the target is low).
action dance if energy >= 60 and combo_points <= 2 -- Shadow Dance with pooled energy: Cheap Shot and Ambushes outside stealth.
action shiv if target.player and debuff.crippling.down -- Shiv to put Crippling Poison back on right away (off-hand poison): no kiting.
action hemorrhage -- Hemorrhage to build combo points.
]],
es = [[
id: tc-rogue-subtlety-pvp
rotacion: Sutileza (PvP)
clase: ROGUE
especializacion: Sutileza
arbol: 3
modo: pvp
autor: Tactics Coach
version: 1
descripcion: Abre desde sigilo con Premeditación y Golpe bajo, encadena con Golpe en los riñones y usa Danza de las Sombras para otro aturdimiento y más Emboscadas. Patada a cada lanzamiento y el objetivo siempre ralentizado.

hechizo patada = 1766           # Kick
hechizo capa = 31224            # Cloak of Shadows
hechizo evasion = 26669
hechizo premeditacion = 14183
hechizo golpebajo = 1833        # Cheap Shot
hechizo emboscada = 48691
hechizo rinones = 8643          # Kidney Shot
hechizo ruptura = 48672
hechizo eviscerar = 48668
hechizo danza = 51713           # Shadow Dance
hechizo shiv = 5938
hechizo hemorragia = 48660
aura entorpecedor = 3409        # Crippling Poison (perjuicio)

accion patada si objetivo.lanzando -- Patada a cada lanzamiento: una curación o una Polimorfia cortada vale más que cualquier golpe.
accion capa si vida < 35 -- Capa de las Sombras cuando te estás muriendo: quita los hechizos dañinos y resiste la magia 5 s.
accion evasion si vida < 50 y objetivo.jugador -- Evasión contra la presión cuerpo a cuerpo: esquivas casi todos los golpes físicos 15 s.
accion premeditacion si (sigilo o beneficio.danza.activo) y puntos <= 2 -- Desde sigilo o en Danza: 2 puntos de combo gratis para la cadena de aturdimientos.
accion golpebajo si (sigilo o beneficio.danza.activo) y objetivo.jugador y perjuicio.golpebajo.inactivo -- Abre con Golpe bajo: 4 s de aturdimiento que además genera puntos.
accion emboscada si sigilo o beneficio.danza.activo -- En sigilo o en Danza, Emboscada es tu golpe fuerte (daga, desde detrás).
accion rinones si puntos >= 4 y objetivo.jugador y perjuicio.golpebajo.inactivo -- Cuando acabe Golpe bajo, Golpe en los riñones para seguir la cadena de aturdimientos.
accion ruptura si puntos >= 5 y perjuicio.ruptura.inactivo y objetivo.vida > 35 -- Ruptura mantiene la presión e impide que druidas y pícaros vuelvan al sigilo.
accion eviscerar si puntos >= 5 -- Con 5 puntos, Eviscerar para el golpe fuerte (sobre todo si el objetivo está bajo).
accion danza si energia >= 60 y puntos <= 2 -- Danza de las Sombras con energía guardada: Golpe bajo y Emboscadas sin sigilo.
accion shiv si objetivo.jugador y perjuicio.entorpecedor.inactivo -- Shiv para volver a poner Veneno entorpecedor al instante (veneno de la mano izquierda): que no se escape.
accion hemorragia -- Hemorragia para generar puntos de combo.
]],
})

table.insert(ns.builtin, {
en = [[
id: tc-rogue-assassination-pvp
rotation: Assassination (PvP)
class: ROGUE
spec: Assassination
tree: 1
mode: pvp
author: Tactics Coach
version: 1
description: Mutilate burst: Cheap Shot from stealth, Mutilate to 4-5 points, Kidney Shot and Cold Blood Envenom inside the stun. Kick every cast and keep the target crippled.

spell kick = 1766
spell cloak = 31224             # Cloak of Shadows
spell evasion = 26669
spell cheap = 1833              # Cheap Shot
spell garrote = 48676
spell kidney = 8643             # Kidney Shot
spell hunger = 51662            # Hunger for Blood
spell coldblood = 14177         # Cold Blood
spell envenom = 57993
spell shiv = 5938
spell mutilate = 48666
aura crippling = 3409           # Crippling Poison (debuff)
aura rupture = 48672

action kick if target.casting -- Kick every cast: a heal or a Polymorph stopped is worth more than any hit.
action cloak if health < 35 -- Cloak of Shadows when you are going down: removes harmful spells and resists magic for 5 s.
action evasion if health < 50 and target.player -- Evasion against melee pressure: dodge most physical hits for 15 s.
action cheap if stealthed and target.player -- Open with Cheap Shot: 4 s stun to start the burst.
action garrote if stealthed -- Against non-players, Garrote from stealth: a bleed for Hunger for Blood.
action kidney if combo_points >= 4 and target.player and debuff.cheap.down -- When Cheap Shot ends, Kidney Shot: the burst lands inside the stun.
action hunger if (debuff.garrote.up or debuff.rupture.up) and buff.hunger.remains < 3 -- Hunger for Blood while your Garrote or Rupture bleeds: +5% damage for the kill window.
action coldblood if combo_points >= 4 -- Cold Blood right before Envenom: guaranteed critical hit.
action envenom if combo_points >= 4 -- Envenom at 4-5 points: big Deadly Poison hit and more poison procs.
action shiv if target.player and debuff.crippling.down -- Shiv to put Crippling Poison back on right away (off-hand poison): no kiting.
action mutilate -- Mutilate to build combo points (2-3 per hit).
]],
es = [[
id: tc-rogue-assassination-pvp
rotacion: Asesinato (PvP)
clase: ROGUE
especializacion: Asesinato
arbol: 1
modo: pvp
autor: Tactics Coach
version: 1
descripcion: Daño explosivo de Mutilar: Golpe bajo desde sigilo, Mutilar hasta 4-5 puntos, Golpe en los riñones y Envenenar con Sangre fría dentro del aturdimiento. Patada a cada lanzamiento y el objetivo siempre ralentizado.

hechizo patada = 1766           # Kick
hechizo capa = 31224            # Cloak of Shadows
hechizo evasion = 26669
hechizo golpebajo = 1833        # Cheap Shot
hechizo garrote = 48676
hechizo rinones = 8643          # Kidney Shot
hechizo ansia = 51662           # Hunger for Blood
hechizo sangrefria = 14177      # Cold Blood
hechizo envenenar = 57993
hechizo shiv = 5938
hechizo mutilar = 48666
aura entorpecedor = 3409        # Crippling Poison (perjuicio)
aura ruptura = 48672

accion patada si objetivo.lanzando -- Patada a cada lanzamiento: una curación o una Polimorfia cortada vale más que cualquier golpe.
accion capa si vida < 35 -- Capa de las Sombras cuando te estás muriendo: quita los hechizos dañinos y resiste la magia 5 s.
accion evasion si vida < 50 y objetivo.jugador -- Evasión contra la presión cuerpo a cuerpo: esquivas casi todos los golpes físicos 15 s.
accion golpebajo si sigilo y objetivo.jugador -- Abre con Golpe bajo: 4 s de aturdimiento para empezar el daño explosivo.
accion garrote si sigilo -- Contra lo que no es jugador, Garrote desde sigilo: un sangrado para Ansia de sangre.
accion rinones si puntos >= 4 y objetivo.jugador y perjuicio.golpebajo.inactivo -- Cuando acabe Golpe bajo, Golpe en los riñones: el daño fuerte entra durante el aturdimiento.
accion ansia si (perjuicio.garrote.activo o perjuicio.ruptura.activo) y beneficio.ansia.restante < 3 -- Ansia de sangre mientras sangre tu Garrote o tu Ruptura: +5% de daño para la ventana de muerte.
accion sangrefria si puntos >= 4 -- Sangre fría justo antes de Envenenar: crítico asegurado.
accion envenenar si puntos >= 4 -- Envenenar con 4-5 puntos: golpe grande de Veneno mortal y más activaciones de veneno.
accion shiv si objetivo.jugador y perjuicio.entorpecedor.inactivo -- Shiv para volver a poner Veneno entorpecedor al instante (veneno de la mano izquierda): que no se escape.
accion mutilar -- Mutilar para generar puntos de combo (2-3 por golpe).
]],
})

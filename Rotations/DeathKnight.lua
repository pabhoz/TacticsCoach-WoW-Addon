local _, ns = ...
ns = ns or TacticsCoachNS
ns.builtin = ns.builtin or {}

-- IDs verificados contra el Spell.dbc 3.3.5a del servidor (rango maximo de cada uno).
-- Las runas no se leen: un golpe sin runas se sugiere igual (hay que esperarlas), asi que el
-- orden de la lista es el que reparte las runas. Las enfermedades se leen como perjuicios.

-- Escarcha de doble empuñadura (ICC): Arrasar con Escarcha+Profano, Golpe de sangre con Sangre.
table.insert(ns.builtin, {
en = [[
id: tc-deathknight-frost
rotation: Frost
class: DEATHKNIGHT
spec: Frost
tree: 2
mode: pve
author: Tactics Coach
version: 1
description: Dual-wield Frost in Blood Presence. Keep both diseases up, Obliterate with Frost and Unholy runes, Blood Strike with Blood runes, and spend runic power on Frost Strike (first with Killing Machine).

spell icy = 49909               # Icy Touch
spell plague = 49921            # Plague Strike
spell armor = 51271             # Unbreakable Armor
spell tap = 45529               # Blood Tap
spell horn = 57623              # Horn of Winter
spell fstrike = 55268           # Frost Strike
spell obliterate = 51425
spell pestilence = 50842
spell bstrike = 49930           # Blood Strike
spell howling = 51411           # Howling Blast
spell erw = 47568               # Empower Rune Weapon
aura ff = 55095                 # Frost Fever
aura bp = 55078                 # Blood Plague
aura km = 51124                 # Killing Machine (proc)
aura rime = 59052               # Freezing Fog (Rime proc)

action icy if debuff.ff.down -- Frost Fever first: Obliterate hits harder for each disease on the target.
action plague if debuff.bp.down -- Blood Plague, the second disease: never strike without both.
action armor -- Unbreakable Armor on cooldown: more Strength and armor for 20 seconds.
action tap if buff.armor.up -- Blood Tap right after Unbreakable Armor: the rune comes back as a Death rune for one more Obliterate.
action horn if buff.horn.down -- Horn of Winter always up: Strength and Agility for you and the raid.
action fstrike if runic_power >= 100 -- Almost capped on runic power: spend it now so none is wasted.
action obliterate -- Obliterate with every Frost+Unholy pair: your biggest hit.
action pestilence if debuff.ff.remains < 5 or debuff.bp.remains < 5 -- With Glyph of Disease, Pestilence refreshes both diseases with a Blood rune.
action bstrike -- Blood Strike with your Blood runes, always both together: they turn into Death runes for more Obliterates.
action fstrike if buff.km.up -- Killing Machine up: Frost Strike is a guaranteed crit.
action howling if buff.rime.up -- Rime: Howling Blast is free, don't waste it.
action fstrike -- Frost Strike to spend runic power while runes recharge.
action horn -- Horn of Winter as filler: 10 runic power and no runes.
action erw -- Empower Rune Weapon when everything is on cooldown: refreshes all your runes.
]],
es = [[
id: tc-deathknight-frost
rotacion: Escarcha
clase: DEATHKNIGHT
especializacion: Escarcha
arbol: 2
modo: pve
autor: Tactics Coach
version: 1
descripcion: Escarcha de doble empuñadura en Presencia de sangre. Mantén las dos enfermedades, Arrasar con runas de Escarcha y Profanas, Golpe de sangre con las de Sangre, y gasta poder rúnico en Golpe de Escarcha (antes con Máquina de matar).

hechizo toque = 49909           # Icy Touch
hechizo peste = 49921           # Plague Strike
hechizo armadura = 51271        # Unbreakable Armor
hechizo aprovechar = 45529      # Blood Tap
hechizo cuerno = 57623          # Horn of Winter
hechizo gescarcha = 55268       # Frost Strike
hechizo arrasar = 51425         # Obliterate
hechizo pestilencia = 50842     # Pestilence
hechizo gsangre = 49930         # Blood Strike
hechizo aullante = 51411        # Howling Blast
hechizo potenciar = 47568       # Empower Rune Weapon
aura fiebre = 55095             # Frost Fever
aura pestesangre = 55078        # Blood Plague
aura maquina = 51124            # Killing Machine
aura cencellada = 59052         # Freezing Fog (Rime)

accion toque si perjuicio.fiebre.inactivo -- Fiebre de escarcha primero: Arrasar pega más por cada enfermedad en el objetivo.
accion peste si perjuicio.pestesangre.inactivo -- Peste de sangre, la segunda enfermedad: nunca golpees sin las dos.
accion armadura -- Armadura inquebrantable en cuanto esté lista: más Fuerza y armadura durante 20 segundos.
accion aprovechar si beneficio.armadura.activo -- Aprovechar sangre justo después de la Armadura: la runa vuelve como runa de Muerte para otro Arrasar.
accion cuerno si beneficio.cuerno.inactivo -- Cuerno de invierno siempre activo: Fuerza y Agilidad para ti y la banda.
accion gescarcha si poder_runico >= 100 -- Casi al tope de poder rúnico: gástalo ya para no desperdiciarlo.
accion arrasar -- Arrasar con cada par de Escarcha y Profana: tu golpe más fuerte.
accion pestilencia si perjuicio.fiebre.restante < 5 o perjuicio.pestesangre.restante < 5 -- Con el Glifo de enfermedad, Pestilencia renueva las dos enfermedades con una runa de Sangre.
accion gsangre -- Golpe de sangre con las runas de Sangre, siempre las dos juntas: se vuelven runas de Muerte para más Arrasar.
accion gescarcha si beneficio.maquina.activo -- Con Máquina de matar, Golpe de Escarcha es crítico seguro.
accion aullante si beneficio.cencellada.activo -- Cencellada: Explosión aullante gratis, no la desperdicies.
accion gescarcha -- Golpe de Escarcha para gastar poder rúnico mientras se recargan las runas.
accion cuerno -- Cuerno de invierno de relleno: 10 de poder rúnico sin gastar runas.
accion potenciar -- Potenciar arma de runas cuando todo esté en reutilización: recarga todas tus runas.
]],
})

-- Profano (ICC): Golpe de la Plaga con Escarcha+Profano, Golpe de sangre con Sangre, gárgola.
table.insert(ns.builtin, {
en = [[
id: tc-deathknight-unholy
rotation: Unholy
class: DEATHKNIGHT
spec: Unholy
tree: 3
mode: pve
author: Tactics Coach
version: 1
description: Keep both diseases up, Scourge Strike with Frost and Unholy runes, Blood Strike with Blood runes and Death Coil to spend runic power. Gargoyle on cooldown. Death and Decay on 2 or more targets.

spell raise = 46584             # Raise Dead
spell bone = 49222              # Bone Shield
spell icy = 49909               # Icy Touch
spell plague = 49921            # Plague Strike
spell horn = 57623              # Horn of Winter
spell gargoyle = 49206          # Summon Gargoyle
spell coil = 49895              # Death Coil
spell scourge = 55271           # Scourge Strike
spell bstrike = 49930           # Blood Strike
spell erw = 47568               # Empower Rune Weapon
aura ff = 55095                 # Frost Fever
aura bp = 55078                 # Blood Plague
aura desolation = 66803         # Desolation (buff from Blood Strike)

action raise if not pet -- Raise your ghoul: with Master of Ghouls it stays for good.
action bone if buff.bone.down -- Bone Shield up: less damage taken and 2% more damage dealt.
action icy if debuff.ff.down -- Frost Fever: Scourge Strike gains damage for each disease.
action plague if debuff.bp.down -- Blood Plague, the second disease: never strike without both.
action horn if buff.horn.down -- Horn of Winter always up: Strength and Agility for you and the raid.
action gargoyle if runic_power >= 60 -- Summon Gargoyle on cooldown: your biggest burst, it needs 60 runic power.
action coil if runic_power >= 100 -- Almost capped on runic power: Death Coil now so none is wasted.
action scourge -- Scourge Strike with every Frost+Unholy pair: your main damage.
action bstrike if buff.desolation.down -- Blood Strike to keep Desolation up: +5% damage.
action bstrike -- Blood Strike with your Blood runes: they turn into Death runes with Reaping.
action coil -- Death Coil to spend runic power while runes recharge.
action horn -- Horn of Winter as filler: 10 runic power and no runes.
action erw -- Empower Rune Weapon when everything is on cooldown: refreshes all your runes.
]],
es = [[
id: tc-deathknight-unholy
rotacion: Profano
clase: DEATHKNIGHT
especializacion: Profano
arbol: 3
modo: pve
autor: Tactics Coach
version: 1
descripcion: Mantén las dos enfermedades, Golpe de la Plaga con runas de Escarcha y Profanas, Golpe de sangre con las de Sangre y Espiral de la muerte para gastar poder rúnico. Gárgola en cuanto esté lista. Muerte y descomposición con 2 o más objetivos.

hechizo resucitar = 46584       # Raise Dead
hechizo huesos = 49222          # Bone Shield
hechizo toque = 49909           # Icy Touch
hechizo peste = 49921           # Plague Strike
hechizo cuerno = 57623          # Horn of Winter
hechizo gargola = 49206         # Summon Gargoyle
hechizo espiral = 49895         # Death Coil
hechizo plaga = 55271           # Scourge Strike
hechizo gsangre = 49930         # Blood Strike
hechizo potenciar = 47568       # Empower Rune Weapon
aura fiebre = 55095             # Frost Fever
aura pestesangre = 55078        # Blood Plague
aura desolacion = 66803         # Desolation

accion resucitar si no mascota -- Levanta a tu necrófago: con Señor de los necrófagos se queda para siempre.
accion huesos si beneficio.huesos.inactivo -- Escudo de huesos activo: menos daño recibido y 2% más de daño.
accion toque si perjuicio.fiebre.inactivo -- Fiebre de escarcha: Golpe de la Plaga pega más por cada enfermedad.
accion peste si perjuicio.pestesangre.inactivo -- Peste de sangre, la segunda enfermedad: nunca golpees sin las dos.
accion cuerno si beneficio.cuerno.inactivo -- Cuerno de invierno siempre activo: Fuerza y Agilidad para ti y la banda.
accion gargola si poder_runico >= 60 -- Invocar gárgola en cuanto esté lista: tu mayor ráfaga, pide 60 de poder rúnico.
accion espiral si poder_runico >= 100 -- Casi al tope de poder rúnico: Espiral de la muerte ya para no desperdiciarlo.
accion plaga -- Golpe de la Plaga con cada par de Escarcha y Profana: tu daño principal.
accion gsangre si beneficio.desolacion.inactivo -- Golpe de sangre para mantener Desolación: +5% de daño.
accion gsangre -- Golpe de sangre con las runas de Sangre: con Cosecha se vuelven runas de Muerte.
accion espiral -- Espiral de la muerte para gastar poder rúnico mientras se recargan las runas.
accion cuerno -- Cuerno de invierno de relleno: 10 de poder rúnico sin gastar runas.
accion potenciar -- Potenciar arma de runas cuando todo esté en reutilización: recarga todas tus runas.
]],
})

-- Sangre tanque (ICC): el tanque caballero de la muerte más común en 3.3.5.
table.insert(ns.builtin, {
en = [[
id: tc-deathknight-blood-tank
rotation: Blood Tank
class: DEATHKNIGHT
spec: Blood Tank
tree: 1
mode: pve
author: Tactics Coach
version: 1
description: Tank in Frost Presence. Rune Strike whenever you dodge or parry, keep both diseases up, Death Strike to heal, Heart Strike for threat, and your cooldowns when health drops.

spell rstrike = 56815           # Rune Strike
spell vampiric = 55233          # Vampiric Blood
spell ibf = 48792               # Icebound Fortitude
spell runetap = 48982           # Rune Tap
spell icy = 49909               # Icy Touch
spell plague = 49921            # Plague Strike
spell drw = 49028               # Dancing Rune Weapon
spell horn = 57623              # Horn of Winter
spell dstrike = 49924           # Death Strike
spell heart = 55262             # Heart Strike
spell coil = 49895              # Death Coil
aura ff = 55095                 # Frost Fever
aura bp = 55078                 # Blood Plague

action rstrike if runic_power >= 20 -- Rune Strike after every dodge or parry: lots of threat and no global cooldown.
action ibf if health < 35 -- Very low health: Icebound Fortitude cuts the damage you take.
action vampiric if health < 50 -- Vampiric Blood: more max health and more healing received.
action runetap if health < 60 -- Rune Tap: an instant heal for one Blood rune.
action icy if debuff.ff.down -- Frost Fever: big threat and slows the target's attacks.
action plague if debuff.bp.down -- Blood Plague: your strikes heal and hit harder with both diseases.
action drw if runic_power >= 60 -- Dancing Rune Weapon: more parry and copies your strikes for threat.
action horn if buff.horn.down -- Horn of Winter always up: Strength and Agility.
action dstrike -- Death Strike with Frost+Unholy: heals you for each disease on the target.
action heart -- Heart Strike with Blood runes: your main threat, hits two targets.
action coil if runic_power >= 80 -- Death Coil only with plenty of runic power: save some for Rune Strike.
action horn -- Horn of Winter as filler: 10 runic power and no runes.
]],
es = [[
id: tc-deathknight-blood-tank
rotacion: Sangre tanque
clase: DEATHKNIGHT
especializacion: Sangre tanque
arbol: 1
modo: pve
autor: Tactics Coach
version: 1
descripcion: Tanquea en Presencia de Escarcha. Golpe de runa cada vez que esquives o pares, mantén las dos enfermedades, Golpe letal para curarte, Golpe en el corazón para la amenaza y tus defensivos cuando baje la vida.

hechizo grunico = 56815         # Rune Strike
hechizo vampirica = 55233       # Vampiric Blood
hechizo entereza = 48792        # Icebound Fortitude
hechizo transfusion = 48982     # Rune Tap
hechizo toque = 49909           # Icy Touch
hechizo peste = 49921           # Plague Strike
hechizo arma = 49028            # Dancing Rune Weapon
hechizo cuerno = 57623          # Horn of Winter
hechizo letal = 49924           # Death Strike
hechizo corazon = 55262         # Heart Strike
hechizo espiral = 49895         # Death Coil
aura fiebre = 55095             # Frost Fever
aura pestesangre = 55078        # Blood Plague

accion grunico si poder_runico >= 20 -- Golpe de runa tras cada esquiva o parada: mucha amenaza y sin tiempo global.
accion entereza si vida < 35 -- Vida muy baja: Entereza ligada al hielo reduce el daño que recibes.
accion vampirica si vida < 50 -- Sangre vampírica: más vida máxima y más sanación recibida.
accion transfusion si vida < 60 -- Transfusión rúnica: una curación instantánea por una runa de Sangre.
accion toque si perjuicio.fiebre.inactivo -- Fiebre de escarcha: mucha amenaza y ralentiza los ataques del objetivo.
accion peste si perjuicio.pestesangre.inactivo -- Peste de sangre: tus golpes curan y pegan más con las dos enfermedades.
accion arma si poder_runico >= 60 -- Arma de runas danzante: más parada y copia tus golpes para la amenaza.
accion cuerno si beneficio.cuerno.inactivo -- Cuerno de invierno siempre activo: Fuerza y Agilidad.
accion letal -- Golpe letal con Escarcha y Profana: te cura por cada enfermedad en el objetivo.
accion corazon -- Golpe en el corazón con runas de Sangre: tu amenaza principal, golpea a dos objetivos.
accion espiral si poder_runico >= 80 -- Espiral de la muerte solo con poder rúnico de sobra: guarda para Golpe de runa.
accion cuerno -- Cuerno de invierno de relleno: 10 de poder rúnico sin gastar runas.
]],
})

-- Profano JcJ (temporada 8): el caballero de la muerte de arenas en 3.3.5.
table.insert(ns.builtin, {
en = [[
id: tc-deathknight-unholy-pvp
rotation: Unholy (PvP)
class: DEATHKNIGHT
spec: Unholy
tree: 3
mode: pvp
author: Tactics Coach
version: 1
description: Arena Unholy in Unholy Presence. Interrupt with Mind Freeze and Strangulate, keep Bone Shield and the target slowed, diseases always up, Gargoyle for burst and Death Strike when you need healing.

spell freeze = 47528            # Mind Freeze
spell strangulate = 47476
spell ams = 48707               # Anti-Magic Shell
spell ibf = 48792               # Icebound Fortitude
spell pact = 48743              # Death Pact
spell raise = 46584             # Raise Dead
spell bone = 49222              # Bone Shield
spell chains = 45524            # Chains of Ice
spell icy = 49909               # Icy Touch
spell plague = 49921            # Plague Strike
spell gargoyle = 49206          # Summon Gargoyle
spell dstrike = 49924           # Death Strike
spell coil = 49895              # Death Coil
spell scourge = 55271           # Scourge Strike
spell bstrike = 49930           # Blood Strike
spell horn = 57623              # Horn of Winter
aura ff = 55095                 # Frost Fever
aura bp = 55078                 # Blood Plague

action freeze if target.casting -- Mind Freeze: interrupt the cast and lock that school.
action strangulate if target.casting and not cooldown.freeze.ready -- Mind Freeze on cooldown: Strangulate silences the caster.
action ams if target.casting -- A spell you couldn't interrupt: Anti-Magic Shell absorbs it and gives you runic power.
action ibf if health < 40 -- Low health: Icebound Fortitude cuts damage and makes you immune to stuns.
action pact if health < 25 and pet -- Very low health: sacrifice your ghoul with Death Pact for a big heal.
action bone if buff.bone.down -- Bone Shield up: absorbs hits and adds damage.
action raise if not pet -- Raise your ghoul: extra damage and Gnaw to stun.
action chains if target.player and debuff.chains.down -- Chains of Ice keeps the target slowed so it can't kite you.
action icy if debuff.ff.down -- Frost Fever: slows their attacks and powers Scourge Strike.
action plague if debuff.bp.down -- Blood Plague, the second disease: Scourge Strike and Death Strike need both.
action gargoyle if runic_power >= 60 -- Summon Gargoyle for burst, better with the healer under pressure or crowd controlled.
action dstrike if health < 50 -- Below half health: Death Strike heals you for each disease on the target.
action coil if runic_power >= 100 -- Almost capped on runic power: Death Coil now so none is wasted.
action scourge -- Scourge Strike with every Frost+Unholy pair: your main damage.
action bstrike -- Blood Strike with your Blood runes.
action coil -- Death Coil to spend runic power: damage at range.
action horn -- Horn of Winter as filler: 10 runic power and no runes.
]],
es = [[
id: tc-deathknight-unholy-pvp
rotacion: Profano (PvP)
clase: DEATHKNIGHT
especializacion: Profano
arbol: 3
modo: pvp
autor: Tactics Coach
version: 1
descripcion: Profano de arenas en Presencia profana. Interrumpe con Helada mental y Estrangular, mantén Escudo de huesos y al objetivo ralentizado, enfermedades siempre puestas, Gárgola para la ráfaga y Golpe letal cuando necesites curarte.

hechizo helada = 47528          # Mind Freeze
hechizo estrangular = 47476     # Strangulate
hechizo antimagia = 48707       # Anti-Magic Shell
hechizo entereza = 48792        # Icebound Fortitude
hechizo pacto = 48743           # Death Pact
hechizo resucitar = 46584       # Raise Dead
hechizo huesos = 49222          # Bone Shield
hechizo cadenas = 45524         # Chains of Ice
hechizo toque = 49909           # Icy Touch
hechizo peste = 49921           # Plague Strike
hechizo gargola = 49206         # Summon Gargoyle
hechizo letal = 49924           # Death Strike
hechizo espiral = 49895         # Death Coil
hechizo plaga = 55271           # Scourge Strike
hechizo gsangre = 49930         # Blood Strike
hechizo cuerno = 57623          # Horn of Winter
aura fiebre = 55095             # Frost Fever
aura pestesangre = 55078        # Blood Plague

accion helada si objetivo.lanzando -- Helada mental: interrumpe el hechizo y bloquea esa escuela.
accion estrangular si objetivo.lanzando y no reutilizacion.helada.listo -- Helada mental en reutilización: Estrangular silencia al lanzador.
accion antimagia si objetivo.lanzando -- Un hechizo que no pudiste cortar: Caparazón antimagia lo absorbe y te da poder rúnico.
accion entereza si vida < 40 -- Vida baja: Entereza ligada al hielo reduce el daño y te hace inmune a aturdimientos.
accion pacto si vida < 25 y mascota -- Vida muy baja: sacrifica a tu necrófago con Pacto de la muerte para una gran curación.
accion huesos si beneficio.huesos.inactivo -- Escudo de huesos activo: absorbe golpes y suma daño.
accion resucitar si no mascota -- Levanta a tu necrófago: más daño y Roer para aturdir.
accion cadenas si objetivo.jugador y perjuicio.cadenas.inactivo -- Cadenas de hielo mantiene al objetivo ralentizado para que no se escape.
accion toque si perjuicio.fiebre.inactivo -- Fiebre de escarcha: ralentiza sus ataques y potencia Golpe de la Plaga.
accion peste si perjuicio.pestesangre.inactivo -- Peste de sangre, la segunda enfermedad: Golpe de la Plaga y Golpe letal necesitan las dos.
accion gargola si poder_runico >= 60 -- Invocar gárgola para la ráfaga, mejor con el sanador presionado o controlado.
accion letal si vida < 50 -- Por debajo de la mitad de vida: Golpe letal te cura por cada enfermedad en el objetivo.
accion espiral si poder_runico >= 100 -- Casi al tope de poder rúnico: Espiral de la muerte ya para no desperdiciarlo.
accion plaga -- Golpe de la Plaga con cada par de Escarcha y Profana: tu daño principal.
accion gsangre -- Golpe de sangre con las runas de Sangre.
accion espiral -- Espiral de la muerte para gastar poder rúnico: daño a distancia.
accion cuerno -- Cuerno de invierno de relleno: 10 de poder rúnico sin gastar runas.
]],
})

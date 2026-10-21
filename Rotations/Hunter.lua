local _, ns = ...
ns = ns or TacticsCoachNS
ns.builtin = ns.builtin or {}

-- IDs verificados contra el Spell.dbc 3.3.5a del servidor (rango maximo de cada uno).
-- Las habilidades de la mascota no se pueden sugerir; Disparo automatico va solo.
-- Disparo mortal (Kill Shot) se salta solo por encima del 20% de vida del objetivo.

-- Punteria (PvE): Kill Shot > Serpent Sting > Chimera Shot > Aimed/Arcane > Steady (guias 3.3.5/ICC).
table.insert(ns.builtin, {
en = [[
id: tc-hunter-mm
rotation: Marksmanship
class: HUNTER
spec: Marksmanship
tree: 2
mode: pve
author: Tactics Coach
version: 1
description: Keep Serpent Sting up and fire Chimera Shot whenever it is ready (it refreshes the sting). Aimed Shot next, Steady Shot as filler, Kill Shot below 20%.

spell callpet = 883             # Call Pet
spell viper = 34074             # Aspect of the Viper
spell dragonhawk = 61847        # Aspect of the Dragonhawk
spell mark = 53338              # Hunter's Mark
spell rapid = 3045              # Rapid Fire
spell readiness = 23989
spell killshot = 61006          # Kill Shot
spell serpent = 49001           # Serpent Sting
spell chimera = 53209           # Chimera Shot
spell aimed = 49050             # Aimed Shot
spell arcane = 49045            # Arcane Shot
spell silencing = 34490         # Silencing Shot
spell steady = 49052            # Steady Shot

action callpet if not pet -- Call your pet (if it died, use Revive Pet): it is a good part of your damage.
action viper if mana < 10 and buff.viper.down -- Out of mana: Aspect of the Viper to recover it while you shoot.
action dragonhawk if buff.dragonhawk.down and (buff.viper.down or mana > 40) -- Aspect of the Dragonhawk: attack power and haste; go back to it once you have mana.
action mark if debuff.mark.down -- Hunter's Mark on the target: extra ranged attack power for the whole raid.
action rapid if buff.rapid.down -- Rapid Fire: +40% ranged haste, use it on cooldown.
action readiness if cooldown.rapid.remains > 60 and buff.rapid.down -- Readiness after Rapid Fire ends: resets it and Chimera Shot for a second burst.
action killshot -- Below 20% health, Kill Shot is your strongest shot.
action serpent if debuff.serpent.down -- Serpent Sting once: Chimera Shot refreshes it and turns it into extra damage.
action chimera -- Chimera Shot whenever it is ready: big hit that refreshes Serpent Sting.
action aimed -- Aimed Shot when it is ready: instant and hits hard (shares cooldown with Multi-Shot).
action arcane -- Arcane Shot if Aimed Shot is on cooldown: instant damage (better with low armor penetration).
action silencing -- Silencing Shot does not use the global cooldown: weave it in for free damage.
action steady -- Steady Shot as filler between your other shots.
]],
es = [[
id: tc-hunter-mm
rotacion: Puntería
clase: HUNTER
especializacion: Puntería
arbol: 2
modo: pve
autor: Tactics Coach
version: 1
descripcion: Mantén Picadura de serpiente y lanza Disparo de quimera en cuanto esté listo (renueva la picadura). Luego Disparo apuntado, Disparo firme de relleno y Disparo mortal por debajo del 20%.

hechizo llamar = 883            # Call Pet
hechizo vibora = 34074          # Aspect of the Viper
hechizo dracohalcon = 61847     # Aspect of the Dragonhawk
hechizo marca = 53338           # Hunter's Mark
hechizo rapido = 3045           # Rapid Fire
hechizo presteza = 23989        # Readiness
hechizo mortal = 61006          # Kill Shot
hechizo serpiente = 49001       # Serpent Sting
hechizo quimera = 53209         # Chimera Shot
hechizo apuntado = 49050        # Aimed Shot
hechizo arcano = 49045          # Arcane Shot
hechizo silenciador = 34490     # Silencing Shot
hechizo firme = 49052           # Steady Shot

accion llamar si no mascota -- Llama a tu mascota (si murió, usa Revivir mascota): es buena parte de tu daño.
accion vibora si mana < 10 y beneficio.vibora.inactivo -- Sin maná: Aspecto de la víbora para recuperarlo mientras disparas.
accion dracohalcon si beneficio.dracohalcon.inactivo y (beneficio.vibora.inactivo o mana > 40) -- Aspecto del dracohalcón: poder de ataque y celeridad; vuelve a él cuando tengas maná.
accion marca si perjuicio.marca.inactivo -- Marca del cazador sobre el objetivo: más poder de ataque a distancia para toda la banda.
accion rapido si beneficio.rapido.inactivo -- Fuego rápido: +40% de celeridad a distancia, úsalo en cuanto esté listo.
accion presteza si reutilizacion.rapido.restante > 60 y beneficio.rapido.inactivo -- Presteza cuando acabe Fuego rápido: lo reinicia junto a Disparo de quimera para otra ráfaga.
accion mortal -- Por debajo del 20% de vida, Disparo mortal es tu disparo más fuerte.
accion serpiente si perjuicio.serpiente.inactivo -- Picadura de serpiente una vez: Disparo de quimera la renueva y la convierte en daño extra.
accion quimera -- Disparo de quimera en cuanto esté listo: golpe fuerte que renueva la Picadura de serpiente.
accion apuntado -- Disparo apuntado cuando esté listo: instantáneo y pega fuerte (comparte reutilización con Disparo múltiple).
accion arcano -- Disparo arcano si Disparo apuntado está en reutilización: daño instantáneo (mejor con poca penetración de armadura).
accion silenciador -- Disparo silenciador no usa el tiempo global: mételo entre disparos para daño gratis.
accion firme -- Disparo firme de relleno entre tus otros disparos.
]],
})

-- Supervivencia (PvE): Kill Shot > Explosive Shot > Black Arrow > Serpent Sting > Aimed > Steady (Warmane 3.3.5 SV PvE).
table.insert(ns.builtin, {
en = [[
id: tc-hunter-sv
rotation: Survival
class: HUNTER
spec: Survival
tree: 3
mode: pve
author: Tactics Coach
version: 1
description: Explosive Shot every time it is ready (and twice with Lock and Load), Black Arrow and Serpent Sting always up, Aimed Shot and Steady Shot in between.

spell callpet = 883             # Call Pet
spell viper = 34074             # Aspect of the Viper
spell dragonhawk = 61847        # Aspect of the Dragonhawk
spell mark = 53338              # Hunter's Mark
spell rapid = 3045              # Rapid Fire
spell killshot = 61006          # Kill Shot
spell explosive = 60053         # Explosive Shot
spell black = 63672             # Black Arrow
spell serpent = 49001           # Serpent Sting
spell aimed = 49050             # Aimed Shot
spell steady = 49052            # Steady Shot
aura lockload = 56453           # Lock and Load (proc)

action callpet if not pet -- Call your pet (if it died, use Revive Pet): it is a good part of your damage.
action viper if mana < 10 and buff.viper.down -- Out of mana: Aspect of the Viper to recover it while you shoot.
action dragonhawk if buff.dragonhawk.down and (buff.viper.down or mana > 40) -- Aspect of the Dragonhawk: attack power and haste; go back to it once you have mana.
action mark if debuff.mark.down -- Hunter's Mark on the target: extra ranged attack power for the whole raid.
action rapid if buff.rapid.down -- Rapid Fire: +40% ranged haste, use it on cooldown.
action killshot -- Below 20% health, Kill Shot comes even before Explosive Shot.
action explosive if buff.lockload.up and debuff.explosive.down -- Lock and Load: Explosive Shot with no cooldown; let the previous one finish ticking first.
action explosive if debuff.explosive.down -- Explosive Shot every time it is ready: your main source of damage.
action black if debuff.black.down -- Black Arrow on cooldown: +6% damage on the target and chances of Lock and Load.
action serpent if debuff.serpent.down -- Keep Serpent Sting up: its ticks also trigger Lock and Load.
action aimed -- Aimed Shot when it is ready: instant damage between Explosive Shots.
action steady -- Steady Shot as filler while Explosive Shot is on cooldown.
]],
es = [[
id: tc-hunter-sv
rotacion: Supervivencia
clase: HUNTER
especializacion: Supervivencia
arbol: 3
modo: pve
autor: Tactics Coach
version: 1
descripcion: Disparo explosivo cada vez que esté listo (y dos veces con Cargado y listo), Flecha negra y Picadura de serpiente siempre puestas, Disparo apuntado y Disparo firme entre medias.

hechizo llamar = 883            # Call Pet
hechizo vibora = 34074          # Aspect of the Viper
hechizo dracohalcon = 61847     # Aspect of the Dragonhawk
hechizo marca = 53338           # Hunter's Mark
hechizo rapido = 3045           # Rapid Fire
hechizo mortal = 61006          # Kill Shot
hechizo explosivo = 60053       # Explosive Shot
hechizo flecha = 63672          # Black Arrow
hechizo serpiente = 49001       # Serpent Sting
hechizo apuntado = 49050        # Aimed Shot
hechizo firme = 49052           # Steady Shot
aura cargado = 56453            # Lock and Load (proc)

accion llamar si no mascota -- Llama a tu mascota (si murió, usa Revivir mascota): es buena parte de tu daño.
accion vibora si mana < 10 y beneficio.vibora.inactivo -- Sin maná: Aspecto de la víbora para recuperarlo mientras disparas.
accion dracohalcon si beneficio.dracohalcon.inactivo y (beneficio.vibora.inactivo o mana > 40) -- Aspecto del dracohalcón: poder de ataque y celeridad; vuelve a él cuando tengas maná.
accion marca si perjuicio.marca.inactivo -- Marca del cazador sobre el objetivo: más poder de ataque a distancia para toda la banda.
accion rapido si beneficio.rapido.inactivo -- Fuego rápido: +40% de celeridad a distancia, úsalo en cuanto esté listo.
accion mortal -- Por debajo del 20% de vida, Disparo mortal va incluso antes que Disparo explosivo.
accion explosivo si beneficio.cargado.activo y perjuicio.explosivo.inactivo -- Cargado y listo: Disparo explosivo sin reutilización; deja que el anterior termine de hacer daño.
accion explosivo si perjuicio.explosivo.inactivo -- Disparo explosivo cada vez que esté listo: tu principal fuente de daño.
accion flecha si perjuicio.flecha.inactivo -- Flecha negra en cuanto esté lista: +6% de daño sobre el objetivo y opciones de Cargado y listo.
accion serpiente si perjuicio.serpiente.inactivo -- Mantén Picadura de serpiente: su daño periódico también activa Cargado y listo.
accion apuntado -- Disparo apuntado cuando esté listo: daño instantáneo entre Disparos explosivos.
accion firme -- Disparo firme de relleno mientras Disparo explosivo está en reutilización.
]],
})

-- Bestias (PvE): Bestial Wrath + Kill Command en reutilizacion, Kill Shot, Serpent Sting, Aimed/Arcane, Steady.
table.insert(ns.builtin, {
en = [[
id: tc-hunter-bm
rotation: Beast Mastery
class: HUNTER
spec: Beast Mastery
tree: 1
mode: pve
author: Tactics Coach
version: 1
description: Your pet does much of the damage: Bestial Wrath and Kill Command on cooldown, Serpent Sting up, Aimed and Arcane Shot when ready and Steady Shot as filler.

spell callpet = 883             # Call Pet
spell viper = 34074             # Aspect of the Viper
spell dragonhawk = 61847        # Aspect of the Dragonhawk
spell mark = 53338              # Hunter's Mark
spell rapid = 3045              # Rapid Fire
spell wrath = 19574             # Bestial Wrath
spell command = 34026           # Kill Command
spell killshot = 61006          # Kill Shot
spell serpent = 49001           # Serpent Sting
spell aimed = 49050             # Aimed Shot
spell arcane = 49045            # Arcane Shot
spell steady = 49052            # Steady Shot

action callpet if not pet -- Call your pet (if it died, use Revive Pet): as Beast Mastery it is half your damage.
action viper if mana < 10 and buff.viper.down -- Out of mana: Aspect of the Viper to recover it while you shoot.
action dragonhawk if buff.dragonhawk.down and (buff.viper.down or mana > 40) -- Aspect of the Dragonhawk: attack power and haste; go back to it once you have mana.
action mark if debuff.mark.down -- Hunter's Mark on the target: extra ranged attack power for the whole raid.
action rapid if buff.rapid.down -- Rapid Fire: +40% ranged haste, line it up with Bestial Wrath.
action wrath if pet -- Bestial Wrath: +50% pet damage (and +10% yours with The Beast Within).
action command if pet -- Kill Command on cooldown: your pet's next special attacks hit harder.
action killshot -- Below 20% health, Kill Shot is your strongest shot.
action serpent if debuff.serpent.down -- Keep Serpent Sting up: cheap damage over time.
action aimed -- Aimed Shot when it is ready (if you took it): instant damage.
action arcane -- Arcane Shot when it is ready: instant damage.
action steady -- Steady Shot as filler between your other shots.
]],
es = [[
id: tc-hunter-bm
rotacion: Bestias
clase: HUNTER
especializacion: Bestias
arbol: 1
modo: pve
autor: Tactics Coach
version: 1
descripcion: Tu mascota hace buena parte del daño: Cólera de las bestias y Matar en cuanto estén listos, Picadura de serpiente puesta, Disparo apuntado y arcano cuando estén listos y Disparo firme de relleno.

hechizo llamar = 883            # Call Pet
hechizo vibora = 34074          # Aspect of the Viper
hechizo dracohalcon = 61847     # Aspect of the Dragonhawk
hechizo marca = 53338           # Hunter's Mark
hechizo rapido = 3045           # Rapid Fire
hechizo colera = 19574          # Bestial Wrath
hechizo matar = 34026           # Kill Command
hechizo mortal = 61006          # Kill Shot
hechizo serpiente = 49001       # Serpent Sting
hechizo apuntado = 49050        # Aimed Shot
hechizo arcano = 49045          # Arcane Shot
hechizo firme = 49052           # Steady Shot

accion llamar si no mascota -- Llama a tu mascota (si murió, usa Revivir mascota): en Bestias es la mitad de tu daño.
accion vibora si mana < 10 y beneficio.vibora.inactivo -- Sin maná: Aspecto de la víbora para recuperarlo mientras disparas.
accion dracohalcon si beneficio.dracohalcon.inactivo y (beneficio.vibora.inactivo o mana > 40) -- Aspecto del dracohalcón: poder de ataque y celeridad; vuelve a él cuando tengas maná.
accion marca si perjuicio.marca.inactivo -- Marca del cazador sobre el objetivo: más poder de ataque a distancia para toda la banda.
accion rapido si beneficio.rapido.inactivo -- Fuego rápido: +40% de celeridad a distancia, júntalo con Cólera de las bestias.
accion colera si mascota -- Cólera de las bestias: +50% de daño de la mascota (y +10% el tuyo con La bestia interior).
accion matar si mascota -- Matar en cuanto esté listo: los siguientes ataques especiales de tu mascota pegan más.
accion mortal -- Por debajo del 20% de vida, Disparo mortal es tu disparo más fuerte.
accion serpiente si perjuicio.serpiente.inactivo -- Mantén Picadura de serpiente: daño periódico barato.
accion apuntado -- Disparo apuntado cuando esté listo (si lo tienes): daño instantáneo.
accion arcano -- Disparo arcano cuando esté listo: daño instantáneo.
accion firme -- Disparo firme de relleno entre tus otros disparos.
]],
})

-- Punteria (PvP, temporada 8): interrumpir con Disparo silenciador, curacion reducida con Disparo apuntado, ralentizar.
table.insert(ns.builtin, {
en = [[
id: tc-hunter-mm-pvp
rotation: Marksmanship (PvP)
class: HUNTER
spec: Marksmanship
tree: 2
mode: pvp
author: Tactics Coach
version: 1
description: Interrupt casts with Silencing Shot, keep the Aimed Shot healing debuff and Concussive Shot on players, and burst with Chimera, Kill Shot and Arcane Shot. Deterrence when you are about to die.

spell callpet = 883             # Call Pet
spell deterrence = 19263
spell viper = 34074             # Aspect of the Viper
spell dragonhawk = 61847        # Aspect of the Dragonhawk
spell silencing = 34490         # Silencing Shot
spell mark = 53338              # Hunter's Mark
spell killshot = 61006          # Kill Shot
spell serpent = 49001           # Serpent Sting
spell chimera = 53209           # Chimera Shot
spell aimed = 49050             # Aimed Shot
spell concussive = 5116         # Concussive Shot
spell rapid = 3045              # Rapid Fire
spell readiness = 23989
spell arcane = 49045            # Arcane Shot
spell steady = 49052            # Steady Shot

action callpet if not pet -- Call your pet: it slows, stuns and adds pressure.
action deterrence if combat and health < 30 -- Low on health: Deterrence deflects attacks and spells for 5 seconds.
action silencing if target.casting -- The target is casting: Silencing Shot interrupts and silences it (off the global cooldown).
action viper if mana < 10 and buff.viper.down -- Out of mana: Aspect of the Viper to recover it.
action dragonhawk if buff.dragonhawk.down and (buff.viper.down or mana > 40) -- Aspect of the Dragonhawk for damage; go back to it once you have mana.
action mark if debuff.mark.down -- Hunter's Mark: more damage and the target cannot hide in stealth.
action killshot -- Below 20% health, Kill Shot to finish the target.
action aimed if target.player and debuff.aimed.remains < 2 -- Aimed Shot on players: -50% healing received, keep it up.
action serpent if debuff.serpent.down -- Serpent Sting so Chimera Shot deals its extra damage.
action chimera -- Chimera Shot whenever it is ready: burst and it refreshes your sting.
action concussive if target.player and debuff.concussive.down -- Concussive Shot: slow the player to keep your distance.
action rapid if buff.rapid.down -- Rapid Fire for a burst window.
action readiness if cooldown.rapid.remains > 60 and buff.rapid.down -- Readiness: resets Rapid Fire, Chimera Shot, Silencing Shot and Deterrence.
action arcane -- Arcane Shot: instant damage you can fire while moving.
action steady if not moving -- Steady Shot as filler only while standing still.
]],
es = [[
id: tc-hunter-mm-pvp
rotacion: Puntería (PvP)
clase: HUNTER
especializacion: Puntería
arbol: 2
modo: pvp
autor: Tactics Coach
version: 1
descripcion: Interrumpe con Disparo silenciador, mantén la curación reducida de Disparo apuntado y Disparo de conmoción sobre jugadores, y presiona con Quimera, Disparo mortal y Disparo arcano. Disuasión cuando estés a punto de morir.

hechizo llamar = 883            # Call Pet
hechizo disuasion = 19263       # Deterrence
hechizo vibora = 34074          # Aspect of the Viper
hechizo dracohalcon = 61847     # Aspect of the Dragonhawk
hechizo silenciador = 34490     # Silencing Shot
hechizo marca = 53338           # Hunter's Mark
hechizo mortal = 61006          # Kill Shot
hechizo serpiente = 49001       # Serpent Sting
hechizo quimera = 53209         # Chimera Shot
hechizo apuntado = 49050        # Aimed Shot
hechizo conmocion = 5116        # Concussive Shot
hechizo rapido = 3045           # Rapid Fire
hechizo presteza = 23989        # Readiness
hechizo arcano = 49045          # Arcane Shot
hechizo firme = 49052           # Steady Shot

accion llamar si no mascota -- Llama a tu mascota: ralentiza, aturde y mete presión.
accion disuasion si combate y vida < 30 -- Poca vida: Disuasión desvía ataques y hechizos durante 5 segundos.
accion silenciador si objetivo.lanzando -- El objetivo está lanzando: Disparo silenciador lo interrumpe y lo silencia (no usa el tiempo global).
accion vibora si mana < 10 y beneficio.vibora.inactivo -- Sin maná: Aspecto de la víbora para recuperarlo.
accion dracohalcon si beneficio.dracohalcon.inactivo y (beneficio.vibora.inactivo o mana > 40) -- Aspecto del dracohalcón para hacer daño; vuelve a él cuando tengas maná.
accion marca si perjuicio.marca.inactivo -- Marca del cazador: más daño y el objetivo no puede esconderse en sigilo.
accion mortal -- Por debajo del 20% de vida, Disparo mortal para rematar.
accion apuntado si objetivo.jugador y perjuicio.apuntado.restante < 2 -- Disparo apuntado sobre jugadores: -50% de curación recibida, mantenlo.
accion serpiente si perjuicio.serpiente.inactivo -- Picadura de serpiente para que Disparo de quimera haga su daño extra.
accion quimera -- Disparo de quimera en cuanto esté listo: daño de ráfaga y renueva tu picadura.
accion conmocion si objetivo.jugador y perjuicio.conmocion.inactivo -- Disparo de conmoción: ralentiza al jugador para mantener la distancia.
accion rapido si beneficio.rapido.inactivo -- Fuego rápido para una ventana de ráfaga.
accion presteza si reutilizacion.rapido.restante > 60 y beneficio.rapido.inactivo -- Presteza: reinicia Fuego rápido, Quimera, Disparo silenciador y Disuasión.
accion arcano -- Disparo arcano: daño instantáneo que puedes lanzar en movimiento.
accion firme si no moviendo -- Disparo firme de relleno solo cuando estés quieto.
]],
})

-- Bestias (PvP, temporada 8): Intimidacion para cortar lanzamientos, Colera de las bestias + Matar para la rafaga.
table.insert(ns.builtin, {
en = [[
id: tc-hunter-bm-pvp
rotation: Beast Mastery (PvP)
class: HUNTER
spec: Beast Mastery
tree: 1
mode: pvp
author: Tactics Coach
version: 1
description: Your pet is the pressure: Bestial Wrath and Kill Command for burst, Intimidation to stop casts, healing debuff and slow on players, and instant shots while you kite.

spell callpet = 883             # Call Pet
spell deterrence = 19263
spell intimidation = 19577
spell viper = 34074             # Aspect of the Viper
spell dragonhawk = 61847        # Aspect of the Dragonhawk
spell mark = 53338              # Hunter's Mark
spell wrath = 19574             # Bestial Wrath
spell command = 34026           # Kill Command
spell killshot = 61006          # Kill Shot
spell aimed = 49050             # Aimed Shot
spell serpent = 49001           # Serpent Sting
spell concussive = 5116         # Concussive Shot
spell rapid = 3045              # Rapid Fire
spell arcane = 49045            # Arcane Shot
spell steady = 49052            # Steady Shot

action callpet if not pet -- Call your pet: as Beast Mastery it is most of your pressure.
action deterrence if combat and health < 30 -- Low on health: Deterrence deflects attacks and spells for 5 seconds.
action intimidation if pet and target.casting -- The target is casting: Intimidation makes your pet stun it for 3 seconds.
action viper if mana < 10 and buff.viper.down -- Out of mana: Aspect of the Viper to recover it.
action dragonhawk if buff.dragonhawk.down and (buff.viper.down or mana > 40) -- Aspect of the Dragonhawk for damage; go back to it once you have mana.
action mark if debuff.mark.down -- Hunter's Mark: more damage and the target cannot hide in stealth.
action wrath if pet -- Bestial Wrath: your pet hits 50% harder and is immune to crowd control; with The Beast Within, so are you.
action command if pet -- Kill Command: your pet's next special attacks hit harder.
action killshot -- Below 20% health, Kill Shot to finish the target.
action aimed if target.player and debuff.aimed.remains < 2 -- Aimed Shot on players (if you took it): -50% healing received.
action serpent if debuff.serpent.down -- Serpent Sting: steady pressure that also makes healers spend mana.
action concussive if target.player and debuff.concussive.down -- Concussive Shot: slow the player so your pet stays on it and you keep your distance.
action rapid if buff.rapid.down -- Rapid Fire, best together with Bestial Wrath.
action arcane -- Arcane Shot: instant damage you can fire while moving.
action steady if not moving -- Steady Shot as filler only while standing still.
]],
es = [[
id: tc-hunter-bm-pvp
rotacion: Bestias (PvP)
clase: HUNTER
especializacion: Bestias
arbol: 1
modo: pvp
autor: Tactics Coach
version: 1
descripcion: Tu mascota es la presión: Cólera de las bestias y Matar para la ráfaga, Intimidación para cortar lanzamientos, curación reducida y ralentización sobre jugadores, y disparos instantáneos mientras te alejas.

hechizo llamar = 883            # Call Pet
hechizo disuasion = 19263       # Deterrence
hechizo intimidacion = 19577    # Intimidation
hechizo vibora = 34074          # Aspect of the Viper
hechizo dracohalcon = 61847     # Aspect of the Dragonhawk
hechizo marca = 53338           # Hunter's Mark
hechizo colera = 19574          # Bestial Wrath
hechizo matar = 34026           # Kill Command
hechizo mortal = 61006          # Kill Shot
hechizo apuntado = 49050        # Aimed Shot
hechizo serpiente = 49001       # Serpent Sting
hechizo conmocion = 5116        # Concussive Shot
hechizo rapido = 3045           # Rapid Fire
hechizo arcano = 49045          # Arcane Shot
hechizo firme = 49052           # Steady Shot

accion llamar si no mascota -- Llama a tu mascota: en Bestias es casi toda tu presión.
accion disuasion si combate y vida < 30 -- Poca vida: Disuasión desvía ataques y hechizos durante 5 segundos.
accion intimidacion si mascota y objetivo.lanzando -- El objetivo está lanzando: Intimidación hace que tu mascota lo aturda 3 segundos.
accion vibora si mana < 10 y beneficio.vibora.inactivo -- Sin maná: Aspecto de la víbora para recuperarlo.
accion dracohalcon si beneficio.dracohalcon.inactivo y (beneficio.vibora.inactivo o mana > 40) -- Aspecto del dracohalcón para hacer daño; vuelve a él cuando tengas maná.
accion marca si perjuicio.marca.inactivo -- Marca del cazador: más daño y el objetivo no puede esconderse en sigilo.
accion colera si mascota -- Cólera de las bestias: tu mascota pega un 50% más y es inmune al control; con La bestia interior, tú también.
accion matar si mascota -- Matar: los siguientes ataques especiales de tu mascota pegan más.
accion mortal -- Por debajo del 20% de vida, Disparo mortal para rematar.
accion apuntado si objetivo.jugador y perjuicio.apuntado.restante < 2 -- Disparo apuntado sobre jugadores (si lo tienes): -50% de curación recibida.
accion serpiente si perjuicio.serpiente.inactivo -- Picadura de serpiente: presión constante que obliga a los sanadores a gastar maná.
accion conmocion si objetivo.jugador y perjuicio.conmocion.inactivo -- Disparo de conmoción: ralentiza al jugador para que tu mascota lo alcance y tú mantengas la distancia.
accion rapido si beneficio.rapido.inactivo -- Fuego rápido, mejor junto a Cólera de las bestias.
accion arcano -- Disparo arcano: daño instantáneo que puedes lanzar en movimiento.
accion firme si no moviendo -- Disparo firme de relleno solo cuando estés quieto.
]],
})

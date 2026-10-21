local _, ns = ...
ns = ns or TacticsCoachNS
ns.builtin = ns.builtin or {}

-- IDs verificados contra el Spell.dbc 3.3.5a del servidor (rango maximo de cada uno).
-- La misma rotacion en los dos idiomas: el id fijo hace que cambiar de idioma no la vuelva otra.

-- Sombra (PvE, ICC): Tejido de sombras a 5 cargas antes del Dolor, que luego renueva Tortura
-- mental (Dolor y sufrimiento). Toque vampirico y Peste devoradora siempre puestos.
table.insert(ns.builtin, {
en = [[
id: tc-priest-shadow
rotation: Shadow
class: PRIEST
spec: Shadow
tree: 3
mode: pve
author: Tactics Coach
version: 1
description: Keep Vampiric Touch and Devouring Plague up, put Shadow Word: Pain on at 5 Shadow Weaving stacks (Mind Flay keeps it up), Mind Blast on cooldown and Mind Flay as filler.

spell shadowform = 15473
spell innerfire = 48168          # Inner Fire
spell embrace = 15286            # Vampiric Embrace
spell vt = 48160                 # Vampiric Touch
spell plague = 48300             # Devouring Plague
spell swp = 48125                # Shadow Word: Pain
spell fiend = 34433              # Shadowfiend
spell dispersion = 47585
spell death = 48158              # Shadow Word: Death
spell blast = 48127              # Mind Blast
spell flay = 48156               # Mind Flay
aura weaving = 15258             # Shadow Weaving (buff on you, 5 stacks)

action shadowform if buff.shadowform.down -- Shadowform always on: +15% shadow damage and your DoTs can crit.
action innerfire if buff.innerfire.down -- Inner Fire always on: spell power.
action embrace if buff.embrace.down -- Vampiric Embrace always on: your shadow damage heals your group.
action vt if debuff.vt.remains < cast.vt -- Refresh Vampiric Touch as it ends: it gives Replenishment (mana) to the raid.
action plague if debuff.plague.down -- Keep Devouring Plague up: strong DoT with an instant hit on cast.
action swp if debuff.swp.down and buff.weaving.stack >= 5 -- Shadow Word: Pain once you have 5 Shadow Weaving stacks; Mind Flay refreshes it from then on.
action fiend if mana < 50 -- Shadowfiend when you drop to half mana: damage and mana back.
action dispersion if mana < 10 -- Dispersion when you are nearly out of mana: it restores 36% over 6 s.
action death if moving -- While moving, Shadow Word: Death is your instant damage.
action blast -- Mind Blast on cooldown: big hit and it keeps Improved Spirit Tap going.
action flay -- Mind Flay as filler: it refreshes Shadow Word: Pain (Pain and Suffering).
]],
es = [[
id: tc-priest-shadow
rotacion: Sombra
clase: PRIEST
especializacion: Sombra
arbol: 3
modo: pve
autor: Tactics Coach
version: 1
descripcion: Mantén Toque vampírico y Peste devoradora, pon Palabra de las Sombras: dolor con 5 cargas de Tejido de sombras (Tortura mental lo renueva), Explosión mental en cuanto esté lista y Tortura mental de relleno.

hechizo forma = 15473            # Shadowform
hechizo fuego = 48168            # Inner Fire
hechizo abrazo = 15286           # Vampiric Embrace
hechizo toque = 48160            # Vampiric Touch
hechizo peste = 48300            # Devouring Plague
hechizo dolor = 48125            # Shadow Word: Pain
hechizo maligno = 34433          # Shadowfiend
hechizo dispersion = 47585       # Dispersion
hechizo muerte = 48158           # Shadow Word: Death
hechizo explosion = 48127        # Mind Blast
hechizo tortura = 48156          # Mind Flay
aura tejido = 15258              # Shadow Weaving (beneficio sobre ti, 5 cargas)

accion forma si beneficio.forma.inactivo -- Forma de las Sombras siempre puesta: +15% de daño de las Sombras y tus efectos periódicos pueden ser críticos.
accion fuego si beneficio.fuego.inactivo -- Fuego interno siempre puesto: poder con hechizos.
accion abrazo si beneficio.abrazo.inactivo -- Abrazo vampírico siempre puesto: tu daño de las Sombras cura a tu grupo.
accion toque si perjuicio.toque.restante < lanzamiento.toque -- Renueva Toque vampírico al acabarse: da Reabastecimiento (maná) a la banda.
accion peste si perjuicio.peste.inactivo -- Mantén Peste devoradora: daño periódico fuerte con un golpe instantáneo al lanzarla.
accion dolor si perjuicio.dolor.inactivo y beneficio.tejido.cargas >= 5 -- Palabra de las Sombras: dolor con 5 cargas de Tejido de sombras; desde ahí Tortura mental la renueva.
accion maligno si mana < 50 -- Maligno de las Sombras con la mitad del maná: daño y maná de vuelta.
accion dispersion si mana < 10 -- Dispersión cuando casi no te queda maná: recupera un 36% en 6 s.
accion muerte si moviendo -- Mientras te mueves, Palabra de las Sombras: muerte es tu daño instantáneo.
accion explosion -- Explosión mental en cuanto esté lista: golpe fuerte que mantiene Toque espiritual mejorado.
accion tortura -- Tortura mental de relleno: renueva Palabra de las Sombras: dolor (Dolor y sufrimiento).
]],
})

-- Disciplina (PvE, ICC): sanador de tanque y de escudos.
table.insert(ns.builtin, {
en = [[
id: tc-priest-discipline
rotation: Discipline
class: PRIEST
spec: Discipline
tree: 1
mode: pve
author: Tactics Coach
version: 1
description: Target the ally you heal. Shield before the damage lands, Penance on cooldown, Prayer of Mending bouncing and Flash Heal to top up; Pain Suppression for emergencies.

spell innerfire = 48168          # Inner Fire
spell suppression = 33206        # Pain Suppression
spell shield = 48066             # Power Word: Shield
spell penance = 53007
spell pom = 48113                # Prayer of Mending
spell fiend = 34433              # Shadowfiend
spell hymn = 64901               # Hymn of Hope
spell greater = 48063            # Greater Heal
spell flash = 48071              # Flash Heal
aura weakened = 6788             # Weakened Soul (debuff from your shield on the ally)
aura borrowed = 59891            # Borrowed Time (buff after your shield)

action innerfire if buff.innerfire.down -- Inner Fire always on: spell power and armor.
action suppression if target.friendly and target.health < 30 -- Pain Suppression on an ally about to die: -40% damage taken.
action shield if target.friendly and debuff.weakened.down and target_buff.shield.down -- Shield before the hit: it absorbs, gives you mana (Rapture) and hastes your next spell (Borrowed Time).
action penance if target.friendly and target.health < 90 -- Penance on cooldown: your strongest heal, and it stacks Grace on the target.
action pom if target.friendly and target_buff.pom.down -- Prayer of Mending on cooldown: it heals and jumps to whoever takes damage next.
action fiend if mana < 50 and not target.friendly -- Shadowfiend on the boss when you are at half mana.
action hymn if mana < 20 -- Hymn of Hope when you are nearly out of mana: mana for you and your raid.
action greater if target.friendly and target.health < 50 and buff.borrowed.up -- With Borrowed Time a fast Greater Heal for a big hole on the tank.
action flash -- Flash Heal as filler: fast heal that keeps Grace up and makes Divine Aegis shields.
]],
es = [[
id: tc-priest-discipline
rotacion: Disciplina
clase: PRIEST
especializacion: Disciplina
arbol: 1
modo: pve
autor: Tactics Coach
version: 1
descripcion: Selecciona al aliado que curas. Escudo antes del daño, Penitencia en cuanto esté lista, Rezo de alivio saltando y Sanación relámpago para rellenar; Supresión de dolor para emergencias.

hechizo fuego = 48168            # Inner Fire
hechizo supresion = 33206        # Pain Suppression
hechizo escudo = 48066           # Power Word: Shield
hechizo penitencia = 53007       # Penance
hechizo alivio = 48113           # Prayer of Mending
hechizo maligno = 34433          # Shadowfiend
hechizo himno = 64901            # Hymn of Hope
hechizo superior = 48063         # Greater Heal
hechizo relampago = 48071        # Flash Heal
aura debilitada = 6788           # Weakened Soul (perjuicio de tu escudo sobre el aliado)
aura prestado = 59891            # Borrowed Time (beneficio tras tu escudo)

accion fuego si beneficio.fuego.inactivo -- Fuego interno siempre puesto: poder con hechizos y armadura.
accion supresion si objetivo.amistoso y objetivo.vida < 30 -- Supresión de dolor sobre un aliado a punto de morir: -40% de daño recibido.
accion escudo si objetivo.amistoso y perjuicio.debilitada.inactivo y beneficio_objetivo.escudo.inactivo -- Escudo antes del golpe: absorbe, te da maná (Éxtasis) y acelera tu siguiente hechizo (Tiempo prestado).
accion penitencia si objetivo.amistoso y objetivo.vida < 90 -- Penitencia en cuanto esté lista: tu mejor sanación, y pone Gracia en el objetivo.
accion alivio si objetivo.amistoso y beneficio_objetivo.alivio.inactivo -- Rezo de alivio en cuanto esté listo: cura y salta a quien reciba daño después.
accion maligno si mana < 50 y no objetivo.amistoso -- Maligno de las Sombras sobre el jefe cuando estés a la mitad de maná.
accion himno si mana < 20 -- Himno de esperanza cuando casi no te queda maná: maná para ti y tu banda.
accion superior si objetivo.amistoso y objetivo.vida < 50 y beneficio.prestado.activo -- Con Tiempo prestado, una Sanación superior rápida para un agujero grande en el tanque.
accion relampago -- Sanación relámpago de relleno: rápida, mantiene Gracia y crea escudos de Égida divina.
]],
})

-- Sagrado (PvE, ICC): sanador de banda.
table.insert(ns.builtin, {
en = [[
id: tc-priest-holy
rotation: Holy
class: PRIEST
spec: Holy
tree: 2
mode: pve
author: Tactics Coach
version: 1
description: Target the ally you heal. Circle of Healing and Prayer of Mending on cooldown, Renew on the tank, free Flash Heals from Surge of Light, and Greater Heal faster with Serendipity.

spell innerfire = 48168          # Inner Fire
spell guardian = 47788           # Guardian Spirit
spell pom = 48113                # Prayer of Mending
spell circle = 48089             # Circle of Healing
spell flash = 48071              # Flash Heal
spell renew = 48068
spell greater = 48063            # Greater Heal
spell binding = 48120            # Binding Heal
spell desperate = 48173          # Desperate Prayer
spell hymn = 64901               # Hymn of Hope
aura surge = 33151               # Surge of Light (proc)
aura serendipity = 63735         # Serendipity (buff, up to 3 stacks)

action innerfire if buff.innerfire.down -- Inner Fire always on: spell power.
action guardian if target.friendly and target.health < 25 -- Guardian Spirit on an ally about to die: +40% healing and it saves them from one killing blow.
action pom if target.friendly -- Prayer of Mending on cooldown: it heals five times jumping between allies.
action circle if target.friendly and target.health < 90 -- Circle of Healing on cooldown: instant heal on the most hurt around your target.
action flash if buff.surge.up -- Surge of Light: your next Flash Heal is instant and free.
action renew if target.friendly and target_buff.renew.down and target.health < 100 -- Renew on whoever takes damage (the tank above all): cheap and instant.
action desperate if health < 35 -- Desperate Prayer when you are the one in danger: instant self heal.
action greater if target.friendly and target.health < 50 and buff.serendipity.stack >= 2 -- With Serendipity stacks, Greater Heal casts faster: use it for big holes.
action binding if target.friendly and health < 70 and target.health < 80 -- Binding Heal when you are hurt too: heals the target and you.
action hymn if mana < 20 -- Hymn of Hope when you are nearly out of mana: mana for you and your raid.
action flash -- Flash Heal as filler: fast, and it stacks Serendipity.
]],
es = [[
id: tc-priest-holy
rotacion: Sagrado
clase: PRIEST
especializacion: Sagrado
arbol: 2
modo: pve
autor: Tactics Coach
version: 1
descripcion: Selecciona al aliado que curas. Círculo de sanación y Rezo de alivio en cuanto estén listos, Renovar en el tanque, Sanación relámpago gratis con Oleada de Luz y Sanación superior más rápida con Serendipia.

hechizo fuego = 48168            # Inner Fire
hechizo espiritu = 47788         # Guardian Spirit
hechizo alivio = 48113           # Prayer of Mending
hechizo circulo = 48089          # Circle of Healing
hechizo relampago = 48071        # Flash Heal
hechizo renovar = 48068          # Renew
hechizo superior = 48063         # Greater Heal
hechizo conjunta = 48120         # Binding Heal
hechizo desesperado = 48173      # Desperate Prayer
hechizo himno = 64901            # Hymn of Hope
aura oleada = 33151              # Surge of Light (proc)
aura serendipia = 63735          # Serendipity (beneficio, hasta 3 cargas)

accion fuego si beneficio.fuego.inactivo -- Fuego interno siempre puesto: poder con hechizos.
accion espiritu si objetivo.amistoso y objetivo.vida < 25 -- Espíritu guardián sobre un aliado a punto de morir: +40% de sanación y lo salva de un golpe mortal.
accion alivio si objetivo.amistoso -- Rezo de alivio en cuanto esté listo: cura cinco veces saltando entre aliados.
accion circulo si objetivo.amistoso y objetivo.vida < 90 -- Círculo de sanación en cuanto esté listo: sanación instantánea a los más heridos alrededor de tu objetivo.
accion relampago si beneficio.oleada.activo -- Oleada de Luz: tu siguiente Sanación relámpago es instantánea y gratis.
accion renovar si objetivo.amistoso y beneficio_objetivo.renovar.inactivo y objetivo.vida < 100 -- Renovar en quien recibe daño (sobre todo el tanque): barato e instantáneo.
accion desesperado si vida < 35 -- Rezo desesperado cuando el que peligra eres tú: sanación instantánea propia.
accion superior si objetivo.amistoso y objetivo.vida < 50 y beneficio.serendipia.cargas >= 2 -- Con cargas de Serendipia, Sanación superior sale más rápido: úsala para agujeros grandes.
accion conjunta si objetivo.amistoso y vida < 70 y objetivo.vida < 80 -- Sanación conjunta cuando tú también estás herido: cura al objetivo y a ti.
accion himno si mana < 20 -- Himno de esperanza cuando casi no te queda maná: maná para ti y tu banda.
accion relampago -- Sanación relámpago de relleno: rápida y acumula Serendipia.
]],
})

-- Disciplina (PvP, temporada 8): el sanador de arenas por excelencia.
table.insert(ns.builtin, {
en = [[
id: tc-priest-discipline-pvp
rotation: Discipline (PvP)
class: PRIEST
spec: Discipline
tree: 1
mode: pvp
author: Tactics Coach
version: 1
description: Target the ally you heal. Shields on whoever is being hit, Penance and Flash Heal to heal, Pain Suppression and Psychic Scream when it goes bad, and purge enemy buffs when you can.

spell innerfire = 48168          # Inner Fire
spell desperate = 48173          # Desperate Prayer
spell scream = 10890             # Psychic Scream
spell suppression = 33206        # Pain Suppression
spell shield = 48066             # Power Word: Shield
spell penance = 53007
spell pom = 48113                # Prayer of Mending
spell flash = 48071              # Flash Heal
spell renew = 48068
spell dispel = 988               # Dispel Magic
aura weakened = 6788             # Weakened Soul (debuff from your shield)

action innerfire if buff.innerfire.down -- Inner Fire always on: armor and spell power.
action desperate if health < 35 -- Desperate Prayer: instant self heal when you are the one being focused.
action scream if health < 50 -- Psychic Scream when melee are on you: fear them off and buy time.
action suppression if target.friendly and target.health < 35 -- Pain Suppression on the ally being killed: -40% damage and harder to dispel.
action shield if target.friendly and debuff.weakened.down and target_buff.shield.down -- Shield whoever is being hit: it absorbs, prevents pushback and hastes your next cast.
action penance if target.friendly and target.health < 85 -- Penance: your biggest heal, channelled and hard to interrupt with Focused Will.
action pom if target.friendly and target_buff.pom.down -- Prayer of Mending on cooldown: instant healing that jumps on damage.
action flash if target.friendly and target.health < 75 -- Flash Heal to top up between shields and Penance.
action renew if target.friendly and target_buff.renew.down and target.health < 95 -- Renew: instant healing you can cast while moving.
action dispel if target.player and not target.friendly -- On an enemy player, Dispel Magic strips their buffs (shields, HoTs, Freedom).
action flash -- Flash Heal as filler on whoever needs it.
]],
es = [[
id: tc-priest-discipline-pvp
rotacion: Disciplina (PvP)
clase: PRIEST
especializacion: Disciplina
arbol: 1
modo: pvp
autor: Tactics Coach
version: 1
descripcion: Selecciona al aliado que curas. Escudos sobre quien recibe golpes, Penitencia y Sanación relámpago para curar, Supresión de dolor y Alarido psíquico cuando se complica, y quita beneficios enemigos cuando puedas.

hechizo fuego = 48168            # Inner Fire
hechizo desesperado = 48173      # Desperate Prayer
hechizo alarido = 10890          # Psychic Scream
hechizo supresion = 33206        # Pain Suppression
hechizo escudo = 48066           # Power Word: Shield
hechizo penitencia = 53007       # Penance
hechizo alivio = 48113           # Prayer of Mending
hechizo relampago = 48071        # Flash Heal
hechizo renovar = 48068          # Renew
hechizo disipar = 988            # Dispel Magic
aura debilitada = 6788           # Weakened Soul (perjuicio de tu escudo)

accion fuego si beneficio.fuego.inactivo -- Fuego interno siempre puesto: armadura y poder con hechizos.
accion desesperado si vida < 35 -- Rezo desesperado: sanación instantánea propia cuando te están matando a ti.
accion alarido si vida < 50 -- Alarido psíquico cuando tienes cuerpo a cuerpo encima: asústalos y gana tiempo.
accion supresion si objetivo.amistoso y objetivo.vida < 35 -- Supresión de dolor sobre el aliado al que matan: -40% de daño y más difícil de disipar.
accion escudo si objetivo.amistoso y perjuicio.debilitada.inactivo y beneficio_objetivo.escudo.inactivo -- Escudo a quien recibe golpes: absorbe, evita retrasos al lanzar y acelera tu siguiente hechizo.
accion penitencia si objetivo.amistoso y objetivo.vida < 85 -- Penitencia: tu mayor sanación, canalizada y difícil de interrumpir con Voluntad concentrada.
accion alivio si objetivo.amistoso y beneficio_objetivo.alivio.inactivo -- Rezo de alivio en cuanto esté listo: sanación instantánea que salta con el daño.
accion relampago si objetivo.amistoso y objetivo.vida < 75 -- Sanación relámpago para rellenar entre escudos y Penitencia.
accion renovar si objetivo.amistoso y beneficio_objetivo.renovar.inactivo y objetivo.vida < 95 -- Renovar: sanación instantánea que puedes lanzar en movimiento.
accion disipar si objetivo.jugador y no objetivo.amistoso -- Sobre un jugador enemigo, Disipar magia le quita beneficios (escudos, curaciones periódicas, Libertad).
accion relampago -- Sanación relámpago de relleno sobre quien lo necesite.
]],
})

-- Sombra (PvP, temporada 8): Shadowplay y dobles con sanador.
table.insert(ns.builtin, {
en = [[
id: tc-priest-shadow-pvp
rotation: Shadow (PvP)
class: PRIEST
spec: Shadow
tree: 3
mode: pvp
author: Tactics Coach
version: 1
description: Silence casters, keep your three DoTs rolling, burst with Mind Blast and Shadow Word: Death, and Mind Flay to slow. Dispersion and Psychic Scream to survive.

spell shadowform = 15473
spell innerfire = 48168          # Inner Fire
spell silence = 15487
spell dispersion = 47585
spell scream = 10890             # Psychic Scream
spell shield = 48066             # Power Word: Shield
spell horror = 64044             # Psychic Horror
spell vt = 48160                 # Vampiric Touch
spell plague = 48300             # Devouring Plague
spell swp = 48125                # Shadow Word: Pain
spell death = 48158              # Shadow Word: Death
spell blast = 48127              # Mind Blast
spell flay = 48156               # Mind Flay
aura weakened = 6788             # Weakened Soul (on you after your shield)

action shadowform if buff.shadowform.down -- Shadowform always on: more damage and -15% physical damage taken.
action innerfire if buff.innerfire.down -- Inner Fire always on: armor and spell power.
action silence if target.casting -- Silence the cast: 5 s without spells.
action dispersion if health < 25 -- Dispersion: -90% damage and it breaks snares while you recover.
action scream if health < 50 -- Psychic Scream when melee are on you: fear them off.
action shield if self_debuff.weakened.down and health < 80 -- Shield yourself when you take damage: absorbs and stops pushback on your casts.
action horror if target.player and target.health < 40 -- Psychic Horror on a low target: they cannot run or fight back while you finish them.
action vt if debuff.vt.remains < cast.vt -- Keep Vampiric Touch up: damage, mana for you, and it protects your other DoTs from dispels.
action plague if debuff.plague.down -- Keep Devouring Plague up: instant damage that heals you.
action swp if debuff.swp.down -- Keep Shadow Word: Pain up: constant pressure.
action death if target.health < 35 or moving -- Shadow Word: Death: instant burst to finish or while moving.
action blast -- Mind Blast on cooldown: your biggest hit.
action flay -- Mind Flay as filler: it slows the target and refreshes Shadow Word: Pain.
]],
es = [[
id: tc-priest-shadow-pvp
rotacion: Sombra (PvP)
clase: PRIEST
especializacion: Sombra
arbol: 3
modo: pvp
autor: Tactics Coach
version: 1
descripcion: Silencia a los lanzadores, mantén tus tres efectos periódicos, daño fuerte con Explosión mental y Palabra de las Sombras: muerte, y Tortura mental para ralentizar. Dispersión y Alarido psíquico para sobrevivir.

hechizo forma = 15473            # Shadowform
hechizo fuego = 48168            # Inner Fire
hechizo silencio = 15487         # Silence
hechizo dispersion = 47585       # Dispersion
hechizo alarido = 10890          # Psychic Scream
hechizo escudo = 48066           # Power Word: Shield
hechizo horror = 64044           # Psychic Horror
hechizo toque = 48160            # Vampiric Touch
hechizo peste = 48300            # Devouring Plague
hechizo dolor = 48125            # Shadow Word: Pain
hechizo muerte = 48158           # Shadow Word: Death
hechizo explosion = 48127        # Mind Blast
hechizo tortura = 48156          # Mind Flay
aura debilitada = 6788           # Weakened Soul (sobre ti tras tu escudo)

accion forma si beneficio.forma.inactivo -- Forma de las Sombras siempre puesta: más daño y -15% de daño físico recibido.
accion fuego si beneficio.fuego.inactivo -- Fuego interno siempre puesto: armadura y poder con hechizos.
accion silencio si objetivo.lanzando -- Silencia el lanzamiento: 5 s sin hechizos.
accion dispersion si vida < 25 -- Dispersión: -90% de daño y quita ralentizaciones mientras te recuperas.
accion alarido si vida < 50 -- Alarido psíquico cuando tienes cuerpo a cuerpo encima: asústalos.
accion escudo si perjuicio_propio.debilitada.inactivo y vida < 80 -- Escúdate cuando recibas daño: absorbe y evita retrasos al lanzar.
accion horror si objetivo.jugador y objetivo.vida < 40 -- Horror psíquico sobre un objetivo bajo: no puede huir ni defenderse mientras lo rematas.
accion toque si perjuicio.toque.restante < lanzamiento.toque -- Mantén Toque vampírico: daño, maná para ti y protege tus otros efectos periódicos de las disipaciones.
accion peste si perjuicio.peste.inactivo -- Mantén Peste devoradora: daño instantáneo que te cura.
accion dolor si perjuicio.dolor.inactivo -- Mantén Palabra de las Sombras: dolor: presión constante.
accion muerte si objetivo.vida < 35 o moviendo -- Palabra de las Sombras: muerte: daño instantáneo para rematar o en movimiento.
accion explosion -- Explosión mental en cuanto esté lista: tu golpe más fuerte.
accion tortura -- Tortura mental de relleno: ralentiza al objetivo y renueva Palabra de las Sombras: dolor.
]],
})

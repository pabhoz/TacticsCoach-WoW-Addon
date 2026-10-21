<div align="center">

# 🎯 Tactics Coach

**Aprende tu clase. Demuéstralo en el muñeco.**

Tactics Coach te dice qué hechizo lanzar ahora y por qué, te deja armar y compartir tus propias rotaciones, y mide en un muñeco de práctica cuál hace más daño.

![WoW 3.3.5a](https://img.shields.io/badge/WoW-3.3.5a%20(WotLK)-8a2be2)
![Interface 30300](https://img.shields.io/badge/Interface-30300-blue)
![Licencia: GPL v3](https://img.shields.io/badge/Licencia-GPLv3-green)
![English · Español](https://img.shields.io/badge/idioma-English%20%C2%B7%20Espa%C3%B1ol-orange)

*[Read in English](README.md)*

</div>

---

Una guía de rotación te dice *qué* pulsar. Tactics Coach se pone junto a tus barras y te dice **qué pulsar ahora mismo**, y **por qué**, para que aprendas la prioridad en vez de memorizarla. Después te deja ponerla a prueba: una prueba de 1 o 3 minutos en un muñeco de práctica y las rotaciones comparadas lado a lado.

<p align="center">
  <img src="docs/screenshots/suggestion.png" alt="La sugerencia: el hechizo de ahora, el siguiente y por qué toca este paso">
</p>
<p align="center"><sub>El hechizo de ahora, el que viene después, y <b>por qué</b>.</sub></p>

<p align="center">
  <img src="docs/screenshots/rotations.png" width="49%" alt="Ventana de rotaciones: la prioridad de la rotación elegida, explicada paso a paso">
  <img src="docs/screenshots/results.png" width="49%" alt="Resultados de las pruebas: DPS medio, mejor, dispersión, DPS de mascota, golpe más grande, acierto y nivel de equipo">
</p>
<p align="center"><sub><b>Rotaciones</b>: cada paso de la prioridad, explicado &nbsp;·&nbsp; <b>Resultados</b>: compara rotaciones en el muñeco</sub></p>

## ✨ Qué hace

| | Qué | Cómo |
|---|---|---|
| 🎯 | **Qué lanzar ahora** | Un icono grande con el siguiente hechizo, uno pequeño con el que viene después y la explicación del paso. Azulado si esperas maná o energía, rojizo si estás fuera de alcance |
| 📚 | **Plantillas para las 10 clases** | Rotaciones de PvE y PvP según el meta de 3.3.5a (ICC y temporada 8). Se elige sola según tus talentos |
| 🛠️ | **Editor visual** | Eliges hechizos de tu libro, los ordenas y les pones condiciones desde un menú, sin código. Las de fábrica también se editan y se restauran |
| ⏱️ | **Pruebas de 1 y 3 minutos** | DPS, daño por hechizo, **DPS de mascota** aparte, **golpe más grande**, **curación** y cuántas veces **seguiste** la sugerencia. Solo se comparan pruebas de la misma duración |
| 📊 | **Medidor de la sesión** | Daño y DPS del combate y de toda la sesión, la parte de la mascota, el golpe más grande y la curación: bajo el icono y en el botón del minimapa |
| 🤝 | **Compartir** | Envía una rotación a tu grupo, tu hermandad o un amigo dentro del juego, o expórtala como texto para Discord. Las rotaciones en inglés y en español funcionan en cualquier cliente |
| 🌍 | **Inglés y español** | Sigue el idioma de tu cliente (`esES` / `esMX`), o eliges tú |

## 📚 Plantillas de fábrica

| Clase | PvE | PvP |
|---|---|---|
| **Caballero de la Muerte** | Escarcha, Profano, Sangre tanque | Profano |
| **Druida** | Equilibrio, Feral felino, Feral tanque (oso), Restauración | Feral, Restauración |
| **Cazador** | Puntería, Supervivencia, Bestias | Puntería, Bestias |
| **Mago** | Arcano, Fuego | Escarcha |
| **Paladín** | Reprensión, Protección, Sagrado | Reprensión, Sagrado |
| **Sacerdote** | Sombra, Disciplina, Sagrado | Disciplina, Sombra |
| **Pícaro** | Sutileza, Asesinato, Combate | Sutileza, Asesinato |
| **Chamán** | Elemental, Mejora, Restauración | Restauración, Mejora, Elemental |
| **Brujo** | Aflicción, Destrucción, Demonología | Aflicción, Destrucción |
| **Guerrero** | Furia, Armas, Protección | Armas |

Cada una explica todos sus pasos, para que entiendas *por qué* un hechizo está donde está. Son un punto de partida: duplica una y ajústala a tu equipo, tus talentos y tu encuentro.

## 🚀 Para empezar

1. Descarga **`TacticsCoach.zip`** de la [última versión](../../releases/latest) y descomprímelo en `World of Warcraft/Interface/AddOns/`. Tiene que quedar `Interface/AddOns/TacticsCoach/TacticsCoach.toc`.
2. Entra al juego. Tu rotación se elige sola según el árbol de talentos donde tienes más puntos. Ábrelo con **`/tc`** o con el botón del minimapa.
3. Busca un muñeco de práctica y pulsa **Probar 3 min**. Después, **Resultados** para comparar.

> Consejo: escribe `/console scriptErrors 1` una vez. WoW 3.3.5a esconde los errores de Lua: si algo se ve raro, el error dice exactamente qué pasó.

## 🛠️ Arma tu propia rotación

En `/tc`: **Nueva**, **Duplicar** o **Editar** (también las de fábrica; **Restaurar original** las devuelve como venían).

<p align="center">
  <img src="docs/screenshots/editor.png" width="49%" alt="Editor visual: la prioridad a la izquierda, las condiciones del hechizo elegido a la derecha">
  <img src="docs/screenshots/spellbook.png" width="49%" alt="Elegir un hechizo de tu libro, con buscador">
</p>

1. **Agregar hechizo** abre tu libro de hechizos con un buscador.
2. La lista de la izquierda es la prioridad: lo más importante arriba. Las flechas reordenan y la X quita.
3. Haz clic en un hechizo para ponerle **condiciones** desde un menú ("A mi perjuicio le quedan menos de 3 seg.", "Vida del objetivo menor que 25%", "El objetivo está lanzando"…). Se tienen que cumplir todas. Sin condiciones, se sugiere siempre que esté listo.
4. Escribe la **explicación** que quieres ver bajo el icono, y **Guardar**.

No hace falta comprobar que un hechizo esté listo o aprendido: si está en reutilización, no lo tienes o no se puede usar ahora (postura o forma equivocada, sin el proc), se salta solo.

### Como texto

Por debajo, una rotación es texto: eso es lo que exportas y compartes. **Editar como texto** y **Pegar texto** te dejan escribirla a mano:

```
rotacion: Destrucción con agonía
clase: brujo
arbol: 3
hechizo inmolar = 47811
hechizo agonia = 47864
hechizo incinerar = 47838
accion inmolar si perjuicio.inmolar.restante < lanzamiento.inmolar -- Inmolar siempre activo.
accion agonia si perjuicio.agonia.inactivo
accion incinerar -- Relleno.
```

Las condiciones son un lenguaje pequeño y cerrado: solo pueden leer los valores de abajo y nunca ejecutan código, así que una rotación que te comparten es segura de importar.

| Escribe | Qué es |
|---|---|
| `beneficio.X.activo` / `.inactivo` / `.restante` / `.cargas` | Tu beneficio X |
| `perjuicio.X.…` | **Tu** perjuicio en el objetivo |
| `beneficio_objetivo.X.…` | **Tu** beneficio en el objetivo (HoTs, escudos, Señal de la Luz) |
| `perjuicio_propio.X.…` | Un perjuicio sobre ti (cargas de Explosión Arcana, Abstinencia) |
| `reutilizacion.X.listo` / `.restante` | Reutilización, sin contar el tiempo global |
| `lanzamiento.X` | Tiempo de lanzamiento de X, con celeridad |
| `mana`, `vida`, `objetivo.vida` | Porcentajes |
| `objetivo.lanzando`, `objetivo.jugador`, `objetivo.amistoso` | Verdadero o falso |
| `energia`, `ira`, `poder_runico`, `puntos`, `fragmentos` | Recursos |
| `sigilo`, `combate`, `moviendo`, `mascota` | Verdadero o falso |

Se combinan con `y`, `o`, `no`, paréntesis y `< <= > >= == !=`. Las palabras en inglés también valen (`debuff`, `buff`, `and`, `or`, `if`…). `/tc id <nombre>` te da los ids de tus hechizos y `/tc auras` los de las auras que tienes.

## ⌨️ Comandos

| Comando | |
|---|---|
| `/tc` | Abre tus rotaciones |
| `/tc prueba [segundos]` · `/tc parar` · `/tc resultados` | Pruebas en el muñeco |
| `/tc mover` · `/tc bloquear` · `/tc desbloquear` | Ubicar el icono (clic derecho para terminar de moverlo) |
| `/tc opciones` | Opciones (también en *Interfaz → Accesorios*) |
| `/tc reiniciar` | Pone a cero el medidor de la sesión |
| `/tc idioma auto\|es\|en` | Idioma |
| `/tc id <texto>` · `/tc auras` | Ids de hechizos y auras, para escribir rotaciones a mano |

Todos los comandos funcionan también en inglés (`/tc test`, `/tc move`, `/tc language`…).

<p align="center">
  <img src="docs/screenshots/options.png" width="60%" alt="Opciones: qué mostrar, tamaño, opacidad, posición e idioma">
</p>

## ❓ Preguntas frecuentes

**¿Lanza los hechizos por mí?** No. Blizzard no deja que los addons lancen hechizos, y la idea es que *tú* aprendas la rotación. Sugiere; tú pulsas.

**¿Es un simulador de combate completo?** No. Es una lista de prioridades que se lee diez veces por segundo. No ve las reutilizaciones de tus compañeros ni cuenta objetivos, y sugiere una cosa a la vez. Es un entrenador, no un bot.

**¿Y los sanadores?** La sugerencia es sobre tu **objetivo actual**: selecciona al aliado que curas.

**¿Dónde se guarda todo?** En `WTF/Account/<CUENTA>/SavedVariables/TacticsCoach.lua` (rotaciones y pruebas) y en el archivo de cada personaje (rotación elegida y medidor de la sesión).

## 🏰 Hecho para Stormrage

Tactics Coach nació para el reino de WotLK [Stormrage](https://stormrage-server.com), donde los muñecos de práctica también suben tus habilidades de arma, pero funciona en cualquier cliente 3.3.5a.

## 📜 Licencia

[GNU GPL v3](LICENSE). Se aceptan contribuciones: plantillas nuevas, correcciones a las prioridades y traducciones.

# 🐥 Flappy Bird (Godot Clone)

**Game #01** of my [20 Games Challenge](https://20_games_challenge.gitlab.io) —
a structured path to learning game development by building small, complete
games instead of jumping straight into one big project.

This is my first real step into hands-on game design. I'm reorienting my
career from AI engineering toward game development, and rather than starting
with a big idea, I'm starting with fundamentals — one small, finished game
at a time. Flappy Bird was the natural first pick: no custom art, no
advanced systems, just enough scope to learn how an engine actually works.

## The Challenge

> Get familiar with your engine of choice and build a small but complete
> game. No custom art yet — use sprites you find online. The focus is on
> understanding how the engine works.

Concretely, this meant learning to:
- create and destroy objects in a running scene
- read player input and move objects with it
- detect collisions and react to them

## What I Learned

- **Godot's autoload singletons** (`EventBus`, `GameState`) as the backbone
  for decoupling systems that don't otherwise need to know about each other —
  the bird doesn't know about the HUD, the HUD doesn't know about the pipes;
  they only know about signals.
- **Signal-driven game flow** over direct method calls: `game_started` /
  `game_over` broadcast from one place, and every system (bird, pipes, HUD,
  background) reacts independently.
- **A tiny state machine** (`Bird.State`: `IDLE → FLYING → DEAD → FALLING`)
  is enough to keep physics behavior readable once "what happens on input"
  stops being a single flat `if`.
- **Area2D + collision layers** for hit detection (ground, pipes, the
  invisible "goal line" that awards a point) — no physics body needed for
  anything that only *detects*, never *pushes*.
- **Persisting state across sessions** with `ConfigFile`, to keep a best
  score on disk between runs.

## Design Decisions

- **`EventBus`** (autoload) owns exactly three signals — `game_started`,
  `game_over`, `score_updated` — and nothing else. Every system subscribes
  to what it cares about instead of being wired together directly.
- **`GameState`** (autoload) owns the run's phase (`MENU / PLAYING / DEAD`),
  the current score, and the persisted best score. It's the single source
  of truth other scripts read from, never mutate directly except through
  its own methods.
- **Pipes are destroyed and respawned**, not pooled: a `PipeSpawner` timer
  instantiates a new `PipesPair` at intervals, and each pair frees itself
  via a `VisibleOnScreenNotifier2D` once it scrolls off the left edge. The
  challenge brief actually suggested reusing pairs by repositioning them —
  I chose the simpler path for a first project. Object pooling is an easy,
  concrete exercise to revisit later if spawn-rate ever becomes a
  bottleneck.
- **Each `PipesPair` is self-contained**: its own collision shapes, its own
  hit/score audio players, its own "did the bird pass me" goal line. The
  spawner's only job is deciding *when* to create one.

## Controls

`Space` — flap / start the run / restart after dying

## Running It

Open the project in **Godot 4.7+** and run it, or run `scenes/main.tscn`
directly.

## Credits

Built while following [Godot 4.3: JUEGO Flappy Bird (Tutorial 2024)](https://www.youtube.com/watch?v=NDERxitqgSs)
on YouTube. Sprites, fonts, and sound effects are the classic Flappy Bird
asset pack found online — per the challenge's own guidance for Game #1, the
focus here was the engine, not the art.

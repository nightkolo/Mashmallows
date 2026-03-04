# Todo

## 2-27

### Gameplay code

- [ ] World 1 beta
  - [x] 1-6
  - [ ] 1-8
  - [ ] 1-9
  - [ ] 1-10
  - [x] Other levels
- [x] Promo
  - [x] Fun level
- [x] Analyze game logic
  - [x] Fix race conditions
- [x] Optimize for prototype showcase
  - [x] Eye movement fix
  - [x] Transitions
  - [x] Asset fixes
- [x] **Level Goal**
  - [x] Precentage completion
  - [x] Correct block detect

## Code Improvements and goals

- [ ] Player
  - [ ] State machine
    - [x] Learn
    - [x] Document and protoype
    - [x] Design diagram
    - [ ] Implement
  - [ ] Seek feedback
- [x] Repeating BG plug-in (TiledSprite2D, WIP)

### Assets and design (WIP)

- [x] Cherry bomb design
  - [x] Explosion
  - [x] Particles
- [x] Level Goal panel design
  - [x] NinePatchRect
  - [x] **Redesign**
- [ ] **Mini block redesign**
  - [x] Redesign
  - [x] **Colored**
  - [x] **Greyscaled**
- [x] Level Goal star design
  - [x] Unattained
  - [x] Attained
  - [x] Eyes
- [x] **BG Design**
- [ ] NPC Character
  - [x] Name
  - [ ] **Design**
    - [x] Partially, sketch
    - [x] Name
    - [ ] Shoe design
    - [ ] Details
    - [ ] Color scheme
  - [ ] **Dialogue**
  - [ ] **Purpose**
- [ ] Vector design

### Animation

- [ ] **Game Loop**
  - [x] Level Goal
    - [x] **Order Blocks**
      - [x] Colored
      - [x] Uncolored
    - [x] **Order Star**
      - [x] Idle
      - [x] Percentage loading
      - [x] Particles
      - [x] Animation
      - [x] Attained Animation
  - [ ] Order complete
  - [ ] Level start
- [ ] Blocks
  - [ ] Sleeping
  - [ ] Mashed
  - [ ] Unmashed
  - [ ] Particles
    - [ ] Jumping
    - [ ] Lnading
  - [ ] Trails
  - [ ] Fun
    - [ ] Idle animation
    - [ ] Pressing down
    - [ ] Hugging walls
  - [ ] Cherry bomb
    - [ ] Attached
    - [ ] Exploding
    - [ ] Environment animation
    - [ ] Screenshake
- [ ] Objects
  - [ ] Switch/Doors
    - [ ] Copy-paste some old animation code (yeah, I'm lazy)
- [ ] NPC (WIP)

## Roadmap

### Project

- [ ] Menus
  - [ ] Start Screen
  - [ ] Title
  - [ ] Options
  - [ ] Level Select
  - [ ] Pause Menu
- [ ] Intro Sequence


## 2-20 (Legacy)

### Assets and design

- [x] Eyes
  - [x] **Happy**
- [x] TileMap
  - [x] Basic Block (for beta, colored for worlds)
  - [x] Seperated Tilemaps
    - [x] Ground
    - [x] Foreground
    - [x] Clipped Outline
    - [x] **Deco Block**
  - [x] Background tiles
    - [x] **Change tile to avoid repeativeness**
  - [x] Colored for worlds
- [x] Mechanics
  - [x] Doors
  - [x] Switch  
- [x] Paper
  - [x] Star marshmellow
    - [x] Base
    - [x] Bright
  - [x] Proper mini blocks
    - [x] **1x2 blocks**
- [x] **Mash highlighter**
- [ ] Interface (WIP)

### Gameplay code

- [x] Switch sprites
- [ ] Order Paper
  - [x] Fix presentation
  - [x] Add Star interface
  - [x] Add mini blocks
    - [x] Analyze fix scaling
    - [x] 1x2 sized
- [ ] Improved game juice
  - [x] Mash highlighters
  - [x] Unmashable highlighter
  - [x] Mashed/Unmashed state
  - [ ] Animations fixes

## 2-12 (Legacy)

### Set up

- [x] Set-up directories (assets, audio, core, scenes/object, scripts, resources)
- [x] Paste assets
- [x] Set-up project.godot
- [x] Paste prototype code
- [x] Set up test map
- [x] Set Tilemap
- [x] Set-up collision
  - [x] Collision names
- [x] Rework sizing
- [x] Rework code
- [x] Blah Blah Blah 

### Gameplay code

- [ ] Improved game juice
  - [x] Mash highlighters
  - [ ] Unmashable highlighter
  - [ ] Mashed/Unmashed state
  - [x] Animations (Tweens, on Demo)
    - [x] Test out
    - [x] Fix anim
- [x] Work on levels
  - [x] 1-3
  - [x] Cherry bomb fixing
  - [x] 1-4
  - [x] See how much you can develop (see priv/levels.md)
- [ ] Code refactor/clean-up

### Core

- [x] Set-up block sprites
- [x] Reworked MashType
- [x] Set 1x2 blocks
- [x] Add eye sprites
- [x] Improved order task presentation
- [x] Test and fix order task
  - [x] 1x2 test
- [x] Structure order complete anim

### Assets and Design (64/128 Block size)
- [ ] Mechanics
  - [x] Doors
  - [ ] Switch
- [x] BG (Moving checkerboard)
- [x] Marshmellow block
  - [x] Player
  - [x] White
  - [x] Golden
  - [x] Choco
  - [x] Biscuit
  - [x] Cherry Bomb
  - [x] Mini
  - [x] Forms for 1x2 block
- [x] Eyes
  - [x] Idle (Mashed)
  - [x] Sleep (Unmashed, darken)

## 2-8 (Legacy, complete)

### Gameplay code

- [x] Coyote jump implementation
- [x] Special marshmellows (Cherry bomb)
- [x] Wide marshmellows (1x2)
  - [x] Block detector implementation
  - [x] Mashed / Unmashed block scenes
  - [x] Code functioning
  - [x] 1x2 Block
- [x] Working on mechanic implegit
- [x] Cherry bomb fix, twice

### Level design

- [x] More level design language

### Core

- [x] Level structure
- [x] Improved order task presentation
- [x] Level progression code
- [x] Signals galore

Each level has to introduce a new gameplay element or design language, to continue off the philosophy of my previous games. I'm currently in the midest of design a language

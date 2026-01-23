# Maven CODE Resource Map

## System Overview

Maven's 53 CODE resources are organized into functional subsystems:

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         MAVEN ARCHITECTURE                               │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  ┌─────────────────────┐     ┌─────────────────────┐                    │
│  │   SIMULATION PATH   │     │    RUNTIME PATH     │                    │
│  │   (FP-heavy)        │     │    (Integer)        │                    │
│  ├─────────────────────┤     ├─────────────────────┤                    │
│  │ CODE 35 - FP Stats  │     │ CODE 32 - Scoring   │                    │
│  │ CODE 50 - Storage   │     │ CODE 15 - MUL Load  │                    │
│  │ CODE 24 - Analysis  │     │ CODE 3  - Search    │                    │
│  └─────────────────────┘     └─────────────────────┘                    │
│            │                           │                                 │
│            └───────────┬───────────────┘                                 │
│                        ▼                                                 │
│  ┌─────────────────────────────────────────────────────────────────┐    │
│  │                    CORE ENGINE                                   │    │
│  ├─────────────────────────────────────────────────────────────────┤    │
│  │ CODE 0  - Segment Loader    │ CODE 11 - Game Controller         │    │
│  │ CODE 1  - Init/Cleanup      │ CODE 21 - Main Game Loop          │    │
│  │ CODE 7  - Board Management  │ CODE 52 - Flag Operations         │    │
│  └─────────────────────────────────────────────────────────────────┘    │
│                        │                                                 │
│  ┌─────────────────────┴───────────────────────────────────────────┐    │
│  │                    USER INTERFACE                                │    │
│  ├─────────────────────────────────────────────────────────────────┤    │
│  │ CODE 6  - Window Mgmt       │ CODE 49 - Clipboard               │    │
│  │ CODE 8  - Menu Handling     │ CODE 54 - String Compare          │    │
│  │ CODE 10 - Dialog Boxes      │                                    │    │
│  └─────────────────────────────────────────────────────────────────┘    │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

## CODE Resource Classification

### Core Engine (Always Loaded)

| CODE | Size | Purpose | FP Calls |
|------|------|---------|----------|
| 0 | 3568 | Segment Loader, A5 setup | 0 |
| 1 | 578 | Initialization and cleanup | 0 |
| 11 | 4478 | Game controller, dispatch | 0 |
| 21 | 13722 | Main game loop, UI events | 0 |

### DAWG & Dictionary

| CODE | Size | Purpose | FP Calls |
|------|------|---------|----------|
| 3 | 4390 | DAWG search coordinator | 0 |
| 15 | 3568 | DAWG traversal, MUL loading | 0 |
| 36 | 9106 | Word validation | 0 |

### Move Generation & Scoring

| CODE | Size | Purpose | FP Calls |
|------|------|---------|----------|
| 32 | 6464 | Move scoring, leave application | 7 |
| 39 | 1788 | Letter combination scoring | 0 |
| 42 | 738 | Rack analysis | 0 |
| 45 | 1126 | Move ranking | 0 |

### Simulation System (FP-Heavy)

| CODE | Size | Purpose | FP Calls |
|------|------|---------|----------|
| 35 | 3276 | SANE FP statistics | 22 |
| 50 | 1178 | Result storage, resources | 25 |
| 24 | 6790 | Analysis functions | 9 |
| 16 | 1898 | Simulation support | 6 |

### Board & Game State

| CODE | Size | Purpose | FP Calls |
|------|------|---------|----------|
| 7 | 2876 | Board state management | 0 |
| 52 | 942 | Flag operations | 0 |
| 47 | 912 | State validation | 0 |

### User Interface

| CODE | Size | Purpose | FP Calls |
|------|------|---------|----------|
| 6 | 1030 | Window management | 1 |
| 8 | 2330 | Menu handling | 0 |
| 10 | 142 | Dialog utilities | 0 |
| 49 | 550 | Clipboard/scrap | 0 |
| 50 | 1178 | Move history display | 25 |

### Utilities

| CODE | Size | Purpose | FP Calls |
|------|------|---------|----------|
| 54 | 46 | String comparison | 0 |
| 53 | 110 | Small utility | 0 |
| 13 | 516 | Memory utilities | 0 |

## Detailed Classification

### Segment 0-10: Core System
- **CODE 0**: Segment loader, global pointer (A5) initialization
- **CODE 1**: Application init/cleanup
- **CODE 2**: Resource management
- **CODE 3**: DAWG search coordinator (large 2282-byte stack frame)
- **CODE 4**: Small utility (112 bytes)
- **CODE 5**: Initialization helper (208 bytes)
- **CODE 6**: Window management, display pointers
- **CODE 7**: Board state arrays (g_state1, g_state2)
- **CODE 8**: Menu command dispatch
- **CODE 9**: Event handling (3944 bytes)
- **CODE 10**: Dialog box utilities

### Segment 11-20: Game Logic
- **CODE 11**: Central game controller, callback system
- **CODE 12**: Move validation (2726 bytes)
- **CODE 13**: Memory management (516 bytes)
- **CODE 14**: Tile bag operations (2770 bytes)
- **CODE 15**: DAWG traversal, **MUL resource loading**
- **CODE 16**: Simulation support (6 FP calls)
- **CODE 17**: Score calculation helpers (2622 bytes)
- **CODE 18**: Position analysis (4464 bytes)
- **CODE 19**: Small utility (386 bytes)
- **CODE 20**: Board position utilities (3402 bytes)

### Segment 21-30: Main Game
- **CODE 21**: **Main game loop** (largest at 13722 bytes)
- **CODE 22**: Player management (2060 bytes)
- **CODE 23**: Turn handling (612 bytes)
- **CODE 24**: Analysis functions (9 FP calls)
- **CODE 25**: Small utility (204 bytes)
- **CODE 27**: Move generation helper (666 bytes)
- **CODE 28**: Cross-word scoring (668 bytes)
- **CODE 29**: Adjacent tile checking (690 bytes)
- **CODE 30**: Position scoring (3496 bytes)

### Segment 31-40: Scoring & Evaluation
- **CODE 31**: Word score calculation (2514 bytes)
- **CODE 32**: **Move scoring, leave value application** (7 FP calls)
- **CODE 34**: Score comparison (1392 bytes)
- **CODE 35**: **SANE FP statistics** (22 FP calls) - SIMULATION
- **CODE 36**: Word validation (9106 bytes)
- **CODE 37**: Extended word checks (5348 bytes)
- **CODE 38**: Small utility (378 bytes)
- **CODE 39**: Letter combination scoring (1788 bytes)
- **CODE 40**: Rack letter utilities (628 bytes)

### Segment 41-54: Support & UI
- **CODE 41**: Helper functions (664 bytes)
- **CODE 42**: Rack analysis (738 bytes)
- **CODE 43**: Move list management (1490 bytes)
- **CODE 44**: Score display (428 bytes)
- **CODE 45**: Move ranking (1126 bytes)
- **CODE 46**: History management (2908 bytes)
- **CODE 47**: State validation (912 bytes)
- **CODE 48**: UI utilities (1096 bytes)
- **CODE 49**: Clipboard operations (550 bytes)
- **CODE 50**: **Result storage** (25 FP calls) - SIMULATION
- **CODE 51**: Small utility (240 bytes)
- **CODE 52**: Flag operations (942 bytes)
- **CODE 53**: Small utility (110 bytes)
- **CODE 54**: String comparison (46 bytes - smallest)

## Key Global Variables

### Board State
| Offset | Name | Size | Purpose |
|--------|------|------|---------|
| A5-17154 | g_state1 | 289 | Letter grid (17×17) |
| A5-16610 | g_state2 | 578 | Score grid (17×17×2) |

### Leave Values
| Offset | Name | Purpose |
|--------|------|---------|
| A5-10868 | MUL handles | Array of 27 MUL resource handles (a-z, ?) |
| A5-10900 | VCB handles | Array of 8 VCB resource handles (only VCBh has data) |
| A5-10904 | FRST handle | FRST resource handle |
| A5-10908 | EXPR handle | EXPR resource handle |
| A5-27630 | Letter values | Point value lookup table |

### Game State
| Offset | Name | Purpose |
|--------|------|---------|
| A5-26158 | g_rack | Current player's rack |
| A5-8584 | g_game_state | Main game state handle |

## Scoring System Flow

```
1. Move Generation (CODE 3, 15)
   └─ DAWG traversal to find valid words

2. Base Score (CODE 32)
   └─ Tile points × multipliers + bingo bonus

3. Leave Value (CODE 32 @ 0x156A)
   └─ Load from MUL[tile][count].offset_24
   └─ SUBTRACT from score (negative = bonus)
   └─ Scale: centipoints (÷100 for points)

4. Combination Bonus (CODE 39)
   └─ Letter pair synergies

5. Final Ranking (CODE 45)
   └─ Sort by total value
```

## Scale Conventions

- **Bingo bonus**: 5000 centipoints = 50 points
- **Leave values**: Integer centipoints at MUL offset 24
- **Sign convention**: Positive = good tile (keep it), Negative = bad tile (play it)
  - CODE 32 SUBTRACTS the adjustment, so positive values reduce move score (incentivize keeping)
- **VCBh**: Vowel count adjustments (optimal at 4 vowels = +3.68 pts)

## Cross-References

| If analyzing... | Also see... |
|-----------------|-------------|
| Move scoring | CODE 32, 39, 45 |
| Leave values | CODE 15, 32, 35 |
| DAWG/Dictionary | CODE 3, 15, 36 |
| Simulation | CODE 35, 50, 24 |
| Board state | CODE 7, 32, 52 |
| UI/Windows | CODE 6, 8, 21 |

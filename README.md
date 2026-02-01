# Kids Educational App

A suite of apps for children that help them learn naturally through play.

---

## Project Structure

```text
kids-edu-app/
├── README.md                    # This file
├── melos.yaml                   # Melos monorepo configuration
├── kids-educational-app-design/ # Design system generated with V0 (reference)
├── packages/                    # Shared Flutter packages
│   ├── design_system/           # Design tokens & themes
│   ├── core/                    # Core logic
│   ├── ui_components/           # Shared UI components
│   └── animations/              # Rich animations (Rive)
└── apps/                        # Applications
    ├── learning_app/            # Learning app
    └── picture_book_app/        # Picture book app
```

---

## Apps

| App | Type | Use Case | Duration |
| --- | ---- | -------- | -------- |
| Learning App | Active | Morning–Afternoon | 3–7 min |
| Picture Book App | Passive | Before bed | 10–15 min |

---

## Concept

**An app where kids get smarter naturally through "play", not "study"**

- Kids hate studying → The moment they perceive it as a study app, you lose
- A replacement for YouTube/TikTok → Something parents can trust
- Both apps share the same characters and world

```text
Traditional: Problem → Answer → Correct/Incorrect
This App:    Play → Action → The world changes (learning is evaluated behind the scenes)
```

---

## Target Users

| Item | Details |
| ---- | ------- |
| Age Range | 3–5 years old (preschool) |
| Primary Users | Children |
| Purchase Decision | Parents |

---

## Tech Stack

| Item | Choice |
| ---- | ------ |
| Framework | Flutter |
| Platforms | Android / iOS |
| Network | Primarily offline |
| Auth | None (on-device profiles) |
| Repository | Monorepo (Melos) |
| State Management | Riverpod |
| Local DB | Hive |
| Routing | go_router |
| In-App AI | No generative AI; adaptive logic only |

### Why Flutter

- Single codebase for both OS with unified UI and logic
- Strong support for 2D animation, parallax, and particle effects
- Integration with Spine / Live2D is possible
- Great fit for educational apps

### What We Avoid

- Unity (heavy app size, slow startup, high integration cost)
- In-app character generation
- In-app generative AI requests
- Account authentication / Auth
- Social sharing
- Ad SDKs

---

## Shared Packages

### design_system

Defines design tokens, typography, and themes.

```
packages/design_system/
└── lib/
    ├── design_system.dart
    └── src/
        ├── colors/app_colors.dart        # Color tokens
        ├── typography/app_typography.dart  # Typography (Japanese-ready)
        ├── spacing/app_spacing.dart        # Spacing, radius, gaps
        └── theme/app_theme.dart            # ThemeData integration
```

**Font Selection:**
- Display: M PLUS Rounded 1c (rounded & kid-friendly, full Japanese support)
- Body: Noto Sans JP (high readability, full Japanese support)

### core

Shared logic for characters, streaks, rewards, etc.

```
packages/core/
└── lib/
    ├── core.dart
    └── src/
        ├── character/       # Character selection, growth, XP, levels
        ├── parent_gate/     # Parent gate (3s hold + math problem)
        ├── storage/         # Local storage abstraction (Hive)
        ├── streak/          # Streak tracking, monthly recovery
        ├── rewards/         # Stamp collection, unlockable items
        └── audio/           # BGM / SFX / narration management
```

### ui_components

Shared UI widget library.

```
packages/ui_components/
└── lib/
    ├── ui_components.dart
    └── src/
        ├── buttons/         # ChoiceButton, PrimaryButton, IconActionButton
        ├── character/       # CharacterAvatar, CharacterSelector
        ├── progress/        # StarProgress, DotProgress, StepProgress
        ├── modals/          # RewardModal, ParentGateModal
        └── common/          # TapFeedback, FadeInWidget, BounceInWidget
```

### animations

Rich animation system that makes kid-friendly UI/UX feel "as fun as a game".

```
packages/animations/
└── lib/
    ├── animations.dart
    └── src/
        ├── rive/           # Rive integration & state machine control
        ├── transitions/    # Custom page transitions (clouds, rainbow wipe, etc.)
        ├── effects/        # Confetti & particles
        ├── living_ui/      # Breathing animations, eye-following
        ├── physics/        # Physics-based buttons
        ├── backgrounds/    # Interactive backgrounds (sky, clouds, animals)
        ├── rewards/        # Reward effects (flying stickers)
        ├── micro/          # Micro-interactions (flower growth, musical taps)
        └── progress/       # Caterpillar progress bar, etc.
```

#### Tech Choice: Rive

| Aspect | Rive | Spine | Live2D |
|--------|------|-------|--------|
| Flutter Support | Official | Official | None |
| File Size | 10–15x smaller | Medium | Large |
| State Machine | Visual editor | Code required | Limited |
| Character + UI unified | Yes | Partial | No |

**Conclusion**: Unified on Rive (for both characters and UI/UX effects)

#### Provided Components

**Page Transitions:**
| Component | Purpose |
|-----------|---------|
| `CloudTransitionPage` | Cloud puff screen transition (learning app) |
| `BookTurnTransitionPage` | Book page-turn transition (picture book app) |
| `StarBurstTransitionPage` | Star burst transition (celebration) |
| `RainbowWipeTransitionPage` | Rainbow wipes across the screen |
| `RainbowBurstTransitionPage` | Rainbow expands from center |

**Effects:**
| Component | Purpose |
|-----------|---------|
| `ConfettiEffect` | Confetti celebration effect |
| `ParticleTapEffect` | Tap particles (flowers, stars, hearts, etc.) |

**Living UI:**
| Component | Purpose |
|-----------|---------|
| `BreathingWidget` | Breathing animation (5 levels: subtle–dramatic) |
| `EyeFollower` | Eyes that follow user interaction |
| `IdleWiggleWidget` | Attention-grabbing wiggle animation |

**Physics:**
| Component | Purpose |
|-----------|---------|
| `SquishyButton` | Physics-based squishy button |
| `JellyContainer` | Jelly-like wobbling container |

**Interactive Backgrounds:**
| Component | Purpose |
|-----------|---------|
| `AnimatedSkyBackground` | Animated sky (clouds, sun, stars, day/night cycle) |
| `PeekABooCreature` | Animals peeking in (rabbits, squirrels, birds, etc.) |

**Reward Effects:**
| Component | Purpose |
|-----------|---------|
| `FlyingSticker` | Sticker flies into the collection |
| `StickerCelebration` | Multiple stickers flying in sequence |
| `AnimatedSticker` | Stars, hearts, flowers, rainbows, crowns, etc. |

**Micro-interactions:**
| Component | Purpose |
|-----------|---------|
| `SeedGrowthEffect` | Tap to grow a seed into a flower (correct answer) |
| `MusicalTapWidget` | Musical scale tap (do-re-mi visual feedback) |
| `MusicalColorRow` | Colorful musical scale button row |
| `RichTouchFeedback` | Shrink + glow + haptic feedback |
| `BouncyTapFeedback` | Bouncy tap effect |
| `HapticHelper` | Haptic feedback patterns |

**Progress:**
| Component | Purpose |
|-----------|---------|
| `CaterpillarProgress` | Caterpillar crawling progress bar |

#### Usage Examples

```dart
import 'package:animations/animations.dart';

// Page transition
GoRoute(
  path: '/lesson/:id',
  pageBuilder: (context, state) => CloudTransitionPage(
    child: LessonScreen(id: state.pathParameters['id']!),
  ),
)

// Tap particles
ParticleTapEffect(
  type: TapParticleType.flowers,
  onTap: () => handleTap(),
  child: PrimaryButton(text: 'Tap!'),
)

// Confetti
ConfettiOverlay.show(context);

// Breathing animation
BreathingWidget(
  intensity: BreathingIntensity.subtle,
  child: CharacterAvatar(...),
)

// Eye following
EyeFollower(
  eyeSize: 32,
  eyeSpacing: 24,
)

// Squishy button
SquishyButton(
  onPressed: () => handlePress(),
  child: MyButtonContent(),
)
```

#### Animation Design Tokens

```dart
// Additional tokens (AppSpacing)
static const Duration durationCelebration;  // 1200ms - celebration
static const Duration durationTransition;   // 400ms - page transition
static const Duration durationSpring;       // 600ms - physics
static const Duration durationBounce;       // 450ms - bounce
static const Duration durationBreathing;    // 3s - breathing
static const Duration durationIdle;         // 5s - idle

static const double touchTargetKids;        // 64px
static const double touchTargetKidsLarge;   // 80px
```

#### Required Rive Assets (To Be Created)

| Asset | Filename | Priority |
|-------|----------|----------|
| Tap particles | `tap_particles.riv` | P0 |
| Button deformation | `button_squish.riv` | P0 |
| Confetti | `confetti.riv` | P0 |
| Cloud transition | `cloud_transition.riv` | P1 |
| Eye following | `eye_follower.riv` | P1 |
| Characters | `character_{type}.riv` | P2 |

---

## Applications

### learning_app (Learning App)

An active learning app where kids interact and the world responds.

```
apps/learning_app/
├── lib/
│   ├── main.dart
│   └── src/
│       ├── app.dart
│       ├── screens/         # HomeScreen, OnboardingScreen
│       ├── widgets/         # App-specific widgets
│       └── providers/       # Riverpod providers
└── assets/
    ├── images/
    └── audio/
```

#### Learning Content

| Subject | Content |
| ------- | ------- |
| Japanese | Hiragana recognition (shape identification over stroke order) |
| Math | Number sense (1–10) → Addition intuition → Mini word problems |
| English | Sound & words (colors, animals, greetings). Reading/writing deferred |
| Thinking | Patterns, classification, sequences, spot-the-difference |
| Daily Life | Clock concepts, days of the week, seasons |

#### Content Formats

- 3-choice questions
- Drag & drop
- Tracing

#### "Doesn't Feel Like Studying" Design Example

**Number Sense (Math):**
- Apples fall onto the screen
- The character asks "Which has more?"
- Tap to choose → Correct answer makes a tree grow and flowers bloom
- Child's perception: Caring for a garden / game — Actual: Quantity comparison, number recognition

### picture_book_app (Picture Book App)

A passive read-aloud app where your own character becomes the narrator.

```
apps/picture_book_app/
├── lib/
│   ├── main.dart
│   └── src/
│       ├── app.dart
│       ├── screens/         # HomeScreen, OnboardingScreen
│       ├── widgets/         # App-specific widgets
│       └── providers/       # Riverpod providers
└── assets/
    ├── images/
    ├── audio/
    └── stories/
```

#### Differentiation

| YouTube/TikTok | This App |
| -------------- | -------- |
| Infinite stimulation | Has an ending |
| Zero thinking | Following a story |
| Consumption | Ownership (your own character) |
| Parents worry | Parents feel safe |

#### Read-Aloud Experience

| Feature | Details |
| ------- | ------- |
| Professional Narration | High-quality readings by voice actors & narrators |
| Text Sync | Karaoke-style text highlighting |
| Ambient Sound & BGM | Bird chirping in forest scenes, suspenseful BGM for tense moments |

#### Scene-Based Modes

| Mode | Features |
| ---- | -------- |
| Bedtime Mode | Dimmed screen, quiet voice, auto-stop |
| Normal Mode | Bright screen, interactions enabled |
| Offline Mode | For car rides, etc. |

---

## Character System

Both apps share the same characters and world.

### Onboarding Flow

1. Choose a favorite animal (6–8 options)
2. Pick a color or accessory
3. "Let's do our best together from today!" → Start the experience within 1 minute
4. First experience is always a success (100% achievable difficulty)

### Character Technology

| Phase | Technology | Notes |
| ----- | ---------- | ----- |
| MVP | Rive + State Machine | Unified with UI/UX, lightweight |
| Next Phase | Advanced Rive | Complex interactions |
| High Quality | Spine (if needed) | For complex skeletal animation |

**Note**: Live2D is not recommended due to lack of official Flutter support. Unifying on Rive allows both UI effects and characters to be created with the same tool.

### Character Reaction Design

Dialogue uses templates + parameter injection. No LLM required.

| Situation | Reaction |
| --------- | -------- |
| Correct / Success | Praise + move to next |
| Miss / Failure | 1 hint + retry |
| Consecutive Misses | Lower difficulty + "Let's do it together" prompt |

---

## Parent-Facing Design

### Parent Gate

- Method: 3-second long press + simple math (addition)
- Scope: In-app purchases, settings, external communication, data deletion
- Implementation: `packages/core/lib/src/parent_gate/` and `packages/ui_components/lib/src/modals/parent_gate_modal.dart`

### Key Selling Points for Parents

- No network communication (offline)
- No surprise charges (or only behind parent gate)
- No free-text input (safe)
- Daily usage limit (prevents dependency)
- No ads

### Parent Dashboard Info

- What the child did today
- Weak areas
- Learning / reading progress

---

## Gamification

### Daily Loop

- Daily missions: 3–5 minutes
- Streak tracking: 1 recovery allowed on failure
- Stamp collection: Complete one sheet in 30 days

### Growth Elements

- Character leveling: XP from learning
- Dress-up: Rewards from daily play and review sessions
- Collection: Animal encyclopedia, badges

### Dependency Prevention

- Capped daily rewards
- Toned-down effects at night

---

## Content Pipeline

### Overall Flow

```text
Define learning requirements (human-authored)
    ↓
AI content generation (internal CI / server-side)
    ↓
Automated validation & normalization
    ↓
Convert to assets (JSON / images / audio)
    ↓
Bundle into the app
    ↓
CI build
    ↓
Store release
```

### Question JSON Schema (Learning App)

```json
{
  "id": "math_add_1_003",
  "domain": "math",
  "unit": "addition",
  "level": 1,
  "question_type": "choice_3",
  "prompt": "There are 2 apples and 1 apple. How many in total?",
  "choices": [2, 3, 4],
  "answer": 3,
  "hints": ["Add 2 and 1"],
  "tags": ["counting", "add_small"],
  "estimated_time_sec": 6
}
```

### Story JSON Schema (Picture Book App)

```json
{
  "id": "story_friendship_001",
  "title": "The Forest of Friendship",
  "theme": ["friendship", "cooperation"],
  "age_range": [3, 5],
  "duration_min": 8,
  "pages": [
    {
      "page_number": 1,
      "text": "Once upon a time, there was a forest.",
      "image": "page_001.png",
      "audio": "page_001.mp3",
      "bgm": "forest_ambient.mp3",
      "interactive_elements": [
        {
          "type": "tap",
          "target": "bird",
          "action": "play_sound",
          "sound": "bird_chirp.mp3"
        }
      ]
    }
  ],
  "narrator_voice": "gentle_female",
  "night_mode_available": true
}
```

### Automated Validation Rules (Shared)

- JSON schema conformance
- Vocabulary level check (no words inappropriate for 5-year-olds)
- Text length limits for questions / story text
- Duplicate content detection

**CI fails if any check fails**

---

## Revenue Model

| Model | Rating | Notes |
| ----- | ------ | ----- |
| Ads | No | Unacceptable for kids |
| Subscription | Maybe | High psychological barrier for parents, poor offline compatibility |
| One-time Purchase | Best | ~$10–15, "safe educational app" is a strong pitch |
| DLC Expansion | Good | Additional packs in the future |

Initial launch: **one-time purchase only**

---

## Development Phases

### Phase 1: Foundation — Done

| Task | Status |
| ---- | ------ |
| Repository structure (monorepo) | Done |
| Design system (V0-generated) | Done |
| design_system package | Done |
| core package | Done |
| ui_components package | Done |
| animations package | Done |
| App project scaffolding | Done |
| Hive adapter generation | Needs local execution |

### Phase 1.5: Animation Foundation — Done

| Task | Status |
| ---- | ------ |
| animations package creation | Done |
| Rive integration (KidsRiveController) | Done |
| Page transition animations | Done |
| Confetti effect | Done |
| Tap particles | Done |
| Breathing animation | Done |
| Eye following | Done |
| Physics-based buttons | Done |
| Design token extension | Done |
| Rive asset creation | Not started (waiting for designer) |

### Phase 2: Specification Finalization

| Task | Status |
| ---- | ------ |
| Question JSON schema finalization | Not started |
| Story JSON schema finalization | Not started |
| UI screen flow design | Not started |
| Difficulty adjustment logic design | Not started |

### Phase 3: MVP Development

| Task | Status |
| ---- | ------ |
| Learning app: Quiz screen | Not started |
| Picture book app: Reader screen | Not started |
| Character asset creation | Not started |
| Audio asset creation | Not started |

---

## Setup

```bash
# Install Melos
dart pub global activate melos

# Install dependencies (all packages)
melos bootstrap

# Generate Hive adapters (core)
melos generate
# Or manually:
cd packages/core && dart run build_runner build --delete-conflicting-outputs
```

---

## Development Commands (Melos)

```bash
# Static analysis for all packages
melos analyze

# Run tests for all packages
melos test

# Code generation (build_runner)
melos generate

# Code formatting
melos format

# Run learning app
melos run:learning

# Run picture book app
melos run:book

# Build APK
melos build:learning:apk
melos build:book:apk
```

---

## Usage

### design_system

```dart
import 'package:design_system/design_system.dart';

// Apply theme
MaterialApp(
  theme: AppTheme.learningApp,        // Learning app
  // theme: AppTheme.pictureBookApp,  // Picture book app (night mode)
)

// Use colors
Container(color: AppColors.learningPrimary)

// Use typography
Text('Hello', style: AppTypography.headlineLarge)

// Use spacing
Column(children: [
  Text('A'),
  const VGap.md(),  // 16px
  Text('B'),
])
```

### core

```dart
import 'package:core/core.dart';

// Initialize
await HiveStorageService.initialize();
final storage = HiveStorageService();

// Create profile
final profileRepo = ProfileRepository(storage);
final profile = await profileRepo.createProfile(name: 'Taro');

// Select character
final charRepo = CharacterRepository(storage);
final character = await charRepo.createCharacter(
  profileId: profile.id,
  type: CharacterType.fox,
  name: 'Foxxie',
);

// Streak management
final streakManager = StreakManager(storage);
final result = await streakManager.recordActivity(profile.id);
print('Current streak: ${result.currentStreak} days');

// Parent gate
final parentGate = ParentGateService();
final problem = parentGate.generateProblem();
print(problem.questionText); // "7 + 5 = ?"
if (parentGate.verifyAnswer(problem, 12)) {
  print('Unlock successful');
}
```

### ui_components

```dart
import 'package:ui_components/ui_components.dart';

// Primary button
PrimaryButton(
  text: 'Next',
  icon: Icons.arrow_forward_rounded,
  onTap: () {},
)

// Quiz choice button
ChoiceButton(
  text: 'Apple',
  icon: '🍎',
  state: ChoiceButtonState.correct,
  onTap: () {},
)

// Character avatar
CharacterAvatar(
  characterType: CharacterType.fox,
  emotion: CharacterEmotion.happy,
  size: CharacterAvatarSize.large,
)

// Star progress
StarProgress(
  current: 2,
  total: 3,
)

// Reward modal
await RewardModal.show(
  context,
  title: 'Amazing!',
  message: 'You got a stamp!',
  emoji: '🎉',
  starsEarned: 3,
);

// Parent gate modal
final verified = await ParentGateModal.show(context);
if (verified) {
  // Navigate to parent settings
}
```

---

## Research Summary

### Evidence-Based Learning Methods

| Method | Evidence |
| ------ | -------- |
| Game-Based Learning | Medium–large effects on cognitive, social, and emotional aspects |
| Dialogic Reading | Vocabulary scores improved from 26% to 54% |
| Adaptive Learning | 30% improvement over traditional methods |
| Spaced Learning | Significant improvement in concept application for ages 5–7 |
| Montessori Education | Academic achievement effect size g=1.10 |

### Educational Philosophies in Picture Books

| Philosophy | Key Features |
| ---------- | ------------ |
| Montessori | Autonomy, sensory experience, realistic depiction |
| Reggio Emilia | Diverse expression, rich environmental description |
| SEL | Emotional understanding, empathy, collaboration |

---

## Competitive Analysis

### Learning Apps (International)

| Service | Ages | Price | Features |
| ------- | ---- | ----- | -------- |
| ABCmouse | 2–8 | $7.95/mo | 7,000+ activities, 1M+ paid members |
| Khan Academy Kids | 2–7 | Free | Non-profit, high quality, AI difficulty adjustment |
| Lingokids | 2–8 | ~$15/mo | 185M downloads, Playlearning |
| HOMER | 2–8 | $9.99/mo | Literacy-focused |

### Learning Apps (Japan)

| Service | Ages | Price | Features |
| ------- | ---- | ----- | -------- |
| Kodomo Challenge | 0–6 | ~$13/mo | Shimajiro, physical + digital materials |
| Smile Zemi Kids | 4–6 | ~$20/mo | Tablet-focused, AI grading |
| Gokko Land | 3–9 | Free | Career experience, sponsor model, 8M downloads |
| WonderBox | 4–10 | ~$25/mo | STEAM education, Think!Think! |

### Picture Book Apps (International)

| Service | Price | Features |
| ------- | ----- | -------- |
| Epic! | $9.99/mo | 40,000+ books, 50M users |
| Amazon Kids+ | ~$3/mo | Includes video & games |
| Vooks | $4.99/mo | Animated storybooks, 94% teacher approval |

### Picture Book Apps (Japan)

| Service | Price | Features |
| ------- | ----- | -------- |
| Ehon Navi Premium | ~$3/mo | 1,000 books unlimited |
| PIBO | ~$3/mo | Folk tales, professional narration |
| miimi | ~$3.50/mo | Voice actor narration, dubbing feature, bedtime-focused |

---

## References

### Academic Research

- Game-Based Learning Effects (Frontiers in Psychology, 2024)
- Dialogic Reading Vocabulary Effects (International Journal of Educational Research, 2009)
- AI Adaptive Learning Effects (Engageli, 2025)
- Montessori Education Meta-Analysis (Contemporary Educational Psychology, 2023)

### UX Design for Kids

- Debra Levin Gelman, *Design for Kids*
- Nielsen Norman Group, UX Guidelines for Children
- Smashing Magazine, Design Patterns for Kids' Apps

### Japanese Market References

- miimi (Tokyo Gas / Otobank)
- Gokko Land (KidsStar)
- Ehon Navi

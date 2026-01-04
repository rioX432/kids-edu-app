# Claude Code Project Instructions

## Project Overview

Kids Educational App monorepo - Flutter apps for children ages 3-5.

## Repository Structure

```
├── apps/
│   ├── learning_app/      # Active learning (morning use, 3-7 min)
│   └── picture_book_app/  # Picture books (bedtime, 10-15 min)
├── packages/
│   ├── design_system/     # Design tokens, themes, typography
│   ├── core/              # Shared logic (character, streak, storage)
│   └── ui_components/     # Shared UI widgets
└── kids-educational-app-design/  # V0 generated design reference (Next.js)
```

## Tech Stack

- Flutter 3.38+
- Riverpod (state management)
- Hive (local storage)
- go_router (navigation)
- Melos (monorepo management) - Currently having path issues with Japanese directory names

## Development Commands

```bash
# Install dependencies (all packages)
cd packages/design_system && flutter pub get
cd packages/core && flutter pub get
cd packages/ui_components && flutter pub get
cd apps/learning_app && flutter pub get
cd apps/picture_book_app && flutter pub get

# Run apps
cd apps/learning_app && flutter run
cd apps/picture_book_app && flutter run

# Code generation (Hive adapters, Freezed)
cd packages/core && dart run build_runner build --delete-conflicting-outputs
```

## Key Design Principles

1. **No "studying" feeling** - Apps should feel like games, not education
2. **Offline-first** - No network dependency
3. **Parent Gate** - 3-second hold + math problem for settings access
4. **Shared Characters** - Same character system across both apps
5. **Age-appropriate** - Content and UI designed for 3-5 year olds

## Code Style

- Follow Flutter/Dart conventions
- Use Riverpod for state management
- Keep widgets small and focused
- Japanese comments are OK for domain-specific terms

## When Adding New Features

1. Consider which package it belongs to:
   - UI widget → `packages/ui_components/`
   - Business logic → `packages/core/`
   - Styling → `packages/design_system/`
   - App-specific → `apps/{app_name}/`

2. If adding Hive models, run build_runner after changes

3. Test on both apps if touching shared packages

## Known Issues

- Melos doesn't work with Japanese path names - use direct flutter commands instead
- Hive adapters need regeneration after model changes

## Environment Setup Notes

```bash
# Required for full functionality
flutter doctor --android-licenses  # Accept Android licenses
brew install cocoapods              # For iOS builds

# Melos (optional, not working with Japanese paths)
dart pub global activate melos
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

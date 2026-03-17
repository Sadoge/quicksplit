# QuickSplit

QuickSplit is a Flutter bill-splitting app built for fast restaurant, trip, and group-expense calculations. It lets you split a bill equally or assign item totals per person, add tip in seconds, and share a clean breakdown with the group.

## Features

- Split a bill equally across the group
- Switch to itemized mode and enter custom amounts per person
- Apply preset tip percentages or enter a custom tip
- Add, rename, and remove people from the split
- See unassigned or over-assigned amounts in itemized mode
- Share the final breakdown with the system share sheet

## Built With

- Flutter
- Riverpod
- Google Fonts
- `share_plus`

## Getting Started

### Prerequisites

- Flutter SDK
- A device, simulator, or emulator for iOS, Android, macOS, Windows, Linux, or web

### Run Locally

```bash
flutter pub get
flutter run
```

## Project Structure

```text
lib/
  core/design_system/      App colors, spacing, typography, theme
  features/split/
    model/                 Domain models for people and split results
    view/                  Main split screen
    viewmodel/             State management and split calculations
    widgets/               Reusable UI components for the split flow
```

## Roadmap Ideas

- Save recent splits
- Export a receipt-style summary
- Multi-currency formatting
- Persistent group presets

## Repository

GitHub: <https://github.com/Sadoge/quicksplit>

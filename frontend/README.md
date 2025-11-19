# Bloom Scroll Frontend

Flutter mobile application for the Bloom Scroll content aggregator.

## Features

- **Masonry Grid Layout**: Dynamic tile layout adapting to content aspect ratios
- **Skeleton Screens**: Reduced anxiety with gray-box placeholders
- **Interactive Charts**: D3-like visualizations for OWID data
- **Perspective Overlay**: Swipe to reveal bias analysis and data context
- **Finite Feeds**: Definitive "End" state after ~20 cards
- **Offline Support**: Local caching with Hive

## Tech Stack

- **Framework**: Flutter 3.0+
- **Language**: Dart
- **State Management**: BLoC pattern
- **Networking**: Dio + Retrofit
- **Local Storage**: Hive
- **Charts**: fl_chart

## Project Structure

```
frontend/
├── lib/
│   ├── main.dart                 # Application entry point
│   ├── app.dart                  # Root widget configuration
│   ├── core/
│   │   ├── config/               # App configuration
│   │   ├── theme/                # Theme definitions
│   │   └── utils/                # Utility functions
│   ├── data/
│   │   ├── models/               # Data models
│   │   ├── repositories/         # Data layer
│   │   └── datasources/          # API clients
│   ├── domain/
│   │   ├── entities/             # Business entities
│   │   └── usecases/             # Business logic
│   ├── presentation/
│   │   ├── screens/              # Screen widgets
│   │   ├── widgets/              # Reusable UI components
│   │   └── blocs/                # BLoC state management
│   └── services/
│       ├── api/                  # API service layer
│       ├── storage/              # Local storage
│       └── navigation/           # Routing
├── assets/
│   ├── images/
│   ├── icons/
│   └── fonts/
├── test/                         # Unit & widget tests
├── integration_test/             # Integration tests
├── pubspec.yaml
└── README.md
```

## Getting Started

### Prerequisites

- Flutter SDK 3.0+
- Dart SDK 3.0+
- Android Studio / Xcode (for mobile development)

### Installation

```bash
# Install dependencies
flutter pub get

# Generate code (for models, API clients, etc.)
flutter pub run build_runner build --delete-conflicting-outputs

# Run on emulator/device
flutter run

# Run on specific device
flutter run -d <device_id>
```

### Development

```bash
# Run tests
flutter test

# Run with coverage
flutter test --coverage

# Run integration tests
flutter test integration_test

# Analyze code
flutter analyze

# Format code
dart format .
```

### Build

```bash
# Build APK (Android)
flutter build apk --release

# Build App Bundle (Android)
flutter build appbundle --release

# Build iOS
flutter build ios --release
```

## Key Widgets

### Masonry Grid
```dart
// lib/widgets/masonry_grid.dart
StaggeredGridView.countBuilder(
  crossAxisCount: 2,
  itemCount: cards.length,
  itemBuilder: (context, index) => BloomCard(card: cards[index]),
  staggeredTileBuilder: (index) => StaggeredTile.fit(1),
)
```

### Skeleton Screen
```dart
// lib/widgets/skeleton_screen.dart
Shimmer.fromColors(
  baseColor: Colors.grey[300]!,
  highlightColor: Colors.grey[100]!,
  child: Container(/* placeholder */),
)
```

### Interactive Chart
```dart
// lib/widgets/owid_chart.dart
LineChart(
  LineChartData(
    lineBarsData: [/* OWID data series */],
    titlesData: /* axis labels */,
  ),
)
```

## Configuration

### API Endpoint
Edit `lib/core/config/api_config.dart`:
```dart
class ApiConfig {
  static const String baseUrl = 'http://localhost:8000/api/v1';
  static const Duration timeout = Duration(seconds: 30);
}
```

### Theme
Edit `lib/core/theme/app_theme.dart` for colors, typography, spacing.

## State Management

Using BLoC pattern:
```dart
// Event
class LoadFeedEvent extends FeedEvent {}

// State
class FeedLoadedState extends FeedState {
  final List<BloomCard> cards;
  FeedLoadedState(this.cards);
}

// BLoC
class FeedBloc extends Bloc<FeedEvent, FeedState> {
  FeedBloc() : super(FeedInitialState()) {
    on<LoadFeedEvent>(_onLoadFeed);
  }
}

// Usage in widget
BlocProvider(
  create: (context) => FeedBloc()..add(LoadFeedEvent()),
  child: FeedScreen(),
)
```

## Testing

```bash
# Unit tests
flutter test test/unit

# Widget tests
flutter test test/widget

# Integration tests
flutter drive --target=test_driver/app.dart
```

## Architecture

Following Clean Architecture principles:
- **Presentation Layer**: UI components, BLoCs
- **Domain Layer**: Business logic, entities
- **Data Layer**: Repositories, API clients, local storage

## Performance

- Lazy loading for feed items
- Image caching with `cached_network_image`
- Debouncing for search/filter inputs
- Hive for fast local storage

## Accessibility

- Semantic labels for screen readers
- High contrast mode support
- Minimum touch target size: 48x48
- Keyboard navigation support

## Contributing

1. Create feature branch
2. Write tests
3. Run `flutter analyze` and `flutter test`
4. Submit PR

## License

Proprietary - Bloom Scroll Team

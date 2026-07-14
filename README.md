# VibeTune Flutter App

A high-quality, responsive Flutter app inspired by [vibetune-a.vercel.app](https://vibetune-a.vercel.app/).

## Features
- 🔥 Dark neon aesthetic matching the original site
- 🎵 Home screen with hero carousel, top charts, trending tracks & fresh drops
- 🔍 Explore screen with search + genre filtering
- 📊 Charts screen with artist/track/rising tabs
- 💬 Community screen with posts & engagement
- 📱 Responsive grid layout (2-6 columns based on screen width)
- 🖼️ Cached network images with shimmer loading

## Getting Started

### Prerequisites
- Flutter SDK 3.x
- Dart 3.x

### Install & Run
```bash
flutter pub get
flutter run
```

### Build APK
```bash
flutter build apk --release
```

### Build iOS
```bash
flutter build ios --release
```

## Project Structure
```
lib/
  main.dart               # Entry point
  theme/
    app_theme.dart        # Colors, typography, theme
  models/
    models.dart           # Data models
  data/
    app_data.dart         # Mock data
  widgets/
    widgets.dart          # Reusable components
  screens/
    app_shell.dart        # Bottom nav shell
    home_screen.dart      # Home with hero, charts, tracks
    explore_screen.dart   # Search & filter artists
    charts_screen.dart    # Tabbed rankings
    community_screen.dart # Social feed
```

## Tech Stack
- `cached_network_image` - Image caching + shimmer placeholders
- `carousel_slider` - Hero carousel
- `smooth_page_indicator` - Dot indicators
- `google_fonts` - Space Grotesk typography
- `shimmer` - Loading skeletons

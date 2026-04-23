# TaskFlow

A comprehensive project management tool for individuals and small teams built with Flutter.

## Building the Windows Executable

Since Visual Studio C++ tools cannot be installed in this environment, we use GitHub Actions to automatically build the Windows executable.

### Quick Start (Recommended)

1. Create a GitHub repository at [github.com/new](https://github.com/new)
2. Run the setup script:
   ```powershell
   cd C:\taskflow
   .\push_to_github.ps1
   ```
3. Enter your repository URL when prompted
4. Wait for the GitHub Actions workflow to complete
5. Download the executable from the Actions tab

For detailed instructions, see [BUILD_INSTRUCTIONS.md](BUILD_INSTRUCTIONS.md)

### Manual Build (Requires Visual Studio)

If you have Visual Studio installed locally:

```powershell
cd C:\taskflow
flutter pub get
flutter build windows --release
```

The executable will be at: `build\windows\runner\Release\TaskFlow.exe`

## Features

- Task management with categories and priorities
- Calendar integration with task deadlines
- Progress tracking and statistics
- Responsive design for different screen sizes
- Local storage with Hive
- Cross-platform (Windows, macOS, Web, Android, iOS)

## Development

This project uses:
- Flutter 3.29.3
- Dart 3.7.2
- Riverpod for state management
- Hive for local storage
- Table Calendar for calendar views

## Dependencies

Key dependencies:
- `flutter_riverpod: ^2.4.9` - State management
- `hive: ^2.2.3` - Local storage
- `intl: 0.19.0` - Internationalization
- `table_calendar: ^3.0.9` - Calendar widget
- `fl_chart: ^0.63.0` - Charts and statistics

**Note**: The `intl` package is pinned to version 0.19.0 due to Flutter SDK compatibility requirements.

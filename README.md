# flutter_structure

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

```
├ (Vertical and Right)
└ (Corner/Last item)
│ (Vertical line)
─ (Horizontal line)
```

### Generate Localizations
---

run both command one by one

1. flutter pub add flutter_localizations --sdk=flutter
2. flutter pub add intl:any

Open the pubspec.yaml file and enable the generate flag. This flag is found in the flutter section in the pubspec file.

```
# The following section is specific to Flutter.
flutter:
  generate: true # Add this line
```

Add a new yaml file to the root directory of the Flutter project. Name this file l10n.yaml and include the following content:

```
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

In ${FLUTTER_PROJECT}/lib/l10n, add the app_en.arb template file. For example:
`app_en.arb`
```
{
  "helloWorld": "Hello World!"
}
```

In ${FLUTTER_PROJECT}/lib/l10n, add the app_ar.arb template file. For example:
`app_ar.arb`
```
{
  "helloWorld": "مرحبا بالعالم!"
}
```

Now, run `flutter pub get` or `flutter run` and codegen takes place automatically. You should find generated files in the directory at the path you specified with the arb-dir or output-dir options Alternatively, you can also run `flutter gen-l10n` to generate the same files without running the app.

add import in main.dart

```
import 'package:flutter_localizations/flutter_localizations.dart';
```

add this in main.dart

```
return const MaterialApp(
    title: 'Localizations Sample App',
    debugShowCheckedModeBanner: false,
    localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    // supportedLocales: [
    //   Locale('en'), // English
    //   Locale('ar'), // Arabic
    // ],
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    //locale: const Locale('ar'), // for default language
  home: MyHomePage(),
);
```

**When Add any new localize run this command for generate string**

```
flutter gen-l10n
```

### Add Environment Variables
---

create env folder in root directory and add production.json and development.json files

```
root/
├──env/
│   ├── development.json
│   └── production.json
```
`
`development.json`

```json
{
  "API_URL": "https://dev.api.com",
  "APP_NAME": "MyApp Dev",
  "IS_PRODUCTION": false
}
```

`production.json`

```json
{
  "API_URL": "https://api.com",
  "APP_NAME": "MyApp",
  "IS_PRODUCTION": true
}
```

create launch.json file in .vscode folder

`launch.json`

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Run Debug (Dev)",
      "request": "launch",
      "type": "dart",
      "flutterMode": "debug",
      "args": [
        "--dart-define-from-file",
        "env/development.json"
      ]
    },
    {
      "name": "Run Release (Prod)",
      "request": "launch",
      "type": "dart",
      "flutterMode": "release",
      "args": [
        "--dart-define-from-file",
        "env/production.json"
      ]
    }
  ]
}
```

create env_config.dart file in lib/config folder

`env_config.dart`

```
class EnvConfig {
  static const apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://dev-api.com',
    );
  static const appName = String.fromEnvironment(
    'APP_NAME',
     defaultValue: 'My App (Local)',
    );

  static const bool isProduction = bool.fromEnvironment(
    'IS_PRODUCTION',
    defaultValue: false,);
}

```

**When Add any new environment variable run this command for generate string**

**Run Release (Prod)**
```
flutter run --dart-define-from-file=env/production.json
```

**Run Debug (Dev)**

```
flutter run --dart-define-from-file=env/development.json
```

**For Android**
```
flutter build apk --dart-define-from-file=env/production.json
```

**For iOS**
```
flutter build ios --dart-define-from-file=env/production.json
```

| Type | Command |
| :---: | :--- |
| Debug Mode | flutter run --dart-define-from-file=env/development.json |
| Release Mode | flutter run --release --dart-define-from-file=env/production.json |
| Build APK | flutter build apk --dart-define-from-file=env/production.json |
| Build iOS | flutter build ios --dart-define-from-file=env/production.json |


## Next Task

1. Font Implementation
2. 

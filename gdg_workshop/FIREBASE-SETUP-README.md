# Firebase AI Setup for Flutter - Complete Guide

This guide walks you through setting up Firebase AI (Gemini) integration for your Flutter project, including all necessary tools and configurations.

## Prerequisites

Before starting, ensure you have the following installed:
- **Flutter SDK** - [Download here](https://flutter.dev/docs/get-started/install)
- **Node.js v18.0.0 or later** - [Download here](https://nodejs.org/)
- **Visual Studio Code** with Flutter extension
- **Git** for version control


## Step 1: Set Up Firebase Project

### 1.1 Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project" or "Get started with a Firebase project"
3. Enter your project name (e.g., `flutter-ai-test-1`)
4. Accept Firebase terms
5. Configure Google Analytics (optional but recommended)
6. Click "Create project"

### 1.2 Configure AI Logic (Gemini API)
1. In Firebase Console, navigate to "AI Logic" (marked as NEW)
2. Choose your Gemini API provider:
   - **Gemini Developer API**: Free tier with generous quota
   - **Vertex AI Gemini API**: Enterprise-grade with advanced features

3. Click "Get started with this API"
4. Set up billing account if prompted
5. Enable required APIs
6. Optionally enable AI monitoring for performance insights

## Step 2: Install Required Tools

### 2.1 Install Node.js and npm
Firebase CLI requires Node.js and npm to be installed globally.

1. **Download and install Node.js** from [https://nodejs.org/en](https://nodejs.org/en)
   - Choose the LTS (Long Term Support) version
   - This automatically installs npm (Node Package Manager)

2. **Verify installation:**
   ```bash
   node --version
   npm --version
   ```

### 2.2 Install Firebase CLI
**Important:** You must use the npm installation method for FlutterFire compatibility. Other installation methods (standalone binary, etc.) will not work with the `flutterfire` command as it requires the globally available `firebase` command.

```bash
npm install -g firebase-tools
```

> **Note:** If you encounter permission errors, run with `sudo` on macOS/Linux or as Administrator on Windows.

**Verify Firebase CLI installation:**
```bash
firebase --version
```

For more installation options and troubleshooting, visit the [Firebase CLI documentation](https://firebase.google.com/docs/cli).

### 2.3 Install FlutterFire CLI
```bash
dart pub global activate flutterfire_cli
```

## Step 3: Set Up Flutter Project

### 3.1 Create Flutter Project
```bash
flutter create your_app_name
cd your_app_name
```

### 3.2 Install Flutter SDK (if needed)
If you see the "Could not find a Flutter SDK" error:
1. Download Flutter SDK from the official website
2. Extract and add to your PATH
3. In VS Code, press `Cmd+Shift+P` (macOS) or `Ctrl+Shift+P` (Windows/Linux)
4. Search for "Flutter: Locate SDK" and select your Flutter installation

## Step 4: Configure Firebase for Flutter

### 4.1 Login to Firebase
```bash
firebase login
```

This will open a browser window for Google authentication. Allow Firebase CLI to access your Google Account.

### 4.2 Enable Gemini Features
When prompted during login:
```
? Enable Gemini in Firebase features? (Y/n) Y
```

### 4.3 Activate FlutterFire CLI
```bash
dart pub global activate flutterfire_cli
```

### 4.4 Set Up PATH for FlutterFire (macOS/Linux)
If you encounter path issues with FlutterFire CLI, add it to your PATH:

```bash
# Edit your shell configuration file
vim ~/.zshrc  # or ~/.bashrc for bash users

# Add this line to the file
export PATH="$PATH":"$HOME/.pub-cache/bin"

# Save and exit vim (press 'esc', then type ':wq!')
# Restart your terminal or source the file
source ~/.zshrc
```

### 4.5 Configure Firebase Project
Run this command at the root of your Flutter project:
```bash
flutterfire configure --project=your-project-id
```

Or simply:
```bash
flutterfire configure
```

The CLI will:
1. Detect your Firebase projects
2. Allow you to select platforms (android, ios, web, etc.)
3. Register your apps with Firebase
4. Generate a `lib/firebase_options.dart` configuration file

**Platform Selection:**
- Use arrow keys and space to select platforms
- ✅ Recommended: android, ios, web
- Press Enter to confirm selection

**Expected Output:**
```
✅ Firebase web app agentic_app_manager (web) registered.
Firebase configuration file lib/firebase_options.dart generated successfully
```

## Step 5: Add Firebase Dependencies

### 5.1 Install Firebase AI Logic SDK
From your Flutter project directory, run:
```bash
flutter pub add firebase_core && flutter pub add firebase_ai
```

Or manually add to your `pubspec.yaml`:
```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^2.24.2
  firebase_ai: ^0.3.0  # Firebase AI Logic SDK

dev_dependencies:
  flutter_test:
    sdk: flutter
```

Then run:
```bash
flutter pub get
```


## Step 6: Initialize Firebase in Your App

### 6.1 Update main.dart
```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase AI Demo',
      home: MyHomePage(),
    );
  }
}
```

### 6.2 Implement Firebase AI Logic Features
After completing the Firebase AI Logic setup in the console, you can start using AI features:

```dart
import 'package:firebase_ai/firebase_ai.dart';

class AIService {
  late final GenerativeModel _model;

  AIService() {
    // Initialize with Firebase AI Logic
    _model = FirebaseAI.instance.generativeModel(
      model: 'gemini-pro',
    );
  }

  Future<String> generateContent(String prompt) async {
    final content = [Content.text(prompt)];
    final response = await _model.generateContent(content);
    return response.text ?? '';
  }
}
```

## Step 7: Test Your Setup

### 7.1 Run the App
```bash
flutter run
```

### 7.2 Test AI Integration
Create a simple test to ensure everything is working:

```dart
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AIService _aiService = AIService();
  String _response = '';

  Future<void> _testAI() async {
    try {
      final response = await _aiService.generateContent('Hello, how are you?');
      setState(() {
        _response = response;
      });
    } catch (e) {
      setState(() {
        _response = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Firebase AI Test')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _testAI,
              child: Text('Test AI'),
            ),
            SizedBox(height: 20),
            Text(_response),
          ],
        ),
      ),
    );
  }
}
```

## Troubleshooting

### Flutter Doctor Check
Before starting, run this command to check your Flutter setup:
```bash
flutter doctor
```

This will show you what's missing in your development environment. You only need to see that,
- ✅ Flutter SDK installed correctly
- ✅ VS Code with Flutter extension

### Common Issues

1. **Permission Errors with npm**
   ```bash
   sudo npm install -g firebase-tools
   ```

2. **Flutter SDK Not Found**
   - Download Flutter SDK from official website
   - Add Flutter to your PATH
   - Use "Flutter: Locate SDK" in VS Code

3. **FlutterFire CLI Not Found (PATH Issues)**
   ```bash
   # Add to ~/.zshrc or ~/.bashrc
   export PATH="$PATH":"$HOME/.pub-cache/bin"
   
   # Then restart terminal or run:
   source ~/.zshrc
   ```

4. **Firebase Login Issues**
   - Ensure you're using the correct Google account
   - Check internet connectivity
   - Try `firebase logout` then `firebase login` again

5. **Android SDK Missing (if developing for Android)**
   - Install Android Studio from: https://developer.android.com/studio/
   - Run `flutter doctor` to check setup status
   - Use `flutter config --android-sdk path/to/sdk` if needed

6. **Xcode Issues (if developing for iOS on macOS)**
   - Install Xcode from Mac App Store
   - Complete Xcode installation as prompted
   - Accept Xcode license agreements

7. **Billing Required**
   - Vertex AI requires Blaze plan (pay-as-you-go)
   - Firebase AI Logic provides some free usage
   - Monitor usage in Firebase Console

8. **Ruby/xcodeproj Error (macOS)**
   - This is a common macOS setup issue
   - The FlutterFire configure command may show Ruby errors but usually still completes successfully
   - Check if `lib/firebase_options.dart` was generated despite the error

## Next Steps

1. **Explore Advanced Features**
   - Multi-modal AI (text + images)
   - Function calling
   - Streaming responses

2. **Production Considerations**
   - Set up proper error handling
   - Implement rate limiting
   - Add user authentication
   - Monitor API usage and costs

3. **Security**
   - Never expose API keys in client code
   - Use Firebase Security Rules
   - Implement proper user authentication

## Resources

- [Firebase AI Documentation](https://firebase.google.com/docs/ai)
- [Flutter Firebase Documentation](https://firebase.flutter.dev/)
- [Gemini API Documentation](https://ai.google.dev/docs)
- [FlutterFire GitHub Repository](https://github.com/firebase/flutterfire)

---

**Note**: This setup process may vary slightly depending on your specific requirements and the latest updates from Firebase and Flutter teams. Always refer to the official documentation for the most current information.
# Flutter Shape Journal Workshop - Stage Breakdown

## Starter Code (Provided)
**What I provide to workshoppers**:
- `Shape` class (shape.dart)
- `ShapedContainer` widget (shaped_container.dart)
- Basic UI setup with empty shapes list

```dart
import 'package:flutter/material.dart';
import 'shaped_container.dart';
import 'shape.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<Shape> shapes;
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    shapes = []; // Start with empty list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Text input row
          Row(
            children: [
              Flexible(
                child: TextField(
                  decoration: InputDecoration(labelText: 'Enter Journal'),
                  controller: controller,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // TODO: Handle submission
                },
                child: Text('Submit'),
              ),
            ],
          ),
          SizedBox(height: 20),
          // Shape display area
          Expanded(
            child: Stack(
              children: shapes.map((shape) {
                return Positioned(
                  top: shape.top,
                  left: shape.left,
                  child: ShapedContainer(
                    width: shape.width,
                    height: shape.height,
                    R: shape.R,
                    a: shape.a,
                    n: shape.n,
                    color: shape.color,
                    rotationLen: shape.rotationLen,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
```

---

## Stage 1: Create AI Agent Class
**Goal**: Build the AppAgent class to analyze journal entries using Firebase AI

**Dependencies to add**:
```yaml
dependencies:
  firebase_ai: ^0.3.4
```

**What workshoppers create** (`app_agent.dart`):
```dart
import 'package:firebase_ai/firebase_ai.dart';

class AppAgent {
  late ChatSession chat;

  final gemini = FirebaseAI.vertexAI().generativeModel(
    model: 'gemini-2.0-flash',
    systemInstruction: Content.text('''
     You are a journal analyzer. You will be given excerpts from a journal entry.
     You must give a json object with the following keys:
      - summary: A brief summary of the excerpt.
      - color: A color that represents the mood of the excerpt, must in format (e.g. 0xFFFF5733).
      - keywords: A list of keywords that represent the main topics of the excerpt.
      - intensity: On a scale of 1.0 to 10.0, how intense are the emotions of the excerpt.
      - emotion: On a scale of 1 to 10, 1 being happy/calm and 10 being sad/angry, what is the emotion of the excerpt.
    '''),
  );
  
  // Initialize the chat session
  void initialize() {
    chat = gemini.startChat();
  }

  void reset() {
    initialize();
  }

  Future<String> processJournal(String message) async {
    try {
      final response = await chat.sendMessage(Content.text(message));
      return response.text ?? 'No response received';
    } catch (e) {
      return 'Error: $e';
    }
  }
}
```

**Test integration** (add to Home class):
```dart
// Add to class variables
late AppAgent appAgent;

// Add to initState
@override
void initState() {
  super.initState();
  shapes = [];
  appAgent = AppAgent();
  appAgent.initialize();
}

// Add method to handle AI processing
void handleButtonPress() async {
  String journalText = controller.text.trim();
  
  if (journalText.isNotEmpty) {
    print('Processing: $journalText');
    
    try {
      String response = await appAgent.processJournal(journalText);
      print('AI Response: $response');
      
      // Clear the text field after processing
      controller.clear();
    } catch (e) {
      print('Error processing journal: $e');
    }
  } else {
    print('Journal text is empty');
  }
}

// Connect to button
onPressed: handleButtonPress,
```

**Learning objectives**:
- Firebase AI integration
- System instruction design
- Chat session management
- Async programming fundamentals
- Error handling patterns

---

## Stage 2: JSON Response Parsing & Shape Creation
**Goal**: Parse AI response and create shapes based on the data

**Additional imports needed**:
```dart
import 'dart:convert';
import 'dart:math';
import 'app_agent.dart';
```

**What workshoppers modify** (update `handleButtonPress` method):
```dart
void handleButtonPress() async {
  String journalText = controller.text.trim();
  
  if (journalText.isNotEmpty) {
    print('Processing: $journalText');
    
    try {
      String response = await appAgent.processJournal(journalText);
      print('AI Response: $response');
      
      // Clean up the response (remove markdown formatting)
      var cleanResponse = response
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .replaceAll('`', '');
      print('Cleaned Response: $cleanResponse');
      
      // Parse JSON response
      var jsonResponse = jsonDecode(cleanResponse);
      print('Parsed JSON: $jsonResponse');
      
      // Create shape from AI response
      var shapeSize = Random().nextDouble() * 200 + 100;
      Shape newShape = Shape(
        R: 25,
        a: jsonResponse['intensity'] ?? 2,
        n: jsonResponse['emotion'] ?? 3,
        width: shapeSize,
        height: shapeSize,
        color: Color(int.parse(jsonResponse['color'])),
        rotationLen: 11 - (jsonResponse['intensity']?.toInt() ?? 5),
        top: Random().nextInt(500).toDouble(),
        left: Random().nextInt(500).toDouble(),
      );
      
      // Add shape to the display
      setState(() {
        shapes.add(newShape);
      });
      
      controller.clear();
    } catch (e) {
      print('Error processing journal: $e');
    }
  } else {
    print('Journal text is empty');
  }
}
```

**Learning objectives**:
- JSON parsing with jsonDecode
- String manipulation and cleaning
- Null-safe programming with ?? operator
- Color parsing from hex strings
- Mathematical mapping (intensity to rotation)
- Random number generation
- State management with setState

---

## Stage 3: Image Generation (Advanced)
**Goal**: Add AI-generated images to shapes

**What I provide**:
- `AIImageGenerator` class (image_generator.dart)

**What workshoppers add**:
```dart
// Add to class variables
late AIImageGenerator imageGenerator;

// Modify handleButtonPress to include conditional image generation
// Add this code after creating newShape but before setState:
if (Random().nextBool()) {
  print('Generating image for: $journalText');
  imageGenerator = AIImageGenerator();
  
  try {
    List<Uint8List> images = await imageGenerator.generateImages(journalText);
    
    if (images.isNotEmpty) {
      newShape.child = Image.memory(images[0], fit: BoxFit.cover);
      print('Image generated successfully');
    } else {
      print('No images generated');
    }
  } catch (e) {
    print('Error generating image: $e');
  }
}
```

**Additional import needed**:
```dart
import 'dart:typed_data';
import 'image_generator.dart';
```

**Learning objectives**:
- Image handling in Flutter
- Memory management with Uint8List
- Conditional feature execution
- Image display with Image.memory

---
## Stage 4: Speech to Text Integration (optional)
**Goal**: Add voice input capability

**Dependencies to add**:
```yaml
dependencies:
  speech_to_text: ^6.1.1
```

**What students add**:
```dart
// Add to class variables
final _speechToText = SpeechToText();
bool _speechEnabled = false;

// Add to initState (after existing code)
_initSpeech();

// Add speech methods
void _initSpeech() async {
  _speechEnabled = await _speechToText.initialize();
  setState(() {});
}

void _startListening() async {
  await _speechToText.listen(onResult: _onSpeechResult);
  setState(() {});
}

void _stopListening() async {
  await _speechToText.stop();
  setState(() {});
}

void _onSpeechResult(SpeechRecognitionResult result) {
  setState(() {
    controller.text = result.recognizedWords;
  });
}
```

**UI Addition**:
```dart
// Add to button column (after Submit button)
_speechEnabled ? ElevatedButton(
  onPressed: _speechToText.isNotListening ? _startListening : _stopListening,
  child: Text(_speechToText.isNotListening ? 'Record' : 'Stop'),
) : Text("No mic access"),
```

**Additional import needed**:
```dart
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
```

**Learning objectives**:
- External package integration
- Async programming
- Platform permissions
- Real-time text updates

---

## Workshop Structure Recommendations

**Time allocation**:
- Stage 1: 15 minutes (AI Agent Creation & Integration)
- Stage 2: 30 minutes (JSON Parsing & Shape Creation)  
- Stage 3: 20 minutes (Image Generation)
- Stage 4: 10 minutes (Speech-to-Text)

**Total workshop time**: ~75 minutes

**Prerequisites**:
- Basic Flutter knowledge
- Understanding of Dart syntax
- Familiarity with state management

**Materials needed**:
- Flutter development environment
- API keys for AI services
- Sample Shape and ShapedContainer implementations
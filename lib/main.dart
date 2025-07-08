import 'dart:convert'; // Used for decoding JSON data.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Used for accessing platform services like rootBundle.

// The main entry point of the application.
void main() {
  runApp(const MyApp());
}

// The root widget of the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Viewer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Sets the home page of the app to be an instance of MyHomePage.
      home: const MyHomePage(title: 'Image Viewer'),
    );
  }
}

// The main screen of the application, which is a stateful widget.
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // The title displayed in the AppBar.
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// The state for the MyHomePage widget.
class _MyHomePageState extends State<MyHomePage> {
  // A list to hold the paths of the image assets. It's initially empty.
  List<String> _imageAssets = [];
  // The index of the currently displayed image in the _imageAssets list.
  int _currentImageIndex = 0;
  // A flag to indicate whether the images are currently being loaded.
  bool _isLoading = true;

  // This method is called when the widget is first inserted into the widget tree.
  @override
  void initState() {
    super.initState();
    // Start loading the images as soon as the app starts.
    _loadImages();
  }

  // Asynchronously loads all image paths from the 'assets/images/' directory.
  Future<void> _loadImages() async {
    // Load the AssetManifest.json file, which contains a list of all assets.
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    // Decode the JSON string into a Map.
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    // Filter the map keys to get only the paths that start with 'assets/images/'.
    final imagePaths = manifestMap.keys
        .where((String key) => key.startsWith('assets/images/'))
        .toList();

    // Update the state with the loaded image paths and set loading to false.
    // This will trigger a rebuild of the widget to display the images.
    setState(() {
      _imageAssets = imagePaths;
      _isLoading = false;
    });
  }

  // Switches to the next image in the list.
  void _switchImage() {
    // Calling setState notifies Flutter that the state has changed and the UI needs to be updated.
    setState(() {
      // Increment the index and use the modulo operator to loop back to the beginning
      // if the end of the list is reached.
      _currentImageIndex = (_currentImageIndex + 1) % _imageAssets.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      // The main content of the screen.
      body: Center(
        // Conditionally display a widget based on the loading state and image list.
        child: _isLoading
            // If images are loading, show a progress indicator.
            ? const CircularProgressIndicator()
            // If loading is finished but no images were found, show a message.
            : _imageAssets.isEmpty
            ? const Text('No images found in assets/images/')
            // If images are loaded, display the current image.
            : Image.asset(_imageAssets[_currentImageIndex]),
      ),
      floatingActionButton: FloatingActionButton(
        // The button is disabled if there are 1 or fewer images to switch between.
        onPressed: _imageAssets.length > 1 ? _switchImage : null,
        tooltip: 'Switch Image',
        child: const Icon(Icons.swap_horiz),
      ),
    );
  }
}

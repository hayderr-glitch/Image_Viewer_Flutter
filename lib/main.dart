import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Viewer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Image Viewer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> _imageAssets = [];
  int _currentImageIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final imagePaths = manifestMap.keys
        .where((String key) => key.startsWith('assets/images/'))
        .toList();

    setState(() {
      _imageAssets = imagePaths;
      _isLoading = false;
    });
  }

  void _switchImage() {
    setState(() {
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
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _imageAssets.isEmpty
            ? const Text('No images found in assets/images/')
            : Image.asset(_imageAssets[_currentImageIndex]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _imageAssets.length > 1 ? _switchImage : null,
        tooltip: 'Switch Image',
        child: const Icon(Icons.swap_horiz),
      ),
    );
  }
}

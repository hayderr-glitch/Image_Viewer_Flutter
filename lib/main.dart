import 'package:flutter/material.dart';

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
  final List<String> _imageAssets = [
    'assets/images/image1.jpg',
    'assets/images/image2.jpg',
  ];
  int _currentImageIndex = 0;

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
      body: Center(child: Image.asset(_imageAssets[_currentImageIndex])),
      floatingActionButton: FloatingActionButton(
        onPressed: _switchImage,
        tooltip: 'Switch Image',
        child: const Icon(Icons.swap_horiz),
      ),
    );
  }
}

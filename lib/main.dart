import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Audio and Image Picker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Pick and Play'),
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
  File? _imageFile;
  String? _audioPath;
  final AudioPlayer _audioPlayer = AudioPlayer();

  // 选择图片
  Future<void> _pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null && result.files.single.path != null) {
        setState(() {
          _imageFile = File(result.files.single.path!);
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  // 选择音频
  Future<void> _pickAudio() async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.audio);
      if (result != null && result.files.single.path != null) {
        setState(() {
          _audioPath = result.files.single.path!;
        });
      }
    } catch (e) {
      print("Error picking audio: $e");
    }
  }

  // 播放音频
  Future<void> _playAudio() async {
    if (_audioPath != null) {
      try {
        await _audioPlayer.setFilePath(_audioPath!);
        await _audioPlayer.play();
      } catch (e) {
        print("音频播放失败: $e");
      }
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // 显示选择的图片
            if (_imageFile != null)
              Image.file(
                _imageFile!,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              )
            else
              const Text('请选择一张图片'),
            const SizedBox(height: 20),

            // 图片选择按钮
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text("选择图片"),
            ),

            const SizedBox(height: 20),

            // 音频选择按钮
            ElevatedButton(
              onPressed: _pickAudio,
              child: const Text("选择音频"),
            ),

            // 播放按钮
            if (_audioPath != null)
              ElevatedButton(
                onPressed: _playAudio,
                child: const Text("播放音频"),
              ),
          ],
        ),
      ),
    );
  }
}

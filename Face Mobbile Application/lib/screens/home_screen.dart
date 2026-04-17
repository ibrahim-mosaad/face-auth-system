import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/api_service.dart';
import '../widgets/result_card.dart';
import '../widgets/face_painter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _image;
  String? _resultImage;
  List faces = [];
  bool loading = false;

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source);

    if (picked != null) {
      setState(() {
        _image = File(picked.path);
        _resultImage = null;
        faces = [];
      });
    }
  }

  Future<void> recognize() async {
    if (_image == null) return;

    setState(() => loading = true);

    final response = await ApiService.recognizeFace(_image!);

    setState(() {
      _resultImage = response["image"];
      faces = response["faces"];
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [

                const Text(
                  "Face Recognition",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                /// Image Preview
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: _image == null
                      ? const Center(
                    child: Icon(Icons.image, size: 80, color: Colors.white54),
                  )
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.file(_image!, fit: BoxFit.cover),
                  ),
                ),

                const SizedBox(height: 20),

                /// Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => pickImage(ImageSource.camera),
                        icon: const Icon(Icons.camera),
                        label: const Text("Camera"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => pickImage(ImageSource.gallery),
                        icon: const Icon(Icons.image),
                        label: const Text("Gallery"),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// Recognize Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _image == null ? null : recognize,
                    child: const Text("Recognize Face"),
                  ),
                ),

                const SizedBox(height: 20),

                /// Loading
                if (loading)
                  Column(
                    children: const [
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(height: 10),
                      Text("Processing...",
                          style: TextStyle(color: Colors.white70))
                    ],
                  ),

                /// Result Image + Bounding Boxes
                if (_resultImage != null) ...[
                  const SizedBox(height: 20),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: 1,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.memory(
                            base64Decode(_resultImage!),
                            height: 250,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned.fill(
                          child: CustomPaint(
                            painter: FacePainter(faces),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                /// Results
                if (faces.isNotEmpty)
                  Column(
                    children: faces
                        .map((face) => ResultCard(face: face))
                        .toList(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
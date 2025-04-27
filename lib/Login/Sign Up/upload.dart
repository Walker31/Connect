import 'dart:io';
import 'package:connect/Login/success_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:reorderable_grid/reorderable_grid.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import '../../Backend/auth.dart';
import '../../Backend/images.dart';
import '../../Components/back.dart';

class UploadImage extends StatefulWidget {
  final Map<String, dynamic> formdata;

  const UploadImage({super.key, required this.formdata});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  final ImagePicker _picker = ImagePicker();
  final List<File?> _images = List.filled(6, null);
  Logger logger = Logger();
  bool _isUploading = false;

  Future<void> _pickImage(int index) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _images[index] = File(pickedFile.path);
      });
    }
  }

  Future<void> _register() async {
    _uploadImages();
  }

  Future<void> _uploadImages() async {
    if (_images.every((image) => image == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select at least one image to upload')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    List<String> uploadedUrls = [];
    for (var image in _images) {
      if (image != null) {
        bool success = await ImageUploadService.uploadImage(image);
        if (success) {
          uploadedUrls.add(image.path);
        }
      }
    }

    if (uploadedUrls.isNotEmpty) {
      widget.formdata['uploadedImages'] = uploadedUrls;
      logger.d(widget.formdata);
      await _signupUser();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image upload failed!')),
      );
    }

    setState(() {
      _isUploading = false;
    });
  }

  Future<void> _signupUser() async {
    final response = await Auth().signup(context, widget.formdata);

    if (response.statusCode == 200) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const SuccessPage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signup failed: ${response.body}')),
      );
    }
  }

  void _reorderImages(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final File? movedImage = _images.removeAt(oldIndex);
      _images.insert(newIndex, movedImage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              backgroundColor: Colors.red.shade900,
              foregroundColor: Colors.white,
              onPressed: _isUploading ? null : _register,
              child: _isUploading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Icon(Icons.done),
            ),
            const SizedBox(
              height: 40,
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: AppBar(
        leading: const Back(),
        title: const Text('Upload Your Photos'),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.all(4),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: ReorderableGridView.builder(
                  onReorder: _reorderImages,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      key: ValueKey(index),
                      onTap: () => _pickImage(index),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: _images[index] != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  _images[index]!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(Icons.add_a_photo,
                                size: 50, color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  StepProgressIndicator(
                    currentStep: 6,
                    totalSteps: 6,
                    size: 10,
                    selectedColor: Colors.red.shade900,
                    unselectedColor: const Color.fromARGB(255, 116, 97, 97),
                    roundedEdges: const Radius.circular(10),
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Step 6'),
                      Text('Step 6'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

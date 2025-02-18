import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import '../../Backend/auth.dart';
import '../../Backend/images.dart';
import '../../Base Scaffold/base.dart';
import '../../Components/back.dart';
import '../../Model/profile.dart';

class UploadImage extends StatefulWidget {
  final Map<String, dynamic> formdata;

  const UploadImage({super.key, required this.formdata});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  final List<File> _selectedImages = [];
  final ImagePicker picker = ImagePicker();
  Logger logger = Logger();
  bool isLoading = false;
  bool _isUploading = false;

  Future<void> pickImages() async {
    final List<XFile> pickerFiles = await picker.pickMultiImage();
    setState(() {
      _selectedImages.addAll(pickerFiles.map((file) => File(file.path)));
    });
  }

  Future<void> _uploadImages() async {
    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select images to upload')));
      return;
    }

    setState(() {
      _isUploading = true;
    });

    bool success = true;
    for (var image in _selectedImages) {
      bool result = await ImageUploadService.uploadImage(image);
      if (!result) {
        success = false;
      }
    }

    if (success) {
      setState(() {
        widget.formdata['uploadedImageUrls'] =
            _selectedImages.map((image) => image.path).toList();
      });

      logger.d('Uploaded Images: ${widget.formdata['uploadedImageUrls']}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Images uploaded successfully!')),
      );
    } else {
      logger.e('Failed to upload images.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image upload failed.')),
      );
    }

    setState(() {
      _isUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: const Back(),
        title: const Text('Upload Your Photos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image Cards in a Wrap
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    ImageCard(isLarge: true, onImagePicked: pickImages),
                    ...List.generate(
                        5, (index) => ImageCard(onImagePicked: pickImages)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Step Progress Indicator
            StepProgressIndicator(
              currentStep: 6,
              selectedColor: Colors.red.shade900,
              totalSteps: 6,
              size: 10,
              unselectedColor: Colors.grey.shade300,
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
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: const Text('upload'),
              elevation: 4,
              foregroundColor: Colors.white,
              backgroundColor: Colors.red.shade900,
              onPressed: _isUploading ? null : _uploadImages,
              child: const Icon(Icons.cloud_upload),
            ),
            const SizedBox(height: 16),
            FloatingActionButton(
              heroTag: const Text('data'),
              elevation: 4,
              foregroundColor: Colors.white,
              backgroundColor: Colors.red.shade900,
              onPressed: _isUploading ? null : () => _showAlertDialog(context),
              child: const Icon(Icons.arrow_forward),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> signup() async {
    setState(() => isLoading = true);

    try {
      final profile = Profile(
        name: widget.formdata['name'],
        gender: widget.formdata['gender'],
        phoneNo: widget.formdata['phoneNumber'],
        password: widget.formdata['password'],
        age: widget.formdata['age'],
        interests: widget.formdata['interests'],
        pictures: widget.formdata['uploadedImageUrls'],
      );

      final auth = Auth();
      final response = await auth.signup(profile);

      setState(() => isLoading = false);

      if (response.statusCode == 200) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
          (route) => false,
        );
      } else {
        _showErrorDialog('Signup failed: ${response.body}');
      }
    } catch (e) {
      _showErrorDialog('An error occurred: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade500,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'You\'re Verified!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Your account is verified, let\'s start making friends!',
                style: TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade500,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                onPressed: () {
                  signup();
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const Home()),
                    (route) => false,
                  );
                },
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ImageCard extends StatelessWidget {
  final bool isLarge;
  final VoidCallback onImagePicked;

  const ImageCard(
      {super.key, this.isLarge = false, required this.onImagePicked});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade200,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: GestureDetector(
        onTap: onImagePicked,
        child: Container(
          height: isLarge ? 160 : 100,
          width: isLarge ? 160 : 100,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_a_photo,
                size: isLarge ? 50 : 40,
                color: Colors.grey.shade700,
              ),
              const SizedBox(height: 10),
              Text(
                'Tap to Add Photo',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

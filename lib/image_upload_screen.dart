import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:green_guard_app/service/image_picker_service.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadScreen extends StatefulWidget {
  const ImageUploadScreen({super.key});

  @override
  State<ImageUploadScreen> createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  Uint8List? image;

  void selectImage() async {
    Uint8List img = await ImagePickerSevice().pickImage(ImageSource.gallery);
    setState(() {
      image = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Hello world',
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        backgroundColor: const Color.fromARGB(255, 240, 255, 241),
        body: buildContent());
  }

  Widget buildContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'សូមបញ្ចូលរូបភាពរបស់អ្នកនៅទីនេះ',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 30,
          ),
          buildUploadButton(),
        ],
      ),
    );
  }

  Widget buildUploadButton() {
    return InkWell(
      child: Stack(
        children: const [
          CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 60,
            backgroundImage:
                NetworkImage('https://clipart-library.com/img/1846196.png'),
          ),
          Positioned(
            top: 40,
            left: 44,
            child: Icon(
              Icons.upload_file_outlined,
              size: 34,
            ),
          )
        ],
      ),
    );
  }
}

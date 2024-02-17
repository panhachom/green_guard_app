import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:green_guard_app/image_predict_success_screen.dart';
import 'package:green_guard_app/model/prediction_model.dart';
import 'package:green_guard_app/service/image_picker_service.dart';
import 'package:green_guard_app/service/image_uploader_service.dart';
import 'package:green_guard_app/widgets/cm_card.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class ImageUploadScreen extends StatefulWidget {
  const ImageUploadScreen({super.key});

  @override
  State<ImageUploadScreen> createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  File? _photo;

  Future<void> onPressedHandler(BuildContext context) async {
    ImagePickerService service = ImagePickerService();

    XFile? file = await service.call(context);

    if (file != null) {
      // Show loading dialog
      buildDialog(context);

      // Delay for 3 seconds
      await Future.delayed(const Duration(seconds: 2));

      Navigator.pop(context);
      _photo = File(file.path);
      List<PredictionModel> predictions =
          await ImageUploaderService.uploadImage(_photo);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ImagePredictSuccessScreen(
            predictions: predictions,
          ),
        ),
      );
    } else {
      if (kDebugMode) {
        print('There is Error Occur');
      }
    }
  }

  Future<dynamic> buildDialog(BuildContext context) {
    return showDialog(
      context: context, // Use the stored context
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          alignment: Alignment.center,
          content: Lottie.asset(
            'assets/images/loading.json',
            width: 85,
            height: 85,
          ),
        );
      },
    );
  }

  // Future uploadFile() async {
  //   if (_photo == null) return;
  //   final fileName = Path.basename(_photo!.path);
  //   final destination = 'files/$fileName';

  //   try {
  //     final ref = FirebaseStorage.instance.ref(destination).child('file/');
  //     await ref.putFile(_photo!);
  //     final downloadUrl = await ref.getDownloadURL();
  //     final bytes =
  //         await Dio().get(downloadUrl).then((response) => response.data);
  //     final imageProvider = NetworkImage(downloadUrl);
  //     Logger().d(imageProvider);
  //   } catch (e) {
  //     print(e);
  //     print('errr');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      body: buildContent(),
    );
  }

  Widget buildContent() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 85,
            ),
            buildUploadImageContent(),
            buildBlogContent()
          ],
        ),
      ),
    );
  }

  Widget buildBlogContent() {
    return Column(
      children: [
        const ListTile(
          leading: Icon(
            Icons.feed,
            size: 35,
            color: Color(0xFF4CAF50),
          ),
          title: Text(
            'ចំណេះដឹងថ្មីៗ ',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            'ស្វែងយល់បន្ថែមអំពីដំណើរនៃជំងឺនៅលើស្លឹកស្រូវ',
            style: TextStyle(fontSize: 13),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        SizedBox(
          height: 240,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            separatorBuilder: (context, index) {
              return const SizedBox(
                width: 10,
              );
            },
            itemCount: 3,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return CmCard(
                image: cardModels[index].image,
                title: cardModels[index].title,
                subtitle: cardModels[index].subtitle,
              );
            },
          ),
        )
      ],
    );
  }

  SizedBox buildCard() {
    return SizedBox(
      width: 260,
      height: 240,
      child: Card(
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
              child: Image.network(
                'https://www.kissanghar.pk/assets/img/insect_blogs/40371820220606214.png',
                height: 130,
                fit: BoxFit.fill,
                width: 260,
              ),
            ),
            const ListTile(
              title: Text('Brown Spot'),
              subtitle: Text(
                'The most Comon happen in Kampong Cham Province',
                style: TextStyle(fontSize: 12),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildUploadImageContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const ListTile(
          leading: Icon(
            Icons.note_alt_outlined,
            size: 35,
            color: Color(0xFF4CAF50),
          ),
          title: Text(
            'សូមបញ្ចូលរូបភាពរបស់អ្នកនៅទីនេះ',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
              'នេះគឺជា Weak AI ត្រូវប្រាកដថាបង្ហោះរូបភាពត្រឹមត្រូវ បើមិនដូច្នេះទេលទ្ធផលនឹងមិនត្រូវបានគេរំពឹងទុកនោះទេ',
              style: TextStyle(fontSize: 13)),
        ),
        const SizedBox(
          height: 30,
        ),
        DottedBorder(
          dashPattern: const [9, 9],
          color: const Color(0xFF4CAF50),
          // color: const Color.fromARGB(255, 173, 171, 171),
          strokeWidth: 1.5,
          child: Container(
            height: 260,
            width: 260,
            color: Colors.white,
            child: buildUploadImageButton(),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }

  Widget buildUploadImageButton() {
    return InkWell(
      onTap: () {
        onPressedHandler(context);
      },
      child: Stack(
        children: [
          Center(
            child: Image.asset('assets/images/leaf.webp'),
          ),
          const Positioned(
            bottom: 40,
            left: 170,
            child: Icon(
              Icons.add_photo_alternate_outlined,
              size: 35,
              color: Color(0xFFA5D6A7),
            ),
          )
        ],
      ),
    );
  }
}

class CardModel {
  final String image;
  final String title;
  final String subtitle;

  CardModel({required this.image, required this.title, required this.subtitle});
}

List<CardModel> cardModels = [
  CardModel(
    image:
        'data:image/jpeg;base64,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',
    title: 'Brown Spot',
    subtitle:
        'Brown spots on rice leaves could be indicative of various issues',
  ),
  CardModel(
    image:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSAirlOeJQA2VAc5Kxi3VOUXlEag-yl1TBgAg&usqp=CAU',
    title: 'Stem Rot',
    subtitle:
        'often caused by the fungus Rhizoctonia solani, is a common fungal disease',
  ),
  CardModel(
    image:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTbswxGWcGw7nRGsMkV5FTtbM5l4L4Qv7r3XQ&usqp=CAU',
    title: 'Sheath Blight',
    subtitle:
        'common fungal disease affecting rice crops, caused by the fungus Rhizoctonia solani',
  ),
];

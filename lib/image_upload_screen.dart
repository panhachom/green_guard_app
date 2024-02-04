import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:green_guard_app/service/image_picker_service.dart';
import 'package:green_guard_app/service/messenger_service.dart';
import 'package:green_guard_app/widgets/cm_card.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as Path;

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
      _photo = File(file.path);
      // uploadFile();
      MessengerService.of(context)
          .showLoading(future: (() => uploadFile()), debugSource: '#onpress');

      Logger().d(file.path);
    } else {
      Logger().d('Error');
    }
  }

  Future uploadFile() async {
    if (_photo == null) return;
    final fileName = Path.basename(_photo!.path);
    final destination = 'files/$fileName';

    try {
      final ref = FirebaseStorage.instance.ref(destination).child('file/');
      await ref.putFile(_photo!);
      final downloadUrl = await ref.getDownloadURL();
      final bytes =
          await Dio().get(downloadUrl).then((response) => response.data);
      final imageProvider = NetworkImage(downloadUrl);
      Logger().d(imageProvider);
    } catch (e) {
      print(e);
      print('errr');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      body: buildContent(),
      bottomNavigationBar: buildButtonNavBar(),
    );
  }

  GNav buildButtonNavBar() {
    return const GNav(
        iconSize: 24,
        gap: 8,
        backgroundColor: Colors.white,
        color: Color(0xFF81C784),
        tabs: [
          GButton(
            icon: Icons.home_outlined,
            text: 'Home',
          ),
          GButton(
            icon: Icons.favorite_outline,
            text: 'Favorite',
          ),
          GButton(
            icon: Icons.library_books_outlined,
            text: 'Blog',
          ),
          GButton(
            icon: Icons.account_circle_outlined,
            text: 'Account',
          )
        ]);
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
        'https://www.kissanghar.pk/assets/img/insect_blogs/40371820220606214.png',
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
        'https://www.agfax.com/wp-content/uploads/rice-sheath-blight-20160617.jpg',
    title: 'Sheath Blight',
    subtitle:
        'common fungal disease affecting rice crops, caused by the fungus Rhizoctonia solani',
  ),
];

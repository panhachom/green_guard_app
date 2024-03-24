import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:green_guard_app/constraint/helper.dart';
import 'package:green_guard_app/image_predict_fail_screen.dart';
import 'package:green_guard_app/image_predict_success_screen.dart';
import 'package:green_guard_app/model/blog_model.dart';
import 'package:green_guard_app/model/prediction_model.dart';
import 'package:green_guard_app/service/image_picker_service.dart';
import 'package:green_guard_app/service/image_uploader_service.dart';
import 'package:green_guard_app/widgets/cm_bottom_sheet.dart';
import 'package:green_guard_app/widgets/cm_card.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;

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

      PredictionModel bestPrediction =
          PredictionModel.findMaxProbability(predictions);

      if (bestPrediction.probability < 80) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const ImagePredictFailScreen(),
        ));
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ImagePredictSuccessScreen(
              predictions: predictions,
              photo: _photo,
            ),
          ),
        );
      }
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

  Future<List<BlogModel>> _fetchAllBlogs() async {
    final response =
        await http.get(Uri.parse('${Helper.developmentUrl}/api/blogs'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['blogs'];
      List<BlogModel> blogs =
          data.map((json) => BlogModel.fromJson(json)).toList();

      return blogs;
    } else {
      throw Exception('Failed to load blogs');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: const Color(0xFFE8F5E9),
      // ),
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
              height: 65,
            ),
            buildUploadImageContent(),
            buildBlogContent()
          ],
        ),
      ),
    );
  }

  Widget buildBlogContent() {
    return FutureBuilder<List<BlogModel>>(
      future: _fetchAllBlogs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          if (snapshot.data!.isEmpty) {
            return const SizedBox.shrink();
          } else {
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
                    itemCount: snapshot.data?.length ?? 0,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return CmCard(
                        id: snapshot.data?[index].id ?? 0,
                        image:
                            snapshot.data?[index].images?.first.fileUrl ?? "",
                        title: snapshot.data?[index].title ?? '',
                        subtitle: snapshot.data?[index].subtitle ?? '',
                      );
                    },
                  ),
                )
              ],
            );
          }
        }
      },
    );
  }

  Widget buildUploadImageContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ListTile(
          leading: const Icon(
            Icons.note_alt_outlined,
            size: 35,
            color: Color(0xFF4CAF50),
          ),
          title: const Text(
            'សូមបញ្ចូលរូបភាពនៃជំងីស្រូវនៅទីនេះ',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          subtitle: Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text:
                      'នេះគឺជា Weak AI តែប៉ុណ្ណោះសូមបង្ហោះរូបភាពអោយបានត្រឹមត្រូវ បើមិនដូច្នេះទេលទ្ធផលនឹងមិនត្រឹមត្រូវដូចការរំពឹងទុកនោះទេ។ សូមចុច ',
                  style: TextStyle(fontSize: 13),
                ),
                TextSpan(
                  text: 'ការណែនាំ',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF4CAF50),
                    fontWeight: FontWeight.bold,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      CmBottomSheet(
                        title: 'ការណែនាំ',
                        contentBuilder: (context) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                buildSuggestionText('1.',
                                    'សូម​បង្ហោះ​រូបភាព​ដែលច្បាស់​​អំពី​ជំងឺ​ស្លឹក​ស្រូវ។'),
                                const SizedBox(
                                  height: 4,
                                ),
                                buildSuggestionText('2.',
                                    'ពិចារណាពង្រីកដើម្បីចាប់យក​ស្លឹក​ស្រូវ​ដែលមាន​ជំងឺ​'),
                                const SizedBox(
                                  height: 4,
                                ),
                                buildSuggestionText('3.',
                                    'រក្សាកាមេរ៉ាឱ្យស្ថិតស្ថេរ ដើម្បីការពារភាពមិនច្បាស់'),
                                const SizedBox(
                                  height: 4,
                                ),
                                buildSuggestionText('4.',
                                    'ត្រូវប្រាកដថាមិនមានដំណក់ទឹក ឬសំណើមលើផ្ទៃស្លឹក'),
                              ],
                            ),
                          );
                        },
                      ).show(context);
                    },
                ),
                const TextSpan(
                  text: ' ដើម្បីឱ្យយល់ច្បាស់',
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 5),
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

  Widget buildSuggestionText(String number, String title) {
    return Row(
      children: [
        // const Icon(Icons.check_box_outlined, size: 20),
        Text(
          number,
        ),
        const SizedBox(
          width: 6,
        ),
        Expanded(
          child: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        )
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

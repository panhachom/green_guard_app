import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:green_guard_app/constraint/disease_constant.dart';
import 'package:green_guard_app/constraint/helper.dart';
import 'package:green_guard_app/detailpage.dart';
import 'package:green_guard_app/model/blog_model.dart';
import 'package:green_guard_app/model/prediction_model.dart';
import 'package:green_guard_app/widgets/cm_bottom_sheet.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:http/http.dart' as http;

class ImagePredictSuccessScreen extends StatelessWidget {
  final List<PredictionModel> predictions;
  final File? photo;
  const ImagePredictSuccessScreen({
    super.key,
    required this.predictions,
    this.photo,
  });

  Future<BlogModel> fetchBlogDetails(String title) async {
    final response = await http
        .get(Uri.parse('${Helper.developmentUrl}/api/blogs/show/$title'));
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      Map<String, dynamic> blogData = responseData['blog'];

      BlogModel blog = BlogModel.fromJson(blogData);

      return blog;
    } else {
      throw Exception('Failed to load blog');
    }
  }

  @override
  Widget build(BuildContext context) {
    PredictionModel bestPrediction =
        PredictionModel.findMaxProbability(predictions);
    Logger().d(bestPrediction.probability);
    DiseaseConstant diseaseConstant = DiseaseConstant();
    String title = diseaseConstant.getTitleInKhmer(bestPrediction.name);
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder(
            future: fetchBlogDetails(title),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return buildContent(context, snapshot.data ?? BlogModel());
              }
            },
          ),
          buildBackButton(context),
        ],
      ),
      backgroundColor: const Color(0xFFE8F5E9),
      bottomNavigationBar: buildButton(context),
    );
  }

  Positioned buildBackButton(BuildContext context) {
    return Positioned(
      top: 70,
      left: 15,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.arrow_back_ios_new_outlined),
      ),
    );
  }

  Widget buildContent(BuildContext context, BlogModel blog) {
    String title = blog.title ?? '';
    int id = blog.id ?? 0;
    String image = blog.images?.first.fileUrl ?? '';
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 25,
              ),
              Lottie.asset(
                'assets/images/success.json',
                width: 200,
                // height: 230,
              ),
              const Text(
                'ការវិភាគរូបភាពទទួលបានជោគជ័យ',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              buildImageCard(context, title, id, image),
              const SizedBox(
                height: 15,
              ),
              // if(photo!= null)
              // Image.file(
              //   photo!,
              //   width: 200,
              //   height: 200,
              // )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
      child: ElevatedButton(
        onPressed: () {
          CmBottomSheet(
            title: 'លទ្ធផលនៃការវិភាគ',
            contentBuilder: (context) {
              return buildPieChart();
            },
          ).show(context);
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color(
              0xff388E3C,
            ),
            foregroundColor: Colors.white),
        child: const Padding(
          padding: EdgeInsets.all(14.0),
          child: Text(
            'លទ្ធផលនៃការវិភាគ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget buildImageCard(
      BuildContext context, String title, int id, String image) {
    return Container(
      width: 320,
      height: 240,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.black,
          width: 0.1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8.0),
                bottomLeft: Radius.circular(8.0),
              ),
              child: Image.network(
                image,
                fit: BoxFit.fill,
                width: 260,
                height: 260,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ListTile(
                    title: Text(
                      title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    subtitle: const Text(
                      'ជំងឺស្លឺកត្នោតអាចបណ្តាលមកពីកត្តាផ្សេងៗ ហើយហេតុផលជាក់លាក់អាចប្រែប្រួលអង្ករសំរូបត្រូវបានកែច្នៃតិចជាងអង្ករស។ វានៅតែមានស្រទាប់កន្ទក់',
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DetailPage(id: id),
                          ),
                        );
                      },
                      child: const Text(
                        'មើល​បន្ថែម​ទៀត',
                        style: TextStyle(
                          color: Color(0xFF43A047),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPieChart() {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: predictions.length,
        itemBuilder: (context, index) {
          PredictionModel prediction = predictions[index];
          double roundedProbability =
              double.parse((prediction.probability).toStringAsFixed(2));
          String subtitle = '${roundedProbability.toString()}%';

          return buildPercentIndicator(
            roundedProbability / 100,
            const Color(0xFF43A047),
            prediction.name,
            subtitle,
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(
            height: 3,
          );
        },
      ),
    );
  }

  Widget buildPercentIndicator(
    double percent,
    Color progressColor,
    String title,
    String subtitle,
  ) {
    DiseaseConstant diseaseConstant = DiseaseConstant();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          diseaseConstant.getTitleInKhmer(title),
          style: const TextStyle(fontWeight: FontWeight.w400),
        ),
        LinearPercentIndicator(
          barRadius: const Radius.circular(10),
          width: 180.0,
          lineHeight: 14.0,
          percent: percent,
          backgroundColor: Colors.white,
          progressColor: progressColor,
          center: Text(
            subtitle,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}

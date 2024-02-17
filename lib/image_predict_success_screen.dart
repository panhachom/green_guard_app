import 'package:flutter/material.dart';
import 'package:green_guard_app/constraint/disease_constant.dart';
import 'package:green_guard_app/model/prediction_model.dart';
import 'package:green_guard_app/widgets/cm_bottom_sheet.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ImagePredictSuccessScreen extends StatelessWidget {
  final List<PredictionModel> predictions;
  const ImagePredictSuccessScreen({
    super.key,
    required this.predictions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          buildBackButton(context),
          buildContent(context),
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

  Widget buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 25,
            ),
            Lottie.asset(
              'assets/images/success.json',
              width: 250,
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
            buildImageCard(context),
            const SizedBox(
              height: 15,
            ),
          ],
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

  Widget buildImageCard(BuildContext context) {
    DiseaseConstant diseaseConstant = DiseaseConstant();

    PredictionModel bestPrediction =
        PredictionModel.findMaxProbability(predictions);
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
                'https://www.kissanghar.pk/assets/img/insect_blogs/40371820220606214.png',
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
                      diseaseConstant.getTitleInKhmer(bestPrediction.name),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    subtitle: const Text(
                      'ជំងឺស្លឺកត្នោតអាចបណ្តាលមកពីកត្តាផ្សេងៗ ហើយហេតុផលជាក់លាក់អាចប្រែប្រួលអង្ករសំរូបត្រូវបានកែច្នៃតិចជាងអង្ករស។ វានៅតែមានស្រទាប់កន្ទក់',
                    ),
                  ),
                  const Expanded(
                    child: TextButton(
                      onPressed: null,
                      child: Text(
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

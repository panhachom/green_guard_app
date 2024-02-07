import 'package:flutter/material.dart';
import 'package:green_guard_app/widgets/cm_bottom_sheet.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ImagePredictSuccessScreen extends StatelessWidget {
  const ImagePredictSuccessScreen({super.key});

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
        bottomNavigationBar: buildButton(context));
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
          const Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.only(top: 8, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ListTile(
                    title: Text(
                      'ជំងឺស្លឺកត្នោត',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      'ជំងឺស្លឺកត្នោតអាចបណ្តាលមកពីកត្តាផ្សេងៗ ហើយហេតុផលជាក់លាក់អាចប្រែប្រួលអង្ករសំរូបត្រូវបានកែច្នៃតិចជាងអង្ករស។ វានៅតែមានស្រទាប់កន្ទក់',
                    ),
                  ),
                  Expanded(
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
      child: Row(
        children: [
          Column(
            children: [
              buildPercentIndicator(0.9, const Color(0xFFE57373),
                  'Brown Spot              ', '90%'),
              buildPercentIndicator(0.75, const Color(0xFFBA68C8),
                  'Stem Rot                 ', '75%'),
              buildPercentIndicator(0.68, const Color(0xFF64B5F6),
                  'Materail Leaf Blight ', '68%'),
              buildPercentIndicator(0.50, const Color(0xFFFFA726),
                  'False Smut              ', '50%'),
              buildPercentIndicator(0.20, const Color(0xFFDCE775),
                  'Rice Blast                ', '20%'),
              buildPercentIndicator(0.20, const Color(0xFFEC407A),
                  'Shealt Blight            ', '20%'),
              buildPercentIndicator(0.06, const Color(0xFF26A69A),
                  'Tungro                     ', '6%'),
            ],
          ),
        ],
      ),
    );
  }

  LinearPercentIndicator buildPercentIndicator(
    double percent,
    Color progressColor,
    String title,
    String subtitle,
  ) {
    return LinearPercentIndicator(
      barRadius: const Radius.circular(10),
      width: 180.0,
      lineHeight: 14.0,
      percent: percent,
      backgroundColor: Colors.white,
      progressColor: progressColor,
      leading: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w400),
      ),
      center: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:green_guard_app/main.dart';
import 'package:lottie/lottie.dart';

class ImagePredictFailScreen extends StatelessWidget {
  const ImagePredictFailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildContent(context),
      backgroundColor: const Color(0xFFE8F5E9),
      bottomNavigationBar: buildButton(context),
    );
  }

  Widget buildButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => MyHomePage(selectedIndex: 0),
            ),
            (Route<dynamic> route) => false,
          );
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color(
              0xff388E3C,
            ),
            foregroundColor: Colors.white),
        child: const Padding(
          padding: EdgeInsets.all(14.0),
          child: Text(
            'បញ្ចូលម្តងទៀត',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 70,
            ),
            Center(
              child: Lottie.asset(
                'assets/images/invalid.json',
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            const Text(
              'មានកំហុសបានកើតឡើង! វាហាក់ដូចជាមានបញ្ហាជាមួយរូបភាពដែលអ្នកបានបញ្ចូល',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            // buildImage(),
            const SizedBox(
              height: 20,
            ),
            buildSuggestionText(
                '1.', 'សូម​បង្ហោះ​រូបភាព​ដែលច្បាស់​​អំពី​ជំងឺ​ស្លឹក​ស្រូវ។'),
            const SizedBox(
              height: 4,
            ),
            buildSuggestionText(
                '2.', 'ពិចារណាពង្រីកដើម្បីចាប់យក​ស្លឹក​ស្រូវ​ដែលមាន​ជំងឺ​'),
            const SizedBox(
              height: 4,
            ),
            buildSuggestionText(
                '3.', 'រក្សាកាមេរ៉ាឱ្យស្ថិតស្ថេរ ដើម្បីការពារភាពមិនច្បាស់'),
            const SizedBox(
              height: 4,
            ),
            buildSuggestionText(
                '4.', 'ត្រូវប្រាកដថាមិនមានដំណក់ទឹក ឬសំណើមលើផ្ទៃស្លឹក'),
          ],
        ),
      ),
    );
  }

  Center buildImage() {
    return Center(
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Shadow color
              spreadRadius: 5, // Spread radius
              blurRadius: 7, // Blur radius
              offset: const Offset(0, 3), // Offset in x and y directions
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(10), // Optional: Add border radius
          child: Image.network(
            'https://images.unsplash.com/photo-1698150098242-cc61d0df20eb?q=80&w=3131&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
            width: 150,
            height: 150,
            fit: BoxFit.cover,
          ),
        ),
      ),
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
}

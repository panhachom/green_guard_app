import 'package:flutter/material.dart';
import 'package:green_guard_app/image_predict_success_screen.dart';

class CmCard extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;

  const CmCard({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ImagePredictSuccessScreen(),
          ),
        );
      },
      child: SizedBox(
        width: 260,
        height: 240,
        child: Card(
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                ),
                child: Stack(
                  children: [
                    Image.network(
                      image,
                      height: 130,
                      fit: BoxFit.fill,
                      width: 260,
                    ),
                    const Positioned(
                      bottom: 8,
                      left: 8,
                      child: CircleAvatar(
                        backgroundColor: Color(0xFFE8F5E9),
                        radius: 20,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://lh3.googleusercontent.com/u5G4lXyNl69C1M298f2yMu610s5oSW98TAAVkze5Gek8B5qMDeJ2dFko0x3cXOaoJVA1339aOaOq3uTM=w544-h544-p-l90-rj'),
                          radius: 18,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              ListTile(
                title: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

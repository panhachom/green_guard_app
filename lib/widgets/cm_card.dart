import 'package:flutter/material.dart';
import 'package:green_guard_app/detailpage.dart';

class CmCard extends StatelessWidget {
  final int id;
  final String image;
  final String title;
  final String subtitle;

  const CmCard({
    super.key,
    required this.id,
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
            builder: (context) => DetailPage(id: id),
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
                            'https://st4.depositphotos.com/1156795/20814/v/450/depositphotos_208142524-stock-illustration-profile-placeholder-image-gray-silhouette.jpg',
                          ),
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

import 'package:flutter/material.dart';
import 'package:green_guard_app/blog_lists_screen.dart';
import 'package:green_guard_app/widgets/add_to_favorite.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// -- IMAGE
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: const Image(
                            image: AssetImage('assets/images/logo.jpg'))),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text('ចុំ បញ្ញា', style: Theme.of(context).textTheme.headline4),
              Text('កសិករ', style: Theme.of(context).textTheme.bodyText2),
              const SizedBox(height: 40),

              const Divider(),
              const SizedBox(height: 20),

              /// -- MENU
              ProfileMenuWidget(
                  title: 'ជំងឺដែលបានកត់ទុក (WhiteList)',
                  icon: LineAwesomeIcons.heart,
                  onPress: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AddToFavorite(),
                      ),
                    );
                  }),
              ProfileMenuWidget(
                  title: 'ជំងឺទូទៅ (Blog) ',
                  icon: LineAwesomeIcons.newspaper,
                  onPress: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BlogListScreen(),
                      ),
                    );
                  }),

              ProfileMenuWidget(
                  title: 'Logout',
                  icon: LineAwesomeIcons.alternate_sign_out,
                  textColor: Colors.red,
                  endIcon: false,
                  onPress: () {
                    // Implement logout functionality here
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileMenuWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final Color? textColor;
  final bool endIcon;

  const ProfileMenuWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.textColor,
    this.endIcon = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Colors.green, // Use your color or variable
                ),
                const SizedBox(width: 32),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            endIcon
                ? const Icon(
                    LineAwesomeIcons.angle_right,
                    color: Colors.black, // Use your color or variable
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}

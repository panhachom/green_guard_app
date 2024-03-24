import 'package:flutter/material.dart';
import 'package:green_guard_app/loginpage.dart';
import 'package:green_guard_app/main.dart';
import 'package:green_guard_app/registerpage.dart';
import 'package:green_guard_app/service/user_service.dart';
import 'package:green_guard_app/user_blog_list.dart';
import 'package:green_guard_app/widgets/add_to_favorite.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isSignin = false;
  String username = '';
  String useremail = '';
  int userId = 0;

  @override
  void initState() {
    super.initState();
    checkUserLoggedIn();
    getUsername();
    getEmail();
    getUserId();
  }

  Future<void> getUserId() async {
    UserService userService = UserService();
    int? id = await userService.getUserId();
    setState(() {
      userId = id ?? 0;
    });
  }

  Future<void> getUsername() async {
    UserService userService = UserService();
    String? name = await userService.getUsername();
    setState(() {
      username = name ?? '';
    });
  }

  Future<void> getEmail() async {
    UserService userService = UserService();
    String? email = await userService.getEmail();
    setState(() {
      useremail = email ?? '';
    });
  }

  Future<void> checkUserLoggedIn() async {
    UserService userService = UserService();
    bool isLoggedIn = await userService.isUserLoggedIn();
    setState(() {
      isSignin = isLoggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildContent(context),
      backgroundColor: const Color(0xFFE8F5E9),
    );
  }

  Widget buildContent(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 70,
            ),
            Row(
              children: [
                const CircleAvatar(
                  radius: 36, // Image radius
                  backgroundImage: NetworkImage(
                    'https://st4.depositphotos.com/1156795/20814/v/450/depositphotos_208142524-stock-illustration-profile-placeholder-image-gray-silhouette.jpg',
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isSignin == true
                        ? Text(username,
                            style: Theme.of(context).textTheme.headline6)
                        : Text('សូមស្វាគមន៍',
                            style: Theme.of(context).textTheme.headline6),
                    isSignin == true
                        ? Text(
                            useremail,
                            style: Theme.of(context).textTheme.bodyText2,
                          )
                        : InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );
                            },
                            child: Text(
                              'ចូល',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  ?.copyWith(color: Color(0xFF4CAF50)),
                            ),
                          ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 30),
            isSignin == true
                ? buildListTile(context)
                : const Text(
                    'សូមចូល ដើម្បីទទួលបានបទពិសោធន៍បន្ថែម',
                    style: TextStyle(fontSize: 16),
                  )
          ],
        ),
      ),
    );
  }

  Widget buildListTile(BuildContext context) {
    UserService userService = UserService();

    return Column(
      children: [
        const Divider(thickness: 1),
        const SizedBox(height: 20),

        /// -- MENUP
        ProfileMenuWidget(
            title: 'ជំងឺដែលបានកត់ទុក',
            icon: Icons.favorite,
            iconColor: Colors.red,
            onPress: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddToFavorite(),
                ),
              );
            }),
        const SizedBox(height: 10),

        ProfileMenuWidget(
            title: 'អត្ថបទរបស់ខ្ញុំ',
            icon: Icons.feed,
            iconColor: const Color(0xFF4CAF50),
            onPress: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UserBlogList(id: userId),
                ),
              );
            }),
        const SizedBox(height: 10),

        ProfileMenuWidget(
          title: 'ចាកចេញ',
          icon: Icons.logout,
          iconColor: Colors.red,
          endIcon: false,
          onPress: () {
            // userService.logoutUser().then(
            //       (value) => Phoenix.rebirth(context),
            //     );

            buildLogoutButton(context, userService);
          },
        ),
      ],
    );
  }

  Future<dynamic> buildLogoutButton(
      BuildContext context, UserService userService) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('តើ​អ្នក​ប្រាកដ​ជា​ចង់​ចេញ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('បោះបង់'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);

                userService.logoutUser();
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const MyHomePage(
                //       selectedIndex: 0,
                //     ),
                //   ),
                // );
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(selectedIndex: 0),
                  ),
                  (Route<dynamic> route) => false,
                );
              },
              child: Text('ចាកចេញ'),
            ),
          ],
        );
      },
    );
  }
}

class ProfileMenuWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final Color? textColor;
  final bool endIcon;
  final Color? iconColor;

  const ProfileMenuWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.textColor,
    this.iconColor,
    this.endIcon = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.all(14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: iconColor, // Use your color or variable
                ),
                const SizedBox(width: 32),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            endIcon
                ? const Icon(
                    LineAwesomeIcons.angle_right,
                    color: Colors.black,
                    size: 16, // Use your color or variable
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}

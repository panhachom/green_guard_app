import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:green_guard_app/blog_lists_screen.dart';
import 'package:green_guard_app/image_upload_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ImageUploadScreen(),
    const BlogListScreen(),
    Container()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
         selectedItemColor: const Color(0xFF4CAF50),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'ទំព័រដើម',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books_outlined),
            label: 'អត្ថបទ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// GNav buildButtonNavBar() {
//   return const GNav(
//       iconSize: 24,
//       gap: 8,
//       backgroundColor: Colors.white,
//       color: Color(0xFF81C784),
//       tabs: [
//         GButton(
//           icon: Icons.home_outlined,
//           text: 'Home',
//         ),
//         GButton(
//           icon: Icons.favorite_outline,
//           text: 'Favorite',
//         ),
//         GButton(
//           icon: Icons.library_books_outlined,
//           text: 'Blog',
//         ),
//         GButton(
//           icon: Icons.account_circle_outlined,
//           text: 'Account',
//         )
//       ]);
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:green_guard_app/constraint/helper.dart';
import 'package:green_guard_app/login_screen.dart';
import 'package:green_guard_app/model/blog_model.dart';
import 'package:green_guard_app/service/user_service.dart';
import 'package:green_guard_app/widgets/add_to_favorite.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({
    super.key,
    required this.id,
  });
  final int id;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late bool isFavorite = false;
  bool isSignin = false;
  int userId = 0;
  @override
  void initState() {
    super.initState();
    checkUserLoggedIn();
    getUserId();
  }

  Future<void> checkUserLoggedIn() async {
    UserService userService = UserService();
    bool isLoggedIn = await userService.isUserLoggedIn();
    setState(() {
      isSignin = isLoggedIn;
    });
    if (isLoggedIn) {
      await getUserId();
      checkFavorite(widget.id, userId);
    }
  }

  Future<void> getUserId() async {
    UserService userService = UserService();
    int? id = await userService.getUserId();
    setState(() {
      userId = id ?? 0;
    });
  }

  Future<void> checkFavorite(int blogId, int userId) async {
    String apiUrl =
        'http://127.0.0.1:8000/api/blogs/$blogId/check-favorite?user_id=$userId';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      bool isFavorited = data['is_favorite'];

      if (isFavorited == true) {
        setState(() {
          isFavorite = true;
        });
      }
    } else {
      Logger().d(userId);
      Logger().d(response.body);
      // Handle other status codes or errors
      throw Exception('Failed to check favorite status');
    }
  }

  Future<void> favoriteBlog(int blogId, int userId) async {
    String apiUrl = 'http://127.0.0.1:8000/api/blogs/$blogId/favorite';

    // Prepare the request body
    Map<String, dynamic> requestBody = {
      'user_id': userId.toString(),
    };

    // Send POST request

    final response = await http.post(
      Uri.parse(apiUrl),
      body: jsonEncode(requestBody),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    Logger().d(response.statusCode);

    if (response.statusCode == 201) {
      setState(() {
        isFavorite = true;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'ចូលចិត្ត',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      maintainState: true, // Maintain state of previous screen
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const AddToFavorite(),
                    ),
                  );
                },
                child: const Text(
                  'មើលអត្ដបទដែលចូលចិត្ត',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          behavior: SnackBarBehavior.floating, // Change behavior to floating
        ),
      );
    }
    if (response.statusCode == 200) {
      setState(() {
        isFavorite = false;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'មិន​ចូលចិត្ត',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        behavior: SnackBarBehavior.floating, // Change behavior to floating
      ));
    }
  }

  Future<BlogModel> fetchBlogDetails() async {
    final response = await http
        .get(Uri.parse('${Helper.developmentUrl}/api/blogs/show/${widget.id}'));
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
    return Scaffold(
        appBar: AppBar(
            // preferredSize: const Size.fromHeight(kToolbarHeight + 50.0),
            // title: Image.asset(
            //   'assets/images/logo.jpg',
            //   width: 150,
            // ),
            // centerTitle: true,
            ),
        backgroundColor: const Color(0xFFE8F5E9),
        body: FutureBuilder(
          future: fetchBlogDetails(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<String> images =
                  snapshot.data!.images?.map((e) => e.fileUrl).toList() ?? [];
              String? createdAt = snapshot.data?.createdAt;

              String formattedDate = '';

              if (createdAt != null) {
                formattedDate =
                    DateFormat.yMMMd().format(DateTime.parse(createdAt));
              }

              return RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    fetchBlogDetails();
                  });
                },
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StaggeredGrid.count(
                          crossAxisCount: 4,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          children: [
                            StaggeredGridTile.count(
                              crossAxisCellCount: 2,
                              mainAxisCellCount: 2,
                              child: FullScreenWidget(
                                disposeLevel: DisposeLevel.Medium,
                                child: Hero(
                                  tag: "img1",
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5.0),
                                    child: Image.network(
                                      images[0],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            StaggeredGridTile.count(
                              crossAxisCellCount: 2,
                              mainAxisCellCount: 1,
                              child: FullScreenWidget(
                                disposeLevel: DisposeLevel.Medium,
                                child: Hero(
                                  tag: "img2",
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5.0),
                                    child: Image.network(
                                      images[1],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            StaggeredGridTile.count(
                              crossAxisCellCount: 1,
                              mainAxisCellCount: 1,
                              child: FullScreenWidget(
                                disposeLevel: DisposeLevel.Medium,
                                child: Hero(
                                  tag: "img3",
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5.0),
                                    child: Image.network(
                                      images[2],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            StaggeredGridTile.count(
                              crossAxisCellCount: 1,
                              mainAxisCellCount: 1,
                              child: FullScreenWidget(
                                disposeLevel: DisposeLevel.Medium,
                                child: Hero(
                                  tag: "img4",
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5.0),
                                    child: Image.network(
                                      images[3],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.all(10.0), // Margin on all sides
                          child: Text(
                            snapshot.data!.title ?? '',
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 200,
                                child: ListTile(
                                  leading: const CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        'https://st4.depositphotos.com/1156795/20814/v/450/depositphotos_208142524-stock-illustration-profile-placeholder-image-gray-silhouette.jpg'),
                                  ),
                                  title: Text(
                                    snapshot.data?.user?.name ?? 'អ្នក​ប្រើ',
                                  ),
                                  subtitle: Text(formattedDate),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: IconButton(
                                  icon: Icon(
                                    isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: isFavorite ? Colors.red : null,
                                  ),
                                  onPressed: () async {
                                    if (isSignin == true) {
                                      favoriteBlog(widget.id, userId);
                                    } else {
                                      buildSignInDialog(context);
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Html(
                            data: snapshot.data?.body,
                            style: {
                              "body": Style(
                                fontSize: FontSize(
                                    16.0), // Change the value to the desired font size
                              ),
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ));
  }

  Future<dynamic> buildSignInDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('តម្រូវឱ្យចូល'),
          content: const Text('អ្នក​ត្រូវ​ចូល​ដើម្បី​ចូល​ចិត្ត​អត្ថបទ​នេះ'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('បោះបង់'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                // Navigate to login screen when "Sign In" button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text('ចូល'),
            ),
          ],
        );
      },
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:green_guard_app/constraint/disease_constant.dart';
import 'package:green_guard_app/constraint/helper.dart';
import 'package:green_guard_app/model/blog_model.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AddToFavorite(),
    );
  }
}

class AddToFavorite extends StatefulWidget {
  @override
  _AddToFavoriteState createState() => _AddToFavoriteState();
}

Future<void> favoriteBlog(int blogId, int userId) async {
  String apiUrl = 'http://127.0.0.1:8000/api/blogs/$blogId/favorite';

  // Prepare the request body
  Map<String, dynamic> requestBody = {
    'user_id': userId.toString(),
  };

  // Send POST request
  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: jsonEncode(requestBody),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 201) {
      print('Remove successfully!');
    } else {
      print('Failed to favorite blog: ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

Future<List<BlogModel>> fetchBlogs(String userId) async {
  final response = await http
      .get(Uri.parse('${Helper.developmentUrl}/api/favorites?user_id=$userId'));
  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body)['blogs'];
    List<BlogModel> blogs =
        data.map((json) => BlogModel.fromJson(json)).toList();
    return blogs;
  } else {
    throw Exception('Failed to load blogs');
  }
}

class _AddToFavoriteState extends State<AddToFavorite> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('ជម្ងឺដែលអ្នកបាន ចំណាំទុក'),
        ),
        body: FutureBuilder<List<BlogModel>>(
          future: fetchBlogs(1.toString()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Padding(
                padding: const EdgeInsets.only(left: 4, right: 4, top: 2),
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final blog = snapshot.data![index];
                    DiseaseConstant diseaseConstant = DiseaseConstant();
                    List<String> images =
                        diseaseConstant.getDiseaseImageList(blog.title);
                    String mainImage = images[0];

                    return buildCard(blog, mainImage);
                  },
                ),
              );
            }
          },
        ));
  }

  Slidable buildCard(BlogModel? blog, String mainImage) {
    return Slidable(
        key: ValueKey(blog?.id),
        endActionPane: ActionPane(
          motion: ScrollMotion(),
          children: [
            SlidableAction(
              flex: 2,
              onPressed: (context) async {
                await favoriteBlog(blog?.id ?? 0, 1);
                setState(() {
                  fetchBlogs(1.toString());
                });
              },

              backgroundColor: Color.fromARGB(255, 217, 91, 91),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Remove',
              // width: 100, // Set the width directly
            ),
          ],
        ),
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey
                    .withOpacity(0.5), // Adjust transparency for depth
                blurRadius: 15,
                offset: Offset(0, 5), // Adjust offset downwards
              ),
            ],
          ),
          margin: EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  mainImage,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover, // Adjust as needed
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        blog?.title ?? '',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        maxLines: 2, // Allow up to 2 lines for title
                        overflow: TextOverflow
                            .ellipsis, // Add ellipsis (...) if truncated
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Text(blog?.createdAt ?? ''),
                        ],
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

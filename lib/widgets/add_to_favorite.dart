import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:green_guard_app/constraint/disease_constant.dart';
import 'package:green_guard_app/constraint/helper.dart';
import 'package:green_guard_app/detailpage.dart';
import 'package:green_guard_app/model/blog_model.dart';
import 'package:http/http.dart' as http;

class AddToFavorite extends StatefulWidget {
  const AddToFavorite({super.key});

  @override
  AddToFavoriteState createState() => AddToFavoriteState();
}

class AddToFavoriteState extends State<AddToFavorite> {
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
    final response = await http.get(
        Uri.parse('${Helper.developmentUrl}/api/favorites?user_id=$userId'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['blogs'];
      List<BlogModel> blogs =
          data.map((json) => BlogModel.fromJson(json)).toList();
      return blogs;
    } else {
      throw Exception('Failed to load blogs');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const ListTile(
            leading: Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            title: Text(
              'អត្ថបទចូលចិត្ត',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
              textAlign: TextAlign.start,
            ),
          ),
          centerTitle: false,
        ),
        backgroundColor: const Color(0xFFE8F5E9),
        body: FutureBuilder<List<BlogModel>>(
          future: fetchBlogs(1.toString()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Container(
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

  Widget buildCard(BlogModel? blog, String mainImage) {
    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        border: Border.all(
          color: Colors.black,
          width: 0.1,
        ),
      ),
      height: 100,
      child: Slidable(
        key: ValueKey(blog?.id),
        endActionPane: ActionPane(
          motion: ScrollMotion(),
          children: [
            SlidableAction(
              flex: 2,
              onPressed: (context) async {
                await favoriteBlog(blog?.id ?? 0, 1);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Removed From Favorite',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: Color.fromARGB(255, 217, 91, 91),
                  ),
                );
                setState(() {
                  fetchBlogs(1.toString());
                });
              },
              backgroundColor: Color.fromARGB(255, 217, 91, 91),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Remove',
            ),
          ],
        ),
        child: buildImageCard(
          context,
          blog?.title ?? '',
          blog?.body ?? '',
          blog?.id ?? 0,
          mainImage,
        ),
      ),
    );
  }

  Widget buildImageCard(
    BuildContext context,
    String title,
    String body,
    int id,
    String mainImage,
  ) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DetailPage(id: id),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(4),
        height: 100,
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(15),
        //   border: Border.all(
        //     color: Colors.black,
        //     width: 0.1,
        //   ),
        // ),
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
                child: Image.asset(
                  mainImage,
                  fit: BoxFit.fill,
                  height: 100,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ListTile(
                    title: Text(
                      title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    subtitle: const Text('Some subtitle can do not have yet'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

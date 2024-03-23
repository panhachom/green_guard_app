import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:green_guard_app/constraint/disease_constant.dart';
import 'package:green_guard_app/constraint/helper.dart';
import 'package:green_guard_app/detailpage.dart';
import 'package:green_guard_app/model/blog_model.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class UserBlogList extends StatefulWidget {
  final int id;

  const UserBlogList({super.key, required this.id});

  @override
  State<UserBlogList> createState() => _UserBlogListState();
}

class _UserBlogListState extends State<UserBlogList> {
  Future<List<BlogModel>> fetchBlogs(int userId) async {
    final response = await http.get(
      Uri.parse('${Helper.developmentUrl}/api/blogs?user_id=$userId'),
    );
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
            'Your Blog',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
            textAlign: TextAlign.start,
          ),
        ),
        centerTitle: false,
      ),
      backgroundColor: const Color(0xFFE8F5E9),
      body: FutureBuilder<List<BlogModel>>(
        future: fetchBlogs(widget.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            if (snapshot.data!.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'No Favorite post yet',
                  style: TextStyle(fontSize: 15),
                ),
              );
            } else {
              return Container(
                padding: const EdgeInsets.only(left: 4, right: 4, top: 2),
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final blog = snapshot.data![index];
                    Logger().d(blog.status);
                    DiseaseConstant diseaseConstant = DiseaseConstant();
                    List<String> images =
                        diseaseConstant.getDiseaseImageList(blog.title ?? '');
                    String mainImage = images[0];
                    String sub = diseaseConstant.subtitle[index];

                    return buildCard(
                        blog, mainImage, blog.status ?? 0, blog.subtitle ?? '');
                  },
                ),
              );
            }
          }
        },
      ),
    );
  }

  Widget buildCard(BlogModel? blog, String mainImage, int status, String sub) {
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
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DetailPage(id: blog?.id ?? 0),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.all(4),
            height: 100,
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
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          blog?.title ?? '',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          sub,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                            left: 5,
                            right: 5,
                            top: 3,
                            bottom: 3,
                          ),
                          decoration: BoxDecoration(
                            color:
                                status == 1 ? Colors.green : Colors.amberAccent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            status == 1 ? 'Public' : 'Pending',
                            style: TextStyle(
                                fontSize: 10,
                                color:
                                    status == 1 ? Colors.white : Colors.black),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget buildImageCard(BuildContext context, String title, String body, int id,
      String mainImage, String sub) {
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
                    // subtitle: Text(
                    //   sub,
                    //   maxLines: 2,
                    //   overflow: TextOverflow.ellipsis,
                    // ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    color: Colors.amberAccent,
                    child: const Text('Pending'),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

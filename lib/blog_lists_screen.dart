import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:green_guard_app/constraint/helper.dart';
import 'package:green_guard_app/detailpage.dart';
import 'package:green_guard_app/model/blog_model.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class BlogListScreen extends StatelessWidget {
  const BlogListScreen({super.key});

  Future<List<BlogModel>> fetchBlogs() async {
    final response =
        await http.get(Uri.parse('${Helper.productionUrl}/api/blogs'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['blogs'];
      List<BlogModel> blogs =
          data.map((json) => BlogModel.fromJson(json)).toList();
      Logger().d(data);
      return blogs;
    } else {
      throw Exception('Failed to load blogs');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ចំណេះដឹងថ្មីៗ',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.start,
        ),
        centerTitle: false,
      ),
      backgroundColor: const Color(0xFFE8F5E9),
      body: buildContent(),
    );
  }

  FutureBuilder<List<BlogModel>> buildContent() {
    return FutureBuilder<List<BlogModel>>(
      future: fetchBlogs(),
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
                return buildImageCard(context, blog.title, blog.body, blog.id);
              },
            ),
          );
        }
      },
    );
  }

  Widget buildImageCard(
      BuildContext context, String title, String body, int id) {
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.black,
            width: 0.1,
          ),
        ),
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
                child: Image.network(
                  'https://www.kissanghar.pk/assets/img/insect_blogs/40371820220606214.png',
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
                    // subtitle: Html(
                    //   data: body,
                    //   style: {
                    //     'body': Style(
                    //       maxLines: 1, // Restrict to 3 lines
                    //       textOverflow: TextOverflow.ellipsis,

                    //     ),
                    //   },
                    // ),
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

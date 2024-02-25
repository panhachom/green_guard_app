import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:green_guard_app/constraint/disease_constant.dart';
import 'package:green_guard_app/constraint/helper.dart';
import 'package:green_guard_app/model/blog_model.dart';

import 'package:http/http.dart' as http;

class DetailPage extends StatelessWidget {
  const DetailPage({
    super.key,
    required this.id,
  });
  final int id;

  Future<BlogModel> fetchBlogDetails() async {
    final response = await http
        .get(Uri.parse('${Helper.developmentUrl}/api/blogs/show/$id'));
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
              DiseaseConstant diseaseConstant = DiseaseConstant();
              List<String> images = diseaseConstant
                  .getDiseaseImageList(snapshot.data?.title ?? '');

              return SingleChildScrollView(
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
                                  child: Image.asset(
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
                                  child: Image.asset(
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
                                  child: Image.asset(
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
                                  child: Image.asset(
                                    images[3],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Add some spacing between the grid and text

                          // Other grid tiles with Tsile widgets
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0), // Margin on all sides
                        child: Text(
                          snapshot.data!.title,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTtPs8ubbPPA31JXQNO9P4WAnPpGQTJFINxn34IwJhk2AgIcDmHKMiojrVfcuPMJMxerBc&usqp=CAU'),
                        ),
                        title: Text('ចុំ បញ្ញា'),
                        subtitle: Text('Feb 05 2024'),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
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
              );
            }
          },
        ));
  }
}

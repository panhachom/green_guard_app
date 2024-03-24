import 'dart:convert';

import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:green_guard_app/constraint/helper.dart';
import 'package:green_guard_app/create_blog_screen.dart';
import 'package:green_guard_app/detailpage.dart';
import 'package:green_guard_app/model/blog_model.dart';
import 'package:http/http.dart' as http;

class BlogListScreen extends StatefulWidget {
  const BlogListScreen({super.key});

  @override
  State<BlogListScreen> createState() => _BlogListScreenState();
}

class _BlogListScreenState extends State<BlogListScreen> {
  TextEditingController searchController = TextEditingController();
  late Future<List<BlogModel>> _futureBlogs;
  late bool _loading = false;
  String _selectedCategory = '';
  late bool showFilter = true;

  List<BlogModel> allBlogs = [];

  @override
  void initState() {
    super.initState();
    _futureBlogs = fetchBlogs();
  }

  Future<List<BlogModel>> fetchBlogs() async {
    final response =
        await http.get(Uri.parse('${Helper.developmentUrl}/api/blogs'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['blogs'];
      List<BlogModel> blogs =
          data.map((json) => BlogModel.fromJson(json)).toList();
      return blogs;
    } else {
      throw Exception('Failed to load blogs');
    }
  }

  Future<List<BlogModel>> _fetchAllBlogs() async {
    final response =
        await http.get(Uri.parse('${Helper.developmentUrl}/api/blogs'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['blogs'];
      List<BlogModel> blogs =
          data.map((json) => BlogModel.fromJson(json)).toList();

      return blogs;
    } else {
      throw Exception('Failed to load blogs');
    }
  }

  Future<void> _filterByCategory(String category) async {
    setState(() {
      _loading = true;
    });
    try {
      final response = await http.get(Uri.parse(
          '${Helper.developmentUrl}/api/blogs/filter-by-category?category=$category'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)['blogs'];
        List<BlogModel> blogs =
            data.map((json) => BlogModel.fromJson(json)).toList();
        setState(() {
          _futureBlogs = Future.value(blogs);
          _loading = false;
        });
      } else {
        throw Exception('Failed to filter blogs by category');
      }
    } catch (error) {
      setState(() {
        _loading = false;
      });
      print('Error: $error');
    }
  }

  Future<void> searchBlogs(String query) async {
    setState(() {
      _loading = true;
    });
    try {
      final response = await http.get(
          Uri.parse('${Helper.developmentUrl}/api/blogs/search?query=$query'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)['blogs'];
        List<BlogModel> blogs =
            data.map((json) => BlogModel.fromJson(json)).toList();
        setState(() {
          _futureBlogs = Future.value(blogs);
          _loading = false;
        });
      } else {
        throw Exception('Failed to search blogs');
      }
    } catch (error) {
      setState(() {
        _loading = false;
      });
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ចំណេះដឹងថ្មីៗ',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
        ),
        actions: [
          buildFilter(context),
        ],
        centerTitle: false,
      ),
      backgroundColor: const Color(0xFFE8F5E9),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 0, bottom: 0, left: 10, right: 10),
            child: Row(
              children: [
                AnimSearchBar(
                  width: 360,
                  textController: searchController,
                  onSuffixTap: () {
                    setState(() {
                      searchController.clear();
                    });
                  },
                  onSubmitted: (s) {
                    searchBlogs(s);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : buildContent(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(
          0xff388E3C,
        ),
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CreateBlogScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add_circle),
        label: const Text(
          'Create Blog',
          style: TextStyle(fontSize: 15),
        ),
      ),
    );
  }

  Widget buildFilter(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(
        Icons.filter_list,
        size: 28,
      ),
      onSelected: (String newValue) {
        _selectedCategory = BlogModel.CATEGORIES[newValue] ?? '';
        _filterByCategory(_selectedCategory);
      },
      itemBuilder: (BuildContext context) {
        return BlogModel.CATEGORIES.entries
            .map((MapEntry<String, String> entry) {
          return PopupMenuItem<String>(
            value: entry.key,
            child: Text(entry.value),
          );
        }).toList();
      },
    );
  }

  FutureBuilder<List<BlogModel>> buildContent() {
    return FutureBuilder<List<BlogModel>>(
      future: _futureBlogs,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          if (snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('រកមិនឃើញលទ្ធផលទេ'),
                  TextButton(
                    onPressed: () async {
                      setState(() {
                        _futureBlogs = _fetchAllBlogs();
                      });
                    },
                    child: const Text(
                      'ត្រឡប់មកវិញ',
                      style: TextStyle(
                        color: Color(
                          0xff388E3C,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _futureBlogs = _fetchAllBlogs();
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 4, right: 4, top: 2),
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final blog = snapshot.data![index];

                    String mainImage =
                        snapshot.data?[index].images?.first.fileUrl ?? '';

                    return buildImageCard(
                        context,
                        blog.title ?? '',
                        blog.body ?? '',
                        blog.id ?? 0,
                        mainImage,
                        blog.subtitle ?? '');
                  },
                ),
              ),
            );
          }
        }
      },
    );
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
                    subtitle: Text(
                      sub,

                      maxLines: 2, // Restrict to 3 lines
                      overflow: TextOverflow.ellipsis,
                    ),
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

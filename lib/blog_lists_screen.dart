import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlogList(),
    );
  }
}

class BlogList extends StatefulWidget {
  const BlogList({super.key});

  @override
  _BlogListState createState() => _BlogListState();
}

class _BlogListState extends State<BlogList> {
  // Replace with your actual blog data
  final List<BlogPost> blogPosts = [
    BlogPost(
      imageUrl:
          'data:image/jpeg;base64,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',
      title: 'ជំងឺ​ អុចត្នោត',
      author: 'Mak Rathmuny',
      date: 'January 1, 2024',
      content:
          'Content of the first blog post auhceauli fheg calu iCHa; IC Ha ;HC a;LEC bchawlbclabcajlcbajcbwacal',
    ),
    // Add more blog posts here...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blog List'),
      ),
      body: ListView.builder(
        itemCount: blogPosts.length,
        itemBuilder: (context, index) {
          final post = blogPosts[index];

          return Card(
            child: Row(
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(16), // Adjust radius as needed
                  child: Padding(
                    padding:
                        const EdgeInsets.all(5.0), // Add padding with all sides
                    child: Image.network(post.imageUrl, width: 120),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Align text to left
                      children: [
                        Text(post.title,
                            style: TextStyle(
                                fontSize: 21, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text('By ${post.author}'),
                            SizedBox(width: 10),
                            Text(post.date),
                          ],
                        ),
                        SizedBox(height: 12),
                        Text(
                          post.content,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class BlogPost {
  final String imageUrl;
  final String title;
  final String author;
  final String date;
  final String content;

  BlogPost({
    required this.imageUrl,
    required this.title,
    required this.author,
    required this.date,
    required this.content,
  });
}

class BlogPostCard extends StatelessWidget {
  final BlogPost post;

  const BlogPostCard({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.network(post.imageUrl),
            const SizedBox(height: 10),
            Text(post.title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Row(
              children: [
                Text('By ${post.author}'),
                const SizedBox(width: 10),
                Text(post.date),
              ],
            ),
            Expanded(
              child: Text(
                post.content, // Limit words first
                maxLines: 1, // Allow only one line
                overflow: TextOverflow.ellipsis, // Add ellipsis if truncated
              ),
            ),
          ],
        ),
      ),
    );
  }
}

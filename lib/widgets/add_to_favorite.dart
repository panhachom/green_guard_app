import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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

class _AddToFavoriteState extends State<AddToFavorite> {
  // Replace with your actual blog data
  final List<BlogPost> blogPosts = [
    BlogPost(
      id: 1,
      title: 'Brown Spot',
      author: 'ចុំ បញ្ញា',
      date: 'January 1, 2024',
      content: 'Content of the first blog post...',
      imageUrl: '../assets/images/test_image.jpeg',
    ),
    BlogPost(
      id: 2,
      title: 'Brown Spot test',
      author: 'ចុំ បញ្ញា aacn',
      date: 'January 1, 2024',
      content: 'Content of the first blog post...',
      imageUrl: '../assets/images/test_image.jpeg',
    ),
    // Add more blog posts here...
  ];

  void removeItem(int index) {
    setState(() {
      blogPosts.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('ជម្ងឺដែលអ្នកបាន ចំណាំទុក'),
        ),
        body: ListView.builder(
          itemCount: blogPosts.length,
          itemBuilder: (context, index) {
            final post = blogPosts[index];
            return buildCard(post);
          },
        ));
  }

  Slidable buildCard(BlogPost blog) {
    return Slidable(
        key: ValueKey(blog.id),
        endActionPane: const ActionPane(
          motion: ScrollMotion(),
          children: [
            SlidableAction(
              flex: 2,
              onPressed: null,
              backgroundColor: Color.fromARGB(255, 217, 91, 91),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Remove',
              // width: 100, // Set the width directly
            ),
          ],
        ),
        child: buildItem(blog));
  }

  ListView buildListView() {
    return ListView.builder(
      itemCount: blogPosts.length,
      itemBuilder: (context, index) {
        final post = blogPosts[index];
        return Dismissible(
          key: UniqueKey(), // Ensure unique key for each item
          dismissThresholds: {
            // Customize swipe sensitivity
            DismissDirection.startToEnd: 0.3, // Swipe right to delete
          },
          onDismissed: (direction) {
            removeItem(index); // Remove item on swipe
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${post.title} removed from favorites'),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {
                    setState(() {
                      blogPosts.insert(index, post); // Undo removal
                    });
                  },
                ),
              ),
            );
          },
          child: buildItem(post),
        );
      },
    );
  }

  Container buildItem(BlogPost post) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color:
                Colors.grey.withOpacity(0.5), // Adjust transparency for depth
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
              post.imageUrl,
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
                    post.title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    maxLines: 2, // Allow up to 2 lines for title
                    overflow: TextOverflow
                        .ellipsis, // Add ellipsis (...) if truncated
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: const [
                      Text('test'),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    post.content.trimLeft().split(' ').take(30).join(' ') +
                        '...',
                    maxLines: 3, // Allow up to 3 lines for content
                    overflow: TextOverflow
                        .ellipsis, // Add ellipsis (...) if truncated
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BlogPost {
  final int id;
  final String imageUrl;
  final String title;
  final String author;
  final String date;
  final String content;

  BlogPost(
      {required this.id,
      required this.imageUrl,
      required this.title,
      required this.author,
      required this.date,
      required this.content});
}

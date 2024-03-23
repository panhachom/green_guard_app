import 'package:flutter/material.dart';

class CreateBlogScreen extends StatefulWidget {
  const CreateBlogScreen({super.key});

  @override
  State<CreateBlogScreen> createState() => _CreateBlogScreenState();
}

class _CreateBlogScreenState extends State<CreateBlogScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(
            Icons.create,
          ),
          title: Text(
            'Create Blog',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
            textAlign: TextAlign.start,
          ),
        ),
        centerTitle: false,
      ),
      backgroundColor: const Color(0xFFE8F5E9),
      body: Form(
        key: widget.key,
        child: Column(
          children: [
            buildTextFormFields(),
            buildImagesFormFields(),
          ],
        ),
      ),
      bottomNavigationBar: buildButton(context),
    );
  }

  Widget buildButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color(
              0xff388E3C,
            ),
            foregroundColor: Colors.white),
        child: const Padding(
          padding: EdgeInsets.all(14.0),
          child: Text(
            'Modify',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget buildImagesFormFields() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        Center(
          child: Container(
            width: 360,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 243, 247, 243),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: const Icon(Icons.add_photo_alternate_outlined),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        buildImageBox(),
                        const SizedBox(
                          width: 10,
                        ),
                        buildImageBox(),
                        const SizedBox(
                          width: 10,
                        ),
                        buildImageBox(),
                        const SizedBox(
                          width: 10,
                        ),
                        buildImageBox(),
                        const SizedBox(
                          width: 10,
                        ),
                        buildImageBox()
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildImageBox() {
    return Stack(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 243, 247, 243),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              'https://lh3.googleusercontent.com/proxy/cjJACIc6JJkjjcQVc8JEyzi31rX-SpL1NGZdAdPRVKllfxE5MJwaPqr2ZUFSZ_bGlDMlqHGJT0zKYVbGa3bqJyY_6Xcng2BSOgjjbyRr7cws73nJGZ0bXi8',
              fit: BoxFit.cover,
            ),
          ),
        ),
        const Positioned(
          top: 3,
          right: 3,
          child: Icon(
            Icons.close_outlined,
            size: 22,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Container buildTextFormFields() {
    return Container(
      margin: const EdgeInsets.only(top: 18),
      width: 360,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            buildFormBox('Title', const Icon(Icons.title_outlined)),
            const SizedBox(
              height: 10,
            ),
            buildFormBox('Subtitle', const Icon(Icons.subtitles_outlined)),
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: const Color.fromARGB(255, 243, 247, 243),
              ),
              height: 200,
              child: TextField(
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.edit_note_outlined,
                    size: 28,
                  ),
                  contentPadding: const EdgeInsets.only(
                      top: 15.0,
                      left: 20.0,
                      right: 20.0,
                      bottom: 0.0), // Adjust top padding
                  label: const Text('Description'),
                  hintStyle: TextStyle(color: Colors.grey[800]),
                  border: InputBorder.none,
                  isDense: true, // Make the input decoration more compact
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildFormBox(String title, Icon icon) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: const Color.fromARGB(255, 243, 247, 243),
      ),
      child: TextFormField(
        decoration: InputDecoration(
          prefixIcon: icon,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
          label: Text(title),
          hintStyle: TextStyle(
            color: Colors.grey[800],
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

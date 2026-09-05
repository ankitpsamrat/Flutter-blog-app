import 'package:blog_app/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:flutter/material.dart';

class BlogPage extends StatelessWidget {
  const BlogPage({super.key});

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => BlogPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog App'),
        actions: [
          IconButton.outlined(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(context, AddNewBlogPage.route()),
          ),
        ],
      ),
      body: const Center(child: Text('Blog Content')),
    );
  }
}

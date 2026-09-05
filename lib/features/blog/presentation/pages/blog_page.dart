import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => BlogPage());
  }

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  //

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BlogBloc>().add(BlogFetchAllBlogs());
    });
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
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            debugPrint(state.error);
            showSnackBar(context, state.error);
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return Center(child: const CircularProgressIndicator());
          }

          if (state is BlogsDiaplaySuccess) {
            return ListView.builder(
              itemCount: state.blogs.length,
              itemBuilder: (BuildContext context, int index) {
                final Blog blog = state.blogs[index];

                return BlogCard(blog: blog);
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

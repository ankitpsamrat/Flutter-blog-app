import 'dart:io';

import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/common/widgets/custom_text_field.dart';
import 'package:blog_app/core/utils/pick_image.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewBlogPage extends StatefulWidget {
  const AddNewBlogPage({super.key});

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => AddNewBlogPage());
  }

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  //

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contntController = TextEditingController();
  final List<String> _selectedTopics = [];
  File? _selectedImage;

  void _uploadBlog() {
    if (_formKey.currentState!.validate() &&
        _selectedTopics.isNotEmpty &&
        _selectedImage != null) {
      final String posterId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user!.id;

      context.read<BlogBloc>().add(
        BlogUpload(
          image: _selectedImage!,
          title: _titleController.text.trim(),
          content: _contntController.text.trim(),
          posterId: posterId,
          topics: _selectedTopics,
        ),
      );
      // log(posterId);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contntController.dispose();
    // _selectedImage = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Blog'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: () {
              _uploadBlog();
            },
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            debugPrint(state.error);
            showSnackBar(context, state.error);
          } else if (state is BlogSuccess) {
            showSnackBar(context, 'Blog Posted Successfully');
            Navigator.pushAndRemoveUntil(
              context,
              BlogPage.route(),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return Center(child: const CircularProgressIndicator());
          }
          return SingleChildScrollView(
            padding: EdgeInsets.all(15),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      final File? img = await pickImage();

                      if (img != null) {
                        setState(() {
                          _selectedImage = img;
                        });
                      }
                    },
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: AppPallete.borderColor),
                      ),
                      child: (_selectedImage != null)
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.file(
                                _selectedImage!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.folder_open),
                                const SizedBox(height: 20),
                                const Text('Select your image'),
                              ],
                            ),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          [
                                'Technology',
                                'Business',
                                'Programing',
                                'Entertenment',
                              ]
                              .map(
                                (e) => Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (_selectedTopics.contains(e)) {
                                        _selectedTopics.remove(e);
                                      } else {
                                        _selectedTopics.add(e);
                                      }
                                      setState(() {});
                                      debugPrint(
                                        'Selected Topics: $_selectedTopics',
                                      );
                                    },
                                    child: Chip(
                                      label: Text(e),
                                      color: _selectedTopics.contains(e)
                                          ? WidgetStatePropertyAll(
                                              AppPallete.gradient1,
                                            )
                                          : null,
                                      side: _selectedTopics.contains(e)
                                          ? null
                                          : BorderSide(
                                              color: AppPallete.borderColor,
                                            ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: CustomTextField(
                      hintText: 'Blog Title',
                      controller: _titleController,
                    ),
                  ),
                  CustomTextField(
                    hintText: 'Blog Content',
                    controller: _contntController,
                    maxLines: null,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

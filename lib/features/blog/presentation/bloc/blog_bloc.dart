import 'dart:io';

import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/usecases/get_all_blog.dart';
import 'package:blog_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlog _getAllBlog;

  BlogBloc({required UploadBlog uploadBlog, required GetAllBlog getAllBlog})
    : _uploadBlog = uploadBlog,
      _getAllBlog = getAllBlog,
      super(BlogInitial()) {
    on<BlogEvent>((event, emit) => emit(BlogLoading()));
    on<BlogUpload>(_blogUpload);
    on<BlogFetchAllBlogs>(_fetchAllBlogs);
  }

  void _blogUpload(BlogUpload event, Emitter<BlogState> emit) async {
    final Either<Failure, Blog> res = await _uploadBlog(
      UploadBlogParams(
        image: event.image,
        title: event.title,
        content: event.content,
        posterId: event.posterId,
        topics: event.topics,
      ),
    );

    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogUploadSuccess()),
    );
  }

  void _fetchAllBlogs(BlogFetchAllBlogs event, Emitter<BlogState> emit) async {
    final Either<Failure, List<Blog>> res = await _getAllBlog(NoParams());

    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogsDiaplaySuccess(r)),
    );
  }
}

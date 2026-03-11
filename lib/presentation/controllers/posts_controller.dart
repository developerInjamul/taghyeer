import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/failures.dart';
import '../../data/models/post_model.dart';
import '../../data/repositories/posts_repository.dart';
import 'products_controller.dart';

class PostsController extends GetxController {
  final PostsRepository _repository;

  PostsController(this._repository);

  final RxList<PostModel> posts = <PostModel>[].obs;
  final Rx<ListState> state = ListState.initial.obs;
  final RxBool isPaginationLoading = false.obs;
  final RxBool hasMore = true.obs;
  final RxString errorMessage = ''.obs;

  int _skip = 0;
  late ScrollController scrollController;

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
    scrollController.addListener(_onScroll);
    fetchPosts();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      if (!isPaginationLoading.value && hasMore.value) {
        fetchMorePosts();
      }
    }
  }

  Future<void> fetchPosts() async {
    _skip = 0;
    posts.clear();
    state.value = ListState.loading;
    errorMessage.value = '';

    try {
      final response = await _repository.getPosts(skip: _skip);
      if (response.posts.isEmpty) {
        state.value = ListState.empty;
      } else {
        posts.addAll(response.posts);
        _skip += AppConstants.pageLimit;
        hasMore.value = response.hasMore;
        state.value = ListState.success;
      }
    } on NetworkFailure catch (e) {
      errorMessage.value = e.message;
      state.value = ListState.error;
    } on TimeoutFailure catch (e) {
      errorMessage.value = e.message;
      state.value = ListState.error;
    } catch (e) {
      errorMessage.value = 'Failed to load posts.';
      state.value = ListState.error;
    }
  }

  Future<void> fetchMorePosts() async {
    if (isPaginationLoading.value || !hasMore.value) return;

    isPaginationLoading.value = true;

    try {
      final response = await _repository.getPosts(skip: _skip);
      posts.addAll(response.posts);
      _skip += AppConstants.pageLimit;
      hasMore.value = response.hasMore;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load more posts.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } finally {
      isPaginationLoading.value = false;
    }
  }

  void retry() => fetchPosts();
}

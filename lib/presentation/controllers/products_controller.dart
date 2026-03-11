import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/failures.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/products_repository.dart';

enum ListState { initial, loading, success, error, empty }

class ProductsController extends GetxController {
  final ProductsRepository _repository;

  ProductsController(this._repository);

  final RxList<ProductModel> products = <ProductModel>[].obs;
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
    fetchProducts();
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
        fetchMoreProducts();
      }
    }
  }

  Future<void> fetchProducts() async {
    _skip = 0;
    products.clear();
    state.value = ListState.loading;
    errorMessage.value = '';

    try {
      final response = await _repository.getProducts(skip: _skip);
      if (response.products.isEmpty) {
        state.value = ListState.empty;
      } else {
        products.addAll(response.products);
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
      errorMessage.value = 'Failed to load products.';
      state.value = ListState.error;
    }
  }

  Future<void> fetchMoreProducts() async {
    if (isPaginationLoading.value || !hasMore.value) return;

    isPaginationLoading.value = true;

    try {
      final response = await _repository.getProducts(skip: _skip);
      products.addAll(response.products);
      _skip += AppConstants.pageLimit;
      hasMore.value = response.hasMore;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load more products.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } finally {
      isPaginationLoading.value = false;
    }
  }

  void retry() => fetchProducts();
}

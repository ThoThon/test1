import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../repositories/product_repository.dart';
import '../models/product_model.dart';
import 'mainpage_state.dart';

class MainpageCubit extends Cubit<MainpageState> {
  final refreshController = RefreshController(initialRefresh: false);

  // Pagination
  var currentPage = 1;
  final int pageSize = 10;
  static const int defaultPageNumber = 1;

  MainpageCubit() : super(const MainpageState()) {
    fetchProducts();
  }

  @override
  Future<void> close() {
    refreshController.dispose();
    return super.close();
  }

  /// Lấy danh sách sản phẩm
  Future<void> fetchProducts({bool isLoadMore = false}) async {
    if (!isLoadMore) {
      emit(state.copyWith(isLoading: true));
    }

    try {
      final page = isLoadMore ? currentPage + 1 : defaultPageNumber;

      final result = await ProductRepository.getProducts(
        page: page,
        size: pageSize,
      );

      final List<Product> newProducts;
      if (isLoadMore) {
        newProducts = [...state.products, ...result.products];
      } else {
        newProducts = result.products;
      }

      emit(state.copyWith(
        products: newProducts,
        isLoading: false,
      ));

      // Chỉ cập nhật currentPage khi load thành công
      currentPage = page;
    } catch (e) {
      print("Lỗi fetchProducts: $e");
      _showErrorSnackbar("Có lỗi xảy ra khi tải dữ liệu");
    } finally {
      if (isLoadMore) {
        refreshController.loadComplete();
      } else {
        emit(state.copyWith(isLoading: false));
        refreshController.refreshCompleted();
      }
    }
  }

  /// Pull to refresh
  Future<void> onRefresh() async {
    await fetchProducts(isLoadMore: false);
  }

  /// Load more
  Future<void> onLoadMore() async {
    await fetchProducts(isLoadMore: true);
  }

  void _showErrorSnackbar(String message) {
    emit(state.copyWith(errorMessage: message));
  }
}

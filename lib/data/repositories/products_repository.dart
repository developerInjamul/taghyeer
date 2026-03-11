import '../../core/constants/app_constants.dart';
import '../datasources/remote/remote_datasource.dart';
import '../models/product_model.dart';

class ProductsRepository {
  final RemoteDataSource _remote;

  ProductsRepository(this._remote);

  Future<ProductsResponse> getProducts({required int skip}) async {
    return _remote.getProducts(skip: skip, limit: AppConstants.pageLimit);
  }
}

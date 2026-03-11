import '../../core/constants/app_constants.dart';
import '../../core/network/network_client.dart';
import '../models/post_model.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';

class RemoteDataSource {
  final NetworkClient _client;

  RemoteDataSource(this._client);

  Future<UserModel> login(String username, String password) async {
    return _client.post<UserModel>(
      AppConstants.loginEndpoint,
      data: {
        'username': username,
        'password': password,
        'expiresInMins': 30,
      },
      fromJson: UserModel.fromJson,
    );
  }

  Future<ProductsResponse> getProducts({
    required int skip,
    int limit = AppConstants.pageLimit,
  }) async {
    return _client.get<ProductsResponse>(
      AppConstants.productsEndpoint,
      queryParameters: {'limit': limit, 'skip': skip},
      fromJson: ProductsResponse.fromJson,
    );
  }

  Future<PostsResponse> getPosts({
    required int skip,
    int limit = AppConstants.pageLimit,
  }) async {
    return _client.get<PostsResponse>(
      AppConstants.postsEndpoint,
      queryParameters: {'limit': limit, 'skip': skip},
      fromJson: PostsResponse.fromJson,
    );
  }
}

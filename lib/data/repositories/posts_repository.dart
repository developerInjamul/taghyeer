import '../../core/constants/app_constants.dart';
import '../datasources/remote/remote_datasource.dart';
import '../models/post_model.dart';

class PostsRepository {
  final RemoteDataSource _remote;

  PostsRepository(this._remote);

  Future<PostsResponse> getPosts({required int skip}) async {
    return _remote.getPosts(skip: skip, limit: AppConstants.pageLimit);
  }
}

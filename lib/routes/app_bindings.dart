import 'package:get/get.dart';
import '../core/network/network_client.dart';
import '../data/datasources/remote/remote_datasource.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/posts_repository.dart';
import '../data/repositories/products_repository.dart';
import '../presentation/controllers/auth_controller.dart';
import '../presentation/controllers/navigation_controller.dart';
import '../presentation/controllers/posts_controller.dart';
import '../presentation/controllers/products_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Network
    final client = NetworkClient();
    client.init();
    Get.put<NetworkClient>(client, permanent: true);

    // Data Sources
    Get.put<RemoteDataSource>(
      RemoteDataSource(Get.find()),
      permanent: true,
    );

    // Repositories
    Get.put<AuthRepository>(
      AuthRepository(Get.find()),
      permanent: true,
    );
    Get.put<ProductsRepository>(
      ProductsRepository(Get.find()),
      permanent: true,
    );
    Get.put<PostsRepository>(
      PostsRepository(Get.find()),
      permanent: true,
    );

    // Controllers
    Get.put<AuthController>(
      AuthController(Get.find()),
      permanent: true,
    );
    Get.put<NavigationController>(
      NavigationController(),
      permanent: true,
    );
    Get.put<ProductsController>(
      ProductsController(Get.find()),
      permanent: true,
    );
    Get.put<PostsController>(
      PostsController(Get.find()),
      permanent: true,
    );
  }
}

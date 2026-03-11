import 'package:get/get.dart';
import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/home_screen.dart';
import '../presentation/screens/products/product_detail_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String productDetail = '/product-detail';

  static List<GetPage> pages = [
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: home, page: () => const HomeScreen()),
    GetPage(name: productDetail, page: () => const ProductDetailScreen()),
  ];
}

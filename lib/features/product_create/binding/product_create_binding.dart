import 'package:get/get.dart';

import '../controller/product_create_controller.dart';

class ProductCreateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductCreateController>(() => ProductCreateController());
  }
}

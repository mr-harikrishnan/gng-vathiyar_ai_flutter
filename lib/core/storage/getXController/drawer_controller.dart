import 'package:get/get.dart';

class DrawerController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  void updateSelectedIndex(int index) {
    selectedIndex.value = index;
  }
}

import 'app_model.dart';

class AppController {
  AppController(this.model);
  AppModel_ model;

  Future<void> boostrap() async {}

  Future<void> authenticate() async {}

  Future<void> saveWindowSize() async {}

  Future<void> updateMenuBar() async {}

  Future<void> setCurrentBook() async {}

  Future<void> setCurrentPage() async {}
}

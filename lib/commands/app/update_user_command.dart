import '../../data/app_user.dart';
import '../commands.dart';

class UpdateUserCommand extends BaseAppCommand {
  Future<void> run(AppUser user) async {
    if (appModel.currentUser == null) return;
    appModel.currentUser = user;
    await firebase.setUserData(user);
  }
}

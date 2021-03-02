import 'package:flutter_folio/commands/commands.dart';
import 'package:flutter_folio/data/app_user.dart';

class UpdateUserCommand extends BaseAppCommand {
  Future<void> run(AppUser user) async {
    appModel.currentUser = user;
    await firebase.setUserData(user);
  }
}

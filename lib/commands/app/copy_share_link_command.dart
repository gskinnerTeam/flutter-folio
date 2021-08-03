import 'package:flutter/services.dart';
import 'package:share/share.dart';

import '../../_utils/device_info.dart';
import '../../_utils/timed/cooldown.dart';
import '../../routing/app_link.dart';
import '../../styled_widgets/toaster.dart';
import '../commands.dart';

class CopyShareLinkCommand extends BaseAppCommand {
  String get baseUrl => "https://flutterfolio.com/#";
  static CoolDown mobileShareCooldown = CoolDown(const Duration(seconds: 1));

  Future<void> run(String bookId, {String? pageId}) async {
    // Form a url using an AppLink
    String url = baseUrl +
        AppLink(
          user: appModel.currentUserEmail,
          bookId: bookId,
          pageId: pageId,
        ).toLocation();

    // Device clipboard
    if (DeviceOS.isDesktopOrWeb) {
      Toaster.showToast(mainContext, "Share link copied!");
      Clipboard.setData(ClipboardData(text: url));
    }
    // Mobile share sheet
    else {
      // Put this on a cool-down, prevents a bug in the share api where it can open multiple sheets.
      mobileShareCooldown.run(() => Share.share(url));
    }
  }
}

import 'package:flutter_folio/commands/commands.dart';

//TODO: Should we pull this feature completely since it's not supported on Windows?
class RefreshMenuBarCommand extends BaseAppCommand {
  Future<void> run() async {
    // bool isDesktop = (UniversalPlatform.isWindows || UniversalPlatform.isMacOS || UniversalPlatform.isLinux);
    // // Exit early if we're not on Desktop, this API does nothing.
    // if (isDesktop == false) return;
    // // Don't use applicationMenu for Windows, we can't since we're using a custom TitleBar
    // if (UniversalPlatform.isWindows == false) {
    //   setApplicationMenu(
    //     [
    //       Submenu(label: 'File', children: [
    //         if (appModel.isAuthenticated) ...[
    //           MenuItem(
    //               label: 'Log Out',
    //               enabled: true,
    //               //shortcut: LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.escape),
    //               onClicked: () => SetCurrentUserCommand().run(null)),
    //         ],
    //         MenuItem(
    //             label: 'Close Application',
    //             enabled: true,
    //             //shortcut: LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.escape),
    //             onClicked: () => exit(0)),
    //       ]),
    //       //TODO: Add all the firebase books and sub pages into the menu??? Stretch goal!
    //       // if (appModel.isLoggedIn) ...{
    //       //   Submenu(label: 'View', children: [
    //       //     MenuItem(
    //       //         label: 'Home',
    //       //         enabled: true,
    //       //         shortcut: LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.numpad1),
    //       //         onClicked: () {}),
    //       //     MenuDivider(),
    //       //     // TODO: Maybe should pump the current state of the app in here.
    //       //     // This requires watching both user.books and user.books[i].pages for every item. Not cheap... think it over.
    //       //     // Maybe just deeplinking to books makes the point? Would be a cool demo to see all the firebase page names right in the file file menu...
    //       //     Submenu(label: 'Book 1', children: [
    //       //       MenuItem(label: 'Page 1', enabled: true, onClicked: () {}),
    //       //       MenuItem(label: 'Page 2', enabled: true, onClicked: () {}),
    //       //       MenuItem(label: 'Page 3', enabled: true, onClicked: () {}),
    //       //       MenuItem(label: 'Page 4', enabled: true, onClicked: () {}),
    //       //     ]),
    //       //     Submenu(label: 'Book 2', children: [
    //       //       MenuItem(label: 'Page 1', enabled: true, onClicked: () {}),
    //       //       MenuItem(label: 'Page 2', enabled: true, onClicked: () {}),
    //       //       MenuItem(label: 'Page 3', enabled: true, onClicked: () {}),
    //       //       MenuItem(label: 'Page 4', enabled: true, onClicked: () {}),
    //       //     ]),
    //       //     Submenu(label: 'Book 3', children: [
    //       //       MenuItem(label: 'Page 1', enabled: true, onClicked: () {}),
    //       //       MenuItem(label: 'Page 2', enabled: true, onClicked: () {}),
    //       //       MenuItem(label: 'Page 3', enabled: true, onClicked: () {}),
    //       //       MenuItem(label: 'Page 4', enabled: true, onClicked: () {}),
    //       //     ])
    //       //   ])
    //       // },
    //     ],
    //   );
  }
}

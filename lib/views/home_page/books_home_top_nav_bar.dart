import 'package:flutter/material.dart';
import 'package:flutter_folio/commands/books/create_folio_command.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/data/app_user.dart';
import 'package:flutter_folio/models/app_model.dart';
import 'package:flutter_folio/models/books_model.dart';

class BooksHomeTopNavBar extends StatelessWidget {
  const BooksHomeTopNavBar({Key key, this.invertText, this.onToggled, this.showListView}) : super(key: key);
  final void Function(bool value) onToggled;
  final bool showListView;
  final bool invertText;

  @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of(context);
    AppUser user = context.select((AppModel m) => m.currentUser);
    int pageCount = context.select((BooksModel m) => m.books?.length ?? 0);
    String name = user.getDisplayName();
    return LayoutBuilder(
      builder: (_, constraints) {
        bool breakText = (constraints.maxWidth < 700);
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: Insets.offset, vertical: Insets.lg),
          child: Row(
            children: [
              SelectableText.rich(
                TextSpan(
                  text: 'Good $_dayPeriod',
                  style:
                      TextStyles.body1.copyWith(height: 1.2, color: showListView ? theme.greyMedium : theme.surface1),
                  children: <TextSpan>[
                    if (name != null) TextSpan(text: " " + name, style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: ". ${breakText ? "\n" : ""}You've created "),
                    TextSpan(
                        text: " ${pageCount} folio${pageCount == 1 ? "" : "s"}",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: " in total."),
                  ],
                ),
              ),
              Spacer(),
              SecondaryBtn(
                  label: "NEW FOLIO",
                  icon: Icons.add,
                  onPressed: () => _handleAddBookPressed(context),
                  leadingIcon: true),
              HSpace.med,
              StyledToggleSwitch(
                  value: showListView,
                  icon1: AppIcons.toggle_carousel,
                  tooltip1: "Grid View",
                  icon2: AppIcons.toggle_list,
                  tooltip2: "List View",
                  onToggled: onToggled),
            ],
          ),
        );
      },
    );
  }

  void _handleAddBookPressed(BuildContext context) => CreateFolioCommand().run();

  String get _dayPeriod {
    int timeNow = DateTime.now().hour;
    if (timeNow > 18) return "evening";
    if (timeNow > 12) return "afternoon";
    return "morning";
  }
}

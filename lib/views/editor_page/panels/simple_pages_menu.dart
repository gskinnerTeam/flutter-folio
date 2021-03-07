import 'package:flutter/material.dart';
import 'package:flutter_folio/_utils/string_utils.dart';
import 'package:flutter_folio/_widgets/rounded_card.dart';
import 'package:flutter_folio/commands/books/set_current_page_command.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/data/book_data.dart';
import 'package:flutter_folio/models/app_model.dart';

class SimplePagesMenu extends StatelessWidget {
  SimplePagesMenu(this.pages, {this.selectedPageId});

  final String selectedPageId;
  final List<ScrapPageData> pages;

  @override
  Widget build(BuildContext context) {
    bool touchMode = context.select((AppModel m) => m.enableTouchMode);
    double pageScrollerHeight = touchMode ? 80 : 65;
    // Pages list
    return GlassCard(
      alpha: .3,
      radius: BorderRadius.zero,
      child: AnimatedContainer(
        duration: Times.fast,
        curve: Curves.easeOut,
        height: pageScrollerHeight,
        padding: EdgeInsets.symmetric(horizontal: Insets.xs, vertical: Insets.lg),
        color: Colors.white.withOpacity(.7),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: pages
              .map((data) => _PageBtn(
                  label: data.title,
                  onPressed: () => _handlePageBtnPressed(context, data),
                  isSelected: data.documentId == selectedPageId))
              .toList(),
        ),
      ),
    );
  }

  void _handlePageBtnPressed(BuildContext context, ScrapPageData data) => SetCurrentPageCommand().run(data);
}

class _PageBtn extends StatelessWidget {
  _PageBtn({@required this.label, this.isSelected = false, this.onPressed});

  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    Color bgColor = isSelected ? theme.accent1.withOpacity(.1) : theme.surface1.withOpacity(.7);
    Color fgColor = isSelected ? theme.accent1 : theme.grey;
    TextStyle textStyle = isSelected ? TextStyles.body3 : TextStyles.body2;
    String title = StringUtils.isEmpty(label) ? "Untitled" : label;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Insets.med / 2),
      child: SimpleBtn(
        onPressed: onPressed,
        child: RoundedBorder(
          radius: Corners.med,
          color: fgColor,
          width: 1.5,
          child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: 110),
              child: Container(
                  color: bgColor,
                  alignment: Alignment.center,
                  child: Text(title, style: textStyle.copyWith(color: fgColor)))),
        ),
      ),
    );
  }
}

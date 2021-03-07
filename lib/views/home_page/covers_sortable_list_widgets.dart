import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_folio/_widgets/animated/animated_rotation.dart';
import 'package:flutter_folio/_widgets/context_menu_overlay.dart';
import 'package:flutter_folio/_widgets/gradient_container.dart';
import 'package:flutter_folio/commands/app/copy_share_link_command.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/data/book_data.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'covers_sortable_list.dart';

enum BookColumnAlignment {
  Left,
  Center,
  Right,
  All,
}

class BookColumnHeader extends StatelessWidget {
  const BookColumnHeader(
    this.label, {
    this.sortLabel,
    Key key,
    this.onPressed,
    this.width,
    this.height,
    this.hzAlignment = BookColumnAlignment.Center,
    this.sortDir,
  }) : super(key: key);
  final String label;
  final String sortLabel;
  final VoidCallback onPressed;
  final double sortDir;
  final double width;
  final double height;
  final BookColumnAlignment hzAlignment;

  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    final radii = _clipRadiiFromAlignment(hzAlignment);
    return SimpleBtn(
      onPressed: _handlePressed,
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: Insets.lg),
        decoration: BoxDecoration(
          color: theme.surface1,
          // The left-most and right most headers have rounded corners
          borderRadius: BorderRadius.horizontal(left: radii[0], right: radii[1]),
        ),
        child: Stack(
          children: [
            Row(
              children: [
                Text(label,
                    style: sortLabel == null
                        ? TextStyles.body3.copyWith(color: theme.greyStrong)
                        : TextStyles.body2.copyWith(color: theme.greyStrong)),
                if (sortLabel == null) ...[
                  AnimatedOpacity(
                    duration: sortDir != 0 ? Times.fast : Duration.zero,
                    opacity: sortDir != 0 ? 1 : 0,
                    child: AnimatedRotation(
                      begin: sortDir == -1 ? 0 : 180,
                      duration: Times.fast,
                      child: Icon(Icons.keyboard_arrow_down),
                    ),
                  ),
                ],
              ],
            ),
            if (sortLabel != null) ...[
              Row(
                textDirection: TextDirection.rtl,
                children: [
                  HSpace(Insets.lg),
                  AnimatedOpacity(
                    duration: sortDir != 0 ? Times.fast : Duration.zero,
                    opacity: sortDir != 0 ? 1 : 0,
                    child: AnimatedRotation(
                      begin: sortDir == -1 ? 0 : 180,
                      duration: Times.fast,
                      child: Icon(Icons.keyboard_arrow_down),
                    ),
                  ),
                  Text(sortLabel, style: TextStyles.body3.copyWith(color: theme.greyStrong)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _handlePressed() => onPressed?.call();
}

class BookRowItem extends StatelessWidget {
  const BookRowItem(this.width, this.height, this.data,
      {Key key, this.hzAlignment = BookColumnAlignment.Center, this.type = ColType.Name})
      : super(key: key);
  final double width;
  final double height;
  final ScrapBookData data;
  final BookColumnAlignment hzAlignment;
  final ColType type;

  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    Widget content = Container();
    if (type == ColType.Name) {
      content = ImageAndNameContent(data, width: width);
    } else if (type == ColType.Created) {
      content = TextContent(text: timeago.format(data.getCreationDate()));
    } else if (type == ColType.Modified) {
      content = TextContent(text: timeago.format(data.getLastModifiedDate()));
    }
    //print(ContextUtils.getSize(context));
    final radii = _clipRadiiFromAlignment(hzAlignment);
    return Stack(
      children: [
        // Hide the DataRow btn (allows the gaps to feel like gaps, instead of always having a hand cursor)
        MouseRegion(cursor: SystemMouseCursors.basic, child: Container(color: theme.bg1)),
        // Align the content to the bottom, allowing for a gap along top top.
        ContextMenuRegion(
          contextMenu: BookContextMenu(data),
          child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: height,
                width: width,
                // Clip content on the left-side
                child: ClipRRect(
                  borderRadius: BorderRadius.horizontal(
                    left: radii[0],
                    right: radii[1],
                  ),
                  child: content,
                ),
              )),
        ),
      ],
    );
  }
}

class ImageAndNameContent extends StatelessWidget {
  const ImageAndNameContent(this.data, {Key key, @required this.width}) : super(key: key);
  final double width;
  final ScrapBookData data;

  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    return Stack(
      children: [
        // Bg Image
        Positioned.fill(child: BookCoverImage(data)),

        // Black Fade
        Align(
          alignment: Alignment.centerRight,
          child: HzGradient([Colors.black.withOpacity(0), Colors.black.withOpacity(1)], [0, 1], width: 400),
        ),

        FadeIn(
          duration: Times.medium,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: VtGradient([Colors.black.withOpacity(0), Colors.black.withOpacity(1)], [0, 1], height: 100),
          ),
        ),

        // TextContent
        Positioned(
          bottom: Insets.lg,
          left: Insets.lg,
          child: Row(
            children: [
              StyledSharedBtn(book: data),
              HSpace.lg,
              Text(
                data.title,
                key: ValueKey(data.documentId),
                style: TextStyles.h2.copyWith(color: theme.surface1),
              ),
              HSpace.lg,
            ],
          ),
        ),
      ],
    );
  }

  void _handleSharePressed() => CopyShareLinkCommand().run(data.documentId);
}

class TextContent extends StatelessWidget {
  const TextContent({Key key, this.text}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    return ExcludeFocus(
      excluding: true,
      child: Container(
        color: Colors.black,
        alignment: Alignment.bottomLeft,
        padding: EdgeInsets.only(bottom: Insets.lg, left: Insets.lg + Insets.sm),
        child: Text(text, style: TextStyles.body1.copyWith(color: theme.surface1)),
      ),
    );
  }
}

List<Radius> _clipRadiiFromAlignment(BookColumnAlignment alignment) {
  Radius leftRadius = Radius.zero, rightRadius = Radius.zero;
  switch (alignment) {
    case BookColumnAlignment.Left:
      leftRadius = Corners.medRadius;
      break;
    case BookColumnAlignment.Right:
      rightRadius = Corners.medRadius;
      break;
    case BookColumnAlignment.All:
      leftRadius = rightRadius = Corners.medRadius;
      break;
    default:
  }
  return [leftRadius, rightRadius];
}

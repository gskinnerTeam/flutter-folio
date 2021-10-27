import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_folio/_utils/input_utils.dart';
import 'package:flutter_folio/_widgets/animated/animated_scale.dart' as amscale;
import 'package:flutter_folio/_widgets/gradient_container.dart';
import 'package:flutter_folio/_widgets/rounded_card.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/data/book_data.dart';
import 'package:flutter_folio/views/home_page/book_cover/book_cover_large.dart';
import 'package:flutter_folio/views/home_page/book_cover/book_cover_small.dart';
import 'package:provider/provider.dart';

/// Represents the Cover for one ScrapBook.
/// Supports 2 modes, and holds the shared elements between the modes, like the imageBg, gradients etc
/// `bool largeMode` toggles between 2 different child widgets (cover_small, cover_large)
/// This is the main card used in [CoversFlowList]], for both the list items, and the primary content area
class BookCoverWidget extends StatefulWidget {
  const BookCoverWidget(
    this.data, {
    Key? key,
    this.isSelected = false,
    this.onPressed,
    this.largeMode = false,
    this.topTitle = false,
  }) : super(key: key);
  final ScrapBookData data;
  final bool isSelected;
  final bool largeMode;
  final bool topTitle;
  final void Function(Offset globalPos)? onPressed;

  @override
  _BookCoverWidgetState createState() => _BookCoverWidgetState();
}

class _BookCoverWidgetState extends State<BookCoverWidget> {
  final FocusNode _focusNode = FocusNode();

  bool _isMouseOver = false;
  set isOver(bool value) {
    if (value == _isMouseOver) return;
    setState(() => _isMouseOver = value);
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of(context);
    bool isClickable = _isMouseOver && widget.onPressed != null;
    double overlayOpacity = 0;
    // 'clickable' cards fade out their overlay when mouse is over
    if (widget.onPressed != null) {
      overlayOpacity = _isMouseOver ? 0 : .3;
    }
    return AnimatedSwitcher(
      duration: Duration(milliseconds: widget.isSelected ? 0 : 200),
      child: widget.isSelected
          ? Container(color: Colors.white.withOpacity(.2))
          : MouseRegion(
              opaque: false,
              cursor: isClickable ? SystemMouseCursors.click : MouseCursor.defer,
              onEnter: (_) => isOver = true,
              onHover: (_) => isOver = true,
              onExit: (_) => isOver = false,
              child: Stack(fit: StackFit.expand, children: [
                /// /////////////////////////////
                /// Background Image
                // Animated scale for when we mouse-over
                amscale.AnimatedScale(
                  duration: Times.slow,
                  begin: 1,
                  end: isClickable ? 1.1 : 1,
                  child: BookCoverImage(widget.data),
                ),

                /// Black overlay, fades out on mouseOver
                if (overlayOpacity > 0)
                  AnimatedContainer(
                      duration: Times.slow,
                      color: Colors.black.withOpacity(overlayOpacity),
                  ),

                /// When in large mode, show some gradients, should sit under the Text elements
                if (widget.largeMode) ...[
                  FadeInLeft(
                    duration: Times.slower,
                    child: const _SideGradient(Colors.black),
                  ),
                  FadeInUp(child: const _BottomGradientLg(Colors.black))
                ] else ...[
                  FadeInUp(child: const _BottomGradientSm(Colors.black)),
                ],

                /// Sit under the text content, and unfocus when tapped.
                GestureDetector(behavior: HitTestBehavior.translucent, onTap: InputUtils.unFocus),

                /// BookContent, shows either the Large cover or Small
                Align(
                  alignment: widget.topTitle ? Alignment.topLeft : Alignment.bottomLeft,
                  // Tween the padding depending on which mode we're in
                  child: AnimatedContainer(
                    duration: Times.slow,
                    padding: EdgeInsets.all(widget.largeMode ? Insets.offset : Insets.sm),
                    child: (widget.largeMode)
                        ? LargeBookCover(widget.data)
                        : SmallBookCover(widget.data, topTitle: widget.topTitle),
                  ),
                ),

                /// Mouse-over effect
                if (isClickable) ...[
                  Positioned.fill(child: FadeIn(child: RoundedBorder(color: theme.accent1, ignorePointer: false))),
                ],
              ]),
            ),
    );
  }
}

class _SideGradient extends StatelessWidget {
  const _SideGradient(this.color, {Key? key}) : super(key: key);
  final Color color;

  @override
  Widget build(BuildContext context) => HzGradient(
        [color.withOpacity(.8), color.withOpacity(0)],
        const [.15, .8],
      );
}

class _BottomGradientLg extends StatelessWidget {
  const _BottomGradientLg(this.color, {Key? key}) : super(key: key);
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: GradientContainer(
        [color.withOpacity(1), color.withOpacity(1), color.withOpacity(0)],
        const [.2, .55, 1],
        height: 300,
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      ),
    );
  }
}

class _BottomGradientSm extends StatelessWidget {
  const _BottomGradientSm(this.color, {Key? key}) : super(key: key);
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: VtGradient(
        [color.withOpacity(0), color.withOpacity(.8)],
        const [0, 1],
        height: 60,
      ),
    );
  }
}

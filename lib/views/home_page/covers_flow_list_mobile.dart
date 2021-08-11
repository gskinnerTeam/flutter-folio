import 'package:animate_do/animate_do.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/data/book_data.dart';
import 'package:flutter_folio/views/home_page/book_cover/book_cover.dart';

/// Holds a list of [BookCover] and a Stack that features one of them in a Fullscreen format.
class CoversFlowListMobile extends StatefulWidget {
  const CoversFlowListMobile({Key? key, required this.books}) : super(key: key);
  final List<ScrapBookData> books;

  @override
  _CoversFlowListMobileState createState() => _CoversFlowListMobileState();
}

class _CoversFlowListMobileState extends State<CoversFlowListMobile> {
  bool _isResting = true;
  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_handlePageChange);
  }

  @override
  Widget build(BuildContext context) {
    int nextPage = (_currentPage + 2).clamp(0, widget.books.length - 1);
    ScrapBookData? nextBook = nextPage == _currentPage ? null : widget.books[nextPage];
    return StyledPageScaffold(
      body: ClipRect(
          child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.books.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (_, index) => BookCoverWidget(widget.books[index], largeMode: true),
          ),
          if (_isResting && nextBook != null)
            Positioned.fill(
              child: FadeInUp(
                child: FractionalTranslation(
                  translation: const Offset(0, 1),
                  child: Transform.translate(
                      offset: const Offset(0, -150),
                      child: Transform.scale(
                        scale: .9,
                        child: BookCoverWidget(nextBook, topTitle: true),
                      )),
                ),
              ),
            ),
        ],
      )),
    );
  }

  void _handlePageChange() {
    bool isResting = _pageController.page?.roundToDouble() == _pageController.page;
    if (_isResting) {
      _currentPage = _pageController.page?.round() ?? 0;
    }
    if (isResting != _isResting) setState(() => _isResting = isResting);
  }
}

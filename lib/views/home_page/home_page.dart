import 'package:flutter/material.dart';
import 'package:flutter_folio/_widgets/gradient_container.dart';
import 'package:flutter_folio/commands/books/create_folio_command.dart';
import 'package:flutter_folio/commands/books/refresh_all_books_command.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/data/book_data.dart';
import 'package:flutter_folio/models/books_model.dart';

import 'covers_flow_list.dart';
import 'covers_flow_list_mobile.dart';
import 'covers_sortable_list.dart';
import 'home_nav_bar.dart';
import 'home_nav_bar_mobile.dart';

class BooksHomePage extends StatefulWidget {
  const BooksHomePage({Key? key}) : super(key: key);

  @override
  BooksHomePageState createState() => BooksHomePageState();
}

class BooksHomePageState extends State<BooksHomePage> {
  bool _showListView = false;

  @override
  void initState() {
    super.initState();
    RefreshAllBooks().run();
  }

  @override
  Widget build(BuildContext context) {
    List<ScrapBookData>? books = context.select((BooksModel m) => m.books);
    bool showSmallScreenView = context.widthPx < 600;
    books?.sort((a, b) => a.lastModifiedTime > b.lastModifiedTime ? -1 : 1);
    return books == null
        ? const LoadingIndicator()
        : StyledPageScaffold(
            key: const ValueKey('StyledPageScaffold'),
            body: Stack(
              children: [
                // Content Area
                if (books.isEmpty) ...[
                  _EmptyHomeView(),
                ] else ...[
                  _showListView
                      ? CoversSortableList(books: books, isMobile: showSmallScreenView)
                      : showSmallScreenView
                          ? CoversFlowListMobile(books: books)
                          : CoversFlowList(books: books),
                ],

                // On small devices, use a TabMenu that is bottom aligned
                if (showSmallScreenView) ...[
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: HomeNavTabMenu(onToggled: _handleViewToggled, showListView: _showListView),
                  ),
                ]
                // On larger devices, use a top aligned toggle button with extra information
                else ...[
                  HomeNavToggleMenu(
                    onToggled: _handleViewToggled,
                    showListView: _showListView,
                    hideButtons: showSmallScreenView,
                  ),
                ]
              ],
            ),
          );
    //  },
    //);
  }

  void _handleViewToggled(bool value) => setState(() => _showListView = value);
}

class _EmptyHomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(fit: StackFit.expand, children: [
      // Bg w/ Gradient
      Positioned.fill(child: Image.asset("assets/images/empty_home_bg.png", fit: BoxFit.cover)),
      Align(alignment: Alignment.topLeft, child: _SideGradient()),

      Padding(
        padding: EdgeInsets.all(Insets.offset),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Spacer(),
          Text("Welcome to Flutter Folio!", style: TextStyles.h1.copyWith(color: Colors.white)),
          VSpace.sm,
          SizedBox(
            width: 380,
            child: Text(
                "Create beautiful scrap books and share them with your friends and family. To get started, create a new Folio and upload some pictures!",
                style: TextStyles.body1.copyWith(color: Colors.white)),
          ),
          VSpace.xl,
          Row(
            children: [
              PrimaryBtn(onPressed: _handleNewFolioPressed, label: "YOUR FIRST FOLIO", icon: Icons.add),
            ],
          ),
          const Spacer(),
        ]),
      ),
    ]);
  }

  void _handleNewFolioPressed() => CreateFolioCommand().run();
}

class _SideGradient extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SizedBox(
        width: 800,
        child: HzGradient([Colors.black.withOpacity(.75), Colors.black.withOpacity(0)], const [.2, 1]),
      );
}

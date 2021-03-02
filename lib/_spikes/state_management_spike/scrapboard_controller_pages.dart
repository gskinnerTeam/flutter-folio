import 'package:flutter/material.dart';

import 'scrapboard_model.dart';

class PagesController {
  PagesController(this.model);
  final ScrapboardModel model;

  // Pages (depends on bookId)
  Future<void> create({@required String bookId}) async {
    // // Mark book as changed
    // int count = setPageCountCommand().increment(bookId: bookId);
    //
    // String pageId = await firebase.addPage(ScrapPageData(
    //   bookId: bookId,
    //   title: "Page $count",
    //   desc: "Add a description...",
    //   boxOrder: [],
    // ));
    // // Add a hidden scrap, this sidesteps a bug in firedart regarding empty collections. //TODO: Remove when firedart is replaced
    // ScrapItem emptyScrap = ScrapItem(bookId: bookId, contentType: ContentType.Hidden, data: "");
    // await CreatePlacedScrapCommand().run(pageId: pageId, size: Size.zero, scraps: [emptyScrap]);
    //
    // // Select the new page
    // SetCurrentPageCommand().run(pageId: pageId);
  }
  Future<void> refresh() async {}
  Future<void> refreshAll() async {}
  Future<void> update() async {}
  Future<void> delete() async {}
}

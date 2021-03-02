import 'scrapboard_model.dart';

class ScrapsController {
  ScrapsController(this.model);
  final ScrapboardModel model;

  // Scrap Pile
  Future<void> createScrap() async {}
  Future<void> refreshAllScraps() async {}
  Future<void> deleteScrap() async {}
  //scrapPile.all

  // Placed Scraps
  Future<void> createPlacedScrap() async {}
  Future<void> refreshAllPlacedScrap() async {}
  Future<void> updatePlacedScrap() async {}
  Future<void> sendPlacedScrapForward() async {}
  Future<void> movePlacedScrapBack() async {}
  Future<void> deletePlacedScrap() async {}
}

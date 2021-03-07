part of 'scrap_pile_picker.dart';

/// Stateless view that is uses [ScrapPilePickerState] as it's controller
/// It couples directly to ScrapPileGridState to reduce boilerplate, rather than exposing a ton of params and callbacks.
class ScrapPilePickerView extends StatelessWidget {
  const ScrapPilePickerView({Key key, @required this.state, @required this.bookScraps}) : super(key: key);
  final ScrapPilePickerState state;
  final List<ScrapItem> bookScraps;

  ScrollController get _scrollController => state._scrollController;
  List<String> get _selectedIds => state._selectedIds;
  bool get _mobileMode => state.widget.mobileMode;

  @override
  Widget build(BuildContext context) {
    if (bookScraps == null) return LoadingIndicator();
    //TODO: Feature this code snippet
    // Depending on the mode, we'll have different btns for adding images
    List<Widget> btns = [
      if (_mobileMode && DeviceInfo.isDesktop == false) ...[
        _TileBtn("Take photo", AppIcons.camera, () => state._handlePickImagesPressed(true)),
        _TileBtn("Choose from library", AppIcons.image, () => state._handlePickImagesPressed(false))
      ] else ...[
        _TileBtn("Import images", AppIcons.add, state._handlePickImagesPressed)
      ]
    ];
    return VisibilityDetector(
      onVisibilityChanged: state._handleVisibilityChanged,
      key: ValueKey("scrap-pile"),
      child: FocusTraversalGroup(
        child: GestureDetector(
          onTap: state._handleBgTapped,
          child: LayoutBuilder(
            builder: (_, constraints) {
              /// Calculate colCount depending on width of parent
              int colCount = (constraints.maxWidth / 250).ceil();

              /// TODO: All sorting should be moved into the RefreshCommands
              bookScraps.sort((itemA, itemB) => itemA.creationTime < itemB.creationTime ? 1 : -1);
              state._bookScraps = bookScraps;
              int imgCount = bookScraps.length;
              int selectedCount = _selectedIds.length;
              String titleText = "Scraps ($imgCount ${StringUtils.pluralize("image", imgCount)})";

              return Column(
                children: [
                  // Top section has TitleBar and GridView + a gradient background
                  Flexible(
                    child: Stack(
                      children: [
                        /// Bg Gradient
                        VtGradient(
                          [Colors.black.withOpacity(0), Colors.black.withOpacity(.05)],
                          [.6, 1],
                        ),

                        // Make sure scraps are sorted by creation time
                        Column(
                          children: [
                            /// Top Title Bar
                            FocusTraversalGroup(
                              child: ScrapPilePickerTitleBar(
                                onClosePressed: () => CloseNotification().dispatch(context),
                                onSelectAllPressed: state._handleSelectAllPressed,
                                title: titleText,
                                isAllSelected: selectedCount == imgCount,
                                mobileMode: _mobileMode,
                              ),
                            ),

                            /// Grid List
                            Flexible(
                                child: FocusTraversalGroup(
                              child: Padding(
                                // Scrollbar requires some weird padding since we want it to hang in the gutter
                                padding: EdgeInsets.only(right: Insets.xs, left: Insets.lg),
                                child: StyledScrollbar(
                                  controller: _scrollController,
                                  child: GridView.count(
                                      crossAxisCount: colCount,
                                      crossAxisSpacing: Insets.sm,
                                      mainAxisSpacing: Insets.sm,
                                      padding: EdgeInsets.only(bottom: Insets.lg),
                                      childAspectRatio: 1.5,
                                      controller: _scrollController,
                                      // Length of list is our btns + allScraps
                                      children: List.generate(bookScraps.length + btns.length, (index) {
                                        // Offset the index back, to account for the extra btns
                                        int scrapIndex = index - btns.length;
                                        // If index is not valid, it must be a btn
                                        if (scrapIndex < 0) return btns[index];
                                        ScrapItem scrap = bookScraps[scrapIndex];
                                        return ContextMenuRegion(
                                          contextMenu: GenericContextMenu(
                                              labels: state.widget.contextMenuLabels?.call(scrap),
                                              actions: state.widget.contextMenuActions?.call(scrap)),
                                          child: ScrapPickerBtn(
                                              key: ValueKey(scrap.documentId),
                                              img: scrap.data,
                                              isSelected: _selectedIds.contains(scrap.documentId),
                                              onPressed: () => state._handleScrapPressed(scrapIndex)),
                                        );
                                      })),
                                ),
                              ),
                            )),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class GridBtn extends StatelessWidget {
  const GridBtn({Key key, this.onPressed, this.bgColor, this.child}) : super(key: key);
  final VoidCallback onPressed;
  final Color bgColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SimpleBtn(
      onPressed: onPressed,
      cornerRadius: Corners.med,
      child: ClipRRect(
        borderRadius: Corners.medBorder,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: bgColor ?? Colors.transparent,
          child: child,
        ),
      ),
    );
  }
}

class _TileBtn extends StatelessWidget {
  const _TileBtn(this.label, this.icon, this.onPressed, {Key key}) : super(key: key);
  final String label;
  final AppIcons icon;
  final VoidCallback onPressed;

  Widget build(BuildContext context) {
    AppTheme theme = context.watch();
    return Padding(
      padding: EdgeInsets.all(Insets.xs),
      child: GridBtn(
        onPressed: onPressed,
        //child: Container(width: double.infinity, height: double.infinity, color: Colors.red, child: Text("TEST")),
        child: Stack(
          children: [
            PositionedAll(
              all: 2,
              child: DottedBorder(
                  radius: Corners.medRadius,
                  dashPattern: [6, 3],
                  strokeWidth: 1,
                  padding: EdgeInsets.zero,
                  color: theme.grey,
                  child: Container()),
            ),
            Container(
              alignment: Alignment.center,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                AppIcon(icon, size: 16, color: theme.grey),
                VSpace.sm,
                Text(label, style: TextStyles.body2.copyWith(color: theme.mainTextColor)),
              ]),
            )
          ],
        ),
      ),
    );
  }
}

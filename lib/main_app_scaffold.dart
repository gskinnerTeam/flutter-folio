import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_folio/_widgets/context_menu_overlay.dart';
import 'package:flutter_folio/_widgets/popover/popover_controller.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/models/app_model.dart';
import 'package:flutter_folio/views/app_title_bar/app_title_bar.dart';
import 'package:flutter_folio/commands/commands.dart' as Commands;
import 'package:statsfl/statsfl.dart';

/// Wraps the entire app, providing it with various helper classes and wrapper widgets.
class MainAppScaffold extends StatefulWidget {
  const MainAppScaffold({Key key, @required this.child, @required this.showAppBar}) : super(key: key);
  final Widget child;
  final bool showAppBar;

  @override
  _MainAppScaffoldState createState() => _MainAppScaffoldState();
}

class _MainAppScaffoldState extends State<MainAppScaffold> {
  @override
  Widget build(BuildContext context) {
    TextDirection textDirection = context.select((AppModel app) => app.textDirection);
    // Provide the appTheme directly to the tree, so views don't need to look it up on the model (less boilerplate for views)
    AppTheme appTheme = context.select((AppModel app) => app.theme);
    return Provider.value(
      value: appTheme,
      child: StatsFl(
        isEnabled: false && (kProfileMode || kDebugMode),
        align: Alignment.bottomCenter,
        child: Directionality(
          textDirection: textDirection,
          // Right-click support
          child: ContextMenuOverlay(
            child: Navigator(
              onPopPage: (Route route, result) {
                if (route.didPop(result)) return true;
                return false;
              },
              pages: [
                MaterialPage(
                    // Pop-over (tooltip) support
                    child: Builder(
                  builder: (BuildContext builderContext) {
                    /// User a builder to provide a context to the Command layer that can safely use Navigator, Overlay etc
                    Commands.setContext(builderContext);
                    return PopOverController(
                      // Draw a border around the entire window, because we're classy :)
                      child: _WindowBorder(
                        color: appTheme.greyStrong,
                        // Supply a top-level scaffold and SafeArea for all views
                        child: Scaffold(
                          backgroundColor: appTheme.bg1,
                          body: SafeArea(
                            // AppBar + Content
                            // This column has a reversed vertical direction, because we want the TitleBar to cast a shadow on the content below it.
                            child: Column(
                              verticalDirection: VerticalDirection.up,
                              children: [
                                // Bottom content area
                                Expanded(
                                  child: widget.child,
                                ),
                                // Top-aligned TitleBar
                                if (widget.showAppBar) AppTitleBar(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WindowBorder extends StatelessWidget {
  const _WindowBorder({Key key, this.child, this.color}) : super(key: key);
  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      child,
      IgnorePointer(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white.withOpacity(.1), width: 1),
          ),
        ),
      ),
    ]);
  }
}

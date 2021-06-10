import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_folio/_utils/string_utils.dart';
import 'package:flutter_folio/_widgets/context_menu_overlay.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:super_editor/super_editor.dart';

class ColorAttribution extends Attribution {
  @override
  String get id => 'color ${background ? "bg" : "fg"}';

  Color color;
  bool background;

  ColorAttribution({this.color = Colors.black, this.background = false});

  @override
  bool canMergeWith(Attribution other) {
    if (other.id == id && (other as ColorAttribution).color == color && other.background == background) {
      return true;
    }
    return false;
  }
}

class SuperTextEditor extends StatefulWidget {
  const SuperTextEditor(this.text,
      {Key? key,
      required this.document,
      required this.maxWidth,
      this.maxLines = 1,
      this.onChanged,
      this.promptText,
      this.onFocusIn,
      this.onFocusOut,
      this.styleNotifier,
      this.enableContextMenu = true,
      this.autoFocus = false})
      : super(key: key);
  final double maxWidth;
  final String text;
  final int maxLines;
  final bool autoFocus;
  final void Function(String value)? onChanged;
  final String? promptText;
  final void Function()? onFocusIn;
  final void Function(String value)? onFocusOut;
  final bool enableContextMenu;
  final MutableDocument document;
  final ValueNotifier<TextStyle>? styleNotifier;

  @override
  _SuperTextEditorState createState() => _SuperTextEditorState();
}

class _SuperTextEditorState extends State<SuperTextEditor> {
  bool _isEditing = false;
  late DocumentEditor _editor;
  late DocumentComposer _composer;
  late FocusNode _textFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    _editor = DocumentEditor(document: widget.document);
    _composer = DocumentComposer();
    _textFocus = FocusNode();

    // Listen for focus out, so we can disable editing when user clicks somewhere else
    _textFocus.addListener(_handleFocusChanged);
    if (widget.autoFocus) {
      _isEditing = true;
      _textFocus.requestFocus();
    }

    widget.styleNotifier?.addListener(_handleStyleChanged);
  }

  @override
  void dispose() {
    widget.styleNotifier?.removeListener(_handleStyleChanged);

    _textFocus.dispose();
    _composer.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppTheme theme = context.watch();

    return Container(
      color: theme.accent1.withOpacity(.1),
      child: SuperEditor.custom(
        editor: _editor,
        composer: _composer,
        focusNode: _textFocus,
        maxWidth: widget.maxWidth,
        textStyleBuilder: _styleBuilder,
      ),
    );
  }

  void _handleCopy() => Clipboard.setData(ClipboardData(text: _getDocumentText()));

  // Ends editing mode when the user focuses out of the text box
  void _handleFocusChanged() {
    if (_textFocus.hasFocus == false) {
      setState(() => _isEditing = false);
      widget.onFocusOut?.call(_getDocumentText());
    } else {
      setState(() => _isEditing = true);
      widget.onFocusIn?.call();
    }
    InlineTextEditorFocusNotification(_textFocus.hasFocus).dispatch(context);
  }

  String _getDocumentText() {
    ParagraphNode? node = widget.document.getNodeAt(0) as ParagraphNode?;
    if (node == null) return "";
    return node.text.text;
  }

  void _toggleStyleForSelection(TextStyle style) {
    final selection = _composer.selection;
    if (selection == null) return;

    final Set<Attribution> attributeToggles = {};

    // Find all of the attributes that exist on nodes that we want to remove and add them to the toggle set
    final nodes = widget.document.getNodesInside(selection.base, selection.extent);
    for (final node in nodes) {
      final ParagraphNode? paragraphNode = node as ParagraphNode?;
      if (paragraphNode == null) continue;

      int startOffset = (selection.base.nodePosition as TextPosition).offset;
      int endOffset = (selection.extent.nodePosition as TextPosition).offset;

      if (endOffset < startOffset) {
        int tmp = startOffset;
        startOffset = endOffset;
        endOffset = tmp;
      }

      print('selection ${startOffset} - ${endOffset}');

      for (int i = startOffset; i != endOffset; ++i) {
        final Set<Attribution> attributes = paragraphNode.text.getAllAttributionsAt(i);
        for (final attribute in attributes) {
          if (attribute is! ColorAttribution) continue;

          attributeToggles.add(attribute);
        }
      }
    }

    // Add style attributes to the toggle set
    if (style.fontStyle == FontStyle.italic) attributeToggles.add(NamedAttribution('italics'));
    if (style.fontWeight == FontWeight.bold) attributeToggles.add(NamedAttribution('bold'));

    final bgColor = style.backgroundColor;
    final fgColor = style.color;

    if (bgColor != null) attributeToggles.add(ColorAttribution(color: bgColor, background: true));

    if (fgColor != null) attributeToggles.add(ColorAttribution(color: fgColor));

    _editor.executeCommand(ToggleTextAttributionsCommand(
      documentSelection: selection,
      attributions: attributeToggles,
    ));

    print(attributeToggles);
  }

  void _handleStyleChanged() {
    final style = widget.styleNotifier!.value;
    _toggleStyleForSelection(style);
  }

  TextStyle _styleBuilder(Set<Attribution> attributes) {
    TextStyle newStyle = TextStyle(
      color: Colors.black,
      fontSize: 13,
      height: 1.4,
    );

    for (final attribute in attributes) {

      if (attribute is ColorAttribution && attribute.background)
        newStyle = newStyle.copyWith(backgroundColor: attribute.color);

      if (attribute is ColorAttribution && !attribute.background)
        newStyle = newStyle.copyWith(color: attribute.color);

      if (attribute is NamedAttribution) {
        switch (attribute.name) {
          case 'bold':
            newStyle = newStyle.copyWith(
              fontWeight: FontWeight.bold,
            );
            break;
          case 'italics':
            newStyle = newStyle.copyWith(
              fontStyle: FontStyle.italic,
            );
            break;
          case 'strikethrough':
            newStyle = newStyle.copyWith(
              decoration: TextDecoration.lineThrough,
            );
            break;
        }
      }
    }
    return newStyle;
  }
}

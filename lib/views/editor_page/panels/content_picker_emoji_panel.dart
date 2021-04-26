import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_folio/_utils/notifications/close_notification.dart';
import 'package:flutter_folio/_utils/string_utils.dart';
import 'package:flutter_folio/commands/books/create_placed_scraps_command.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:flutter_folio/data/book_data.dart';
import 'package:flutter_folio/styled_widgets/emoji.dart';

class ContentPickerEmojiPanel extends StatefulWidget {
  const ContentPickerEmojiPanel({Key? key, required this.isVisible, required this.bookId, required this.pageId})
      : super(key: key);
  final bool isVisible;
  final String? pageId;
  final String bookId;

  @override
  _ContentPickerEmojiPanelState createState() => _ContentPickerEmojiPanelState();
}

class _ContentPickerEmojiPanelState extends State<ContentPickerEmojiPanel> {
  static const List<Emojis> emojis = [
    Emojis.beers,
    Emojis.checkmark,
    Emojis.confetti,
    Emojis.cool,
    Emojis.crying_face,
    Emojis.dizzy_face,
    Emojis.exclamation_question,
    Emojis.fire,
    Emojis.folded_hands,
    Emojis.heart_eyes,
    Emojis.hundred_points,
    Emojis.kissing_face,
    Emojis.location_pin,
    Emojis.musical_notes,
    Emojis.palms_up,
    Emojis.pile_of_poo,
    Emojis.red_heart,
    Emojis.shooting_star,
    Emojis.smiling_eyes,
    Emojis.sparkles,
    Emojis.squinting_face,
    Emojis.sunglasses_face,
    Emojis.tears_of_joy_face,
    Emojis.warning_sign,
  ];

  @override
  Widget build(BuildContext context) {
    bool isPageSelected = StringUtils.isNotEmpty(widget.pageId);
    return Visibility(
      maintainState: true,
      visible: widget.isVisible,
      child: GlassCard(
        child: Container(
          width: 300,
          height: 440,
          padding: EdgeInsets.all(Insets.lg),
          alignment: Alignment.center,
          child: GridView.builder(
            itemCount: emojis.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: Insets.xs,
              mainAxisSpacing: Insets.xs,
              childAspectRatio: 1,
            ),
            itemBuilder: (_, index) {
              Emojis e = emojis.elementAt(index);
              return SimpleBtn(
                  onPressed: isPageSelected ? () => _handleAddPressed(e) : null,
                  child: Container(padding: EdgeInsets.all(Insets.sm), alignment: Alignment.center, child: Emoji(e)));
            },

            //child: Text(emojis, style: TextStyle(fontSize: 32))
          ),
        ),
      ),
    );
  }

  void _handleAddPressed(Emojis emoji) {
    if (widget.pageId != null) {
      CreatePlacedScrapCommand().run(pageId: widget.pageId!, scraps: [
        ScrapItem(
          bookId: widget.bookId,
          aspect: 1,
          contentType: ContentType.Emoji,
          data: EnumToString.convertToString(emoji),
        )
      ]);
    }
    CloseNotification().dispatch(context);
  }
}

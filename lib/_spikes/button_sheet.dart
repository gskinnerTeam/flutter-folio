import 'package:flutter/material.dart';
import 'package:flutter_folio/_utils/input_utils.dart';
import 'package:flutter_folio/_widgets/decorated_container.dart';
import 'package:flutter_folio/styled_widgets/buttons/styled_buttons.dart';
import 'package:flutter_folio/styled_widgets/styled_spacers.dart';

class ButtonSheet extends StatelessWidget {
  const ButtonSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const underline = BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey)));
    Widget _center(Widget w) => Container(child: w, height: 100, decoration: underline, alignment: Alignment.center);
    return GestureDetector(
      onTap: InputUtils.unFocus,
      child: Center(
        child: DecoratedContainer(
          borderColor: Colors.grey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _center(Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            PrimaryBtn(onPressed: () {}, label: "Primary"),
                            HSpace.med,
                            PrimaryBtn(onPressed: () {}, isCompact: true, label: "Primary-Compact"),
                          ],
                        )),
                        _center(Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            PrimaryBtn(onPressed: () {}, isCompact: true, icon: Icons.padding),
                            HSpace.med,
                            PrimaryBtn(onPressed: () {}, isCompact: false, icon: Icons.padding, label: "Icon & Label"),
                          ],
                        )),
                        _center(Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            PrimaryBtn(onPressed: () {}, isCompact: true, label: "Text w/ Icon", icon: Icons.padding),
                            HSpace.med,
                            PrimaryBtn(
                                onPressed: () {},
                                isCompact: false,
                                icon: Icons.padding,
                                leadingIcon: true,
                                label: "leading"),
                          ],
                        )),
                        _center(PrimaryBtn(onPressed: () {})),
                      ],
                    ),
                  ),
                  Container(width: 1, color: Colors.grey),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _center(Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SecondaryBtn(onPressed: () {}, label: "Primary"),
                            HSpace.med,
                            SecondaryBtn(onPressed: () {}, isCompact: true, label: "Primary-Compact"),
                          ],
                        )),
                        _center(Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SecondaryBtn(onPressed: () {}, isCompact: true, icon: Icons.padding),
                            HSpace.med,
                            SecondaryBtn(
                                onPressed: () {}, isCompact: false, icon: Icons.padding, label: "Icon & Label"),
                          ],
                        )),
                        _center(Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SecondaryBtn(onPressed: () {}, isCompact: true, label: "Text w/ Icon", icon: Icons.padding),
                            HSpace.med,
                            SecondaryBtn(
                                onPressed: () {},
                                isCompact: false,
                                icon: Icons.padding,
                                leadingIcon: true,
                                label: "leading"),
                          ],
                        )),
                        _center(SecondaryBtn(onPressed: () {})),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextBtn("Update Photo", onPressed: () {}),
                    HSpace.med,
                    IconBtn(Icons.translate, onPressed: () {}),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

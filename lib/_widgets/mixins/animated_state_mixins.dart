import 'package:flutter/material.dart';

// Some mixins to save boilerplate and prevent bugs around setup/teardown of AnimationControllers
//mixin TickerProviderStateMixin<T extends StatefulWidget> on State<T> implements TickerProvider {
mixin AnimationMixin1<T extends StatefulWidget> on State<T> implements TickerProviderStateMixin<T> {
  late AnimationController anim1;

  @override
  void initState() {
    var defaultDuration = const Duration(milliseconds: 350);
    anim1 = AnimationController(vsync: this, duration: defaultDuration);
    initAnimations();
    super.initState();
  }

  void initAnimations() {}

  @override
  void dispose() {
    anim1.dispose();
    super.dispose();
  }

  void resetAnims() => anim1.reset();
}

mixin AnimationMixin2<T extends StatefulWidget> on State<T>, TickerProviderStateMixin<T> {
  late AnimationController anim1;
  late AnimationController anim2;

  @override
  void initState() {
    var defaultDuration = const Duration(milliseconds: 350);
    anim1 = AnimationController(vsync: this, duration: defaultDuration);
    anim2 = AnimationController(vsync: this, duration: defaultDuration);
    initAnimations();
    super.initState();
  }

  void initAnimations() {}

  @override
  void dispose() {
    anim1.dispose();
    anim2.dispose();
    super.dispose();
  }

  void resetAnims() {
    anim1.reset();
    anim2.reset();
  }
}

mixin AnimationMixin3<T extends StatefulWidget> on State<T>, TickerProviderStateMixin<T> {
  late AnimationController anim1;
  late AnimationController anim2;
  late AnimationController anim3;

  @override
  void initState() {
    var defaultDuration = const Duration(milliseconds: 350);
    anim1 = AnimationController(vsync: this, duration: defaultDuration);
    anim2 = AnimationController(vsync: this, duration: defaultDuration);
    anim3 = AnimationController(vsync: this, duration: defaultDuration);
    initAnimations();
    super.initState();
  }

  void initAnimations() {}

  void resetAnims() {
    anim1.reset();
    anim2.reset();
    anim3.reset();
  }

  @override
  void dispose() {
    anim1.dispose();
    anim2.dispose();
    anim3.dispose();
    super.dispose();
  }
}

mixin AnimationMixin4<T extends StatefulWidget> on State<T>, TickerProviderStateMixin<T> {
  late AnimationController anim1;
  late AnimationController anim2;
  late AnimationController anim3;
  late AnimationController anim4;

  @override
  void initState() {
    var defaultDuration = const Duration(milliseconds: 350);
    anim1 = AnimationController(vsync: this, duration: defaultDuration);
    anim2 = AnimationController(vsync: this, duration: defaultDuration);
    anim3 = AnimationController(vsync: this, duration: defaultDuration);
    anim4 = AnimationController(vsync: this, duration: defaultDuration);
    initAnimations();
    super.initState();
  }

  void initAnimations() {}

  @override
  void dispose() {
    anim1.dispose();
    anim2.dispose();
    anim3.dispose();
    anim4.dispose();
    super.dispose();
  }

  void resetAnims() {
    anim1.reset();
    anim2.reset();
    anim3.reset();
    anim4.reset();
  }
}

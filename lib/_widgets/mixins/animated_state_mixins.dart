import 'package:flutter/material.dart';

// Some mixins to save boilerplate and prevent bugs around setup/teardown of AnimationControllers
mixin AnimationMixin1<T extends StatefulWidget> on State<T>, TickerProviderStateMixin<T> {
  AnimationController anim1;

  @override
  void initState() {
    var defaultDuration = Duration(milliseconds: 350);
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
  AnimationController anim1;
  AnimationController anim2;

  @override
  void initState() {
    var defaultDuration = Duration(milliseconds: 350);
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
  AnimationController anim1;
  AnimationController anim2;
  AnimationController anim3;

  @override
  void initState() {
    var defaultDuration = Duration(milliseconds: 350);
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
  AnimationController anim1;
  AnimationController anim2;
  AnimationController anim3;
  AnimationController anim4;

  @override
  void initState() {
    var defaultDuration = Duration(milliseconds: 350);
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

import 'package:flame/components/component.dart';
import 'package:ordered_set/comparing.dart';
import 'package:ordered_set/ordered_set.dart';
import 'package:flutter/painting.dart';
import 'package:flame/components/resizable.dart';

mixin ComposedComponent on Component {
  OrderedSet<Component> components =
      new OrderedSet(Comparing.on((c) => c.priority()));

  @override
  render(Canvas canvas) {
    canvas.save();
    components.forEach((comp) => _renderComponent(canvas, comp));
    canvas.restore();
  }

  void _renderComponent(Canvas canvas, Component c) {
    c.render(canvas);
    canvas.restore();
    canvas.save();
  }

  @override
  void update(double t) {
    components.forEach((c) => c.update(t));
    components.removeWhere((c) => c.destroy());
  }

  void add(Component c) {
    this.components.add(c);

    if (this is Resizable) {
      // first time resize
      Resizable thisResizable = this as Resizable;
      if (thisResizable.size != null) {
        c.resize(thisResizable.size);
      }
    }
  }

  void updateComponents(Function itractionCB) {
    components.forEach(itractionCB);
  }

  List<Resizable> children() =>
      this.components.where((r) => r is Resizable).cast<Resizable>().toList();
}

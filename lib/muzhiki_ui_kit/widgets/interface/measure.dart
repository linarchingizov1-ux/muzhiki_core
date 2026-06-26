import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


class MeasureSize extends SingleChildRenderObjectWidget {
  final ValueChanged<Size> onChange;

  const MeasureSize({required this.onChange, required Widget child, super.key})
    : super(child: child);

  @override
  RenderObject createRenderObject(BuildContext context) =>
      RenderMeasureSize(onChange);

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderMeasureSize renderObject,
  ) {
    renderObject.onChange = onChange;
  }
}

class RenderMeasureSize extends RenderProxyBox {
  RenderMeasureSize(this.onChange);
  ValueChanged<Size> onChange;
  Size? _oldSize;

  @override
  void performLayout() {
    super.performLayout();
    final newSize = child?.size;
    if (newSize == null) return;

    if (_oldSize == newSize) {
      return;
    }
    _oldSize = newSize;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      onChange(newSize);
    });
  }
}

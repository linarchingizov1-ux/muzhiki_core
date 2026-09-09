import 'package:flutter/material.dart';

class StoryGeometry {
  final double screenHeight;

  final double appBarHeight;

  final double cornerRadius;

  final double cornerStraightenDistance;

  StoryGeometry({
    required this.screenHeight,
    required this.appBarHeight,
    required this.cornerRadius,
    required this.cornerStraightenDistance,
  });

  static const double defaultMidSize = 0.4;

  late final List<double> snapSizes = [defaultMidSize];

  double get maxSize => 1 - appBarHeight / screenHeight;
 
  // Сила размытия под шапкой
  double appBarBlurAt(double size) =>
      const Cubic(0.5, 0, 0.5, 1).transform(expandProgressAt(size));

  // Прогресс первой фазы, от него едут заголовок, полосы прогресса,
  // кнопки и проявление текста
  static double openProgressAt(double size) =>
      (size / defaultMidSize).clamp(0.0, 1.0);

  // Прогресс второй фазы, от него едет размытие под шапкой
  double expandProgressAt(double size) =>
      ((size - defaultMidSize) / (maxSize - defaultMidSize)).clamp(0.0, 1.0);

  // Фото занимает весь экран над листом
  double photoHeightAt(double size) => screenHeight * (1 - size);

  // Скругление гаснет у обеих границ, на полном экране и на высоте шапки углы
  // должны быть прямыми
  double cornerRadiusAt(double size) {
    final photoHeight = photoHeightAt(size);
    return cornerRadius *
        ((screenHeight - photoHeight) / cornerStraightenDistance).clamp(
          0.0,
          1.0,
        ) *
        ((photoHeight - appBarHeight) / cornerStraightenDistance).clamp(
          0.0,
          1.0,
        );
  }
}


// Обрезает фото по нижней кромке и скругляет ему низ
// Клиппер, а не анимированный ClipRRect сверху, потому что пересчитывается
// только форма обрезки, дерево виджетов при этом не трогается
class StoryPhotoClipper extends CustomClipper<RRect> {
  final double size;
  final StoryGeometry geometry;

  const StoryPhotoClipper({required this.size, required this.geometry});

  @override
  RRect getClip(Size layoutSize) {
    final corner = Radius.circular(geometry.cornerRadiusAt(size));
    return RRect.fromRectAndCorners(
      Rect.fromLTWH(0, 0, layoutSize.width, geometry.photoHeightAt(size)),
      bottomLeft: corner,
      bottomRight: corner,
    );
  }

  @override
  bool shouldReclip(StoryPhotoClipper oldClipper) =>
      oldClipper.size != size || oldClipper.geometry != geometry;
}

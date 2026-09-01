import 'package:muzhiki_ui/buttons/muzhiki_buttons.dart';
import 'package:muzhiki_ui/dialog/muzhiki_dialog.dart';
import 'package:muzhiki_ui/effect/muzhiki_effect.dart';
import 'package:muzhiki_ui/other/other.dart';
import 'package:muzhiki_ui/scaffold/scaffold.dart';

export 'buttons/muzhiki_buttons.dart';
export 'buttons/buttons.dart';
export 'dialog/dialog.dart';
export 'effect/effect.dart';
export 'scaffold/scaffold.dart';
export 'media/media_viewer.dart';
export 'theme/muzhiki_colors.dart';
export 'theme/muzhiki_fonts.dart';
export 'other/notification.dart';
export 'other/skelet.dart';
export 'buttons/widgets/animated_button.dart';
export 'buttons/widgets/choi_widgets.dart';
export 'buttons/widgets/small_button.dart';

abstract final class MuzhikiUi {
  static const buttons = MuzhikiButtons();
  static const dialog = MuzhikiDialog();
  static const other = MuzhikiOther();
  static const effect = MuzhikiEffect();
  static const scaffold = MuzhikiScaffold();
}

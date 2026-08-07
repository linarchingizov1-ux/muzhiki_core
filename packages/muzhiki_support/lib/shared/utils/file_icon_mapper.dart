import 'package:muzhiki_support/config/support_assets.dart';

abstract final class FileIconMapper {
  static String forExtension(String? extension) {
    final ext = extension?.toLowerCase().replaceFirst('.', '') ?? '';

    return switch (ext) {
      'pdf' => SupportAssets.I.png.pdf,
      'doc' || 'docx' => SupportAssets.I.png.doc,
      'xls' || 'xlsx' => SupportAssets.I.png.xls,
      'ppt' || 'pptx' => SupportAssets.I.png.ppt,
      'zip' || 'rar' || '7z' => SupportAssets.I.png.zip,
      'txt' => SupportAssets.I.png.txt,
      _ => SupportAssets.I.png.file,
    };
  }

  static String forFileName(String? fileName) {
    final extension = fileName?.split('.').last;
    return forExtension(extension);
  }
}

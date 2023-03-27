part of 'helpers.dart';

class SplitHelper {
  static String getFileName({required String path}) {
    final splitArray = path.split('/');
    return splitArray.last;
  }

  static String getFileExtension({required String fileName}) =>
      fileName.split('.').last;

  /// format duration to hh:mm:ss
  static String formatDuration(Duration d) =>
      d.toString().split('.').first.substring(2);

  /// Return last word of the name
  static String formatName({required String name}) {
    //Trường Sinh Nguyễn
    final arrayName = name.split(" "); // Trường || Sinh || Nguyễn
    if (arrayName.length > 1) {
      // true
      // "Sinh Nguyễn"
      return "${arrayName[0]} ${arrayName[1]}";
    }
    return arrayName[0];
  }
}

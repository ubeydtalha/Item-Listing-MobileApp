import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:uuid/uuid.dart';

class ImageHandler {
  static Future<XFile?> saveImage(XFile img, String type) async {
    final String path = (await getApplicationDocumentsDirectory()).path;

    // Klasör yolunu belirle
    final String directoryPath = '$path/$type';

    // Eğer klasör yoksa, oluştur
    final Directory directory = Directory(directoryPath);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }

    File convertedImg = File(img.path);
    String fileName = const Uuid().v4().toString();

    final File localImage_ =
        await convertedImg.copy('$directoryPath/$fileName.jpg');

    try{
    // Resmi sıkıştır
    var compressedImage = await FlutterImageCompress.compressWithList(
      localImage_.readAsBytesSync(),
      quality: 50,
    );

    await localImage_.delete();

    // Sıkıştırılmış resmi belirlenen klasörde yeni bir dosyaya yaz
    File('$directoryPath/$fileName.jpg').writeAsBytesSync(compressedImage);

    var compressedImage_ = File('$directoryPath/$fileName.jpg');

    print(compressedImage_.exists());
      
    } 
    catch(e){
      print(e);
    }

    return XFile('$directoryPath/$fileName.jpg');
  }

  /// EXTENDED
  static Future<XFile> loadImage(String fileName) async {
    final String path = (await getApplicationDocumentsDirectory()).path;

    if (File('$path/$fileName.jpg').existsSync()) {
      print("Image exists. Loading it...");

      return XFile('$path/$fileName.jpg');
    }
    print("Image does not exist. Loading default image...");
    return XFile('');
  }
}

import 'dart:io';
import 'package:connect_z/constants/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  static Future<String> uploadProfilePicture(File fileImage, String id) async {
    String? uniquePhotoId = const Uuid().v4();

    File image = await compressImage(uniquePhotoId, fileImage);

    UploadTask uploadTask =
        storageRef.child('images/users/$id/profile_photo.jpg').putFile(image);

    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  static Future<String> uploadCoverPhoto(File fileImage, String id) async {
    String? uniquePhotoId = const Uuid().v4();

    File image = await compressImage(uniquePhotoId, fileImage);

    UploadTask uploadTask =
        storageRef.child('images/users/$id/cover_photo.jpg').putFile(image);

    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  static Future<String> uploadPostImage(File fileImage, String id) async {
    String? uniquePhotoId = const Uuid().v4();

    File image = await compressImage(uniquePhotoId, fileImage);

    UploadTask uploadTask = storageRef
        .child('images/users/$id/posts/Post_$uniquePhotoId.jpg')
        .putFile(image);

    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  static Future<File> compressImage(String photoId, File imageObj) async {
    final tempDirection = await getTemporaryDirectory();

    final path = tempDirection.path;

    var cmpImage = await FlutterImageCompress.compressAndGetFile(
        imageObj.absolute.path, '$path/img_$photoId.jpg',
        quality: 70, format: CompressFormat.jpeg);

    File compressedImage = File(cmpImage!.path);

    return compressedImage;
  }
}

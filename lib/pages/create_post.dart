import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_z/common/custom_button.dart';
import 'package:connect_z/constants/constants.dart';
import 'package:connect_z/models/tweet_model.dart';
import 'package:connect_z/services/db_service.dart';
import 'package:connect_z/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateTweet extends StatefulWidget {
  final String currentUserId;
  const CreateTweet({super.key, required this.currentUserId});

  @override
  State<CreateTweet> createState() => _CreateTweetState();
}

class _CreateTweetState extends State<CreateTweet> {
  String? _tweetText;
  String icontext = "Upload An Image";
  File? _pickedImage;
  bool? _loading;

  handleImageFromGallery() async {
    try {
      var imageFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (imageFile != null) {
        setState(() {
          _pickedImage = File(imageFile.path);
        });
      }

      icontext = "Change Uploaded Image";
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          systemOverlayStyle: appDefaultSystemOverlayStyle,
          backgroundColor: appDefaultColor,
          centerTitle: true,
          leading: const BackButton(
            color: Colors.white,
          ),
          title: const Text(
            'Create Post',
            style: TextStyle(color: Colors.white, fontSize: 20),
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              _loading == true
                  ? Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: const CircularProgressIndicator())
                  : const SizedBox.shrink(),
              const SizedBox(
                height: 20,
              ),
              TextField(
                maxLength: 280,
                maxLines: 7,
                decoration: const InputDecoration(
                  hintText: 'Write something here...',
                ),
                onChanged: (value) {
                  _tweetText = value;
                },
              ),
              GestureDetector(
                onTap: handleImageFromGallery,
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        border: Border.all(
                          color: tcolor,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 20,
                        color: appDefaultColor,
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      icontext,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: appDefaultColor),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              _pickedImage == null
                  ? const SizedBox.shrink()
                  : Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 25),
                          height: 200,
                          decoration: BoxDecoration(
                              color: tcolor,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(_pickedImage!, scale: 1.0))),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _pickedImage = null;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.all(10),
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.red,
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.delete,
                                  size: 15,
                                  color: Colors.red,
                                ),
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              const Text(
                                'Remove Photo',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
              const SizedBox(
                height: 5,
              ),
              StdButton(
                btnText: 'Create Post',
                onBtnPressed: () async {
                  setState(() {
                    _loading = true;
                  });
                  if (_tweetText != null && _tweetText!.isNotEmpty) {
                    String image;
                    if (_pickedImage == null) {
                      image = '';
                    } else {
                      image = await StorageService.uploadPostImage(
                          File(_pickedImage!.path), widget.currentUserId);
                    }
                    TweetModel tweetModel = TweetModel(
                        text: _tweetText,
                        image: image,
                        authorID: widget.currentUserId,
                        likes: 0,
                        retweets: 0,
                        timestamp: Timestamp.fromDate(
                          DateTime.now(),
                        ));
                    DBService.createPost(tweetModel);
                    Navigator.pop(context);
                    setState(() {
                      _loading = false;
                    });
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              _loading == false
                  ? const CircularProgressIndicator()
                  : const SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }
}

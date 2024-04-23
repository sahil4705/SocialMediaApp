// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, unrelated_type_equality_checks

import 'dart:io';
import 'package:connect_z/common/progress_circle.dart';
import 'package:connect_z/constants/constants.dart';
import 'package:connect_z/models/user_model.dart';
import 'package:connect_z/services/db_service.dart';
import 'package:connect_z/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel user;
  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String? _name, _bio;

  File? _profileImage, _coverImage;

  String? _imagePickedType;

  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    _name = widget.user.name;
    _bio = widget.user.bio;
  }

  handleImageFromGallery() async {
    final imagePicker = ImagePicker();

    try {
      var imageFile = await imagePicker.pickImage(source: ImageSource.gallery);

      if (imageFile != null) {
        if (_imagePickedType == "profile") {
          if (mounted) {
            setState(() {
              _profileImage = File(imageFile.path);
            });
          }
        } else if (_imagePickedType == "cover") {
          if (mounted) {
            setState(() {
              _coverImage = File(imageFile.path);
            });
          }
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  displayCoverImage() {
    if (_coverImage == null) {
      return NetworkImage(widget.user.coverImage!);
    } else {
      return FileImage(_coverImage!);
    }
  }

  displayProfileImage() {
    if (_profileImage == null) {
      return NetworkImage(widget.user.profilePicture!);
    } else {
      return FileImage(_profileImage!);
    }
  }

  saveProfile() async {
    _formKey.currentState!.save();

    if (_formKey.currentState!.validate() && !isLoading) {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }

      String ProfilePictureUrl = "";

      String CoverPhotoUrl = "";

      if (_profileImage == null || _profileImage == "") {
        ProfilePictureUrl = widget.user.profilePicture!;
      } else {
        ProfilePictureUrl = await StorageService.uploadProfilePicture(
            _profileImage!, widget.user.id!);
      }

      if (_coverImage == null) {
        CoverPhotoUrl = widget.user.coverImage!;
      } else {
        CoverPhotoUrl = await StorageService.uploadCoverPhoto(
            _coverImage!, widget.user.id!);
      }

      UserModel user = UserModel(
          id: widget.user.id,
          name: _name,
          profilePicture: ProfilePictureUrl,
          bio: _bio,
          coverImage: CoverPhotoUrl);

      DBService.updateUserData(user);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        children: [
          GestureDetector(
            onTap: () {
              _imagePickedType = "cover";
              handleImageFromGallery();
            },
            child: Stack(
              children: [
                Container(
                    height: 150,
                    decoration: BoxDecoration(
                        color: tcolor,
                        image: DecorationImage(
                            fit: BoxFit.cover, image: displayCoverImage()))),
                Container(
                  height: 150,
                  color: Colors.black54,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt,
                        size: 70,
                        color: Colors.white,
                      ),
                      Text(
                        'Change Cover Photo',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            transform: Matrix4.translationValues(0, -40, 0),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _imagePickedType = "profile";
                        handleImageFromGallery();
                      },
                      child: Stack(children: [
                        CircleAvatar(
                            radius: 45, backgroundImage: displayProfileImage()),
                        const CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.black54,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Icon(
                                Icons.camera_alt,
                                size: 25,
                                color: Colors.white,
                              ),
                              Text(
                                'Change Profile Picture',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        )
                      ]),
                    ),
                    GestureDetector(
                      onTap: saveProfile,
                      child: Container(
                        width: 100,
                        height: 35,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.black,
                          border: Border.all(color: Colors.black),
                        ),
                        child: const Center(
                            child: Text(
                          'Save',
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                  ],
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        TextFormField(
                            initialValue: _name,
                            decoration: const InputDecoration(
                              labelText: 'Name',
                              labelStyle: TextStyle(color: tcolor),
                            ),
                            validator: (input) => input!.trim().length < 2
                                ? 'please enter valid name'
                                : null,
                            onSaved: (value) {
                              _name = value;
                            }),
                        TextFormField(
                            initialValue: _bio,
                            decoration: const InputDecoration(
                              labelText: 'Bio',
                              labelStyle: TextStyle(color: tcolor),
                            ),
                            validator: (input) => input!.trim().length < 2
                                ? 'please enter valid bio'
                                : null,
                            onSaved: (value) {
                              _bio = value;
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.cancel),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Discard Changes',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ))
                      ],
                    ))
              ],
            ),
          ),
          isProcessing ? const ProgressCircle() : const SizedBox.shrink(),
        ],
      ),
    );
  }
}

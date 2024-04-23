import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Assets {
  static const String _svgsPath = 'assets/svgs';
  static const String twitterLogo = '$_svgsPath/twitter_logo.svg';
  static const String connectLogo = '$_svgsPath/appicon.svg';
}

const Color tcolor = Color(0xff00acee);

const ImageProvider bgimg = NetworkImage(
    'https://firebasestorage.googleapis.com/v0/b/myfirebase-db-75c27.appspot.com/o/default_photos%2Fcover_photo.jpg?alt=media&token=e8474eb7-052b-4f3e-8f25-569b05e35133&_gl=1*swtpk1*_ga*MTk3Mzk1MjgyLjE2OTY5NDgwMTQ.*_ga_CW55HF8NVT*MTY5NzI1MzU3MC4zLjEuMTY5NzI1NjI2OC42MC4wLjA');

const appDefaultSystemOverlayStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.blue, statusBarIconBrightness: Brightness.dark);

const appDefaultProfilePicture = NetworkImage(
    "https://firebasestorage.googleapis.com/v0/b/myfirebase-db-75c27.appspot.com/o/default_photos%2Fprofile_photo.png?alt=media&token=386e8f3a-b5c4-4f82-80b7-6eb04cdd42be&_gl=1*rvl4l7*_ga*MTk3Mzk1MjgyLjE2OTY5NDgwMTQ.*_ga_CW55HF8NVT*MTY5NzI3MDQwMi41LjEuMTY5NzI3MTA0MC4zMC4wLjA");

const appDefaultColor = Colors.blue;

const appcolor = Colors.blue;

const appinverse = Colors.white;

const textboxborder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 1.5),
    borderRadius: BorderRadius.all(Radius.circular(7)));

final firestore = FirebaseFirestore.instance;

final usersRef = firestore.collection('users');

final followersRef = firestore.collection('followers');

final followingRef = firestore.collection('following');

final tweetsRef = firestore.collection('tweet');

final storageRef = FirebaseStorage.instance.ref();

final likesRefs = firestore.collection('likes');

final notificationsRef = firestore.collection('notifications');

final commentsRef = firestore.collection('comments');

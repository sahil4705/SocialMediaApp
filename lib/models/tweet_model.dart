import 'package:cloud_firestore/cloud_firestore.dart';

class TweetModel {
  String? id;
  String? authorID;
  String? text;
  String? image;
  Timestamp? timestamp;
  int? likes;
  int? retweets;

  TweetModel(
      {this.id,
      this.authorID,
      this.text,
      this.image,
      this.timestamp,
      this.likes,
      this.retweets});

  factory TweetModel.fromDoc(DocumentSnapshot doc) {
    return TweetModel(
        id: doc.id,
        authorID: doc['authorid'],
        text: doc['text'],
        image: doc['image'],
        timestamp: doc['timestamp'],
        likes: doc['likes'],
        retweets: doc['retweets']);
  }
}

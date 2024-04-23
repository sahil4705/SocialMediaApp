import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_z/constants/constants.dart';
import 'package:connect_z/models/notification_model.dart';
import 'package:connect_z/models/tweet_model.dart';
import 'package:connect_z/models/user_model.dart';

class DBService {
  static Future<int> getFollowersCount(String? userID) async {
    QuerySnapshot followersSnapshot =
        await followersRef.doc(userID).collection('followers').get();
    return followersSnapshot.docs.length;
  }

  static Future<int> getFollowingCount(String? userID) async {
    QuerySnapshot followingSnapshot = await firestore
        .collection('following')
        .doc(userID)
        .collection('following')
        .get();
    return followingSnapshot.docs.length - 1;
  }

  static void updateUserData(UserModel user) {
    usersRef.doc(user.id).update({
      'name': user.name,
      'bio': user.bio,
      'profilepicture': user.profilePicture,
      'coverimage': user.coverImage
    });
  }

  static Future<QuerySnapshot> searchUser(String name) async {
    Future<QuerySnapshot> users = usersRef
        .where('name', isGreaterThanOrEqualTo: name)
        .where('name', isLessThan: '${name}z')
        .get();
    return users;
  }

  static void followUser(String currentUserId, String visitedUserId) async {
    followingRef
        .doc(currentUserId)
        .collection('following')
        .doc(visitedUserId)
        .set({});

    followersRef
        .doc(visitedUserId)
        .collection('followers')
        .doc(currentUserId)
        .set({});

    createNotification(currentUserId, null, true, visitedUserId);
  }

  static void unfollowUser(String currentUserId, String visitedUserId) async {
    followingRef
        .doc(currentUserId)
        .collection('following')
        .doc(visitedUserId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    followersRef
        .doc(visitedUserId)
        .collection('followers')
        .doc(currentUserId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  static Future<bool> isFollowingUser(
      String currentUserId, String visitedUserId) async {
    DocumentSnapshot followingdoc = await followersRef
        .doc(visitedUserId)
        .collection('followers')
        .doc(currentUserId)
        .get();
    return followingdoc.exists;
  }

  static void createPost(TweetModel tweetModel) {
    tweetsRef.doc(tweetModel.authorID).set({'tweetTime': tweetModel.timestamp});
    tweetsRef.doc(tweetModel.authorID).collection('userTweets').add({
      'text': tweetModel.text,
      'image': tweetModel.image,
      'authorid': tweetModel.authorID,
      'timestamp': tweetModel.timestamp,
      'likes': tweetModel.likes,
      'retweets': tweetModel.retweets
    });
  }

  static void updatePost(TweetModel tweetModel) {
    tweetsRef.doc(tweetModel.authorID).set({'tweetTime': tweetModel.timestamp});
    tweetsRef
        .doc(tweetModel.authorID)
        .collection('userTweets')
        .doc(tweetModel.id)
        .update({
      'text': tweetModel.text,
      'image': tweetModel.image,
      'authorid': tweetModel.authorID,
      'timestamp': tweetModel.timestamp,
      'likes': tweetModel.likes,
      'retweets': tweetModel.retweets
    });
  }

  static Future<List<TweetModel>> getUserTweets(String userid) async {
    QuerySnapshot userTweetsSnap = await tweetsRef
        .doc(userid)
        .collection('userTweets')
        .orderBy('timestamp', descending: true)
        .get();

    List<TweetModel> userTweets =
        userTweetsSnap.docs.map((doc) => TweetModel.fromDoc(doc)).toList();

    return userTweets;
  }

  static Future<List> getHomeTweets(String currentUserId) async {
    List<String> uids = [];

    QuerySnapshot querySnapshot =
        await followingRef.doc(currentUserId).collection('following').get();

    for (var element in querySnapshot.docs) {
      uids.add(element.id.toString());
    }

    List<TweetModel> posts = [];

    for (int i = 0; i < uids.length; i++) {
      QuerySnapshot postSnap =
          await tweetsRef.doc(uids[i]).collection('userTweets').get();
      for (var element in postSnap.docs) {
        posts.add(TweetModel.fromDoc(element));
      }
    }

    posts.sort((a, b) => b.timestamp!.compareTo(a.timestamp!));

    return posts;
  }

  static Future<void> likeTweet(String currentUserId, TweetModel tweet) async {
    DocumentReference reference =
        tweetsRef.doc(tweet.authorID).collection('userTweets').doc(tweet.id);
    reference.get().then((doc) {
      if (doc.exists) {
        int likes = doc.get('likes');
        reference.update({'likes': likes + 1});
      }
    });

    likesRefs.doc(tweet.id).collection('tweetLikes').doc(currentUserId).set({});

    createNotification(currentUserId, tweet, false, null);
  }

  static void unlikeTweet(String currentUserId, TweetModel tweet) {
    DocumentReference reference =
        tweetsRef.doc(tweet.authorID).collection('userTweets').doc(tweet.id);
    reference.get().then((doc) {
      if (doc.exists) {
        int likes = doc.get('likes');
        reference.update({'likes': likes - 1});
      }
    });

    likesRefs
        .doc(tweet.id)
        .collection('tweetLikes')
        .doc(currentUserId)
        .get()
        .then((doc) => doc.reference.delete());
  }

  static Future<bool> likeStatus(String currentUserId, TweetModel tweet) async {
    DocumentSnapshot snapshot = await likesRefs
        .doc(tweet.id)
        .collection('tweetLikes')
        .doc(currentUserId)
        .get();

    return snapshot.exists;
  }

  // ignore: non_constant_identifier_names
  static Future<List<NotificationModel>> getNotification(String UserID) async {
    QuerySnapshot notificationSnapshot = await notificationsRef
        .doc(UserID)
        .collection('user_notifications')
        .orderBy('timestamp', descending: true)
        .get();

    List<NotificationModel> notifications = notificationSnapshot.docs
        .map((e) => NotificationModel.fromDoc(e))
        .toList();

    return notifications;
  }

  static void createNotification(String currentUserId, TweetModel? tweet,
      bool follow, String? followedUserID) {
    if (follow) {
      notificationsRef
          .doc(followedUserID)
          .collection('user_notifications')
          .add({
        'fromUserID': currentUserId,
        'timestamp': Timestamp.fromDate(DateTime.now()),
        'follow': true,
      });
    } else {
      notificationsRef
          .doc(tweet!.authorID)
          .collection('user_notifications')
          .add({
        'fromUserID': currentUserId,
        'timestamp': Timestamp.fromDate(DateTime.now()),
        'follow': false,
      });
    }
  }

  static Future<List<UserModel>> getConnection(String id, String page) async {
    QuerySnapshot connections =
        await followersRef.doc(id).collection('followers').get();

    if (page == "Following") {
      connections = await followingRef.doc(id).collection('following').get();
    }

    List<UserModel> connectionsList = [];

    for (var doc in connections.docs) {
      DocumentSnapshot snapshot = await usersRef.doc(doc.id).get();
      if (doc.id != id) {
        connectionsList.add(UserModel.fromDoc(snapshot));
      }
    }

    return connectionsList;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String id;
  final String name;
  final String imageUrl;
  final String recentSender;
  final String recentMessage;
  final Timestamp recentTimestamp;
  final List<dynamic> memberIds;
  final dynamic memberInfo;
  final dynamic readStatus;

  Chat(
      {this.id,
      this.name,
      this.imageUrl,
      this.recentMessage,
      this.recentTimestamp,
      this.memberIds,
      this.memberInfo,
      this.readStatus,
      this.recentSender});

  factory Chat.fromDoc(DocumentSnapshot doc) {
    return Chat(
        id: doc.documentID,
        name: doc['name'],
        imageUrl: doc['imageUrl'],
        recentMessage: doc['recentMessage'],
        recentSender: doc['recentSender'],
        recentTimestamp: doc['recentTimestamp'],
        memberIds: doc['memberIds'],
        memberInfo: doc['memberInfo'],
        readStatus: doc['readStatus']);
  }
}
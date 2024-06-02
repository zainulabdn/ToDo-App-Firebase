import 'package:cloud_firestore/cloud_firestore.dart';

class Quote {
  final String category;
  final String text;

  Quote({required this.category, required this.text});

  Quote.fromSnapshot(DocumentSnapshot snapshot)
      : category = snapshot['category'],
        text = snapshot['text'];
}

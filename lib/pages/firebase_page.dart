import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/utils/stream_subscriber_mixin.dart';
import 'package:flutter/material.dart';

class FirebaseApp extends StatefulWidget {
  const FirebaseApp({super.key});

  @override
  State<FirebaseApp> createState() => _FirebaseAppState();
}

class _FirebaseAppState extends State<FirebaseApp> {
  int _likes = 0;
  late final DatabaseReference _likesRef;
  late StreamSubscription<DatabaseEvent> _likeSubscription;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    _likesRef = FirebaseDatabase.instance.ref('likes');

    try {
      final likeSnapshot = await _likesRef.get();
      _likes = likeSnapshot.value as int;
    } catch (err) {
      debugPrint(err.toString());
    }

    _likeSubscription = _likesRef.onValue.listen((DatabaseEvent event) {
      setState(() {
        _likes = (event.snapshot.value ?? 0) as int;
      });
    });
  }

  like() async {
    await _likesRef.set(ServerValue.increment(1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          IconButton(onPressed: like, icon: const Icon(Icons.thumb_up)),
          Text(_likes.toString())
        ]),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_rights/screens/add_post_screen.dart';
import 'package:chat_rights/screens/feed_screen.dart';
import 'package:chat_rights/screens/profile_screen.dart';
import 'package:chat_rights/screens/search_screen.dart';
import 'package:chat_rights/screens/ai_chat_screen.dart';
import 'package:chat_rights/screens/rights_lists_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const RightsListsScreen(),
  const AddPostScreen(),
  const AiChatScreen(),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];

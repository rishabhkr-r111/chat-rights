import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:chat_rights/utils/colors.dart';
import 'package:chat_rights/utils/global_variable.dart';
import 'package:chat_rights/screens/rights_lists_screen.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({Key? key}) : super(key: key);

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor:
            width > webScreenSize ? webBackgroundColor : mobileBackgroundColor,
        appBar: width > webScreenSize
            ? null
            : AppBar(
                backgroundColor: mobileBackgroundColor,
                centerTitle: false,
                title: SvgPicture.asset(
                  'assets/chatrights.svg',
                  color: primaryColor,
                  height: 32,
                ),
                actions: [
                  IconButton(
                    icon: const Icon(
                      Icons.policy,
                      color: primaryColor,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RightsListsScreen()),
                      );
                    },
                  ),
                ],
              ),
        body: Container(
          child: Text('AI-Chat-Screen'),
        ));
  }
}

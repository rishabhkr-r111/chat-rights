import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:chat_rights/utils/colors.dart';
import 'package:chat_rights/utils/global_variable.dart';

class RightsListsScreen extends StatefulWidget {
  const RightsListsScreen({Key? key}) : super(key: key);

  @override
  State<RightsListsScreen> createState() => _RightsListsScreen();
}

class _RightsListsScreen extends State<RightsListsScreen> {
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
              ),
        body: Container(
          child: Text('rights list'),
        ));
  }
}

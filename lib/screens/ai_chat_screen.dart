import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:chat_rights/utils/colors.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:chat_rights/utils/global_variable.dart';
import 'package:chat_rights/utils/chat_mannager.dart';
import 'package:chat_rights/screens/rights_lists_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({Key? key}) : super(key: key);

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final ChatManager chatManager = ChatManager();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    void handleSendPressed(types.PartialText message) {
      if (!chatManager.isLoading) {
        final textMessage = types.TextMessage(
          author: chatManager.user,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: const Uuid().v4(),
          text: message.text,
        );
        chatManager.addMessage(textMessage);
        setState(() {});
      }
    }

    void handleImageSelection() async {
      final result = await ImagePicker().pickImage(
        imageQuality: 70,
        maxWidth: 1440,
        source: ImageSource.gallery,
      );

      if (result != null) {
        final bytes = await result.readAsBytes();
        final image = await decodeImageFromList(bytes);

        final message = types.ImageMessage(
          author: chatManager.user,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          height: image.height.toDouble(),
          id: const Uuid().v4(),
          name: result.name,
          size: bytes.length,
          uri: result.path,
          width: image.width.toDouble(),
        );

        chatManager.addMessage(message);
      }
    }

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
      body: Chat(
        messages: chatManager.messages,
        onAttachmentPressed: handleImageSelection,
        onSendPressed: handleSendPressed,
        showUserAvatars: false,
        showUserNames: true,
        user: chatManager.user,
        theme: const DefaultChatTheme(
          backgroundColor: Colors.black,
          inputBorderRadius: BorderRadius.zero,
          receivedMessageBodyTextStyle: TextStyle(color: Colors.white),
          secondaryColor: Color(0xFF1c1c1c),
          attachmentButtonIcon: Icon(
            Icons.camera_alt_outlined,
            color: Colors.white,
          ),
          inputBackgroundColor: Color(0xFF1c1c1c),
          seenIcon: Text(
            'read',
            style: TextStyle(
              fontSize: 10.0,
            ),
          ),
        ),
      ),
    );
  }
}

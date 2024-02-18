import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:chat_rights/utils/colors.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:chat_rights/utils/global_variable.dart';
import 'package:chat_rights/utils/chat_mannager.dart';
import 'package:chat_rights/screens/rights_lists_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
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
  void initState() {
    chatManager.initializeWebsocket();
    chatManager.channel.stream.listen((event) {
      chatManager.onMessageReceived(event);
      setState(() {});
    });
    super.initState();
  }

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

    void handlePdfSelection() async {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );

      if (result != null) {
        PlatformFile file = result.files.first;

        final PdfDocument pdf = PdfDocument(inputBytes: file.bytes);
        String message = PdfTextExtractor(pdf).extractText();
        pdf.dispose();

        final textMessage = types.FileMessage(
          author: chatManager.user,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: const Uuid().v4(),
          name: file.name,
          size: file.size,
          uri: file.path ?? '',
        );

        chatManager.addMessage(textMessage, filedata: message);
        setState(() {});
      } else {
        // todo -> handel canceled
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
        onAttachmentPressed: handlePdfSelection,
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
            Icons.document_scanner,
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

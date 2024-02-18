import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone_flutter/providers/user_provider.dart';
import 'package:instagram_clone_flutter/resources/firestore_methods.dart';
import 'package:instagram_clone_flutter/utils/colors.dart';
import 'package:instagram_clone_flutter/utils/utils.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  bool isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> _selectImage(ImageSource source) async {
    Uint8List file = await pickImage(source);
    setState(() {
      _file = file;
    });
  }

  void postImage(String uid, String username, String profImage) async {
    setState(() {
      isLoading = true;
    });

    try {
      String res = await FireStoreMethods().uploadPost(
        _descriptionController.text,
        _file!,
        uid,
        username,
        profImage,
      );
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        if (context.mounted) {
          showSnackBar(
            context,
            'Posted!',
          );
        }
        clearImage();
      } else {
        if (context.mounted) {
          showSnackBar(context, res);
        }
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
    Navigator.pop(context); // Close the screen after posting
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: clearImage,
        ),
        title: const Text('New Post'),
        centerTitle: true,
        actions: <Widget>[
          TextButton(
            onPressed: () => postImage(
              userProvider.getUser.uid,
              userProvider.getUser.username,
              userProvider.getUser.photoUrl,
            ),
            child: const Text(
              "Post",
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: _file == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.add_a_photo,
                                  size: 40.0,
                                ),
                                onPressed: () =>
                                    _selectImage(ImageSource.camera),
                              ),
                              const SizedBox(height: 10),
                              Text('Take a Photo', style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.image,
                                  size: 40.0,
                                ),
                                onPressed: () =>
                                    _selectImage(ImageSource.gallery),
                              ),
                              const SizedBox(height: 10),
                              Text('Choose from Gallery', style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(
                          height: 300.0,
                          child: Image.memory(
                            _file!,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextField(
                            controller: _descriptionController,
                            decoration: const InputDecoration(
                              hintText: "Write a caption...",
                              border: InputBorder.none,
                            ),
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          isLoading ? const LinearProgressIndicator() : Container(),
        ],
      ),
    );
  }
}

import 'package:bwai_akure/views/apikeys/api_keys.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late GenerativeModel _model;
  late ChatSession _chat;
  final TextEditingController _chatController = TextEditingController();
  final List<Map<String, dynamic>> _chatHistory = [];

  void getResponse(String text) async {
    final content = [Content.text(text)];
    var response = await _chat.sendMessage(content);
    _chatHistory.add({
      "time": DateTime.now(),
      "message": _chatController.text.trim(),
      "isUser": true,
      "isImage": false,
    });
  }

  @override
  void initState() {
    _model = GenerativeModel(model: 'gemini-pro', apiKey: ApiKey().apiKey);
    _chat = _model.startChat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat Screen"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                  itemCount: _chatHistory.length,
                  itemBuilder: (context, index) {
                    final message = _chatHistory.elementAt(index);
                    return ListTile(
                      tileColor: message["isUser"] ? Colors.green : Colors.red,
                      title: Text(message["message"]),
                    );
                  }),
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.upload_file)),
                const SizedBox(
                  width: 4,
                ),
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(hintText: "Type your message"),
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                IconButton(
                    onPressed: () {
                      if (_chatController.text.trim().isEmpty) {
                        return;
                      }

                      _chatHistory.add({
                        "time": DateTime.now(),
                        "message": _chatController.text.trim(),
                        "isUser": true,
                        "isImage": false,
                      });

                      getResponse(_chatController.text.trim());
                      _chatController.clear;
                      setState(() {});
                    },
                    icon: const Icon(Icons.send)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

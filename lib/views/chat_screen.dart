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
    try {
      final content = Content.text(text);
      var response = await _chat.sendMessage(content);
      setState(() {
        _chatHistory.add({
          "time": DateTime.now(),
          "message": response.text,
          "isUser": false,
          "isImage": false,
        });
      });
    } catch (e) {
      print('Error sending message: $e');
    }
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
        centerTitle: true,
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
                      tileColor: message["isUser"] ? Colors.pink : Colors.white,
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
                Expanded(
                  child: TextField(
                    controller: _chatController,
                    decoration: InputDecoration(hintText: "Type your message"),
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        if (_chatController.text.trim().isEmpty) {
                          return;
                        }
                        final userInput = _chatController.text.trim();
                        _chatHistory.add({
                          "time": DateTime.now(),
                          "message": _chatController.text,
                          "isUser": true,
                          "isImage": false,
                        });
                        getResponse(userInput);
                        _chatController.clear();
                      });
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

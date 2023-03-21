// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:mychattutorial/constants/const_key.dart';

// import 'package:mychattutorial/constants/constants.dart';
// import 'package:http/http.dart' as http;
// import 'package:mychattutorial/models/model.dart';

// class ChatScreen extends StatefulWidget {
//   const ChatScreen({super.key});

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   late bool isLoading;
//   final TextEditingController _textController = TextEditingController();

//   final List<ChatMessage> _messages = [];

//   @override
//   void initState() {
//     super.initState();
//     isLoading = false;
//   }

//   //response function
//   Future<String> genereteResponse(String prompt) async {
//     const apiKey = apiSecretKey;
//     var url = Uri.http("api.openai.com", "v1/completions");
//     final response = await http.post(url,
//         headers: {
//           "Content-type": "application/json",
//           "Authorization": "Bearer $apiKey",
//         },
//         body: jsonEncode({
//           "model": "text-davinchi-003",
//           "prompt": prompt,
//           "temperature": 0,
//           "max_tokens": 200,
//           "top_p": 1,
//           "frequency_penalty": 0.0,
//           "presency_penalty": 0.0
//         }));
//     //decode response
//     Map<String, dynamic> newresponse = jsonDecode(response.body);
//     return newresponse['choices'][0]['text'];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: scaffoldBackgoundColor,
//       appBar: AppBar(
//         elevation: 3,
//         backgroundColor: scaffoldBackgoundColor,
//         title: const Text('ChatGPT'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SafeArea(
//           child: Column(
//             children: [
//               //chatbody
//               Expanded(
//                 child: _buildList(),
//               ),
//               //indicator loading
//               Visibility(
//                 visible: isLoading,
//                 child: const CircularProgressIndicator(
//                   color: Colors.white,
//                 ),
//               ),
//               //textfield + sendbutton
//               Row(
//                 children: [
//                   //input field
//                   _buildInput(),
//                   //submit button

//                   _buildSubmit(),
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Expanded _buildInput() {
//     return Expanded(
//       child: TextField(
//         controller: _textController,
//         style: const TextStyle(color: Colors.white),
//         decoration: const InputDecoration(
//           hintText: 'Введите запрос',
//           hintStyle: TextStyle(color: Colors.white),
//           fillColor: Colors.white,
//         ),
//       ),
//     );
//   }

//   Widget _buildSubmit() {
//     return Visibility(
//       visible: !isLoading,
//       child: IconButton(
//         onPressed: () {
//           //display user input
//           setState(() {
//             _messages.add(
//               ChatMessage(
//                 text: _textController.text,
//                 chatMessageType: ChatMessageType.user,
//               ),
//             );
//             isLoading = true;
//           });
//           var input = _textController.text;
//           _textController.clear();

//           //call chat bot api
//           genereteResponse(input).then((value) {
//             setState(() {
//               isLoading = false;
//               //displat chat bot response
//               _messages.add(
//                 ChatMessage(
//                   text: value,
//                   chatMessageType: ChatMessageType.bot,
//                 ),
//               );
//             });
//           });
//           _textController.clear();
//         },
//         icon: const Icon(
//           Icons.send,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }

//   ListView _buildList() {
//     return ListView.builder(
//       itemCount: _messages.length,
//       itemBuilder: (context, index) {
//         var message = _messages[index];
//         return ChatMessageWidget(
//           text: message.text,
//           chatMessageType: message.chatMessageType,
//         );
//       },
//     );
//   }
// }

// class ChatMessageWidget extends StatelessWidget {
//   final String text;
//   final ChatMessageType chatMessageType;
//   const ChatMessageWidget(
//       {super.key, required this.text, required this.chatMessageType});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       color: chatMessageType == ChatMessageType.bot
//           ? cardColor
//           : scaffoldBackgoundColor,
//       child: Row(
//         children: [
//           chatMessageType == ChatMessageType.bot
//               ? SizedBox(
//                   height: 20,
//                   width: 20,
//                   child: Image.asset('assets/images/logo-gpt.png'),
//                 )
//               : SizedBox(
//                   height: 20,
//                   width: 20,
//                   child: Image.asset('assets/images/person.png'),
//                 ),
//           Expanded(
//               child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Text(
//                   text,
//                   style: const TextStyle(color: Colors.white),
//                 ),
//               ),
//             ],
//           ))
//         ],
//       ),
//     );
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mychattutorial/constants/const_key.dart';
import 'package:mychattutorial/models/model.dart';

const backgroundColor = Color(0xff343541);
const botBackgroundColor = Color(0xff444654);

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

Future<String> generateResponse(String prompt) async {
  const apiKey = apiSecretKey;

  var url = Uri.https("api.openai.com", "/v1/completions");

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $apiKey"
    },
    body: json.encode({
      "model": "text-davinci-003",
      "prompt": prompt,
      'temperature': 0,
      'max_tokens': 1000,
      'top_p': 1,
      'frequency_penalty': 0.0,
      'presence_penalty': 0.0,
    }),
  );

  // Do something with the response
  Map<String, dynamic> newresponse =
      jsonDecode(utf8.decode(response.bodyBytes));

  return newresponse['choices'][0]['text'];
}

class _ChatPageState extends State<ChatPage> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  late bool isLoading;

  @override
  void initState() {
    super.initState();
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //toolbarHeight: 100,
        title: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "chat GPT",
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ),
        backgroundColor: botBackgroundColor,
      ),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _buildList(),
            ),
            Visibility(
              visible: isLoading,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  _buildInput(),
                  _buildSubmit(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmit() {
    return Visibility(
      visible: !isLoading,
      child: Container(
        color: botBackgroundColor,
        child: IconButton(
          icon: const Icon(
            Icons.send_rounded,
            color: Color.fromRGBO(142, 142, 160, 1),
          ),
          onPressed: () async {
            setState(
              () {
                _messages.add(
                  ChatMessage(
                    text: _textController.text,
                    chatMessageType: ChatMessageType.user,
                  ),
                );
                isLoading = true;
              },
            );
            var input = _textController.text;
            _textController.clear();
            Future.delayed(const Duration(milliseconds: 50))
                .then((_) => _scrollDown());
            generateResponse(input).then((value) {
              setState(() {
                isLoading = false;
                _messages.add(
                  ChatMessage(
                    text: value,
                    chatMessageType: ChatMessageType.bot,
                  ),
                );
              });
            });
            _textController.clear();
            Future.delayed(const Duration(milliseconds: 50))
                .then((_) => _scrollDown());
          },
        ),
      ),
    );
  }

  Expanded _buildInput() {
    return Expanded(
      child: TextField(
        textCapitalization: TextCapitalization.sentences,
        style: const TextStyle(color: Colors.white),
        controller: _textController,
        decoration: const InputDecoration(
          fillColor: botBackgroundColor,
          filled: true,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
      ),
    );
  }

  ListView _buildList() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        var message = _messages[index];
        return ChatMessageWidget(
          text: message.text,
          chatMessageType: message.chatMessageType,
        );
      },
    );
  }

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}

class ChatMessageWidget extends StatelessWidget {
  const ChatMessageWidget(
      {super.key, required this.text, required this.chatMessageType});

  final String text;
  final ChatMessageType chatMessageType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Container(
        decoration: BoxDecoration(
          color: chatMessageType == ChatMessageType.bot
              ? botBackgroundColor
              : backgroundColor,
          borderRadius: BorderRadius.circular(5),
        ),
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            chatMessageType == ChatMessageType.bot
                ? Container(
                    margin: const EdgeInsets.only(right: 16.0),
                    child: CircleAvatar(
                      backgroundColor: const Color.fromRGBO(16, 163, 127, 1),
                      child: Image.asset(
                        'assets/images/logo-gpt.png',
                        //color: Colors.white,
                        scale: 1.5,
                      ),
                    ),
                  )
                : Container(
                    height: 35,
                    width: 35,
                    margin: const EdgeInsets.only(right: 16.0),
                    child: Image.asset(
                      'assets/images/person.png',
                    ),
                  ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    child: Text(
                      text,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

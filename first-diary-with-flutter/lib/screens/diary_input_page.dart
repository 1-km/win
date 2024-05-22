import 'package:flutter/material.dart';

class DiaryInputPage extends StatefulWidget {
  final String? initContent;
  const DiaryInputPage({super.key, this.initContent});

  @override
  State<DiaryInputPage> createState() => _DiaryInputPageState();
}

class _DiaryInputPageState extends State<DiaryInputPage> {
  late TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("일기를 쓰자"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: textEditingController,
                decoration: const InputDecoration(hintText: "일기를 써보는 게 어떨까?"),
                maxLines: 25,
              ),
              const SizedBox(height: 20,),
              ElevatedButton(onPressed: (){
                Navigator.pop(context, textEditingController.text);
              }, child: const Text("일기 저장")),
            ],
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController(text: widget.initContent);
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
  }
}

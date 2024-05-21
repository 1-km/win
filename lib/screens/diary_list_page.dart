import 'package:diary/models/diary.dart';
import 'package:diary/screens/diary_input_page.dart';
import 'package:flutter/material.dart';

class DiaryListPage extends StatefulWidget {
  const DiaryListPage({super.key});

  @override
  State<DiaryListPage> createState() => _DiaryListPageState();
}

class _DiaryListPageState extends State<DiaryListPage> {

  List<Diary> items = [
    Diary(content: "diary-1", createdAt: DateTime(2021, 05, 19)),
    Diary(content: "diary-2", createdAt: DateTime(2022, 05, 19)),
    Diary(content: "diary-3", createdAt: DateTime(2022, 05, 19)),
    Diary(content: "diary-4", createdAt: DateTime(2022, 05, 19)),
    Diary(content: "diary-5", createdAt: DateTime(2023, 01, 19)),
  ];


  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("일기"),
        actions: [
          IconButton(onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const DiaryInputPage())).then((
                value) {
              setState(() {
                items.add(Diary(content: value, createdAt: DateTime.now()));
              });
            });
          }, icon: const Icon(Icons.create))
        ],
      ),
      body: ListView(
        children: groupDiaryByYear(items).entries.map((entry) {
          return Column(
            children: [
              Padding(padding: const EdgeInsets.all(10),
                child: Text('${entry.key}', style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),),),
              CustomListView(items: entry.value, onDelete: (Diary) {
                setState(() {
                  items.remove(Diary);
                });
              })
            ],
          );
        }).toList(),
      ),
    );
  }
}

class CustomListView extends StatelessWidget {
  final List<Diary> items;
  final Function(Diary) onDelete;

  const CustomListView(
      {super.key, required this.items, required this.onDelete});

  // todo 역순 정렬
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (context, index) {
          var customIem = items[index];
          return ListTile(
            title: Text(items[index].content),
            subtitle: Text(items[index].createdAt.toString()),
            tileColor: Colors.greenAccent[100],
            trailing: IconButton(
              onPressed: () {
                onDelete(customIem);
              },
              icon: const Icon(Icons.delete),
            ),
          );
        });
  }
}


Map<int, List<Diary>> groupDiaryByYear(List<Diary> items) {
  Map<int, List<Diary>> diaryByYear = {};

  for (var item in items) {
    int year = item.createdAt.year;
    if (!diaryByYear.containsKey(year)) {
      diaryByYear[year] = [];
    };
    diaryByYear[year]?.add(item);
  }
  return diaryByYear;
}
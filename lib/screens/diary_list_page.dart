import 'package:diary/database/database_helper.dart';
import 'package:diary/models/diary.dart';
import 'package:diary/screens/diary_input_page.dart';
import 'package:flutter/material.dart';

class DiaryListPage extends StatefulWidget {
  const DiaryListPage({super.key});

  @override
  State<DiaryListPage> createState() => _DiaryListPageState();
}

class _DiaryListPageState extends State<DiaryListPage> {
  DatabaseHelper dbHelper = DatabaseHelper();
  late Future<List<Diary>> diaries;

  @override
  void initState() {
    super.initState();
    dbHelper.insertDiary(Diary(content: "diary-1", createdAt: DateTime(2012, 5, 13)));
    dbHelper.insertDiary(Diary(content: "diary-2", createdAt: DateTime(2013, 5, 13)));
    dbHelper.insertDiary(Diary(content: "diary-3", createdAt: DateTime(2014, 5, 13)));
    dbHelper.insertDiary(Diary(content: "diary-4", createdAt: DateTime(2020, 5, 13)));
    diaries = dbHelper.getDiaries();
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
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (_) => const DiaryInputPage()))
                    .then((value) {
                  if (!value.isEmpty) {
                    setState(() {
                      dbHelper.insertDiary(
                          Diary(content: value, createdAt: DateTime.now()));
                      diaries = dbHelper.getDiaries();
                    });
                  }
                });
              },
              icon: const Icon(Icons.create))
        ],
      ),
      body: FutureBuilder<List<Diary>>(
        future: diaries,
        builder: (context, snapshot) {
          var items = snapshot.data?.reversed.toList() ?? [];
          return ListView(
            children: groupDiaryByYear(items).entries.map((entry) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      '${entry.key}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  CustomListView(
                    items: entry.value,
                    onDelete: (customId) {
                      setState(() {
                        dbHelper.deleteDiary(customId);
                        diaries = dbHelper.getDiaries();
                      });
                    },
                    onUpdate: (customDiary) {
                      setState(() {
                        dbHelper.updateDiary(customDiary);
                        diaries = dbHelper.getDiaries();
                      });
                    },
                  )
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class CustomListView extends StatelessWidget {
  final List<Diary> items;
  final Function(int) onDelete;
  final Function(Diary) onUpdate;

  const CustomListView(
      {super.key,
      required this.items,
      required this.onDelete,
      required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items[index].content),
            subtitle: Text(items[index].createdAt.toString()),
            tileColor: Colors.greenAccent[100],
            trailing: IconButton(
              onPressed: () {
                onDelete(items[index].id!);
              },
              icon: const Icon(Icons.delete),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DiaryInputPage(
                          initContent: items[index].content))).then((value) {
                if (items[index].content != value) {
                  onUpdate(Diary(
                      id: items[index].id,
                      content: value,
                      createdAt: items[index].createdAt));
                }
              });
            },
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
    }
    ;
    diaryByYear[year]?.add(item);
  }
  return diaryByYear;
}

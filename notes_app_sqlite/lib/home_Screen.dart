import 'package:flutter/material.dart';
import 'package:notes_app_sqlite/data/local/db_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  DbHelper? dbref;
  List<Map<String, dynamic>> allNotes = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbref = DbHelper.getinstance;
    getNotes();
  }

  void getNotes() async {
    allNotes = await dbref!.getallNotes();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('home screen'),
      ),
      body: allNotes.isNotEmpty
          ? ListView.builder(
              itemCount: allNotes.length,
              itemBuilder: (_, index) {
                return ListTile(
                  leading:
                      //Text(allNotes[index][dbref!.COLUMN_NOTE_SNO].toString()),
                      Text('${index + 1}'),
                  title: Text(
                      allNotes[index][dbref!.COLUMN_NOTE_TITLE].toString()),
                  subtitle:
                      Text(allNotes[index][dbref!.COLUMN_NOTE_DESC].toString()),
                  trailing: SizedBox(
                    width: 50,
                    child: Row(
                      children: [
                        InkWell(
                            onTap: () {
                              titlecontroller.text =
                                  allNotes[index][dbref!.COLUMN_NOTE_TITLE];
                              descriptioncontroller.text =
                                  allNotes[index][dbref!.COLUMN_NOTE_DESC];
                              showbottomsheet(
                                  isupdate: true,
                                  sno: allNotes[index][dbref!.COLUMN_NOTE_SNO]);
                            },
                            child: Icon(Icons.edit)),
                        InkWell(
                          onTap: () async {
                            bool check = await dbref!.DeleteNote(
                                sno: allNotes[index][dbref!.COLUMN_NOTE_SNO]);
                            if (check) {
                              getNotes();
                            }
                          },
                          child: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              })
          : Center(
              child: Text('No notes yet'),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // bool check = await dbref!
          //     .addNote(mTitle: "profile", mdesc: "hello rao zeeshan here");
          // if (check) {
          //   getNotes();
          // }

          showbottomsheet();
          titlecontroller.clear();
          descriptioncontroller.clear();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void showbottomsheet({bool isupdate = false, int sno = 0}) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(11),
            width: double.infinity,
            child: Column(
              children: [
                Text(
                  isupdate ? 'Update Notes' : 'Add Notes',
                  style: TextStyle(fontSize: 30),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: titlecontroller,
                  decoration: InputDecoration(
                      hintText: 'Enter Title Here',
                      label: Text('Title'),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: descriptioncontroller,
                  maxLines: 4,
                  decoration: InputDecoration(
                      hintText: 'Enter Description Here',
                      label: Text('Desc'),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(11),
                                  side: BorderSide(width: 4))),
                          onPressed: () async {
                            var title = titlecontroller.text;
                            var desc = descriptioncontroller.text;
                            if (title.isNotEmpty && desc.isNotEmpty) {
                              bool check = isupdate
                                  ? await dbref!.UpdateNote(
                                      mtitle: title, mdesc: desc, sno: sno)
                                  : await dbref!
                                      .addNote(mTitle: title, mdesc: desc);
                              if (check) {
                                getNotes();
                                Navigator.pop(context);
                                titlecontroller.clear();
                                descriptioncontroller.clear();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Failed to add note. Please try again.'),
                                  ),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Title and Description cannot be empty!'),
                                ),
                              );
                            }
                          },
                          child: Text(isupdate ? 'Update Note' : 'Add Note')),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(11),
                                  side: BorderSide(width: 4))),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel')),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }
}

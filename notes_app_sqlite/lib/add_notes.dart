import 'package:flutter/material.dart';
import 'package:notes_app_sqlite/data/local/db_helper.dart';
import 'package:notes_app_sqlite/db_provider.dart';
import 'package:notes_app_sqlite/home_Screen.dart';
import 'package:notes_app_sqlite/main.dart';
import 'package:provider/provider.dart';

class AddNotes extends StatelessWidget {
  AddNotes(
      {super.key,
      this.isupdate = false,
      this.sno = 0,
      this.title = "",
      this.description = ""});

  bool isupdate;
  String title;
  String description;
  int sno;
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  // DbHelper? dbref = DbHelper.getinstance;
  List<Map<String, dynamic>> allNotes = [];

  @override
  Widget build(BuildContext context) {
    if (isupdate) {
      titlecontroller.text = title;
      descriptioncontroller.text = description;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes Screen'),
      ),
      body: Container(
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
                          if (isupdate) {
                            Provider.of<DbProvider>(context, listen: false)
                                .updatedata(title, desc, sno);
                          } else {
                            Provider.of<DbProvider>(context, listen: false)
                                .adddata(title, desc);
                          }
                          Navigator.pop(context);
                          // bool check = isupdate
                          //     ? await dbref!.UpdateNote(
                          //         mtitle: title, mdesc: desc, sno: sno)
                          //     : await dbref!
                          //         .addNote(mTitle: title, mdesc: desc);
                          // if (check) {
                          //   Navigator.pop(context);
                          //   titlecontroller.clear();
                          //   descriptioncontroller.clear();
                          // } else {
                          //   ScaffoldMessenger.of(context).showSnackBar(
                          //     SnackBar(
                          //       content: Text(
                          //           'Failed to add note. Please try again.'),
                          //     ),
                          //   );
                          // }
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
      ),
    );
  }
}

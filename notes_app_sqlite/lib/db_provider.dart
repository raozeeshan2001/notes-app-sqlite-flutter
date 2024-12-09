import 'package:flutter/foundation.dart';
import 'package:notes_app_sqlite/data/local/db_helper.dart';

class DbProvider extends ChangeNotifier {
  DbHelper dbHelper;
  DbProvider({required this.dbHelper});
  List<Map<String, dynamic>> _mdata = [];

  void adddata(String title, String desc) async {
    bool check = await dbHelper.addNote(mTitle: title, mdesc: desc);
    if (check) {
      _mdata = await dbHelper.getallNotes();
      notifyListeners();
    }
  }

  List<Map<String, dynamic>> getallnotes() => _mdata;

  void getinitialnotes() async {
    _mdata = await dbHelper.getallNotes();
    notifyListeners();
  }

  void updatedata(String title, String desc, int sno) async {
    //bool check = await dbHelper.addNote(mTitle: title, mdesc: desc);
    bool check =
        await dbHelper.UpdateNote(mtitle: title, mdesc: desc, sno: sno);
    if (check) {
      _mdata = await dbHelper.getallNotes();
      notifyListeners();
    }
  }

  void deletedata(int sno) async {
    //bool check = await dbHelper.addNote(mTitle: title, mdesc: desc);
    bool check = await dbHelper.DeleteNote(sno: sno);
    if (check) {
      _mdata = await dbHelper.getallNotes();
      notifyListeners();
    }
  }
}

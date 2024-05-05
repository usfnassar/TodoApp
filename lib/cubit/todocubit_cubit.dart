import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import '../pages/archive_tasks_page.dart';
import '../pages/done_tasks_page.dart';
import '../pages/new_tasks_page.dart';

part 'todocubit_state.dart';

class TodocubitCubit extends Cubit<TodocubitState> {
  TodocubitCubit() : super(TodocubitInitial());

  bool BottomShitIsShown = false;
  List<Map>? newTasks;
  List<Map>? doneTasks;
  List<Map>? archivedTasks ;

  int currentIndex = 0;
  Database? db;

  List<Widget> screens = [NewTasksPage(), DoneTasksPage(), ArchiveTasksPage(), NewTasksPage(), NewTasksPage()];
  void changeBottomSheetState({
    required bool isShow,
  }) {
    BottomShitIsShown = isShow;

    emit(AppChangeBottomSheetState());
  }


  void changeIndex(int index) {
    currentIndex = index;

    emit(AppChangeBottomNavBarState());
  }
  void changeIndexForMe(int index) {
    currentIndex = index;

    emit(SetSate());
  }
  void createDataBase() async {
    db = await openDatabase('TodoApp.db', version: 1,
        onCreate: (database, version) async {
          print("database Created!!!");
          try {
            await database.execute(
                "CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT,jop TEXT, date TEXT, time TEXT, status TEXT, msgId INTEGER)");
            print("Table Created");
          } catch (e) {
            print(e.toString());
          }
        },
        onOpen: (database) {
          getDataFromDB(database);
          print("database Opened");
        });
    emit(CreateDbState());

  }

  void InsertIntoDataBase({required title, required date, required time,required msgId,required jop}) {

      db!.transaction((txn) async {
         await txn.rawInsert(
            'INSERT INTO tasks(title, date, time, status,msgId,jop) VALUES("$title", "$date", "$time", "new","$msgId","$jop")');
        print('inserted Sucssfuly');
        emit(InsertIntoDbState());
        // getDataFromDB(db);
      });

  }

  void getDataFromDB(database) async {
     emit(LoadingGetDbState());


    newTasks=[] ;
    doneTasks = [];
    archivedTasks = [];
    database.rawQuery("SELECT * FROM tasks").then((value){
      value.forEach((e) {

        if (e["status"] == "new") {
          newTasks?.add(e);
          emit(MoveState());
        }
        else if (e["status"] == "done") {
          doneTasks?.add(e);
          emit(MoveState());

        }
        else {
          archivedTasks?.add(e);
          emit(MoveState());

        }

      }
      );
    });


    emit(GetDbState());
  }

  void updateData({
    required String status,
    required int id,
  }) async {
    db!.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      ['$status', id],
    ).then((value) {
      emit(UbdateDb());
      getDataFromDB(db);

      print(doneTasks);
    });
  }

  void deleteData({
    required int id,
  }) async {
    print("usf$db");
    db!.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDB(db);
      emit(DeleteFromDb());

    });

  }
  List<int> DeletedItems=[];
  void addElementToDelete(int id)

  {
    if (DeletedItems.contains(id)) {
      DeletedItems.remove(id);
    } else {
      DeletedItems.add(id);
    }
    emit(AddElementToDeleteState());
  }
  List<int> selectedIndices = [];

  void deleteSelectedData({
    required List<int> ids,
  }) async {
    String idString = ids.join(', ');
    db!.rawDelete('DELETE FROM tasks WHERE id IN ($idString)').then((value) {
      getDataFromDB(db);
      emit(DeleteFromDb());

    });
  }


  void updateDataInfo({
    required String title,
    required String jop,
    required String date,
    required String time,
    required int id,
  }) async {
    db!.rawUpdate(
      'UPDATE tasks SET title = ? , date = ?, time = ?, jop = ?  WHERE id = ?',
      ['$title','$date','$time', '$jop',id],
    ).then((value) {
      emit(UbdateDb());
      getDataFromDB(db);

      print(doneTasks);
    });
  }



  var FormKey = GlobalKey<FormState>();
  var ScaffoldKey = GlobalKey<ScaffoldState>();
  bool isUbdate=false;
  TextEditingController titleController=TextEditingController();
  TextEditingController timeController=TextEditingController();
  TextEditingController dateController=TextEditingController();
  TextEditingController jopController=TextEditingController();
  int id=0;
  var msgId;
   TimeOfDay? UpdateAlarmTime;
   DateTime? UpdateAlarmDate;




  void ChangeMode({required TextEditingController title,required TextEditingController time,required TextEditingController date,required idd,required TextEditingController jop,required msg})
  {
    isUbdate=true;
    id=idd;
    msgId=msg;
    titleController=title;
    timeController=time;
    dateController=date;
    jopController=jop;
    emit(ChangeModeState());
  }
  void BackMode()
  {
    isUbdate=false;
    emit(BackModeState());


  }
  String? jop;
void setState()
{
  emit(SetSate());
}
}

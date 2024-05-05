import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:todo/main.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../cubit/todocubit_cubit.dart';

class HomePage extends StatelessWidget {

  static String id = "HomePage";



  // var ScaffoldKey = GlobalKey<ScaffoldState>();
  // var FormKey = GlobalKey<FormState>();
  TextEditingController title = TextEditingController();
  TextEditingController jop = TextEditingController();
  TextEditingController time = TextEditingController();
  TextEditingController date = TextEditingController();
  late TimeOfDay alarmTime;
  late DateTime alarmDate;


  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.now();
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(dateTime.timeZoneName));
    return BlocProvider(
      create: (context) => TodocubitCubit()..createDataBase(),
      child: BlocConsumer<TodocubitCubit, TodocubitState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              actions: [
                context.read<TodocubitCubit>().DeletedItems.isEmpty? Container():IconButton(onPressed: (){
                  context.read<TodocubitCubit>().selectedIndices.clear();
                  context.read<TodocubitCubit>().deleteSelectedData(ids: context.read<TodocubitCubit>().DeletedItems);
                  context.read<TodocubitCubit>().DeletedItems.clear();

                }, icon:Icon(Icons.delete_outline,color: Colors.red,))
              ],
              backgroundColor:Color(0xff2c7da5) ,
              title:Text( "TodoApp",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
              centerTitle: true,
              automaticallyImplyLeading: false,

            ),
            key: context.read<TodocubitCubit>().ScaffoldKey,
            body:(state is! LoadingGetDbState)?Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: context.read<TodocubitCubit>().screens[context.read<TodocubitCubit>().currentIndex],
            ):Center(child: CircularProgressIndicator()),
            floatingActionButton: FloatingActionButton(
              onPressed: () {

                if (context.read<TodocubitCubit>().BottomShitIsShown) {
                  context.read<TodocubitCubit>().getDataFromDB( context.read<TodocubitCubit>().db);
                    Navigator.pop(context);

                  if (context.read<TodocubitCubit>().FormKey.currentState!.validate()) {
                    if(context.read<TodocubitCubit>().isUbdate) {
                        title=context.read<TodocubitCubit>().titleController;
                        time=context.read<TodocubitCubit>().timeController;
                        date=context.read<TodocubitCubit>().dateController;
                        jop= context.read<TodocubitCubit>().jopController;

                        context.read<TodocubitCubit>().updateDataInfo(jop: jop.text,title: title.text, date: date.text, time: time.text, id: context.read<TodocubitCubit>().id );
                        TimeOfDay? AlarmTime=  context.read<TodocubitCubit>().UpdateAlarmTime;
                        DateTime? AlarmDate=  context.read<TodocubitCubit>().UpdateAlarmDate;
                        DateTime oldDate=DateFormat("MMM d, yyyy").parse(date.text);
                        DateFormat inputFormat = DateFormat("h:mm a");
                        DateFormat outputFormat = DateFormat("HH:mm");
                        TimeOfDay oldTime = TimeOfDay.fromDateTime(outputFormat.parse(inputFormat.format(inputFormat.parse(time.text))));
                        scheduleAlarm(year: AlarmDate?.year??oldDate.year,month: AlarmDate?.month??oldDate.month,day: AlarmDate?.day??oldDate.day,hour: AlarmTime?.hour??oldTime.hour,minute: AlarmTime?.minute??oldTime.minute,id:   context.read<TodocubitCubit>().msgId,task: title.text);

                        title.clear();
                        time.clear();
                        date.clear();
                        jop.clear();
                      }

                    else{

                      List<Map> tasks=context.read<TodocubitCubit>().newTasks??[{"id":0}];
                      int msgId=tasks.length>0?tasks[tasks.length-1]['id']:0;
                      context.read<TodocubitCubit>().InsertIntoDataBase(
                          title: title.text, time: time.text, date: date.text,msgId: msgId,jop: jop.text);
                      scheduleAlarm(year: alarmDate.year,month: alarmDate.month,day: alarmDate.day,hour: alarmTime.hour,minute: alarmTime.minute,id: msgId,task: title.text);

                      title.clear();
                      time.clear();
                      date.clear();
                      jop.clear();

                    }


                    Navigator.pop(context);
                    context.read<TodocubitCubit>().changeBottomSheetState(isShow: false) ;
                  }
                }
                else {
                  context.read<TodocubitCubit>().BackMode();
                  context.read<TodocubitCubit>().ScaffoldKey.currentState
                      ?.showBottomSheet(

                        (context) =>
                        Container(
                          padding: EdgeInsets.all(40),
                          child: Form(
                            key: context.read<TodocubitCubit>().FormKey,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    controller: title,
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return "Title must not be empty";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15.0)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15.0)),
                                      ),
                                      label: Text("Title"),
                                      prefixIcon: Icon(Icons.title),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  TextFormField(
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return "Time must not be empty";
                                      }
                                      return null;
                                    },
                                    readOnly: true,
                                    controller: time,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15.0)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15.0)),
                                      ),
                                      label: Text("Time"),
                                      prefixIcon: Icon(
                                          Icons.watch_later_outlined),
                                    ),
                                    onTap: () async {
                                      TimeOfDay? pickedTime = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      );
                                      if (pickedTime != null) {
                                        time.text =
                                            pickedTime.format(context).toString();
                                        alarmTime=pickedTime;
                                      }
                                      else {
                                        print("enter empty time");
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  TextFormField(
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return "Date must not be empty";
                                      }
                                      return null;
                                    },
                                    readOnly: true,
                                    controller: date,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15.0)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15.0)),
                                      ),
                                      label: Text("Date"),
                                      prefixIcon: Icon(Icons.date_range),
                                    ),
                                    onTap: () async {
                                      DateTime?pickedDte = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse("2040-12-12"),
                                      );
                                      if (pickedDte != null) {
                                        alarmDate=pickedDte;
                                        date.text =
                                            DateFormat.yMMMd().format(pickedDte);

                                      }
                                      else {
                                        print("enter empty Date");
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  TextFormField(
                                    controller: jop,
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return "Tasks must not be empty";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15.0)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15.0)),
                                      ),
                                      label: Text("Tasks"),
                                      prefixIcon: Icon(Icons.task),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  ElevatedButton(onPressed: (){
                                    if (context.read<TodocubitCubit>().FormKey.currentState!.validate()) {
                                      if(context.read<TodocubitCubit>().isUbdate) {
                                        title=context.read<TodocubitCubit>().titleController;
                                        time=context.read<TodocubitCubit>().timeController;
                                        date=context.read<TodocubitCubit>().dateController;
                                        jop= context.read<TodocubitCubit>().jopController;

                                        context.read<TodocubitCubit>().updateDataInfo(jop: jop.text,title: title.text, date: date.text, time: time.text, id: context.read<TodocubitCubit>().id );
                                        TimeOfDay? AlarmTime=  context.read<TodocubitCubit>().UpdateAlarmTime;
                                        DateTime? AlarmDate=  context.read<TodocubitCubit>().UpdateAlarmDate;
                                        DateTime oldDate=DateFormat("MMM d, yyyy").parse(date.text);
                                        DateFormat inputFormat = DateFormat("h:mm a");
                                        DateFormat outputFormat = DateFormat("HH:mm");
                                        TimeOfDay oldTime = TimeOfDay.fromDateTime(outputFormat.parse(inputFormat.format(inputFormat.parse(time.text))));
                                        scheduleAlarm(year: AlarmDate?.year??oldDate.year,month: AlarmDate?.month??oldDate.month,day: AlarmDate?.day??oldDate.day,hour: AlarmTime?.hour??oldTime.hour,minute: AlarmTime?.minute??oldTime.minute,id:   context.read<TodocubitCubit>().msgId,task: title.text);
                                        time.clear();
                                        date.clear();
                                        jop.clear();
                                      }

                                      else{

                                        List<Map> tasks=context.read<TodocubitCubit>().newTasks??[{"id":0}];
                                        int msgId=tasks.length>0?tasks[tasks.length-1]['id']:0;
                                        context.read<TodocubitCubit>().InsertIntoDataBase(
                                            title: title.text, time: time.text, date: date.text,msgId: msgId,jop: jop.text);
                                        scheduleAlarm(year: alarmDate.year,month: alarmDate.month,day: alarmDate.day,hour: alarmTime.hour,minute: alarmTime.minute,id: msgId,task: title.text);
                                        MessageToUser(context: context,Message: "Done Add ${jop.text} To ${title.text}");

                                        time.clear();
                                        date.clear();
                                        jop.clear();

                                      }


                                      // Navigator.pop(context);
                                      // context.read<TodocubitCubit>().changeBottomSheetState(isShow: false) ;
                                    }
                                  }, child: Text("+ Add jop",style: TextStyle(color: Colors.white),),style:ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xff2c7da5)
                                  ) ,)


                                ],
                              ),
                            ),
                          ),
                        ),
                  )
                      .closed
                      .then((value) {
                    title.clear();
                    time.clear();
                    date.clear();
                    jop.clear();
                    context.read<TodocubitCubit>().changeBottomSheetState(isShow: false) ;

                    // setState(() {});
                  });

                  context.read<TodocubitCubit>().changeBottomSheetState(isShow: true) ;
                }
              },
              child: Icon(context.read<TodocubitCubit>().BottomShitIsShown ? Icons.add : Icons.edit),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              elevation: 0.0,
              currentIndex: context.read<TodocubitCubit>().currentIndex,
              onTap: (index) {
                context.read<TodocubitCubit>().changeIndex(index);


              },
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Tasks"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.task_alt), label: "Done"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined), label: "Archived"),
              ],
            ),
          );
        },
      ),
    );

  }



  tz.TZDateTime _nextInstanceOfTenAM({required int year,required int month,required int day,required int hour,required int minute,}) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
    tz.TZDateTime(tz.local, year, month, day,hour,minute);
    print(now.year);
    print(now.month);
    print(now.day);
    print(now.hour);
    print(now.minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
  void scheduleAlarm({required int year,required int month,required int day,required int hour,required int minute, int? id,required String task}) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id??0,
        'New Task Todo !',
        task,
        _nextInstanceOfTenAM(day: day,hour: hour,minute: minute,month: month,year: year),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                '0', 'todo alarm',
                channelDescription: 'notify')),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
  }

  MessageToUser({required String Message,required context}){

    return   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Center(child: Text(Message)),
      backgroundColor: Colors.green,
      duration:Duration(milliseconds: 2000),
    ));
  }

}





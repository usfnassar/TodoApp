
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo/cubit/todocubit_cubit.dart';
import 'package:todo/pages/jop_page.dart';

import '../main.dart';

TextEditingController title = TextEditingController();
TextEditingController time = TextEditingController();
TextEditingController date = TextEditingController();
TextEditingController jop = TextEditingController();


Widget buildTaskItem(Map data ,context,{bool isNotDoneScreen=true,required List<Map> jops ,bool isNotArchScreen=true,required int index}) =>
    BlocConsumer<TodocubitCubit, TodocubitState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          bool isRight=true;
          List<int> selectedIndices = context.read<TodocubitCubit>().selectedIndices;
          return GestureDetector(
            onDoubleTap: (){
              context.read<TodocubitCubit>().ChangeMode(idd: data['id'],title: title,time: time,date: date,msg: data["msgId"],jop: jop);
              title.text=data['title'];
              date.text=data['date'];
              time.text=data['time'];
              jop.text=data['jop'];

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
                                      context.read<TodocubitCubit>().UpdateAlarmTime=pickedTime;
                                      time.text =
                                          pickedTime.format(context).toString();
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
                                      print(pickedDte);

                                      context.read<TodocubitCubit>().UpdateAlarmDate=pickedDte;

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
                                  maxLines:5 ,
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
                  context.read<TodocubitCubit>().changeBottomSheetState(isShow: false) ;
                  // setState(() {});
                });

                context.read<TodocubitCubit>().changeBottomSheetState(isShow: true) ;
              },
            onLongPress:(){
              if (selectedIndices.contains(index)) {
                selectedIndices.remove(index);
              } else {
                selectedIndices.add(index);
              }
              context.read<TodocubitCubit>().addElementToDelete(data['id']);
              print(context.read<TodocubitCubit>().DeletedItems);
            } ,
            onTap: ()
            {
              if (selectedIndices.contains(index)) {
                selectedIndices.remove(index);
                context.read<TodocubitCubit>().DeletedItems.remove(data['id']);

              }
              else {
                Navigator.pushNamed(context,JopPage.id,arguments: [jops,context] );
              }
              context.read<TodocubitCubit>().setState();
            },

            child: Dismissible(
              onDismissed: (dir)async
              {
                await flutterLocalNotificationsPlugin.cancel(data['msgId']);
                context.read<TodocubitCubit>().deleteData(id: data['id']);

              },
              background: slideRightBackground(),
              secondaryBackground: slideLeftBackground(),
              key: Key(data['id'].toString()),
              child: Padding(
                padding: const EdgeInsets.only(top:20.0,bottom: 20,right: 20,left: 5),
                child: Row(
                  children: [
                    selectedIndices.contains(index)?Icon(Icons.check_box_outlined,color: Colors.green,size: 30,):Container(),
                    SizedBox(width: 10,),

                    CircleAvatar(
                      radius: 40,
                      child: Text(data['time']),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data["jop"],
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyText1,
                          ),
                          Text(
                            data['date'],
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Visibility(
                      visible: isNotDoneScreen,
                      child: IconButton(
                          icon: Icon(
                            Icons.done_outline_outlined,
                            color: Colors.lightGreen,
                          ),
                          onPressed: () {
                            context.read<TodocubitCubit>().updateData(status: 'done', id: data["id"]);
                          }),
                    ),
                    Visibility(
                      visible: isNotArchScreen,
                      child: IconButton(
                          icon: Icon(Icons.archive_outlined),
                          onPressed: () {
                            context.read<TodocubitCubit>().updateData(status: 'archive', id: data["id"]);


                          }),
                    )
                  ],
                ),
              ),

            ),
          );
        },
      );
Widget slideRightBackground() {
  return Container(
    color: Colors.red,
    child: Align(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Icon(
            Icons.delete,
            color: Colors.white,
          ),
          Text(
            " Delete",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
      alignment: Alignment.centerLeft,
    ),
  );
}
Widget slideLeftBackground() {
  return Container(
    color: Colors.red,
    child: Align(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Icon(
            Icons.delete,
            color: Colors.white,
          ),
          Text(
            " Delete",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.right,
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      alignment: Alignment.centerRight,
    ),
  );
}
Widget taskBuilder({ required List<Map>? tasks,bool isNotDoneScreen=true,bool isNotArchScreen=true}) {


      if (tasks!=null) {
        if (tasks.length>0) {
          List<String>? titles=[];
          List<Map> showTask=[];
          tasks.forEach((task) {
            if(!titles.contains(task['title']))
              {
                titles.add(task['title']);
                showTask.add(task);
              }

          });
                return ListView.separated(
                        itemBuilder: (context, index) {
                          List<Map> jops=[];
                          tasks.forEach((task) {
                            if(task['title']==showTask[index]['title'])
                            {
                              jops.add(task);
                            }
                          });
                          return buildTaskItem(jops: jops,index: index,showTask[index], context,isNotDoneScreen: isNotDoneScreen,isNotArchScreen:isNotArchScreen );
                        },
                        separatorBuilder: (context, index) {
                          return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Container(height: 1, color: Colors.grey,),
                            );
                        },
                        itemCount: showTask.length,
                      );
              }  else {
          return Center(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Icon(
          Icons.menu,
          size: 100,
          color: Colors.grey,
          ),
          Text(
          'No Tasks Yet, Please Add Some Tasks',
          style: TextStyle(
          fontSize: 16,
          color: Colors.grey,
          ),
          )
          ],
          ),
          );
          }
      }
      else {
        return Center(child: CircularProgressIndicator());
      }
}








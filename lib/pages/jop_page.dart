import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../componets/componets.dart';
import '../cubit/todocubit_cubit.dart';

class JopPage extends StatelessWidget {
  static String id = "JopPage";

  JopPage();

  @override
  Widget build(BuildContext context) {
    var data=ModalRoute.of(context)!.settings.arguments as List;
    List<Map> jop=data[0];
    BuildContext blocContext=data[1];
    return  Scaffold(
      appBar: AppBar(
        leading: BackButton(
            color: Colors.white
        ),

        backgroundColor:Color(0xff2c7da5) ,
        title:Text( "TodoApp",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        centerTitle: true,


      ),
      // key:context.read<TodocubitCubit>().ScaffoldKey,
      body: buildListView(blocContext, jop),
    );
  }

  Widget buildListView(BuildContext context, List<Map<dynamic, dynamic>> jop) {
    List jops=jop.sublist(1);
    return BlocProvider.value(
  value: BlocProvider.of<TodocubitCubit>(context),
  child: BlocBuilder<TodocubitCubit, TodocubitState>(
  builder: (context, state) {
    return ListView.separated(
          itemBuilder: (context, index) {
            return GestureDetector(
              // onDoubleTap: (){
              //   context.read<TodocubitCubit>().ChangeMode(idd: data['id'],title: title,time: time,date: date,msg: data["msgId"],jop: jop);
              //   title.text=data['title'];
              //   date.text=data['date'];
              //   time.text=data['time'];
              //   jop.text=data['jop'];
              //
              //     context.read<TodocubitCubit>().ScaffoldKey.currentState
              //         ?.showBottomSheet(
              //
              //           (context) =>
              //           Container(
              //             padding: EdgeInsets.all(40),
              //             child: Form(
              //               key: context.read<TodocubitCubit>().FormKey,
              //               child: SingleChildScrollView(
              //                 child: Column(
              //                   mainAxisSize: MainAxisSize.min,
              //                   children: [
              //                     TextFormField(
              //                       controller: title,
              //                       validator: (String? value) {
              //                         if (value!.isEmpty) {
              //                           return "Title must not be empty";
              //                         }
              //                         return null;
              //                       },
              //                       decoration: InputDecoration(
              //                         border: OutlineInputBorder(
              //                           borderRadius: BorderRadius.all(
              //                               Radius.circular(15.0)),
              //                         ),
              //                         enabledBorder: OutlineInputBorder(
              //                           borderRadius: BorderRadius.all(
              //                               Radius.circular(15.0)),
              //                         ),
              //                         label: Text("Title"),
              //                         prefixIcon: Icon(Icons.title),
              //                       ),
              //                     ),
              //                     SizedBox(
              //                       height: 15.0,
              //                     ),
              //                     TextFormField(
              //                       validator: (String? value) {
              //                         if (value!.isEmpty) {
              //                           return "Time must not be empty";
              //                         }
              //                         return null;
              //                       },
              //                       readOnly: true,
              //                       controller: time,
              //                       decoration: InputDecoration(
              //                         border: OutlineInputBorder(
              //                           borderRadius: BorderRadius.all(
              //                               Radius.circular(15.0)),
              //                         ),
              //                         enabledBorder: OutlineInputBorder(
              //                           borderRadius: BorderRadius.all(
              //                               Radius.circular(15.0)),
              //                         ),
              //                         label: Text("Time"),
              //                         prefixIcon: Icon(
              //                             Icons.watch_later_outlined),
              //                       ),
              //                       onTap: () async {
              //                         TimeOfDay? pickedTime = await showTimePicker(
              //                           context: context,
              //                           initialTime: TimeOfDay.now(),
              //                         );
              //                         if (pickedTime != null) {
              //                           context.read<TodocubitCubit>().UpdateAlarmTime=pickedTime;
              //                           time.text =
              //                               pickedTime.format(context).toString();
              //                         }
              //                         else {
              //                           print("enter empty time");
              //                         }
              //                       },
              //                     ),
              //                     SizedBox(
              //                       height: 15.0,
              //                     ),
              //                     TextFormField(
              //                       validator: (String? value) {
              //                         if (value!.isEmpty) {
              //                           return "Date must not be empty";
              //                         }
              //                         return null;
              //                       },
              //                       readOnly: true,
              //                       controller: date,
              //                       decoration: InputDecoration(
              //                         border: OutlineInputBorder(
              //                           borderRadius: BorderRadius.all(
              //                               Radius.circular(15.0)),
              //                         ),
              //                         enabledBorder: OutlineInputBorder(
              //                           borderRadius: BorderRadius.all(
              //                               Radius.circular(15.0)),
              //                         ),
              //                         label: Text("Date"),
              //                         prefixIcon: Icon(Icons.date_range),
              //                       ),
              //                       onTap: () async {
              //                         DateTime?pickedDte = await showDatePicker(
              //                           context: context,
              //                           initialDate: DateTime.now(),
              //                           firstDate: DateTime.now(),
              //                           lastDate: DateTime.parse("2040-12-12"),
              //                         );
              //                         if (pickedDte != null) {
              //                           print(pickedDte);
              //
              //                           context.read<TodocubitCubit>().UpdateAlarmDate=pickedDte;
              //
              //                           date.text =
              //                               DateFormat.yMMMd().format(pickedDte);
              //                         }
              //                         else {
              //                           print("enter empty Date");
              //                         }
              //                       },
              //                     ),
              //                     SizedBox(
              //                       height: 15.0,
              //                     ),
              //
              //                     TextFormField(
              //                       controller: jop,
              //                       maxLines:5 ,
              //                       validator: (String? value) {
              //                         if (value!.isEmpty) {
              //                           return "Tasks must not be empty";
              //                         }
              //                         return null;
              //                       },
              //                       decoration: InputDecoration(
              //                         border: OutlineInputBorder(
              //                           borderRadius: BorderRadius.all(
              //                               Radius.circular(15.0)),
              //                         ),
              //                         enabledBorder: OutlineInputBorder(
              //                           borderRadius: BorderRadius.all(
              //                               Radius.circular(15.0)),
              //                         ),
              //                         label: Text("Tasks"),
              //                         prefixIcon: Icon(Icons.task),
              //                       ),
              //                     ),
              //                     SizedBox(
              //                       height: 15.0,
              //                     ),
              //
              //
              //                   ],
              //                 ),
              //               ),
              //             ),
              //           ),
              //     )
              //         .closed
              //         .then((value) {
              //       title.clear();
              //       time.clear();
              //       date.clear();
              //       context.read<TodocubitCubit>().changeBottomSheetState(isShow: false) ;
              //       // setState(() {});
              //     });
              //
              //     context.read<TodocubitCubit>().changeBottomSheetState(isShow: true) ;
              //   },
              // onLongPress:(){
              //   if (selectedIndices.contains(index)) {
              //     selectedIndices.remove(index);
              //   } else {
              //     selectedIndices.add(index);
              //   }
              //   context.read<TodocubitCubit>().addElementToDelete(data['id']);
              //   print(context.read<TodocubitCubit>().DeletedItems);
              // } ,


              child: Dismissible(
                onDismissed: (dir)async
                {
                  context.read<TodocubitCubit>().deleteData(id: jops[index]['id']);
                  jop.removeAt(index);


                },
                background: slideRightBackground(),
                secondaryBackground: slideLeftBackground(),
                key: Key(jops[index]['id'].toString()),
                child: Padding(
                  padding: const EdgeInsets.only(top:20.0,bottom: 20,right: 20,left: 5),
                  child: Row(
                    children: [
                      // selectedIndices.contains(index)?Icon(Icons.check_box_outlined,color: Colors.green,size: 30,):Container(),
                      SizedBox(width: 10,),

                      CircleAvatar(
                        radius: 40,
                        child: Text(jops[index]["time"]),
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
                              jops[index]["jop"],
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyText1,
                            ),
                            Text(
                              jops[index]['date'],
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

                    ],
                  ),
                ),

              ),
            );;
          },
          separatorBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(height: 1, color: Colors.grey,),
            );
          },
          itemCount: jops.length,
        );
  },
),
);
  }
}

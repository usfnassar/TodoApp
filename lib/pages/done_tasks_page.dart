import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../componets/componets.dart';
import '../cubit/todocubit_cubit.dart';

class DoneTasksPage extends StatelessWidget {
  static String id = "DonePage";

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodocubitCubit, TodocubitState>(
      listener: (context, state) {},
      builder: (context, state) {
        return taskBuilder(tasks: context
            .read<TodocubitCubit>()
            .doneTasks,isNotDoneScreen: false);
      },
    );
  }
}

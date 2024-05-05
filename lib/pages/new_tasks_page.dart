import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/cubit/todocubit_cubit.dart';

import '../componets/componets.dart';

class NewTasksPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodocubitCubit, TodocubitState>(
      listener: (context, state) {
      },
      builder: (context, state) {
        return taskBuilder(tasks: context.read<TodocubitCubit>().newTasks);
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../componets/componets.dart';
import '../cubit/todocubit_cubit.dart';

class ArchiveTasksPage extends StatelessWidget {
  static String id="archivePage";
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodocubitCubit, TodocubitState>(
      listener: (context, state) {},
      builder: (context, state) {
        return taskBuilder(tasks: context
            .read<TodocubitCubit>()
            .archivedTasks,isNotArchScreen: false);
      },
    );
  }
}

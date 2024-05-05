part of 'todocubit_cubit.dart';

@immutable
abstract class TodocubitState {}

class TodocubitInitial extends TodocubitState {}
class AppChangeBottomSheetState extends TodocubitState {}
class AppChangeBottomNavBarState extends TodocubitState {}
class InsertIntoDbState extends TodocubitState {}
class CreateDbState extends TodocubitState {}
class GetDbState extends TodocubitState {}
class LoadingGetDbState extends TodocubitState {}
class UbdateDb extends TodocubitState {}
class MoveState extends TodocubitState {}
class DeleteFromDb extends TodocubitState {}
class ChangeModeState extends TodocubitState {}
class BackModeState extends TodocubitState {}
class AddElementToDeleteState extends TodocubitState {}
class SetSate extends TodocubitState {}


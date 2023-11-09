part of 'employee_list_bloc.dart';

@immutable
abstract class EmployeeListEvent {}

class GetAllEmployeeList extends EmployeeListEvent {
  GetAllEmployeeList();
}

class AddEmployeeList extends EmployeeListEvent {
  final Employee emp;
  AddEmployeeList({this.emp});
}

class UpdateEmployeeList extends EmployeeListEvent{
  final Employee emp;
  UpdateEmployeeList(this.emp);
}

class DeleteEmployeeList extends EmployeeListEvent{
  final int empId;
  DeleteEmployeeList(this.empId);
}
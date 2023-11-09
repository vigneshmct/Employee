part of 'employee_list_bloc.dart';

abstract class EmployeeListState {
  List<Employee> empList=[];
  EmployeeListState({this.empList});
}

class EmployeeListInitial extends EmployeeListState {
  EmployeeListInitial({ List<Employee> empList}) : super (empList: empList);
}

class EmployeeListUpdated extends EmployeeListState {
  EmployeeListUpdated({ List<Employee> empList}) : super (empList: empList);
}

class GetAllEmployeeListState extends EmployeeListState {
  GetAllEmployeeListState({ List<Employee> empList}) : super (empList: empList);
}

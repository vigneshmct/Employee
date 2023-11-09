import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../datahelper/data-helper.dart';
import '../../modelClass/employee.dart';
part 'employee_list_event.dart';
part 'employee_list_state.dart';


class EmployeeListBloc extends Bloc<EmployeeListEvent, EmployeeListState> {
  var db = new DatabaseHelper();
  EmployeeListBloc() : super(EmployeeListInitial(empList: [])) {
     on<GetAllEmployeeList>(_getAllEmployee);
    on<AddEmployeeList>(_addEmployee);
    on<UpdateEmployeeList>(_updateEmployee);
    on<DeleteEmployeeList>(_deleteEmployee);
  }

  Future<FutureOr<void>> _getAllEmployee(GetAllEmployeeList event, Emitter<EmployeeListState> emit) async {
    List list= await db.getAllEmployee();
    List<Employee> empList =[];
    list.forEach((element) {
     empList.add( Employee(id: element['pid'],
          name: element['name'],
          role: element['role'],
          fromDate: element['fromDate'],
          toDate: element['toDate']));

    });
    state.empList=[];
    state.empList=empList;
    emit(GetAllEmployeeListState(empList: state.empList));
  }

  Future<FutureOr<void>> _addEmployee(AddEmployeeList event, Emitter<EmployeeListState> emit) async {
    await db.insertNote(Employee(
        name: event.emp.name,
        role: event.emp.role,
        toDate: event.emp.toDate,
        fromDate: event.emp.fromDate == 'Today'
            ? DateFormat('dd-MMM-yyyy')
            .format(DateTime.now())
            : event.emp.fromDate));

    emit(EmployeeListUpdated(empList: state.empList));
  }

  Future<FutureOr<void>> _updateEmployee(UpdateEmployeeList event, Emitter<EmployeeListState> emit) async {

    await db.updateNote(Employee(
        id: event.emp.id,
        name: event.emp.name,
        role: event.emp.role,
        toDate: event.emp.toDate,
        fromDate: event.emp.fromDate == 'Today'
            ? DateFormat('dd-MMM-yyyy')
            .format(DateTime.now())
            : event.emp.fromDate));

    emit(EmployeeListUpdated(empList: state.empList));
  }

  Future<FutureOr<void>> _deleteEmployee(DeleteEmployeeList event, Emitter<EmployeeListState> emit) async {
    await db.deleteNote(event.empId);
    List list= await db.getAllEmployee();
    List<Employee> empList =[];
    list.forEach((element) {
      empList.add( Employee(id: element['pid'],
          name: element['name'],
          role: element['role'],
          fromDate: element['fromDate'],
          toDate: element['toDate']));

    });
    state.empList=[];
    state.empList=empList;
    emit(EmployeeListUpdated(empList: state.empList));
  }

  Future<List<Employee>> getAllEmployee()
  async {
    List list= await db.getAllEmployee();
    List<Employee> empList =[];
    list.forEach((element) {
      empList.add( Employee(id: element['pid'],
          name: element['name'],
          role: element['role'],
          fromDate: element['fromDate'],
          toDate: element['toDate']));

    });
    return empList;
  }

}

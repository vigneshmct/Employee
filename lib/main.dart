import 'dart:convert';

import 'package:flpfbonew/pages/employee-edit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'block-provider/employee_list_bloc.dart';
import 'datahelper/data-helper.dart';
import 'modelClass/employee.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => EmployeeListBloc())],
      child:MaterialApp(
        routes: {
          '/home': (context) => MyHomePage(),
        },
        initialRoute: '/home',
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: const MyHomePage(),
      ) ,
    );

  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  EmployeeListBloc empBloc = EmployeeListBloc();

  var db = new DatabaseHelper();
  List<Employee> list = [];
  List<Employee> currentEmpList = [];
  List<Employee> previousEmpList = [];
  bool isHaveEmpList = false;
  @override
  initState() {
    // TODO: implement initState
    super.initState();

    db.initDb();
    empBloc.add(GetAllEmployeeList());
  }

  getEmployee(List<Employee> listDB) async {
    // List<Employee>listDB = empBloc.state.empList;
    for(int i=0;i<listDB.length;i++) {
      setState(() {
        if(listDB[i].toDate=='No Date')
          {
            currentEmpList.add( listDB[i]);
          }
        else
          {
            previousEmpList.add(listDB[i]);
          }

      });
    }
  }

  List<Employee> getCurrentEmployee() {
    return list.where((emp) => emp.toDate == '' || emp.toDate == null).toList();
  }

  List<Employee> getPreviousEmployee() {
    return list.where((emp) => emp.toDate != '').toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee List'),
        elevation: 0,
      ),
      body:
        BlocBuilder<EmployeeListBloc, EmployeeListState>(
    bloc: empBloc,
    builder: (context, state) {
      if(state.empList.isNotEmpty)
        {
          currentEmpList=[];
          previousEmpList=[];
          for(int i=0;i<state.empList.length;i++)
            {
              state.empList[i].toDate=='No Date'?currentEmpList.add( state.empList[i]):previousEmpList.add(state.empList[i]);
            }
        }

      return state.empList.isNotEmpty?Container(
          child: Column(
            children: [
              Container(
                color: Colors.grey[300],
                height: 40,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      child: Text(
                        'Current Employee',
                        style: TextStyle(fontSize: 17, color: Colors.blue),
                      ),
                      padding: EdgeInsets.only(left: 10),
                    ),

                    // Add other widgets as needed
                  ],
                ),
              ),
              Container(
                height: (MediaQuery
                    .of(context)
                    .size
                    .height / 2) - 120,
                child: Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: currentEmpList.length == null
                        ? 0
                        : currentEmpList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) =>
                                  EmployeeInstUpdScreen(action: 'Edit',
                                      emp: currentEmpList[index])));
                        },
                        child: Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.20,
                          child: Container(
                            padding: EdgeInsets.only(left: 10),
                            color: Colors.white,
                            child: Row(
                                children: [ Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(currentEmpList[index].name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),),
                                    SizedBox(height: 10,),
                                    Text(currentEmpList[index].role,
                                        style: TextStyle(
                                            color: Colors.grey[500])),
                                    SizedBox(height: 5,),
                                    Text(
                                      'From ' + currentEmpList[index].fromDate,
                                      style: TextStyle(
                                          color: Colors.grey[500]),),
                                    SizedBox(height: 10,),
                                  ],
                                ),
                                ]
                            ),
                          ),

                          secondaryActions: <Widget>[
                            IconSlideAction(
                              caption: 'Delete',
                              color: Colors.red,
                              icon: Icons.delete,
                              onTap: () async => {
                              empBloc.add(DeleteEmployeeList(currentEmpList[index].id))
                                // await db.deleteNote(currentEmpList[index].id)
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              Container(
                color: Colors.grey[300],
                height: 40,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      child: Text(
                        'Previous Employee',
                        style: TextStyle(fontSize: 17, color: Colors.blue),
                      ),
                      padding: EdgeInsets.only(left: 10),
                    ),

                    // Add other widgets as needed
                  ],
                ),
              ),
              Container(
                height: (MediaQuery
                    .of(context)
                    .size
                    .height / 2) - 120,
                child: Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    // primary: false,
                    shrinkWrap: true,
                    itemCount: previousEmpList.length == null
                        ? 0
                        : previousEmpList.length,
                    itemBuilder: (BuildContext context, int index) {
                      //  Map place = bestsellingList.reversed.toList()[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) =>
                                  EmployeeInstUpdScreen(action: 'Edit',
                                      emp: previousEmpList[index])));
                        },
                        child: Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          child: Container(
                            padding: EdgeInsets.only(left: 10),
                            color: Colors.white,
                            child: Row(
                                children: [ Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(previousEmpList[index].name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),),
                                    SizedBox(height: 10,),
                                    Text(previousEmpList[index].role,
                                        style: TextStyle(
                                            color: Colors.grey[500])),
                                    SizedBox(height: 5,),
                                    Text(
                                      'From ' + previousEmpList[index].fromDate +
                                          ' - ' +
                                          previousEmpList[index].toDate,
                                      style: TextStyle(
                                          color: Colors.grey[500]),),
                                    SizedBox(height: 10,),
                                  ],
                                ),
                                ]
                            ),


                          ),

                          secondaryActions: <Widget>[
                            IconSlideAction(
                              caption: 'Delete',
                              color: Colors.red,
                              icon: Icons.delete,
                              onTap: () => {
                                empBloc.add(DeleteEmployeeList(previousEmpList[index].id))
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      child: Text(
                        'Swipe left to delete',
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      padding: EdgeInsets.only(left: 10),
                    ),
                    Padding(
                      child: Container(
                        // color: Colors.blue,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(15)),
                        child: IconButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) =>
                                    EmployeeInstUpdScreen(action: 'ADD')));
                          },
                          icon: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),

                          iconSize: 30, // Set the size of the icon
                        ),
                      ),
                      padding: EdgeInsets.only(right: 20, top: 3),
                    ),
                  ],
                ),
              )
            ],
          )):Container(
      child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
      Container(
      height: (MediaQuery
          .of(context)
          .size
          .height / 2) - 40,
      child: Center(
      child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
      Container(
      height: MediaQuery
          .of(context)
          .size
          .width * 0.47,
      child: Image.asset('assets/Logo/img.png'),
      padding: EdgeInsets.all(3),
      ),
      Text('No employee records found'),
      ],
      ),
      ),
      ),
      Container(
      height: (MediaQuery
          .of(context)
          .size
          .height / 2) - 60,
      child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
      Container(
      margin: EdgeInsets.only(bottom: 30),
      height: 50,
      child: Padding(
      child: Container(
      // color: Colors.blue,
      decoration: BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.circular(15)),
      child: IconButton(
      onPressed: () {
      Navigator.push(context, MaterialPageRoute(
      builder: (context) =>
      EmployeeInstUpdScreen(action: 'ADD')));
      },
      icon: Icon(
      Icons.add,
      color: Colors.white,
      ),

      iconSize: 30, // Set the size of the icon
      ),
      ),
      padding: EdgeInsets.only(right: 30, top: 3),
      ),
      )
      ],
      ),
      )
      ],
      ));
    }),
    );
  }
}




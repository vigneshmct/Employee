import 'package:flpfbonew/main.dart';
import 'package:flpfbonew/modelClass/employee.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../block-provider/employee_list_bloc.dart';
import '../datahelper/data-helper.dart';

class EmployeeInstUpdScreen extends StatefulWidget {
  String action = '';
  Employee emp;

  EmployeeInstUpdScreen({Key key, @required this.action, this.emp})
      : super(key: key);

  @override
  EmployeeInstUpdScreenState createState() =>
      EmployeeInstUpdScreenState(this.action, this.emp);
}

class EmployeeInstUpdScreenState extends State<EmployeeInstUpdScreen> {
  TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String action = '';
  Employee emp;
  List list = [
    'Product Designer',
    'Flutter Developer',
    'QA Tester',
    'Product Own'
  ];
  EmployeeListBloc empBloc =EmployeeListBloc();
  // String selectedValue = 'Option 1';
  bool isSelectDrop = false;
  bool isDropASValue = false;
  String role = 'Employee Role';

  EmployeeInstUpdScreenState(this.action, this.emp);

  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  String toDateStr = 'No Date';
  String fromDateStr = 'Today';

  var db = new DatabaseHelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db = DatabaseHelper();
    this._nameController.text = '';
    if (this.action.toLowerCase() != 'add') {
      this._nameController.text = emp.name;
      this.role = emp.role;
      this.toDateStr =
          (emp.toDate == '' || emp.toDate == null) ? 'No Date' : emp.toDate;
      this.fromDateStr = emp.fromDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: this.action == 'ADD'
              ? Text('Add Employee Details')
              : Text('Edit Employee Details'),
          actions: [
            this.action == 'ADD'
                ? Center()
                : IconButton(onPressed: () async {
              // await db.deleteNote(emp.id);
              empBloc.add(DeleteEmployeeList(emp.id));
              Navigator.pushReplacementNamed(context, '/home');
            }, icon: Icon(Icons.delete))
          ],
        ),
        body: Container(
          padding: EdgeInsets.only(right: 5, left: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                  // height: 40,
                  child: Form(
                key: _formKey,
                child: TextFormField(
                  controller: _nameController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter name';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Employee Name',
                    labelStyle: TextStyle(color: Colors.grey[500]),
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.blue,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              )),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  setState(() {
                    isDropASValue = false;
                    isSelectDrop = true;
                  });
                  _showBottomSheet(context);
                },
                child: Container(
                    decoration: BoxDecoration(
                      // color: Colors.red,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: isDropASValue ? Colors.red : Colors.grey[500],
                        // Border color
                        width: 1, // Border width
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              SizedBox(
                                width: 15,
                              ),
                              Icon(
                                Icons.shopping_bag,
                                color: Colors.blue,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                role,
                                style: TextStyle(
                                    fontSize: 16,
                                    color:
                                        isSelectDrop || role != 'Employee Role'
                                            ? Colors.black
                                            : Colors.grey[500]),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: Colors.blue,
                          size: 40,
                        )
                      ],
                    )),
              ),
              isDropASValue
                  ? Padding(
                      padding: EdgeInsets.only(top: 5, left: 10),
                      child: Text(
                        'Please select role',
                        style: TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    )
                  : Center(),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        _selectFromDate(context);
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            // color: Colors.red,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: isSelectDrop
                                  ? Colors.blue
                                  : Colors.grey[500], // Border color
                              width: 1, // Border width
                            ),
                          ),
                          height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Icon(
                                      Icons.calendar_month,
                                      color: Colors.blue,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                          3.5,
                                      child: Text(
                                        fromDateStr,
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.blue,
                    ),
                    GestureDetector(
                      onTap: () {
                        // setState(() {
                        //   isSelectDrop = true;
                        // });
                        _selectToDate(context);
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            // color: Colors.red,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: isSelectDrop
                                  ? Colors.blue
                                  : Colors.grey[500], // Border color
                              width: 1, // Border width
                            ),
                          ),
                          height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Icon(
                                      Icons.calendar_month,
                                      color: Colors.blue,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                          3.5,
                                      child: Text(
                                        toDateStr,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: toDateStr != 'No Date'
                                                ? Colors.black
                                                : Colors.grey[500]),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        persistentFooterButtons: [
          Padding(
            padding: EdgeInsets.only(right: 10, bottom: 5),
            child: Container(
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blue[100],
              ),
              child: TextButton(
                  onPressed: () {
                    // Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyApp()));
                  },
                  child: Text(
                    'Cancle',
                    style: TextStyle(color: Colors.blue),
                  )),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 15, bottom: 5),
            child: Container(
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blue,
              ),
              child: TextButton(
                  onPressed: () async {
                    setState(() {
                      if (role == 'Employee Role') {
                        isDropASValue = true;
                      }
                    });
                    if (_formKey.currentState.validate()) {
                      Map<String, dynamic> param = {
                        'name': _nameController.text,
                        'role': role,
                        'fromDate': fromDateStr,
                        'toDate': toDateStr
                      };
                      if (this.action.toLowerCase() == 'add') {
                      Employee emp =  Employee(
                              name: _nameController.text,
                              role: role,
                              toDate: toDateStr,
                              fromDate: fromDateStr == 'Today'
                                  ? DateFormat('dd-MMM-yyyy')
                                      .format(DateTime.now())
                                  : fromDateStr);

                        empBloc.add(AddEmployeeList(emp: emp));
                        // await db.insertNote(Employee(
                        //     name: _nameController.text,
                        //     role: role,
                        //     toDate: toDateStr,
                        //     fromDate: fromDateStr == 'Today'
                        //         ? DateFormat('dd-MMM-yyyy')
                        //             .format(DateTime.now())
                        //         : fromDateStr));
                      } else {
                        // await db.updateNote(Employee(
                        //     id: emp.id,
                        //     name: _nameController.text,
                        //     role: role,
                        //     toDate: toDateStr,
                        //     fromDate: fromDateStr == 'Today'
                        //         ? DateFormat('dd-MMM-yyyy')
                        //             .format(DateTime.now())
                        //         : fromDateStr));
                        Employee empUpdate =  Employee(
                          id: emp.id,
                            name: _nameController.text,
                            role: role,
                            toDate: toDateStr,
                            fromDate: fromDateStr == 'Today'
                                ? DateFormat('dd-MMM-yyyy')
                                .format(DateTime.now())
                                : fromDateStr);

                        empBloc.add(UpdateEmployeeList(empUpdate));
                      }
                    }
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyApp()));
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  )),
            ),
          )
        ]);
  }

  //To Date Picker
  Future<void> _selectToDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: toDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(3030),
    );

    if (picked != null) {
      setState(() {
        toDate = picked;
        toDateStr = DateFormat('dd-MMM-yyyy').format(toDate);
      });
    }
  }

  //Form Date Picker
  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: fromDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(3030),
    );

    if (picked != null) {
      setState(() {
        fromDate = picked;
        fromDateStr = DateFormat('dd-MMM-yyyy').format(fromDate);
      });
    }
  }

  //Bottom drop drow
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
        top: Radius.circular(30),
      )),
      context: context,
      builder: (BuildContext ctx) {
        return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: list.length == null ? 0 : list.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    role = list[index];
                    isSelectDrop = false;
                  });
                  Navigator.pop(context);
                },
                child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(color: Colors.grey[200], width: 1)),
                    ),
                    height: 40,
                    child: Center(
                        child: Text(
                      list[index],
                      style: TextStyle(fontSize: 18),
                    ))),
              );
            });
      },
    );
  }
}

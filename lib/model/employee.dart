import 'dart:io';

import 'package:flutter/cupertino.dart';

class Employee {
  int id;
  String name;
  String role;
  String toDate;
  String fromDate;

  Employee(
      {@required this.id, @required this.name, @required this.role, @required this.toDate, @required this.fromDate});

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
        id: map['pid'],
        name: map['name'],
        role: map['role'],
        fromDate: map['fromDate'],
        toDate: map['toDate']
    );
  }

  Employee.fromJson(Map<String, dynamic> json) {
    id = json['pid'];
    name = json['name'];
    role = json['role'];
    toDate = json['todate'];
    fromDate = json['formDate'];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if ( pid != null) {
      map['pid'] =  pid;
    }
    map['name'] =  name;
    map['role'] =  role;
    map['fromDate'] =  fromDate;
    map['toData'] =  toDate;
    return map;
  }
}
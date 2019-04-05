import 'package:flutter/material.dart';

class DailylabourReport{

  final String fireBaseId;
  final String temName;
  final String projectName;
  final String date;
  final List<Map<String,String>> labourDetails;
  final String advanceAmount;
  final List<Map<String,String>> foodAllowance;
  final String otherAllowance;
  final String reasonAllowance;
  final List<Map<String,String>> otDetails;

  DailylabourReport({
    @required this.fireBaseId,
    @required this.temName,
    @required this.projectName,
    @required this.date,
    @required this.labourDetails,
    @required this.advanceAmount,
    @required this.foodAllowance,
    @required this.otherAllowance,
    @required this.reasonAllowance,
    @required this.otDetails
});


}
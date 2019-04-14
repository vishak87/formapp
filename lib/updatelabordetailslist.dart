import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'model/datereportfields.dart';
import 'model/dailyreportformfields.dart';
import 'widgets/dailyreportviewcard.dart';
class UpdateLaborDetailsList extends StatelessWidget {
  Map<String, dynamic> responseMap = {};
  Map<String, List<DateReportField>> transformedData = {};
  Map<String, dynamic> dateReportMap = {};
  Map<String, dynamic> dataFromDB = {};
  List<DailyReportFormModel> lstrprtModel=[];
  Map<String,dynamic> teamDataFromDB= {};
  Map<String,dynamic> transformedTeamDataFromDB={};

  Future<_DailyReportResponse> _dailyReportData;

  Future<_DailyReportResponse> fetchTeamProjectDetails() async {
    final _dailyReportResponse = await http.get(
        'https://operationsreporting-584ec.firebaseio.com/dailyreports.json');

    final _dailyReportResponse2 = await http.get(
        'https://operationsreporting-584ec.firebaseio.com/TeamDetails.json');

    if (_dailyReportResponse.statusCode == 200 && _dailyReportResponse2.statusCode==200) {
      // If the call to the server was successful, parse the JSON
      teamDataFromDB=json.decode(_dailyReportResponse2.body);
      teamDataFromDB.forEach((fbid,teamDataMap){
        Map<String,String> tempMap ={
        "baseSalary":teamDataMap['baseSalary'],
        "foodAllowance":teamDataMap['foodAllowance'],
        "mesthriAllowance":teamDataMap['mesthriAllowance'],
        "otAllowance": teamDataMap['otAllowance'],
        "sprayAllowance": teamDataMap['sprayAllowance'],
        "teamName": teamDataMap['teamName'],
         "fbid": fbid

        };
        transformedTeamDataFromDB[teamDataMap['teamName']] = tempMap;

      });

      print(json.decode(_dailyReportResponse.body));
      responseMap = json.decode(_dailyReportResponse.body);
      return _DailyReportResponse(json.decode(_dailyReportResponse.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('Update report details'),),
      body: Center(
                   child: FutureBuilder(
                    future: fetchTeamProjectDetails(),
                    builder: (context, snapshot) {
                    if (snapshot.hasData) {
                    responseMap = snapshot.data.dailyDataMap;
                    responseMap.forEach((dateString, laborUpdateMap) {
                    dateReportMap = laborUpdateMap;
                    dateReportMap.forEach((fbid, reportMap) {
                    DailyReportFormModel drfmmodel = DailyReportFormModel(fbid,
                                                                              reportMap['OtDetails'],
                                                                              reportMap['advanceAmount'],
                                                                              reportMap['date'],
                                                                              reportMap['foodAmountRow1'],
                                                                              reportMap['foodAmountRow2'],
                                                                              reportMap['foodAmountRow3'],
                                                                              reportMap['foodDetails'],
                                                                              reportMap['labourDetails'],
                                                                              reportMap['labourRow1'],
                                                                              reportMap['labourRow2'],
                                                                              reportMap['labourRow3'],
                                                                              reportMap['labourShiftRow1'],
                                                                              reportMap['labourShiftRow2'],
                                                                              reportMap['labourShiftRow3'],
                                                                              reportMap['mesthriShift'],
                                                                              reportMap['otherAllowance'],
                                                                              reportMap['otherAllowanceReason'],
                                                                              reportMap['pendingSalary'],
                                                                              reportMap['projectName'],
                                                                              reportMap['shiftOTRow1'],
                                                                              reportMap['shiftOTRow2'],
                                                                              reportMap['shiftOTRow3'],
                                                                              reportMap['sprayLabour'],
                                                                              reportMap['teamName'],
                                                                              reportMap['workerFoodRow1'],
                                                                              reportMap['workerFoodRow2'],
                                                                              reportMap['workerFoodRow3'],
                                                                              reportMap['workerOTRow1'],
                                                                              reportMap['workerOTRow2'],
                                                                              reportMap['workerOTRow3']);
                    lstrprtModel.add(drfmmodel);

                    });
                });
                    lstrprtModel = lstrprtModel.reversed.toList();
                    return ListView.builder(itemBuilder: (context,index){
                      return DailyReportFormFieldsCard(lstrprtModel[index],transformedTeamDataFromDB[lstrprtModel[index].teamName]);

                    },itemCount: lstrprtModel.length,);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              return Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }
}

class _DailyReportResponse {
  final Map<String, dynamic> dailyDataMap;


  _DailyReportResponse(this.dailyDataMap);
}

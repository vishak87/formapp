import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'model/reportfields.dart';
import 'model/datereportfields.dart';
import 'reportpageview.dart';

class GenerateReportHomepage extends StatelessWidget{



  Map<String,List<DateReportField>> transformedData={};
  Map<String,ReportFields> siteTeamReportMa={};
  Map<String,dynamic> responseMap={};
  Map<String,dynamic> reduceMap={};

  GenerateReportHomepage(){
    _dailyReportData=fetchTeamProjectDetails();
  }

  Future<_DailyReportResponse> _dailyReportData ;

  Future<_DailyReportResponse> fetchTeamProjectDetails() async {
    final _dailyReportResponse = await http
        .get('https://operationsreporting-584ec.firebaseio.com/dailyreports.json');



    if (_dailyReportResponse.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      print(json.decode(_dailyReportResponse.body));
      responseMap=json.decode(_dailyReportResponse.body);
      return _DailyReportResponse(json.decode(_dailyReportResponse.body));

    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  _transformMap(){

    //this key is a date

    reduceMap.forEach((key,dataMap){

      /**
       * _ReportFields(this.fbId,this.date,this.OtDetails,this.advanceAmount,this.labourDetails,this.foodDetails,
          this.projectName,this.teamName,this.otherAllowance,this.otherAllowanceReason,this.pendingSalary);*/
      //this datakey is fbId autogenerated
      if(dataMap!=null){

        dataMap.forEach((dataKey,valueMap){
          ReportFields _reportFields= ReportFields(dataKey,valueMap['date'],valueMap['OtDetails'],valueMap['advanceAmount'],
                                                         valueMap['labourDetails'],valueMap['foodDetails'],valueMap['projectName'],valueMap['teamName'],valueMap['otherAllowance'],
                                                         valueMap['otherAllowanceReason'],valueMap['pendingSalary'],valueMap['mesthriShift']
                                                   ,valueMap['sprayLabour']);

          if(transformedData.containsKey( _reportFields.teamName+'-'+_reportFields.projectName)) {
            transformedData[ _reportFields.teamName + '-' +
                _reportFields.projectName].add(DateReportField(_reportFields, key));
          }
          else{
            List<DateReportField> lstDatereportfield=[];
            lstDatereportfield.add(DateReportField(_reportFields, key));
            transformedData[ _reportFields.teamName + '-' +
                _reportFields.projectName]=lstDatereportfield;

          }
        });

      }


    });

  }

  _reduceData(DateTime frmDate,DateTime toDate){
    List<String> dates=[];
    Duration diff = toDate.difference(frmDate);
    int difference =diff.inDays;
    DateTime currDate=frmDate;
    String strDate='';
    for(int i=0;i< difference;i++){
      currDate=currDate.add(Duration(days: 1));
      strDate=currDate.toString().substring(0,currDate.toString().indexOf(' '));
      dates.add(strDate);
    }

    dates.forEach((date){
      reduceMap[date]=responseMap[date];
    });



  }

  final formats = {
    InputType.date: DateFormat('dd-MM-yyyy'),
  };
  DateTime fromdt;
  DateTime todt;

  _buildDateField(String label) {

    InputType inputType = InputType.date;
    return DateTimePickerFormField(
      decoration:
      InputDecoration(labelText: label, hasFloatingPlaceholder: false),
      dateOnly: true,
      inputType: inputType,
      format: formats[inputType],
      editable: false,
      onChanged: (dt){
      if(label=='From Date'){
        fromdt=dt;
      }
      else{
        todt=dt;
      }
      },
      );
  }
   @override
  Widget build(BuildContext context) {
    // TODO: implement build
     SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return Center(
      child: FutureBuilder(
          future: _dailyReportData,
          builder: (context, snapshot) {

            if(snapshot.hasData){
              return  Column(
                children: <Widget>[
                  _buildDateField('From Date'),
                  _buildDateField('To Date'),
                  RaisedButton(onPressed: (){
                    if(!todt.difference(fromdt).isNegative){
                      _reduceData(fromdt,todt);
                      _transformMap();
                      print(transformedData) ;
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ReportPageView(transformedData)),
                        );
                    }

                  },
                                 child: Text('Submit'),)

                ],
                );
            }
            else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            return Center(child: CircularProgressIndicator() ,
                          );

          }



          ),
      );


  }

}

class _DailyReportResponse{
  final Map<String, dynamic> dailyDataMap;

  _DailyReportResponse(this.dailyDataMap);
}


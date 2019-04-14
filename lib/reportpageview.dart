import 'package:flutter/material.dart';
import 'model/datereportfields.dart';
import 'package:flutter/services.dart';

class ReportPageView extends StatelessWidget {
  Map<String, List<DateReportField>> transformedData;

  Map<String, List<_TeamSalaryDetails>> _mapSummary = {};
  ReportPageView(this.transformedData);
  double _totalSalary = 0.0;
  List<_TeamSalaryDetails> teamSalarySummary = [];
  Map<String, double> salaryMap = {};
  _buildPageView(BuildContext context) {

    List<SingleChildScrollView> dataTables = [];
    if (transformedData != null) {
      transformedData.forEach((key, lstRecords) {
        dataTables.add(_buildTableView(key, lstRecords, context));
        String teamName = key.substring(0, key.indexOf('-')).trim();
        teamSalarySummary
            .add(_TeamSalaryDetails(key, _totalSalary.toString(), teamName));
        _totalSalary = 0;
      });
    }

    teamSalarySummary.forEach((teamSalaryDetails) {
      if (_mapSummary[teamSalaryDetails.teamName] != null) {
        _mapSummary[teamSalaryDetails.teamName].add(teamSalaryDetails);
      } else {
        List<_TeamSalaryDetails> subList = [];
        subList.add(teamSalaryDetails);
        _mapSummary[teamSalaryDetails.teamName] = subList;
      }
    });
    dataTables.add(_summaryPage());
    return dataTables;
  }

  _summaryPage() {
    List<Text> lstTxt = [];
    _mapSummary.forEach((teamName, teamSalaryDetailsList) {
      lstTxt.add(Text(teamName,
          style: TextStyle(
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
          )));
      teamSalaryDetailsList.forEach((details) {
        lstTxt
            .add(Text(details.siteName + "    " + 'Rs.' + details.totalSalary));
      });
    });

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: lstTxt,
      ),
    );
  }

  _buildTableView(
      String key, List<DateReportField> lstRecords, BuildContext context) {

    lstRecords.forEach((dtreportFields){
      _totalSalary = _totalSalary +
          double.parse(dtreportFields.reportFields.pendingSalary);
    });
    salaryMap[key] = _totalSalary;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
        Row(
          children: <Widget>[
            Text(key),
            SizedBox(
              width: 20.0,
            ),
            Text('Pending Salary :' + 'Rs. '+salaryMap[key].toString())
          ],
        ),
        DataTable(

          columns: [
            DataColumn(label: Text('Date')),
            DataColumn(label: Text('Advance')),
            //DataColumn(label: Text('Labour')),
            ////DataColumn(label: Text('Mesthri')),
            //DataColumn(label: Text('Food')),
            //DataColumn(label: Text('OT')),
            //DataColumn(label: Text('Spray')),
            //DataColumn(label: Text('Other')),
            DataColumn(label: Text('Pending Salary')),
          ],
          rows: _generateDataCell(lstRecords, context),
        ),
      ]),
    );
  }

  _generateDataCell(List<DateReportField> lstRecords, BuildContext context) {
    List<DataRow> lstDataRow = [];
    lstRecords.forEach((dtreportFields) {
     lstDataRow.add(DataRow(cells: [
        DataCell(Text(dtreportFields.date,softWrap: true,)),
        DataCell(Text(dtreportFields.reportFields.advanceAmount,softWrap: true)),
        DataCell(Text(dtreportFields.reportFields.pendingSalary,softWrap: true),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return _DetailScreen(dtreportFields);
              }));
            }
                 ),
       // DataCell(Text(dtreportFields.reportFields.labourDetails,softWrap: true)),
        //DataCell(Text(dtreportFields.reportFields.mesthriShift,softWrap: true)),
        //DataCell(Text(dtreportFields.reportFields.foodDetails,softWrap: true)),
        //DataCell(Text(dtreportFields.reportFields.OtDetails,softWrap: true)),
       // DataCell(Text(dtreportFields.reportFields.sprayLabour,softWrap: true)),
        //DataCell(Text(dtreportFields.reportFields.otherAllowance,softWrap: true),),
      ], ));

    });

    return lstDataRow;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(
        title: Text('Salary reports'),
      ),
      body: PageView(
        children: _buildPageView(context),
        scrollDirection: Axis.vertical,
        pageSnapping: true,
      ),
    );
  }
}

class _TeamSalaryDetails {
  String siteName;
  String totalSalary;
  String teamName;
  _TeamSalaryDetails(this.siteName, this.totalSalary, this.teamName);
}

class _DetailScreen extends StatelessWidget{
  DateReportField _dtreportFields;
  _DetailScreen(this._dtreportFields);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(

      body: GestureDetector(
        child: Center(
          child: Column(
            children: <Widget>[
              Text('Labour Details     : '+ _dtreportFields.reportFields.labourDetails),
              SizedBox(height: 20,),
              Text('Mesthri Shift       : '+ _dtreportFields.reportFields.mesthriShift),
              SizedBox(height: 20,),
              Text('Food Details       : '+ _dtreportFields.reportFields.foodDetails),
              SizedBox(height: 20,),
              Text('Spray Details      : '+ _dtreportFields.reportFields.sprayLabour),
              SizedBox(height: 20,),
              Text('Other Details      : '+ _dtreportFields.reportFields.otherAllowance),
              SizedBox(height: 20,),
              Text('Allowance Details  : '+ _dtreportFields.reportFields.otherAllowanceReason),
              SizedBox(height: 20,),
              Text('Advance            : '+ 'Rs.'+_dtreportFields.reportFields.advanceAmount),
              SizedBox(height: 20,),
              Text('Advance            : '+ 'Rs.'+_dtreportFields.reportFields.pendingSalary),


            ],

          ),
        ),
      onTap: (){
        Navigator.pop(context);
      },
      ),
    );
  }
}
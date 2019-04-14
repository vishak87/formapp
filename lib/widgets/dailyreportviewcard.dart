import '../model/dailyreportformfields.dart';
import 'package:flutter/material.dart';
import 'package:form_app/editdailyreportform.dart';
import 'package:http/http.dart' as http;
class DailyReportFormFieldsCard extends StatelessWidget{

  DailyReportFormModel drprtfrmModel;
  Map<String,dynamic> teamDataFromDB;

  DailyReportFormFieldsCard(this.drprtfrmModel,this.teamDataFromDB);


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Container(
          margin: EdgeInsets.all(5.0),
          child: Card(
            color: Colors.teal[100],
            child: Column(
              children: <Widget>[
                Row(children: <Widget>[
                  Container(
                    child: IconButton(icon: Icon(Icons.edit), onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditDailyReportForm(drprtfrmModel,teamDataFromDB)),
                        );
                    }),

                    ),
                  SizedBox(
                    width: 250.00,
                  ),
                  Container(
                    child: IconButton(icon: Icon(Icons.delete), onPressed: ()async{
                      String str = drprtfrmModel.date.substring(0,drprtfrmModel.date.indexOf(' '));
                      String url = 'https://operationsreporting-584ec.firebaseio.com/dailyreports/'+str+'/'+drprtfrmModel.fbid+'.json';
                      print(url);
                      final _deleteResponse =
                      await http.delete(url);
                      if(_deleteResponse.statusCode==200){
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Status'),
                                content: Text('Data Deleted'),
                                actions: <Widget>[
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Ok'),
                                    )
                                ],
                                );
                            });
                      }

                    }),

                    )
                ],),Row(
                  children: <Widget>[Container(
                    child: Text(drprtfrmModel.date.substring(0,drprtfrmModel.date.indexOf(' '))),
                    margin: EdgeInsets.all(10.0),
                    padding: EdgeInsets.all(10.0),
                    decoration: new BoxDecoration(
                        color: Colors.red[700],
                        borderRadius: new BorderRadius.only(
                            topLeft:  const  Radius.circular(10.0),
                            topRight: const  Radius.circular(10.0),
                            bottomLeft: const Radius.circular(10.0),
                            bottomRight: const Radius.circular(10.0))
                        )

                    ,
                    ),
                  Container(
                      child: Text(drprtfrmModel.teamName+'-'+drprtfrmModel.projectName,style: TextStyle(
                          fontSize: 15,fontWeight: FontWeight.bold
                          ),),
                      margin: EdgeInsets.all(10.0),
                      padding: EdgeInsets.all(10.0),
                      decoration: new BoxDecoration(
                          color: Colors.lightBlueAccent[100],
                          borderRadius: new BorderRadius.only(
                              topLeft:  const  Radius.circular(10.0),
                              topRight: const  Radius.circular(10.0),
                              bottomLeft: const Radius.circular(10.0),
                              bottomRight: const Radius.circular(10.0))
                          )
                      )
                  ],
                  ),
                Row(children: <Widget>[Center(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Text('Labour Details :' +drprtfrmModel.labourDetails),Text('OT Details : '+drprtfrmModel.OtDetails), Text('Food Details : '+ drprtfrmModel.foodDetails),
                        Text('Other Allowance : '+ drprtfrmModel.otherAllowance),Text('Advance : '+ drprtfrmModel.advanceAmount),Text('Pending Salary : Rs.'+drprtfrmModel.pendingSalary)
                      ],
                    ),
                    margin: EdgeInsets.all(40.0),
                    padding: EdgeInsets.all(10.0),
                    decoration: new BoxDecoration(
                        color: Colors.lightBlueAccent[100],
                        borderRadius: new BorderRadius.only(
                            topLeft:  const  Radius.circular(10.0),
                            topRight: const  Radius.circular(10.0),
                            bottomLeft: const Radius.circular(10.0),
                            bottomRight: const Radius.circular(10.0))
                        ),

                  ),
                )
                ])],
              ),
            )
          ),
      );

  }
}
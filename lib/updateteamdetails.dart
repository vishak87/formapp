import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './model/teamdetails.dart';
import 'labourreport.dart';



class UpdateTeamDetails extends StatefulWidget{

  final TeamData teamData;
  UpdateTeamDetails(this.teamData);
  @override
  State<StatefulWidget> createState() {
    return _UpdateTeamDState(teamData);
  }



}

class _UpdateTeamDState extends State<UpdateTeamDetails>{

   TeamData _teamData;
  _UpdateTeamDState(this._teamData);



  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String,dynamic> _formData = {
    'teamName': null,
    'baseSalary': null,
    'mesthriAllowance': null,
    'foodAllowance': null,
    'sprayAllowance': null,
    'otAllowance':null

  };

  Widget _buildTeamNameField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Team Name', filled: true, fillColor: Colors.white),
      obscureText: false,
      initialValue: _teamData.teamName,
      keyboardType: TextInputType.text,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Team Name cannot be empty';
        }
      },
      onSaved: (String value) {
        _formData['teamName'] = value;
      },
    );
  }

  Widget _buildBaseSalaryField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Base Salary of Team', filled: true, fillColor: Colors.white,),
      obscureText: false,
      initialValue: _teamData.baseSalary,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      validator: (String value) {
        if (value.isEmpty || !validateNumber(value)) {
          return 'Base salary cannot be empty and should be a number';
        }
      },
      onSaved: (String value) {
        _formData['baseSalary'] = value;
      },
    );
  }

  Widget _buildMesthriAllowanceField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Mesthri Allowance', filled: true, fillColor: Colors.white),
      obscureText: false,
      initialValue: _teamData.mesthriAllowance,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      validator: (String value) {
        if (value.isEmpty || !validateNumber(value)) {
          return 'Mesthri Allowance cannot be empty and should be a number';
        }
      },
      onSaved: (String value) {
        _formData['mesthriAllowance'] = value;
      },
    );
  }

  Widget _buildFoodAllowanceField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Food Allowance for Session', filled: true, fillColor: Colors.white),
      obscureText: false,
      initialValue: _teamData.foodAllowance,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      validator: (String value) {
        if (value.isEmpty || !validateNumber(value)) {
          return 'Food allowance should be a number and can\'t be empty';
        }
      },
      onSaved: (String value) {
        _formData['foodAllowance'] = value;
      },
    );
  }

  Widget _buildSprayAllowanceField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Spray Allowance', filled: true, fillColor: Colors.white),
      obscureText: false,
      initialValue: _teamData.sprayAllowance,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      validator: (String value){
        if (value.isEmpty || !validateNumber(value)) {
          return 'Spray allowance can\'t be empty and should be a number';
        }
      },
      onSaved: (String value) {
        _formData['sprayAllowance'] = value;
      },
    );
  }

  Widget _buildOTAllowanceField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'OT Allowance per hour', filled: true, fillColor: Colors.white),
      obscureText: false,
      initialValue: _teamData.otAllowance,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      validator: (String value) {
        if (value.isEmpty || !validateNumber(value) ) {
          return 'OT can\'t be empty and should be a number';
        }
      },
      onSaved: (String value) {
        _formData['otAllowance'] = value;
      },
    );
  }

  bool validateNumber(String val){

    if(RegExp(r"(\d{1,5}|\d{0,5}\.\d{1,2})").hasMatch(val)){
      return true;
    }
    else{
      return false;
    }

  }



  @override
  Widget build(BuildContext context) {
    // Use only portrait mode for Login Page.
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
        appBar: AppBar(title: Text('Create New Team'),),
        body: Container(
          child: SingleChildScrollView(
              child:Container(
                margin: EdgeInsets.all(10.0),
                child: Form(
                    key: _formKey,
                    child: Column(

                      children: <Widget>[

                        SizedBox(
                          height: 4.0,
                        )
                        ,

                        _buildTeamNameField(),


                        SizedBox(
                          height: 4.0,
                        ),
                        _buildBaseSalaryField(),

                        SizedBox(
                          height: 4.0,
                        ),

                        _buildMesthriAllowanceField(),

                        SizedBox(
                          height: 4.0,
                        ),

                        _buildFoodAllowanceField(),

                        SizedBox(
                          height: 4.0,
                        ),

                        _buildSprayAllowanceField(),

                        SizedBox(
                          height: 4.0,
                        ),

                        _buildOTAllowanceField(),

                        SizedBox(
                          height: 10.0,
                        ),

                        RaisedButton(
                            color: Colors.amber,
                            textColor: Colors.black,
                            child: Text('Submit'),
                            onPressed: ()async{

                              if (_formKey.currentState.validate() ) {

                                _formKey.currentState.save();
                                print(_formData);
                                final http.Response response = await http.patch(
                                    'https://operationsreporting-584ec.firebaseio.com/TeamDetails/'+_teamData.fireBaseId+'.json',
                                    body: json.encode(_formData),
                                    headers: {'Content-Type': 'application/json'});
                                print(response.statusCode);
                                if(response.statusCode==200){
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Success'),
                                          content: Text('The details have been submitted!'),
                                          actions: <Widget>[
                                            FlatButton(
                                              onPressed: () {
                                                Navigator
                                                    .push(
                                                    context,
                                                    new MaterialPageRoute(builder: (context) => LabourReport()
                                                    )
                                                );
                                              },
                                              child: Text('Ok'),
                                            )
                                          ],
                                        );
                                      });


                                }
                                else{

                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Something went wrong'),
                                          content: Text('Please try again!'),
                                          actions: <Widget>[
                                            FlatButton(
                                              onPressed: (){
                                                Navigator
                                                    .push(
                                                    context,
                                                    new MaterialPageRoute(builder: (context) => LabourReport()
                                                    )
                                                );
                                              },
                                              child: Text('Ok'),
                                            )
                                          ],
                                        );
                                      });
                                }

                              }

                            }

                        ),

                      ],

                    )),
              )
          ),

        )
    );
  }


}


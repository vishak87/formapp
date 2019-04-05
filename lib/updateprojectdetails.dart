import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './model/projectdetails.dart';
import 'labourreport.dart';


class UpdateProjectDetails extends StatefulWidget{

  final ProjectData projectData;
  UpdateProjectDetails(this.projectData);
  @override
  State<StatefulWidget> createState() {
    return _UpdateProjectState(projectData);
  }



}

class _UpdateProjectState extends State<UpdateProjectDetails>{

  final ProjectData projectData;
  _UpdateProjectState(this.projectData);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String,dynamic> _formData = {
    'projectName' : null,
    'projectAddress': null

  };

  Widget _buildProjectNameField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Project Name', filled: true, fillColor: Colors.white),
      obscureText: false,
      keyboardType: TextInputType.text,
      initialValue: projectData.projectName,

      validator: (String value) {
        if (value.isEmpty) {
          return 'Project Name cannot be empty';
        }
      },
      onSaved: (String value) {
        _formData['projectName'] = value;
      },
    );
  }

  Widget _buildAddressField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Address', filled: true, fillColor: Colors.white,),
      obscureText: false,
      initialValue: projectData.projectAddress,
      keyboardType: TextInputType.multiline,
      maxLines: null,

      validator: (String value) {
        if (value.isEmpty) {
          return 'Address should not be empty';
        }
      },
      onSaved: (String value) {
        _formData['projectAddress'] = value;
      },
    );
  }






  @override
  Widget build(BuildContext context) {
    // Use only portrait mode for Login Page.
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
        appBar: AppBar(title: Text('Create New Project'),),
        body: Center(
          child: Container(
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

                          _buildProjectNameField(),


                          SizedBox(
                            height: 4.0,
                          ),
                          _buildAddressField(),


                          RaisedButton(
                              color: Colors.amber,
                              textColor: Colors.black,
                              child: Text('Submit'),
                              onPressed: ()async{

                                if (_formKey.currentState.validate() ) {

                                  _formKey.currentState.save();
                                  print(_formData);
                                  final http.Response response = await http.patch(
                                      'https://operationsreporting-584ec.firebaseio.com/ProjectDetails/'+projectData.fireBaseId+'.json',
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

          ),
        )
    );
  }


}


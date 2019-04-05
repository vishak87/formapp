import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class CreateProject extends StatefulWidget{


  @override
  State<StatefulWidget> createState() {
    return _CreateProjectState();
  }



}

class _CreateProjectState extends State<CreateProject>{

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
                                  final http.Response response = await http.post(
                                      'https://operationsreporting-584ec.firebaseio.com/ProjectDetails.json',
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
                                                  Navigator.of(context).pop();
                                                  _formKey.currentState.reset();
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
                                                onPressed: () => Navigator.of(context).pop(),
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


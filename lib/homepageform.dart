import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';




class HomePageForm extends StatefulWidget{


  final List<String> teamName;
  final List<String> projectName;



  HomePageForm(this.teamName,this.projectName);



  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomePageState(teamName,projectName);
  }

}


class _HomePageState extends State<HomePageForm>{

  List<String> teamName;
  List<String> projectName;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String teamNameDropdownValue;
  String projectNameDropdownValue;
  DateTime date;
  List<Widget> listFormFields=[];
  int listRowCount=0;

  final formats = {
    InputType.date: DateFormat('dd-MM-yyyy'),
  };


  _HomePageState(this.teamName,this.projectName);


  String dateValue = '';


   _buildTeamNameDropDown(List<String> teamName) {
    List<DropdownMenuItem<String>> teamNameMenu = [];


    teamName.forEach((String val) {
      teamNameMenu.add(new DropdownMenuItem(
        child: Text(val),
        value: val,
      ));
    });

    listFormFields.add(DropdownButtonFormField(

      items: teamNameMenu,
      value: teamNameDropdownValue,

      hint: Text('Team Name'),
      onChanged: (value) {
        setState(() {
          print('The value selected is ' + value);
          teamNameDropdownValue=value;
          teamName=teamName;
          projectName=projectName;
          projectNameDropdownValue=projectNameDropdownValue;
          date=date;
          //listFormFields=listFormFields;

        });
      },
      ));

    _addSizedBox();
     
  }


   _buildProjectNameDropDown(List<String> projectName) {
    List<DropdownMenuItem<String>> projectNameMenu = [];


    projectName.forEach((String val) {
      projectNameMenu.add(new DropdownMenuItem(
        child: Text(val),
        value: val,
      ));
    });

    listFormFields.add(DropdownButtonFormField(
      decoration: InputDecoration(

      ),
      items: projectNameMenu,
      value: projectNameDropdownValue,


      hint: Text('Project Name'),
      onChanged: (value) {
        setState(() {
          print('The value selected is ' + value);
          teamNameDropdownValue=teamNameDropdownValue;
          teamName=teamName;
          projectName=projectName;
          projectNameDropdownValue=value;
          date=date;
          //listFormFields=listFormFields;



        });
      },
      ) )
     ;
    _addSizedBox();
  }

   _buildDateField(){
    InputType inputType = InputType.date;
    listFormFields.add(DateTimePickerFormField(
      decoration: InputDecoration(
      labelText: 'Date', hasFloatingPlaceholder: false),
      dateOnly: true,
      inputType: inputType,
      format: formats[inputType],
      editable: false,
      onChanged: (dt) => setState((){

        date=dt;
        teamNameDropdownValue=teamNameDropdownValue;
        teamName=teamName;
        projectName=projectName;
        projectNameDropdownValue=projectNameDropdownValue;



      }),

      ));
    _addSizedBox();
  }


  Widget _buildAdvanceField() {
    listFormFields.add(
        TextFormField(
          decoration: InputDecoration(
              labelText: 'Advance Amount', filled: true, fillColor: Colors.white),
          obscureText: false,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          validator: (String value) {
            if (value.isEmpty || !validateNumber(value) ) {
              return 'Advance can\'t be empty and should be a number';
            }
          },
          onSaved: (String value) {


          },
          )
    );
    _addSizedBox();
  }

  bool validateNumber(String val){

    if(RegExp(r"(\d{1,5}|\d{0,5}\.\d{1,2})").hasMatch(val)){
      return true;
    }
    else{
      return false;
    }

  }



  _buildLabourRow(){
   listFormFields.add(RaisedButton(
     child: Text('Add Labour Details'),
     onPressed: (){

       listFormFields.add(TextFormField(
         decoration: InputDecoration(
             labelText: 'Workers', filled: true, fillColor: Colors.white),
         obscureText: false,
         keyboardType: TextInputType.numberWithOptions(decimal: true),
         validator: (String value) {
           if (value.isEmpty || !validateNumber(value) ) {
             return 'Worker Details can\'t be empty and should be a number';
           }
         },
         onSaved: (String value) {

         },
         ));

       _addSizedBox();

       listFormFields.add(TextFormField(
         decoration: InputDecoration(
             labelText: 'Shift', filled: true, fillColor: Colors.white),
         obscureText: false,
         keyboardType: TextInputType.numberWithOptions(decimal: true),
         validator: (String value) {
           if (value.isEmpty || !validateNumber(value)  ) {
             return 'Shift can\'t be empty and should be a number';
           }
         },
         onSaved: (String value) {

         },
         ));

       _addSizedBox();

       setState(() {

         date=date;
         teamNameDropdownValue=teamNameDropdownValue;
         teamName=teamName;
         projectName=projectName;
         projectNameDropdownValue=projectNameDropdownValue;
         listFormFields=listFormFields;

       });
     },

     ));
     
 }

  Widget _buildLabourReportFieldList(){

    print('listLabourShiftRow length :' +listFormFields.length.toString());

    return ListView.builder(itemBuilder: (BuildContext context,int index){

      return listFormFields[index];},
                              itemCount: listFormFields.length,

                            );


  }
    _addSizedBox(){
     listFormFields.add(
         SizedBox(
           height: 5.0,
           )
     );
    }
  @override
  Widget build(BuildContext context) {

     if(listFormFields.isEmpty){

       _buildTeamNameDropDown(teamName);_buildProjectNameDropDown(projectName);
       _buildDateField(); _buildAdvanceField(); _buildLabourRow();

     }

    
    return Form(
      child: Expanded(child: _buildLabourReportFieldList(),

                      ),

                key: _formKey,    
                );

}

}
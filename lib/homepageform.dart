import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePageForm extends StatefulWidget {
  final List<String> teamName;
  final List<String> projectName;
  final Map<String, dynamic> teamDataFromDB;

  HomePageForm(this.teamName, this.projectName, this.teamDataFromDB);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomePageState(teamName, projectName, teamDataFromDB);
  }
}

class _HomePageState extends State<HomePageForm> {
  Map<String, Map<String, String>> teamDataFromDB;
  List<String> teamName;
  List<String> projectName;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String teamNameDropdownValue;
  String projectNameDropdownValue;
  DateTime date;
  List<Widget> listFormFields = [];
  int listRowCount = 0;

  Map<String, dynamic> _formdata = {
    'teamName': '',
    'projectName': '',
    'date': '',
    'advanceAmount': '',
    'otherAllowance': '',
    'otherAllowanceReason': '',
    'pendingSalary': '',
    'labourRow1': '',
    'labourRow2': '',
    'labourRow3': '',
    'labourShiftRow1': '',
    'labourShiftRow2': '',
    'labourShiftRow3': '',
    'workerFoodRow1': '',
    'workerFoodRow2': '',
    'workerFoodRow3': '',
    'foodAmountRow1': '',
    'foodAmountRow2': '',
    'foodAmountRow3': '',
    'workerOTRow1': '',
    'workerOTRow2': '',
    'workerOTRow3': '',
    'shiftOTRow1': '',
    'shiftOTRow2': '',
    'shiftOTRow3': '',
    'labourDetails': '',
    'OtDetails': '',
    'foodDetails': '',
    'mesthriShift': '',
    'sprayLabour': '',
  };

  final formats = {
    InputType.date: DateFormat('dd-MM-yyyy'),
  };

  _HomePageState(this.teamName, this.projectName, this.teamDataFromDB);

  String dateValue = '';

  _buildTeamNameDropDown(List<String> teamName) {
    List<DropdownMenuItem<String>> teamNameMenu = [];

    teamName.forEach((String val) {
      teamNameMenu.add(new DropdownMenuItem(
        child: Text(val),
        value: val,
        ));
    });

    return DropdownButtonFormField(
      items: teamNameMenu,
      value: teamNameDropdownValue,
      hint: Text('Team Name'),
      onChanged: (value) {
        setState(() {
          print('The value selected is ' + value);
          teamNameDropdownValue = value;
          teamName = teamName;
          projectName = projectName;
          projectNameDropdownValue = projectNameDropdownValue;
          date = date;
          _formdata['teamName'] = value;
          _formdata = _formdata;
        });
      },
      );
  }

  _buildProjectNameDropDown(List<String> projectName) {
    List<DropdownMenuItem<String>> projectNameMenu = [];

    projectName.forEach((String val) {
      projectNameMenu.add(new DropdownMenuItem(
        child: Text(val),
        value: val,
        ));
    });

    return DropdownButtonFormField(
      decoration: InputDecoration(),
      items: projectNameMenu,
      value: projectNameDropdownValue,
      hint: Text('Project Name'),
      onChanged: (value) {
        setState(() {
          print('The value selected is ' + value);
          teamNameDropdownValue = teamNameDropdownValue;
          teamName = teamName;
          projectName = projectName;
          projectNameDropdownValue = value;
          date = date;
          _formdata['projectName'] = value;
          _formdata = _formdata;
        });
      },
      );
  }

  _buildDateField() {
    InputType inputType = InputType.date;
    return DateTimePickerFormField(
      decoration:
      InputDecoration(labelText: 'Date', hasFloatingPlaceholder: false),
      dateOnly: true,
      inputType: inputType,
      format: formats[inputType],
      editable: false,
      onChanged: (dt) => setState(() {
        date = dt;
        teamNameDropdownValue = teamNameDropdownValue;
        teamName = teamName;
        projectName = projectName;
        projectNameDropdownValue = projectNameDropdownValue;
        _formdata['date'] = dt.toString();
        _formdata = _formdata;
      }),
      );
  }

  Widget _buildAdvanceField() {
    return TextFormField(
      initialValue: '0',
      decoration: InputDecoration(
          labelText: 'Advance Amount', filled: true, fillColor: Colors.white),
      obscureText: false,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      validator: (String value) {
        if (value.isEmpty || !validateNumber(value)) {
          return 'Advance can\'t be empty and should be a number';
        }
      },
      onSaved: (String value) {
        _formdata['advanceAmount'] = value;
      },
      );
  }

  Widget _buildOtherAllowance() {
    return TextFormField(
      initialValue: '0',
      decoration: InputDecoration(
          labelText: 'Other Allowance in Rs.',
          filled: true,
          fillColor: Colors.white),
      obscureText: false,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      validator: (String value) {
        if (!validateNumber(value)) {
          return 'Should be a number';
        }
      },
      onSaved: (String value) {
        _formdata['otherAllowance'] = value;
      },
      );
  }

  Widget _buildOtherAllowanceDesc() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Reason for allowance.',
          filled: true,
          fillColor: Colors.white),
      obscureText: false,
      keyboardType: TextInputType.multiline,
      onSaved: (String value) {
        _formdata['otherAllowanceReason'] = value;
      },
      );
  }

  Widget _buildLabourShitRow(String workerKey, String shiftKey) {
    return Row(
      children: <Widget>[
        Flexible(
          child: TextFormField(
            initialValue: '0',
            decoration: InputDecoration(
                labelText: 'No. Of Workers',
                filled: true,
                fillColor: Colors.white),
            obscureText: false,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Can\'t be empty';
              } else if (!validateNumber(value) || double.parse(value) > 20) {
                return 'Should be a less than 20';
              }
            },
            onSaved: (String value) {
              _formdata[workerKey] = value;
            },
            ),
          ),
        Flexible(
          child: TextFormField(
            initialValue: '0',
            decoration: InputDecoration(
                labelText: 'Shift', filled: true, fillColor: Colors.white),
            obscureText: false,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Can\'t be empty';
              } else if (!validateNumber(value) || double.parse(value) > 3) {
                return 'Enter num <3';
              }
            },
            onSaved: (String value) {
              _formdata[shiftKey] = value;
            },
            ),
          )
      ],
      );
  }

  Widget _buildMesthriAllowance() {
    return TextFormField(
      initialValue: '0',
      decoration: InputDecoration(
          labelText: 'Mesthri Shift', filled: true, fillColor: Colors.white),
      obscureText: false,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Can\'t be empty';
        } else if (!validateNumber(value) || double.parse(value) > 3) {
          return 'Enter num <3';
        }
      },
      onSaved: (String value) {
        _formdata['mesthriShift'] = value;
      },
      );
  }

  Widget _buildSparyAllowance() {
    return TextFormField(
      initialValue: '0',
      decoration: InputDecoration(
          labelText: 'No.Of Spray Labours',
          filled: true,
          fillColor: Colors.white),
      obscureText: false,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      validator: (String value) {
        if (!validateNumber(value)) {
          return 'Should be a number';
        }
      },
      onSaved: (String value) {
        _formdata['sprayLabour'] = value;
      },
      );
  }

  Widget _buildOTRow(String workerKey, String shiftKey) {
    return Row(
      children: <Widget>[
        Flexible(
          child: TextFormField(
            initialValue: '0',
            decoration: InputDecoration(
                labelText: 'No. Of Workers',
                filled: true,
                fillColor: Colors.white),
            obscureText: false,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            validator: (String value) {
              if (!validateNumber(value) || double.parse(value) > 20) {
                return 'Enter num < 20';
              }
            },
            onSaved: (String value) {
              _formdata[workerKey] = value;
            },
            ),
          ),
        Flexible(
          child: TextFormField(
            initialValue: '0',
            decoration: InputDecoration(
                labelText: 'OT in hrs', filled: true, fillColor: Colors.white),
            obscureText: false,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            validator: (String value) {
              if (!validateNumber(value) || double.parse(value) > 3) {
                return 'Enter num < 4';
              }
            },
            onSaved: (String value) {
              _formdata[shiftKey] = value;
            },
            ),
          )
      ],
      );
  }

  Widget _buildLabourFoodRow(String workerKey, String amount) {
    return Row(
      children: <Widget>[
        Flexible(
          child: TextFormField(
            initialValue: '0',
            decoration: InputDecoration(
                labelText: 'No. Of Workers',
                filled: true,
                fillColor: Colors.white),
            obscureText: false,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            validator: (String value) {
              if (!validateNumber(value) || double.parse(value) > 20) {
                return 'Enter num < 20';
              }
            },
            onSaved: (String value) {
              _formdata[workerKey] = value;
            },
            ),
          ),
        Flexible(
          child: TextFormField(
            initialValue: '0',
            decoration: InputDecoration(
                labelText: 'Food allownace in Rs.',
                filled: true,
                fillColor: Colors.white),
            obscureText: false,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            validator: (String value) {
              if (!validateNumber(value) || double.parse(value) > 150) {
                return 'Enter num < 150';
              }
            },
            onSaved: (String value) {
              _formdata[amount] = value;
            },
            ),
          )
      ],
      );
  }

  bool validateNumber(String val) {
    if (RegExp(r"(\d{1,5}|\d{0,5}\.\d{1,2})").hasMatch(val)) {
      return true;
    } else {
      return false;
    }
  }

  constructLabourDetailsText() {
    String row1 = '';
    String row2 = '';
    String row3 = '';

    if (double.parse(_formdata['labourRow1']) *
        double.parse(_formdata['labourShiftRow1']) !=
        0.0) {
      row1 = _formdata['labourRow1'] +
          ' Labours *' +
          _formdata['labourShiftRow1'] +
          ' Shift' +
          " ";
    }
    if (double.parse(_formdata['labourRow2']) *
        double.parse(_formdata['labourShiftRow2']) !=
        0) {
      row2 = _formdata['labourRow2'] +
          ' Labours *' +
          _formdata['labourShiftRow2'] +
          ' Shift' +
          ' ';
    }
    if (double.parse(_formdata['labourRow3']) *
        double.parse(_formdata['labourShiftRow3']) !=
        0) {
      row3 = _formdata['labourRow3'] +
          ' Labours *' +
          _formdata['labourShiftRow3'] +
          ' Shift';
    }

    _formdata['labourDetails'] = row1 + ' ' + row2 + ' ' + row3;
    _formdata['labourDetails'] = _formdata['labourDetails'].toString().trim();
  }

  constructFoodDetailsText() {
    String row1 = '';
    String row2 = '';
    String row3 = '';
    /*
    * 'workerFoodRow3':'',
    'foodAmountRow1':'',*/

    if (double.parse(_formdata['workerFoodRow1']) *
        double.parse(_formdata['foodAmountRow1']) !=
        0.0) {
      row1 = _formdata['workerFoodRow1'] +
          ' Labours *' +
          'Rs.' +
          _formdata['foodAmountRow1'] +
          " ";
    }
    if (double.parse(_formdata['workerFoodRow2']) *
        double.parse(_formdata['foodAmountRow2']) !=
        0.0) {
      row2 = _formdata['workerFoodRow2'] +
          ' Labours *' +
          'Rs.' +
          _formdata['foodAmountRow2'] +
          " ";
    }
    if (double.parse(_formdata['workerFoodRow3']) *
        double.parse(_formdata['foodAmountRow3']) !=
        0.0) {
      row3 = _formdata['workerFoodRow3'] +
          ' Labours *' +
          'Rs.' +
          _formdata['foodAmountRow3'] +
          " ";
    }

    _formdata['foodDetails'] = row1 + ' ' + row2 + ' ' + row3;
    _formdata['foodDetails'] = _formdata['foodDetails'].toString().trim();
    if (_formdata['foodDetails'].toString().isEmpty) {
      _formdata['foodDetails'] = 'NA';
    }
  }

  constructOTDetailsText() {
    String row1 = '';
    String row2 = '';
    String row3 = '';

    /*
    * 'workerOTRow3':'',
    'shiftOTRow1':'',
    */
    if (double.parse(_formdata['workerOTRow1']) *
        double.parse(_formdata['shiftOTRow1']) !=
        0.0) {
      row1 = _formdata['workerOTRow1'] +
          ' Labours *' +
          _formdata['shiftOTRow1'] +
          "hrs ";
    }
    if (double.parse(_formdata['workerOTRow2']) *
        double.parse(_formdata['shiftOTRow2']) !=
        0.0) {
      row2 = _formdata['workerOTRow2'] +
          ' Labours *' +
          _formdata['shiftOTRow2'] +
          "hrs ";
    }
    if (double.parse(_formdata['workerOTRow3']) *
        double.parse(_formdata['shiftOTRow3']) !=
        0.0) {
      row3 = _formdata['workerOTRow3'] +
          ' Labours *' +
          _formdata['shiftOTRow3'] +
          "hrs";
    }

    _formdata['OtDetails'] = row1 + ' ' + row2 + ' ' + row3;
    _formdata['OtDetails'] = _formdata['OtDetails'].toString().trim();
    if (_formdata['OtDetails'].toString().isEmpty) {
      _formdata['OtDetails'] = 'NA';
    }
  }

  calculatePendingSalary() {
    print(teamDataFromDB);
    Map<String, String> teamdetails = teamDataFromDB[teamNameDropdownValue];
    print(teamdetails);
    String mesthriSalary = teamdetails['mesthriAllowance'];
    String baseSalary = teamdetails['baseSalary'];
    String sprayAllowance = teamdetails['sprayAllowance'];
    String otAllowance = teamdetails['otAllowance'];
    double foodAllowance = 0.0;

    double spray = 0.0;
    double otamount = 0.0;

    double labourSalary = (double.parse(_formdata['labourRow1']) *
        double.parse(_formdata['labourShiftRow1']) +
        double.parse(_formdata['labourRow2']) *
            double.parse(_formdata['labourShiftRow2']) +
        double.parse(_formdata['labourRow3']) *
            double.parse(_formdata['labourShiftRow3'])) *
        double.parse(baseSalary);

    foodAllowance = (double.parse(_formdata['workerFoodRow1']) *
        double.parse(_formdata['foodAmountRow1']) +
        double.parse(_formdata['workerFoodRow2']) *
            double.parse(_formdata['foodAmountRow2']) +
        double.parse(_formdata['workerFoodRow2']) *
            double.parse(_formdata['foodAmountRow3']));

    print('ot 1: ' +
              (double.parse(_formdata['workerOTRow1']) *
                  double.parse(_formdata['shiftOTRow1']))
                  .toString());
    print('ot 2: ' +
              (double.parse(_formdata['workerOTRow2']) *
                  double.parse(_formdata['shiftOTRow2']))
                  .toString());
    print('ot 3: ' +
              (double.parse(_formdata['workerOTRow3']) *
                  double.parse(_formdata['shiftOTRow3']))
                  .toString());
    print('otallowance :' + otAllowance);
    otamount = ((double.parse(_formdata['workerOTRow1']) *
        double.parse(_formdata['shiftOTRow1'])) +
        (double.parse(_formdata['workerOTRow2']) *
            double.parse(_formdata['shiftOTRow2'])) +
        (double.parse(_formdata['workerOTRow3']) *
            double.parse(_formdata['shiftOTRow3']))) *
        double.parse(otAllowance);

    double mesthriExtra =
        double.parse(_formdata['mesthriShift']) * double.parse(mesthriSalary);

    spray =
        double.parse(_formdata['sprayLabour']) * double.parse(sprayAllowance);

    double pendingSalary = labourSalary +
        double.parse(_formdata['otherAllowance']) +
        foodAllowance +
        spray +
        otamount +
        mesthriExtra -
        double.parse(_formdata['advanceAmount']);

    _formdata['pendingSalary'] = pendingSalary.toString();

    print('labourSalary :' + labourSalary.toString());
    print('otherallowance: ' + _formdata['otherAllowance']);
    print('food :' + foodAllowance.toString());
    print('spray:' + spray.toString());
    print('ot :' + otamount.toString());
    print('mesthri :' + mesthriExtra.toString());

    print('Pending Salary :' + _formdata['pendingSalary']);

    print('Pending Salary :' + _formdata['pendingSalary']);
    print('Labour details :' + _formdata['labourDetails']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Daily labour Report'),),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _buildTeamNameDropDown(teamName),
              SizedBox(
                height: 4.0,
                ),
              _buildProjectNameDropDown(projectName),
              SizedBox(
                height: 4.0,
                ),
              _buildDateField(),
              SizedBox(
                height: 20.0,
                ),
              Center(
                child: Text('Please Enter Labour Details'),
                ),
              SizedBox(
                height: 20.0,
                ),
              _buildLabourShitRow('labourRow1', 'labourShiftRow1'),
              SizedBox(
                height: 4.0,
                ),
              _buildLabourShitRow('labourRow2', 'labourShiftRow2'),
              SizedBox(
                height: 4.0,
                ),
              _buildLabourShitRow('labourRow3', 'labourShiftRow3'),
              SizedBox(
                height: 4.0,
                ),
              _buildMesthriAllowance(),
              SizedBox(
                height: 4.0,
                ),
              _buildSparyAllowance(),
              SizedBox(
                height: 4.0,
                ),
              _buildAdvanceField(),
              SizedBox(
                height: 20.0,
                ),
              Center(
                child: Text('Enter Allowance Details'),
                ),
              SizedBox(
                height: 20.0,
                ),
              _buildLabourFoodRow('workerFoodRow1', 'foodAmountRow1'),
              SizedBox(
                height: 4.0,
                ),
              _buildLabourFoodRow('workerFoodRow2', 'foodAmountRow2'),
              SizedBox(
                height: 4.0,
                ),
              _buildLabourFoodRow('workerFoodRow3', 'foodAmountRow3'),
              SizedBox(
                height: 4.0,
                ),
              _buildOtherAllowance(),
              SizedBox(
                height: 4.0,
                ),
              _buildOtherAllowanceDesc(),
              SizedBox(
                height: 20.0,
                ),
              Center(
                child: Text('Enter OT Details'),
                ),
              _buildOTRow('workerOTRow1', 'shiftOTRow1'),
              SizedBox(
                height: 4.0,
                ),
              _buildOTRow('workerOTRow2', 'shiftOTRow2'),
              SizedBox(
                height: 4.0,
                ),
              _buildOTRow('workerOTRow3', 'shiftOTRow3'),
              SizedBox(
                height: 20.0,
                ),
              RaisedButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    LinearProgressIndicator();
                    String msg = 'The details have been submitted!';
                    _formKey.currentState.save();
                    calculatePendingSalary();
                    constructFoodDetailsText();
                    constructLabourDetailsText();
                    constructOTDetailsText();
                    print(_formdata);
                    String dateStr = _formdata['date'].toString();
                    print('The date string is :' + dateStr);
                    dateStr = dateStr.substring(0, dateStr.indexOf(' '));
                    dateStr = dateStr.trim();
                    print('The date string is :' + dateStr);
                    String _projectName = _formdata['projectName'].toString();
                    _projectName = _projectName.replaceAll(' ', '');
                    http.Response response = await http.post(
                        'https://operationsreporting-584ec.firebaseio.com/dailyreports/' +
                            dateStr +
                            '.json',
                        body: json.encode(_formdata),
                        headers: {'Content-Type': 'application/json'});

                    if (response.statusCode == 200) {
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
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Status'),
                              content: Text('Submission Failed' +
                                                response.statusCode.toString()),
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
                  }
                },
                child: Text('Submit'),
                )
            ],
            ),
          ),
        ),
      );
  }
}

/*
* http.Response putResponse = http.post(
                            'https://operationsreporting-584ec.firebaseio.com/' +
                                _formdata['date'].toString() +
                                '/' +
                                _formdata['teamName'] +
                                '-' +
                                _projectName+
                                '.json',
                            body: json.encode(_formdata),
                            headers: {'Content-Type': 'application/json'}).then((putResponse){

                        });

*/

/*
* */

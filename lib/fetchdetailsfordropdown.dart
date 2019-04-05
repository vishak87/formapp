import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './model/teamdetails.dart';
import './model/projectdetails.dart';
import 'mainreportpage.dart';
import 'dart:collection';

Future<_TeamProjectDetailsResponse> fetchTeamProjectDetails() async {
  final _teamDetailsResponse = await http
      .get('https://operationsreporting-584ec.firebaseio.com/TeamDetails.json');

  final _projectDetailsResponse = await http.get(
      'https://operationsreporting-584ec.firebaseio.com/ProjectDetails.json');

  if (_teamDetailsResponse.statusCode == 200 &&
      _projectDetailsResponse.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    return _TeamProjectDetailsResponse(json.decode(_teamDetailsResponse.body),
        json.decode(_projectDetailsResponse.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class FetchDetails extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _FetchDetailsState();
  }
}

class _FetchDetailsState extends State<FetchDetails> {
  List<String> teamName = [];
  List<String> projectName = [];
  Map<String,Map<String,String>>
  teamDetailsMap={

  };
  Future<_TeamProjectDetailsResponse> _teamprojectresponseData;


  _FetchDetailsState() {
    _teamprojectresponseData = fetchTeamProjectDetails();
  }

  Map<String, dynamic> _teamDataMap;
  Map<String, dynamic> _projectDataMap;



  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return FutureBuilder(
        future: _teamprojectresponseData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _teamDataMap = snapshot.data.teamDataJson;
            _projectDataMap = snapshot.data.projectDataJson;
            _teamDataMap.forEach((String fbId, dynamic teamDataFromDB) {
              final TeamData teamData = TeamData(
                fireBaseId: fbId,
                teamName: teamDataFromDB['teamName'],
                baseSalary: teamDataFromDB['baseSalary'],
                mesthriAllowance: teamDataFromDB['mesthriAllowance'],
                foodAllowance: teamDataFromDB['foodAllowance'],
                otAllowance: teamDataFromDB['otAllowance'],
                sprayAllowance: teamDataFromDB['sprayAllowance'],
                );
              teamName.add(teamData.teamName);
             Map<String,String>  teamDetailsForSalary={
              'teamName':teamData.teamName,
              'baseSalary':teamData.baseSalary,
              'mesthriAllowance':teamData.mesthriAllowance,
              'foodAllowance':teamData.foodAllowance,
              'otAllowance': teamData.otAllowance,
              'sprayAllowance':teamData.sprayAllowance,
              };
              teamDetailsMap.putIfAbsent(teamDataFromDB['teamName'],()=>teamDetailsForSalary);

            });

            _projectDataMap.forEach((String fbId, dynamic projectDataFromDB) {
              final ProjectData projectData = ProjectData(
                fireBaseId: fbId,
                projectName: projectDataFromDB['projectName'],
                projectAddress: projectDataFromDB['projectAddress'],
                );

              projectName.add(projectData.projectName);
            });

            return HomePageForm(teamName,projectName,teamDetailsMap);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner
          return Center(child: CircularProgressIndicator() ,
                        );
        });
  }
}

class _TeamProjectDetailsResponse {
  final Map<String, dynamic> teamDataJson;
  final Map<String, dynamic> projectDataJson;

  _TeamProjectDetailsResponse(this.teamDataJson, this.projectDataJson);
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './model/teamdetails.dart';
import './widgets/teamdetailswidget.dart';

Future<_TeamDetailsResponse> fetchPost() async {
  final response =
  await http.get('https://operationsreporting-584ec.firebaseio.com/TeamDetails.json');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    return _TeamDetailsResponse(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}



class TeamDetails extends StatelessWidget{

  List<TeamData> listTeamDetails=[];
  Map<String, dynamic> teamMapData={};
  Future<_TeamDetailsResponse> _responseData;

  TeamDetails(){
    _responseData=fetchPost();
  }


  @override
  Widget build(BuildContext context) {
    // Use only portrait mode for Login Page.

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return Scaffold(
        appBar: AppBar(title: Text('Team Details'),),
        body: Center(
          child: FutureBuilder(future: _responseData,builder: (context,snapshot){

            if (snapshot.hasData) {
              teamMapData =snapshot.data.teamDataJson;
              teamMapData.forEach((String fbId,dynamic teamDataFromDB){
                final TeamData teamData = TeamData(
                  fireBaseId: fbId,
                  teamName: teamDataFromDB['teamName'],
                  baseSalary:teamDataFromDB['baseSalary'],
                  mesthriAllowance:teamDataFromDB['mesthriAllowance'],
                  foodAllowance:teamDataFromDB['foodAllowance'],
                  otAllowance:teamDataFromDB['otAllowance'],
                  sprayAllowance:teamDataFromDB['sprayAllowance'],
                );
                listTeamDetails.add(teamData);
              });
              
              return ListView.builder(itemBuilder: (context,index){
                return TeamDetailsCard(listTeamDetails[index]);

              },itemCount: listTeamDetails.length,);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            // By default, show a loading spinner
            return CircularProgressIndicator();

          }),
        ),

      );


  }


}

class _TeamDetailsResponse {

 final Map<String,dynamic> teamDataJson;

 _TeamDetailsResponse(this.teamDataJson);

}
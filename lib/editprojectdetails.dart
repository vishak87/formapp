import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './model/projectdetails.dart';
import './widgets/projectdetailswidget.dart';

Future<_ProjectDetailsResponse> fetchPost() async {
  final response =
  await http.get('https://operationsreporting-584ec.firebaseio.com/ProjectDetails.json');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    return _ProjectDetailsResponse(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}



class ProjectDetails extends StatelessWidget{

  List<ProjectData> listProjectDetails=[];
  Map<String, dynamic> teamMapData={};
  Future<_ProjectDetailsResponse> _responseData;

  ProjectDetails(){
    _responseData=fetchPost();
  }


  @override
  Widget build(BuildContext context) {
    // Use only portrait mode for Login Page.

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return Scaffold(
      appBar: AppBar(title: Text('Project Details'),),
      body: Center(
        child: FutureBuilder(future: _responseData,builder: (context,snapshot){

          if (snapshot.hasData) {
            teamMapData =snapshot.data.projectDataJson;
            teamMapData.forEach((String fbId,dynamic projectDataFromDB){
              final ProjectData projectData = ProjectData(
                fireBaseId: fbId,
                projectName : projectDataFromDB['projectName'],
                projectAddress :projectDataFromDB['projectAddress'],

              );
              listProjectDetails.add(projectData);
            });

            return ListView.builder(itemBuilder: (context,index){
              return ProjectDetailsCard(listProjectDetails[index]);

            },itemCount: listProjectDetails.length,);
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

class _ProjectDetailsResponse {

  final Map<String,dynamic> projectDataJson;

  _ProjectDetailsResponse(this.projectDataJson);

}
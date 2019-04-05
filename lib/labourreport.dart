import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'createteam.dart';
import 'vieweditteam.dart';
import 'createproject.dart';
import 'editprojectdetails.dart';
import 'fetchdetailsfordropdown.dart';
import 'editDailyReports.dart';
import 'generatereporthomepage.dart';


class LabourReport extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _LabourReportState();
  }

}


class _LabourReportState extends State<LabourReport>{



  @override
  Widget build(BuildContext context) {
    // Use only portrait mode for Login Page.
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
      appBar: AppBar(title: Text('Labour Report'),),
      body: Container(

      child: FetchDetails(),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Text('Menu'),

            ),
            ListTile(
              title: Text('Create New Team'),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateNewTeam()),
                );
              },
            ),
            ListTile(
              title: Text('Edit Team Details'),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TeamDetails()),
                );
              },
            ),
            ListTile(
              title: Text('Add a New Project'),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateProject()),
                );
              },
            ),
            ListTile(
              title: Text('Edit Project Details'),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProjectDetails()),
                );
              },
            ),
            ListTile(
              title: Text('Generate report'),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GenerateReportHomepage()),
                  );
              },
              )
            /*ListTile(
              title: Text('Test Details'),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePageForm()),
                );
              },
            )*/

          ],
        ),
      ),

    );
  }


}
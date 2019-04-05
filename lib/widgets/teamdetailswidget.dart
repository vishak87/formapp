import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../model/teamdetails.dart';
import '../updateteamdetails.dart';

class TeamDetailsCard extends StatelessWidget{

  TeamData teamData;

  TeamDetailsCard(this.teamData);

  Widget build(BuildContext context) {
    // Use only portrait mode for Login Page.

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

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
                        MaterialPageRoute(builder: (context) => UpdateTeamDetails(teamData)),
                      );
                    }),

                  )
                ],),Row(
                  children: <Widget>[Container(
                    child: Text('Team Name: ' + teamData.teamName),
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
                      child: Text('Base Salary: '+ 'Rs.'+teamData.baseSalary),
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
                Row(children: <Widget>[Container(
                    child: Text('Mesthri Allowance: '+ 'Rs.'+teamData.mesthriAllowance),
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
                ),
                Container(
                    child: Text('OT Allowance: '+ 'Rs.'+teamData.otAllowance),
                    padding: EdgeInsets.all(10.0),
                    decoration: new BoxDecoration(
                        color: Colors.lightBlueAccent[100],
                        borderRadius: new BorderRadius.only(
                            topLeft:  const  Radius.circular(10.0),
                            topRight: const  Radius.circular(10.0),
                            bottomLeft: const Radius.circular(10.0),
                            bottomRight: const Radius.circular(10.0))
                    )
                )])],
            ),
          )
      ),
    );

  }
}
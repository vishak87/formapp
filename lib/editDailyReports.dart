import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class EditDailyReport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Use only portrait mode for Login Page.

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return Scaffold(
      appBar: AppBar(
        title: Text('Project Details'),
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection("dailyreports").snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if(snapshot.hasData){
                getDailyReports(snapshot);
              }
              if (snapshot.hasError) return new Text('${snapshot.error}');
              return CircularProgressIndicator();
             }),
      ),
    );
  }

  getDailyReports(AsyncSnapshot<QuerySnapshot> snapshot) {
    print('The size of snapshot is :'+ snapshot.data.documents.length.toString());
    snapshot.data.documents.forEach((doc){
      print('The document Id is :'+ doc.documentID);
      doc.data.forEach((key,valueMap){
        print('project key: '+key);
        print('value map: '+ valueMap);
      });
    });
    return Text('hi');
  }


/*
* return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection(documentName).snapshots(),
    builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) return new Text('${snapshot.error}');
      switch (snapshot.connectionState) {
        case ConnectionState.waiting:
          return new Center(child: new PlatformProgress());
        default:
          return new ListView(children: getExpenseItems(snapshot));


          getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents
        .map((doc) => new Container(
            margin: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
            child: ListTile(
                leading: Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                    child: Hero(
                        tag: doc[_audioLink],
                        child: new ClipOval(
                            child: Container(
                          width: 70.0,
                          height: 70.0,
                          child: Image.asset(
                            Utils.getImagePastor(doc[_pastorCode]),
                            fit: BoxFit.cover,
                          ),
                        )))),
                title: new Text(doc[_speechTitle]),
                subtitle: new Text(doc[_speechSubtitle].toString() +
                    " - " +
                    doc[_pastorName].toString()),
                onTap: () => onPressed(context, doc[_speechTitle],
                    doc[_pastorCode], doc[_audioLink]))))
        .toList();
  }

  onPressed(BuildContext context, String speechTitle, String pastorCode,
      String audioLink) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ScreenAudioSelected(speechTitle, pastorCode, audioLink)));
  }
*
* */

}

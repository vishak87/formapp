import 'package:flutter/material.dart';


class LabourEntry extends StatefulWidget{


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TdState();
  }

}




class _TdState extends State<LabourEntry>{

  List<TextFormField> listLabourShiftRow=[];


  Widget _buildLabourFieldList(){

    print('listLabourShiftRow length :' +listLabourShiftRow.length.toString());

        return ListView.builder(itemBuilder: (BuildContext context,int index){
        return listLabourShiftRow[index];},
        itemCount: listLabourShiftRow.length,

      );


  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return
        Flex(
          direction: Axis.vertical,
          children: <Widget>[
            RaisedButton(
              child: Text('Add Labour Details'),
              onPressed: (){

                listLabourShiftRow.add(TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Workers', filled: true, fillColor: Colors.white),
                  obscureText: false,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (String value) {
                    if (value.isEmpty ) {
                      return 'Details can\'t be empty and should be a number';
                    }
                  },
                  onSaved: (String value) {

                  },
                ));
                setState(() {
                  listLabourShiftRow=listLabourShiftRow;
                });
              },

            ),
            Expanded(
              child: _buildLabourFieldList(),
            )


          ],
        );


  }
}
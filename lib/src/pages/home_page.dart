import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:band_names/src/models/band.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands = [
    Band(id: "1", name: "Frank Sinatra", votes: 5),
    Band(id: "2", name: "John Denver", votes: 3),
    Band(id: "3", name: "Inquietos del vallenato", votes: 5),
    Band(id: "4", name: "Ricardo Arjona", votes: 2),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Band Names", style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, i) => _bandTile(bands[i])
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand,
        // En caso de necesitar mandar parametros, hacerlo asi
        // onPressed: () => addNewBand("hola"),
      ),
   );
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        // TODO: Llamar el borrado en el sv
      },
      background: Container(
        color: Colors.red[400],
        padding: EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Icon( FontAwesomeIcons.trash, color: Colors.white),
            SizedBox(width: 10), 
            Text("Delete band", style: TextStyle(fontSize: 15, color: Colors.white))
          ]
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(band.name.substring(0,2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(band.name),
        trailing: Text("${band.votes}", style: TextStyle(fontSize: 20)),
        onTap: (){},
      ),
    );
  }

  addNewBand() {

    final textController = new TextEditingController();

    if (Platform.isAndroid){
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("New Band Name"),
            content: TextField(
              controller: textController,
              textCapitalization: TextCapitalization.words,
            ),
            actions: [
              MaterialButton(
                child: Text("Add"),
                textColor: Colors.blue,
                onPressed: () => addBandToList(textController.text),
              )
            ],
          );
        }
      );
    }

    if (Platform.isIOS){
      return showCupertinoDialog(
        context: context, 
        builder: (_) { 
          return CupertinoAlertDialog(
            title: Text("New Band Name"),
            content: CupertinoTextField(
              controller: textController,
              textCapitalization: TextCapitalization.words
            ),
            actions: [
              CupertinoDialogAction(
                child: Text("Add"),
                isDefaultAction: true, // Disparar accion cuando presionan enter en el dispositivo fisico
                onPressed: () => addBandToList(textController.text),
              ),
              
              CupertinoDialogAction(
                child: Text("Dismiss"),
                isDestructiveAction: true,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        }
      );
    }
  }

  void addBandToList( String name ) {
    if ( name.length > 1 ) {
      this.bands.add( new Band(id: DateTime.now().toString(), name: name, votes: 0 ) );
      setState(() {});
    } else {

    }

    Navigator.pop(context);
  }
}
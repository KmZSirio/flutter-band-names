import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:band_names/src/models/band.dart';
import 'package:band_names/src/services/socket_service.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands = [];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);

    socketService.socket.on( "active-bands", _handleActiveBands );

    super.initState();
  }

  _handleActiveBands(dynamic payload) {
    
    this.bands = ( payload as List )
      .map( (band) => Band.fromMap(band) )
      .toList();

    setState(() {});
  }

  // En caso de necesitar destruir esta page, off para dejar de escuchar active-bands
  // @override
  // void dispose() {
  //   final socketService = Provider.of<SocketService>(context, listen: false);
  //   socketService.socket.off("active-bands");
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Band Names", style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: ( socketService.serverStatus == ServerStatus.Online )
              ? Icon( FontAwesomeIcons.solidCheckCircle, color: Colors.green[300] )
              : Icon( FontAwesomeIcons.solidTimesCircle, color: Colors.red[300] ),
          )
        ],
      ),
      body: Column(
        children: [

          _showGraph(),

          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (context, i) => _bandTile(bands[i])
            ),
          )
        ],
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

    final socketService = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) => socketService.socket.emit( "delete-band", { "id": band.id } ),
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
        onTap: () => socketService.socket.emit( "vote-band", {"id": band.id} ),
      ),
    );
  }

  addNewBand() {

    final textController = new TextEditingController();

    if (Platform.isAndroid){
      return showDialog(
        context: context,
        builder: (_) {
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

      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.socket.emit( "add-band", { "name": name } );
    }

    Navigator.pop(context);
  }

  Widget _showGraph() {

    Map<String, double> dataMap = {};
    bands.forEach((band) {
      dataMap.putIfAbsent( band.name, () => band.votes.toDouble() );
    });

    final List<Color> colorList = [
      Colors.blue[300],
      Colors.green[300],
      Colors.yellow[300],
      Colors.red[300],
      Colors.orange[300],
      Colors.black26,
      Colors.blueGrey[300],
      Colors.pink[300],
    ];

    if ( dataMap.isNotEmpty ) {
      return Container(
        width: double.infinity,
        height: 250,
        child: PieChart(
          dataMap: dataMap,
          animationDuration: Duration(milliseconds: 800),
          chartLegendSpacing: 64,
          chartRadius: MediaQuery.of(context).size.width / 3,
          colorList: colorList,
          initialAngleInDegree: 0,
          chartType: ChartType.ring,
          ringStrokeWidth: 10,
          centerText: "",
          legendOptions: LegendOptions(
            showLegendsInRow: false,
            legendPosition: LegendPosition.right,
            showLegends: true,
            legendShape: BoxShape.circle,
            legendTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          chartValuesOptions: ChartValuesOptions(
            showChartValueBackground: false,
            decimalPlaces: 0,
            showChartValues: true,
            showChartValuesInPercentage: true,
            showChartValuesOutside: true,
          ),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.all(30),
        child: Row(
          children: [
            Icon( FontAwesomeIcons.exclamationCircle , color: Colors.blue, size: 40 ),
            SizedBox(width: 20),
            Text("No data", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400))
          ],
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
      );
    }
  }

    

}
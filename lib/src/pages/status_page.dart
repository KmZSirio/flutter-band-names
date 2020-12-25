import 'package:band_names/src/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class StatusPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context);
    
    return Scaffold(
      body: Center(
        child: Text("Status: ${socketService.serverStatus}"),
     ),
     floatingActionButton: FloatingActionButton(
       child: Icon(Icons.message),
       onPressed: () {

         socketService.socket.emit("emitir-mensaje", { "nombre": "Flutter", "mensaje": "Hola desde Flutter"});

       },
     ),
   );
  }
}
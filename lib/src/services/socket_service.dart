import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting
}

class SocketService with ChangeNotifier {

  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket => this._socket;

  SocketService() {
    this._initConfig();
  }

  void _initConfig() {

    this._socket = IO.io('http://192.168.0.26:3000',{
      "transports": ["websocket"],
      "autoConnect": true
    });

    this._socket.onConnect((_) {
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    this._socket.onDisconnect((_) {
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });









    // socket.on("nuevo-mensaje", (payload) {

      // socket.emit("emitir-mensaje", { nombre: "Sirio", clan: "Busta"});   // Web

      // print("Nuevo mensaje!!");
      // print("Nombre: " + payload["nombre"]);
      // print("Clan: " + payload["clan"]);
      // print( payload.containsKey("otro") ? payload["otro"] : "Nada mas" );   // Verificar si existe y evitar error
    // });

  }

}


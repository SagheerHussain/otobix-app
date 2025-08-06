import 'package:otobix/Utils/socket_events.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/foundation.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();

  factory SocketService() => _instance;

  late IO.Socket socket;

  SocketService._internal();

  void initSocket(String serverUrl) {
    socket = IO.io(serverUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.onConnect((_) {
      debugPrint('🟢 Connected to Socket.IO');
    });

    socket.onDisconnect((_) {
      debugPrint('🔴 Disconnected from Socket.IO');
    });

    // Optionally listen for errors
    socket.onConnectError((e) => debugPrint('⚠️ Connect error: $e'));
    socket.onError((e) => debugPrint('❌ Socket error: $e'));
  }

  void joinRoom(String roomId) {
    socket.emit(SocketEvents.joinRoom, roomId);
    debugPrint('Joined room: $roomId');
  }

  void on(String event, Function(dynamic) handler) {
    socket.on(event, handler);
  }

  void emit(String event, dynamic data) {
    socket.emit(event, data);
  }

  void dispose() {
    socket.dispose();
  }
}

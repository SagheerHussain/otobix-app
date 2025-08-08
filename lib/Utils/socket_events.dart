class SocketEvents {
  // Built-in
  static const String connect = 'connect';
  static const String disconnect = 'disconnect';
  static const String connectError = 'connect_error';
  static const String error = 'error';

  // Custom Events (match your backend)
  static const String joinRoom = 'join-room';
  static const String bidUpdated = 'bid-updated';
  static const String leaveRoom = 'leave-room';
  static const String auctionEnded = 'auction-ended';
}

import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  Function(Map<String, dynamic>)? _onMessageCallback;
  Function()? _onConnectedCallback;
  Function()? _onDisconnectedCallback;

  void connect(String url, {required int userId}) {
    final wsUrl = '$url?user_id=$userId';
    _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
    
    _channel!.stream.listen(
      (message) {
        if (_onMessageCallback != null) {
          final data = jsonDecode(message);
          _onMessageCallback!(data);
        }
      },
      onDone: () {
        if (_onDisconnectedCallback != null) {
          _onDisconnectedCallback!();
        }
      },
      onError: (error) {
        print('WebSocket error: $error');
        if (_onDisconnectedCallback != null) {
          _onDisconnectedCallback!();
        }
      },
    );

    if (_onConnectedCallback != null) {
      _onConnectedCallback!();
    }
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
  }

  void send(Map<String, dynamic> message) {
    if (_channel != null) {
      _channel!.sink.add(jsonEncode(message));
    }
  }

  void joinNote(int noteId) {
    send({
      'type': 'note:join',
      'payload': {
        'note_id': noteId,
      },
    });
  }

  void leaveNote(int noteId) {
    send({
      'type': 'note:leave',
      'payload': {
        'note_id': noteId,
      },
    });
  }

  void updateNote({
    required int noteId,
    required String content,
    String? title,
  }) {
    send({
      'type': 'note:update',
      'payload': {
        'note_id': noteId,
        'content': content,
        if (title != null) 'title': title,
      },
    });
  }

  void setTyping({
    required int noteId,
    required bool isTyping,
  }) {
    send({
      'type': 'note:user_typing',
      'payload': {
        'note_id': noteId,
        'is_typing': isTyping,
      },
    });
  }

  void onMessage(Function(Map<String, dynamic>) callback) {
    _onMessageCallback = callback;
  }

  void onConnected(Function() callback) {
    _onConnectedCallback = callback;
  }

  void onDisconnected(Function() callback) {
    _onDisconnectedCallback = callback;
  }

  bool get isConnected => _channel != null;
}

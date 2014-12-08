import 'dart:html';
import 'dart:async';
import 'dart:convert';

WebSocket socket;

void main() {
  initWebSocket();

  querySelector("#submit").onClick.listen((MouseEvent e) {
    print("Send mesaage");
    var editor = querySelector("#editor");
    // 将br转变为换行标记
    editor.querySelectorAll("br").forEach((Element e) {
      e.text = "<{#}>";
    });
    var message = JSON.encode({
      'Type': 'new',
      'Data': {
        'channel': 'piazza',
        'author': 'unknown',
        'content': editor.text
      }
    });
    print(editor.text);
    socket.send(message);
    editor.text = "";
  });

  querySelectorAll(".toolbar .btn.btn-success").forEach((Element btn) {
    btn.onClick.listen((MouseEvent e) {
      print(btn.parent.parent.id);
    });
  });
}

void initWebSocket([int retrySeconds = 2]) {
  var reconnectScheduled = false;

  print("Connecting to websocket");
  socket = new WebSocket('ws://127.0.0.1:4000/ws');

  void scheduleReconnect() {
    if (!reconnectScheduled) {
      new Timer(new Duration(milliseconds: 1000 * retrySeconds), () => initWebSocket(retrySeconds * 2));
    }
    reconnectScheduled = true;
  }

  socket.onOpen.listen((e) {
    print('Connected');
    // 重置重连接时间
    retrySeconds = 2;
  });

  socket.onClose.listen((e) {
    print('Websocket closed, retrying in $retrySeconds seconds');
    scheduleReconnect();
  });

  socket.onError.listen((e) {
    print("Error connecting to ws");
    scheduleReconnect();
  });

  socket.onMessage.listen((MessageEvent e) {
    var msg = JSON.decode(e.data.toString());
    switch (msg["Type"]) {
    case "newMsg":
      var content = new Element.html('<div id="${msg["Data"]["ID"]}" class="content"><p>${msg["Data"]["Content"]}</p><div class="editor editor-reply"></div><div class="toolbar"><a class="btn btn-success">回复</a></div></div>');
      // 因为上面无法直接解析contenteditable属性
      // 所以在这里手动添加
      content.querySelector(".editor.editor-reply").attributes['contenteditable'] = 'true';
      // 设置本消息上的回复按钮onClick事件
      content.querySelector(".toolbar .btn.btn-success").onClick.listen((MouseEvent e) {
        print(msg["Data"]["ID"]);
      });
      // 在所有消息前插入本消息
      querySelector("#stream").insertBefore(content, querySelector("#stream .content"));
      break;
    case "error":
      print(msg["Data"]);
      break;
    }
  });
}

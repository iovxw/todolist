import 'dart:html';
import 'dart:async';
import 'dart:convert';

WebSocket socket;

void main() {
  initWebSocket();

  querySelector("#submit").onClick.listen((MouseEvent e) {
    print("Send mesaage");
    var editor = querySelector("#editor div div div .editor");
    // 将br转变为换行标记
    editor.querySelectorAll("br").forEach((Element e) {
      e.text = "<{#}>";
    });
    var message = JSON.encode({
      'Type': 'new',
      'Data': {
        'channel': 'piazza',
        'content': editor.text,
      }
    });
    print(editor.text);
    socket.send(message);
    editor.text = "";
    querySelector("button.close").click();
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
      var content = new Element.html(
        '''
          <div id="${msg["Data"]["ID"]}" class="col-md-4">
            <div class="content">
              <div class="con">${msg["Data"]["Content"]}</div>
              <div class="info">
                <i class="fa fa-clock-o"></i>
                <a>time</a>
              </div>
            </div>
          </div>
        '''
      );
      // 在所有消息前插入本消息
      var childDiv = querySelector("body .container .row div");
      childDiv.parent.insertBefore(content, childDiv);
      break;
    case "error":
      print(msg["Data"]);
      break;
    }
  });
}
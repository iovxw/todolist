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

  var colorBoxes = querySelectorAll(".colors .color-box");

  const selected = " fa fa-check";

  for (Element colorBox in colorBoxes) {
    colorBox.onClick.listen((MouseEvent e) {
      var id = colorBox.id;
      var str = colorBox.getAttribute("class");
      // 检查是否已经被选中
      if (str.indexOf(selected) == -1) {
        // 选中
        colorBox.setAttribute("class", str + selected);

        // 取消选中其他选框
        for (Element colorBox in colorBoxes) {
          // 跳过被选中的colorBox
          if (colorBox.id != id) {
            // 取消选中
            str = colorBox.getAttribute("class").replaceAll(selected, "");
            colorBox.setAttribute("class", str);
          }
        }
      }
    });
  }
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
          <div id="${msg["Data"]["ID"]}" class="col-xs-12 col-sm-6 col-md-4">
		      	<div class="content">
			      	<div class="panel-body">${msg["Data"]["Content"]}</div>
              <div class="panel-footer" style="background-color: ${msg["Data"]["Color"]};">
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

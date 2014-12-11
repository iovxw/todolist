import 'dart:html';
import 'dart:async';
import 'dart:convert';

WebSocket socket;
Map config;

void main() {
  Location currentLocation = window.location;
  config = {
    'host': currentLocation.host,
    'head': "https" == currentLocation.protocol ? 'wss' : 'ws',
  };

  initWebSocket();

  querySelector("#submit").onClick.listen((MouseEvent e) {
    print("Send mesaage");
    var editor = querySelector("#editor div div div .editor");
    // 将br转变为换行标记
    editor.querySelectorAll("br").forEach((Element e) {
      e.text = "<{#}>";
    });
    // 获取选中的颜色的id
    var color = querySelector(".colors .fa.fa-check").id;
    var message = JSON.encode({
      'Type': 'new',
      'Data': {
        'channel': 'piazza',
        'content': editor.text,
        'color': color,
      }
    });
    print(editor.text);
    socket.send(message);
    editor.text = "";
    querySelector("button.close").click();
  });

  querySelectorAll(".dropdown-menu li a .fa-times").forEach((Element toolBar) {
    removeBtnClicked(toolBar.parent);
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
  socket = new WebSocket('${config["head"]}://${config["host"]}/ws');

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
        newMsg(msg);
        break;
      case "deleteMsg":
        document.getElementById(msg["Data"]).remove();
        break;
      case "error":
        print(msg["Data"]);
        break;
    }
  });
}

void newMsg(Map msg) {
  var color;
  switch (msg["Data"]["Color"]) {
    case 0:
      color = "default";
      break;
    case 1:
      color = "red";
      break;
    case 2:
      color = "pink";
      break;
    case 3:
      color = "orange";
      break;
    case 4:
      color = "yellow";
      break;
    case 5:
      color = "lime";
      break;
    case 6:
      color = "green";
      break;
    case 7:
      color = "teal";
      break;
    case 8:
      color = "blue";
      break;
    case 9:
      color = "indigo";
      break;
    case 10:
      color = "deep-purple";
      break;
    case 11:
      color = "purple";
      break;
  }
  var content = new Element.html('''
    <div id="${msg["Data"]["ID"]}" class="col-xs-12 col-sm-6 col-md-4">
      <div class="content">
        <div class="panel-body">${msg["Data"]["Content"]}</div>
          <div class="panel-footer ${color}">
            <i class="fa fa-clock-o"></i><a>time</a>
            <div class="btn-group">
              <a><i class="fa fa-ellipsis-v"></i></a>
              <ul class="dropdown-menu">
              <li>
                <a><i class="fa fa-check"></i> 标记为已完成</a>
              </li>
              <li class="divider"></li>
              <li>
                <a><i class="fa fa-times"></i> 删除</a>
              </li>
            </ul>
          </div>
        </div>
      </div>
    </div>
    ''');

  removeBtnClicked(content.querySelector(".dropdown-menu li a .fa-times").parent);

  content.querySelector('.btn-group > a').attributes['data-toggle'] = 'dropdown';

  // 插入消息
  var childDiv = querySelector("body .container .row div");
  // 如果找不到已存在的消息，直接插入
  if (childDiv == null) {
    // 直接插入
    querySelector("body .container .row").append(content);
  } else {
    // 在所有消息前插入本消息
    childDiv.parent.insertBefore(content, childDiv);
  }
}

void removeBtnClicked(Element removeButton) {
  removeButton.onClick.listen((MouseEvent e) {
    var div = removeButton.parent.parent.parent.parent.parent.parent;
    //div.remove();
    socket.send(JSON.encode({
      'Type': 'remove',
      'Data': {
        'id': div.id,
      }
    }));
  });
}

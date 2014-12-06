import "dart:html";import "dart:convert";import "dart:async";WebSocket j;void main(){l();querySelector("#submit").onClick.listen((MouseEvent h){print("Send mesaage");var g=querySelector("#editor div div div .editor");g.querySelectorAll("br").forEach((Element h){h.text="<{#}>";});var k=JSON.encode({'Type':'new','Data':{'channel':'piazza','content':g.text}});print(g.text);j.send(k);g.text="";querySelector("button.close").click();});querySelectorAll(".toolbar .btn.btn-success").forEach((Element i){i.onClick.listen((MouseEvent h){print(i.parent.parent.id);});});}void l([int g=2]){var k=false;print("Connecting to websocket");j=new WebSocket('ws://127.0.0.1:4000/ws');void m(){if(!k){new Timer(new Duration(milliseconds:1000*g),()=>l(g*2));}k=true;}j.onOpen.listen((h){print('Connected');g=2;});j.onClose.listen((h){print('Websocket closed, retrying in ${g} seconds');m();});j.onError.listen((h){print("Error connecting to ws");m();});j.onMessage.listen((MessageEvent h){var i=JSON.decode(h.data.toString());switch (i["Type"]){case "newMsg":var AB=new Element.html('''
          <div id="${i["Data"]["ID"]}" class="col-md-4">
            <div class="content">
              <div class="con">${i["Data"]["Content"]}</div>
              <div class="info">
                <i class="fa fa-clock-o"></i>
                <a>time</a>
              </div>
            </div>
          </div>
        ''');var n=querySelector("body .container .row div");n.parent.insertBefore(AB,n);break;case "error":print(i["Data"]);break;}});}const BB='mangledGlobalNames';class o{static const String CB="Chrome";static const String DB="Firefox";static const String EB="Internet Explorer";static const String FB="Opera";static const String GB="Safari";final String v;final String minimumVersion;const o(this.v,[this.minimumVersion]);}class q{const q();}class s{final String name;const s(this.name);}class t{const t();}class u{const u();}
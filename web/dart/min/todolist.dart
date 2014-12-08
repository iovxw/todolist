import "dart:html";import "dart:convert";import "dart:async";WebSocket j;void main(){l();querySelector("#submit").onClick.listen((MouseEvent h){print("Send mesaage");var g=querySelector("#editor div div div .editor");g.querySelectorAll("br").forEach((Element h){h.text="<{#}>";});var k=JSON.encode({'Type':'new','Data':{'channel':'piazza','content':g.text}});print(g.text);j.send(k);g.text="";querySelector("button.close").click();});querySelectorAll(".toolbar .btn.btn-success").forEach((Element i){i.onClick.listen((MouseEvent h){print(i.parent.parent.id);});});}void l([int h=2]){var k=false;print("Connecting to websocket");j=new WebSocket('ws://127.0.0.1:4000/ws');void m(){if(!k){new Timer(new Duration(milliseconds:1000*h),()=>l(h*2));}k=true;}j.onOpen.listen((i){print('Connected');h=2;});j.onClose.listen((i){print('Websocket closed, retrying in ${h} seconds');m();});j.onError.listen((i){print("Error connecting to ws");m();});j.onMessage.listen((MessageEvent i){var g=JSON.decode(i.data.toString());switch (g["Type"]){case "newMsg":var AB=new Element.html('''
          <div id="${g["Data"]["ID"]}" class="col-xs-12 col-sm-6 col-md-4">
		      	<div class="content">
			      	<div class="panel-body">${g["Data"]["Content"]}</div>
              <div class="panel-footer" style="background-color: ${g["Data"]["Color"]};">
                <i class="fa fa-clock-o"></i>
				        <a>time</a>
              </div>
            </div>
          </div>
        ''');var n=querySelector("body .container .row div");n.parent.insertBefore(AB,n);break;case "error":print(g["Data"]);break;}});}const BB='mangledGlobalNames';class o{static const String CB="Chrome";static const String DB="Firefox";static const String EB="Internet Explorer";static const String FB="Opera";static const String GB="Safari";final String v;final String minimumVersion;const o(this.v,[this.minimumVersion]);}class q{const q();}class s{final String name;const s(this.name);}class t{const t();}class u{const u();}
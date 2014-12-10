import "dart:html";import "dart:convert";import "dart:async";WebSocket k;Map q;void main(){Location m=window.location;q={'host':m.host,'head':"https"==m.protocol?'wss':'ws'};s();querySelector("#submit").onClick.listen((MouseEvent j){print("Send mesaage");var h=querySelector("#editor div div div .editor");h.querySelectorAll("br").forEach((Element j){j.text="<{#}>";});var o=querySelector(".colors .fa.fa-check").id;var EB=JSON.encode({'Type':'new','Data':{'channel':'piazza','content':h.text,'color':o}});print(h.text);k.send(EB);h.text="";querySelector("button.close").click();});querySelectorAll(".dropdown-menu li a .fa-times").forEach((Element FB){t(FB.parent);});var n=querySelectorAll(".colors .color-box");const l=" fa fa-check";for(Element g in n){g.onClick.listen((MouseEvent j){var GB=g.id;var i=g.getAttribute("class");if(i.indexOf(l)==-1){g.setAttribute("class",i+l);for(Element g in n){if(g.id!=GB){i=g.getAttribute("class").replaceAll(l,"");g.setAttribute("class",i);}}}});}}void s([int i=2]){var n=false;print("Connecting to websocket");k=new WebSocket('${q["head"]}://${q["host"]}/ws');void o(){if(!n){new Timer(new Duration(milliseconds:1000*i),()=>s(i*2));}n=true;}k.onOpen.listen((j){print('Connected');i=2;});k.onClose.listen((j){print('Websocket closed, retrying in ${i} seconds');o();});k.onError.listen((j){print("Error connecting to ws");o();});k.onMessage.listen((MessageEvent j){var h=JSON.decode(j.data.toString());switch (h["Type"]){case "newMsg":var g;switch (h["Data"]["Color"]){case 0:g="default";break;case 1:g="red";break;case 2:g="pink";break;case 3:g="orange";break;case 4:g="yellow";break;case 5:g="lime";break;case 6:g="green";break;case 7:g="teal";break;case 8:g="blue";break;case 9:g="indigo";break;case 10:g="deep-purple";break;case 11:g="purple";break;}var l=new Element.html('''
          <div id="${h["Data"]["ID"]}" class="col-xs-12 col-sm-6 col-md-4">
		      	<div class="content">
			      	<div class="panel-body">${h["Data"]["Content"]}</div>
              <div class="panel-footer ${g}">
                <i class="fa fa-clock-o"></i><a>time</a>
                <div class="btn-group">
                  <a data-toggle="dropdown"><i class="fa fa-ellipsis-v"></i></a>
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
        ''');t(l.querySelector(".dropdown-menu li a .fa-times").parent);var m=querySelector("body .container .row div");if(m==null){querySelector("body .container .row").append(l);}else{m.parent.insertBefore(l,m);}break;case "error":print(h["Data"]);break;}});}void t(Element g){g.onClick.listen((MouseEvent i){var h=g.parent.parent.parent.parent.parent.parent;h.remove();k.send(JSON.encode({'Type':'remove','Data':{'id':h.id}}));});}const HB='mangledGlobalNames';class u{static const String IB="Chrome";static const String JB="Firefox";static const String KB="Internet Explorer";static const String LB="Opera";static const String MB="Safari";final String DB;final String minimumVersion;const u(this.DB,[this.minimumVersion]);}class v{const v();}class AB{final String name;const AB(this.name);}class BB{const BB();}class CB{const CB();}
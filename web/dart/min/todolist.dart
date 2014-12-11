import "dart:html";import "dart:convert";import "dart:async";WebSocket k;Map m;void main(){Location q=window.location;m={'host':q.host,'head':"https"==q.protocol?'wss':'ws'};n();querySelector("#submit").onClick.listen((MouseEvent j){print("Send mesaage");var h=querySelector("#editor div div div .editor");h.querySelectorAll("br").forEach((Element j){j.text="<{#}>";});var EB=querySelector(".colors .fa.fa-check").id;var FB=JSON.encode({'Type':'new','Data':{'channel':'piazza','content':h.text,'color':EB}});print(h.text);k.send(FB);h.text="";querySelector("button.close").click();});querySelectorAll(".dropdown-menu li a .fa-times").forEach((Element GB){o(GB.parent);});var s=querySelectorAll(".colors .color-box");const l=" fa fa-check";for(Element g in s){g.onClick.listen((MouseEvent j){var HB=g.id;var i=g.getAttribute("class");if(i.indexOf(l)==-1){g.setAttribute("class",i+l);for(Element g in s){if(g.id!=HB){i=g.getAttribute("class").replaceAll(l,"");g.setAttribute("class",i);}}}});}}void n([int g=2]){var j=false;print("Connecting to websocket");k=new WebSocket('${m["head"]}://${m["host"]}/ws');void l(){if(!j){new Timer(new Duration(milliseconds:1000*g),()=>n(g*2));}j=true;}k.onOpen.listen((h){print('Connected');g=2;});k.onClose.listen((h){print('Websocket closed, retrying in ${g} seconds');l();});k.onError.listen((h){print("Error connecting to ws");l();});k.onMessage.listen((MessageEvent h){var i=JSON.decode(h.data.toString());switch (i["Type"]){case "newMsg":t(i);break;case "deleteMsg":document.getElementById(i["Data"]).remove();break;case "error":print(i["Data"]);break;}});}void t(Map i){var g;switch (i["Data"]["Color"]){case 0:g="default";break;case 1:g="red";break;case 2:g="pink";break;case 3:g="orange";break;case 4:g="yellow";break;case 5:g="lime";break;case 6:g="green";break;case 7:g="teal";break;case 8:g="blue";break;case 9:g="indigo";break;case 10:g="deep-purple";break;case 11:g="purple";break;}var h=new Element.html('''
    <div id="${i["Data"]["ID"]}" class="col-xs-12 col-sm-6 col-md-4">
      <div class="content">
        <div class="panel-body">${i["Data"]["Content"]}</div>
          <div class="panel-footer ${g}">
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
    ''');o(h.querySelector(".dropdown-menu li a .fa-times").parent);h.querySelector('.btn-group > a').attributes['data-toggle']='dropdown';var j=querySelector("body .container .row div");if(j==null){querySelector("body .container .row").append(h);}else{j.parent.insertBefore(h,j);}}void o(Element g){g.onClick.listen((MouseEvent i){var h=g.parent.parent.parent.parent.parent.parent;k.send(JSON.encode({'Type':'remove','Data':{'id':h.id}}));});}const IB='mangledGlobalNames';class u{static const String JB="Chrome";static const String KB="Firefox";static const String LB="Internet Explorer";static const String MB="Opera";static const String NB="Safari";final String DB;final String minimumVersion;const u(this.DB,[this.minimumVersion]);}class v{const v();}class AB{final String name;const AB(this.name);}class BB{const BB();}class CB{const CB();}
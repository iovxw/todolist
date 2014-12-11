import "dart:html";import "dart:convert";import "dart:async";WebSocket k;Map m;void main(){Location l=window.location;m={'host':l.host,'head':"https"==l.protocol?'wss':'ws'};n();querySelector("#submit").onClick.listen(v);querySelectorAll(".dropdown-menu li a .fa-times").forEach((Element HB){o(HB.parent);});querySelectorAll(".dropdown-menu li a .fa-pencil").forEach((Element h){h.parent.onClick.listen((MouseEvent h){var i=querySelector("#editor");var q=i.querySelector(".modal-title");var s=i.querySelector("#modification").classes;var t=i.querySelector("#submit").classes;q.text="编辑";s.remove("hide");t.add("hide");querySelector("#add").onClick.listen((MouseEvent h){q.text="添加新事项";s.add("hide");t.remove("hide");});});});var u=querySelectorAll(".colors .color-box");const j=" fa fa-check";for(Element g in u){g.onClick.listen((MouseEvent h){var IB=g.id;if(!g.classes.contains(j)){g.classes.add(j);for(Element g in u){if(g.id!=IB){g.classes.remove(j);}}}});}}void n([int g=2]){var j=false;print("Connecting to websocket");k=new WebSocket('${m["head"]}://${m["host"]}/ws');void l(){if(!j){new Timer(new Duration(milliseconds:1000*g),()=>n(g*2));}j=true;}k.onOpen.listen((h){print('Connected');g=2;});k.onClose.listen((h){print('Websocket closed, retrying in ${g} seconds');l();});k.onError.listen((h){print("Error connecting to ws");l();});k.onMessage.listen((MessageEvent h){var i=JSON.decode(h.data.toString());switch (i["Type"]){case "newMsg":AB(i);break;case "deleteMsg":document.getElementById(i["Data"]).remove();break;case "error":print(i["Data"]);break;}});}void v(MouseEvent h){print("Send mesaage");var g=querySelector("#editor div div div .editor");g.querySelectorAll("br").forEach((Element h){h.text="<{#}>";});var i=querySelector(".colors .fa.fa-check").id;var j=JSON.encode({'Type':'new','Data':{'channel':'piazza','content':g.text,'color':i}});print(g.text);k.send(j);g.text="";querySelector("button.close").click();}void AB(Map i){var g;switch (i["Data"]["Color"]){case 0:g="default";break;case 1:g="red";break;case 2:g="pink";break;case 3:g="orange";break;case 4:g="yellow";break;case 5:g="lime";break;case 6:g="green";break;case 7:g="teal";break;case 8:g="blue";break;case 9:g="indigo";break;case 10:g="deep-purple";break;case 11:g="purple";break;}var h=new Element.html('''
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
  ''');o(h.querySelector(".dropdown-menu li a .fa-times").parent);h.querySelector('.btn-group > a').attributes['data-toggle']='dropdown';var j=querySelector("body .container .row div");if(j==null){querySelector("body .container .row").append(h);}else{j.parent.insertBefore(h,j);}}void o(Element g){g.onClick.listen((MouseEvent i){var h=g.parent.parent.parent.parent.parent.parent;k.send(JSON.encode({'Type':'remove','Data':{'id':h.id}}));});}const JB='mangledGlobalNames';class BB{static const String KB="Chrome";static const String LB="Firefox";static const String MB="Internet Explorer";static const String NB="Opera";static const String OB="Safari";final String GB;final String minimumVersion;const BB(this.GB,[this.minimumVersion]);}class CB{const CB();}class DB{final String name;const DB(this.name);}class EB{const EB();}class FB{const FB();}
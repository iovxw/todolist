package base

import (
	"bytes"
	"log"

	"todolist/modules"
)

func Content(channel string, _buffer *bytes.Buffer) {
	contents, err := modules.GetContent(channel)
	if err != nil {
		log.Println("[modules.GetContent]ERROR", err)
		_buffer.WriteString("<div class=\"content\"><p>服务器数据库错误！</p></div>")
		return
	}
	for _, info := range contents {
		_buffer.WriteString("<div id=\"")
		_buffer.WriteString(info.ID)
		_buffer.WriteString("\" class=\"col-xs-12 col-sm-6 col-md-4\"><div class=\"content\"><div class=\"panel-body\">")
		_buffer.WriteString(info.Content)
		_buffer.WriteString("</div>")
		var color string
		switch info.Color {
		case 0:
			color = "default"
		case 1:
			color = "red"
		case 2:
			color = "pink"
		case 3:
			color = "orange"
		case 4:
			color = "yellow"
		case 5:
			color = "lime"
		case 6:
			color = "green"
		case 7:
			color = "teal"
		case 8:
			color = "blue"
		case 9:
			color = "indigo"
		case 10:
			color = "deep-purple"
		case 11:
			color = "purple"
		}
		_buffer.WriteString("<div class=\"panel-footer ")
		_buffer.WriteString(color)
		_buffer.WriteString("\"><i class=\"fa fa-clock-o\"></i><a>time</a><div class=\"btn-group\"><a data-toggle=\"dropdown\"><i class=\"fa fa-ellipsis-v\"></i></a><ul class=\"dropdown-menu\"><li><a><i class=\"fa fa-check\"></i> 标记为已完成</a></li><li class=\"divider\"></li><li><a><i class=\"fa fa-times\"></i> 删除</a></li></ul></div></div></div></div>")
	}
}

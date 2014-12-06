package base

import (
	"bytes"
	"log"

	"github.com/Bluek404/todolist/modules"
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
		// 判断是否需要添加颜色参数
		var addition string
		if info.Color != "" {
			addition = ` style="background-color: ` + info.Color + `;"`
		}
		_buffer.WriteString("<div class=\"panel-footer\"")
		_buffer.WriteString(addition)
		_buffer.WriteString("><i class=\"fa fa-clock-o\"></i><a>time</a></div></div></div>")
	}
}

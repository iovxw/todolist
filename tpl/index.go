package tpl

import (
	"bytes"

	"github.com/Bluek404/todolist/tpl/base"
)

func Index() string {
	_buffer := new(bytes.Buffer)

	_buffer.WriteString("<!DOCTYPE html><html>")
	base.Head("TodoList —— 首页", _buffer)
	_buffer.WriteString("<body><div id=\"editor\" class=\"modal fade\"><div class=\"modal-dialog\"><div class=\"modal-content\"><div class=\"modal-header\"><button class=\"close\" data-dismiss=\"modal\" aria-hidden=\"true\">×</button><h4 class=\"modal-title\">添加新事项</h4></div><div class=\"modal-body\"><div class=\"editor\" contentEditable=\"true\"></div></div><div class=\"modal-footer\"><button class=\"btn btn-default\" data-dismiss=\"modal\">关闭</button><button id=\"submit\" class=\"btn btn-primary\">保存</button></div></div></div></div>")
	base.Navbar(_buffer)
	_buffer.WriteString("<div class=\"container\"><div class=\"row\">")
	base.Content("piazza", _buffer)
	_buffer.WriteString("</div></div>")
	base.Footer(_buffer)
	_buffer.WriteString("</body></html>")

	return _buffer.String()
}

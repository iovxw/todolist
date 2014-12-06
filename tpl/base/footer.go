package base

import (
	"bytes"
)

func Footer(_buffer *bytes.Buffer) {
	_buffer.WriteString("<script src=\"http://libs.baidu.com/jquery/2.0.3/jquery.min.js\"></script><script src=\"http://libs.baidu.com/bootstrap/3.0.3/js/bootstrap.min.js\"></script>")

	_buffer.WriteString("<script async type=\"application/dart\" src=\"/dart/todolist.dart\"></script><script async src=\"/dart/packages/browser/dart.js\"></script>")
}

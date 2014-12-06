package base

import (
	"bytes"
)

func Head(title string, _buffer *bytes.Buffer) {
	_buffer.WriteString("<head><meta charset=\"utf-8\"></meta><title>")
	_buffer.WriteString(title)
	_buffer.WriteString("</title><link rel=\"stylesheet\" href=\"/css/font-awesome.css\"><link rel=\"stylesheet\" href=\"/css/bootstrap.css\"><link rel=\"stylesheet\" href=\"/css/custom.css\"></head>")
}

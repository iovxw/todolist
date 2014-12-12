package modules

import (
	"errors"
	"fmt"
	"strconv"
	"strings"

	"github.com/russross/blackfriday"
)

var nilContentERR = errors.New("content == nil")
var colors = 11

func newMessage(message *Message) error {
	msg := message.Data.(map[string]interface{})

	// 读取channel数据
	v, err := db.Get([]byte(msg["channel"].(string)), nil)
	if err != nil {
		return err
	}
	// 解码channel数据
	var chanInfo channelInfo
	err = decode(v, &chanInfo)
	if err != nil {
		return err
	}

	color, err := strconv.Atoi(msg["color"].(string))
	if err != nil {
		return err
	}

	// 检查收到的颜色编号是否合法
	if color < 0 || color > colors {
		// 超出许可范围，设置为默认值
		color = 0
	}

	// 检查是否为空信息
	if strings.Replace(msg["content"].(string), "<{#}>", "", -1) == "" {
		return nilContentERR
	}

	// 编码msg数据
	var conInfo = &contentInfo{
		ID:      newID(),
		Color:   color,
		Content: toMarkdown(escape(msg["content"].(string))),
	}
	// 将当前信息添加到channel的列表里
	chanInfo.MsgList = append([]contentInfo{*conInfo}, chanInfo.MsgList...)

	// 编码channel数据
	buf, err := encode(&chanInfo)
	if err != nil {
		return err
	}
	// 保存channel数据
	err = db.Put([]byte(msg["channel"].(string)), buf, nil)
	if err != nil {
		return err
	}

	// 将新信息推送到全部客户端
	pushMessageToClient(&Message{
		Type: "newMsg",
		Data: *conInfo,
	})

	return nil
}

func removeMessage(message *Message) error {
	msg := message.Data.(map[string]interface{})
	id := msg["id"].(string)
	channel := "piazza"

	// 读取channel数据
	v, err := db.Get([]byte(channel), nil)
	if err != nil {
		return err
	}
	var chanInfo channelInfo
	// 解码数据
	err = decode(v, &chanInfo)
	if err != nil {
		return err
	}

	// 删除
	for k, v := range chanInfo.MsgList {
		if v.ID == id {
			chanInfo.MsgList = append(chanInfo.MsgList[:k], chanInfo.MsgList[k+1:]...)
		}
	}

	buf, err := encode(&chanInfo)
	if err != nil {
		return err
	}
	err = db.Put([]byte(channel), buf, nil)
	if err != nil {
		return err
	}
	fmt.Println(chanInfo.MsgList)

	err = db.Delete([]byte(channel+"_"+id), nil)
	if err != nil {
		return err
	}

	pushMessageToClient(&Message{
		Type: "deleteMsg",
		Data: id,
	})

	return nil
}

func escape(s string) string {
	s = strings.Replace(s, "<{#}>", "\n", -1)
	s = strings.Replace(s, "<", "&lt;", -1)
	s = strings.Replace(s, ">", "&gt;", -1)
	return s
}

func toMarkdown(s string) string {
	// set up the HTML renderer
	htmlFlags := 0
	htmlFlags |= blackfriday.HTML_USE_XHTML
	renderer := blackfriday.HtmlRenderer(htmlFlags, "", "")

	// set up the parser
	extensions := 0
	extensions |= blackfriday.EXTENSION_NO_INTRA_EMPHASIS
	extensions |= blackfriday.EXTENSION_TABLES
	extensions |= blackfriday.EXTENSION_FENCED_CODE
	extensions |= blackfriday.EXTENSION_AUTOLINK
	extensions |= blackfriday.EXTENSION_STRIKETHROUGH
	extensions |= blackfriday.EXTENSION_SPACE_HEADERS
	extensions |= blackfriday.EXTENSION_HEADER_IDS

	s = string(blackfriday.Markdown([]byte(s), renderer, extensions))
	return s
}

func pushMessageToClient(msg *Message) {
	for _, sender := range wsClientList {
		sender <- msg
	}
}

type Message struct {
	Type string
	Data interface{}
}

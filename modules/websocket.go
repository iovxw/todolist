package modules

import (
	"log"
)

func WSMain(receiver <-chan *Message, sender chan<- *Message, done <-chan bool, disconnect chan<- int, errorChannel <-chan error) {
	// 生成id
	clientID := newID()
	// 将sender添加到客户端列表
	wsClientList[clientID] = sender
	for {
		select {
		case msg := <-receiver:
			log.Println(msg)
			switch msg.Type {
			case "new":
				err := newMessage(msg)
				if err != nil {
					// 处理错误
					switch err {
					case nilContentERR:
						sender <- &Message{
							Type: "error",
							Data: "发送的信息为空！发送失败",
						}
					default:
						log.Println("[newMessage]ERROR:", err)
						sender <- &Message{
							Type: "error",
							Data: "服务器发生内部错误！发送失败",
						}
					}
				}
			case "remove":
				err := removeMessage(msg)
				if err != nil {
					log.Println("[removeMessage]ERROR:", err)
					sender <- &Message{
						Type: "error",
						Data: "服务器发生内部错误！删除失败",
					}
				}
			default:
				log.Println("[WSMain]ERROR: unknown type", msg.Type)
			}
		//disconnect <- websocket.CloseNormalClosure
		case <-done:
			// 从客户端列表中删除
			delete(wsClientList, clientID)
			return
		case err := <-errorChannel:
			// Uh oh, we received an error. This will happen before a close if the client did not disconnect regularly.
			log.Println(err)
		}
	}
}

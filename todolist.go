package main

import (
	"log"
	"net/http"

	"github.com/Bluek404/todolist/modules"
	"github.com/Bluek404/todolist/tpl"

	"github.com/Unknwon/macaron"
	"github.com/macaron-contrib/sockets"
)

func main() {
	// 初始化模块
	err := modules.Initialize()
	if err != nil {
		log.Fatalln(err)
	}
	defer modules.Exit()

	m := macaron.Classic()
	m.Get("/", tpl.Index)
	m.Get("/ws", sockets.JSON(modules.Message{}), modules.WSMain)

	log.Println("Run Wordfalls on", modules.Config.Host+":"+modules.Config.Port)
	log.Println(http.ListenAndServe(modules.Config.Host+":"+modules.Config.Port, m))
}

package main

import (
	"log"
	"net/http"

	"github.com/Bluek404/todolist/modules"
	"github.com/Bluek404/todolist/tpl"

	sockets "github.com/beatrichartz/martini-sockets"
	"github.com/go-martini/martini"
)

func main() {
	// 初始化模块
	err := modules.Initialize()
	if err != nil {
		log.Fatalln(err)
	}
	defer modules.Exit()

	m := martini.Classic()
	m.Get("/", tpl.Index)
	m.Get("/ws", sockets.JSON(modules.Message{}), modules.WSMain)

	log.Println("Run todolist on", modules.Config.Host)
	log.Println(http.ListenAndServe(modules.Config.Host, m))
}

package modules

import (
	"log"
	"os"

	"github.com/syndtr/goleveldb/leveldb"
)

var wsClientList = make(map[string]chan<- *Message)

func Initialize() error {
	err := readConfig()
	if err != nil {
		return err
	}

	if Config.FirstRun {
		// 初始化数据库
		log.Println("Initialize database...")

		// 创建数据库文建夹
		err = os.Mkdir("db", 0700)
		if err != nil {
			return err
		}

		db, err = leveldb.OpenFile("db", nil)
		if err != nil {
			return err
		}

		// 初始化广场频道
		chanInfo := &channelInfo{
			Name:      "piazza",
			Password:  "",
			MsgIDList: []string{},
		}
		buf, err := encode(chanInfo)
		if err != nil {
			return err
		}
		err = db.Put([]byte("piazza"), buf, nil)
		if err != nil {
			return err
		}

		Config.FirstRun = false
		err = saveConfig()
		if err != nil {
			return err
		}

		log.Println("Initialize database [OK]")
	} else {
		// 加载数据库
		db, err = leveldb.OpenFile("db", nil)
		if err != nil {
			return err
		}
	}

	return nil
}

func Exit() {
	db.Close()
}

package modules

import (
	"bytes"
	"encoding/gob"

	"github.com/syndtr/goleveldb/leveldb"
)

var db *leveldb.DB

func GetContent(channel string) (list *[]contentInfo, err error) {
	// 读取channel数据
	v, err := db.Get([]byte(channel), nil)
	if err != nil {
		return nil, err
	}
	var chanInfo channelInfo
	// 解码数据
	err = decode(v, &chanInfo)
	if err != nil {
		return nil, err
	}

	return &chanInfo.MsgList, nil
}

func encode(data interface{}) ([]byte, error) {
	buf := bytes.NewBuffer(nil)
	enc := gob.NewEncoder(buf)
	err := enc.Encode(data)
	if err != nil {
		return nil, err
	}
	return buf.Bytes(), nil
}

func decode(data []byte, to interface{}) error {
	buf := bytes.NewBuffer(data)
	dec := gob.NewDecoder(buf)
	return dec.Decode(to)
}

type contentInfo struct {
	ID      string
	Color   int
	Content string
}
type channelInfo struct {
	Name     string
	Password string
	MsgList  []contentInfo
}

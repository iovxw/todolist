package modules

import (
	"bytes"
	"encoding/gob"

	"github.com/syndtr/goleveldb/leveldb"
)

var db *leveldb.DB

func GetContent(channel string) (list []*contentInfo, err error) {
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

	// 根据channel数据里存储的列表找到单条message的key
	for _, v := range chanInfo.MsgIDList {
		// 读取单条message
		msg, err := db.Get(append([]byte(channel+"_"), v...), nil)
		if err != nil {
			return nil, err
		}
		// 解码message
		var conInfo contentInfo
		err = decode(msg, &conInfo)
		if err != nil {
			return nil, err
		}

		conInfo.ID = string(v)
		list = append(list, &conInfo)
	}
	return list, nil
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
	Color   string
	Content string
}
type channelInfo struct {
	Name      string
	Password  string
	MsgIDList []string
}

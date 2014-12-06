package modules

import (
	"math/rand"
	"strconv"
	"time"
)

// 用于生成随机数
var r = rand.New(rand.NewSource(time.Now().UnixNano()))

// 生成随机ID
func newID() string { return strconv.FormatInt(r.Int63(), 36) }

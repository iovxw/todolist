package modules

import (
	"io/ioutil"

	"gopkg.in/v2/yaml"
)

var Config = new(cfg)

// 读配置文件
func readConfig() error {
	buf, err := ioutil.ReadFile("config.yaml")
	if err != nil {
		return err
	}
	err = yaml.Unmarshal(buf, Config)
	if err != nil {
		return err
	}

	return nil
}

// 保存配置文件
func saveConfig() error {
	buf, err := yaml.Marshal(Config)
	if err != nil {
		return err
	}
	err = ioutil.WriteFile("config.yaml", buf, 0700)
	if err != nil {
		return err
	}
	return nil
}

type cfg struct {
	FirstRun bool   `yaml:"firstRun"`
	Host     string `yaml:"host"`
}

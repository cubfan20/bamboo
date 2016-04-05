package haproxy

import (
	"github.com/QubitProducts/bamboo/Godeps/_workspace/src/github.com/samuel/go-zookeeper/zk"
	conf "github.com/QubitProducts/bamboo/configuration"
	"github.com/QubitProducts/bamboo/services/marathon"
	"github.com/QubitProducts/bamboo/services/service"
	"os"
	"strings"
)

type templateData struct {
	Apps     marathon.AppList
	Services map[string]service.Service
	Env      map[string]string
}

func GetTemplateData(config *conf.Configuration, conn *zk.Conn) (interface{}, error) {

	apps, err := marathon.FetchApps(config.Marathon)

	if err != nil {
		return nil, err
	}

	services, err := service.All(conn, config.Bamboo.Zookeeper)

	if err != nil {
		return nil, err
	}
	
	env := make(map[string]string)
	for _, i := range os.Environ() {
		sep := strings.Index(i, "=")
		env[i[0:sep]] = i[sep+1:]
	}

	return templateData{apps, services, env}, nil
}

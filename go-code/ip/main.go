package main

import (
	"bytes"
	"fmt"
	"io/ioutil"
	"net"
	"net/http"
)

func main() {
	fmt.Println(OuterIp, InnerIp)
}

func OuterIp() string {
	//res, err := http.Get("http://myexternalip.com/raw")
	res, err := http.Get("http://px.ktkt.com/myip")
	if err != nil {
		fmt.Println("Get Out ip err ", err.Error())
		return ""
	}
	defer res.Body.Close()

	data, err := ioutil.ReadAll(res.Body)
	if err != nil {
		fmt.Println("Get Out ip err ", err.Error())
		return ""
	}

	return string(bytes.TrimSpace(data))
}

func InnerIp() string {
	addrs, err := net.InterfaceAddrs()
	if err != nil {
		fmt.Println("Get Inner ip err ", err.Error)
		return ""
	}
	for _, a := range addrs {
		if ipnet, ok := a.(*net.IPNet); ok && !ipnet.IP.IsLoopback() {
			if ipnet.IP.To4() != nil {
				return ipnet.IP.String()
			}
		}
	}

	return ""
}

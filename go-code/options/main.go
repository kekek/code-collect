package options

import (
	"fmt"
	"net"
)

// Run Run
func Run(opts ...Option) {

	opt := Options{}

	for _, o := range opts {
		o(&opt)
	}

	lis, err := net.Listen("tcp", opt.Addr)
	if err != nil {
		panic(err)
	}

	fmt.Println(lis)
}


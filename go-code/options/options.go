package options

import (
	"context"

)

// Options Options
type Options struct {
	Addr string


	Ctx context.Context
}

// Option Option
type Option func(*Options)

// WithCtx WithCtx
func WithCtx(ctx context.Context) Option {
	return func(o *Options) {
		o.Ctx = ctx
	}
}

// WithAddr WithAddr
func WithAddr(addr string) Option {
	return func(o *Options) {
		o.Addr = addr
	}

}

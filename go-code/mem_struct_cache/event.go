package storage

import "errors"

var (
	ErrorListFull = errors.New("list is full")
)

type UserEvent struct {
	Id            int64  `json:"id" gorm:"column:id"`
	TraceId       string `json:"trace_id" gorm:"column:trace_id"`
	NanoTimeStamp int64  `json:"nano_time_stamp" gorm:"column:nano_time_stamp"` // 纳秒时间戳
	What          string `json:"what" gorm:"column:what"`
	When          string `json:"when" gorm:"column:when"`
	ClientVersion string `json:"client_version" gorm:"column:client_version"`
	ClientName    string `json:"client_name" gorm:"column:client_name"`

	DeviceUUID     string `json:"device_uuid" gorm:"column:device_uuid"`
	DeviceName     string `json:"device_name" gorm:"column:device_name"`
	DeviceVersion  string `json:"device_version" gorm:"column:device_version"`
	DeviceTimeZone string `json:"device_time_zone" gorm:"column:device_time_zone"` // local, "", utc, IANA Time Zone 规定的时区

	UaInfo string `json:"ua_info" gorm:"column:ua_info"`
	Ip     string `json:"ip" gorm:"column:ip"`
	Uid    int64  `json:"uid" gorm:"column:uid"`
}

func (u UserEvent) TableName() string {
	return "user_event"
}

type SliceUserEvent struct {
	list []*UserEvent
	off  int
	cap  int
}

func NewSliceUserEvent(capLen ...int) *SliceUserEvent {
	c := 0
	if len(capLen) > 0 {
		c = capLen[0]
	}

	return &SliceUserEvent{
		list: make([]*UserEvent, c, c),
		off:  0,
		cap:  c,
	}
}

func (s *SliceUserEvent) DataLen() int {
	return s.off
}

func (s *SliceUserEvent) DataCap() int {
	return s.cap
}

func (s *SliceUserEvent) Reset() {
	s.off = 0
}

func (s *SliceUserEvent) AppendInfo(info *UserEvent) error {

	if s.Full() {
		return ErrorListFull
	}

	s.list[s.off] = info
	s.off++

	return nil
}

func (s *SliceUserEvent) Full() bool {
	if s.off == s.DataCap() {
		return true
	}

	return false
}

func (s *SliceUserEvent) Data() []*UserEvent {
	res := make([]*UserEvent, s.off)
	copy(res[:], s.list[:s.off])
	return res
}

func (s *SliceUserEvent) Empty() bool {
	return s.off == 0
}

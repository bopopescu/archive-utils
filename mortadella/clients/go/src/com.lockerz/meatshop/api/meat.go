package api

import (
	"com.lockerz/meatshop/pbs"
	"code.google.com/p/goprotobuf/proto"
	"time"
)





func GetMeats() (chan *pbs.ListMeatsResponse) {
	c := make(chan *pbs.ListMeatsResponse)
	go func() {		
		time.Sleep(200 * time.Millisecond)
		c <- &pbs.ListMeatsResponse{
		Meats:[]*pbs.Meat{ 
			&pbs.Meat{Name:proto.String("ham")},
			&pbs.Meat{Name:proto.String("salami")}},}
	}();
	return c
}



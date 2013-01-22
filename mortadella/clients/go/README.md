Meatshop Go
-----------

this is all really early / various things are unfinished. 

##Installation instructions if you want to play:

1. Download go
Go to http://code.google.com/p/go/downloads/list and download the .tar.gz for your arch

```bash
# we will put /ext on your GOPATH later so 3rd party libs download to there
mkdir -p ~/opt/go/ext
cd ~/opt/go
tar -zxvf /Path/to/go1.0.3.darwin-amd64.tar.gz 
mv go go-1.0.3
```

2. Set up your gopath.
```
MEATSHOP_PATH="/Users/andrewm/git-repos/lockerz/lockerz-utils/mortadella/clients/go"
GO_EXT_PATH="/Users/andrewm/opt/go/ext"
GOROOT="/Users/andrewm/opt/go/go-1.0.3"
GOPATH="${GO_EXT_PATH}"
GOPATH="${GOPATH}:${MEATSHOP_PATH}

PATH="${GOROOT}/bin:${PATH}
PATH="${GO_EXT_PATH}/bin:${PATH}"
PATH="${MEATSHOP_PATH}/bin:${PATH}"

export GOROOT
export GOPATH
export PATH
```

3. Install the dependencies
```bash
go get github.com/gorilla/mux
go get github.com/gorilla/sessions
go get github.com/gorilla/schema
go get code.google.com/p/rsc/devweb/slave
go get code.google.com/p/rsc/devweb
```

4. Start the server
devweb com.lockerz/meatshop

5. Hit port http://localhost:8000


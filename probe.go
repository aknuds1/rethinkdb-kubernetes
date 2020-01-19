package main

import (
	"crypto/tls"
	"crypto/x509"
	"io/ioutil"
	"log"
	"os"

	r "gopkg.in/rethinkdb/rethinkdb-go.v6"
)

func main() {
	url := os.Getenv("RETHINKDB_URL")
	if url == "" {
		url = "localhost:28015"
	}

	caPemPath := os.Getenv("RETHINKDB_CA_CERT")
	if caPemPath == "" {
		log.Fatalln("You must provide $RETHINKDB_CA_CERT")
	}

	caPem, err := ioutil.ReadFile(caPemPath)
	if err != nil {
		log.Fatalln(err.Error())
	}

	username := "admin"
	password := os.Getenv("RETHINKDB_PASSWORD")

	certPool := x509.NewCertPool()
	if !certPool.AppendCertsFromPEM([]byte(caPem)) {
		log.Fatalln("Couldn't parse $RETHINKDB_CA_CERT")
	}
	session, err := r.Connect(r.ConnectOpts{
		Address:  url,
		Database: "rethinkdb",
		Username: username,
		Password: password,
		TLSConfig: &tls.Config{
			RootCAs: certPool,
		},
	})
	if err != nil {
		log.Fatalln(err.Error())
	}

	res, err := r.Table("server_status").Pluck("id", "name").Run(session)
	if err != nil {
		log.Fatalln(err.Error())
	}
	defer res.Close()

	if res.IsNil() {
		log.Fatalln("No server status results found")
	}

	log.Printf("A-OK!")
}

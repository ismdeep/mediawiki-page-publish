package main

import (
	"errors"
	"fmt"
	"io"
	"os"

	"cgt.name/pkg/go-mwclient"
)

var mediawikiEndpoint string
var username string
var password string

func init() {
	mediawikiEndpoint = os.Getenv("MEDIAWIKI_ENDPOINT")
	username = os.Getenv("MEDIAWIKI_USERNAME")
	password = os.Getenv("MEDIAWIKI_PASSWORD")
}

func main() {
	pageTitle := os.Args[1]

	// Initialize a *Client with New(), specifying the wiki's API URL
	// and your HTTP User-Agent. Try to use a meaningful User-Agent.
	w, err := mwclient.New(fmt.Sprintf("%v/api.php", mediawikiEndpoint), "IE11")
	if err != nil {
		fmt.Printf("[ERROR] failed to create mediawiki client, err: %v\n", err.Error())
		os.Exit(1)
	}

	// Log in.
	err = w.Login(username, password)
	if err != nil {
		fmt.Printf("[ERROR] failed to login, err: %v\n", err.Error())
		os.Exit(1)
	}

	content, err := io.ReadAll(os.Stdin)
	if err != nil {
		fmt.Printf("[ERROR] failed to read from stdin, err: %v\n", err.Error())
		os.Exit(1)
	}

	// Specify parameters to send.
	parameters := map[string]string{
		"action": "edit",
		"title":  pageTitle,
		"text":   string(content),
	}

	// Make the request.
	if err := w.Edit(parameters); err != nil && !errors.Is(err, mwclient.ErrEditNoChange) {
		fmt.Printf("[ERROR] failed to edit page, page: %v, err: %v\n", pageTitle, err.Error())
		os.Exit(1)
	}

	fmt.Printf("[INFO] successfully edit page: %v\n", pageTitle)
}

package main

import (
	"fmt"

	_ "github.com/gin-gonic/gin"
	_ "github.com/go-resty/resty/v2"
	_ "github.com/sirupsen/logrus"
	_ "github.com/spf13/cobra"
	_ "github.com/stretchr/testify/assert"
)

func main() {
	fmt.Println("Hello from go-mod")
}

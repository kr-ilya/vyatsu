package main

import (
	"fmt"
	"os"
)

func main() {
	f, err := os.OpenFile("test.txt", os.O_APPEND|os.O_WRONLY, 0600)
	if err != nil {
		panic(err)
	}
	defer f.Close()

	if _, err = f.WriteString("Z(12)\nZ(13)\nZ(22)\n"); err != nil {
		panic(err)
	}
	for i := 1; i <= 10; i++ {

			if _, err = f.WriteString(
				fmt.Sprintf("Z(11)\nZ(16)\nZ(21)\n\nJ(%d, 11, %d)\nS(11)\nS(21)\nJ(%d, 11, %d)\nS(11)\nJ(1, 1, %d)\n\nJ(21, 22, %d)\nJ(%d, 16, %d)\nS(13)\nS(16)\nJ(1, 1, %d)\n\nJ(%d, 16, %d)\nS(12)\nS(16)\nJ(1, 1, %d)\n\n",i, 18*i-5, i, 18*i-5, 6+18*(i-1), 18*i, i, 4+18*i, 18*i-4, i, 4+18*i, 18*i)); err != nil {
				panic(err)
			}
	}
}



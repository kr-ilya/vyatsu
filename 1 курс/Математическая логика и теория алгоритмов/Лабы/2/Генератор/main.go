package main

import (
	"fmt"
	"os"
)

func defs(a int, b int, c int, col int) [6]int {
	var ar [6]int

	var g = [3][3][3]int{
		{{1, 6}, {3, 5}, {2, 4}},
		{{2, 5}, {1, 4}, {3, 6}},
		{{3, 4}, {2, 6}, {1, 5}},
	}

	for j := 0; j <= 1; j++ {
		ar[g[col][0][j]-1] = a
		ar[g[col][1][j]-1] = b
		ar[g[col][2][j]-1] = c
	}

	return ar

}

func main() {
	f, err := os.OpenFile("test.txt", os.O_APPEND|os.O_WRONLY, 0600)
	if err != nil {
		panic(err)
	}
	defer f.Close()

	var z = [8][3]int{
		{0, 0, 0},
		{0, 0, 1},
		{0, 1, 0},
		{0, 1, 1},
		{1, 0, 0},
		{1, 0, 1},
		{1, 1, 0},
		{1, 1, 1},
	}

	var r [3][8][8][8][6]int

	var ip = [3]int{
		1, 2,
	}

	var ot = [64][6]int{
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 1},
		{0, 0, 0, 0, 1, 0},
		{0, 0, 0, 0, 1, 1},
		{0, 0, 0, 1, 0, 0},
		{0, 0, 0, 1, 0, 1},
		{0, 0, 0, 1, 1, 0},
		{0, 0, 0, 1, 1, 1},
		{0, 0, 1, 0, 0, 0},
		{0, 0, 1, 0, 0, 1},
		{0, 0, 1, 0, 1, 0},
		{0, 0, 1, 0, 1, 1},
		{0, 0, 1, 1, 0, 0},
		{0, 0, 1, 1, 0, 1},
		{0, 0, 1, 1, 1, 0},
		{0, 0, 1, 1, 1, 1},
		{0, 1, 0, 0, 0, 0},
		{0, 1, 0, 0, 0, 1},
		{0, 1, 0, 0, 1, 0},
		{0, 1, 0, 0, 1, 1},
		{0, 1, 0, 1, 0, 0},
		{0, 1, 0, 1, 0, 1},
		{0, 1, 0, 1, 1, 0},
		{0, 1, 0, 1, 1, 1},
		{0, 1, 1, 0, 0, 0},
		{0, 1, 1, 0, 0, 1},
		{0, 1, 1, 0, 1, 0},
		{0, 1, 1, 0, 1, 1},
		{0, 1, 1, 1, 0, 0},
		{0, 1, 1, 1, 0, 1},
		{0, 1, 1, 1, 1, 0},
		{0, 1, 1, 1, 1, 1},
		{1, 0, 0, 0, 0, 0},
		{1, 0, 0, 0, 0, 1},
		{1, 0, 0, 0, 1, 0},
		{1, 0, 0, 0, 1, 1},
		{1, 0, 0, 1, 0, 0},
		{1, 0, 0, 1, 0, 1},
		{1, 0, 0, 1, 1, 0},
		{1, 0, 0, 1, 1, 1},
		{1, 0, 1, 0, 0, 0},
		{1, 0, 1, 0, 0, 1},
		{1, 0, 1, 0, 1, 0},
		{1, 0, 1, 0, 1, 1},
		{1, 0, 1, 1, 0, 0},
		{1, 0, 1, 1, 0, 1},
		{1, 0, 1, 1, 1, 0},
		{1, 0, 1, 1, 1, 1},
		{1, 1, 0, 0, 0, 0},
		{1, 1, 0, 0, 0, 1},
		{1, 1, 0, 0, 1, 0},
		{1, 1, 0, 0, 1, 1},
		{1, 1, 0, 1, 0, 0},
		{1, 1, 0, 1, 0, 1},
		{1, 1, 0, 1, 1, 0},
		{1, 1, 0, 1, 1, 1},
		{1, 1, 1, 0, 0, 0},
		{1, 1, 1, 0, 0, 1},
		{1, 1, 1, 0, 1, 0},
		{1, 1, 1, 0, 1, 1},
		{1, 1, 1, 1, 0, 0},
		{1, 1, 1, 1, 0, 1},
		{1, 1, 1, 1, 1, 0},
		{1, 1, 1, 1, 1, 1},
	}

	first := true
	two := true
	for col := 1; col <= 3; col++ {

		if _, err = f.WriteString(fmt.Sprintf("%d: {\n", col-1)); err != nil {
			panic(err)
		}

		for i := 0; i < 8; i++ {
			g := 8

			first = true
			t := defs(z[i][0], z[i][1], z[i][2], col-1)
			for l := 0; l < g; l++ {
				su := 8
				two = true
				for u := 0; u < su; u++ {
					r[col-1][i][l][u] = t
					tn := t

					if col > 1 {
						for k := 0; k < 6; k++ {
							if t[k] > r[col-2][l][u][u][k] {
								tn[k] = 0
							}
						}
					}
					r[col-1][i][l][u] = tn

					if (col == 1) && (first == true) {
						first = false
						if _, err = f.WriteString(
							fmt.Sprintf(
								"(%d, %d, %d, ~, ~, ~, ~, ~, ~, ~, ~) = (~, ~, ~, %d, %d, %d, %d, %d, %d, ~, ~) -> %d, (r, r, r, s, s, s, s, s, s, s, s)\n",
								z[i][0], z[i][1], z[i][2], tn[0], tn[1], tn[2], tn[3], tn[4], tn[5], col)); err != nil {
							panic(err)
						}

						if _, err = f.WriteString(
							fmt.Sprintf(
								"(%d, %d, %d, ~, ~, ~, ~, ~, ~, -, ~) = (%d, %d, %d, ~, ~, ~, ~, ~, ~, ~, ~) -> %d, (s, s, s, s, s, s, s, s, s, r, s)\n",
								z[i][0], z[i][1], z[i][2], z[i][0], z[i][1], z[i][2], col-1)); err != nil {
							panic(err)
						}

						if _, err = f.WriteString(
							fmt.Sprintf(
								"(%d, %d, %d, ~, ~, ~, ~, ~, ~, %d, ~) = (%d, %d, %d, ~, ~, ~, ~, ~, ~, ~, ~) -> %d, (s, s, s, s, s, s, s, s, s, s, s)\n",
								z[i][0], z[i][1], z[i][2], 0, z[i][0], z[i][1], z[i][2], col-1)); err != nil {
							panic(err)
						}

						for pp := 0; pp < 2; pp++ {
							if _, err = f.WriteString(
								fmt.Sprintf(
									"(%d, %d, %d, ~, ~, ~, ~, ~, ~, %d, ~) = (%d, %d, %d, ~, ~, ~, ~, ~, ~, ~, ~) -> %d, (s, s, s, s, s, s, s, s, s, s, s)\n",
									z[i][0], z[i][1], z[i][2], ip[pp], z[i][0], z[i][1], z[i][2], col-1)); err != nil {
								panic(err)
							}
						}
					} else if (col == 2) && (two == true) || (col == 3) {
						two = false
						if _, err = f.WriteString(
							fmt.Sprintf(
								"(%d, %d, %d, %d, %d, %d, %d, %d, %d, ~, ~) = (~, ~, ~, %d, %d, %d, %d, %d, %d, ~, ~) -> %d, (r, r, r, s, s, s, s, s, s, s, s)\n",
								z[i][0], z[i][1], z[i][2], r[col-2][l][u][u][0], r[col-2][l][u][u][1], r[col-2][l][u][u][2], r[col-2][l][u][u][3], r[col-2][l][u][u][4], r[col-2][l][u][u][5], tn[0], tn[1], tn[2], tn[3], tn[4], tn[5], col)); err != nil {
							panic(err)
						}
					}
				}
			}
		}
		if _, err = f.WriteString("}\n"); err != nil {
			panic(err)
		}
	}

	if _, err = f.WriteString("3: {\n"); err != nil {
		panic(err)
	}
	for q := 0; q < 64; q++ {
		res := ot[q][0] + ot[q][1] + ot[q][2] - ot[q][3] - ot[q][4] - ot[q][5]
		if res >= 0 {
			if _, err = f.WriteString(
				fmt.Sprintf(
					"(~, ~, ~, %d, %d, %d, %d, %d, %d, ~, ~) = (~, ~, ~, ~, ~, ~, ~, ~, ~, %d, ~) -> 10, (s, s, s, s, s, s, s, s, s, s, s)\n",
					ot[q][0], ot[q][1], ot[q][2], ot[q][3], ot[q][4], ot[q][5], res)); err != nil {
				panic(err)
			}
		} else {
			if _, err = f.WriteString(
				fmt.Sprintf(
					"(~, ~, ~, %d, %d, %d, %d, %d, %d, ~, ~) = (~, ~, ~, %d, %d, %d, %d, %d, %d, -, 1) -> 3, (s, s, s, s, s, s, s, s, s, r, s)\n",
					ot[q][0], ot[q][1], ot[q][2], ot[q][3], ot[q][4], ot[q][5], ot[q][0], ot[q][1], ot[q][2], ot[q][3], ot[q][4], ot[q][5])); err != nil {
				panic(err)
			}
			if _, err = f.WriteString(
				fmt.Sprintf(
					"(~, ~, ~, %d, %d, %d, %d, %d, %d, ~, 1) = (~, ~, ~, ~, ~, ~, ~, ~, ~, %d, ~) -> 10, (s, s, s, s, s, s, s, s, s, l, s)\n",
					ot[q][0], ot[q][1], ot[q][2], ot[q][3], ot[q][4], ot[q][5], res*(-1))); err != nil {
				panic(err)
			}
		}
	}
	if _, err = f.WriteString("}\n"); err != nil {
		panic(err)
	}
}

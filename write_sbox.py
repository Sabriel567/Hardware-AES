sbox = """
2b 28 ab 09
7e ae f7 cf
15 d2 15 4f
16 a6 88 3c
"""
row = 0
for i in sbox.splitlines():
  col = 3
  for l in i.split():
    print("in[{1}][{2}:{3}] <= 8'h{0};".format(l, row-1, ((col+1)*8)-1, col*8 ), end="")
    col = col - 1
  print("\n",end="")
  row = row + 1


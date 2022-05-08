import sys

def charify(s):
    if s.startswith("0x"):
        return int(s[2:], 16)
    elif s.startswith("0b"):
        return int(s[2:], 2)
    elif len(s) == 8:
        return int(s, 2)
    else:
        return int(s)

print("Run `hexdump -C [file]` to view the file")
print("Or xxd -g1 -c8 [file]")
print("Type `a` to append bytes, type `d` to delete a byte (d+ also supported), or type `e` to edit a byte")
with open(sys.argv[1], "rb") as file:
    data = file.read()
    #print(data)
    #print(type(data))
    #print(data + bytes([5]))
mode=input()
if mode == 'a':
    print("Input bytes to append to file. They should be separated by spaces, and can be in binary (0b01010101 or 01010101), decimal (57), or hexadecimal (0x8c)")
    i = input()
    nums = [charify(x) for x in i.split(" ")]
    b = bytes(nums)
    with open(sys.argv[1], "wb") as file:
        file.write(data + b)
elif mode == 'd':
    print("Give the hex address of the byte to delete")
    i = input()
    num = int(i, 16)
    print("Are you sure you want to delete " + hex(data[num]) + " at address " + hex(num) + "?")
    if input().startswith("y"):
        del data[num]
        with open(sys.argv[1], "wb") as file:
            file.write(data)
elif mode == 'e':
    print("Give the hex address of the byte to edit")
    i = input()
    num = int(i, 16)
    data=bytearray(data)
    data[num] = charify(input())
    with open(sys.argv[1], "wb") as file:
        file.write(data)
elif mode == 'd+':
    print("Give the hex address of the byte to start deleting at")
    i = input()
    num = int(i, 16)
    data=bytearray(data)
    del data[num:]
    with open(sys.argv[1], "wb") as file:
        file.write(data)

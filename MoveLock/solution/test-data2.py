cp = [[4, 15, 11], [0, 13, 4], [19, 19, 19]]
ct = [[19, 11, 18], [16, 9, 2], [17, 21, 3]]
solution = []
for i in range(len(cp)):
    found = False
    for a in range(0, 100):
        for b in range(0, 100):
            for c in range(0, 100):
                if ( cp[0][0] * a + cp[0][1] * b + cp[0][2] * c) % 26 == ct[i][0] \
                    and (cp[1][0] * a + cp[1][1] * b + cp[1][2] * c) % 26 == ct[i][1] \
                    and (cp[2][0] * a + cp[2][1] * b + cp[2][2] * c) % 26 == ct[i][2]:
                    # print(a, b, c)
                    solution.append(a)
                    solution.append(b)
                    solution.append(c)
                    found = True
                    break
            if found:
                break
        if found:
            break

print(solution)

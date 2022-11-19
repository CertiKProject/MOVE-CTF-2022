results= [[22, 7, 4], [25, 21, 5], [7, 23, 6], [23, 5, 13], [3, 5, 9], [16, 12, 22], [14, 3, 14], [12, 22, 18], [4, 3, 9], [2, 19, 5], [16, 7, 20], [1, 11, 18], [23, 4, 15], [20, 5, 24], [9, 1, 12], [5, 16, 10], [7, 2, 1], [21, 1, 25], [18, 22, 2], [2, 7, 25], [15, 7, 10]]
solution = []
for i in range(len(results)):
    found = False
    for a in range(0, 100):
        for b in range(0, 100):
            for c in range(0, 100): 
                if (25 * a + 11 * b + 6 * c) % 26 == results[i][0] and (10 * a + 13 * b + 25 * c) % 26 == results[i][1] and (12 * a + 19 * b + 2 * c) % 26 == results[i][2]:
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


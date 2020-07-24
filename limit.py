import math

def cumulativeProductOfCosTerms():
    gain = 1

    for i in range(0,32):
        m = 1.0 / (1<<i)        # 2^-i
        angle = math.atan(m)    # work out the angle which will allow
                                # us to shift instead of multiplying
        gain *= math.cos(angle) # cumulative product
        print(i,gain)

    return gain

og = cumulativeProductOfCosTerms() ;

og = 0.6072529350088814
tol = 0.0001
print("Overall Gain",og, "Tolerance required",tol)

for i in range(0,128):
    m = 1.0 / (1<<i)
    if (m < og):
        og = og - m
        print("Use Power Index 2^-i where i = ",i)
    if (og < tol):
        break

#for i in range(0,32):
#    m = 1.0 / (1 << i)
#    print(m)

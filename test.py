import math
from array import *
# CORDIC Algorithm
# Compute SINE and COSINE without multiplying.
# Function will be a series of adds and shifts.
# Johnny Wilson Sussex, Brighton July 2020
_FPSHIFT = 28


def fp(val):
   return (int)(val * (1<<_FPSHIFT))

def ufp(val):
    return (1.0 * val) / (1 << _FPSHIFT)

# 'Pseudo' Rotation - out by a factor of
# 1/cos(atan(angle))

def rotateVector(direction,x,y,sr):
    #d = 1 if (ang > 0) else -1  (direction)
    #m = fp(1.0 / (1<<sr))
    #aang = abs(ang)

    # Since we are removing the 'cos' function
    # from our rotation matrix - we
    # need to deal with overall gain (1/0.607252935009) by making
    # sure we start with a magnitude of 0.607252935009

    # If we consider the 'true' 2D rotation, with its cosine factor -
    # cosa = cos(atan(m)) = cos(atan(2^-i)) where i=0,1,2,3,...(bitRes - 1)
    # to work out cos(atan(2^-i)) - draw a right angled triangle
    #with sides 1 (base) and 2^-i (height). The hypotonuse is
    # SQRT(1 + 2^-i) Pythag thereom
    # tan (th) = 2^-i / 1 --> th = atan(2^-i) = acos(1/SQRT(1 + 2^-i))
    # so cos(atan(2^-i)) = cos(acos(1/SQRT(1 + 2^-i))) = 1/SQRT(1 + 2^-i)

    # so the overall 'gain' when we iterate with the function
    # rotateVector is the product of the cosa terms
    #i.e PRODUCT( 1 / SQRT(1 + 2^-i), i=0...bitRes - 1)
    # This accumulative product quickly converges to ~0.607252935009
    # so we can effectively take the cosa term out of our conventional 2D
    # rotation formulae
    #
    #    newx = x * cosa - d * y * sina
    #    newy = d * x * sina + y * cosa

    # We must make sure that our starting vector has a magnitude of
    # 0.607252935009 - (making sure that our iteration sequence
    # uses the set of 'Tangent' values which give us powers of 2. (2^-i)

    # Our 2D 'Rotation' which places are vector at the correct angle
    # but will increase the length by 1 / cos(atan(1/(1<<sr)))

    if (direction == 1):
        nx = ( x  - (y >> sr))
        ny = ((x  >> sr) + y)
    else:
        nx = ( x  + (y >> sr))
        ny = (y - (x  >> sr))

    return nx,ny

def calcRadians(angleInDegrees):
    return angleInDegrees * math.pi / 180.0

def calcDegrees(angleInRadians):
    return 180.0 * angleInRadians / math.pi

def lookupAngleFromAtan(index):
    return atan[index]

def iterateSinCos(wantedAngle):
    return iterateSinCosQuad1(wantedAngle)

def iterateSinCosQuad1(wantedAngle):

    # Start off with an appropriate vector depending on the quadrant
    # our required angle is.

    if (wantedAngle > fp(calcRadians(270))):
        currentAngle = fp(calcRadians(270))
        ny = fp(0)
        nx = -fp(0.6072529350088814)     # start off with 1/gain
    elif (wantedAngle > fp(calcRadians(180))):
        currentAngle = fp(calcRadians(180))
        nx = fp(0)
        ny = -fp(0.6072529350088814)     # start off with 1/gain
    elif (wantedAngle > fp(calcRadians(90))):
        currentAngle = fp(calcRadians(90))
        ny = fp(0)
        nx = fp(0.6072529350088814)     # start off with 1/gain
    else:
        currentAngle = fp(0)
        nx = fp(0)
        ny = fp(0.6072529350088814)     # start off with 1/gain

    # Lim (Accumulative Product(1 / sqrt(1 + 2^-2i)), i=0,..31)

    for itern in range(0,31):

        angle = lookupAngleFromAtan(itern)
        #print("current angle", currentAngle);
        if (currentAngle < wantedAngle):
            currentAngle = currentAngle + angle
            #print "it: %d Rotate clock by Angle %f to %f" % (itern,calcDegrees(ufp(angle)),calcDegrees(ufp(currentAngle)))
            #print("currentAngle %x",currentAngle) ;
            nx,ny = rotateVector(-1,nx,ny,itern)
        else:
            currentAngle = currentAngle - angle
            #print "it: %d Rotate anti by Angle %f to %f" % (itern,calcDegrees(ufp(angle)),calcDegrees(ufp(currentAngle)))
            nx,ny = rotateVector(1,nx,ny,itern)

    return nx,ny,currentAngle

def generateAtanTable():
    atanTbl = array('L',[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0])

    gain = 1
    for i in range(0,31):
        m = 1.0 / (1<<i)        # 2^-i
        angle = math.atan(m)    # work out the angle which will allow
                                    # us to shift instead of multiplying
        fangle  =fp(angle)
        atanTbl[i] = fangle
        print("assign atan[%02d]  = 32'b%s ;" % (i,format(fangle, '031b')))

    return atanTbl

atan = generateAtanTable()
bad = 0
tol = 0.0000001

print "Starting Test..."
parts = 100
testsCompleted = 0
minSin = 1
maxSin = -1
for degTest in range(0 * parts,360 * parts):
    testsCompleted+=1 ;
    exampleAngleInDegrees = 1.0 * degTest / parts
    #print(exampleAngleInDegrees)
    wantedAngle = fp(calcRadians(exampleAngleInDegrees))
    sinA,cosA,finalAngle = iterateSinCos(wantedAngle)

    if (sinA > maxSin):
        maxSin = sinA
    if (sinA < minSin):
        minSin = sinA

    errSin = abs(ufp(sinA) - math.sin(ufp(wantedAngle)))
    errCos = abs(ufp(cosA) - math.cos(ufp(wantedAngle)))

    if (errSin >  tol or errCos > tol):
        bad += 1
        print "Bad Approx Angle %f ErrSin %f ErrCos %f finalAngle %f" % (exampleAngleInDegrees,errSin,errCos,calcDegrees(ufp(finalAngle)))

print "Bad approximations %d  out of %d" % (bad, testsCompleted)
print "Min Sin %d Max Sin %d" % (minSin, maxSin)
print "%s" % (format(maxSin, '032b'))

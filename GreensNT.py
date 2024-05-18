#Greens Function visualized in Python

import numpy as np
from scipy.integrate import odeint
import matplotlib.pyplot as plt
import math

g1 = []
g2 = []

h1 = []
h2 = []

def homo_1(x):
    return (3/2)-((3/4)*math.exp(-2*x))

def homo_2(x):
    return -4 * math.cos(x)

# Define the differential equation for y'' + 2y' + 2 = 2x
'''
def diff_eq_1(y, x):
    y0, y1 = y
    dydx = [-y1, 2 - 2*x - 2*y1]
    return dydx
    '''

# Define the differential equation for y'' + y = 4
'''
def diff_eq_2(y, x):
    y0, y1 = y
    dydx = [y1, 4 - y0]
    return dydx
    '''

# Set initial conditions and range of x values
y0 = [0, 0]
x = np.linspace(0, 1, 100)

def gfunc_1(x):
    return ((math.pow(x, 2))/2) -((3*x)/2)+(3/4)-((3*(math.exp(-2*x)))/4)

def gfunc_2(x):
    return -4 * math.cos(x) + 4

for i in range(100):
    g1.append(gfunc_1(i))
    g2.append(gfunc_2(i))

    h1.append(homo_1(i))
    h2.append(homo_2(i))
# Plot the solutions
#plt.figure(1)
#plt.plot(x, g1, label='Green Solution 1')
#plt.legend(loc='best')
#plt.xlabel('x')
#plt.ylabel('y')
#plt.grid()

plt.figure(2)
plt.plot(x, g2, label='Green Solution 2')
plt.legend(loc='best')
plt.xlabel('x')
plt.ylabel('y')
plt.grid()

#plt.figure(3)
#plt.plot(x, h1, label ='Homogeneous Equation 1')
#plt.legend(loc='best')
#plt.xlabel('x')
#plt.ylabel('y')
#plt.grid()

plt.figure(4)
plt.plot(x, h2, label = 'Homogeneous Equation 2')
plt.legend(loc='best')
plt.xlabel('x')
plt.ylabel('y')
plt.grid()

plt.tight_layout()
plt.show()

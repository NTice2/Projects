import math
import numpy as np
from scipy.integrate import odeint
import matplotlib.pyplot as plt

x0 = 2.0
y0 = 1.0
h = 0.3
iterations = 300
y_runge = []
x_runge = []
x_ode = []
y_ode = []

# function that returns dy/dx
def model(y, x):
    y_ode.append(y)
    x_ode.append(x)
    dydx = -y + math.log(x, math.e)
    return dydx

def rungekutta(x0, y0, h):
    #model function
    k1 = f(x0, y0)
    k2 = f(x0 + h/2, y0 + ((h/2) * k1))
    k3 = f(x0 + h/2, y0 + ((h/2) * k2))
    k4 = f(x0 + h, y0 + h * k3)
    T4 = 1/6 * (k1 + 2*k2 + 2*k3 + k4)
    y1 = y0 + h * T4
    print("yn\t\t\txn")
    print('%.4f\t%.4f' % (y0,x0))
    return y1

def f(x,y):
    fxy = -y + math.log(x, math.e)
    return fxy

#need to increase x by h each time and store y in an array.
for i in range(1,1001):
    y0 = rungekutta(x0,y0,h)
    y_runge.append(y0)
    x_runge.append(x0)
    x0 = x0 + h;    # noqa

# initial condition
y0 = 1
#points
x = np.linspace(2,iterations,301)
# solve ODEs
y1 = odeint(model,y0,x)


plt.plot(x, y1)
plt.title('ODE Graph')
plt.xlabel('time')
plt.ylabel('y-vals')
#plt.xlim([min(x), max(x)])
#plt.ylim([min(y1), max(y1)])
plt.show()

plt.plot(x_runge, y_runge)
plt.title('Runge Kutta Graph')
plt.xlabel('time')
plt.ylabel('y-vals')
#plt.xlim([min(x_runge), max(x_runge)])
#plt.ylim([min(y_runge), max(y_runge)])
plt.show()


plt.plot(x,y1, label= "ODE",linestyle="-.")
plt.title('Runge vs ODE')
plt.plot(x_runge,y_runge, label = "Runge Kutta",linestyle="--")
plt.xlim([min(x_runge), max(x_runge)])
plt.ylim([min(y_runge), max(y_runge)])
plt.legend()
plt.show()

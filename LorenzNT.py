import numpy as np
import matplotlib.pyplot as plt

def lorenz(xyz,*, s=10, r=28, b=2.667): # noqa
    """
    Parameters
    ----------
    xyz : array-like, shape (3D)
       Point of interest in three-dimensional space.
    s, r, b : float
       Parameters defining the Lorenz attractor.

    Returns
    -------
    xyz_dot : array, shape (3D)
       Values of the Lorenz attractor's partial derivatives atxyz.
    """
    x, y, z = xyz
    x_dot = s*(y - x) # noqa
    y_dot = r*x - y - x*z
    z_dot = x*y - b*z
    return np.array([x_dot, y_dot, z_dot])


dt = 0.01
num_steps = 10000
rs = [11, 15, 19]  # Define the values of r to plot, incremented by 4 to show dynamic chaos difference

# Loop over the values of r
for r in rs:
    xyzs = np.empty((num_steps + 1, 3))  # Need one more for the initial values
    xyzs[0] = (0, 15.27, 20)  # Set initial values, these are chosen to give best visual results
    # Step through "time", calculating the partial derivatives at the current point
    # and using them to estimate the next point
    for i in range(num_steps):
        xyzs[i + 1] = xyzs[i] + lorenz(xyzs[i], r=r) * dt # noqa

    # Plot the x component
    fig, ax = plt.subplots()
    ax.plot(xyzs[:, 0], lw=0.5)
    ax.set_xlabel("Time Step")
    ax.set_ylabel("X Coordinate")
    ax.set_title(f"Lorenz Attractor: X Component (r = {r})")

    # Plot the y component
    fig, ax = plt.subplots()
    ax.plot(xyzs[:, 1], lw=0.5)
    ax.set_xlabel("Time Step")
    ax.set_ylabel("Y Coordinate")
    ax.set_title(f"Lorenz Attractor: Y Component (r = {r})")

    # Plot the z component
    fig, ax = plt.subplots()
    ax.plot(xyzs[:, 2], lw=0.5)
    ax.set_xlabel("Time Step")
    ax.set_ylabel("Z Coordinate")
    ax.set_title(f"Lorenz Attractor: Z Component (r = {r})")

    # Plot the 3D attractor
    fig = plt.figure()
    ax = fig.add_subplot(projection='3d')
    ax.plot(*xyzs.T, lw=0.5)
    ax.set_xlabel("X Axis")
    ax.set_ylabel("Y Axis")
    ax.set_zlabel("Z Axis")
    ax.set_title(f"Lorenz Attractor (r = {r})")

plt.show()
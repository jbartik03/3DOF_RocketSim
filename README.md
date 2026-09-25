# 3DOF Rocket Flight Dynamics Simulator

## Overview

This repository contains a three-degree-of-freedom (3DOF) rocket flight dynamics simulator developed as part of undergraduate aerospace modeling and simulation research at the University of North Florida.

The simulator was developed to evaluate the trajectory, velocity, and aerodynamic behavior of the Black Brant VC sounding rocket using a mathematical framework consisting of 7 coupled nonlinear differential equations. The model captures translational motion throughout powered and unpowered flight while incorporating aerodynamic drag, changing mass properties, and atmospheric effects. This simulator served as an intermediate step in the development of progressively higher-fidelity rocket dynamics models culminating in a 6DOF rigid-body simulation framework.

---

## Features
* Three-degree-of-freedom translational flight dynamics simulation.
* Numerical integration of coupled nonlinear differential equations.
* Dynamic drag coefficient calculations throughout flight.
* Time-varying mass and center-of-gravity tracking during propellant consumption.
* Atmospheric modeling including changes in air density, gravity, and temperature with altitude.
* User-configurable launch conditions and vehicle geometry.
* Thrust curve integration using measured propulsion data.
* Modular plotting and post-processing utilities for simulation analysis.
* Trajectory prediction through powered ascent, coast, and descent phases.

---

## Technical Topics

* Aerospace Modeling & Simulation
* Flight Dynamics
* Trajectory Analysis
* Rocket Performance Analysis
* Mathematical Modeling
* Nonlinear Differential Equations
* Numerical Integration
* Aerodynamics
* Scientific Computing
* Verification & Validation
* MATLAB Simulation

---

## Model Assumptions

* The vehicle is modeled as an axisymmetric, rigid body rocket.
* Rotational dynamics are two-dimentional (pitch only).
* Aerodynamic drag is included throughout flight.
* Atmospheric properties vary with altitude.
* Structural flexibility and propellant slosh effects are neglected.
* Vehicle geometry remains constant throughout flight.

---

## Inputs

Vehicle and mission parameters are specified through the `rocket3dof.m` file.

Configurable parameters include:

* Initial launch angle
* Vehicle diameter
* Nose length
* Total vehicle length
* Fin root chord
* Fin tip chord
* Fin span
* Fin position
* Dry mass
* Initial propellant mass
* Specific impulse
* Dry center of gravity location
* Forward and aft propellant locations

---

## Outputs

### Trajectory Results

* Altitude (m)
* Downrange distance (m)
* Velocity (m/s)
* Vertical velocity (m/s)
* Horizontal velocity (m/s)
* Total Velocity

### Stability Results

* Pitch attitude (rad)
* Pitching rate (rad/s)
* Flight path angle (rad)
* Angle of attack (rad)

### Flight Performance Metrics

* Maximum altitude
* Maximum velocity
* Burnout conditions
* Flight time

---

## Validation

Simulation outputs were compared against RASAeroII trajectory predictions to verify model behavior and ensure consistency with established aerospace analysis tools.

---

## Repository Structure

```text
Functions/
    Supporting MATLAB functions and dynamics routines

Results/
    Example simulation output plots

ROCKET_SIMULATOR_3DOF.m
    Primary simulation execution file

plot3DOFresults.m
    Supporting MATLAB function for simulation results

rocket3dof.m
    Primary function for integration of ODE system
```

---

## Example Results

Representative simulation outputs are provided in the `Results` directory.

These include trajectory, velocity, aerodynamic performance, and flight condition plots generated during Black Brant VC flight simulations.

---

## Research Context

This simulator represents an intermediate-fidelity rocket dynamics model developed as part of a broader research effort investigating increasingly sophisticated mathematical formulations for rocket trajectory and passive dynamic stability analysis. The project progression included 2DOF, 3DOF, 4DOF, 5DOF and 6DOF flight dynamics models of increasing complexity and fidelity.

---

## Citation

If referencing this work, please cite:

Bartik, J (2026) Mathematical Models for Coupling Rocket Trajectory and Passive Stability, *AJUR* Vol 23, Issue 3, 182. https://doi.org/10.33697/ajur.2026.182

---

## Author

Jonathan A. Bartik

B.S. Applied Mathematics, Computing Minor

University of North Florida

Created: 2026

Original work developed as part of undergraduate aerospace modeling and simulation research at the University of North Florida.

Copyright © 2026 Jonathan A. Bartik. All rights reserved.

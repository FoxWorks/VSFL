Status
--------------------------------------------------------------------------------
The server is a work-in-progress, and as such is not yet actually useful.

Virtual SpaceFLight Network Server
--------------------------------------------------------------------------------
VSFL Network is a server-side simulator to provide a realtime virtual low-earth orbit
simulation, including digital radio simulation.

The VSFL Network will allow anybody to launch their own virtual models of satellites,
communicate to the existing satellites over simulated radio. The target audience
is aspiring satellite engineers and space software developers.

Technical Information
--------------------------------------------------------------------------------
VSFL Server is supposed to run on a dedicated multi-core server (at least 2 cores
required), with sufficient hard drive space (depending on how much of the solar
system is being modelled).

It uses MongoDB for storing vessel information, launch schedules, and intermediate
state snapshots.

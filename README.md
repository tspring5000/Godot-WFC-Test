# WFC Godot
An attempt at getting a WFC generator working in Godot.
So far it mostly works, there are 3 current issues though:
	1. It does generate with some "gaps", which means all possible options have been removed from
	the cell. This can happen in WFC implementations, my workaround has been to populate those cells
	with a default option (0).
	2. It's not very efficient. This is my fastest implementation so far, but going above a size of
	23x23 causes a stack overflow error.
	3. Its not a full WFC generator. A full WFC generator will propogate changes to its neighbours, 
	and then propagate its neighbours changes to its neighbours, and so on. Mine only propagates to
	its nearest neighbours before moving on.

![Screenshot](screenshot.png)

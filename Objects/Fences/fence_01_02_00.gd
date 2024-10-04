extends Node3D

#TODO 

#HI LYZ OR WHOMEVER IT MAY CONCERN:

# This fence setup sure looks weird, no?
# I setup the fence's blender file to be local instead of instanced... Because, it conflicted with interact/hover/hilite stuff if it was a blender instance as you had it before.

# Just trust me, don't try to think about what that means, if you're confused.

# The main takeaway, is if you want these fences to be well instantiated with the Blender integration, you're going to need to replace every single fence that you've stamped down, with a new fence scene, whose top level node is the blender-instantiated file.

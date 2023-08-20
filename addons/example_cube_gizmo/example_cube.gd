@tool 	# must be a tool script such that inspector changes invoke 
		# the setter which in turn updates the associated gizmos.
extends Node3D
class_name ExampleCube

@export var extents : Vector3 = Vector3(1,1,1) : set = _set_extents

func _set_extents(new):
	extents = new
	update_gizmos()

func _init():
	set_disable_scale(true)

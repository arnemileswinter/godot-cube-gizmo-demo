@tool
extends EditorPlugin

var gizmo_plugin

func _enter_tree():
	gizmo_plugin = preload("res://addons/example_cube_gizmo/example_cube_gizmo_plugin.gd").new()
	add_node_3d_gizmo_plugin(gizmo_plugin)


func _exit_tree():
	remove_node_3d_gizmo_plugin(gizmo_plugin)

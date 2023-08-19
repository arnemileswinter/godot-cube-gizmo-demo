extends EditorNode3DGizmoPlugin
class_name ExampleCubeGizmoPlugin

func _has_gizmo(node):
	return node is ExampleCube

func _get_gizmo_name():
	return "SampleCube"

func _init():
	create_material("main", Color(1, 0, 0))
	create_handle_material("handles")

func _redraw(gizmo):
	gizmo.clear()
	var n = gizmo.get_node_3d()
	
	var vertices = [
		Vector3(n.extents.x, n.extents.y, n.extents.z),
		Vector3(-n.extents.x, n.extents.y, n.extents.z),
		Vector3(-n.extents.x, -n.extents.y, n.extents.z),
		Vector3(n.extents.x, -n.extents.y, n.extents.z),
		Vector3(n.extents.x, n.extents.y, -n.extents.z),
		Vector3(-n.extents.x, n.extents.y, -n.extents.z),
		Vector3(-n.extents.x, -n.extents.y, -n.extents.z),
		Vector3(n.extents.x, -n.extents.y, -n.extents.z)
	]
	var cube_lines = [
		vertices[0], vertices[1],
		vertices[1], vertices[2],
		vertices[2], vertices[3],
		vertices[3], vertices[0],
		vertices[4], vertices[5],
		vertices[5], vertices[6],
		vertices[6], vertices[7],
		vertices[7], vertices[4],
		vertices[0], vertices[4],
		vertices[1], vertices[5],
		vertices[2], vertices[6],
		vertices[3], vertices[7]
	]
	gizmo.add_lines(cube_lines, get_material("main", gizmo), false)
	
	var handles = PackedVector3Array()
	handles.push_back(Vector3(n.extents.x, 0, 0)) # x-handle, handle_id 0
	handles.push_back(Vector3(0, n.extents.y, 0)) # y-handle, handle_id 1
	handles.push_back(Vector3(0, 0, n.extents.z)) # z-handle, handle_id 2
	gizmo.add_handles(handles, get_material("handles", gizmo), [])

func _get_handle_name(gizmo, handle_id, secondary):
	match handle_id:
		0: return "x"
		1: return "y"
		2: return "z"

func _get_handle_value(gizmo, handle_id, secondary):
	var n = gizmo.get_node_3d()
	match handle_id:
		0: return n.extents.x
		1: return n.extents.y
		2: return n.extents.z

func _set_handle(gizmo: EditorNode3DGizmo, handle_id: int, secondary: bool, camera: Camera3D, screen_pos: Vector2):
	var n = gizmo.get_node_3d()
	
	var plane : Plane;
	match handle_id:
		0: plane = Plane.PLANE_XY
		1: plane = Plane.PLANE_XY
		2: plane = Plane.PLANE_YZ
	plane = n.global_transform * plane
	
	var ray_from = camera.project_ray_origin(screen_pos)
	var ray_to = camera.project_ray_normal(screen_pos)
	var drag_to = ray_from + ray_to * n.global_transform.origin.distance_to(ray_from)  # Project the ray onto the gizmo plane

	match handle_id:
		0: n.extents.x = drag_to.x
		1: n.extents.y = drag_to.y
		2: n.extents.z = drag_to.z
	_redraw(gizmo) # see https://github.com/godotengine/godot/issues/71979
	

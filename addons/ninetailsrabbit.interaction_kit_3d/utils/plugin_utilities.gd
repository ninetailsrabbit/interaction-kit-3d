class_name InteractionKit3DPluginUtilities

static func is_mouse_left_click(event: InputEvent) -> bool:
	return event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed


static func is_mouse_right_click(event: InputEvent) -> bool:
	return event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed


static func is_mouse_visible() -> bool:
	return Input.mouse_mode == Input.MOUSE_MODE_VISIBLE || Input.mouse_mode == Input.MOUSE_MODE_CONFINED


static func action_just_pressed_and_exists(action: String) -> bool:
	return InputMap.has_action(action) and Input.is_action_just_pressed(action)


static func action_pressed_and_exists(action: String, event: InputEvent = null) -> bool:
	return InputMap.has_action(action) and event.is_action_pressed(action) if event else Input.is_action_pressed(action)


static func global_distance_to_v3(a: Node3D, b: Node3D) -> float:
	return a.global_position.distance_to(b.global_position)


static func generate_3d_random_fixed_direction() -> Vector3:
	return Vector3(randi_range(-1, 1), randi_range(-1, 1), randi_range(-1, 1)).normalized()


static func rotate_horizontal_random(origin: Vector3 = Vector3.ONE) -> Vector3:
	var arc_direction: Vector3 = [Vector3.DOWN, Vector3.UP].pick_random()
	
	return origin.rotated(arc_direction, randf_range(-PI / 2, PI / 2))


## Only works for native custom class not for GDScriptNativeClass
## Example NodePositioner.find_nodes_of_custom_class(self, MachineState)
static func find_nodes_of_custom_class(node: Node, class_to_find: Variant) -> Array:
	var  result := []
	
	var childrens = node.get_children(true)

	for child in childrens:
		if child.get_script() == class_to_find:
			result.append(child)
		else:
			result.append_array(find_nodes_of_custom_class(child, class_to_find))
	
	return result

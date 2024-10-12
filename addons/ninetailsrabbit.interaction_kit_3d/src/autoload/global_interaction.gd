extends Node

#region Interactables
signal interactable_focused(interactable: Interactable3D)
signal interactable_unfocused(interactable: Interactable3D)
signal interactable_interacted(interactable: Interactable3D)
signal interactable_canceled_interaction(interactable: Interactable3D)
signal interactable_interaction_limit_reached(interactable: Interactable3D)
signal canceled_interactable_scan(interactable: Interactable3D)

#endregion

#region Picking
signal grabbable_focused(grabbable: Grabbable3D)
signal grabbable_unfocused(grabbable: Grabbable3D)
#endregion


func _enter_tree() -> void:
	get_tree().root.child_entered_tree.connect(on_child_entered)
	
	
func _ready() -> void:
	_connect_interactables()
	_connect_grabbables()
	

func _connect_interactables() -> void:
	for interactable_3d: Interactable3D in get_tree().get_nodes_in_group(Interactable3D.GroupName):
		_connect_interactable(interactable_3d)
	

func _connect_grabbables() -> void:
	for grabbable_3d: Grabbable3D in get_tree().get_nodes_in_group(Grabbable3D.GroupName):
		_connect_grabbable(grabbable_3d)


func _connect_grabbable(grabbable: Grabbable3D) -> void:
	if not grabbable.focused.is_connected(on_grabbable_focused):
		grabbable.focused.connect(on_grabbable_focused.bind(grabbable))
			
	if not grabbable.unfocused.is_connected(on_grabbable_unfocused):
		grabbable.unfocused.connect(on_grabbable_unfocused.bind(grabbable))
			
	
func _connect_interactable(interactable: Interactable3D) -> void:
	if not interactable.interacted.is_connected(on_interactable_interacted):
		interactable.interacted.connect(on_interactable_interacted.bind(interactable))
		
		if not interactable.focused.is_connected(on_interactable_focused):
			interactable.focused.connect(on_interactable_focused.bind(interactable))
			
		if not interactable.unfocused.is_connected(on_interactable_unfocused):
			interactable.unfocused.connect(on_interactable_unfocused.bind(interactable))
			
		if not interactable.canceled_interaction.is_connected(on_interactable_canceled_interaction):
			interactable.canceled_interaction.connect(on_interactable_canceled_interaction.bind(interactable))
			
		if not interactable.interaction_limit_reached.is_connected(on_interactable_interaction_limit_reached):
			interactable.interaction_limit_reached.connect(on_interactable_interaction_limit_reached.bind(interactable))
			
	
#region Signal callbacks
func on_child_entered(child: Node) -> void:
	if child is Interactable3D:
		_connect_interactable(child as Interactable3D)
		
	elif child is Grabbable3D:
		_connect_grabbable(child as Grabbable3D)
	else:
		for interactable: Interactable3D in PluginUtilities.find_nodes_of_custom_class(child, Interactable3D):
			_connect_interactable(interactable)
			
		for grabbable: Grabbable3D in PluginUtilities.find_nodes_of_custom_class(child, Grabbable3D):
			_connect_grabbable(grabbable)


func on_interactable_interacted(interactable: Interactable3D):
	interactable_interacted.emit(interactable)


func on_interactable_canceled_interaction(interactable: Interactable3D):
	interactable_canceled_interaction.emit(interactable)


func on_interactable_interaction_limit_reached(interactable: Interactable3D):
	interactable_interaction_limit_reached.emit(interactable)


func on_interactable_focused(interactable: Interactable3D):
	interactable_focused.emit(interactable)


func on_interactable_unfocused(interactable: Interactable3D):
	interactable_unfocused.emit(interactable)
	
	
func on_grabbable_focused(grabbable: Interactable3D):
	grabbable_focused.emit(grabbable)


func on_grabbable_unfocused(grabbable: Interactable3D):
	grabbable_unfocused.emit(grabbable)
	
#endregion

@tool
extends EditorPlugin

const UpdateNotifyToolScene = preload("updater/update_notify_tool.tscn")

var update_notify_tool_instance: Node

func _enter_tree() -> void:
	MyPluginSettings.set_update_notification()
	MyPluginSettings.set_interactable_collision_layer()
	MyPluginSettings.set_grabbable_collision_layer()
	
	_setup_updater()
	
	if not DirAccess.dir_exists_absolute(MyPluginSettings.PluginTemporaryReleaseUpdateDirectoryPath):
		DirAccess.make_dir_recursive_absolute(MyPluginSettings.PluginTemporaryReleaseUpdateDirectoryPath)
	
	add_custom_type("Interactable3D", "Area3D", preload("src/interactable_3d.gd"), preload("assets/interaction_kit_3d.svg"))
	add_custom_type("Grabbable3D", "RigidBody3D", preload("src/pickup/grabbable_3d.gd"), preload("assets/grabbable.svg"))
	add_custom_type("GrabbableAreaDetector3D", "Area3D", preload("src/pickup/grabbable_area_detector_3d.gd"), null)
	add_custom_type("Grabber3D", "Node3D", preload("src/pickup/grabber_3d.gd"), preload("assets/grabber.svg"))
	
	add_custom_type("RayCastInteractor3D", "RayCast3D", preload("src/interactors/raycast_interactor_3d.gd"), preload("assets/interactor_3d.svg"))
	add_custom_type("MouseRayCastInteractor3D", "Node3D", preload("src/interactors/mouse_raycast_interactor_3d.gd"), preload("assets/interactor_3d.svg"))
	add_custom_type("GrabbableRayCastInteractor3D", "Node3D", preload("src/interactors/grabbable_raycast_interactor_3d.gd"), preload("assets/interactor_3d.svg"))
	
	add_autoload_singleton("GlobalInteraction3D", "src/autoload/global_interaction.gd")


func _exit_tree() -> void:
	MyPluginSettings.remove_settings()
	
	if update_notify_tool_instance:
		update_notify_tool_instance.free()
		update_notify_tool_instance = null
		
	remove_autoload_singleton("GlobalInteraction3D")
	
	remove_custom_type("MouseRayCastInteractor3D")
	remove_custom_type("RayCastInteractor3D")
	remove_custom_type("GrabbableInteractor3D")
	
	remove_custom_type("Grabber3D")
	remove_custom_type("GrabbableAreaDetector3D")
	remove_custom_type("Grabbable3D")
	remove_custom_type("Interactable3D")

## Update tool referenced from https://github.com/MikeSchulze/gdUnit4/blob/master/addons/gdUnit4
func _setup_updater() -> void:
	if MyPluginSettings.is_update_notification_enabled():
		update_notify_tool_instance = UpdateNotifyToolScene.instantiate()
		Engine.get_main_loop().root.add_child.call_deferred(update_notify_tool_instance)

class_name GrabbableAreaDetector3D extends Area3D


func _enter_tree() -> void:
	collision_layer = 0
	collision_mask = ProjectSettings.get_setting(MyPluginSettings.GrabbablesCollisionLayerSetting)
	monitorable = false
	monitoring = true
	priority = 2

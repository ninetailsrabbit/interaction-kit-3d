@tool
class_name MyPluginSettings extends RefCounted

const PluginPrefixName: String = "ninetailsrabbit.interaction_kit_3d" ## The folder name
const GitRepositoryName: String = "interaction-kit-3d"

static var PluginName: String = "MyPlugin"
static var PluginProjectName: String = ProjectSettings.get_setting("application/config/name")
static var PluginBasePath: String = "res://addons/%s" % PluginPrefixName
static var PluginLocalConfigFilePath = "%s/plugin.cfg" % PluginBasePath
static var PluginSettingsBasePath: String = "%s/config/%s" % [PluginProjectName, PluginPrefixName]
static var RemoteReleasesUrl = "https://api.github.com/repos/ninetailsrabbit/%s/releases" % GitRepositoryName
static var PluginTemporaryDirectoryPath = OS.get_user_data_dir() + "/" + PluginPrefixName
static var PluginTemporaryReleaseUpdateDirectoryPath = "%s/update" % PluginTemporaryDirectoryPath
static var PluginTemporaryReleaseFilePath = "%s/%s.zip" % [PluginTemporaryDirectoryPath, PluginPrefixName]
static var PluginDebugDirectoryPath = "res://debug"

#region Plugin Settings
static var UpdateNotificationSetting: String = PluginSettingsBasePath + "/update_notification_enabled"
static var InteractablesCollisionLayerSetting: String = PluginSettingsBasePath + "/interactables_collision_layer"
static var GrabbablesCollisionLayerSetting: String = PluginSettingsBasePath + "/grabbables_collision_layer"
#endregion

## Enable to test the updater without need to have a latest release version to trigger it
static var DebugMode: bool = false

static func set_update_notification(enable: bool = true) -> void:
	ProjectSettings.set_setting(UpdateNotificationSetting, enable)
	ProjectSettings.add_property_info({
		"name": UpdateNotificationSetting,
		"type": typeof(enable),
	 	"value": enable,
		"hint": PROPERTY_HINT_TYPE_STRING,
		"hint_string": "Turn notifications on or off to receive alerts when new versions of the plugin are released"
	})
	ProjectSettings.save()


## By default on layer 5
static func set_interactable_collision_layer(interactable_layer: int = 6) -> void:
	interactable_layer = clamp(interactable_layer, 1, 32)
	
	ProjectSettings.set_setting(InteractablesCollisionLayerSetting, interactable_layer)
	ProjectSettings.add_property_info({
		"name": InteractablesCollisionLayerSetting,
		"type": typeof(interactable_layer),
	 	"value": interactable_layer,
		"hint": PROPERTY_HINT_TYPE_STRING,
		"hint_string": "Set the collision layer for interactables to be detected by interactors"
	})
	ProjectSettings.save()


## By default on layer 6
static func set_grabbable_collision_layer(grabbable_layer: int = 7) -> void:
	grabbable_layer = clamp(grabbable_layer, 1, 32)
	
	ProjectSettings.set_setting(GrabbablesCollisionLayerSetting, grabbable_layer)
	ProjectSettings.add_property_info({
		"name": GrabbablesCollisionLayerSetting,
		"type": typeof(grabbable_layer),
	 	"value": grabbable_layer,
		"hint": PROPERTY_HINT_TYPE_STRING,
		"hint_string": "Set the collision layer for grabbables to be detected by the grabber"
	})
	ProjectSettings.save()



static func is_update_notification_enabled() -> bool:
	return ProjectSettings.get_setting(UpdateNotificationSetting, true)


static func remove_settings() -> void:
	remove_setting(UpdateNotificationSetting)
	remove_setting(InteractablesCollisionLayerSetting)
	remove_setting(GrabbablesCollisionLayerSetting)


static func remove_setting(name: String) -> void:
	if ProjectSettings.has_setting(name):
		ProjectSettings.set_setting(name, null)
		ProjectSettings.save()
		

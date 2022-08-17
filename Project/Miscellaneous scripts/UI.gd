extends CanvasLayer

const MIN_HEALTH: int = 23 # Stores the value of the minimum health

var max_hp: int = 4 # Stores the max hp of the players

# onready variables for the player, the health bar, and the tween
onready var player: KinematicBody2D = get_parent().get_node("Player")
onready var health_bar: TextureProgress = get_node("HealthBar")
onready var health_bar_tween: Tween = get_node("HealthBar/Tween")

# ready function changes the value of the max_hp to the player hp. Makes the max the initial value
func _ready() -> void:
	max_hp = player.hp
	# Fills the health bar using the _update_health_bar function with 100 as the parameter
	_update_health_bar(100)

# Updates the health bar, parameter for the new value of the health bar
func _update_health_bar(new_value: int) -> void:
	# interpolates the value of the health bar to the new value indicated by the parameter using tween
	var __ = health_bar_tween.interpolate_property(health_bar, "value", health_bar.value, new_value, 0.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	__ = health_bar_tween.start() # Starts the tween

# Finds the new value of the health bar with the new hp of the player between 23-100
func _on_Player_hp_changed(new_hp: int) -> void:
	# calculates the number of possible values of the new range: 100 - 23
	# Multiplies the anterior value by the player hp %. Ues a value between 0-77 that represents hp%
	var new_health: int = int((100 - MIN_HEALTH) * float(new_hp) / max_hp) + MIN_HEALTH
	# Updates the health bar with the calulated value
	_update_health_bar(new_health)
	print("Player health changed")

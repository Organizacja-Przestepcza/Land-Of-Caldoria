extends Neutral
class_name MobSheep

var is_sheared: bool = false

func _ready() -> void:
	mob_name = "sheep"
	health = 10
	super()
	speed = 80
	exp = 3
	sprite.play("idle")
	add_to_group("neutrals")

func shear():
	if is_sheared:
		return
	sprite = $ShearedAnimatedSprite
	sprite.play(&"idle")
	player.inventory.add_item(ItemLoader.name("wool"),randi_range(1,2))
	is_sheared = true
	$InteractableArea.queue_free()

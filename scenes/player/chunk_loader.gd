extends ThreadedChunkLoader2D
class_name ChunkLoader

## Emitted when the player moved to a different chunk
signal chunk_changed(chunk_position: Vector2i)

func _try_loading() -> void:
	var actor_position: Vector2i = _get_actors_position()

	if actor_position == _last_position:
		return

	_last_position = actor_position
	_update_loading(actor_position)
	chunk_changed.emit(actor_position)

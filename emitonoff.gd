extends Node2D

func set_emission(enabled: bool) -> void:
	for emitter in get_children():
		if emitter is GPUParticles2D:
			emitter.emitting = enabled


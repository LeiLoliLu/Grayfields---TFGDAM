extends StaticBody2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name != "Allen":
		return
	if not $"..".can_leave:
		return
	$Area2D.disconnect("body_entered",_on_area_2d_body_entered)
	$"..".call_deferred("goNextArea")

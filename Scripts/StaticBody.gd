extends StaticBody

var me

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#    pass


func _on_StaticBody_tree_exiting() -> void:
    print("Static body exiting")


func _on_StaticBody_tree_exited() -> void:
    print("Static body exited")
    var shape : ConcavePolygonShape = get_node("CollisionShape").get_shape()
    shape.queue_free()
    self.queue_free()


func _on_StaticBody_tree_entered() -> void:
    print("Static body entering")

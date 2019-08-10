class_name SyncedDataNode extends DataNode

var previous_data: Dictionary = {}

signal updated(previous_data, new_data)
signal index_added(index)
signal index_removed(index)


func _init(parent_node: Node, name: String, authorities: Array=[]).(parent_node, name, authorities):
	pass
		
func update_local(update: Dictionary):
	
	.update_local(update)
	
	for key in update:
		if not previous_data.has(key):
			emit_signal("index_added", key)
			
		if update[key]==null:
			emit_signal("index_removed", key)	
	
	emit_signal("updated", previous_data, data)
	
	previous_data = {}
	for key in data: #shallow clone
		previous_data[key]=data[key]
	
	
	
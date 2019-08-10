class_name SyncedPlayerList extends SyncedDataNode

func _init(parent_node: Node).(parent_node, "SyncedPlayerList", [1]):
	pass
	
func add_player(id, data={}):
	self.update_and_push({ id: data})
	pass
	
func remove_player(id):
	self.update_and_push({ id: null})
	pass
	
func edit_player(id, update):
	self.update_and_push({ id: update})
	
func get_player_data_node(player_id):
	var name = str("Player",player_id)
	if not self.has_node(name):
		return null
	return self.get_node(name)
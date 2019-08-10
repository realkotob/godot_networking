class_name ContinuousDataNode extends DataNode


	
var sync_frequency: float = 33
var time_since_last_sync: float = 0


func _init(parent_node: Node, name: String, sync_frequency = 33, authorities: Array=[]).(parent_node, name, authorities):
	self.sync_frequency = sync_frequency



func push(client_id, update):
	rpc_unreliable_id(client_id, "accept_update", update)


func _physics_process(delta):
	time_since_last_sync += delta
	if time_since_last_sync > sync_frequency:
		update_and_push(self.data)
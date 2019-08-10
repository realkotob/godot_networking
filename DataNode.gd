class_name DataNode extends Node

var data = {}
var authorities = [1]
master var subscribers:Array=[]


func _init(parent_node: Node, name: String, authorities: Array=[]):
	#All nodes are controlled by the server
	parent_node.add_child(self)
	self.set_network_master(1, false)
	self.name = name
	for client in authorities:
		if not self.authorities.has(client):
			self.authorities.append(client)
	if not is_network_master():
		rpc_id(1, "subscribe_client")
		print("Want to subscribe to ", self.name)

	
func _exit_tree():
	if not is_network_master():
		rpc_id(1, "unsubscribe_client")
		print("Want to unsubscribe from ", self.name)
	
	
master func subscribe_client():
	var sender_id = get_tree().get_rpc_sender_id()
	print("Trying to subscribe ",sender_id, " to ", self.name)
	if subscribers.has(sender_id) == false:
		subscribers.append(sender_id)
		print("subscribed ",sender_id, " to ", self.name)
	push(sender_id, self.data)
		
		
master func unsubscribe_client():
	var sender_id = get_tree().get_rpc_sender_id()
	if subscribers.has(sender_id):
		subscribers.erase(sender_id)
		
func update_and_push(update: Dictionary):
	
	assert(self.is_inside_tree())
	if NetworkManager.i_am_host():
		for client_id in subscribers:
			push(client_id, update)
		
	else:
		push(1 ,update)

	update_local(update)
	
	
func push(client_id, update):
	rpc_id(client_id, "accept_update", update)
	
	
		
remotesync func accept_update(update: Dictionary):
	
	var sender_id = get_tree().get_rpc_sender_id()
	
	if NetworkManager.i_am_host():
		if sender_id in authorities:
			update_and_push(update)
			
	else:
		if sender_id == 1:
			update_local(update)

		
func update_local(update: Dictionary):
	
	for key in update:
		if update[key]==null:
			self.data.erase(key)
		else:
			self.data[key] = update[key]
	

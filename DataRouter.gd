extends Node

const data_nodes: Dictionary = {}

func add(node: SyncedDataNode):
	data_nodes[node.name] = node
	
func remove(node: SyncedDataNode):
	data_nodes.erase(node.name)
	
func send_rpc(node_name:String, function_name:String, args:Array):
	rpc("receive_rpc", node_name, function_name, args)
	
remote func receive_rpc(node_name:String, function_name:String, args:Array):
	if data_nodes.has(node_name):
		var node:SyncedDataNode = data_nodes[node_name]
		node.call(function_name, args)
	else:
		print("No node named: ",node_name)
		print_stack()
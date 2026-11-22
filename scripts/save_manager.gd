extends Node

func save_state() -> Dictionary:
	var state = {
		'data': {}
	}
	
	for node in get_tree().get_nodes_in_group('save'):
		if node.has_method('save_state'):
			node.save_state(state['data'])
	return state

func load_state(state: Dictionary, node: Node2D) -> void:
	var data = state.get('data',{})
	
	if node.has_method('load_state'):
		node.load_state(data)

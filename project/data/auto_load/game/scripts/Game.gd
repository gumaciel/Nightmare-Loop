extends Node


func _ready():
	pass

func save_game() -> bool:
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("player")
	
	for node in save_nodes:
		if node.filename.empty():
			print("not an istanced scene")
			continue
		
		if !node.has_method("save"):
			print("node doesnt have save method")
			continue
		var node_data = node.call("save")
		
		save_game.store_line(to_json(node_data))
	save_game.close()
	return false

func load_game(node_search : String) -> Dictionary:
	var load_game = File.new()
	if not load_game.file_exists("user://savegame.save"):
		return {}
	load_game.open("user://savegame.save", File.READ)
	while load_game.get_position() < load_game.get_len():
		var node_data = parse_json(load_game.get_line())
		if node_data["name"] == node_search:
			return node_data
		else: continue
	return {}

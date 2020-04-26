extends Node

func save_node_by_path(NodePathSaved : NodePath) -> bool:
	var FileSaved := File.new()
	var NodeSaved := get_node(NodePathSaved)

	if !NodeSaved.has_method("save"):
		print("Node doesn't have save method.")
		return false
	
	var node_data : Dictionary = NodeSaved.call("save")
	
	FileSaved.open("res://" + NodeSaved.name + ".save", File.WRITE)
	FileSaved.store_line(to_json(node_data))
	FileSaved.close()
	return true

func load_node_by_name(node_name_saved : String) -> Dictionary:
	var FileSaved := File.new()
	var name_file_load := "res://" + node_name_saved + ".save"
	var node_data : Dictionary

	if FileSaved.file_exists(name_file_load):
		FileSaved.open(name_file_load, File.READ)
		node_data = parse_json(FileSaved.get_line())
	else:
		print("FileSaved doesn't exists.")
	return node_data

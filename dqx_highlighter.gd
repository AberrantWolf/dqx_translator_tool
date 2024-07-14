class_name DqxHighlighter
extends SyntaxHighlighter


var line_caches: Array = []


func _clear_highlighting_cache() -> void:
	line_caches.clear()


func _get_line_syntax_highlighting(line: int) -> Dictionary:
	if line < line_caches.size():
		return line_caches[line]
	return {}


func _update_cache() -> void:
	line_caches.clear()
	var text = get_text_edit().text
	var lines = text.split("\n")
	for line: String in lines:
		var cursor = 0
		var cache = {}
		while cursor < line.length():
			var found = line.find("<", cursor)
			if found == -1:
				break
			
			var start = found
			
			found = line.find(">", cursor)
			if found == -1:
				break
			var end = found + 1
			
			cache[start] = {"color": Color.DIM_GRAY}
			cache[end] = {"color": Color.WHITE}
			
			cursor = end
		
		line_caches.append(cache)

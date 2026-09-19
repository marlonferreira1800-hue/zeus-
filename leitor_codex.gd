extends SceneTree

func _init() -> void:
	var args = OS.get_cmdline_user_args()
	var target_id = ''
	for i in range(args.size()):
		if args[i] == '--id' and i + 1 < args.size():
			target_id = args[i + 1]
	var file = FileAccess.open('res://codex.json', FileAccess.READ)
	if not file:
		printerr('Erro ao abrir codex.json')
		quit(1)
	var data = JSON.parse_string(file.get_as_text())
	file.close()
	if target_id != '':
		var found = false
		for entry in data.get('entradas', []):
			if entry.get('id') == target_id:
				print('--- ENTRADA ENCONTRADA ---')
				print('ID: ', entry.get('id'))
				print('Nome: ', entry.get('nome'))
				print('Descricao: ', entry.get('descricao'))
				found = true
				break
		if not found:
			print('Entrada com ID ', target_id, ' nao encontrada.')
	else:
		print('--- TODAS AS ENTRADAS ---')
		print(data)
	quit(0)

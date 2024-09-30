class_name Main
extends Node

signal xml_file_dumped(file_path: String)

const ITEMS_PER_PAGE: int = 10

@onready var http_request: HTTPRequest = %HTTPRequest
@onready var item_container: VBoxContainer = %ItemBoxContainer
@onready var display: PackedScene = load("res://item_display.tscn")

@onready var name_filter: LineEdit = %NameFilter
@onready var brand_filter: LineEdit = %BrandFilter

@onready var price_min: LineEdit = %PriceMin
@onready var price_max: LineEdit = %PriceMax

@onready var price_sorting: Button = %PriceSorting
@onready var name_sorting: Button = %NameSorting

@onready var previous_page: Button = %PreviousPage
@onready var page_display: Label = %PageDisplay
@onready var next_page: Button = %NextPage

@onready var shadowrealm: Node = %Shadowrealm

var xml_dictionary: Dictionary
var items: Array[Item]

enum Sort { INCREMENT = 0, DECREMENT = 1, FINAL_SORT }

var price_sorting_sort: Sort
var name_sorting_sort: Sort

var page_index: int = 1
var all_children: Array[ItemDisplay]

func _ready():
	http_request.request_completed.connect(self._http_request_completed)
	xml_file_dumped.connect(read_xml_file)
	request("https://www.ton.eu/exports/reseller_feed_en.xml")
	
	name_filter.text_changed.connect(update_name_filter)
	brand_filter.text_changed.connect(update_brand_filter)
	
	price_min.text_changed.connect(update_price_filter)
	price_max.text_changed.connect(update_price_filter)
	
	price_sorting.pressed.connect(price_sort)
	name_sorting.pressed.connect(name_sort)
	
	previous_page.pressed.connect(prev_press)
	next_page.pressed.connect(next_press)

# Called when the HTTP request is completed.
func _http_request_completed(_result, _response_code, _headers, body):
	var s = body.get_string_from_utf8()
	var doc: XMLDocument = XML.parse_str(s)
	doc.root.dump_file("res://file.xml", true, 0, 0)
	xml_file_dumped.emit("res://file.xml")

func request(p_request: String) -> void:
	var error = http_request.request(p_request, ["Accept: application/xml"])
	if error != OK:
		push_error("An error occurred in the HTTP request.")

func read_xml_file(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.READ)
	
	items.clear()
	
	while !file.eof_reached(): # iterate through all lines until the end of file is reached
		var line = file.get_line()
		var is_item: bool = false
		
		if line.contains("<item>"):
			is_item = true
			
			var item: Item = Item.new()
			
			while is_item:
				line = file.get_line()
				if line.contains("<g:id>"):
					item.id = file.get_line()
				elif line.contains("<g:title>"):
					item.title = file.get_line()
				elif line.contains("<g:description>"):
					item.description = file.get_line()
				elif line.contains("<g:availability>"):
					item.availability = file.get_line()
				elif line.contains("<g:condition>"):
					item.condition = file.get_line()
				elif line.contains("<g:price>"):
					item.price = file.get_line()
				elif line.contains("<g:link>"):
					item.link = file.get_line()
				elif line.contains("<g:brand>"):
					item.brand = file.get_line()
				elif line.contains("<g:image_link>"):
					item.image_link = file.get_line()
				elif line.contains("<g:gtin>"):
					item.gtin = int(file.get_line())
				elif line.contains("<g:item_group_id>"):
					item.item_group_id = int(file.get_line())
				
				if line.contains("</item>"):
					is_item = false
					items.append(item)
	file.close()
	display_items()
	
	# display items in ui

func display_items() -> void:
	clear_container()
	
	for child in items:
		if child is Item:
			var item_display = display.instantiate()
			item_display.item = child
			item_container.add_child(item_display)
			all_children.append(item_display)
	
	update_page_view()

func clear_container() -> void:
	for child in item_container.get_children():
		child.queue_free()
	
	all_children.clear()

func update_name_filter(text: String) -> void:
	if text.is_empty():
		update_page_view()
		return
	
	var children: Array[ItemDisplay]
	
	for child in item_container.get_children():
		if child is ItemDisplay:
			if child.item.title.containsn(text):
				children.append(child)
				child.visible = true
			else:
				child.visible = false
	
	update_page_view(children)

func update_brand_filter(text: String) -> void:
	if text.is_empty():
		update_page_view()
		return
	
	var children: Array[ItemDisplay]
	
	for child in item_container.get_children():
		if child is ItemDisplay:
			if child.item.brand.containsn(text):
				children.append(child)
				child.visible = true
			else:
				child.visible = false
	
	update_page_view(children)

func update_price_filter(text: String) -> void:
	if text.is_valid_float() || text.is_empty():
		price_min.self_modulate = Color.WHITE
		price_max.self_modulate = Color.WHITE
	else:
		price_min.self_modulate = Color.RED
		price_max.self_modulate = Color.RED
		return
	
	var min_price: float
	var max_price: float
	
	if price_min.text.is_empty():
		min_price = 0.0
	else:
		min_price = float(price_min.text)
	
	if price_max.text.is_empty():
		max_price = 999999999999 # i'm really sorry, i really am....
	else:
		max_price = float(price_max.text)
	
	for child in item_container.get_children():
		if child is ItemDisplay:
			if child.item.get_raw_price() > min_price && child.item.get_raw_price() < max_price:
				child.visible = true
			else:
				child.visible = false



func price_sort() -> void:
	price_sorting_sort = wrapi(price_sorting_sort as int + 1, 0, Sort.FINAL_SORT as int) as Sort
	name_sorting.text = "Name Sort: ▲▼"
	match price_sorting_sort:
		Sort.INCREMENT:
			items.sort_custom(func(a: Item, b: Item): return a.get_raw_price() < b.get_raw_price())
			price_sorting.text = "Price Sort: ▲"
		Sort.DECREMENT:
			items.sort_custom(func(a: Item, b: Item): return a.get_raw_price() > b.get_raw_price())
			price_sorting.text = "Price Sort: ▼"
	display_items()

func name_sort() -> void:
	name_sorting_sort = wrapi(name_sorting_sort as int + 1, 0, Sort.FINAL_SORT as int) as Sort
	price_sorting.text = "Price Sort: ▲▼"
	match name_sorting_sort:
		Sort.INCREMENT:
			items.sort_custom(func(a: Item, b: Item): return a.title < b.title)
			name_sorting.text = "Name Sort: ▲"
		Sort.DECREMENT:
			items.sort_custom(func(a: Item, b: Item): return a.title > b.title)
			name_sorting.text = "Name Sort: ▼"
	display_items()

func prev_press() -> void:
	page_index -= 1
	
	if page_index <= 1:
		previous_page.disabled = true
	if page_index < get_page_count():
		next_page.disabled = false
	
	update_page_view()

func next_press() -> void:
	page_index += 1
	
	if page_index > 1:
		previous_page.disabled = false
	
	if page_index >= get_page_count() - 1:
		next_page.disabled = true
	
	update_page_view()

func update_page_view(child_arr: Array = item_container.get_children()) -> void:
	page_display.text = str(page_index)
	
	for child in child_arr:
		child.visible = false
	
	var starting_index = (page_index - 1) * ITEMS_PER_PAGE
	
	for index in range(starting_index, starting_index + ITEMS_PER_PAGE):
		if child_arr.size() > index:
			var child = child_arr[index]
			if child:
				child.visible = true

func get_page_count(visible_only: bool = false) -> int:
	if !visible_only:
		return ceili(item_container.get_child_count() / float(ITEMS_PER_PAGE))
	
	var visible: int = 0
	for child in item_container.get_children():
		if child.visible:
			visible += 1
	
	return ceili(visible / float(ITEMS_PER_PAGE))


# product/item inner class

class Item:
	var id: String
	
	var title: String:
		set(value):
			value = value.replace("<![CDATA[", "")
			value = value.replace("]]>", "")
			title = value
	
	var description: String:
		set(value):
			value = value.replace("<![CDATA[", "")
			value = value.replace("]]>", "")
			description = value

	var availability: String
	var condition: String
	var price: String
	var link: String
	var brand: String
	var image_link: String
	var gtin: int
	var item_group_id: int
	
	# todo: clean up each variable as it is assigned
	
	func get_raw_price() -> float:
		return float(price)

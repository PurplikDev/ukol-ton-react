class_name ItemDisplay
extends Control

@onready var big_button: Button = %BigButton
@onready var small_button: Button = %SmallButton

@onready var big_panel: Panel = %BigPanel
@onready var small_panel: Panel = %SmallPanel

var item: Main.Item:
	set(value):
		item = value
		%SmallID.text = item.id
		%SmallName.text = item.title
		%SmallBrand.text = item.brand
		%SmallCondition.text = item.condition
		%SmallPrice.text = item.price
		
		%BigID.text = item.id
		%BigTitle.text = item.title
		%BigDescription.text = item.description
		%BigAvailability.text = item.availability
		%BigCondition.text = item.condition
		%BigPrice.text = item.price
		%BigBrand.text = item.brand
		%BigGTIN.text = str(item.gtin)
		%BigItemGroupID.text = str(item.item_group_id)
		%BigLinkButton.uri = item.link 


func _ready() -> void:
	small_button.pressed.connect(func():
		small_panel.visible = false
		big_panel.visible = true
		custom_minimum_size = Vector2(1000,250)
		
		if %BigItemImage.texture == null:
			%ImageRequest.request(item.image_link)
		)
	
	big_button.pressed.connect(func():
		small_panel.visible = true
		big_panel.visible = false
		custom_minimum_size = Vector2(1000,100)
		)
	
	%ImageRequest.request_completed.connect(_http_request_completed)

func _http_request_completed(result, _response_code, _headers, body):
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Image couldn't be downloaded. Try a different image.")

	var image = Image.new()
	var error = image.load_png_from_buffer(body)
	if error != OK:
		push_error("Couldn't load the image.")

	var texture = ImageTexture.create_from_image(image)

	%BigItemImage.texture = texture

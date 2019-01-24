extends Node2D


export (int) var PLAYER_NUM = 1
export (int) var CARDS_NUM = 8
export (int) var SPACE_BETWEEN_CARDS = 20


var card_scene = load("res://Scenes/Card.tscn")
var all_cards = []
var deck_cards = []
var played_cards = []

func _ready():
    all_cards = load_cards()
    
    var card_deck = $"./../CardDeck"
    
    for i in CARDS_NUM:
        randomize()
        var card = all_cards[randi()%29+1].duplicate()
        card.position.x += (card.get_width() + SPACE_BETWEEN_CARDS) * i
        deck_cards.append(card)
        card_deck.add_child(card)



func create_card(card):
    match card.type:
        "builder":
            card.get_node("Front").texture = load("res://Images/card_front_brown.png")
            card.find_node("Currency").text = "bricks"
        "soldier":
            card.get_node("Front").texture = load("res://Images/card_front_green.png")
            card.find_node("Currency").text = "weapons"
        "wizard":
            card.get_node("Front").texture = load("res://Images/card_front_purple.png")
            card.find_node("Currency").text = "crystals"
    #card.position = $"./../CardDeck".rect_position
    card.find_node("Name").text = card.name
    card.find_node("Price").text = card.price
    return card


func load_cards():
    var file = File.new()
    file.open("res://Configs/cards.txt", File.READ)
    var card_deck = []
    
    var line = file.get_line()
    var variable_list = line.split('|')
    while true:
        line = file.get_line()
        if file.eof_reached(): 
            break
        line = line.split('|')
        var card = card_scene.instance()
        card.name = line[1].strip_edges()
        card.type = line[2].strip_edges()
        card.price = line[3].strip_edges()
        card_deck.append(create_card(card))
    file.close()
    return card_deck
    
    

func play_card(card):
    var card_deck = $"./../CardDeck"
    var index = deck_cards.find(card)
    deck_cards.remove(index)
    
    var played = get_node("Played")
    card.position = Vector2(0.0, 0.0)
    card_deck.remove_child(card)
    for child in played.get_children():
        played.remove_child(child)
    played.add_child(card)
    
    played_cards.append(card)
    print(played_cards)
    card.is_played = true
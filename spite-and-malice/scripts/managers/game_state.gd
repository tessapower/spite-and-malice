extends Node

## Game Settings
# TODO: move to game settings or rules manager singleton
const MAX_IN_HAND = 5
const MAX_DISCARD_PILES = 4
const MAX_PLAY_PILES = 4
const N_JOKERS_PER_DECK = 2
const N_PLAYERS = 2

var selected_card: Card = null
var selected_card_source = null
var dest_pile: CardSlot = null


func select_card(card: Card) -> void:
    selected_card = card
    selected_card_source = card.parent


func deselect_card() -> void:
    selected_card = null
    selected_card_source = null

# TODO: implement reset functionality?

class_name Player
extends Node2D

## player.gd: a data class to hold the cards and card piles that belong to a player.

@onready var card_slots: Array[Node] = get_tree().get_nodes_in_group("PlayerCardSlots")

var cards: Array[Card] = []


func add_to_hand(card: Card) -> bool:
    if (cards.size() > GameState.MAX_IN_HAND):
        return false

    cards.append(card)
    # FIXME: For some reason, card doesn't appear in window if you try to add
    #  it directly to the card slot using `slot.add_child(card)` or by passing
    # the card as a function arg...
    add_child(card)

    # Sort cards
    cards.sort_custom(_sort_by_rank)
    for i in range(cards.size()):
        card_slots[i].set_card(cards[i])

    return true


func _sort_by_rank(a: Card, b: Card) -> bool:
    return a.rank < b.rank

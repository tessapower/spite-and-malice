class_name Player
extends Node2D

## player.gd: a data class to hold the cards and card piles that belong to
## the player.

@onready var card_slots: Array[Node] = get_node("CardSlots").get_children()
@onready var goal_pile: Pile = get_node("GoalPile")

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
        var card_slot: CardSlot = card_slots[i]
        card_slot.remove_card()
        card_slot.set_card(cards[i])

    return true


func _sort_by_rank(a: Card, b: Card) -> bool:
    return a.rank < b.rank

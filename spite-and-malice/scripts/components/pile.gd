class_name Pile
extends Node

# The cards in this pile.
@onready var cards: Stack = Stack.new()
# Whether this pile is required to be in rank order.
@export var rank_order: bool = false
# Whether this pile accepts cards being added to it
@export var accepts_cards: bool = true
# Whether this pile is selectable by the player.
@export var selectable: bool = true

enum Type { DRAW_PILE, PLAY_PILE, GOAL_PILE, DISCARD_PILE, IN_HAND, NONE }
@export var type: Type = Type.NONE

# TODO: introduce per instance rules

## Create a new pile. Rank ordering will be enforced when adding cards to this
## pile if enforce_rank_order is true.
func _init(enforce_rank_order: bool = false) -> void:
    rank_order = enforce_rank_order


## Returns the number of cards in the pile
func size() -> int:
    return cards.size()


## Returns whether the pile is empty
func is_empty() -> bool:
    return cards.is_empty()


## Adds a card to this pile, returns whether adding the card was successful.
func add(c: Card) -> bool:
    if !accepts_cards:
        return false

    if cards.is_empty():
        c.selectable = true
        cards.push(c)

    if rank_order:
        if c > cards.peek():
            # Set current top card as not selectable
            cards.peek().selectable = false
            # Set new top card as selectable
            c.selectable = true
            cards.push(c)
            return true

    return false


## Peeks at the top card from this pile without removing it
func peek_top_card() -> Card:
    if cards.is_empty():
        return null

    return cards.peek()


## Removes and returns the top card from this pile
func pop_top_card() -> Card:
    if cards.is_empty():
        return null

    var top_card = cards.pop()
    # Set removed top card as not selectable
    top_card.selectable = false
    # Set new top card as selectable
    cards.peek().selectable = true

    return top_card



## Returns whether this pile enforces rank ordering
func enforces_rank_order() -> bool:
    return rank_order


func _on_mouse_entered() -> void:
    pass # Replace with function body.



func _on_mouse_exited() -> void:
    pass # Replace with function body.

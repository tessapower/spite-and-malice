class_name CardSlot
extends Node2D

## card_slot.gd: represents a slot where a card can be. Can only hold one card
## at a time.

@export var selectable: bool = true
@export var visible_to_player: bool = true
var card: Card = null
var selected: bool = false


func set_card(c: Card) -> void:
    # Guard against passing null
    if c == null: return
    # Don't do anything if card already belongs to this slot
    if card == c: return

    card = c
    card.selectable = selectable
    card.parent = self
    card.original_pos = position
    card.position = position
    if !visible_to_player:
        card.display_back(true)


# Removes the card from this card slot and unassigns itself as the card's parent
func remove_card() -> void:
    # Don't do anything if this slot has no card
    if card == null: return

    card.selectable = false
    card.parent = null
    card.display_back(false)
    card = null


func _on_mouse_entered() -> void:
    var can_pick_up_card = GameState.selected_card == null && card != null && card.selectable
    if can_pick_up_card:
        # Visually show that the card can be picked up
        card.hover(true)


func _on_mouse_exited() -> void:
    if card != null && card.selectable:
        card.hover(false)

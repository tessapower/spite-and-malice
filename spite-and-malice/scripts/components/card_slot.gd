class_name CardSlot
extends Node2D

## card_slot.gd: represents a slot where a card can be. Can only hold one card
## at a time.

@export var card: Card = null
@export var selectable: bool = true
var selected: bool = false


func set_card(c: Card) -> void:
    # Guard against passing null
    if c == null: return
    # Don't do anything if card already belongs to this slot
    if card == c: return

    card = c
    card.selectable = true
    card.set_parent(self)


# Removes the card from this card slot and unassigns itself as the card's parent
func remove_card() -> void:
    # Don't do anything if this slot has no card
    if card == null: return

    card.selectable = false
    card.set_parent(null)
    card = null


func _on_mouse_entered() -> void:
    var can_pick_up_card = GameState.selected_card == null && card != null && card.selectable
    if can_pick_up_card:
        # Visually show that the card can be picked up
        card.hover(true)


func _on_mouse_exited() -> void:
    if card != null && card.selectable:
        card.hover(false)


func _on_area_entered(area: Area2D) -> void:
    var c := area.get_parent() as Card
    if c:
        # TODO: Remove card == null when converting to pile with multiple cards
        if GameState.selected_card && card == null:
            # TODO: check if legal move
            # If yes, highlight green set this as dest_pile
            print("Do some rule checking here, highlight ")
            GameState.dest_pile = self
            # If no, highlight red


func _on_area_exited(area: Area2D) -> void:
    var c := area.get_parent() as Card
    # If we set this slot as the destination, unset it
    if c && GameState.dest_pile == self:
        GameState.dest_pile = null

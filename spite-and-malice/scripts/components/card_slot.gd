class_name CardSlot
extends Node2D

## card_slot.gd: represents a slot where a card can be. Can only hold one card
## at a time.

@export var selectable: bool = true
var card: Card = null
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
            if RulesManager.is_legal_move(GameState.selected_card, self):
                GameState.dest_pile = self
                c.highlight_on(RulesManager.legal_move_color)
            # If no, highlight red
            else:
                c.highlight_on(RulesManager.illegal_move_color)


func _on_area_exited(area: Area2D) -> void:
    var c := area.get_parent() as Card
    # If we set this slot as the destination, unset it
    if c && GameState.dest_pile == self:
        GameState.dest_pile = null

    c.highlight_off()

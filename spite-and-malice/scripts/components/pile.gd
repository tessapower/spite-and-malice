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

enum Type { DRAW_PILE, PLAY_PILE, GOAL_PILE, DISCARD_PILE }
@export var type: Type = Type.DRAW_PILE

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
func add(c: Card) -> void:
    if is_empty() || !rank_order || (rank_order && c.rank > cards.peek().rank):
        c.selectable = selectable
        c.set_parent(self)
        # Set newly pushed card's z ordering so that it appears on the top
        # of the stack
        if !is_empty(): c.z_index = cards.peek().z_index + 1
        cards.push(c)


## Peeks at the top card from this pile without removing it
func peek_top_card() -> Card:
    if is_empty():
        return null

    return cards.peek()


## Removes and returns the top card from this pile
func pop_top_card() -> Card:
    if is_empty():
        return null

    var card = cards.pop()
    card.z_index = Card.NORMAL_Z_IDX

    return card


## Returns whether this pile enforces rank ordering
func enforces_rank_order() -> bool:
    return rank_order


func _on_mouse_entered() -> void:
    var can_pick_up_card = selectable && GameState.selected_card == null && !cards.is_empty()
    if can_pick_up_card:
        # Visually show that the card can be picked up
        cards.peek().hover(true)


func _on_mouse_exited() -> void:
    if selectable && !cards.is_empty():
        cards.peek().hover(false)


func _on_area_entered(area: Area2D) -> void:
    var c := area.get_parent() as Card
    if c:
        if GameState.selected_card:
            if RulesManager.is_legal_move(GameState.selected_card, self):
                GameState.dest_pile = self
                c.highlight_on(RulesManager.legal_move_color)
            else:
                c.highlight_on(RulesManager.illegal_move_color)


func _on_area_exited(area: Area2D) -> void:
    var c := area.get_parent() as Card
    # If we set this slot as the destination, unset it
    if c && GameState.dest_pile == self:
        GameState.dest_pile = null

    c.highlight_off()

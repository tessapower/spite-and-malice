extends Node2D

## game.gd: controls the main game scene, and is used to keep track of turns.
##
## Author(s): Tessa Power

@onready var space_state = get_world_2d().direct_space_state
@onready var params = PhysicsPointQueryParameters2D.new()
var playing_cards: Array[Card] = Deck.new_deck(true)
@onready var window_size = get_viewport_rect().size
var dragging: bool = false

const MOUSE_INPUT_LAYER: int = 1

func _ready() -> void:
    # Set up object click detection
    get_viewport().physics_object_picking_sort = true
    get_viewport().physics_object_picking_first_only = true
    params.collide_with_areas = true
    params.collision_mask = MOUSE_INPUT_LAYER

    # Deal some cards
    # TODO: this is a test, remove later
    #playing_cards.shuffle()
    for i in range(5):
        var card: Card = playing_cards.pop_front()
        $PlayerView.add_to_hand(card)
        card = playing_cards.pop_front()
        $OpponentView.add_to_hand(card)


func _process(_delta: float) -> void:
    if GameState.selected_card:
        var mouse_pos = get_global_mouse_position()
        if !dragging:
            start_dragging_card(mouse_pos)
        else:
            GameState.selected_card.position = mouse_pos


func _input(event) -> void:
    # Check for user click events
    if event.is_action_pressed("Left Click"):
        var node = check_for_node()

        if node is CardSlot:
            var card_slot: CardSlot = node
            if card_slot.selectable && card_slot.card:
                GameState.select_card(card_slot.card)
        elif node is Pile:
            var pile: Pile = node
            if pile.selectable && !pile.is_empty():
                GameState.select_card(pile.peek_top_card())
    elif event.is_action_released("Left Click"):
        dragging = false
        if GameState.selected_card: # If we are dragging a card
            GameState.selected_card.drag(dragging)
            # dest_pile will be populated when we're holding a selected card
            # over a pile that is a legal move
            if GameState.dest_pile:
                move_card_to(GameState.selected_card, GameState.dest_pile)
                GameState.deselect_card()
                GameState.dest_pile = null
            else: # Return the card to the pile it came from
                GameState.selected_card.return_to_pile()
                GameState.deselect_card()


func move_card_to(card: Card, destination) -> void:
    if card.parent is CardSlot:
        card.parent.remove_card()
    elif card.parent is Pile:
        card.parent.pop_top_card()

    if destination is CardSlot:
        destination.set_card(card)
        card.return_to_pile()
    elif destination is Pile:
        destination.add(card)
        card.return_to_pile()

    # Stop highlighting the card
    card.highlight_off()


func start_dragging_card(mouse_pos: Vector2) -> void:
    # Constrain card to window
    # TODO: clamp better so that we take size of card into account
    var tween = get_tree().create_tween()
    tween.tween_property(GameState.selected_card, "position", Vector2(
        clamp(mouse_pos.x, 0, window_size.x),
        clamp(mouse_pos.y, 0, window_size.y)), 0.025)
    tween.tween_property(GameState.selected_card, "scale",
        GameState.selected_card.DRAG_SCALE, 0.1)
    dragging = true

    GameState.selected_card.drag(dragging)


# Returns either the top-most object beneath the mouse or null
func check_for_node() -> Variant:
    params.position = get_global_mouse_position()
    var result = space_state.intersect_point(params)

    return null if result.is_empty() else result[0].collider.get_parent()

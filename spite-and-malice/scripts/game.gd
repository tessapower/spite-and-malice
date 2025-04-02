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
    playing_cards.shuffle()
    for i in range(3):
        var card: Card = playing_cards.pop_front()
        $PlayerView.add_to_hand(card)


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

        # TODO: Refactor to only (de)select cards on left click. Dragging cards
        # to piles is more intuitive
        if node is CardSlot:
            var card_slot: CardSlot = node
            if card_slot.card:
                GameState.select_card(card_slot.card)
        elif node is Pile:
            # TODO: select card
            return
    elif event.is_action_released("Left Click"):
        dragging = false
        if GameState.selected_card: # If we are dragging a card
            GameState.selected_card.drag(dragging)
            if GameState.dest_pile: # and we're holding it over a pile
                move_card_between_piles(GameState.selected_card, GameState.dest_pile)
                GameState.deselect_card()
                GameState.dest_pile = null
            else: # Return the card to the pile it came from
                GameState.selected_card.move_to_parent_position()
                GameState.deselect_card()


func move_card_between_piles(card: Card, destination: CardSlot) -> void:
    card.parent.remove_card()
    destination.set_card(card)
    # Stop highlighting the card
    card.highlight_off()


func start_dragging_card(mouse_pos: Vector2) -> void:
    # Constrain card to window
    # TODO: clamp better so that we take size of card into account
    var tween = get_tree().create_tween()
    tween.tween_property(GameState.selected_card, "position", Vector2(
        clamp(mouse_pos.x, 0, window_size.x),
        clamp(mouse_pos.y, 0, window_size.y)), 0.025)
    dragging = true

    GameState.selected_card.drag(dragging)


# Returns either the top-most object beneath the mouse or null
func check_for_node() -> Variant:
    params.position = get_global_mouse_position()
    var result = space_state.intersect_point(params)

    return null if result.is_empty() else result[0].collider.get_parent()

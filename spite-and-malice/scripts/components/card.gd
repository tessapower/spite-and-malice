class_name Card
extends Node2D

## card.gd: represents a single playing card in a deck of cards.
##
## Author(s): Tessa Power

enum Suit { CLUBS, DIAMONDS, HEARTS, SPADES, NONE }
enum Rank { ACE = 1, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN,
            JACK, QUEEN, KING, JOKER }

# Card Variables
var rank: Rank = Rank.ACE
var suit: Suit = Suit.SPADES
var selectable: bool = false
var parent = null

# Card constants
const NORMAL_SCALE: Vector2 = Vector2(1.0, 1.0)
const NORMAL_Z_IDX: int = 2
const HOVERED_SCALE: Vector2 = Vector2(1.05, 1.05)
const HOVERED_Z_IDX: int = 3
const DRAG_SCALE: Vector2 = Vector2(1.0, 1.0)
const DRAG_Z_IDX: int = 4
const image = preload("res://assets/graphics/cards/BACK.png")

func _ready() -> void:
    z_index = NORMAL_Z_IDX
    scale = NORMAL_SCALE

# Set up card data
func init(card_rank: Rank, card_suit: Suit):
    suit = card_suit
    rank = card_rank


func set_parent(card_slot: CardSlot) -> void:
    parent = card_slot
    if card_slot != null:
        position = parent.position
        move_to_parent_position()


func _process(_delta) -> void:
    if $CardImage != null:
        if $CardImage.texture == null:
            $CardImage.texture = load(_image_path(suit, rank))


func highlight_on(color: Color) -> void:
    modulate = color


func highlight_off() -> void:
    modulate = Color(1.0, 1.0, 1.0)


func hover(should_highlight: bool) -> void:
    scale = HOVERED_SCALE if should_highlight else NORMAL_SCALE
    z_index = HOVERED_Z_IDX if should_highlight else NORMAL_Z_IDX


func drag(is_being_dragged: bool) -> void:
    scale = DRAG_SCALE if is_being_dragged else NORMAL_SCALE
    z_index = DRAG_Z_IDX if is_being_dragged else NORMAL_Z_IDX


func _image_path(s: Suit, r: Rank) -> String:
    var path = "res://assets/graphics/cards/"

    match s:
        Suit.CLUBS:
            path += "CLUBS_"
        Suit.DIAMONDS:
            path += "DIAMONDS_"
        Suit.HEARTS:
            path += "HEARTS_"
        Suit.SPADES:
            path += "SPADES_"
        Suit.NONE:
            path += "JOKER_"

    if r == Rank.JOKER:
        # Randomly pick red or black
        var color = randi_range(0, 1)
        path += "BLACK" if color == 0 else "RED"
    else:
        path += String.num_int64(rank)

    path += ".png"

    return path


func _to_string() -> String:
    return str("rank: ", rank, ", suit: ", suit)


# TODO: rename to return_to_pile() after refactoring
func move_to_parent_position() -> void:
    if parent:
        var tween = get_tree().create_tween()
        tween.tween_property(self, "position", parent.position, 0.1)

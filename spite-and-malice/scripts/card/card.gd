class_name Card
extends Node2D

## card.gd: represents a single playing card in a deck of cards.
##
## Author(s): Tessa Power

enum State { DRAW_PILE, PLAY_PILE, GOAL_PILE, DISCARD_PILE, IN_HAND }
enum Suit { CLUBS, DIAMONDS, HEARTS, SPADES }
enum Rank { ACE = 1, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN,
            JACK, QUEEN, KING, JOKER }

var state: State
var suit: Suit
var rank: Rank
var selectable: bool = false


func _on_mouse_entered():
    # TODO: zoom a bit? highlight?
    pass # Replace with function body.


func _on_mouse_exited():
    # TODO: unzoom/unhighlight
    pass # Replace with function body.

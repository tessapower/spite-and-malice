class_name Opponent
extends Player

## opponent.gd: a data class to hold the cards and card piles that belong to the
## player's opponent.

func init_goal_pile(goal_cards: Array[Card]) -> void:
    for card in goal_cards:
        card.selectable = false
    super(goal_cards)

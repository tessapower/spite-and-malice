extends Node

## deck.gd: represents a deck of playing cards.
##
## Author(s): Tessa Power

var card_scene: PackedScene = load("res://scenes/components/card.tscn")

## Returns a deck of 52 playing cards with optionally two jokers
func new_deck(include_jokers: bool) -> Array[Card]:
    var deck: Array[Card] = []

    for suit in Card.Suit.values().slice(0, -1):
        for rank in Card.Rank.values().slice(0, -1):
            var card = card_scene.instantiate()
            card.init(rank, suit)
            deck.append(card)

    # Add two jokers to the deck if they should be included
    if (include_jokers):
        var joker_1 = card_scene.instantiate()
        joker_1.init(Card.Rank.JOKER, Card.Suit.NONE)
        deck.append(joker_1)

        var joker_2 = card_scene.instantiate()
        joker_2.init(Card.Rank.JOKER, Card.Suit.NONE)
        deck.append(joker_2)

    return deck

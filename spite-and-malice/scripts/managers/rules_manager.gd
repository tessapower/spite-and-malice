extends Node

## rules_manager.gd: helps to enforce the rules of the game through
## functions which can be used to check if a card is playable.
##
## Author(s): Tessa Power

# Rules of Spite and Malice:
# The object of the game is to be the first to get rid of all cards in the
# goal pile (A.K.A. pay-off pile) by placing them on the play piles
# (A.K.A. center stacks).
#
# To begin, two packs of cards are shuffled, with half of the cards going to
# the draw pile (A.K.A. stock pile), which players initially draw five cards
# from. The other half of the cards are split into two equally-sized goal piles
# for each player. The first card of each goal pile is turned face up, and the
# player with the highest card gets to go first. At this point, the play piles
# and both player's discard piles (A.K.A. side stacks) are empty.
#
# During each turn, players place cards from their hand, goal pile, or discard
# piles on the play piles, which are initially empty. To start a play pile, an
# ace must first be placed. Cards can be placed on any play pile, but must be
# played in the order of rank (A, 2, 3, ..., J, Q, K). Jokers are wildcards
# and can be played in place of any card, except for Aces. There is a max. of
# four play piles allowed at any given time.
#
# Players must always begin each turn by ensuring they have five cards in hand.
# Cards can be played to the play piles from the player's hand, the _top_ of a
# discard pile, or the _top_ of a goal pile. The player can play as many cards
# to the play piles as they want/are able to. If during their turn the player
# manages to play all five cards from their hand, without playing to a discard
# pile, they immediately draw five more cards from the draw pile and continue
# playing. Players signal the end of their turn by playing a card to one of
# their discard piles. Each player has a maximum of four discard piles, and may
# place cards on discard piles in any order.
#

const legal_move_color: Color = Color(0.275, 0.733, 0.529)
const illegal_move_color: Color = Color(0.986, 0.435, 0.435)


func is_legal_move(card: Card, destination: Pile) -> bool:
    var source = card.parent

    if destination.enforces_rank_order() && !destination.is_empty():
        return card.rank > destination.peek_top_card().rank

    if source is CardSlot:
        return destination.type == Pile.Type.PLAY_PILE \
            || destination.type == Pile.Type.DISCARD_PILE
    elif source is Pile:
        match source.type:
            Pile.Type.DISCARD_PILE, Pile.Type.GOAL_PILE:
                return destination.type == Pile.Type.PLAY_PILE
            Pile.Type.DRAW_PILE, Pile.Type.PLAY_PILE: return false

    return false

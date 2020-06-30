//
//  MemoryGame.swift
//  Memorize
//
//  Created by Adiel Hernandez on 6/29/20.
//  Copyright © 2020 Adiel Hernandez. All rights reserved.
//

import Foundation

struct MemoryGame<CardContent> {
    var cards: Array<Card>
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent){
        cards = Array<Card>()
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2+1))
        }
        cards = cards.shuffled()
    }
    
    mutating func choose(card: Card) {
        print("card chosen: \(card)")
        let cardIndex: Int = findCardIndex(of: card)
        self.cards[cardIndex].isFaceUp = !self.cards[cardIndex].isFaceUp
    }
    
    func findCardIndex(of otherCard: Card) -> Int {
        for cardIndex in 0..<cards.count {
            if cards[cardIndex].id == otherCard.id {
                return cardIndex
            }
        }
        return cards.count * 5 // TODO: bogus!
    }
    
    struct Card: Identifiable {
        var isFaceUp: Bool = true
        var isMatched: Bool = false
        var content: CardContent
        var id: Int
    }
}

//
//  MemoryGame.swift
//  Memorize
//
//  Created by Adiel Hernandez on 6/29/20.
//  Copyright © 2020 Adiel Hernandez. All rights reserved.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    private(set) var gameSettings: Theme
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter { index in cards[index].isFaceUp }.only }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = index == newValue
            }
        }
    }
    
    init(numberOfPairsOfCards: Int, themeName: String, emojiSet: Array<CardContent>, cardContentFactory: (Int) -> CardContent){
        cards = Array<Card>()
        gameSettings = Theme(name: themeName, emojiSet: emojiSet, numCards: numberOfPairsOfCards)
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2+1))
        }
        cards = cards.shuffled()
    }
    
    // Choose function, chooses a card and runs the logic of the game.
    mutating func choose(card: Card) {
        if let chosenIndex = cards.firstIndex(matching: card), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched {
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                }
                self.cards[chosenIndex].isFaceUp = true
            } else {
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
        }
    }
    
    func themeColor() -> String {
        return gameSettings.name
    }
    
    // Create Card Struct to encapsulate Card characteristics.
    struct Card: Identifiable {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent
        var id: Int
    }
    
    struct Theme {
        var name: String
        var emojiSet: Array<CardContent>
        var numCards: Int?
    }
}

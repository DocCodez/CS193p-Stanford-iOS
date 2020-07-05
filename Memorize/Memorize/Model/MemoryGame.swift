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
    private(set) var gameInfo: Game
    
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
        gameInfo = Game(name: themeName, emojiSet: emojiSet, numCards: numberOfPairsOfCards)
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2+1))
        }
        cards.shuffle()
    }
    
    // TODO: Add bonus points for matching quicker.
    // Choose function, chooses a card and runs the logic of the game.
    mutating func choose(card: Card) {
        resetScoreUpdated()
        if let chosenIndex = cards.firstIndex(matching: card), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched {
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    gameInfo.score = gameInfo.score + 2
                    gameInfo.score = gameInfo.score + (Int(card.bonusRemaining * 10))
                    cards[chosenIndex].scoreUpdateValue = (Int(card.bonusRemaining * 10)) + 2
                    cards[chosenIndex].scoreUpdated = true
                } else {
                    if cards[potentialMatchIndex].hasBeenSeen || cards[chosenIndex].hasBeenSeen {
                        gameInfo.score = gameInfo.score - 1
                        cards[chosenIndex].scoreUpdateValue = -1
                        cards[chosenIndex].scoreUpdated = true
                    } else {
                        cards[chosenIndex].scoreUpdated = false
                    }
                    cards[chosenIndex].hasBeenSeen = true
                    cards[potentialMatchIndex].hasBeenSeen = true
                }
                self.cards[chosenIndex].isFaceUp = true
            } else {
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
        }
    }
    
    private mutating func resetScoreUpdated() {
        for card in 0..<cards.count {
            cards[card].scoreUpdated = false
        }
    }
    
    func themeColor() -> String {
        return gameInfo.name
    }
    
    // Create Card Struct to encapsulate Card characteristics.
    struct Card: Identifiable {
        var isFaceUp: Bool = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched: Bool = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        var hasBeenSeen: Bool = false
        var content: CardContent
        var scoreUpdateValue: Int = 0
        var scoreUpdated: Bool = false
        var potentialMatchIsMatched: Bool = false
        var id: Int
        
        
        // MARK: - Bonus Time

        // this could give matching bonus points
        // if the user matches the card
        // before a certain amount of time passes during which the card is face up

        // can be zero which means "no bonus available" for this card
        var bonusTimeLimit: TimeInterval = 6
        
        // how long this card has ever been face up
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        
        // the last time this card turned face up (and is still face up)
        var lastFaceUpDate: Date?
        
        // the accumulated time this card has been face up in the past
        // (i.e. not including the current time its been face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0
        
        // how much time left before the bonus opportunity runs out
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        
        // the percentage of the bonus time remaining
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
        }
        
        // whether the card was matched during the bonus time period
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        
        // wehther we are currently face up, unmatched and have not yet used up the bonus window
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        
        // called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        // called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
    }
    
    struct Game {
        var name: String
        var emojiSet: Array<CardContent>
        var numCards: Int?
        var score: Int = 0
    }
        
}





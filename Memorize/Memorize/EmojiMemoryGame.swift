//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Adiel Hernandez on 6/29/20.
//  Copyright © 2020 Adiel Hernandez. All rights reserved.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    @Published private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
    
    static private let emojiSet: Array<String> = ["⚽️", "🏀", "🏈", "⚾️", "🎾", "🏐", "🏉", "🎱", "🏓", "🥊", "🏄🏻‍♂️", "🏊🏼"]
    
    static func createMemoryGame() -> MemoryGame<String> {
        var emojis: Array<String> = []
        for _ in 0..<Int.random(in: 2...5) {
            while true {
                let randomEmoji = EmojiMemoryGame.emojiSet.randomElement()!
                if emojis.contains(randomEmoji) {
                    continue
                }
                else {
                    emojis.append(randomEmoji)
                    break
                }
            }
        }
        return MemoryGame<String>(numberOfPairsOfCards: emojis.count) { pairIndex in
            return emojis[pairIndex]
        }
    }
    
    // MARK: - Access to the Model
    
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    
    // MARK: - Intent(s)
    
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
}

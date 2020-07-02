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
    
    static private let lowerBoundRandom: Int = 2
    static private let upperBoundRandom: Int = 6
    
    static private var emojiSet: [String: Array<String>] {
        let emojiSetSports = ["⚽️", "🏀", "🏈", "⚾️", "🎾", "🏐", "🏉", "🎱", "🏓", "🥊", "🏄🏻‍♂️", "🏊🏼"]
        let emojiSetFaces = ["😀","😁","😅","😆","🤣","🥰","😎","🤩","😘","🧐","😳","😡"]
        let emojiSetFlags = ["🇨🇺","🇺🇸","🇵🇷","🇮🇪","🇮🇹","🇮🇸","🇧🇷","🇫🇷","🇨🇦","🏴󠁧󠁢󠁥󠁮󠁧󠁿","🇩🇪","🇬🇷"]
        let emojiSetAnimals = ["🐶","🐱","🐰","🐵","🐷","🦈","🦨","🦁","🐻","🐸","🦄","🐊"]
        let emojiSetFood = ["🍔","🍕","🍌","🍟","🍤","🍇","🍞","🥓","🌭","🍗","🍣","🍦"]
        let emojiSetWeather = ["🌈","🌪","⛈","❄️","☃️","🌬","☔️","⚡️","🔥","🌤","☀️","☄️"]
        
        return ["Sports": emojiSetSports,
                "Faces": emojiSetFaces,
                "Flags": emojiSetFlags,
                "Animals": emojiSetAnimals,
                "Food": emojiSetFood,
                "Weather": emojiSetWeather]
    }
    
    private static func createMemoryGame() -> MemoryGame<String> {
        var emojis: Array<String> = []
        var nameOfTheme: String = ""
        var setOfEmojis: Array<String> = []
        let randomEmojiSet = EmojiMemoryGame.emojiSet.randomElement()!
        nameOfTheme = randomEmojiSet.key
        setOfEmojis = randomEmojiSet.value
        for _ in 0..<Int.random(in: EmojiMemoryGame.lowerBoundRandom...EmojiMemoryGame.upperBoundRandom) {
            while true {
                let randomEmoji = randomEmojiSet.value.randomElement()!
                if emojis.contains(randomEmoji) {
                    continue
                }
                else {
                    emojis.append(randomEmoji)
                    break
                }
            }
        }
        return MemoryGame<String>(numberOfPairsOfCards: emojis.count, themeName: nameOfTheme, emojiSet: setOfEmojis) { pairIndex in
            emojis[pairIndex]
        }
    }
    
    private static func chooseColor(themeName: String) -> Color {
        return Color.orange
    }
    
    // MARK: - Access to the Model
    
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    
    // MARK: - Intent(s)
    
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
    
    func themeColor() -> Color {
        let theme = model.themeColor()
        switch theme {
        case "Sports":
            return Color.blue
        case "Faces":
            return Color.yellow
        case "Flags":
            return Color.green
        case "Animals":
            return Color.purple
        case "Food":
            return Color.primary
        case "Weather":
            return Color.gray
        default:
            return Color.accentColor
        }
    }
}

//
//  ThemeSelection.swift
//  Memorize
//
//  Created by Adiel Hernandez on 7/5/20.
//  Copyright © 2020 Adiel Hernandez. All rights reserved.
//

import SwiftUI

struct ThemeSelection: View {
    
    var body: some View {
        NavigationView{
            List{
                ForEach(EmojiMemoryGame.retrieveThemes().sorted(), id: \.self) { theme in
                    NavigationLink(destination: EmojiMemoryGameView(viewModel: EmojiMemoryGame(game: ThemeSelection.self.createMemoryGame(theme: theme)))) {
                        VStack(alignment: .leading) {
                            Text(theme).foregroundColor(EmojiMemoryGame.getThemeColor(theme: theme)).font(.title)
                            Text(EmojiMemoryGame.retrieveThemeEmojis(theme: theme).joined()).font(.headline)
                            
                        }
                    }
                }
            }
            .navigationBarTitle("Themes")
        }
    }
    
    static func createMemoryGame(theme: String) -> MemoryGame<String> {
        let randomEmojisChosen = EmojiMemoryGame.chooseRandomEmojiForGame(setOfEmojis: EmojiMemoryGame.retrieveThemeEmojis(theme: theme))
        let randomEmojisChosenCount = randomEmojisChosen.count
        return MemoryGame<String>(numberOfPairsOfCards: randomEmojisChosenCount, themeName: theme, emojiSet: EmojiMemoryGame.retrieveThemeEmojis(theme: theme)) { pairIndex in
            randomEmojisChosen[pairIndex]
        }
    }
}


struct ThemeSelection_Previews: PreviewProvider {
    static var previews: some View {
        ThemeSelection()
    }
}

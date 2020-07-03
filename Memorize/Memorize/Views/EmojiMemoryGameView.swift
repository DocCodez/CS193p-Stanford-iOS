//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Adiel Hernandez on 6/29/20.
//  Copyright © 2020 Adiel Hernandez. All rights reserved.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject private(set) var viewModel: EmojiMemoryGame
    
    var body: some View {
        VStack {
            // HStack for the navigation bar item and new game button at top of the screen.
            HStack {
                Text(viewModel.gameSettings.name) // TODO: Create a navigation bar item that takes back to view displaying themes to play.
                Spacer()
                Button(action: {
                    withAnimation(.easeInOut){
                        self.viewModel.resetGame()
                    }
                }) {
                    Text("New Game")
                }
            }
            .font(.headline)
            .padding()
            
            // Text For the title of the theme.
            HStack {
                Text(viewModel.gameSettings.name)
                    .bold()
                Spacer()
            }
            .font(.largeTitle)
            .padding(.leading)
            
            // Grid for the cards.
            Grid(viewModel.cards) { card in
                CardView(card: card).onTapGesture {
                    withAnimation(.easeInOut){
                        self.viewModel.choose(card: card)
                    }
                }
            .padding(5)
            .foregroundColor(self.viewModel.themeColor())
            }
            
            // Text For the score at bottom of screen.
            HStack {
                Text("Score: \(viewModel.gameScore)")
            }
            .font(.largeTitle)
                
                .padding()
        }
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }
    
    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
            ZStack {
                Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(110-90), clockwise: true)
                    .padding(5)
                    .opacity(0.40)
                Text(self.card.content)
                    .font(Font.system(size: fontSize(for: size)))
                    .rotationEffect(Angle.degrees(card.isMatched ? 360: 0))
                    .animation(card.isMatched ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default)
            }
            .cardify(isFaceUp: card.isFaceUp)
            .transition(AnyTransition.scale)
        }
    }
    
    // MARK: - Drawing Constants
    
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.7
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        return EmojiMemoryGameView(viewModel: game)
    }
}

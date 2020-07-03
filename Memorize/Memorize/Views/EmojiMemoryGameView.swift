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
    
    @State private var animatedBonusRemaining: Double = 0
    
    private func startBonusTimeAnimation() {
        animatedBonusRemaining = card.bonusRemaining
        withAnimation(.linear(duration: card.bonusTimeRemaining)) {
            animatedBonusRemaining = 0
        }
    }
    
    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle.degrees(0-quarterCircleAngle), endAngle: Angle.degrees(-animatedBonusRemaining*fullCircleAngle-quarterCircleAngle), clockwise: true)
                            .onAppear {
                                self.startBonusTimeAnimation()
                        }
                    } else {
                        Pie(startAngle: Angle.degrees(0-quarterCircleAngle), endAngle: Angle.degrees(-card.bonusRemaining*fullCircleAngle-quarterCircleAngle), clockwise: true)
                    }
                }
                .padding(piePadding).opacity(pieOpacity)
                Text(self.card.content)
                    .font(Font.system(size: fontSize(for: size)))
                    .rotationEffect(Angle.degrees(card.isMatched ? fullCircleAngle: 0))
                    .animation(card.isMatched ? Animation.linear(duration: animationDuration).repeatForever(autoreverses: false) : .default)
            }
            .cardify(isFaceUp: card.isFaceUp)
            .transition(AnyTransition.scale)
        }
    }
    
    // MARK: - Drawing Constants
    
    private let fullCircleAngle: Double = 360
    private let quarterCircleAngle: Double = 90
    private let halfCircleAngle: Double = 180
    private let pieOpacity: Double = 0.4
    private let piePadding: CGFloat = 5
    private let animationDuration: Double = 1
    
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

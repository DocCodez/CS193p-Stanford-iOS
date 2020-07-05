//
//  ScoringAnimation.swift
//  Memorize
//
//  Created by Adiel Hernandez on 7/3/20.
//  Copyright © 2020 Adiel Hernandez. All rights reserved.
//

import SwiftUI

struct ScoringAnimation: View {
    var scoreUpdate: Int
    
    var body: some View {
        Text(scoreUpdate > 0 ? "+\(scoreUpdate)" : "\(scoreUpdate)")
            .font(.title)
            .foregroundColor(scoreUpdate > 0 ? Color.green : Color.red)
            .bold()
    }
}

struct ScoringAnimation_Previews: PreviewProvider {
    static var previews: some View {
        ScoringAnimation(scoreUpdate: 10)
    }
}

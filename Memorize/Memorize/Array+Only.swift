//
//  Array+Only.swift
//  Memorize
//
//  Created by Adiel Hernandez on 6/30/20.
//  Copyright © 2020 Adiel Hernandez. All rights reserved.
//

import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}

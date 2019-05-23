//
//  Extentions.swift
//  customer
//
//  Created by Tom Manuel on 5/7/19.
//  Copyright © 2019 Tom Manuel. All rights reserved.
//

import Foundation

enum UIViewBackgroundAnimationState {
    case lighten
    case darken
}

extension Date {
    func adding(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
}

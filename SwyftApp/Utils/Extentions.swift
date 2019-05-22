//
//  Extentions.swift
//  customer
//
//  Created by Tom Manuel on 5/7/19.
//  Copyright © 2019 Tom Manuel. All rights reserved.
//

import Foundation
import UIKit

extension Date {
    func adding(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
}

extension UITextField {
    
    func addBottomBoarder(color: UIColor, bgColor: UIColor = UIColor.white){
        
        self.borderStyle = .none
        self.layer.backgroundColor = bgColor.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
        
    }
    
    func addDashedBottomBoarder(color: UIColor, bgColor: UIColor = UIColor.white){
        
        let boarder = CAShapeLayer()
        let width: CGFloat = 1
        let shapeRect = CGRect(x: 0, y: self.frame.maxY-width, width: self.frame.width, height: width)
        boarder.strokeColor = UIColor.black.cgColor
        boarder.lineDashPattern = [1, 2]
        boarder.frame = shapeRect
        boarder.fillColor = nil
        boarder.path = UIBezierPath(rect: shapeRect).cgPath
        self.borderStyle = .none
        self.layer.backgroundColor = bgColor.cgColor
        self.layer.addSublayer(boarder)
        self.layer.masksToBounds = false

        
    }
}

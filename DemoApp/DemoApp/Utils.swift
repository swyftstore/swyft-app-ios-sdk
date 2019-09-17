//
//  Utils.swift
//  DemoApp
//
//  Created by Rigoberto Saenz Imbacuan on 9/17/19.
//  Copyright © 2019 Swyft Inc. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func loadViewController<T: UIViewController>(from bundle: Bundle = .main) -> T {
        
        let identifier = className(some: T.self)
        let storyboard = UIStoryboard(name: identifier, bundle: bundle)
        
        guard let screen = storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
            fatalError("UIViewController with identifier '\(identifier)' was not found")
        }
        return screen
    }
}

extension UITableView {
    
    func dequeue<T: UITableViewCell>(_ indexPath: IndexPath) -> T {
        
        let identifier = className(some: T.self)
        let rawCell = self.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        guard let cell = rawCell as? T else {
            fatalError("UITableViewCell with identifier '\(identifier)' was not found")
        }
        return cell
    }
}

private func className(some: Any) -> String {
    return (some is Any.Type) ? "\(some)" : "\(type(of: some))"
}

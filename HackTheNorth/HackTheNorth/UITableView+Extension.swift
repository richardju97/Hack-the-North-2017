//
//  UITableView+Extension.swift
//  HackTheNorth
//
//  Created by Ryuji Mano on 9/16/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import UIKit

extension UITableView {
    func register<T: UITableViewCell>(cellType: T.Type) {
        let className = cellType.className
        let cellNib = UINib(nibName: className, bundle: nil)
        self.register(cellNib, forCellReuseIdentifier: className)
    }

    func register<T: UITableViewCell>(cellTypes: [T.Type]) {
        cellTypes.forEach { register(cellType: $0) }
    }

    func dequeueReusableCell<T: UITableViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: type.className, for: indexPath) as? T else {
            fatalError()
        }
        return cell
    }
}

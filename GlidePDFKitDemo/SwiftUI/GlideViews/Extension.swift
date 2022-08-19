//
//  Extension.swift
//  GlidePDFKitDemo
//
//  Created by Qinchao Xu on 2022/8/19.
//

import Foundation
import UIKit
import SwiftUI

public extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hex & 0x00ff00) >> 8) / 255.0
        let blue = CGFloat((hex & 0x0000ff) >> 0) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

extension Color {
    static let gray40 = Color(UIColor(hex: 0xDADADA))
    static let lightGreen = Color(UIColor(hex: 0xF6FEFD))
}

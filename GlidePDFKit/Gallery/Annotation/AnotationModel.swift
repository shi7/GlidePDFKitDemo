//
//  AnotationModel.swift
//  GlidePDFKitDemo
//
//  Created by shanks on 2022/8/17.
//

import Foundation
import SwiftUI

struct AnotationModel: Identifiable {
    var id = UUID()

    var x: CGFloat
    var y: CGFloat
    var w: CGFloat
    var h: CGFloat
//    var location: CGPoint

    var type : AnotationType
    var image : UIImage?
}

enum AnotationType {
    case Image, Text
}

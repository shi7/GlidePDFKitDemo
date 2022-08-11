//
//  BottomButton.swift
//  GlidePDFKitDemo
//
//  Created by shanks on 2022/8/11.
//

import UIKit

enum BottomButtonActions {
    case addAnnotion
    case removeAnnotion
    case addPoint

    var image: UIImage? {
        switch self {
        case .addAnnotion: return UIImage(named: "draw")
        case .removeAnnotion: return UIImage(named: "delete")
        case .addPoint: return UIImage(named: "search")
        }
    }
}

class BottomButton: UIButton {

    var actionType: BottomButtonActions

    init(frame: CGRect,actionType: BottomButtonActions) {
        self.actionType = actionType
        super.init(frame: frame)
        self.setImage(actionType.image, for: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

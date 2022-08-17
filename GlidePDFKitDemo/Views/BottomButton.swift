//
//  BottomButton.swift
//  GlidePDFKitDemo
//
//  Created by shanks on 2022/8/11.
//

import UIKit

enum BottomButtonActions {
    case addImageAnnotation
    case addTextAnnotation
    case removeAnnotation

    var image: UIImage? {
        switch self {
        case .addImageAnnotation: return UIImage(named: "draw")
        case .removeAnnotation: return UIImage(named: "delete")
        case .addTextAnnotation: return UIImage(named: "plus")
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

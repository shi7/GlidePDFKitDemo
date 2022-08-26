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
    case updateAnnotation

    case addCheckbox
    case addLine
    case addRadio

    var image: UIImage? {
        switch self {
        case .addImageAnnotation: return UIImage(named: "plus")
        case .removeAnnotation: return UIImage(named: "delete")
        case .addTextAnnotation: return UIImage(named: "draw")
        case .updateAnnotation: return UIImage(named: "floodway")
        default: return UIImage(named: "plus")
        }
    }

    var title: String? {
        switch self {
        case .addImageAnnotation: return "add image"
        case .removeAnnotation: return "delete"
        case .addTextAnnotation: return "add text"
        case .updateAnnotation: return "update"
        case .addCheckbox: return "checkbox"
        case .addLine: return "line"
        case .addRadio: return "radio"
        }
    }
}

class BottomButton: UIButton {
    var actionType: BottomButtonActions

    init(frame: CGRect, actionType: BottomButtonActions) {
        self.actionType = actionType
        super.init(frame: frame)
        setImage(actionType.image, for: .normal)
        setTitle(actionType.title, for: .normal)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

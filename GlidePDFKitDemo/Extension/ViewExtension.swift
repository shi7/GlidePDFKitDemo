//
//  ViewExtention.swift
//  GlidePDFKitDemo
//
//  Created by shanks on 2022/8/11.
//
import UIKit
import SnapKit

extension UIView {
    func addSubview(_ view: UIView, make: (ConstraintMaker) -> Void) {
        addSubview(view)
        view.snp.makeConstraints(make)
    }

    func addLayoutGuide(_ guide: UILayoutGuide, make: (ConstraintMaker) -> Void) {
        addLayoutGuide(guide)
        guide.snp.makeConstraints(make)
    }
}

public extension UIStackView {
    func addArrangedSubview(_ view: UIView, isHidden: Bool = false, make: (ConstraintMaker) -> Void) {
        addArrangedSubview(view, isHidden: isHidden)
        view.snp.makeConstraints(make)
    }

    func addArrangedSubview(_ view: UIView, isHidden: Bool = false) {
        addArrangedSubview(view)
        view.isHidden = isHidden
    }
}

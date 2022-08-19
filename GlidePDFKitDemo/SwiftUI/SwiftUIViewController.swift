//
//  SwiftUIViewController.swift
//  GlidePDFKitDemo
//
//  Created by QinChao Xu on 2022/8/17.
//

import UIKit
import SwiftUI

class SwiftUIViewController: UIViewController {

    override func viewDidLoad() {
        setupSwiftUI()
    }

    func setupSwiftUI() {
        let controller = UIHostingController(rootView: MainView())
        if let swiftUIView = controller.view {
            view.addSubview(swiftUIView) { make in
                make.edges.equalToSuperview()
            }
        }
    }
}

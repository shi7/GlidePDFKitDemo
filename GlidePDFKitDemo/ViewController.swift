//
//  ViewController.swift
//  GlidePDFKitDemo
//
//  Created by shanks on 2022/8/11.
//

import UIKit
import SnapKit
import SwiftUI

class ViewController: UIViewController {
    let pdfView = PDFView()
    let previousButton: UIButton = {
        let button = UIButton()
        button.setTitle("Previous page", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(goPreviousPage), for: .touchUpInside)
        return button
    } ()
    let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next page", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(goNextPage), for: .touchUpInside)
        return button
    } ()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        loadPDF()
        setupViews()
    }

    func setupViews() {
//        pdfView.contentMode = .scaleAspectFit
//        view.addSubview(pdfView)
//        pdfView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }

        setupGallery()
        setupTopBtns()
        addBottomView()
    }
    
    func setupTopBtns() {
        view.addSubview(previousButton)
        previousButton.backgroundColor = UIColor.green
        previousButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(40)
            make.width.equalTo(150)
            make.height.equalTo(40)
        }

        view.addSubview(nextButton)
        nextButton.backgroundColor = UIColor.green
        nextButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(40)
            make.width.equalTo(150)
            make.height.equalTo(40)
        }
    }
    
    func setupGallery() {
        let galleryVC = UIHostingController(rootView: GalleryEntry(images: pdfView.pdfImages))
        
        if let gallery = galleryVC.view {
            gallery.contentMode = .scaleAspectFit
            view.addSubview(gallery)
            gallery.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }

    func loadPDF() {
        let fileUrl = Bundle.main.url(forResource: "read-only", withExtension: "pdf")!
        pdfView.loadPDF(url: fileUrl)
    }

    @objc func goPreviousPage(sender: UIButton) {
        pdfView.goPreviousPage()
    }

    @objc func goNextPage(sender: UIButton) {
        pdfView.goNextPage()
    }

    func addBottomView() {
        let bottomStack = UIStackView()
        bottomStack.alignment = .center
        bottomStack.spacing = 50
        bottomStack.distribution = .fillEqually

        bottomStack.backgroundColor = .lightGray
        let buttonActions: [BottomButtonActions] = [.removeAnnotion,.addAnnotion,.addPoint]
        for type in buttonActions {
            let button = BottomButton(frame: CGRect.zero, actionType: type)
            button.addTarget(self, action: #selector(didTapBottomAction), for: .touchUpInside)
            bottomStack.addArrangedSubview(button) { make in
                make.width.height.equalTo(60)
            }
        }

        view.addSubview(bottomStack) { make in
            make.left.right.bottom.equalToSuperview()
        }
    }

    @objc private func didTapBottomAction(button:BottomButton) {
        print("\(button.actionType)")
    }
}


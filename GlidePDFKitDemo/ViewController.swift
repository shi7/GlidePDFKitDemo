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
    let pdfLoader = PDFLoader()
    let pdfContainer = UIView()
    let loadPDFFromFileButton: UIButton = {
        let button = UIButton()
        button.setTitle("Read from file", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.backgroundColor = UIColor.green
        button.addTarget(self, action: #selector(loadPDFFromFile), for: .touchUpInside)
        return button
    } ()
    let loadPDFFromURLButton: UIButton = {
        let button = UIButton()
        button.setTitle("Read from url", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.backgroundColor = UIColor.green
        button.addTarget(self, action: #selector(loadPDFFromURL), for: .touchUpInside)
        return button
    } ()
    let loadingView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.hidesWhenStopped = true
        return indicator
    } ()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        setupViews()
    }

    func setupViews() {
        view.addSubview(pdfContainer) { make in
            make.edges.equalToSuperview()
        }

        view.addSubview(loadPDFFromFileButton) { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(40)
            make.width.equalTo(150)
            make.height.equalTo(40)
        }

        view.addSubview(loadPDFFromURLButton) { make in
            make.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(40)
            make.width.equalTo(150)
            make.height.equalTo(40)
        }

        view.addSubview(loadingView)
        loadingView.center = self.view.center

        addBottomView()
    }


    @objc func loadPDFFromFile(sender: UIButton) {
        let pdfUrl = Bundle.main.url(forResource: "big", withExtension: "pdf")!
        let imageUrl = Bundle.main.url(forResource: "iphone", withExtension: "png")!
        pdfLoader.delegate = self
        pdfLoader.loadPDF(url: imageUrl)
    }

    @objc func loadPDFFromURL(sender: UIButton) {
        let imageUrl = URL(string: "https://user-images.githubusercontent.com/61569191/184310230-c178ee61-b2df-40e3-8708-1283585619b6.jpeg")!
        let pdfUrl = URL(string: "https://s3.amazonaws.com/prodretitle-east/9ebd31f734ad9ee3719ef97b/tt.pdf")!
        pdfLoader.delegate = self
        pdfLoader.loadPDF(url: imageUrl)
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

extension ViewController: PDFDelegate {

    func onDocumentPreLoad() {
        print("PDFDelegate onDocumentPreLoad")
        loadingView.startAnimating()
    }

    func onDocumentLoaded() {
        print("PDFDelegate onDocumentLoaded")
        loadingView.stopAnimating()
        setupGallery()
    }

    func onDocumentLoadedFail(_ error: PDFError) {
        print("PDFDelegate onDocumentLoadedFail")
        loadingView.stopAnimating()
    }
    
    func setupGallery() {
        let galleryVC = UIHostingController(rootView: GalleryEntry(pages: pdfLoader.totalPages(), fetcher: pdfLoader))
        
        if let gallery = galleryVC.view {
            gallery.contentMode = .scaleAspectFit
            pdfContainer.addSubview(gallery)
            gallery.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
}


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
    let pdfContainer = UIView()
    let loadPDFFromFileButton: UIButton = {
        let button = UIButton()
        button.setTitle("Read from file", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(loadPDFFromFile), for: .touchUpInside)
        return button
    } ()
    let loadPDFFromURLButton: UIButton = {
        let button = UIButton()
        button.setTitle("Read from url", for: .normal)
        button.setTitleColor(.blue, for: .normal)
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
        view.addSubview(pdfContainer)
        pdfContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        view.addSubview(loadPDFFromFileButton)
        loadPDFFromFileButton.backgroundColor = UIColor.green
        loadPDFFromFileButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(40)
            make.width.equalTo(150)
            make.height.equalTo(40)
        }

        view.addSubview(loadPDFFromURLButton)
        loadPDFFromURLButton.backgroundColor = UIColor.green
        loadPDFFromURLButton.snp.makeConstraints { make in
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
        let fileUrl = Bundle.main.url(forResource: "read-only", withExtension: "pdf")!
        pdfView.delegate = self
        pdfView.loadPDF(url: fileUrl)
    }

    @objc func loadPDFFromURL(sender: UIButton) {
        let url = URL(string: "https://s3.amazonaws.com/prodretitle-east/9ebd31f734ad9ee3719ef97b/tt.pdf")!
        pdfView.delegate = self
        pdfView.loadPDF(url: url)
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
        let galleryVC = UIHostingController(rootView: GalleryEntry(pages: pdfView.totalPages(), fetcher: pdfView))
        
        if let gallery = galleryVC.view {
            gallery.contentMode = .scaleAspectFit
            pdfContainer.addSubview(gallery)
            gallery.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
}


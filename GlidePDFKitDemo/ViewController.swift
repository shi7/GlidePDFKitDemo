//
//  ViewController.swift
//  GlidePDFKitDemo
//
//  Created by shanks on 2022/8/11.
//

import SnapKit
import SwiftUI
import UIKit

class ViewController: UIViewController {
    let pdfLoader = PDFLoader()
    let annotationService: AnnotationServiceProxy = .init()
    let pdfContainer = UIView()
    let loadPDFFromFileButton: UIButton = {
        let button = UIButton()
        button.setTitle("Read from file", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .lightGray
        button.addTarget(self, action: #selector(loadPDFFromFile), for: .touchUpInside)
        button.layer.cornerRadius = 8
        return button
    }()

    let loadPDFFromURLButton: UIButton = {
        let button = UIButton()
        button.setTitle("Read from URL", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .lightGray
        button.addTarget(self, action: #selector(loadPDFFromURL), for: .touchUpInside)
        button.layer.cornerRadius = 8
        return button
    }()

    let loadingView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.hidesWhenStopped = true
        return indicator
    }()

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
            make.centerX.equalToSuperview().offset(-85)
            make.top.equalToSuperview().offset(40)
            make.width.equalTo(150)
            make.height.equalTo(40)
        }

        view.addSubview(loadPDFFromURLButton) { make in
            make.left.equalTo(loadPDFFromFileButton.snp.right).offset(20)
            make.top.equalToSuperview().offset(40)
            make.width.equalTo(150)
            make.height.equalTo(40)
        }

        view.addSubview(loadingView)
        loadingView.center = view.center

        addBottomView()
    }

    @objc func loadPDFFromFile(sender _: UIButton) {
        let pdfUrl = Bundle.main.url(forResource: "big", withExtension: "pdf")!
        let imageUrl = Bundle.main.url(forResource: "iphone", withExtension: "png")!
        pdfLoader.delegate = self
        pdfLoader.loadPDF(url: pdfUrl)
    }

    @objc func loadPDFFromURL(sender _: UIButton) {
        let imageUrl = URL(string: "https://user-images.githubusercontent.com/61569191/184310230-c178ee61-b2df-40e3-8708-1283585619b6.jpeg")!
        let pdfUrl = URL(string: "https://s3.amazonaws.com/prodretitle-east/9ebd31f734ad9ee3719ef97b/tt.pdf")!
        pdfLoader.delegate = self
        pdfLoader.loadPDF(url: pdfUrl)
    }

    func addBottomView() {
        let buttonActions: [BottomButtonActions] = [.removeAnnotation, .addImageAnnotation, .addTextAnnotation]
        let bottomStack = getBottomStack(buttonActions)
        view.addSubview(bottomStack) { make in
            make.left.right.bottom.equalToSuperview()
        }

        let secondButtonActions: [BottomButtonActions] = [.addCheckbox, .addLine, .addRadio]
        let secondBottomStack = getBottomStack(secondButtonActions)
        view.addSubview(secondBottomStack) { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(bottomStack.snp.top)
        }

    }

    private func getBottomStack(_ buttonActions: [BottomButtonActions]) -> UIStackView {
        let bottomStack = UIStackView()
        bottomStack.alignment = .center
        bottomStack.spacing = 50
        bottomStack.distribution = .fillEqually

        bottomStack.backgroundColor = .lightGray
        for type in buttonActions {
            let button = BottomButton(frame: CGRect.zero, actionType: type)
            button.addTarget(self, action: #selector(didTapBottomAction), for: .touchUpInside)
            bottomStack.addArrangedSubview(button) { make in
                make.width.height.equalTo(60)
            }
        }

        return bottomStack
    }

    @objc private func didTapBottomAction(button: BottomButton) {
        print("\(button.actionType)")
        switch button.actionType {
        case .addImageAnnotation: annotationService.addAnnotations(type: .image)
        case .addTextAnnotation: annotationService.addAnnotations(type: .text)
        case .removeAnnotation: annotationService.removeSelectedAnnotations()
        case .updateAnnotation: annotationService.removeSelectedAnnotations()
        case .addCheckbox: addCheckbox()
        case .addLine: addLine()
        case .addRadio: addRadio()
        }
    }

    private func addCheckbox() {
        let model = GlidePDFKitAnnotationModel(type: .checkbox, location: CGPoint(x: 150, y: 210), width: 40, height: 40, image: UIImage(named: "radio"), isCircle: true)
        annotationService.addAnnotations([model])
    }

    private func addLine() {
        let model = GlidePDFKitAnnotationModel(type: .line, location: CGPoint(x: 150, y: 210), width: 40, height: 40)
        annotationService.addAnnotations([model])
    }

    private func addRadio() {}
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

    func onDocumentLoadedFail(_: PDFError) {
        print("PDFDelegate onDocumentLoadedFail")
        loadingView.stopAnimating()
    }

    func annotationDidTap(annotation: GlidePDFKitAnnotationModel) {
        print("annotationDidTap \(annotation.id)")
        // TODO: navigator a new page to update annotation
        var newAnnotation = annotation
        newAnnotation.backgroundColor = .red
        newAnnotation.image = UIImage(named: "floodway")
        newAnnotation.text = "xxx"
        newAnnotation.isSelected = true
        annotationService.updateAnnotation(annotation: newAnnotation)
    }

    func setupGallery() {
        let galleryEntry = GalleryEntry(
            pages: pdfLoader.totalPages(),
            fetcher: pdfLoader,
            processor: pdfLoader.processor,
            proxy: annotationService
        )
        let galleryVC = UIHostingController(rootView: galleryEntry)
        if let gallery = galleryVC.view {
            gallery.contentMode = .scaleAspectFit
            pdfContainer.addSubview(gallery)
            gallery.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
}

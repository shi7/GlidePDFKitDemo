//
//  PDFTextAnnotation.swift
//  GlidePDFKitDemo
//
//  Created by Wenjuan Li on 2022/8/17.
//

import SwiftUI

struct PDFTextAnnotation: View {
    private let size: CGSize
    private let position: Position
    private let pageNum: Int
    
    @State private var offset = CGSize.zero
    
    @EnvironmentObject var dataModel: ViewModel
    
    init(position: Position, size: CGSize, pageNum: Int) {
        self.position = position
        self.size = size
        self.pageNum = pageNum
    }
    
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                offset = CGSize(
                    width: value.startLocation.x + value.translation.width - size.width/2,
                    height: value.startLocation.y + value.translation.height - size.height/2
                )
            }
            .onEnded { value in
                let translation = value.translation
                dataModel.updateItemPosition(
                    pageNum: pageNum,
                    position: Position(
                        position.x + translation.width,
                        position.y + translation.height)
                )
            }
    }
    
    var body: some View {
        Text("Text")
            .frame(width: size.width, height: size.height)
            .border(.blue, width: 2)
            .foregroundColor(.red)
            .offset(offset)
            .gesture(dragGesture)
            .position(x: position.x, y: position.y)
    }
}

typealias Position = (x: CGFloat, y: CGFloat)
typealias OnDragEnd = (CGFloat, CGFloat) -> Void

struct PDFTextAnnotation_Previews: PreviewProvider {
    static var previews: some View {
        Group {}
    }
}

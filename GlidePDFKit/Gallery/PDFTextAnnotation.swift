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
    
    @State private var offset = CGSize.zero
    
    init(position: Position, size: CGSize) {
        self.position = position
        self.size = size
    }
    
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                offset = CGSize(
                    width: value.startLocation.x + value.translation.width - size.width/2,
                    height: value.startLocation.y + value.translation.height - size.height/2
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
    }
}

typealias Position = (x: CGFloat, y: CGFloat)

struct PDFTextAnnotation_Previews: PreviewProvider {
    static var previews: some View {
        Group {
        }
    }
}

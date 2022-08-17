//
//  ImageAnotationView.swift
//  GlidePDFKitDemo
//

import SwiftUI

struct ImageAnotationView: View {

    @State var newPosition: CGPoint = CGPoint(x: UIScreen.main.bounds.width/2, y:  UIScreen.main.bounds.height/2)
    @State var model : AnotationModel
    
    var body: some View {
        let dragGesture = DragGesture()
            .onChanged { (value) in
                print(value.startLocation, value.location, value.translation)
                self.newPosition = value.location
            }.onEnded { value in

            }

        return Image("draw")
            .frame(width: 200, height: 100)
            .position(newPosition)
            .gesture(dragGesture)
    }
}

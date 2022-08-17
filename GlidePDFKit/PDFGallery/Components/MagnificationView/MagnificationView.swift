//
//  MagnificationView.swift
//  GlidePDFKitDemo
//
//  Created by Wenjuan Li on 2022/8/16.
//

import SwiftUI

struct MagnificationView<Content>: View where Content: View {
    @ViewBuilder private var content: () -> Content
    private var size: CGSize

    init(size: CGSize, @ViewBuilder content: @escaping () -> Content) {
        self.size = size
        self.content = content
    }

    var body: some View {
        content().modifier(MagnificationModifier(size: size))
    }
}

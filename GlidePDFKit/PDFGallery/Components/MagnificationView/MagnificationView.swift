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
    private var gotoPreviousPage: GotoPreviousPage
    private var gotoNextPage: GotoNextPage
    private var onTapped: OnTapped
    
    init(
        size: CGSize,
        gotoPreviousPage: @escaping GotoPreviousPage,
        gotoNextPage: @escaping GotoNextPage,
        onTapped: @escaping OnTapped,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.size = size
        self.gotoPreviousPage = gotoPreviousPage
        self.gotoNextPage = gotoNextPage
        self.onTapped = onTapped
        self.content = content
    }
    
    var body: some View {
        content()
            .modifier(
                MagnificationModifier(
                    size: size,
                    gotoPreviousPage: gotoPreviousPage,
                    gotoNextPage: gotoNextPage,
                    onTapped: onTapped
                )
            )
    }
}

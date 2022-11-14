//
//  RoundedBorder.swift
//  TimeTracker
//
//  Created by Brett Chapin on 11/6/22.
//

import SwiftUI

struct RoundedBorderModifier: ViewModifier {
    var height: CGFloat
    var lineWidth: CGFloat
    var paddingInset: CGFloat
    
    func body(content: Content) -> some View {
        content
            .frame(height: self.height)
            .padding(.horizontal, paddingInset)
            .background(.black.opacity(0.05), in: RoundedRectangle(cornerRadius: height / 4))
            .overlay(content: {
                RoundedRectangle(cornerRadius: self.height / 4)
                    .stroke(.black.opacity(0.2), lineWidth: self.lineWidth)
            })
    }
}

//
//  ViewExtension.swift
//  TimeTracker
//
//  Created by Brett Chapin on 11/6/22.
//

import SwiftUI

extension View {
    
    func roundedBorder(height: CGFloat = 40, lineWidth: CGFloat = 1, paddingInset: CGFloat = 10) -> some View {
        self.modifier(RoundedBorderModifier(height: height, lineWidth: lineWidth, paddingInset: paddingInset))
    }
    
}

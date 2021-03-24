//
//  Analytics.swift
//  PeiYang Lite
//
//  Created by 游奕桁 on 2021/3/24.
//

import SwiftUI

struct AnalyticsModifier: ViewModifier {
    let className: String
    
    func body(content: Content) -> some View {
        content
            .onAppear(perform: {
                UMAnalyticsSwift.beginLogPageView(pageName: className)
            })
            .onDisappear {
                UMAnalyticsSwift.endLogPageView(pageName: className)
            }
    }
}

extension View {
    func addAnalytics(className: String) -> some View {
        self.modifier(AnalyticsModifier(className: className))
    }
}

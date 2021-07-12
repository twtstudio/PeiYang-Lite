//
//  TripleLinkView.swift
//  PeiYang-Lite
//
//  Created by Zr埋 on 2021/7/11.
//

import SwiftUI

// 解决点击NavigationLink造成多次跳转跳回的问题
struct TripleEmptyNavigationLink: View {
    var body: some View {
        VStack {
        NavigationLink(destination: EmptyView()) {EmptyView()}
        NavigationLink(destination: EmptyView()) {EmptyView()}
        NavigationLink(destination: EmptyView()) {EmptyView()}
            
        }
    }
}


struct TripleEmptyNavigationLinkBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(TripleEmptyNavigationLink())
    }
}



extension View {
    func tripleEmptyNavigationLink()-> some View {
        self.modifier(TripleEmptyNavigationLinkBackground())
    }
}

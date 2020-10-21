//
//  CourseTableHeaderViewButtonModifier.swift
//  PeiYang Lite
//
//  Created by Zr埋 on 2020/9/6.
//

import SwiftUI


public struct CourseTableHeaderViewButtonModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .foregroundColor(.primary)
            .padding(4)
            .background(Color.shadow.opacity(0.8))
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

public struct ListIndicatorNoneModifier: ViewModifier {
    let direct: Axis.Set
    
    public func body(content: Content) -> some View {
        content.onAppear(perform: {
            if direct == .vertical {
                UITableView.appearance().showsVerticalScrollIndicator = false
            } else {
                UITableView.appearance().showsHorizontalScrollIndicator = false
            }
        })
    }
}

public struct ListSeperatorNoneModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content.onAppear {
            UITableView.appearance().separatorStyle = .none
        }
    }
}

extension View {
    public func listIndicatorNone(_ direct: Axis.Set = .vertical) -> some View {
        modifier(ListIndicatorNoneModifier(direct: direct))
    }
    
    public func listSeperatorNone() -> some View {
        modifier(ListSeperatorNoneModifier())
    }
    
    public func cthViewButtonModifier() -> some View {
        modifier(CourseTableHeaderViewButtonModifier())
    }
}


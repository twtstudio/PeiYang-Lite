//
//  NavigationBar.swift
//  PeiYang Lite
//
//  Created by Zrzz on 2021/3/12.
//

import SwiftUI

struct NavigationBar<Leading, Center, Trailing>: View where Leading: View, Center: View, Trailing: View {
    @Environment(\.presentationMode) private var presentationMode
    
    let leading: Leading?
    let center: Center?
    let trailing: Trailing?
    
    init (@ViewBuilder leading: () -> Leading? = { nil }, @ViewBuilder center: () -> Center? = { nil }, @ViewBuilder trailing: () -> Trailing? = { nil }) {
        self.leading = leading()
        self.center = center()
        self.trailing = trailing()
    }
    
    var body: some View {
        ZStack {
            HStack {
                if leading != nil {
                    leading!
                } else {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                    }
                    .font(.title2)
                    .foregroundColor(Color(#colorLiteral(red: 0.3856853843, green: 0.403162986, blue: 0.4810273647, alpha: 1)))
                    .padding()
                }
                
                Spacer()
                
                if trailing != nil {
                    trailing!
                }
            }
            
            if center != nil {
                center!
            }
        }
    }
}


struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            NavigationBar(center: {
                Text("HELLO")
                    .foregroundColor(.white)
            }, trailing: {
                Button(action: {}, label: {
                    Image(systemName: "checkmark")
                })
                .font(.title2)
                .foregroundColor(Color(#colorLiteral(red: 0.3856853843, green: 0.403162986, blue: 0.4810273647, alpha: 1)))
                .padding()
            })
            Spacer()
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

extension NavigationBar where Leading == EmptyView, Center == EmptyView {
    init (@ViewBuilder trailing: () -> Trailing? = { nil }) {
        self.leading = nil
        self.center = nil
        self.trailing = trailing()
    }
}

extension NavigationBar where Leading == EmptyView, Trailing == EmptyView {
    init (@ViewBuilder center: () -> Center? = { nil }) {
        self.leading = nil
        self.center = center()
        self.trailing = nil
    }
}

extension NavigationBar where Center == EmptyView {
    init (@ViewBuilder leading: () -> Leading? = { nil }, @ViewBuilder trailing: () -> Trailing? = { nil }) {
        self.leading = leading()
        self.center = nil
        self.trailing = trailing()
    }
}

extension NavigationBar where Leading == EmptyView {
    init (@ViewBuilder center: () -> Center? = { nil }, @ViewBuilder trailing: () -> Trailing? = { nil }) {
        self.leading = nil
        self.center = center()
        self.trailing = trailing()
    }
}

extension NavigationBar where Trailing == EmptyView {
    init (@ViewBuilder leading: () -> Leading? = { nil }, @ViewBuilder center: () -> Center? = { nil }) {
        self.leading = leading()
        self.center = center()
        self.trailing = nil
    }
}


// More to Complete if needed

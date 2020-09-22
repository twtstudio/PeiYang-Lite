//
//  BlurView.swift
//  PeiYang Lite
//
//  Created by TwTStudio on 7/6/20.
//

import SwiftUI

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemUltraThinMaterial
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blurView)
        
        NSLayoutConstraint.activate([
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor),
            blurView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

struct BlurView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            GeometryReader { geo in
                HStack {
                    Text("Blur View")
                        .font(.largeTitle)
                        .frame(width: geo.size.width / 2)
                    
                    ZStack {
                        Text("Blur View")
                            .font(.largeTitle)
                        BlurView()
                            .edgesIgnoringSafeArea(.all)
                    }
                }
            }
            .statusBar(hidden: true)
            .environment(\.colorScheme, .dark)
        }
    }
}

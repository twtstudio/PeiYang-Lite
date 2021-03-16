//
//  StarRatingView.swift
//  PeiYang Lite
//
//  Created by Zr埋 on 2021/3/10.
//

import SwiftUI

struct StarRatingView: View {
    enum StarType {
        case half, fill, continuous
    }
    
    // 评分
    @Binding var rating: CGFloat
    
    // 星星种类
    let type: StarType
    
    // 星星间隔
    var spacing: CGFloat = 10
    
    // 填充颜色
    var fillColor: Color = .yellow
    
    // 最大个数
    let maxRating: Int
    
    // overlayWidth
    @State private var width: CGFloat = 0
    
    @State private var totalWidth: CGFloat = 0
    
    var body: some View {
        let stars = HStack(spacing: spacing) {
            ForEach(0..<maxRating) { _ in
                Image(systemName: "star.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        HStack {
            stars.overlay(
                GeometryReader { g -> AnyView in
                    return AnyView(
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .frame(width: width)
                                .foregroundColor(fillColor)
                        }
                        .onAppear {
                            totalWidth = g.size.width
                        }
                    )
                }
                .mask(stars)
            )
            .foregroundColor(.gray)
            .onTapWithLocation(.local) { value in
                calcWidth(value.x)
            }
            .gesture(
                DragGesture()
                    .onChanged({ (value) in
                        calcWidth(value.location.x)
                    })
            )
        }
        
    }
    
    private func calcWidth(_ tmpX: CGFloat) {
        let starWidth: CGFloat = (totalWidth - CGFloat(maxRating - 1) * spacing) / CGFloat(maxRating)
        let t = CGFloat(floor(tmpX / (starWidth + spacing)))
        rating = t + tmpX.truncatingRemainder(dividingBy: starWidth + spacing) / starWidth
        if type == .continuous {
            width = rating / CGFloat(maxRating) * totalWidth
        } else if type == .fill {
            width = (t + 1) * (spacing + starWidth)
            rating = (t + 1)
        } else {
            var i: CGFloat = 0
            while Int(i) < maxRating * 2 + 1 {
                if abs(i * 0.5 - rating) < 0.25 {
                    break
                } else {
                    i += 1
                }
            }
            rating = i * 0.5
            width = rating * starWidth + t * spacing
        }
    }
}

public extension View {
    func onTapWithLocation(_ coordinateSpace: CoordinateSpace = .local, _ tapHandler: @escaping (CGPoint) -> Void) -> some View {
        modifier(TapLocationViewModifier(tapHandler: tapHandler, coordinateSpace: coordinateSpace))
    }
}

fileprivate struct TapLocationViewModifier: ViewModifier {
    let tapHandler: (CGPoint) -> Void
    let coordinateSpace: CoordinateSpace
    
    func body(content: Content) -> some View {
        content.overlay(
            TapLocationBackground(tapHandler: tapHandler, coordinateSpace: coordinateSpace)
        )
    }
}

fileprivate struct TapLocationBackground: UIViewRepresentable {
    var tapHandler: (CGPoint) -> Void
    let coordinateSpace: CoordinateSpace
    
    func makeUIView(context: UIViewRepresentableContext<TapLocationBackground>) -> UIView {
        let v = UIView(frame: .zero)
        let gesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.tapped))
        v.addGestureRecognizer(gesture)
        return v
    }
    
    class Coordinator: NSObject {
        var tapHandler: (CGPoint) -> Void
        let coordinateSpace: CoordinateSpace
        
        init(handler: @escaping ((CGPoint) -> Void), coordinateSpace: CoordinateSpace) {
            self.tapHandler = handler
            self.coordinateSpace = coordinateSpace
        }
        
        @objc func tapped(gesture: UITapGestureRecognizer) {
            let point = coordinateSpace == .local
                ? gesture.location(in: gesture.view)
                : gesture.location(in: nil)
            tapHandler(point)
        }
    }
    
    func makeCoordinator() -> TapLocationBackground.Coordinator {
        Coordinator(handler: tapHandler, coordinateSpace: coordinateSpace)
    }
    
    func updateUIView(_: UIView, context _: UIViewRepresentableContext<TapLocationBackground>) {
        /* nothing */
    }
}



struct StarRatingView_Previews: PreviewProvider {
    @State static var rating: CGFloat = 0
    
    static var previews: some View {
        // 实际测试没问题，但是好像preview不行
        VStack {
            Text(rating.description)
            StarRatingView(rating: $rating, type: .half, maxRating: 5)
            StarRatingView(rating: $rating, type: .fill, maxRating: 5)
            StarRatingView(rating: $rating, type: .continuous, maxRating: 5)
        }
    }
}

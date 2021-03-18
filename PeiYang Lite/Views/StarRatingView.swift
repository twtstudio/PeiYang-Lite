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
    
    // 是否可以交互
    var isInteractive: Bool = false
    
    // 最大个数
    let maxRating: Int
    
    // overlayWidth
    @State private var width: CGFloat = 0
    
    @State private var totalWidth: CGFloat = 0
    
    // end回调函数
    var scoreChanged: ((CGFloat) -> Void)? = nil
    
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
                            initWidth()
                        }
                    )
                }
                .mask(stars)
            )
            .foregroundColor(.gray)
            .onTapWithLocation(.local) { value in
                if isInteractive {
                    calcWidth(value.x)
                    scoreChanged?(rating)
                }
            }
            .gesture(
                DragGesture()
                    .onChanged({ (value) in
                        if isInteractive {
                            calcWidth(value.location.x)
                        }
                    })
                    .onEnded({ (value) in
                        if isInteractive {
                            calcWidth(value.location.x)
                            scoreChanged?(rating)
                        }
                    })
            )
        }
    }
    
    private func initWidth() {
        guard rating >= 0 || rating <= CGFloat(maxRating) else { return }
        
        let starWidth: CGFloat = (totalWidth - CGFloat(maxRating - 1) * spacing) / CGFloat(maxRating)
        let starCnt = CGFloat(floor(rating))
        if type == .continuous {
            width = starWidth * rating + spacing * starCnt
        } else if type == .fill {
            width = (starWidth + spacing) * starCnt
        } else {
            var i: CGFloat = 0
            while Int(i) < maxRating * 2 + 1 {
                if abs(i * 0.5 - rating) < 0.25 {
                    break
                } else {
                    i += 1
                }
            }
            width = i * 0.5 * starWidth + starCnt * spacing
        }
    }
    
    private func calcWidth(_ tmpX: CGFloat) {
        guard tmpX >= 0 && tmpX <= totalWidth else { return }
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
    @State static var rating: CGFloat = 3.5
    
    static var previews: some View {
        // 实际测试没问题，但是好像preview不行
        VStack {
            Text(rating.description)
            StarRatingView(rating: $rating, type: .half, isInteractive: true, maxRating: 5)
//            StarRatingView(rating: $rating, type: .fill, isInteractive: true, maxRating: 5)
//            StarRatingView(rating: $rating, type: .continuous, isInteractive: true, maxRating: 5)
        }
    }
}

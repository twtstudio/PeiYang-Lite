//
//  StyRmSelectClassGridView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/3/3.
//

import SwiftUI


struct StyRmSelectClassGridStack<Header: View, Content: View>: View {
    private let minCellWidth: CGFloat
    private let spacing: CGFloat
    private let numItems: Int
    private let alignment: HorizontalAlignment
    private let header: () -> Header
    private let content: (Int, CGFloat) -> Content
    private let gridCalculator = GridCalculator()
    
    init(
        minCellWidth: CGFloat,
        spacing: CGFloat,
        numItems: Int,
        alignment: HorizontalAlignment = .leading,
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder content: @escaping (Int, CGFloat) -> Content
    ) {
        self.minCellWidth = minCellWidth
        self.spacing = spacing
        self.numItems = numItems
        self.alignment = alignment
        self.header = header
        self.content = content
    }
    
    var items: [Int] {
        Array(0..<numItems).map { $0 }
    }
    
    var body: some View {
        GeometryReader { geometry in
            InnerGrid(
                spacing: spacing,
                items: items,
                alignment: alignment,
                header: header,
                content: content,
                gridDefinition: gridCalculator.calculate(
                    availableWidth: geometry.size.width,
                    minimumCellWidth: minCellWidth,
                    cellSpacing: spacing
                )
            )
//            .padding(.top, geometry.safeAreaInsets.bottom)
//            .padding(.bottom, geometry.safeAreaInsets.top)
        }
    }
}

struct StyRmInnerGrid<Header: View, Content: View>: View {
    private let spacing: CGFloat
    private let rows: [[Int]]
    private let alignment: HorizontalAlignment
    private let header: () -> Header
    private let content: (Int, CGFloat) -> Content
    private let columnWidth: CGFloat
    
    init(
        spacing: CGFloat,
        items: [Int],
        alignment: HorizontalAlignment = .leading,
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder content: @escaping (Int, CGFloat) -> Content,
        gridDefinition: GridCalculator.GridDefinition
    ) {
        self.spacing = spacing
        self.alignment = alignment
        self.header = header
        self.content = content
        self.columnWidth = gridDefinition.columnWidth
        rows = items.chunked(into: gridDefinition.columnCount)
    }
    
    var body : some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: alignment, spacing: spacing) {
                header()
                ForEach(rows, id: \.self) { row in
                    HStack(spacing: spacing) {
                        ForEach(row, id: \.self) { item in
                            // Pass the index and the cell width to the content
                            content(item, columnWidth)
                                .frame(width: columnWidth)
                        }
                    }.padding(.horizontal, spacing)
                }
            }.padding(.vertical, spacing)
            .frame(height: .infinity)
        }
    }
}


struct StuRmGridStack_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                GridStack(minCellWidth: 300,
                          spacing: 18,
                          numItems: 7) {
                    HStack {
                        Text("Header")
                            .font(.largeTitle)
                            .bold()
                        Spacer()
                    }
                    .padding()
                } content: { index, width in
                    GeometryReader { geo in
                        VStack {
                            Text("\(index)")
                            Spacer()
                        }
                        .padding()
                        .frame(width: width, height: width * 0.6)
                        .background(Color.gray)
                        .cornerRadius(24)
                    }
                    .frame(width: width, height: width * 0.6) // That's sucked!
                }
                .environment(\.colorScheme, .dark)
                
            }
        }
    }
}


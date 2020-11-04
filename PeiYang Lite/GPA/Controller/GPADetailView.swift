//
//  GPADetailView.swift
//  PeiYang Lite
//
//  Created by TwTStudio on 7/5/20.
//

import SwiftUI

struct GPADetailView: View {
    @ObservedObject var store = Storage.gpa
    private var gpa: GPA { store.object }
    
    @State private var isLoading = false
    
    @State private var activeIndex = 0
    
    @State private var showLogin = false
    
    @State private var isError = false
    @State private var errorMessage: LocalizedStringKey = ""
    
    var body: some View {
        GeometryReader { full in
            ScrollView(showsIndicators: false) {
                VStack {
                    // MARK: - Header
                    HStack {
                        Text(Localizable.gpa.rawValue)
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        RefreshButton(isLoading: $isLoading, action: load)
                    }
                    .padding()
                    
                    // MARK: - RadarChart
                    
    //                    GPAListView(activeSemesterGPA: gpa.semesterGPAArray[activeIndex])
                    RadarChartView(strokeColor: Color(#colorLiteral(red: 0.6459901929, green: 0.6900593638, blue: 0.5020841956, alpha: 1)), textColor: Color.white, center: CGPoint(x: (full.size.width - 30)/2, y: (full.size.width - 30)/2), width: full.size.width - 20, activeSemesterGPA: gpa.semesterGPAArray[activeIndex])
                        .frame(width: full.size.width - 30, height: full.size.width - 30)
                    
                    HStack {
                        GPATitleView(value: gpa.semesterGPAArray[activeIndex].score.decimal, title: .score)
                            .padding(5)
                        GPATitleView(value: gpa.semesterGPAArray[activeIndex].gpa.decimal, title: .gpa)
                            .padding(5)
                        GPATitleView(value: gpa.semesterGPAArray[activeIndex].credit.decimal, title: .credit)
                            .padding(5)
                    }
                    
                    // MARK: - Curve
//                    GeometryReader { geo in
                        CurveDetailView(
                            data: ChartData(points: gpa.semesterGPAArray.map(\.score)),
                            size: .constant(CGSize(width: full.size.width - 30, height: full.size.width * 0.5)),
                            minDataValue: .constant(nil),
                            maxDataValue: .constant(nil),
                            activeIndex: $activeIndex,
                            showIndicator: .constant(true),
                            pathGradient: Gradient(colors: [Color(#colorLiteral(red: 0.6580134034, green: 0.7014739513, blue: 0.5453689694, alpha: 1))]),
                            backgroundGradient: Gradient(colors: [Color.clear]),
                            indicatorColor: Color.white
                        )
                        .frame(width: full.size.width - 30, height: full.size.width*0.5)
//                    }
//                    .frame(width: full.size.width, height: full.size.width/6)
//                    .padding()
                    // MARK: - CellList
                    GPACellListView(activeSemesterGPA: gpa.semesterGPAArray[activeIndex])
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .sheet(isPresented: $showLogin) {
                    HomeLoginView(module: .gpa)
                }
                .alert(isPresented: $isError) {
                    Alert(title: Text(errorMessage),
                          dismissButton: .default(Text(Localizable.ok.rawValue)))
                }
            }
            .onAppear(perform: load)
            .edgesIgnoringSafeArea(.all)
            .background(Color(#colorLiteral(red: 0.500842154, green: 0.5448840261, blue: 0.3510230184, alpha: 1)))
        }
        .edgesIgnoringSafeArea(.all)
        .background(Color(#colorLiteral(red: 0.500842154, green: 0.5448840261, blue: 0.3510230184, alpha: 1)))
    }
    
    func load() {
        isLoading = true
        
        ClassesManager.checkLogin { result in
            switch result {
            case .success:
                return
            case .failure(let error):
                if error == .requestFailed {
                    isError = true
                    errorMessage = error.localizedStringKey
                } else {
                    showLogin = true
                }
            }
        }
        
        ClassesManager.gpaGet { result in
            switch result {
            case .success(let gpa):
                store.object = gpa
                store.save()
            case .failure(let error):
                print(error)
            }
            isLoading = false
        }
    }
}

struct GPATitleView: View {
    let value: String
    let title: Localizable
    
    var body: some View {
        VStack {
            Text(value)
                .font(.title)
                .foregroundColor(.white)
            Text(title.rawValue)
                .font(.footnote)
                .fontWeight(.bold)
                .foregroundColor(Color(#colorLiteral(red: 0.6580134034, green: 0.7014739513, blue: 0.5453689694, alpha: 1)))
        }
        .padding()
    }
}

struct GPADetailView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            GPADetailView()
                .environment(\.colorScheme, .dark)
        }
    }
}

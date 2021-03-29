//
//  GPADetailView.swift
//  PeiYang Lite
//
//  Created by TwTStudio on 7/5/20.
//

import SwiftUI

struct GPADetailView: View {
    @AppStorage(ClassesManager.isLoginKey, store: Storage.defaults) private var isLogin = true
    @AppStorage(SharedMessage.GPABackgroundColorKey, store: Storage.defaults) private var gpaBackgroundColor = 0x7f8b59
    @AppStorage(SharedMessage.GPATextColorKey, store: Storage.defaults) private var gpaTextColor = 0xFFFFFF
    @EnvironmentObject var sharedMessage: SharedMessage
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var store = Storage.gpa
    private var gpa: GPA { store.object }
    
    @State private var isLoading = false
    
    @State private var activeIndex = 0
    
    @State private var isError = false
    @State private var showRelogin = false
    @State private var errorMessage: String = ""
    
    var body: some View {
        GeometryReader { full in
            VStack {
                // MARK: - Header
                NavigationBar(leading: {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.backward")
                            .font(.title)
                            .foregroundColor(.init(hex: gpaTextColor))
                    }
                }, trailing: {
                    RefreshButton(isLoading: $isLoading, action: reload, color: .init(hex: gpaTextColor))
                }).padding(.horizontal)
                
                if !gpa.semesterGPAArray.isEmpty {
                    ScrollView(showsIndicators: false) {
                        // MARK: - RadarChart
                        //                    GPAListView(activeSemesterGPA: gpa.semesterGPAArray[activeIndex])
                        if !gpa.semesterGPAArray.isEmpty {
                            RadarChartView(strokeColor: Color.init(hex: gpaTextColor).opacity(0.7), textColor: Color.init(hex: gpaTextColor), center: CGPoint(x: (full.size.width - 30)/2, y: (full.size.width - 30)/2), width: full.size.width - 20, activeIndex: $activeIndex)
                        } else {
                            Text("Empty Data!")
                        }
                        HStack {
                            GPATitleView(value: gpa.semesterGPAArray[activeIndex].score.decimal, title: .score, titleColor: Color.init(hex: gpaTextColor).opacity(0.7), valueColor: .init(hex: gpaTextColor))
                                .padding(5)
                            GPATitleView(value: gpa.semesterGPAArray[activeIndex].gpa.decimal, title: .gpa, titleColor: Color.init(hex: gpaTextColor).opacity(0.7), valueColor: .init(hex: gpaTextColor))
                                .padding(5)
                            GPATitleView(value: gpa.semesterGPAArray[activeIndex].credit.decimal, title: .credit, titleColor: Color.init(hex: gpaTextColor).opacity(0.7), valueColor: .init(hex: gpaTextColor))
                                .padding(5)
                        }
                        
                        // MARK: - Curve
                        //                    GeometryReader { geo in
                        CurveDetailView(
                            data: ChartData(points: gpa.semesterGPAArray.filter({ $0.score != 0}).map(\.score)),
                            size: .constant(CGSize(width: full.size.width - 30, height: full.size.width * 0.5)),
                            minDataValue: .constant(nil),
                            maxDataValue: .constant(nil),
                            activeIndex: $activeIndex,
                            showIndicator: .constant(true),
                            pathGradient: Gradient(colors: [Color.init(hex: gpaTextColor).opacity(0.7)]),
                            backgroundGradient: Gradient(colors: [Color.clear]),
                            indicatorColor: Color.init(hex: gpaTextColor)
                        )
                        .frame(height: full.size.width*0.5)
                        .padding(.leading)
                        // MARK: - CellList
                        GPACellListView(activeSemesterGPA: gpa.semesterGPAArray[activeIndex])
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .alert(isPresented: $isError) {
                        Alert(title: Text(errorMessage),
                              dismissButton: .default(Text(Localizable.ok.rawValue)))
                    }
                }
            }
        }
        .onAppear(perform:  {
            load()
        })
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.bottom)
        .background(Color.init(hex: gpaBackgroundColor).edgesIgnoringSafeArea(.all))
        .addAnalytics(className: "GPADetailView")
        .showReloginView($showRelogin) { (result) in
            switch result {
            case .success:
                self.reload()
                showRelogin = false
            case .failure: break
            }
        }
    }
    
    func load() {
        if gpa.semesterGPAArray.isEmpty {
            reload()
        }
    }
    
    func reload() {
        isLoading = true
        ClassesManager.checkLogin { result in
            switch result {
                case .success:
                    ClassesManager.getGPA { result in
                        switch result {
                            case .success(let gpa):
                                store.object = gpa
                                store.save()
                            case .failure(let error):
                                log(error)
                        }
                        isLoading = false
                    }
                    return
                case .failure(let error):
                    if error == .requestFailed {
                        isError = true
                        errorMessage = error.localizedDescription
                    } else {
                        sharedMessage.isBindBs = false
                        isLogin = false
                        isLoading = false
                        showRelogin = true
                    }
            }
        }
        
    }
}

struct GPATitleView: View {
    let value: String
    let title: Localizable
    let titleColor: Color
    let valueColor: Color
    
    var body: some View {
        VStack {
            Text(title.rawValue)
                .font(.footnote)
                .fontWeight(.bold)
                .foregroundColor(titleColor)
            Text(value)
                .lineLimit(1)
                .font(.title2)
                .foregroundColor(valueColor)
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

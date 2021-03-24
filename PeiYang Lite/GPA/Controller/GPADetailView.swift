//
//  GPADetailView.swift
//  PeiYang Lite
//
//  Created by TwTStudio on 7/5/20.
//

import SwiftUI

struct GPADetailView: View {
    @AppStorage(ClassesManager.isLoginKey, store: Storage.defaults) private var isLogin = true
    @EnvironmentObject var sharedMessage: SharedMessage
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var store = Storage.gpa
    private var gpa: GPA { store.object }
    
    @State private var isLoading = false
    
    @State private var activeIndex = 0
    
    @State private var showLogin = false
    
    @State private var isError = false
    @State private var errorMessage: String = ""
    
    var body: some View {
        GeometryReader { full in
            VStack {
                // MARK: - Header
                NavigationBar(leading: {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                }, trailing: {
                    //                    HStack {
                    RefreshButton(isLoading: $isLoading, action: reload, color: .white)
                    //                        Image(systemName: "exclamationmark.circle")
                    //                            .font(.title)
                    //                            .foregroundColor(.white)
                    //                    }
                }).padding(.horizontal)
                
                if !gpa.semesterGPAArray.isEmpty {
                    ScrollView(showsIndicators: false) {
                        // MARK: - RadarChart
                        //                    GPAListView(activeSemesterGPA: gpa.semesterGPAArray[activeIndex])
                        if !gpa.semesterGPAArray.isEmpty {
                            RadarChartView(strokeColor: Color(#colorLiteral(red: 0.6459901929, green: 0.6900593638, blue: 0.5020841956, alpha: 1)), textColor: Color.white, center: CGPoint(x: (full.size.width - 30)/2, y: (full.size.width - 30)/2), width: full.size.width - 20, activeIndex: $activeIndex)
                        } else {
                            Text("Empty Data!")
                        }
                        HStack {
                            GPATitleView(value: gpa.semesterGPAArray[activeIndex].score.decimal, title: .score, titleColor: Color(#colorLiteral(red: 0.6580134034, green: 0.7014739513, blue: 0.5453689694, alpha: 1)), valueColor: .white)
                                .padding(5)
                            GPATitleView(value: gpa.semesterGPAArray[activeIndex].gpa.decimal, title: .gpa, titleColor: Color(#colorLiteral(red: 0.6580134034, green: 0.7014739513, blue: 0.5453689694, alpha: 1)), valueColor: .white)
                                .padding(5)
                            GPATitleView(value: gpa.semesterGPAArray[activeIndex].credit.decimal, title: .credit, titleColor: Color(#colorLiteral(red: 0.6580134034, green: 0.7014739513, blue: 0.5453689694, alpha: 1)), valueColor: .white)
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
                            pathGradient: Gradient(colors: [Color(#colorLiteral(red: 0.6580134034, green: 0.7014739513, blue: 0.5453689694, alpha: 1))]),
                            backgroundGradient: Gradient(colors: [Color.clear]),
                            indicatorColor: Color.white
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
        .sheet(isPresented: $showLogin, onDismiss: {
            load()
        }, content: {
            ClassesSSOView()
        })
        .edgesIgnoringSafeArea(.bottom)
        .background(Color(#colorLiteral(red: 0.500842154, green: 0.5448840261, blue: 0.3510230184, alpha: 1)).edgesIgnoringSafeArea(.all))
        .addAnalytics(className: "GPADetailView")
    }
    
    func load() {
        if gpa.semesterGPAArray.isEmpty {
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
                            showLogin = true
                            isLoading = false
                        }
                }
            }
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
                        showLogin = true
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

//
//  HomeScrollView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/3/15.
//
//
//import SwiftUI
//
//protocol HomeScrollViewDataSource {
//    var studyRoomCollections: [CollectionClass] { get set }
//    
//}
//
//protocol HomeScrollViewAction {
//    func loadOnAppear()
//}
//
//protocol HomeScrollViewModel: ObservableObject {
//    var action: HomeScrollViewAction { get }
//    var dataSource: HomeScrollViewDataSource { get set }
//}
//
//struct HomeScrollView<Model: HomeScrollViewModel>: View {
//    @ObservedObject var model: Model
//    
//    var body: some View {
//        LazyHStack{
//            ForEach(model.dataSource.studyRoomCollections, id: \.self) { room in
//                
//            }
//        }
//    }
//}

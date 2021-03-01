//
//  ECardDetailView.swift
//  PeiYang Lite
//
//  Created by TwTStudio on 7/26/20.
//

import SwiftUI

struct ECardDetailView: View {
    @ObservedObject var store = Storage.ecard
    private var overview: ECardOverview { store.object.overview }
    private var periodAmountArray: [PeriodAmount] { store.object.periodAmountArray }
    
    @State private var isLoading = false
    
    @State private var activePeriodIndex = -1
    private let periods = ["7", "30", "90", "180", "360"]
    
    @State private var activeDailyConsumeIndex = 0
    @State private var showDailyConsume = false
    
    @State private var activeSiteConsumeIndex = -1
    @State private var showSiteConsume = false
    
    @State private var activeSiteRechargeIndex = -1
    @State private var showSiteRecharge = false
    
    var body: some View {
        GeometryReader { full in
            VStack(alignment: .leading) {
                // MARK: - Header
                ECardOverviewView(overview: overview)
                
                HStack {
                    Picker(
                        Localizable.period.rawValue,
                        selection: $activePeriodIndex
                            .onChange { _ in
                                activeDailyConsumeIndex = 0
                                showDailyConsume = false
                                
                                activeSiteConsumeIndex = -1
                                showSiteConsume = false
                                
                                activeSiteRechargeIndex = -1
                                showSiteRecharge = false
                            }
                    ) {
                        ForEach(periods, id: \.self) {
                            Text("\($0) days")
                                .tag(periods.firstIndex(of: $0) ?? -1)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    RefreshButton(isLoading: $isLoading, action: load, color: .white)
                }
                .padding(.bottom)
                
                // MARK: - List
                if activePeriodIndex != -1 && !periodAmountArray.isEmpty {
                    List {
                        if !periodAmountArray[activePeriodIndex].transactionArray.isEmpty {
                            Section(header: Text(Localizable.transaction.rawValue)) {
                                ECardtransactionView(transactionArray: periodAmountArray[activePeriodIndex].transactionArray)
                            }
                        }
                        
                        if !periodAmountArray[activePeriodIndex].dailyConsumeArray.isEmpty {
                            Section(header: Text(Localizable.dailyConsume.rawValue)) {
                                ECardDailyAmountView(
                                    dailyAmountArray: periodAmountArray[activePeriodIndex].dailyConsumeArray,
                                    activeDailyAmountIndex: $activeDailyConsumeIndex,
                                    showDailyAmount: $showDailyConsume,
                                    geo: full
                                )
                            }
                        }
                        
                        if !periodAmountArray[activePeriodIndex].siteConsumeArray.isEmpty {
                            Section(header: Text(Localizable.siteConsume.rawValue)) {
                                ECardSiteAmountView(
                                    siteAmountArray: periodAmountArray[activePeriodIndex].siteConsumeArray,
                                    activeSiteAmountIndex: $activeSiteConsumeIndex,
                                    showSiteAmount: $showSiteConsume,
                                    geo: full
                                )
                            }
                        }
                        
                        if !periodAmountArray[activePeriodIndex].siteRechargeArray.isEmpty {
                            Section(header: Text(Localizable.siteRecharge.rawValue)) {
                                ECardSiteAmountView(
                                    siteAmountArray: periodAmountArray[activePeriodIndex].siteRechargeArray,
                                    activeSiteAmountIndex: $activeSiteRechargeIndex,
                                    showSiteAmount: $showSiteRecharge,
                                    geo: full
                                )
                            }
                        }
                    }
                }
            }
        }
        .onAppear(perform: load)
    }
    
    func load() {
        isLoading = true
        ECardManager.ecardPost(periods) { result in
            switch result {
            case .success(let ecard):
                store.object = ecard
                store.save()
            case .failure(let error):
                print(error)
            }
            isLoading = false
        }
    }
}

struct ECardDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            ECardDetailView()
                .environment(\.colorScheme, .dark)
        }
    }
}

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        return Binding(
            get: { self.wrappedValue },
            set: { selection in
                self.wrappedValue = selection
                handler(selection)
        })
    }
}

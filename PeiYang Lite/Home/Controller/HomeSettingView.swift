//
//  HomeSettingView.swift
//  PeiYang Lite
//
//  Created by TwTStudio on 8/2/20.
//
<<<<<<< HEAD

=======
>>>>>>> e4291697b2a03afcf4cfbf314ae8cf47114102d1
import SwiftUI
import LocalAuthentication

enum Account {
    static let needUnlockKey = "needUnlockKey"
    
    case classes, ecard, wlan
}

struct HomeSettingView: View {
    @State private var account = Account.ecard
    @State private var showAccountAlert = false
    
    @State private var showSafetyAlert = false
    @State private var errorMessage = Localizable.unknownError
    
    @AppStorage(Account.needUnlockKey, store: Storage.defaults) private var needUnlock = false
    
    var body: some View {
        Form {
            // MARK: - Account
            Section(header: Text(Localizable.account.rawValue)) {
                HomeAccountSettingView(
                    title: .classes,
                    isLogin: ClassesManager.isGPAStore || ClassesManager.isCourseStore,
                    description: ClassesManager.username,
                    account: .classes,
                    activeAccount: $account,
                    showAccountAlert: $showAccountAlert
                )
<<<<<<< HEAD
//                
=======
//
>>>>>>> e4291697b2a03afcf4cfbf314ae8cf47114102d1
//                HomeAccountSettingView(
//                    title: .ecard,
//                    isLogin: ECardManager.isStore,
//                    description: ECardManager.username,
//                    account: .ecard,
//                    activeAccount: $account,
//                    showAccountAlert: $showAccountAlert
//                )
                
                HomeAccountSettingView(
                    title: .wlan,
                    isLogin: WLANManager.isStore,
                    description: WLANManager.username,
                    account: .wlan,
                    activeAccount: $account,
                    showAccountAlert: $showAccountAlert
                )
            }
            // MARK: - Account Alert
            .alert(isPresented: $showAccountAlert) {
                Alert(
                    title: Text(Localizable.logout.rawValue),
                    message: Text(Localizable.logoutMessage.rawValue),
                    primaryButton: .destructive(
                        Text(Localizable.confirm.rawValue),
                        action: logout
                    ),
                    secondaryButton: .cancel()
                )
            }
            
            // MARK: - Safety
            Section(header: Text(Localizable.safety.rawValue)) {
                Toggle(
                    Localizable.needUnlock.rawValue,
                    isOn: $needUnlock
                        .onChange { needUnlock in
                            if needUnlock {
                                authenticate()
                            }
                        }
                )
                .toggleStyle(SwitchToggleStyle(tint: .accentColor))
            }
            // MARK: - Safety Alert
            .alert(isPresented: $showSafetyAlert) {
                switch errorMessage {
                case .biometryNotAvailable:
                    return Alert(
                        title: Text(errorMessage.rawValue),
                        message: Text(Localizable.biometryNotAvailableMessage.rawValue),
                        primaryButton: .default(
                            Text(Localizable.confirm.rawValue),
                            action: goToAppSettings
                        ),
                        secondaryButton: .cancel()
                    )
                default:
                    return Alert(
                        title: Text(errorMessage.rawValue),
                        dismissButton: .default(Text(Localizable.ok.rawValue))
                    )
                }
            }
        }
    }
    
    func logout() {
        switch account {
        case .classes:
            ClassesManager.removeAll()
        case .ecard:
            ECardManager.removeAll()
        case .wlan:
            WLANManager.removeAll()
        }
        
        /// TODO: Delete cookies for specific url
        /// TODO: Delete cookies in `Storage.defaults`
        let cookieStorage = HTTPCookieStorage.shared
        if let cookies = cookieStorage.cookies {
            for cookie in cookies {
                cookieStorage.deleteCookie(cookie)
            }
        }
    }
    
    func authenticate() {
        let context = LAContext()
        let policy = LAPolicy.deviceOwnerAuthenticationWithBiometrics
        var error: NSError?
        
        if context.canEvaluatePolicy(policy, error: &error) {
            context.evaluatePolicy(policy, localizedReason: "NSFaceIDUsageDescription") { success, authenticationError in
                DispatchQueue.main.async {
                    if !success {
                        needUnlock = false
                        if let authenticationError = authenticationError {
                            let laErrorCode = LAError(_nsError: authenticationError as NSError).code
                            errorMessage = laErrorCode.localizable
                            showSafetyAlert = true
                        }
                    }
                }
            }
        } else {
            needUnlock = false
            if let error = error {
                let laErrorCode = LAError(_nsError: error).code
                errorMessage = laErrorCode.localizable
                showSafetyAlert = true
            }
        }
    }
    
    func goToAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

struct HomeAccountSettingView: View {
    let title: Localizable
    let isLogin: Bool
    let description: String
    let account: Account
    
    @Binding var activeAccount: Account
    @Binding var showAccountAlert: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title.rawValue)
                
                if isLogin {
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical, 8)
            
            Spacer()
            
            Text(isLogin ? Localizable.online.rawValue : Localizable.offline.rawValue)
                .font(.subheadline)
                .foregroundColor(.white)
                .padding(8)
                .background(isLogin ? Color.green : Color.red)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .onTapGesture {
                    if isLogin {
                        activeAccount = account
                        showAccountAlert = true
                    }
                }
        }
    }
}

struct HomeSettingView_Previews: PreviewProvider {
    static var previews: some View {
        HomeSettingView()
    }
}

extension LAError.Code {
    var localizable: Localizable {
        switch self {
        case .biometryNotEnrolled:
            return .biometryNotEnrolled
        case .biometryNotAvailable:
            return .biometryNotAvailable
        case .userCancel:
            return .userCancel
        default:
            return .unknownError
        }
    }
}

//
//  LXConstants.swift
//  LXCore
//
//  Created by Artak Gevorgyan on 23.10.23.
//

import Foundation

enum LXGlobalRepoParams {
    
    case baseURL
    case baseAuthorization
    
    var value: String {
        switch self {
// Temporary commented this, Should be uncomment asap
        case .baseURL: return (LXConstantsManager.shared.getLXBaseUrl() ?? "")// + "\(LXConstantsManager.shared.getLXLanguage() ?? "")/"
        case .baseAuthorization: return  "Authorization"
        }
    }
    
    var authValue: String {
        return String(format: "Bearer %@", LXConstantsManager.shared.getLXJwt() ?? "")
    }
}

enum LXEnvironment {
    case debugTest
    case debugProd
    case qaTest
    case qaProd
    case tfTest
    case tfProd
    case appStore
}

struct LXEnvironmentConstants {
    
//    static var env: LXEnvironment {
//        #if DEBUG_TEST
//            return .debugTest
//        #elseif DEBUG_PROD
//            return .debugProd
//        #elseif QA_TEST
//            return .qaTest
//        #elseif QA_PROD
//            return .qaProd
//        #elseif TF_TEST
//            return .tfTest
//        #elseif TF_PROD
//            return .tfProd
//        #elseif APP_STORE
//            return .appStore
//        #else
//            return .debugTest
//        #endif
//    }
    
    static var isTestEnv: Bool = (LXConstantsManager.shared.getLXEnvironment() == .debugTest
                                  || LXConstantsManager.shared.getLXEnvironment() == .qaTest ||
                                  LXConstantsManager.shared.getLXEnvironment() == .tfTest)

    static var defaultLengthOfAmountField: Int = 15
    // Temporary changed to recipes, should be added functionality to set it via interface
    static var responseDefaultKeyPath: String = "recipes"
}

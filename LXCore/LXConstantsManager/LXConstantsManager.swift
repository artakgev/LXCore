//
//  LXConstantsManager.swift
//  LXCore
//
//  Created by Artak Gevorgyan on 23.10.23.
//

import Foundation

enum LXErrorTextTypeEnum {
    case noInternetError
    case defaultError
}

final class LXConstantsManager {
    
    static let shared = LXConstantsManager()
    private var language: String?
    private var baseUrl: String?
    private var jwt: String?
    private var noInternetErrorText: String?
    private var defaultErrorText: String?
    private var lightAppearanceMode: Bool?
    private var environment: LXEnvironment?
    
    // MARK: Set configs
    
    // You need to call configLXConstants when called AppDelegate didFinishLaunchingWithOptions
    
    func setLXBaseUrl(_ baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    // You need to call setLXEnvironment when called AppDelegate didFinishLaunchingWithOptions
    // You need to have local private method which can check env mode and set it for env parametr in setLXEnvironment(_ env: LXEnvironment) method
    
    //#if DEBUG_TEST
    //    return .debugTest
    //#elseif DEBUG_PROD
    //    return .debugProd
    //#elseif QA_TEST
    //    return .qaTest
    //#elseif QA_PROD
    //    return .qaProd
    //#elseif TF_TEST
    //    return .tfTest
    //#elseif TF_PROD
    //    return .tfProd
    //#elseif APP_STORE
    //    return .appStore
    //#else
    //    return .debugTest
    //#endif
    
    func setLXEnvironment(_ env: LXEnvironment) {
        self.environment = env
    }
    
    // You need to call setLXErrorTexts first time when called AppDelegate didFinishLaunchingWithOptions, and every time when you changed app language
    
    func setLXErrorTexts(noInternetError: String? = nil,
                         defaultError: String? = nil ) {
        self.noInternetErrorText = noInternetError
        self.defaultErrorText = defaultError
    }
    
    // You need to call setLXErrorTexts first time when called AppDelegate didFinishLaunchingWithOptions, and every time when you changed app language
    
    func setLXLanguage(_ language: String) {
        self.language = language
    }
    
    // You need to call setLXJwt every time when you get JWT from db or local db
    
    func setLXJwt(_ jwt: String) {
        self.jwt = jwt
    }

    // You need to call setLXLightAppearanceMode every time when you get changed app appearanceMode
    
    func setLXLightAppearanceMode(_ lightAppearanceMode: Bool) {
        self.lightAppearanceMode = lightAppearanceMode
    }
    
    // MARK: Get configs
    
    func getLXEnvironment() -> LXEnvironment? {
        return self.environment
    }
    
    func getLXCurrentError(_ errorType: LXErrorTextTypeEnum) -> String {
        switch errorType {
        case .noInternetError:
            return self.noInternetErrorText ?? ""
        case .defaultError:
            return self.defaultErrorText ?? ""
        }
    }
    
    func getLXLanguage() -> String? {
        return self.language
    }
    
    func getLXBaseUrl() -> String? {
        return self.baseUrl
    }
    
    func getLXJwt() -> String? {
        return self.jwt
    }
    
    func getLXLightAppearanceMode() -> Bool? {
        return self.lightAppearanceMode
    }
}

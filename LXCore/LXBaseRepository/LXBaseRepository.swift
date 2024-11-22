//
//  LXBaseRepository.swift
//  LXCore
//
//  Created by Artak Gevorgyan on 23.10.23.
//

import Alamofire
import SwiftyJSON

class LXBaseRepository<T: LXTargetType> {
        
     var sessionManager: Alamofire.Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 60
        let sessionManager = Session(configuration: configuration)
        return sessionManager
    }()
    
    func fetchPlainData(target: T, completionHandler: @escaping (LXNetworkError?) -> Void) {

        let url = target.baseURL + target.path + "?" + self.constructRequiredParams()
        let headers = Alamofire.HTTPHeaders(target.headers ?? [:])
        let method = Alamofire.HTTPMethod(rawValue: target.method.rawValue)

        let parameters = buildParams(task: target.task)

        self.printRequestDetails(url, headers, method, parameters)
        AF.request(url,
                   method: method,
                   parameters: parameters.0,
                   encoding: URLEncoding.default,
                   headers: headers).response { (responseObject) in
            guard let safeResponseObj = responseObject.response else {
                completionHandler(LXNetworkError.init(code: -1, 
                                                      message: LXConstantsManager.shared.getLXCurrentError(.defaultError)))
                return
            }

            if //let safeResponseObj = responseObject.response,
               safeResponseObj.statusCode != 200 {
                if let data = responseObject.data {
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    print("👹 Body: ", json)
                }
                self.printResponseObject(responseObject.response)
            }
            if let safeResponseObjData = responseObject.data {
                var responseAsADict: [String: Any] = [:]
                self.convertResponseToDictionary(safeResponseObjData) { (result, error) in
                    if error != nil {
                        print("🆘🆘🆘🆘 Could not convert data to Dictionary: ", error)
                    } else if let result = result {
                        responseAsADict = result
                    } else {
                    }
                }
                if self.isStatusFieldContainsError(responseAsADict,
                                       statusCode: responseObject.response?.statusCode) {
                    do {
                        if var responseObj = try LXCodableService().decodeObject(of: LXNetworkError.self,
                                                                               data: safeResponseObjData) {
                            responseObj.code = safeResponseObj.statusCode
                            completionHandler(responseObj)
                        } else {
                            print("🆘🆘🆘🆘 Error to NetworkError object is Nil: ")
                        }
                    } catch {
                        print("🆘🆘🆘🆘 Could not convert error to NetworkError object: ", error)
                        completionHandler(LXNetworkError.init(withError: error, code: safeResponseObj.statusCode))
                    }
                    return
                }
            }
            if let safeError = responseObject.error {
                completionHandler(LXNetworkError.init(withAFError: safeError, code: safeResponseObj.statusCode))
            } else {
                completionHandler(nil)
            }
        }
    }
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

    func fetchData<M: Decodable>(target: T,
                                 responseClass: M.Type,
                                 encoding: URLEncoding = .default,
                                 completionHandler: @escaping (Result<M, LXNetworkError>) -> Void) {

        // Temporary commented this. Should be uncomment asap
        let url = target.baseURL// + target.path + "?" + self.constructRequiredParams()
        let headers = Alamofire.HTTPHeaders(target.headers ?? [:])
        let method = Alamofire.HTTPMethod(rawValue: target.method.rawValue)
        var parameters = buildParams(task: target.task)
        var finalParams = parameters.0
        self.printRequestDetails(url, headers, method, parameters)
        // Temporary commented this. Should be uncomment asap
//        AF.request(url,
//                   method: method,
//                   parameters: finalParams,
//                   encoding: encoding,
//                   headers: headers).response { (responseObject) in
        AF.request(url).responseJSON { (responseObject) in

            guard let safeResponseObj = responseObject.response else {
                let message = LXConstantsManager.shared.getLXCurrentError(.defaultError)
                completionHandler(.failure(LXNetworkError.init(code: -1, message: message)))
                return
            }

            if// let safeResponseObj = responseObject.response,
               safeResponseObj.statusCode != 200 {
                if let data = responseObject.data {
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    print("👹 Body: ", json)
                }

                self.printResponseObject(responseObject.response)
                do {
                    if var responseObj = try LXCodableService().decodeObject(of: LXNetworkError.self,
                                                                           data: responseObject.data!) {
                        responseObj.code = safeResponseObj.statusCode
                        completionHandler(.failure(responseObj))
                        return
                    } else {
                        print("🆘🆘🆘🆘 Error to NetworkError object is Nil: ")
                        completionHandler(.failure(LXNetworkError.init(code: safeResponseObj.statusCode,
                                                                       message: "Could not decode object")))
                        return
                    }
                } catch {
                    print("🆘🆘🆘🆘 Could not convert error to NetworkError object: ", error)
                    completionHandler(.failure(LXNetworkError.init(withError: error,
                                                                 code: safeResponseObj.statusCode)))
                }
            } else {
                if let safeError = responseObject.error {
                    completionHandler(.failure(LXNetworkError.init(withAFError: safeError,
                                                                 code: safeResponseObj.statusCode)))
                } else {
                    if let safeResponseObjData = responseObject.data {
                        var responseAsADict: [String: Any] = [:]
                        self.convertResponseToDictionary(safeResponseObjData) { (result, error) in
                            if error != nil {
                                print("🆘🆘🆘🆘 Could not convert data to Dictionary: ", error ?? "Error is nil")
                            } else if let result = result {
                                responseAsADict = result
                            } else {
                            }
                        }
                        if self.isStatusFieldContainsError(responseAsADict,
                                               statusCode: responseObject.response?.statusCode) {
                            do {
                                if var responseObj = try LXCodableService().decodeObject(of: LXNetworkError.self,
                                                                                       data: safeResponseObjData) {
                                    responseObj.code = safeResponseObj.statusCode
                                    completionHandler(.failure(responseObj))
                                } else {
                                    print("🆘🆘🆘🆘 Error to NetworkError object is Nil: ")
                                }
                            } catch {
                                print("🆘🆘🆘🆘 Could not convert error to NetworkError object: ", error)
                                completionHandler(.failure(LXNetworkError.init(withError: error,
                                                                             code: safeResponseObj.statusCode)))
                            }

                        } else {
                            do {
                                let key = LXEnvironmentConstants.responseDefaultKeyPath
                                let responseObj = try LXCodableService().decodeObject(of: M.self,
                                                                                    data: safeResponseObjData,
                                                                                    key: key)
                                completionHandler(.success(responseObj!))
                            } catch {
                                print(error.localizedDescription.debugDescription)
                                print(error.localizedDescription)

                                completionHandler(.failure(LXNetworkError.init(withError: error, 
                                                                               code: safeResponseObj.statusCode)))
                            }
                        }
                    } else {
                        completionHandler(.failure(LXNetworkError.init(code: safeResponseObj.statusCode,
                                                                     message: "Response object as a data is Nil")))
                    }
                }
            }
        }
    }

    private func buildParams(task: LXTask) -> ([String: Any], ParameterEncoding) {
        switch task {
        case .requestPlain:
            return ([:], URLEncoding.default)
        case .requestParameters(parameters: let parameters, encoding: let encoding):
            return (parameters, encoding)
        }
    }

    private func printRequestDetails(_ url: String,
                                     _ headers: HTTPHeaders,
                                     _ method: Alamofire.HTTPMethod,
                                     _ parameters: ([String: Any], ParameterEncoding)) {
        print("➡️➡️➡️➡️➡️➡️➡️ Request start ➡️➡️➡️➡️➡️➡️➡️")
        print("➡️ URL: ", url)
        print("➡️ METHOD: ", method.rawValue)
        print("➡️ HEADERS: ", headers)
        print("➡️ PARAMS: ", parameters.0)
    }

    private func convertResponseToDictionary(_ responseObjectData: Data,
                                             completionHandler: @escaping ([String: Any]?, NSError?) -> Void) {
        do {
            let jsonDict = try JSONSerialization.jsonObject(with: responseObjectData, 
                                                            options: []) as? [String: Any]
            let jsonData = try JSONSerialization.data(withJSONObject: jsonDict,
                                                      options: .prettyPrinted)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("✅✅✅✅✅✅✅ Response start ✅✅✅✅✅✅✅")
                print("✅ DATA: ", jsonString)

            }
            completionHandler(jsonDict, nil)
        } catch {
            print("🐸  JSON parse error: ", error)
            completionHandler(nil, NSError(domain: "JSON error parse", code: 1, userInfo: nil))
        }
    }

    private func printResponseObject(_ responseObj: HTTPURLResponse?) {
        print("👹👹👹👹👹👹👹 Response fail 👹👹👹👹👹👹👹")
        print("👹 StatusCode: ", responseObj?.statusCode ?? "Object is nil")
        print("👹 Content-Type: ", responseObj?.headers.value(for: "Content-Type") ?? "Object is nil")
        print("👹 ResponseObject: ", responseObj ?? "Object is nil")
    }

    private func printResponseDetails(_ responseObjectDict: [String: Any]) {
            print("✅✅✅✅✅✅✅ Response start ✅✅✅✅✅✅✅")
            print("✅ DATA: ", responseObjectDict)

    }

    private func isStatusFieldContainsError(_ result: [String: Any], statusCode: Int?) -> Bool {
        if let statusCode = statusCode,
           statusCode != 200 {

            let containsError = result.contains { (key: String, value: Any) in
                let valueStr = value as? String
                return key == "status" && (valueStr == "ERROR" ||
                                           valueStr == "INVALID_DATA" ||
                                           valueStr == "NOT_FOUND" ||
                                           valueStr == "TOKEN_MISMATCH" ||
                                           valueStr == "UNAUTHORIZED" ||
                                           valueStr == "FORBIDDEN" ||
                                           valueStr == "APP_ERROR")
            }
            return containsError
        }
        return false
    }

    private func constructRequiredParams() -> String {
        let deviceTypeParam = "deviceType=iPhone"
        let lightDarkModeParam = "&mode=" + ((LXConstantsManager.shared.getLXLightAppearanceMode() ?? true) ? "light" : "dark")
        var udidParam = ""
        // swiftlint:disable all
        if let udid = UIDevice().udid {
            udidParam = "&applicationId=" + udid
        }
        // swiftlint:enable all

        var appVersionParam = ""
        if let versionNumber = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            appVersionParam = "&applicationVersion=" + versionNumber
        }
        var versionNumberParam = ""
        if let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            versionNumberParam = "&versionNumber=" + buildNumber
        }
        let deviceScaleParam = "&deviceScale=" + "\(String(describing: UIScreen.main.scale))"
        let osVersionParam = "&os_version=" + UIDevice.current.systemVersion
        let requiredParams = deviceTypeParam + lightDarkModeParam + udidParam +
                                    appVersionParam + versionNumberParam +
                                    deviceScaleParam + osVersionParam
        return requiredParams
    }
}

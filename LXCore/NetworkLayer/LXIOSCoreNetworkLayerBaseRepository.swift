//
//  LXIOSCoreBaseRepository.swift
//  LXCore
//
//  Created by Artak Gevorgyan on 25.06.23.
//

import Foundation

import Alamofire
import SwiftyJSON

class LXIOSCoreNetworkLayerBaseRepository<T: LXIOSCoreNetworkLayerTargetType> {
        
     var sessionManager: Alamofire.Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 60
        let sessionManager = Session(configuration: configuration)
//        sessionManager.startRequestsImmediately = true
        return sessionManager
    }()
    
//    func fetchPlainData(target: T, completionHandler: @escaping (NetworkError?) -> Void) {
//
//        let url = target.baseURL + target.path + "?" + self.constructRequiredParams()
//        let headers = Alamofire.HTTPHeaders(target.headers ?? [:])
//        let method = Alamofire.HTTPMethod(rawValue: target.method.rawValue)
//
//        let parameters = buildParams(task: target.task)
//
//        self.printRequestDetails(url, headers, method, parameters)
//        AF.request(url,
//                   method: method,
//                   parameters: parameters.0,
//                   encoding: URLEncoding.default,
//                   headers: headers).response { (responseObject) in
//            guard let safeResponseObj = responseObject.response else {
//                completionHandler(NetworkError.init(code: -1, message: Texts.Common.Default.Error.message))
//                return
//            }
//
//            if //let safeResponseObj = responseObject.response,
//               safeResponseObj.statusCode != 200 {
//                if let data = responseObject.data {
//                    let json = String(data: data, encoding: String.Encoding.utf8)
//                    print("👹 Body: ", json)
//                }
//                self.printResponseObject(responseObject.response)
//            }
//            if let safeResponseObjData = responseObject.data {
//                var responseAsADict: [String: Any] = [:]
//                self.convertResponseToDictionary(safeResponseObjData) { (result, error) in
//                    if error != nil {
//                        print("🆘🆘🆘🆘 Could not convert data to Dictionary: ", error)
//                    } else if let result = result {
//                        responseAsADict = result
//                    } else {
//                    }
//                }
//                if self.isStatusFieldContainsError(responseAsADict,
//                                       statusCode: responseObject.response?.statusCode) {
//                    do {
//                        if var responseObj = try CodableService().decodeObject(of: NetworkError.self,
//                                                                               data: safeResponseObjData) {
//                            responseObj.code = safeResponseObj.statusCode
//                            completionHandler(responseObj)
//                        } else {
//                            print("🆘🆘🆘🆘 Error to NetworkError object is Nil: ")
//                        }
//                    } catch {
//                        print("🆘🆘🆘🆘 Could not convert error to NetworkError object: ", error)
//                        completionHandler(NetworkError.init(withError: error, code: safeResponseObj.statusCode))
//                    }
//                    return
//                }
//            }
//            if let safeError = responseObject.error {
//                completionHandler(NetworkError.init(withAFError: safeError, code: safeResponseObj.statusCode))
//            } else {
//                completionHandler(nil)
//            }
//        }
//    }
//    func convertToDictionary(text: String) -> [String: Any]? {
//        if let data = text.data(using: .utf8) {
//            do {
//                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//        return nil
//    }

//    func qmsFetchPlainData(target: T, completionHandler: @escaping (NetworkError?) -> Void) {
//        let url = target.baseURL + target.path// + "?" + self.constructRequiredParams()
////        let headers = Alamofire.HTTPHeaders(target.headers ?? [:])
//        let method = Alamofire.HTTPMethod(rawValue: target.method.rawValue)
//        let parameters = buildParams(task: target.task)
////    Alamofire.request.
//
//        let jsonData = try? JSONSerialization.data(withJSONObject: parameters.0)
//                var request = URLRequest(url: URL(string: target.baseURL + target.path)!)
//              request.httpMethod = method.rawValue
////              request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//              request.headers = Alamofire.HTTPHeaders(target.headers ?? [:])
//              request.httpBody = jsonData
//        print("➡️➡️➡️➡️➡️➡️➡️ QMS Plain Request start ➡️➡️➡️➡️➡️➡️➡️")
//        print("➡️ URL: ", request.url?.description)
//        print("➡️ METHOD: ", method.rawValue)
//        print("➡️ HEADERS: ", request.headers.description)
//        print("➡️ HttpBody: ", parameters.0.description.utf8CString)
//        print("➡️ PARAMS: ", parameters.0)
//
//        AF.request(request).responseJSON { (responseObject) in
//            guard let safeResponseObj = responseObject.response else {
//                completionHandler(NetworkError.init(code: -1, message: Texts.Common.Default.Error.message))
//                return
//            }
//            if //let safeResponseObj = responseObject.response,
//               safeResponseObj.statusCode != 200 && safeResponseObj.statusCode != 204 {
//
//                if let data = responseObject.data {
//                    let json = String(data: data, encoding: String.Encoding.utf8)
//                    print("👹 Body: ", json)
//                    if let safeJson = json {
//                        let errorDict = self.convertToDictionary(text: safeJson)
//                        if let errors = errorDict?["Errors"] as? [String] {
//                            completionHandler(NetworkError.init(code: safeResponseObj.statusCode,
//                                                                message: errors.joined(separator: " ")))
//                        }
//                    }
//                }
//                self.printResponseObject(responseObject.response)
//            } else {
//                if let safeError = responseObject.error {
//                    // TODO: This is bad solution. Status code is ok, but we are receiving
//                    // Alamofire.AFError.ResponseSerializationFailureReason.inputDataNilOrZeroLength
//                    // error, as maybe the body is empty.
//                    // We have to consider this case as a success
//                    // This is QMS delay API call when response is success
////                    completionHandler(NetworkError.init(withAFError: safeError, code: safeResponseObj.statusCode))
//                        completionHandler(nil)
//                } else {
//                    if let safeResponseObjData = responseObject.data {
//        //                var responseAsADict: [String: Any] = [:]
//        //                self.convertResponseToDictionary(safeResponseObjData) { (result, error) in
//        //                    if error != nil {
//        //                        print("🆘🆘🆘🆘 Could not convert data to Dictionary: ", error)
//        //                    } else if let result = result {
//        //                        responseAsADict = result
//        //                    } else {
//        //                    }
//        //                }
//        //                if self.isStatusFieldContainsError(responseAsADict,
//        //                                       statusCode: responseObject.response?.statusCode) {
//                            do {
//                                if var responseObj = try CodableService().decodeObject(of: NetworkError.self,
//                                                                                       data: safeResponseObjData) {
//                                    responseObj.code = safeResponseObj.statusCode
//                                    completionHandler(responseObj)
//                                } else {
//                                    print("🆘🆘🆘🆘 Error to NetworkError object is Nil: ")
//                                }
//                            } catch {
//                                print("🆘🆘🆘🆘 Could not convert error to NetworkError object: ", error)
//                                completionHandler(NetworkError.init(withError: error,
//                                                                    code: safeResponseObj.statusCode))
//                            }
//                            return
//        //                }
//                    } else {
//                        completionHandler(nil)
//                        return
//                    }
//
//                }
//            }
////            if let safeError = responseObject.error {
////                completionHandler(NetworkError.init(withAFError: safeError))
////            } else {
////                completionHandler(nil)
////            }
//        }
//
//    }

//    func qmsFetchData<M: Decodable>(target: T,
//                                    responseClass: M.Type,
//                                    encoding: URLEncoding = .default,
//                                    completionHandler: @escaping (Result<M, NetworkError>) -> Void) {
//        let url = target.baseURL + target.path
//        let headers = Alamofire.HTTPHeaders(target.headers ?? [:])
//        let method = Alamofire.HTTPMethod(rawValue: target.method.rawValue)
//        let parameters = buildParams(task: target.task)
//
//        let jsonData = try? JSONSerialization.data(withJSONObject: parameters.0)
//        var request = URLRequest(url: URL(string: target.baseURL + target.path)!)
//        request.httpMethod = method.rawValue
////              request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.headers = Alamofire.HTTPHeaders(target.headers ?? [:])
//        if method != .get {
//            request.httpBody = jsonData
//
//        }
//        print("➡️➡️➡️➡️➡️➡️➡️ QMS Request start ➡️➡️➡️➡️➡️➡️➡️")
//        print("➡️ URL: ", url)
//        print("➡️ METHOD: ", method.rawValue)
//        print("➡️ HEADERS: ", headers.description)
//        print("➡️ HttpBody: ", parameters.0.description)
//        print("➡️ PARAMS: ", parameters.0)
//
//        AF.request(request).responseJSON { (responseObject) in
//            guard let safeResponseObj = responseObject.response else {
//                completionHandler(.failure(NetworkError.init(code: -1, message: Texts.Common.Default.Error.message)))
//                return
//            }
//
//            if //let safeResponseObj = responseObject.response,
//               safeResponseObj.statusCode != 200  && safeResponseObj.statusCode != 204 {
//                if let data = responseObject.data {
//                    let json = String(data: data, encoding: String.Encoding.utf8)
//                    print("👹 Body: ", json)
//                    if let safeJson = json {
//                        let errorDict = self.convertToDictionary(text: safeJson)
//                        if let errors = errorDict?["Errors"] as? [String] {
//                            completionHandler(.failure(NetworkError.init(code: safeResponseObj.statusCode,
//                                                                         message: errors.joined(separator: " "))))
//                            return
//                        }
//                    }
//                }
//
//                self.printResponseObject(responseObject.response)
//                if let safeResponseObjData = responseObject.data {
//
//                    do {
//                        if var responseObj = try CodableService().decodeObject(of: NetworkError.self,
//                                                                               data: responseObject.data!) {
//                            responseObj.code = safeResponseObj.statusCode
//                            completionHandler(.failure(responseObj))
//                        } else {
//                            print("🆘🆘🆘🆘 Error to NetworkError object is Nil: ")
//                            completionHandler(.failure(NetworkError.init(code: safeResponseObj.statusCode,
//                                                                         message: "Could not decode object")))
//                        }
//                    } catch {
//                        print("🆘🆘🆘🆘 Could not convert error to NetworkError object: ", error)
//                        completionHandler(.failure(NetworkError.init(withError: error,
//                                                                     code: safeResponseObj.statusCode)))
//                    }
//                    //                completionHandler(.failure(NetworkError(code: safeResponseObj.statusCode,
//                    //                                                        message: safeResponseObj.url?.absoluteString)))
//                } else {
//                    completionHandler(.failure(NetworkError.init(code: safeResponseObj.statusCode,
//                                                                 message: "")))
//                }
//            } else {
//                if let safeError = responseObject.error {
//                    completionHandler(.failure(NetworkError.init(withAFError: safeError, code: safeResponseObj.statusCode)))
//                } else {
//                    if let safeResponseObjData = responseObject.data {
//                        var responseAsADict: [String: Any] = [:]
////                        self.convertResponseToDictionary(safeResponseObjData) { (result, error) in
////                            if error != nil {
////                                print("🆘🆘🆘🆘 Could not convert data to Dictionary: ", error ?? "Error is nil")
////                            } else if let result = result {
////                                responseAsADict = result
////                            } else {
////                            }
////                        }
////                        if self.isStatusFieldContainsError(responseAsADict,
////                                               statusCode: responseObject.response?.statusCode) {
////                            do {
////                                if let responseObj = try CodableService().decodeObject(of: NetworkError.self,
////                                                                                       data: safeResponseObjData) {
////                                    completionHandler(.failure(responseObj))
////                                } else {
////                                    print("🆘🆘🆘🆘 Error to NetworkError object is Nil: ")
////                                }
////                            } catch {
////                                print("🆘🆘🆘🆘 Could not convert error to NetworkError object: ", error)
////                                completionHandler(.failure(NetworkError.init(withError: error)))
////                            }
//
////                        } /*else {
//                            do {
//                                let responseObj = try CodableService().decodeObject(of: M.self,
//                                                                                    data: safeResponseObjData,
//                                                                                    key: nil)
//                                completionHandler(.success(responseObj!))
//                            } catch {
//                                print(error.localizedDescription.debugDescription)
//                                print(error.localizedDescription)
//
//                                completionHandler(.failure(NetworkError.init(withError: error, code: safeResponseObj.statusCode)))
//                            }
////                        }
//                    } else {
//    //                    completionHandler(.failure(NSError(domain: "Response object as a data is Nil", code: 1, userInfo: nil)))
//                        completionHandler(.failure(NetworkError.init(code: safeResponseObj.statusCode,
//                                                                     message: "Response object as a data is Nil")))
//                    }
//                }
//            }
//              }
//    }

    func fetchData<M: Decodable>(target: T,
                                 responseClass: M.Type,
                                 encoding: URLEncoding = .default,
                                 completionHandler: @escaping (Result<M, Error>) -> Void) {

        let url = target.baseURL + target.path// + "?" + self.constructRequiredParams()
        let headers = Alamofire.HTTPHeaders(target.headers ?? [:])
        let method = Alamofire.HTTPMethod(rawValue: target.method.rawValue)
        var parameters = buildParams(task: target.task)
        var finalParams = parameters.0
        self.printRequestDetails(url, headers, method, parameters)
        AF.request(url,
                   method: method,
                   parameters: finalParams,
                   encoding: encoding,
                   headers: headers).response { (responseObject) in
            guard let safeResponseObj = responseObject.response else {
//                completionHandler(.failure(Error.init(code: -1,
//                                                      message: "Texts.Common.Default.Error.message")))
                return
            }

            if// let safeResponseObj = responseObject.response,
               safeResponseObj.statusCode != 200 {
                if let data = responseObject.data {
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    print("👹 Body: ", json)
                }

                self.printResponseObject(responseObject.response)
//                do {
//                    if var responseObj = try CodableService().decodeObject(of: Error.self,
//                                                                           data: responseObject.data!) {
//                        responseObj.code = safeResponseObj.statusCode
//                        completionHandler(.failure(responseObj))
//                        return
//                    } else {
//                        print("🆘🆘🆘🆘 Error to NetworkError object is Nil: ")
////                        completionHandler(.failure(NetworkError.init(code: safeResponseObj.statusCode,
////                                                                     message: "Could not decode object")))
////                        completionHandler(.failure(error))
//                        return
//                    }
//                } catch {
//                    print("🆘🆘🆘🆘 Could not convert error to NetworkError object: ", error)
////                    completionHandler(.failure(NetworkError.init(withError: error,
////                                                                 code: safeResponseObj.statusCode)))
//                    completionHandler(.failure(error))
//
//                }
//                completionHandler(.failure(NetworkError(code: safeResponseObj.statusCode,
//                                                        message: safeResponseObj.url?.absoluteString)))
            } else {
                if let safeError = responseObject.error {
//                    completionHandler(.failure(NetworkError.init(withAFError: safeError,
//                                                                 code: safeResponseObj.statusCode)))
                    completionHandler(.failure(safeError))
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
//                            do {
//                                if var responseObj = try CodableService().decodeObject(of: Error.self,
//                                                                                       data: safeResponseObjData) {
//                                    responseObj.code = safeResponseObj.statusCode
//                                    completionHandler(.failure(responseObj))
//                                } else {
//                                    print("🆘🆘🆘🆘 Error to NetworkError object is Nil: ")
//                                }
//                            } catch {
//                                print("🆘🆘🆘🆘 Could not convert error to NetworkError object: ", error)
////                                completionHandler(.failure(NetworkError.init(withError: error,
////                                                                             code: safeResponseObj.statusCode)))
//                                completionHandler(.failure(error))
//                            }

                        } else {
//                            do {
//                                let responseObj = try CodableService().decodeObject(of: M.self,
//                                                                                    data: safeResponseObjData,
//                                                                                    key: Constants.responseDefaultKeyPath)
//                                completionHandler(.success(responseObj!))
//                            } catch {
//                                print(error.localizedDescription.debugDescription)
//                                print(error.localizedDescription)
//
////                                completionHandler(.failure(NetworkError.init(withError: error, code: safeResponseObj.statusCode)))
//                                completionHandler(.failure(error))
//                            }
                        }
                    } else {
    //                    completionHandler(.failure(NSError(domain: "Response object as a data is Nil", code: 1, userInfo: nil)))
//                        completionHandler(.failure(NetworkError.init(code: safeResponseObj.statusCode,
//                                                                     message: "Response object as a data is Nil")))
//                        completionHandler(.failure(error))
                    }
                }
            }
        }
    }

    private func buildParams(task: Task) -> ([String: Any], ParameterEncoding) {
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
            let jsonDict = try JSONSerialization.jsonObject(with: responseObjectData, options: []) as? [String: Any]
            let jsonData = try JSONSerialization.data(withJSONObject: jsonDict, options: .prettyPrinted)
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

//    private func constructRequiredParams() -> String {
//        let deviceTypeParam = "deviceType=iPhone"
//        let lightDarkModeParam = "&mode=" + (UserDefaultsManager().lightAppearanceMode ? "light" : "dark")
//        var udidParam = ""
//        if let udid = UIDevice().udid {
//            udidParam = "&applicationId=" + udid
//        }
//        var appVersionParam = ""
//        if let versionNumber = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
//            appVersionParam = "&applicationVersion=" + versionNumber
//        }
//        var versionNumberParam = ""
//        if let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
//            versionNumberParam = "&versionNumber=" + buildNumber
//        }
//        let deviceScaleParam = "&deviceScale=" + "\(String(describing: UIScreen.main.scale))"
//        let osVersionParam = "&os_version=" + UIDevice.current.systemVersion
//        let requiredParams = deviceTypeParam + lightDarkModeParam + udidParam +
//                                    appVersionParam + versionNumberParam +
//                                    deviceScaleParam + osVersionParam
//        return requiredParams
//    }
}

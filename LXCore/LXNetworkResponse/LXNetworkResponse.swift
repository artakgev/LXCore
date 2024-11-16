//
//  LXNetworkResponse.swift
//  LXCore
//
//  Created by Rafayel Aghayan on 23.10.23.
//

import Foundation
import Alamofire

// MARK: - Codable operator decode and encode
infix operator <~: AdditionPrecedence
infix operator ~>: AdditionPrecedence
infix operator <!: AdditionPrecedence
internal func <~<A: Decodable, K>(property: inout A, mapping: (KeyedDecodingContainer<K>, K)) {
  do {
    if let val = try mapping.0.decodeIfPresent(A.self, forKey: mapping.1) {
      property = val
    }
  } catch {}
}

internal func ~><A: Encodable, K>(container: inout KeyedEncodingContainer<K>, mapping: (A, K)) {
  do {
    try container.encode(mapping.0, forKey: mapping.1)
  } catch {}
}

internal func <!<A: Decodable, K>(container: KeyedDecodingContainer<K>, key: K) -> A {
  // swiftlint:disable force_try
  return try! container.decode(A.self, forKey: key)
}
// swiftlint:enable force_try

public enum LXNetworkResponse<T> {
    case next(value: T, statusCode: Int)
    case error(error: LXNetworkError, statusCode: Int)

    public var isNext: Bool {
        if case .next = self {
            return true
        }
        return false
    }

    public var value: T? {
        switch self {
        case .next(value: let val, statusCode: _):
            return val
        default: return nil
        }
    }

    public var statusCode: Int {
        switch self {
        case .next(value: _, statusCode: let code):
            return code
        case .error(error: _, statusCode: let code):
            return code
        }
    }

    public func toVoid() -> NetworkResponseVoid {
        switch self {
        case .error(error: let error, statusCode: let code):
            return .error(error: error, statusCode: code)
        case .next(value: _, statusCode: let code):
            return .next(statusCode: code)
        }
    }
}

public enum NetworkResponseVoid {
    case next(statusCode: Int)
    case error(error: LXNetworkError, statusCode: Int)

    public var isNext: Bool {
        if case .next = self {
            return true
        }
        return false
    }
}

public struct LXNetworkError: Error, Decodable {
    public var code: Int? = -1
    public var message: String?
    public var errors: [ErrorKey: String]?
    public var status: String?
    public var apiEndpoint: String?

    public init(code: Int, message: String? = nil, apiEndPoint: String? = nil, errors: [ErrorKey: String]? = nil) {
        self.code = code
        self.message = message
        self.errors = errors
    }

    enum CodingKeys: String, CodingKey {
        case status
        case message
        case errors
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message <~ (values, .message)
        errors <~ (values, .errors)
        status <~ (values, .status)
    }

    public init(withAFError: AFError, code: Int) {
        self.code = code
        if let underlyingError = withAFError.underlyingError as NSError?,
           [NSURLErrorNotConnectedToInternet, NSURLErrorDataNotAllowed].contains(underlyingError.code) {
            self.message = LXConstantsManager.shared.getLXCurrentError(.noInternetError)
        } else if withAFError.isExplicitlyCancelledError {
            self.message = "AFIsExplicitlyCancelledError"
            // for isExplicitlyCancelledError errorDescription is "Request explicitly cancelled"
        } else if withAFError.isInvalidURLError {
            self.message = "AFInvalidURLError"
        } else if withAFError.isRequestRetryError {
            self.message = "AFRequestRetryError"
        } else if withAFError.isCreateUploadableError {
            self.message = "AFCreateUploadableError"
        } else if withAFError.isParameterEncoderError {
            self.message = "AFParameterEncoderError"
        } else if withAFError.isMultipartEncodingError {
            self.message = "AFMultipartEncodingError"
        } else if withAFError.isRequestAdaptationError {
            self.message = "AFRequestAdaptationError"
        } else if withAFError.isResponseValidationError {
            self.message = "AFResponseValidationError"
        } else if withAFError.isSessionInvalidatedError {
            self.message = "AFSessionInvalidatedError"
        } else if withAFError.isSessionDeinitializedError {
            self.message = "AFSessionDeinitializedError"
        } else if withAFError.isSessionTaskError {
            self.message = "AFSessionTaskError"
        } else if withAFError.isCreateURLRequestError {
            self.message = "AFCreateURLRequestError"
        } else if withAFError.isParameterEncodingError {
            self.message = "AFParameterEncodingError"
        } else if withAFError.isResponseSerializationError {
            self.message = "AFResponseSerializationError"
        } else if withAFError.isServerTrustEvaluationError {
            self.message = "AFServerTrustEvaluationError"
        } else if withAFError.isDownloadedFileMoveError {
            self.message = "AFDownloadedFileMoveError"
        }
    }

    public init(withError: Error, code: Int) {
        self.code = code
        self.message = withError.asAFError.debugDescription
        #warning("To do handle details error")
//        if let safeAsAFError = withError.asAFError {
//            self.message = safeAsAFError.errorDescription ?? safeAsAFError.localizedDescription
//        } else if let safeAsDecodingError = withError as? DecodingError {
//            //      self.message = safeAsDecodingError.
//        }
        guard message == "nil" else { return }
        message = LXConstantsManager.shared.getLXCurrentError(.defaultError)
    }

    public var getDisplayDescription: String {
        let isTestEnv = LXEnvironmentConstants.isTestEnv
        var apiEndpointStr = ""
        if let safeApiEndpointStr = apiEndpoint,
           isTestEnv {
            apiEndpointStr = "API: " + "\(safeApiEndpointStr)" + " "
        }

        var codeStr = ""
        if let safeCode = code,
           isTestEnv {
            codeStr = "Status code: " + "\(safeCode)" + " "
        }
        var statusStr = ""
        if let safeStatus = status,
           isTestEnv {
            statusStr = "Status: " + "\(safeStatus)"
        }
        var messageStr = ""
        if let safeMessage = message {
            messageStr = (isTestEnv ? "\nMessage: " : "") + safeMessage
        }
        var errorFieldsStr = ""
        if let safeErrors = errors {
            let safeErrors = safeErrors.map { (isTestEnv ? ($0.0 + ": ") : "")  + $0.1 }.joined(separator: ", ")

            errorFieldsStr = (isTestEnv ? "\nErrors: " : "") + safeErrors
        }
        return apiEndpointStr + codeStr + statusStr + messageStr + errorFieldsStr
    }
    
    public func isUnathorized() -> Bool {
        return code == 401 && status == "UNAUTHORIZED"
    }
}

extension LXNetworkError {
    public func toNSError() -> NSError {
        return .init(domain: Bundle.main.bundleIdentifier ?? "Application",
                     code: 0, userInfo: [NSLocalizedDescriptionKey: localizedDescription])
    }
}

extension NSError {
    public func toLXNetworkError() -> LXNetworkError {
        return LXNetworkError(code: self.code, message: self.localizedDescription)
    }
}

public typealias ErrorKey = String

//typealias ObservableNetworkResponse<T> = Observable<NetworkResponse<T>>
//typealias ObservableNetworkResponseVoid = Observable<NetworkResponseVoid>

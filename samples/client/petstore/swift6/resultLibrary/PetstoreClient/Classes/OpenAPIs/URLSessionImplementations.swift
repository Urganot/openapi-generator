// URLSessionImplementations.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if !os(macOS)
import MobileCoreServices
#endif
#if canImport(UniformTypeIdentifiers)
import UniformTypeIdentifiers
#endif

// Protocol defined for a session data task. This allows mocking out the URLSessionProtocol below since
// you may not want to create or return a real URLSessionDataTask.
internal protocol URLSessionDataTaskProtocol {
    func resume()

    var taskIdentifier: Int { get }

    var progress: Progress { get }

    func cancel()
}

// Protocol allowing implementations to alter what is returned or to test their implementations.
internal protocol URLSessionProtocol {
    // Task which performs the network fetch. Expected to be from URLSession.dataTask(with:completionHandler:) such that a network request
    // is sent off when `.resume()` is called.
    func dataTaskFromProtocol(with request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, (any Error)?) -> Void) -> URLSessionDataTaskProtocol
}

extension URLSession: URLSessionProtocol {
  // Passthrough to URLSession.dataTask(with:completionHandler) since URLSessionDataTask conforms to URLSessionDataTaskProtocol and fetches the network data.
  internal func dataTaskFromProtocol(with request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, (any Error)?) -> Void) -> URLSessionDataTaskProtocol {
    return dataTask(with: request, completionHandler: completionHandler)
  }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}

internal class URLSessionRequestBuilderFactory: RequestBuilderFactory {
    internal init() {}

    internal func getNonDecodableBuilder<T>() -> RequestBuilder<T>.Type {
        return URLSessionRequestBuilder<T>.self
    }

    internal func getBuilder<T: Decodable>() -> RequestBuilder<T>.Type {
        return URLSessionDecodableRequestBuilder<T>.self
    }
}

internal typealias PetstoreClientAPIChallengeHandler = ((URLSession, URLSessionTask, URLAuthenticationChallenge) -> (URLSession.AuthChallengeDisposition, URLCredential?))

fileprivate class URLSessionRequestBuilderConfiguration: @unchecked Sendable {
    private init() {
        defaultURLSession = URLSession(configuration: .default, delegate: sessionDelegate, delegateQueue: nil)
    }

    static let shared = URLSessionRequestBuilderConfiguration()
    
    // Store the URLSession's delegate to retain its reference
    let sessionDelegate = SessionDelegate()

    // Store the URLSession to retain its reference
    let defaultURLSession: URLSession

    // Store current taskDidReceiveChallenge for every URLSessionTask
    var challengeHandlerStore = SynchronizedDictionary<Int, PetstoreClientAPIChallengeHandler>()

    // Store current URLCredential for every URLSessionTask
    var credentialStore = SynchronizedDictionary<Int, URLCredential>()
}

internal class URLSessionRequestBuilder<T>: RequestBuilder<T>, @unchecked Sendable {

    /**
     May be assigned if you want to control the authentication challenges.
     */
    internal var taskDidReceiveChallenge: PetstoreClientAPIChallengeHandler?

    required internal init(method: String, URLString: String, parameters: [String: Any]?, headers: [String: String] = [:], requiresAuthentication: Bool, openAPIClient: OpenAPIClient = OpenAPIClient.shared) {
        super.init(method: method, URLString: URLString, parameters: parameters, headers: headers, requiresAuthentication: requiresAuthentication, openAPIClient: openAPIClient)
    }

    /**
     May be overridden by a subclass if you want to control the URLSession
     configuration.
     */
    internal func createURLSession() -> URLSessionProtocol {
        return URLSessionRequestBuilderConfiguration.shared.defaultURLSession
    }

    /**
     May be overridden by a subclass if you want to control the Content-Type
     that is given to an uploaded form part.

     Return nil to use the default behavior (inferring the Content-Type from
     the file extension).  Return the desired Content-Type otherwise.
     */
    internal func contentTypeForFormPart(fileURL: URL) -> String? {
        return nil
    }

    /**
     May be overridden by a subclass if you want to control the URLRequest
     configuration (e.g. to override the cache policy).
     */
    internal func createURLRequest(urlSession: URLSessionProtocol, method: HTTPMethod, encoding: ParameterEncoding, headers: [String: String]) throws -> URLRequest {

        guard let url = URL(string: URLString) else {
            throw DownloadException.requestMissingURL
        }

        var originalRequest = URLRequest(url: url)

        originalRequest.httpMethod = method.rawValue

        buildHeaders().forEach { key, value in
            originalRequest.setValue(value, forHTTPHeaderField: key)
        }

        let modifiedRequest = try encoding.encode(originalRequest, with: parameters)

        return modifiedRequest
    }

    @discardableResult
    override internal func execute(completion: @Sendable @escaping (_ result: Swift.Result<Response<T>, ErrorResponse>) -> Void) -> RequestTask {
        let urlSession = createURLSession()

        guard let xMethod = HTTPMethod(rawValue: method) else {
            fatalError("Unsupported Http method - \(method)")
        }

        let encoding: ParameterEncoding

        switch xMethod {
        case .get, .head:
            encoding = URLEncoding()

        case .options, .post, .put, .patch, .delete, .trace, .connect:
            let contentType = headers["Content-Type"] ?? "application/json"

            if contentType.hasPrefix("application/") && contentType.contains("json") {
                encoding = JSONDataEncoding()
            } else if contentType.hasPrefix("multipart/form-data") {
                encoding = FormDataEncoding(contentTypeForFormPart: contentTypeForFormPart(fileURL:))
            } else if contentType.hasPrefix("application/x-www-form-urlencoded") {
                encoding = FormURLEncoding()
            } else if contentType.hasPrefix("application/octet-stream"){
                encoding = OctetStreamEncoding()
            } else {
                fatalError("Unsupported Media Type - \(contentType)")
            }
        }

        do {
            let request = try createURLRequest(urlSession: urlSession, method: xMethod, encoding: encoding, headers: headers)

            let dataTask = urlSession.dataTaskFromProtocol(with: request) { data, response, error in
                self.openAPIClient.apiResponseQueue.async {
                    self.processRequestResponse(urlRequest: request, data: data, response: response, error: error, completion: completion)
                    self.cleanupRequest()
                }
            }

            onProgressReady?(dataTask.progress)

            URLSessionRequestBuilderConfiguration.shared.challengeHandlerStore[dataTask.taskIdentifier] = taskDidReceiveChallenge
            URLSessionRequestBuilderConfiguration.shared.credentialStore[dataTask.taskIdentifier] = credential

            requestTask.set(task: dataTask)

            dataTask.resume()
        } catch {
            self.openAPIClient.apiResponseQueue.async {
                completion(.failure(ErrorResponse.error(415, nil, nil, error)))
            }
        }

        return requestTask
    }

    private func cleanupRequest() {
        if let task = requestTask.get() {
            URLSessionRequestBuilderConfiguration.shared.challengeHandlerStore[task.taskIdentifier] = nil
            URLSessionRequestBuilderConfiguration.shared.credentialStore[task.taskIdentifier] = nil
        }
    }

    fileprivate func processRequestResponse(urlRequest: URLRequest, data: Data?, response: URLResponse?, error: Error?, completion: @escaping (_ result: Swift.Result<Response<T>, ErrorResponse>) -> Void) {

        if let error = error {
            completion(.failure(ErrorResponse.error(-1, data, response, error)))
            return
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            completion(.failure(ErrorResponse.error(-2, data, response, DecodableRequestBuilderError.nilHTTPResponse)))
            return
        }

        guard openAPIClient.successfulStatusCodeRange.contains(httpResponse.statusCode) else {
            completion(.failure(ErrorResponse.error(httpResponse.statusCode, data, response, DecodableRequestBuilderError.unsuccessfulHTTPStatusCode)))
            return
        }

        switch T.self {
        case is Void.Type:

            completion(.success(Response(response: httpResponse, body: () as! T, bodyData: data)))

        default:
            fatalError("Unsupported Response Body Type - \(String(describing: T.self))")
        }

    }

    internal func buildHeaders() -> [String: String] {
        var httpHeaders: [String: String] = [:]
        for (key, value) in openAPIClient.customHeaders {
            httpHeaders[key] = value
        }
        for (key, value) in headers {
            httpHeaders[key] = value
        }
        return httpHeaders
    }

    fileprivate func getFileName(fromContentDisposition contentDisposition: String?) -> String? {

        guard let contentDisposition = contentDisposition else {
            return nil
        }

        let items = contentDisposition.components(separatedBy: ";")

        var filename: String?

        for contentItem in items {

            let filenameKey = "filename="
            guard let range = contentItem.range(of: filenameKey) else {
                continue
            }

            filename = contentItem
            return filename?
                .replacingCharacters(in: range, with: "")
                .replacingOccurrences(of: "\"", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
        }

        return filename

    }

    fileprivate func getPath(from url: URL) throws -> String {

        guard var path = URLComponents(url: url, resolvingAgainstBaseURL: true)?.path else {
            throw DownloadException.requestMissingPath
        }

        if path.hasPrefix("/") {
            path.remove(at: path.startIndex)
        }

        return path

    }

    fileprivate func getURL(from urlRequest: URLRequest) throws -> URL {

        guard let url = urlRequest.url else {
            throw DownloadException.requestMissingURL
        }

        return url
    }

}

internal class URLSessionDecodableRequestBuilder<T: Decodable>: URLSessionRequestBuilder<T>, @unchecked Sendable {
    override fileprivate func processRequestResponse(urlRequest: URLRequest, data: Data?, response: URLResponse?, error: Error?, completion: @escaping (_ result: Swift.Result<Response<T>, ErrorResponse>) -> Void) {

        if let error = error {
            completion(.failure(ErrorResponse.error(-1, data, response, error)))
            return
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            completion(.failure(ErrorResponse.error(-2, data, response, DecodableRequestBuilderError.nilHTTPResponse)))
            return
        }

        guard openAPIClient.successfulStatusCodeRange.contains(httpResponse.statusCode) else {
            completion(.failure(ErrorResponse.error(httpResponse.statusCode, data, response, DecodableRequestBuilderError.unsuccessfulHTTPStatusCode)))
            return
        }

        switch T.self {
        case is String.Type:

            let body = data.flatMap { String(data: $0, encoding: .utf8) } ?? ""

            completion(.success(Response<T>(response: httpResponse, body: body as! T, bodyData: data)))

        case is URL.Type:
            do {

                guard error == nil else {
                    throw DownloadException.responseFailed
                }

                guard let data = data else {
                    throw DownloadException.responseDataMissing
                }

                let fileManager = FileManager.default
                let cachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
                let requestURL = try getURL(from: urlRequest)

                var requestPath = try getPath(from: requestURL)

                if let headerFileName = getFileName(fromContentDisposition: httpResponse.allHeaderFields["Content-Disposition"] as? String) {
                    requestPath = requestPath.appending("/\(headerFileName)")
                } else {
                    requestPath = requestPath.appending("/tmp.PetstoreClient.\(UUID().uuidString)")
                }

                let filePath = cachesDirectory.appendingPathComponent(requestPath)
                let directoryPath = filePath.deletingLastPathComponent().path

                try fileManager.createDirectory(atPath: directoryPath, withIntermediateDirectories: true, attributes: nil)
                try data.write(to: filePath, options: .atomic)

                completion(.success(Response(response: httpResponse, body: filePath as! T, bodyData: data)))

            } catch let requestParserError as DownloadException {
                completion(.failure(ErrorResponse.error(400, data, response, requestParserError)))
            } catch {
                completion(.failure(ErrorResponse.error(400, data, response, error)))
            }

        case is Void.Type:

            completion(.success(Response(response: httpResponse, body: () as! T, bodyData: data)))

        case is Data.Type:

            completion(.success(Response(response: httpResponse, body: data as! T, bodyData: data)))

        default:

            guard let unwrappedData = data, !unwrappedData.isEmpty else {
                if let expressibleByNilLiteralType = T.self as? ExpressibleByNilLiteral.Type {
                    completion(.success(Response(response: httpResponse, body: expressibleByNilLiteralType.init(nilLiteral: ()) as! T, bodyData: data)))
                } else {
                    completion(.failure(ErrorResponse.error(httpResponse.statusCode, nil, response, DecodableRequestBuilderError.emptyDataResponse)))
                }
                return
            }

            let decodeResult = openAPIClient.codableHelper.decode(T.self, from: unwrappedData)

            switch decodeResult {
            case let .success(decodableObj):
                completion(.success(Response(response: httpResponse, body: decodableObj, bodyData: unwrappedData)))
            case let .failure(error):
                completion(.failure(ErrorResponse.error(httpResponse.statusCode, unwrappedData, response, error)))
            }
        }
    }
}

fileprivate final class SessionDelegate: NSObject, URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {

        var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling

        var credential: URLCredential?

        if let taskDidReceiveChallenge = URLSessionRequestBuilderConfiguration.shared.challengeHandlerStore[task.taskIdentifier] {
            (disposition, credential) = taskDidReceiveChallenge(session, task, challenge)
        } else {
            if challenge.previousFailureCount > 0 {
                disposition = .rejectProtectionSpace
            } else {
                credential = URLSessionRequestBuilderConfiguration.shared.credentialStore[task.taskIdentifier] ?? session.configuration.urlCredentialStorage?.defaultCredential(for: challenge.protectionSpace)

                if credential != nil {
                    disposition = .useCredential
                }
            }
        }

        completionHandler(disposition, credential)
    }
}

internal enum HTTPMethod: String {
    case options = "OPTIONS"
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case trace = "TRACE"
    case connect = "CONNECT"
}

internal protocol ParameterEncoding {
    func encode(_ urlRequest: URLRequest, with parameters: [String: Any]?) throws -> URLRequest
}

private class URLEncoding: ParameterEncoding {
    func encode(_ urlRequest: URLRequest, with parameters: [String: Any]?) throws -> URLRequest {

        var urlRequest = urlRequest

        guard let parameters = parameters else { return urlRequest }

        guard let url = urlRequest.url else {
            throw DownloadException.requestMissingURL
        }

        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            urlComponents.queryItems = APIHelper.mapValuesToQueryItems(parameters)
            urlRequest.url = urlComponents.url
        }

        return urlRequest
    }
}

private class FormDataEncoding: ParameterEncoding {

    let contentTypeForFormPart: (_ fileURL: URL) -> String?

    init(contentTypeForFormPart: @escaping (_ fileURL: URL) -> String?) {
        self.contentTypeForFormPart = contentTypeForFormPart
    }

    func encode(_ urlRequest: URLRequest, with parameters: [String: Any]?) throws -> URLRequest {

        var urlRequest = urlRequest

        guard let parameters = parameters, !parameters.isEmpty else {
            return urlRequest
        }

        let boundary = "Boundary-\(UUID().uuidString)"

        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        for (key, value) in parameters {
            for value in (value as? Array ?? [value]) {
                switch value {
                case let fileURL as URL:

                    urlRequest = try configureFileUploadRequest(
                        urlRequest: urlRequest,
                        boundary: boundary,
                        name: key,
                        fileURL: fileURL
                    )

                case let string as String:

                    if let data = string.data(using: .utf8) {
                        urlRequest = configureDataUploadRequest(
                            urlRequest: urlRequest,
                            boundary: boundary,
                            name: key,
                            data: data
                        )
                    }

                case let number as NSNumber:

                    if let data = number.stringValue.data(using: .utf8) {
                        urlRequest = configureDataUploadRequest(
                            urlRequest: urlRequest,
                            boundary: boundary,
                            name: key,
                            data: data
                        )
                    }

                case let data as Data:

                    urlRequest = configureDataUploadRequest(
                        urlRequest: urlRequest,
                        boundary: boundary,
                        name: key,
                        data: data
                    )

                case let uuid as UUID:

                    if let data = uuid.uuidString.data(using: .utf8) {
                        urlRequest = configureDataUploadRequest(
                            urlRequest: urlRequest,
                            boundary: boundary,
                            name: key,
                            data: data
                        )
                    }

                default:
                    fatalError("Unprocessable value \(value) with key \(key)")
                }
            }
        }

        var body = urlRequest.httpBody.orEmpty

        body.append("\r\n--\(boundary)--\r\n")

        urlRequest.httpBody = body

        return urlRequest
    }

    private func configureFileUploadRequest(urlRequest: URLRequest, boundary: String, name: String, fileURL: URL) throws -> URLRequest {

        var urlRequest = urlRequest

        var body = urlRequest.httpBody.orEmpty

        let fileData = try Data(contentsOf: fileURL)

        let mimetype = contentTypeForFormPart(fileURL) ?? mimeType(for: fileURL)

        let fileName = fileURL.lastPathComponent

        // If we already added something then we need an additional newline.
        if body.count > 0 {
            body.append("\r\n")
        }

        // Value boundary.
        body.append("--\(boundary)\r\n")

        // Value headers.
        body.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName)\"\r\n")
        body.append("Content-Type: \(mimetype)\r\n")

        // Separate headers and body.
        body.append("\r\n")

        // The value data.
        body.append(fileData)

        urlRequest.httpBody = body

        return urlRequest
    }

    private func configureDataUploadRequest(urlRequest: URLRequest, boundary: String, name: String, data: Data) -> URLRequest {

        var urlRequest = urlRequest

        var body = urlRequest.httpBody.orEmpty

        // If we already added something then we need an additional newline.
        if body.count > 0 {
            body.append("\r\n")
        }

        // Value boundary.
        body.append("--\(boundary)\r\n")

        // Value headers.
        body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n")

        // Separate headers and body.
        body.append("\r\n")

        // The value data.
        body.append(data)

        urlRequest.httpBody = body

        return urlRequest

    }

    func mimeType(for url: URL) -> String {
        let pathExtension = url.pathExtension

        if #available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *) {
            #if canImport(UniformTypeIdentifiers)
            if let utType = UTType(filenameExtension: pathExtension) {
                return utType.preferredMIMEType ?? "application/octet-stream"
            }
            #else
            return "application/octet-stream" 
            #endif
        } else {
            if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue(),
                    let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
            return "application/octet-stream"
        }
        return "application/octet-stream"
    }

}

private class FormURLEncoding: ParameterEncoding {
    func encode(_ urlRequest: URLRequest, with parameters: [String: Any]?) throws -> URLRequest {

        var urlRequest = urlRequest

        var requestBodyComponents = URLComponents()
        requestBodyComponents.queryItems = APIHelper.mapValuesToQueryItems(parameters ?? [:])

        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        }

        urlRequest.httpBody = requestBodyComponents.query?.data(using: .utf8)

        return urlRequest
    }
}

private class OctetStreamEncoding: ParameterEncoding {
    func encode(_ urlRequest: URLRequest, with parameters: [String: Any]?) throws -> URLRequest {

        var urlRequest = urlRequest

        guard let body = parameters?["body"] else { return urlRequest }

        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        }

        switch body {
        case let fileURL as URL:
            urlRequest.httpBody = try Data(contentsOf: fileURL)
        case let data as Data:
            urlRequest.httpBody = data
        default:
            fatalError("Unprocessable body \(body)")
        }

        return urlRequest
    }
}

private extension Data {
    /// Append string to Data
    ///
    /// Rather than littering my code with calls to `dataUsingEncoding` to convert strings to Data, and then add that data to the Data, this wraps it in a nice convenient little extension to Data. This converts using UTF-8.
    ///
    /// - parameter string:       The string to be added to the `Data`.

    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

private extension Optional where Wrapped == Data {
    var orEmpty: Data {
        self ?? Data()
    }
}

extension JSONDataEncoding: ParameterEncoding {}

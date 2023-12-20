//
//  ApiRepository.swift
//  Twitter Notification App
//
//  Created by Moshiur Rahman on 11/3/23.
//

import Foundation

public class ApiRepository {
    
    private let baseUrl: URL

    public init(baseUrl: URL) {
        self.baseUrl = baseUrl
    }

    lazy var jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()

        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)

        return jsonDecoder
    }()
}

// MARK: - API calls
extension ApiRepository {
    
    func urlRequest(httpMethod: String, url: URL, accessToken: String? = nil) -> URLRequest {
        var result = URLRequest(url: url)
        result.httpMethod = httpMethod
        
        if let accessToken = accessToken {
            result.setValue("\(accessToken)", forHTTPHeaderField: "api-key")
        }
        return result
    }

    func urlRequest(
        httpMethod: String,
        path: String,
        queryItems: [URLQueryItem]? = nil,
        accessToken: String? = nil
    ) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.queryItems = queryItems
        let url = urlComponents.url(relativeTo: self.baseUrl.appendingPathComponent(path))!
        var result = urlRequest(httpMethod: httpMethod, url: url, accessToken: accessToken)
        result.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        result.setValue("application/json", forHTTPHeaderField: "Accept")
        return result
    }

    func invoke<DTO: Decodable>(
        urlRequest: URLRequest,
        block: @escaping (DTO?, Error?) -> Void
    ) {
        self._invoke(urlRequest: urlRequest) { (response: DTO?, error: Error?) in
            if let myError = error as? MyError, case .invocationFailed(let reason) = myError, reason.statusCode == 401 {
                self._resetSession()
                block(response, error)
                return
            }
            block(response, error)
        }
    }

    private func _invoke<DTO: Decodable>(
        urlRequest: URLRequest,
        block: @escaping (DTO?, Error?) -> Void
    ) {
        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, urlResponse, error in
            guard let self = self else { return }

            var result: (dto: DTO?, error: Error?) = (nil, nil)

            defer {
                if let error = result.error {
                    print("ERROR [API] \(urlRequest.httpMethod ?? "") \(urlRequest.url?.absoluteString ?? ""): \(error.localizedDescription)")
                } else if result.dto == nil {
                    print("ERROR [API] \(urlRequest.httpMethod ?? "") \(urlRequest.url?.absoluteString ?? ""): Not found response.")
                }
                block(result.dto, result.error)
            }

            if let error = error {
                result = (nil, error)
                return
            }
            guard let httpUrlResponse = urlResponse as? HTTPURLResponse else {
                result = (nil, "Invalid HTTP response.")
                return
            }

            let statusCode = httpUrlResponse.statusCode
            guard statusCode >= 200 && statusCode < 300 else {
                do {
                    guard let data = data else {
                        throw "Response data is nil."
                    }

                    let errorResponse = try self.jsonDecoder.decode(ErrorResponse.self, from: data)

                    print("ERROR [RESPONSE \(statusCode)] \(urlRequest.httpMethod ?? "") \(urlRequest.url?.absoluteString ?? ""): \(errorResponse)")

                    result = (nil, MyError.invocationFailed(reason: (
                        errorResponse.detail ?? errorResponse.detail,
                        statusCode
                    )))
                } catch {
                    print("ERROR [JSONDecoder \(ErrorResponse.self)]", error)
                    result = (nil, MyError.invocationFailed(reason: (
                        message: error.localizedDescription,
                        statusCode: statusCode
                    )))
                }

                // If (404 - Not Found) then we do not throw an error, instead we return nil as a result DTO.
                if statusCode == 404 {
                    result = (nil, nil)
                }

                return
            }

            do {
                guard let data = data else {
                    throw "Response data is nil."
                }

                let dto = try self.jsonDecoder.decode(DTO.self, from: data)

                result = (dto, nil)
            } catch {
                print("ERROR [JSONDecoder \(DTO.self)]", error)

                result = (nil, MyError.invocationFailed(reason: (
                    message: error.localizedDescription,
                    statusCode: statusCode
                )))
            }
        }

        task.resume()
    }

    func _resetSession(notify: Bool = false) {
        UserDefaults.authSession = nil

        if notify {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: ApiRepository.unauthorizedNotification, object: nil)
            }
        }
    }
}

// MARK: - Notifications

extension ApiRepository {
    public static let unauthorizedNotification = NSNotification.Name(rawValue: "\(Bundle.main.bundleIdentifier!).UnauthorizedNotification")
}

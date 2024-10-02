//
// StoreAPI.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
@preconcurrency import PromiseKit
@preconcurrency import RxSwift
#if canImport(Combine)
import Combine
#endif
#if canImport(AnyCodable)
import AnyCodable
#endif

open class StoreAPI {
    public let openAPIClient: OpenAPIClient
    public init(openAPIClient: OpenAPIClient = OpenAPIClient.shared) {
        self.openAPIClient = openAPIClient
    }

    /**
     Delete purchase order by ID
     
     - parameter orderId: (path) ID of the order that needs to be deleted 
     - returns: Promise<Void>
     */
    open func deleteOrder(orderId: String) -> Promise<Void> {
        let deferred = Promise<Void>.pending()
        deleteOrderWithRequestBuilder(orderId: orderId).execute { result in
            switch result {
            case .success:
                deferred.resolver.fulfill(())
            case let .failure(error):
                deferred.resolver.reject(error)
            }
        }
        return deferred.promise
    }

    /**
     Delete purchase order by ID
     
     - parameter orderId: (path) ID of the order that needs to be deleted 
     - returns: Observable<Void>
     */
    open func deleteOrder(orderId: String) -> Observable<Void> {
        return Observable.create { observer -> Disposable in
            let requestTask = self.deleteOrderWithRequestBuilder(orderId: orderId).execute { result in
                switch result {
                case .success:
                    observer.onNext(())
                case let .failure(error):
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            
            return Disposables.create {
                requestTask.cancel()
            }
        }
    }

    /**
     Delete purchase order by ID
     
     - parameter orderId: (path) ID of the order that needs to be deleted 
     - returns: AnyPublisher<Void, Error>
     */
    #if canImport(Combine)
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open func deleteOrder(orderId: String) -> AnyPublisher<Void, Error> {
        let requestBuilder = deleteOrderWithRequestBuilder(orderId: orderId)
        let requestTask = requestBuilder.requestTask
        return Deferred { Future<Void, Error> { promise in
            nonisolated(unsafe) let promise = promise
            requestBuilder.execute { result in
                switch result {
                case .success:
                    promise(.success(()))
                case let .failure(error):
                    promise(.failure(error))
                }
            }
        }
        .handleEvents(receiveCancel: {
            requestTask.cancel()
        })
        .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
    #endif

    /**
     Delete purchase order by ID
     
     - parameter orderId: (path) ID of the order that needs to be deleted 
     - returns: Void
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open func deleteOrder(orderId: String) async throws(ErrorResponse) {
        return try await deleteOrderWithRequestBuilder(orderId: orderId).execute().body
    }

    /**
     Delete purchase order by ID
     
     - parameter orderId: (path) ID of the order that needs to be deleted 
     - parameter completion: completion handler to receive the result
     */
    @discardableResult
    open func deleteOrder(orderId: String, completion: @Sendable @escaping (_ result: Swift.Result<Void, ErrorResponse>) -> Void) -> RequestTask {
        return deleteOrderWithRequestBuilder(orderId: orderId).execute { result in
            switch result {
            case .success:
                completion(.success(()))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    /**
     Delete purchase order by ID
     - DELETE /store/order/{order_id}
     - For valid response try integer IDs with value < 1000. Anything above 1000 or nonintegers will generate API errors
     - parameter orderId: (path) ID of the order that needs to be deleted 
     
     - returns: RequestBuilder<Void> 
     */
    open func deleteOrderWithRequestBuilder(orderId: String) -> RequestBuilder<Void> {
        var localVariablePath = "/store/order/{order_id}"
        let orderIdPreEscape = "\(APIHelper.mapValueToPathItem(orderId))"
        let orderIdPostEscape = orderIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        localVariablePath = localVariablePath.replacingOccurrences(of: "{order_id}", with: orderIdPostEscape, options: .literal, range: nil)
        let localVariableURLString = openAPIClient.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<Void>.Type = openAPIClient.requestBuilderFactory.getNonDecodableBuilder()

        return localVariableRequestBuilder.init(method: "DELETE", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: false, openAPIClient: openAPIClient)
    }

    /**
     Returns pet inventories by status
     
     - returns: Promise<[String: Int]>
     */
    open func getInventory() -> Promise<[String: Int]> {
        let deferred = Promise<[String: Int]>.pending()
        getInventoryWithRequestBuilder().execute { result in
            switch result {
            case let .success(response):
                deferred.resolver.fulfill(response.body)
            case let .failure(error):
                deferred.resolver.reject(error)
            }
        }
        return deferred.promise
    }

    /**
     Returns pet inventories by status
     
     - returns: Observable<[String: Int]>
     */
    open func getInventory() -> Observable<[String: Int]> {
        return Observable.create { observer -> Disposable in
            let requestTask = self.getInventoryWithRequestBuilder().execute { result in
                switch result {
                case let .success(response):
                    observer.onNext(response.body)
                case let .failure(error):
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            
            return Disposables.create {
                requestTask.cancel()
            }
        }
    }

    /**
     Returns pet inventories by status
     
     - returns: AnyPublisher<[String: Int], Error>
     */
    #if canImport(Combine)
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open func getInventory() -> AnyPublisher<[String: Int], Error> {
        let requestBuilder = getInventoryWithRequestBuilder()
        let requestTask = requestBuilder.requestTask
        return Deferred { Future<[String: Int], Error> { promise in
            nonisolated(unsafe) let promise = promise
            requestBuilder.execute { result in
                switch result {
                case let .success(response):
                    promise(.success(response.body))
                case let .failure(error):
                    promise(.failure(error))
                }
            }
        }
        .handleEvents(receiveCancel: {
            requestTask.cancel()
        })
        .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
    #endif

    /**
     Returns pet inventories by status
     
     - returns: [String: Int]
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open func getInventory() async throws(ErrorResponse) -> [String: Int] {
        return try await getInventoryWithRequestBuilder().execute().body
    }

    /**
     Returns pet inventories by status
     
     - parameter completion: completion handler to receive the result
     */
    @discardableResult
    open func getInventory(completion: @Sendable @escaping (_ result: Swift.Result<[String: Int], ErrorResponse>) -> Void) -> RequestTask {
        return getInventoryWithRequestBuilder().execute { result in
            switch result {
            case let .success(response):
                completion(.success(response.body))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    /**
     Returns pet inventories by status
     - GET /store/inventory
     - Returns a map of status codes to quantities
     - API Key:
       - type: apiKey api_key (HEADER)
       - name: api_key

     - returns: RequestBuilder<[String: Int]> 
     */
    open func getInventoryWithRequestBuilder() -> RequestBuilder<[String: Int]> {
        let localVariablePath = "/store/inventory"
        let localVariableURLString = openAPIClient.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<[String: Int]>.Type = openAPIClient.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true, openAPIClient: openAPIClient)
    }

    /**
     Find purchase order by ID
     
     - parameter orderId: (path) ID of pet that needs to be fetched 
     - returns: Promise<Order>
     */
    open func getOrderById(orderId: Int64) -> Promise<Order> {
        let deferred = Promise<Order>.pending()
        getOrderByIdWithRequestBuilder(orderId: orderId).execute { result in
            switch result {
            case let .success(response):
                deferred.resolver.fulfill(response.body)
            case let .failure(error):
                deferred.resolver.reject(error)
            }
        }
        return deferred.promise
    }

    /**
     Find purchase order by ID
     
     - parameter orderId: (path) ID of pet that needs to be fetched 
     - returns: Observable<Order>
     */
    open func getOrderById(orderId: Int64) -> Observable<Order> {
        return Observable.create { observer -> Disposable in
            let requestTask = self.getOrderByIdWithRequestBuilder(orderId: orderId).execute { result in
                switch result {
                case let .success(response):
                    observer.onNext(response.body)
                case let .failure(error):
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            
            return Disposables.create {
                requestTask.cancel()
            }
        }
    }

    /**
     Find purchase order by ID
     
     - parameter orderId: (path) ID of pet that needs to be fetched 
     - returns: AnyPublisher<Order, Error>
     */
    #if canImport(Combine)
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open func getOrderById(orderId: Int64) -> AnyPublisher<Order, Error> {
        let requestBuilder = getOrderByIdWithRequestBuilder(orderId: orderId)
        let requestTask = requestBuilder.requestTask
        return Deferred { Future<Order, Error> { promise in
            nonisolated(unsafe) let promise = promise
            requestBuilder.execute { result in
                switch result {
                case let .success(response):
                    promise(.success(response.body))
                case let .failure(error):
                    promise(.failure(error))
                }
            }
        }
        .handleEvents(receiveCancel: {
            requestTask.cancel()
        })
        .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
    #endif

    /**
     Find purchase order by ID
     
     - parameter orderId: (path) ID of pet that needs to be fetched 
     - returns: Order
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open func getOrderById(orderId: Int64) async throws(ErrorResponse) -> Order {
        return try await getOrderByIdWithRequestBuilder(orderId: orderId).execute().body
    }

    /**
     Find purchase order by ID
     
     - parameter orderId: (path) ID of pet that needs to be fetched 
     - parameter completion: completion handler to receive the result
     */
    @discardableResult
    open func getOrderById(orderId: Int64, completion: @Sendable @escaping (_ result: Swift.Result<Order, ErrorResponse>) -> Void) -> RequestTask {
        return getOrderByIdWithRequestBuilder(orderId: orderId).execute { result in
            switch result {
            case let .success(response):
                completion(.success(response.body))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    /**
     Find purchase order by ID
     - GET /store/order/{order_id}
     - For valid response try integer IDs with value <= 5 or > 10. Other values will generate exceptions
     - parameter orderId: (path) ID of pet that needs to be fetched 
     
     - returns: RequestBuilder<Order> 
     */
    open func getOrderByIdWithRequestBuilder(orderId: Int64) -> RequestBuilder<Order> {
        var localVariablePath = "/store/order/{order_id}"
        let orderIdPreEscape = "\(APIHelper.mapValueToPathItem(orderId))"
        let orderIdPostEscape = orderIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        localVariablePath = localVariablePath.replacingOccurrences(of: "{order_id}", with: orderIdPostEscape, options: .literal, range: nil)
        let localVariableURLString = openAPIClient.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<Order>.Type = openAPIClient.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: false, openAPIClient: openAPIClient)
    }

    /**
     Place an order for a pet
     
     - parameter body: (body) order placed for purchasing the pet 
     - returns: Promise<Order>
     */
    open func placeOrder(body: Order) -> Promise<Order> {
        let deferred = Promise<Order>.pending()
        placeOrderWithRequestBuilder(body: body).execute { result in
            switch result {
            case let .success(response):
                deferred.resolver.fulfill(response.body)
            case let .failure(error):
                deferred.resolver.reject(error)
            }
        }
        return deferred.promise
    }

    /**
     Place an order for a pet
     
     - parameter body: (body) order placed for purchasing the pet 
     - returns: Observable<Order>
     */
    open func placeOrder(body: Order) -> Observable<Order> {
        return Observable.create { observer -> Disposable in
            let requestTask = self.placeOrderWithRequestBuilder(body: body).execute { result in
                switch result {
                case let .success(response):
                    observer.onNext(response.body)
                case let .failure(error):
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            
            return Disposables.create {
                requestTask.cancel()
            }
        }
    }

    /**
     Place an order for a pet
     
     - parameter body: (body) order placed for purchasing the pet 
     - returns: AnyPublisher<Order, Error>
     */
    #if canImport(Combine)
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open func placeOrder(body: Order) -> AnyPublisher<Order, Error> {
        let requestBuilder = placeOrderWithRequestBuilder(body: body)
        let requestTask = requestBuilder.requestTask
        return Deferred { Future<Order, Error> { promise in
            nonisolated(unsafe) let promise = promise
            requestBuilder.execute { result in
                switch result {
                case let .success(response):
                    promise(.success(response.body))
                case let .failure(error):
                    promise(.failure(error))
                }
            }
        }
        .handleEvents(receiveCancel: {
            requestTask.cancel()
        })
        .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
    #endif

    /**
     Place an order for a pet
     
     - parameter body: (body) order placed for purchasing the pet 
     - returns: Order
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open func placeOrder(body: Order) async throws(ErrorResponse) -> Order {
        return try await placeOrderWithRequestBuilder(body: body).execute().body
    }

    /**
     Place an order for a pet
     
     - parameter body: (body) order placed for purchasing the pet 
     - parameter completion: completion handler to receive the result
     */
    @discardableResult
    open func placeOrder(body: Order, completion: @Sendable @escaping (_ result: Swift.Result<Order, ErrorResponse>) -> Void) -> RequestTask {
        return placeOrderWithRequestBuilder(body: body).execute { result in
            switch result {
            case let .success(response):
                completion(.success(response.body))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    /**
     Place an order for a pet
     - POST /store/order
     - parameter body: (body) order placed for purchasing the pet 
     
     - returns: RequestBuilder<Order> 
     */
    open func placeOrderWithRequestBuilder(body: Order) -> RequestBuilder<Order> {
        let localVariablePath = "/store/order"
        let localVariableURLString = openAPIClient.basePath + localVariablePath
        let localVariableParameters = JSONEncodingHelper.encodingParameters(forEncodableObject: body, codableHelper: openAPIClient.codableHelper)

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<Order>.Type = openAPIClient.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "POST", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: false, openAPIClient: openAPIClient)
    }
}

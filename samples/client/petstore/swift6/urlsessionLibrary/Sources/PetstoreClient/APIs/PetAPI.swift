//
// PetAPI.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

extension PetstoreClientAPI {


open class PetAPI {

    /**
     Add a new pet to the store
     
     - parameter body: (body) Pet object that needs to be added to the store 
     - parameter openAPIClient: The OpenAPIClient that contains the configuration for the http request.
     - parameter completion: completion handler to receive the data and the error objects
     */
    @discardableResult
    open class func addPet(body: Pet, openAPIClient: OpenAPIClient = OpenAPIClient.shared, completion: @Sendable @escaping (_ data: Void?, _ error: Error?) -> Void) -> RequestTask {
        return addPetWithRequestBuilder(body: body, openAPIClient: openAPIClient).execute { result in
            switch result {
            case .success:
                completion((), nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     Add a new pet to the store
     - POST /pet
     - OAuth:
       - type: oauth2
       - name: petstore_auth
     - API Key:
       - type: apiKey api_key_query (QUERY)
       - name: api_key_query
     - parameter body: (body) Pet object that needs to be added to the store 
     
     - parameter openAPIClient: The OpenAPIClient that contains the configuration for the http request.
     - returns: RequestBuilder<Void> 
     */
    open class func addPetWithRequestBuilder(body: Pet, openAPIClient: OpenAPIClient = OpenAPIClient.shared) -> RequestBuilder<Void> {
        let localVariablePath = "/pet"
        let localVariableURLString = openAPIClient.basePath + localVariablePath
        let localVariableParameters = JSONEncodingHelper.encodingParameters(forEncodableObject: body, codableHelper: openAPIClient.codableHelper)

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            "Content-Type": "application/json",
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<Void>.Type = openAPIClient.requestBuilderFactory.getNonDecodableBuilder()

        return localVariableRequestBuilder.init(method: "POST", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true, openAPIClient: openAPIClient)
    }

    /**
     Deletes a pet
     
     - parameter petId: (path) Pet id to delete 
     - parameter apiKey: (header)  (optional)
     - parameter openAPIClient: The OpenAPIClient that contains the configuration for the http request.
     - parameter completion: completion handler to receive the data and the error objects
     */
    @discardableResult
    open class func deletePet(petId: Int64, apiKey: String? = nil, openAPIClient: OpenAPIClient = OpenAPIClient.shared, completion: @Sendable @escaping (_ data: Void?, _ error: Error?) -> Void) -> RequestTask {
        return deletePetWithRequestBuilder(petId: petId, apiKey: apiKey, openAPIClient: openAPIClient).execute { result in
            switch result {
            case .success:
                completion((), nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     Deletes a pet
     - DELETE /pet/{petId}
     - OAuth:
       - type: oauth2
       - name: petstore_auth
     - parameter petId: (path) Pet id to delete 
          - parameter apiKey: (header)  (optional)
     
     - parameter openAPIClient: The OpenAPIClient that contains the configuration for the http request.
     - returns: RequestBuilder<Void> 
     */
    open class func deletePetWithRequestBuilder(petId: Int64, apiKey: String? = nil, openAPIClient: OpenAPIClient = OpenAPIClient.shared) -> RequestBuilder<Void> {
        var localVariablePath = "/pet/{petId}"
        let petIdPreEscape = "\(APIHelper.mapValueToPathItem(petId))"
        let petIdPostEscape = petIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        localVariablePath = localVariablePath.replacingOccurrences(of: "{petId}", with: petIdPostEscape, options: .literal, range: nil)
        let localVariableURLString = openAPIClient.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            "api_key": apiKey?.encodeToJSON(codableHelper: openAPIClient.codableHelper),
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<Void>.Type = openAPIClient.requestBuilderFactory.getNonDecodableBuilder()

        return localVariableRequestBuilder.init(method: "DELETE", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true, openAPIClient: openAPIClient)
    }

    /**
     * enum for parameter status
     */
    public enum Status_findPetsByStatus: String, CaseIterable {
        case available = "available"
        case pending = "pending"
        case sold = "sold"
    }

    /**
     Finds Pets by status
     
     - parameter status: (query) Status values that need to be considered for filter 
     - parameter openAPIClient: The OpenAPIClient that contains the configuration for the http request.
     - parameter completion: completion handler to receive the data and the error objects
     */
    @discardableResult
    open class func findPetsByStatus(status: [Status_findPetsByStatus], openAPIClient: OpenAPIClient = OpenAPIClient.shared, completion: @Sendable @escaping (_ data: [Pet]?, _ error: Error?) -> Void) -> RequestTask {
        return findPetsByStatusWithRequestBuilder(status: status, openAPIClient: openAPIClient).execute { result in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     Finds Pets by status
     - GET /pet/findByStatus
     - Multiple status values can be provided with comma separated strings
     - OAuth:
       - type: oauth2
       - name: petstore_auth
     - parameter status: (query) Status values that need to be considered for filter 
     
     - parameter openAPIClient: The OpenAPIClient that contains the configuration for the http request.
     - returns: RequestBuilder<[Pet]> 
     */
    open class func findPetsByStatusWithRequestBuilder(status: [Status_findPetsByStatus], openAPIClient: OpenAPIClient = OpenAPIClient.shared) -> RequestBuilder<[Pet]> {
        let localVariablePath = "/pet/findByStatus"
        let localVariableURLString = openAPIClient.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        var localVariableUrlComponents = URLComponents(string: localVariableURLString)
        localVariableUrlComponents?.queryItems = APIHelper.mapValuesToQueryItems([
            "status": (wrappedValue: status.encodeToJSON(codableHelper: openAPIClient.codableHelper), isExplode: false),
        ])

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<[Pet]>.Type = openAPIClient.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true, openAPIClient: openAPIClient)
    }

    /**
     Finds Pets by tags
     
     - parameter tags: (query) Tags to filter by 
     - parameter openAPIClient: The OpenAPIClient that contains the configuration for the http request.
     - parameter completion: completion handler to receive the data and the error objects
     */
    @available(*, deprecated, message: "This operation is deprecated.")
    @discardableResult
    open class func findPetsByTags(tags: [String], openAPIClient: OpenAPIClient = OpenAPIClient.shared, completion: @Sendable @escaping (_ data: [Pet]?, _ error: Error?) -> Void) -> RequestTask {
        return findPetsByTagsWithRequestBuilder(tags: tags, openAPIClient: openAPIClient).execute { result in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     Finds Pets by tags
     - GET /pet/findByTags
     - Multiple tags can be provided with comma separated strings. Use tag1, tag2, tag3 for testing.
     - OAuth:
       - type: oauth2
       - name: petstore_auth
     - parameter tags: (query) Tags to filter by 
     
     - parameter openAPIClient: The OpenAPIClient that contains the configuration for the http request.
     - returns: RequestBuilder<[Pet]> 
     */
    @available(*, deprecated, message: "This operation is deprecated.")
    open class func findPetsByTagsWithRequestBuilder(tags: [String], openAPIClient: OpenAPIClient = OpenAPIClient.shared) -> RequestBuilder<[Pet]> {
        let localVariablePath = "/pet/findByTags"
        let localVariableURLString = openAPIClient.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        var localVariableUrlComponents = URLComponents(string: localVariableURLString)
        localVariableUrlComponents?.queryItems = APIHelper.mapValuesToQueryItems([
            "tags": (wrappedValue: tags.encodeToJSON(codableHelper: openAPIClient.codableHelper), isExplode: false),
        ])

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<[Pet]>.Type = openAPIClient.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true, openAPIClient: openAPIClient)
    }

    /**
     Find pet by ID
     
     - parameter petId: (path) ID of pet to return 
     - parameter openAPIClient: The OpenAPIClient that contains the configuration for the http request.
     - parameter completion: completion handler to receive the data and the error objects
     */
    @discardableResult
    open class func getPetById(petId: Int64, openAPIClient: OpenAPIClient = OpenAPIClient.shared, completion: @Sendable @escaping (_ data: Pet?, _ error: Error?) -> Void) -> RequestTask {
        return getPetByIdWithRequestBuilder(petId: petId, openAPIClient: openAPIClient).execute { result in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     Find pet by ID
     - GET /pet/{petId}
     - Returns a single pet
     - API Key:
       - type: apiKey api_key (HEADER)
       - name: api_key
     - parameter petId: (path) ID of pet to return 
     
     - parameter openAPIClient: The OpenAPIClient that contains the configuration for the http request.
     - returns: RequestBuilder<Pet> 
     */
    open class func getPetByIdWithRequestBuilder(petId: Int64, openAPIClient: OpenAPIClient = OpenAPIClient.shared) -> RequestBuilder<Pet> {
        var localVariablePath = "/pet/{petId}"
        let petIdPreEscape = "\(APIHelper.mapValueToPathItem(petId))"
        let petIdPostEscape = petIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        localVariablePath = localVariablePath.replacingOccurrences(of: "{petId}", with: petIdPostEscape, options: .literal, range: nil)
        let localVariableURLString = openAPIClient.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<Pet>.Type = openAPIClient.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true, openAPIClient: openAPIClient)
    }

    /**
     Update an existing pet
     
     - parameter body: (body) Pet object that needs to be added to the store 
     - parameter openAPIClient: The OpenAPIClient that contains the configuration for the http request.
     - parameter completion: completion handler to receive the data and the error objects
     */
    @discardableResult
    open class func updatePet(body: Pet, openAPIClient: OpenAPIClient = OpenAPIClient.shared, completion: @Sendable @escaping (_ data: Void?, _ error: Error?) -> Void) -> RequestTask {
        return updatePetWithRequestBuilder(body: body, openAPIClient: openAPIClient).execute { result in
            switch result {
            case .success:
                completion((), nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     Update an existing pet
     - PUT /pet
     - OAuth:
       - type: oauth2
       - name: petstore_auth
     - parameter body: (body) Pet object that needs to be added to the store 
     
     - parameter openAPIClient: The OpenAPIClient that contains the configuration for the http request.
     - returns: RequestBuilder<Void> 
     */
    open class func updatePetWithRequestBuilder(body: Pet, openAPIClient: OpenAPIClient = OpenAPIClient.shared) -> RequestBuilder<Void> {
        let localVariablePath = "/pet"
        let localVariableURLString = openAPIClient.basePath + localVariablePath
        let localVariableParameters = JSONEncodingHelper.encodingParameters(forEncodableObject: body, codableHelper: openAPIClient.codableHelper)

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            "Content-Type": "application/json",
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<Void>.Type = openAPIClient.requestBuilderFactory.getNonDecodableBuilder()

        return localVariableRequestBuilder.init(method: "PUT", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true, openAPIClient: openAPIClient)
    }

    /**
     Updates a pet in the store with form data
     
     - parameter petId: (path) ID of pet that needs to be updated 
     - parameter name: (form) Updated name of the pet (optional)
     - parameter status: (form) Updated status of the pet (optional)
     - parameter openAPIClient: The OpenAPIClient that contains the configuration for the http request.
     - parameter completion: completion handler to receive the data and the error objects
     */
    @discardableResult
    open class func updatePetWithForm(petId: Int64, name: String? = nil, status: String? = nil, openAPIClient: OpenAPIClient = OpenAPIClient.shared, completion: @Sendable @escaping (_ data: Void?, _ error: Error?) -> Void) -> RequestTask {
        return updatePetWithFormWithRequestBuilder(petId: petId, name: name, status: status, openAPIClient: openAPIClient).execute { result in
            switch result {
            case .success:
                completion((), nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     Updates a pet in the store with form data
     - POST /pet/{petId}
     - OAuth:
       - type: oauth2
       - name: petstore_auth
     - parameter petId: (path) ID of pet that needs to be updated 
          - parameter name: (form) Updated name of the pet (optional)
          - parameter status: (form) Updated status of the pet (optional)
     
     - parameter openAPIClient: The OpenAPIClient that contains the configuration for the http request.
     - returns: RequestBuilder<Void> 
     */
    open class func updatePetWithFormWithRequestBuilder(petId: Int64, name: String? = nil, status: String? = nil, openAPIClient: OpenAPIClient = OpenAPIClient.shared) -> RequestBuilder<Void> {
        var localVariablePath = "/pet/{petId}"
        let petIdPreEscape = "\(APIHelper.mapValueToPathItem(petId))"
        let petIdPostEscape = petIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        localVariablePath = localVariablePath.replacingOccurrences(of: "{petId}", with: petIdPostEscape, options: .literal, range: nil)
        let localVariableURLString = openAPIClient.basePath + localVariablePath
        let localVariableFormParams: [String: Any?] = [
            "name": name?.encodeToJSON(codableHelper: openAPIClient.codableHelper),
            "status": status?.encodeToJSON(codableHelper: openAPIClient.codableHelper),
        ]

        let localVariableNonNullParameters = APIHelper.rejectNil(localVariableFormParams)
        let localVariableParameters = APIHelper.convertBoolToString(localVariableNonNullParameters)

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            "Content-Type": "application/x-www-form-urlencoded",
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<Void>.Type = openAPIClient.requestBuilderFactory.getNonDecodableBuilder()

        return localVariableRequestBuilder.init(method: "POST", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true, openAPIClient: openAPIClient)
    }

    /**
     uploads an image
     
     - parameter petId: (path) ID of pet to update 
     - parameter additionalMetadata: (form) Additional data to pass to server (optional)
     - parameter file: (form) file to upload (optional)
     - parameter openAPIClient: The OpenAPIClient that contains the configuration for the http request.
     - parameter completion: completion handler to receive the data and the error objects
     */
    @discardableResult
    open class func uploadFile(petId: Int64, additionalMetadata: String? = nil, file: URL? = nil, openAPIClient: OpenAPIClient = OpenAPIClient.shared, completion: @Sendable @escaping (_ data: ApiResponse?, _ error: Error?) -> Void) -> RequestTask {
        return uploadFileWithRequestBuilder(petId: petId, additionalMetadata: additionalMetadata, file: file, openAPIClient: openAPIClient).execute { result in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     uploads an image
     - POST /pet/{petId}/uploadImage
     - OAuth:
       - type: oauth2
       - name: petstore_auth
     - parameter petId: (path) ID of pet to update 
          - parameter additionalMetadata: (form) Additional data to pass to server (optional)
          - parameter file: (form) file to upload (optional)
     
     - parameter openAPIClient: The OpenAPIClient that contains the configuration for the http request.
     - returns: RequestBuilder<ApiResponse> 
     */
    open class func uploadFileWithRequestBuilder(petId: Int64, additionalMetadata: String? = nil, file: URL? = nil, openAPIClient: OpenAPIClient = OpenAPIClient.shared) -> RequestBuilder<ApiResponse> {
        var localVariablePath = "/pet/{petId}/uploadImage"
        let petIdPreEscape = "\(APIHelper.mapValueToPathItem(petId))"
        let petIdPostEscape = petIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        localVariablePath = localVariablePath.replacingOccurrences(of: "{petId}", with: petIdPostEscape, options: .literal, range: nil)
        let localVariableURLString = openAPIClient.basePath + localVariablePath
        let localVariableFormParams: [String: Any?] = [
            "additionalMetadata": additionalMetadata?.encodeToJSON(codableHelper: openAPIClient.codableHelper),
            "file": file?.encodeToJSON(codableHelper: openAPIClient.codableHelper),
        ]

        let localVariableNonNullParameters = APIHelper.rejectNil(localVariableFormParams)
        let localVariableParameters = APIHelper.convertBoolToString(localVariableNonNullParameters)

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            "Content-Type": "multipart/form-data",
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<ApiResponse>.Type = openAPIClient.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "POST", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true, openAPIClient: openAPIClient)
    }

    /**
     uploads an image (required)
     
     - parameter petId: (path) ID of pet to update 
     - parameter requiredFile: (form) file to upload 
     - parameter additionalMetadata: (form) Additional data to pass to server (optional)
     - parameter openAPIClient: The OpenAPIClient that contains the configuration for the http request.
     - parameter completion: completion handler to receive the data and the error objects
     */
    @discardableResult
    open class func uploadFileWithRequiredFile(petId: Int64, requiredFile: URL, additionalMetadata: String? = nil, openAPIClient: OpenAPIClient = OpenAPIClient.shared, completion: @Sendable @escaping (_ data: ApiResponse?, _ error: Error?) -> Void) -> RequestTask {
        return uploadFileWithRequiredFileWithRequestBuilder(petId: petId, requiredFile: requiredFile, additionalMetadata: additionalMetadata, openAPIClient: openAPIClient).execute { result in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     uploads an image (required)
     - POST /fake/{petId}/uploadImageWithRequiredFile
     - OAuth:
       - type: oauth2
       - name: petstore_auth
     - parameter petId: (path) ID of pet to update 
          - parameter requiredFile: (form) file to upload 
          - parameter additionalMetadata: (form) Additional data to pass to server (optional)
     
     - parameter openAPIClient: The OpenAPIClient that contains the configuration for the http request.
     - returns: RequestBuilder<ApiResponse> 
     */
    open class func uploadFileWithRequiredFileWithRequestBuilder(petId: Int64, requiredFile: URL, additionalMetadata: String? = nil, openAPIClient: OpenAPIClient = OpenAPIClient.shared) -> RequestBuilder<ApiResponse> {
        var localVariablePath = "/fake/{petId}/uploadImageWithRequiredFile"
        let petIdPreEscape = "\(APIHelper.mapValueToPathItem(petId))"
        let petIdPostEscape = petIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        localVariablePath = localVariablePath.replacingOccurrences(of: "{petId}", with: petIdPostEscape, options: .literal, range: nil)
        let localVariableURLString = openAPIClient.basePath + localVariablePath
        let localVariableFormParams: [String: Any?] = [
            "additionalMetadata": additionalMetadata?.encodeToJSON(codableHelper: openAPIClient.codableHelper),
            "requiredFile": requiredFile.encodeToJSON(codableHelper: openAPIClient.codableHelper),
        ]

        let localVariableNonNullParameters = APIHelper.rejectNil(localVariableFormParams)
        let localVariableParameters = APIHelper.convertBoolToString(localVariableNonNullParameters)

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            "Content-Type": "multipart/form-data",
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<ApiResponse>.Type = openAPIClient.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "POST", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true, openAPIClient: openAPIClient)
    }
}
}

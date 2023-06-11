//
//  File.swift
//  
//
//  Created by cw-ryu.nakayama on 2023/06/11.
//

import Foundation

struct IncomingRequestsRepository {
    private let endpointString = "https://api.chatwork.com/v2/incoming_requests"
    
    func get(token: APIToken) async throws -> IncomingRequestsGetResponse? {
        let url = URL(string: endpointString)!
        var request = URLRequest(url: url)
        
        request.httpMethod = HTTPMethod.get.rawValue
        
        // 検討: 他Repositoryでも共通な気がするから切り出し候補
        let headers = [
          "accept": "application/json",
          "x-chatworktoken": token.value
        ]
        request.allHTTPHeaderFields = headers
        
        // リクエスト
        let (data, response) = try await URLSession.shared.data(for: request)
        
        let responseStatusCode = (response as! HTTPURLResponse).statusCode
        
        // 200と204以外は早期リターン
        if responseStatusCode != 200 && responseStatusCode != 204 {
            throw APIError.statusCodeIsNot200(statusCode: responseStatusCode)
        }
        
        // デコードする
        do {
            if responseStatusCode == 200 {
                let decodeResult = try JSONDecoder().decode([IncomingRequest].self, from: data)
                return IncomingRequestsGetResponse(body: decodeResult)
            }
            
            return nil
            
        } catch {
            throw APIError.failedToDecodeModel
        }
    }
}

// PUTとDELETE
extension IncomingRequestsRepository {
    func put(token: APIToken, requestId: Int) async throws -> IncomingRequestPutResponse {
        let url = URL(string: endpointString + "\(requestId)")!
        var request = URLRequest(url: url)
        
        request.httpMethod = HTTPMethod.put.rawValue
        
        // 検討: 他Repositoryでも共通な気がするから切り出し候補
        let headers = [
          "accept": "application/json",
          "x-chatworktoken": token.value
        ]
        request.allHTTPHeaderFields = headers
        
        // リクエスト
        let (data, response) = try await URLSession.shared.data(for: request)
        
        let responseStatusCode = (response as! HTTPURLResponse).statusCode
        
        // 200以外は早期リターン
        if responseStatusCode != 200 {
            throw APIError.statusCodeIsNot200(statusCode: responseStatusCode)
        }
        
        // デコードする
        do {
            let decodeResult = try JSONDecoder().decode(IncomingRequestPutResponse.self, from: data)
            return decodeResult
            
        } catch {
            throw APIError.failedToDecodeModel
        }
    }
    
    func delete(token: APIToken, requestId: Int) async throws {
        let url = URL(string: endpointString + "\(requestId)")!
        var request = URLRequest(url: url)
        
        request.httpMethod = HTTPMethod.delete.rawValue
        
        // 検討: 他Repositoryでも共通な気がするから切り出し候補
        let headers = [
          "accept": "application/json",
          "x-chatworktoken": token.value
        ]
        request.allHTTPHeaderFields = headers
        
        // リクエスト
        let (data, response) = try await URLSession.shared.data(for: request)
        
        let responseStatusCode = (response as! HTTPURLResponse).statusCode
        
        // 200以外は早期リターン
        if responseStatusCode != 204 {
            throw APIError.statusCodeIsNot200(statusCode: responseStatusCode)
        }
    }
}

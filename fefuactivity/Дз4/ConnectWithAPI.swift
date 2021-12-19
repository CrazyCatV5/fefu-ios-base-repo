//
//  ConnectWithAPI.swift
//  fefuactivity
//
//  Created by wsr5 on 19.12.2021.
//
import Foundation

struct UserRegBody: Encodable {
    let login: String
    let password: String
    let name: String
    let gender: Int
}

struct UserLoginBody: Encodable {
    let login: String
    let password: String
}

struct ApiError: Decodable {
    let errors: Dictionary<String, [String]>
}

struct LoginErrors: Decodable {
    let login: [String]
}

struct Gender: Decodable {
    let code: Int
    let name: String
}

struct UserModel: Decodable, Identifiable {
    let id: Int
    let name: String
    let login: String
    let gender: Gender
}

struct AuthUserModel: Decodable {
    let token: String
    let user: UserModel
}

class AuthService {
    static private let registerEndpoint: String = "https://fefu.t.feip.co/api/auth/register"
    static private let loginEndpoint: String = "https://fefu.t.feip.co/api/auth/login"
    
    static let decoder = JSONDecoder()
    static let encoder = JSONEncoder()
    
    init() {
        AuthService.decoder.keyDecodingStrategy = .convertFromSnakeCase
        AuthService.encoder.keyEncodingStrategy = .convertToSnakeCase
    }
    
    static func register(_ body: Data,
                         completion: @escaping ((AuthUserModel) -> Void),
                         onError :@escaping((ApiError) -> Void)) {
        
        guard let url = URL(string: registerEndpoint) else {
            print("Invalid URL")
            return
        }
        
        var urlReq = URLRequest(url: url)
        urlReq.httpMethod = "POST"
        urlReq.httpBody = body
        urlReq.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlReq.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlReq) { data, response, error in
            
            guard let data = data else {
                return
            }
            
            if let res = response as? HTTPURLResponse {
                switch res.statusCode {
                case 422:
                    do {
                        let errData = try AuthService.decoder.decode(ApiError.self, from: data)
                        onError(errData)
                        return
                    } catch let e {
                        print("Decode error: \(e)")
                    }
                case 201:
                    do {
                        let userData = try AuthService.decoder.decode(AuthUserModel.self, from: data)
                        completion(userData)
                        return
                    } catch let e {
                        print("Decode error: \(e)")
                    }
                default:
                    return
                }
            }
        }
        task.resume()
    }
    
    static func login(_ body: Data,
                      completion: @escaping ((AuthUserModel) -> Void),
                      onError :@escaping((ApiError) -> Void)) {
        guard let url = URL(string: loginEndpoint) else {
            print("Invalid URL")
            return
        }
        
        var urlReq = URLRequest(url: url)
        urlReq.httpMethod = "POST"
        urlReq.httpBody = body
        urlReq.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlReq.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlReq) { data, response, error in
            
            guard let data = data else {
                return
            }
            
            if let res = response as? HTTPURLResponse {
                switch res.statusCode {
                case 422:
                    do {
                        let errData = try AuthService.decoder.decode(ApiError.self, from: data)
                        onError(errData)
                        return
                    } catch let e {
                        print("Decode error: \(e)")
                    }
                case 200:
                    do {
                        let userData = try AuthService.decoder.decode(AuthUserModel.self, from: data)
                        completion(userData)
                        return
                    } catch let e {
                        print("Decode error: \(e)")
                    }
                default:
                    return
                }
            }
        }
        task.resume()
    }
}

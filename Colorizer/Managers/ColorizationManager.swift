//
//  ColorizationManager.swift
//  Colorizer
//
//  Created by Artyom Gurbovich on 15.11.21.
//

import UIKit
import SwiftyJSON

final class ColorizationManager {
    
    static let shared = ColorizationManager()
    private let url = URL(string: "https://api.deepai.org/api/colorizer")!
    private let apiKey = ""  // https://deepai.org/machine-learning-model/colorizer
    
    private init() { }
    
    func create(from image: UIImage, completion: @escaping (String?) -> ()) {
        let boundary = UUID().uuidString
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue(apiKey, forHTTPHeaderField: "api-key")
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        var data = Data()
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append(image.jpegData(compressionQuality: 1.0)!)
        data.append("\r\n--\(boundary)--".data(using: .utf8)!)
        URLSession.shared.uploadTask(with: urlRequest, from: data) { data, _, _ in
            guard let data = data, let json = try? JSON(data: data) else {
                completion(nil)
                return
            }
            completion(json["output_url"].string)
        }.resume()
    }
    
    func create(from link: String, completion: @escaping (String?) -> ()) {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue(apiKey, forHTTPHeaderField: "api-key")
        urlRequest.httpBody = "image=\(link)".data(using: .utf8)!
        URLSession.shared.dataTask(with: urlRequest) { data, _, _ in
            guard let data = data, let json = try? JSON(data: data) else {
                completion(nil)
                return
            }
            completion(json["output_url"].string)
        }.resume()
    }
}

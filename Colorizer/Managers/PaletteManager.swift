//
//  PaletteManager.swift
//  Colorizer
//
//  Created by Artyom Gurbovich on 15.11.21.
//

import UIKit
import SwiftyJSON

final class PaletteManager {
    
    static let shared = PaletteManager()
    private let url = "https://api.imagga.com/v2/colors"
    private let authorization = ""  // https://imagga.com/solutions/color-api
    
    private init() { }
    
    func create(from link: String, completion: @escaping ([UIColor]?) -> ()) {
        var urlRequest = URLRequest(url: URL(string: url + "?image_url=" + link)!)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue(authorization, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: urlRequest) { data, _, _ in
            guard let data = data, let json = try? JSON(data: data) else {
                completion(nil)
                return
            }
            var colors = [UIColor]()
            if let backgroundColors = json["result"]["colors"]["background_colors"].array {
                for backgroundColor in backgroundColors {
                    guard let htmlCode = backgroundColor["html_code"].string else { continue }
                    colors.append(UIColor(from: htmlCode))
                }
            }
            if let foregroundColors = json["result"]["colors"]["foreground_colors"].array {
                for foregroundColor in foregroundColors {
                    guard let htmlCode = foregroundColor["html_code"].string else { continue }
                    colors.append(UIColor(from: htmlCode))
                }
            }
            completion(colors)
        }.resume()
    }
}

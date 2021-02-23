//
//  Copyright © 2021 Redbubble. All rights reserved.
//

import Foundation

class DataFetcher {
    static let shared = DataFetcher()
    private let session = URLSession(configuration: .default)

    fileprivate init() {}

    typealias DataDownloaderCompletionHandler = (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> ()

    func getDataFromUrl(url: String, completion: @escaping DataDownloaderCompletionHandler) {

        guard let imageUrl = URL(string: url) else { return }

        URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
            DispatchQueue.main.async {
                completion(data, response, error)
            }
        }.resume()
    }
}

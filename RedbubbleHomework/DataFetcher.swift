//
//  DataFetcher.swift
//  RedbubbleHomework
//
//  Created by Zoe Wen on 16/2/21.
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

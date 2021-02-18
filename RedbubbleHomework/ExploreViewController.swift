//
//  ViewController.swift
//  RedbubbleHomework
//
//  Created by Zoe Wen on 15/2/21.
//

import UIKit

struct HomeModel {
    let type: String
    let id: String
    let title: String
    let safeForWork: Bool
    let thumbnailUrl: String
    let amount: Double?
    let currency: String?
    let artist: String?
}

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var grid: [HomeModel] = []

    @IBOutlet var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        fetchData()

    }

    func fetchData() {
        DataFetcher.shared.getDataFromUrl(url: "https://take-home-test.herokuapp.com/api/v1/works.json") { (data, _, error) in
            if let data = data {
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                          let home = json["home"] as? [[String: Any]] else { return }

                    let response: [HomeModel] = home.compactMap { item -> HomeModel? in
                        guard let type = item["type"] as? String,
                              let id = item["id"] as? String,
                              let title = item["title"] as? String,
                              let safeForWork = item["safeForWork"] as? Bool,
                              let thumbnailUrl = item["thumbnailUrl"] as? String else { return nil }

                        let amount = item["amount"] as? Double
                        let currency = item["currency"] as? String
                        let artist = item["artist"] as? String

                       return HomeModel(type: type, id: id, title: title, safeForWork: safeForWork, thumbnailUrl: thumbnailUrl, amount: amount, currency: currency, artist: artist)
                    }

                    self.grid = response
                    self.collectionView.reloadData()

                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return grid.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }

}

class ExploreCollectionViewCell: UICollectionViewCell {
	
}


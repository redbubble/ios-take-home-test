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

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
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
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return }

                    if let home = json["home"] as? [[String: Any]] {
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
                    } else { return }
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "home cell", for: indexPath) as! ExploreCollectionViewCell
        cell.homeModel = grid[indexPath.row]
        cell.cfg()
        return cell
    }
}

class ExploreCollectionViewCell: UICollectionViewCell {
    @IBOutlet var image: UIImageView!
    @IBOutlet var title1: UILabel!
    @IBOutlet var title2: UILabel!

    var homeModel: HomeModel!

    override class func awakeFromNib() {
    }

    func cfg() {
        guard let imageUrl = URL(string: self.homeModel.thumbnailUrl) else { return }

        URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
            DispatchQueue.main.async {

                if let data = data {
                    self.image.image = UIImage(data: data)
                }
            }
        }.resume()

        title1.text = homeModel.title

        if homeModel.type == "PRODUCT" {
            if let currency = homeModel.currency, let amount = homeModel.amount {
                let locale = NSLocale(localeIdentifier: currency)
                let symbol = locale.displayName(forKey: .currencySymbol, value: currency) ?? "$"
                let formatter = NumberFormatter()
                formatter.numberStyle = NumberFormatter.Style.currency
                formatter.currencySymbol = symbol
                let number = NSNumber(value: amount)
                title2.text = formatter.string(from: number) ?? ""
            }
        } else {
            if let artist = homeModel.artist {
                title2.text = "by \(artist)"
            }
        }

        title1.font = UIFont.systemFont(ofSize: 17.0, weight: .bold)
        title2.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
        title1.textColor = UIColor(red: 0.251, green: 0.208, blue: 0.306, alpha: 1)
        title2.textColor = UIColor(red: 0.549, green: 0.584, blue: 0.647, alpha: 1)
    }
}

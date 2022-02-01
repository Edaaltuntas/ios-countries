//
//  DetailController.swift
//  Countries
//
//  Created by Eda Altuntas on 1.02.2022.
//

import UIKit
import SDWebImage
import SDWebImageSVGKitPlugin
import SVGKit

class DetailController: UIViewController {

    @IBOutlet weak var code: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var nav: UINavigationBar!
    @IBOutlet weak var flag: UIImageView!
    var sCode : String?
    var country: DataClass?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.addTarget(self, action: #selector(go), for: .touchUpInside)
        button.semanticContentAttribute = UIApplication.shared
            .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let SVGCoder = SDImageSVGKCoder.shared
        SDImageCodersManager.shared.addCoder(SVGCoder)
        getDetail() {
            success in
                if success {
                    DispatchQueue.main.async {
                        self.flag.sd_setImage(with: URL(string: self.country!.flagImageURI!), placeholderImage: nil, options: [])
                        self.nav.topItem?.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: SaveController.exists(name: self.country!.name!) ? "star.fill" : "star"), style: .plain, target: self, action: #selector(self.tggle))
                        self.code.text = self.country!.code
                        self.nav.topItem?.title = self.country!.name
                    }
                }
            print("lol", success)
        }
    }
    
    @objc func tggle() {
        let button: UIBarButtonItem = self.nav.topItem!.rightBarButtonItem!
        if SaveController.exists(name: self.country!.name!) {
            if ( SaveController.rem(name: (self.country!.name!)) ){
                button.image = UIImage(systemName: "star")
            }
        }else{
            let country : Datum = Datum(code: self.country?.code, currencyCodes: self.country?.currencyCodes, name: self.country?.name, wikiDataID: self.country?.wikiDataID)
            if ( SaveController.save(country: country) ) {
                button.image = UIImage(systemName: "star.fill")
            }
        }
    }
    
    func getDetail(completion: @escaping ((Bool)-> Void)) {
        let headers = [
            "x-rapidapi-host": "wft-geo-db.p.rapidapi.com",
            "x-rapidapi-key": "9b4011cbfdmsh1717c634acdd085p1ce413jsn5cb4713c2f78"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://wft-geo-db.p.rapidapi.com/v1/geo/countries/" + (sCode ?? "US")!)! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let task = URLSession.shared.dataTask(with: request as URLRequest) { (Data, _, error) in
            if error != nil {
                completion(false)
            }else if let data = Data {
                do {
                    self.country = try JSONDecoder().decode(Detail.self, from: data).data
                    completion(true)
                }catch {
                    completion(false)
                }
            }
        }
        task.resume()
    }
    
    @objc func go() {
        if let url = URL(string: "https://www.wikidata.org/wiki/" + (country?.wikiDataID)!) {
            UIApplication.shared.open(url)
        }
    }
    

}

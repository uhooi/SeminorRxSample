//
//  ViewController.swift
//  SeminorRxSample
//
//  Created by がーたろ on 2019/06/29.
//  Copyright © 2019 がーたろ. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Alamofire

struct ResData: Codable {
    let result: [String]

    
}

struct Result: Codable {
    let address1: String
    let address2: String
    let address3: String
    let kana1: String
    let kana2: String
    let kana3: String
}


class ViewController: UIViewController {

    private let baseUrl: String =  "http://zipcloud.ibsnet.co.jp/api/search?zipcode="
    @IBOutlet var zipcodeTxt: UITextField!
    @IBOutlet var tableView: UITableView!
    
    private var address: [ResData]?
    private let disposeBag = DisposeBag()
    let loadFinishTrigger: PublishSubject<Void> = PublishSubject<Void>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        httpRequest()
    }
    
    
    
    
    func httpRequest() {
//    func httpRequest(zipcodeTxt: UITextField) {
//        zipcodeTxt.rx.text.subscribe({ _ in
            let url = self.baseUrl + "5600003"
            let headers: HTTPHeaders = [
                "Contenttype": "application/json"
            ]
            Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
//                if let result = response.result.value as? [String: Any] {
//                    print(result)
////                    self.loadFinishTrigger.onNext(())
//                }
                guard let data = response.data else {
                    return
                }
                let decoder = JSONDecoder()
                do {
                    let datas: [ResData] = try! decoder.decode([ResData].self, from: data)
                } catch {
                    print("error")
                }
            }
//        }).disposed(by: disposeBag)
    }


}

//extension ViewController: UITableViewDelegate,UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//    
//    
//}

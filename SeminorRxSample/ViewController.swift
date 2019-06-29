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
import ObjectMapper

class AddressModel: Mappable {
    required init?(map: Map) {
    }
    
    var resultList: [Result] = []
    func mapping(map: Map) {
        resultList <- map["resultList"]
    }
    
}


class Result: Mappable {
    required init?(map: Map) {
    }
    
    var address1: String = ""
    var address2: String = ""
    var address3: String = ""
    var kana1: String = ""
    var kana2: String = ""
    var kana3: String = ""
    
    
    
    func mapping(map: Map) {
        address1 <- map["address1"]
        address2 <- map["address2"]
        address3 <- map["address3"]
        kana1 <- map["kana1"]
        kana2 <- map["kana2"]
        kana3 <- map["kana3"]
        
    }
    
    
}




class ViewController: UIViewController {

    private let baseUrl: String =  "http://zipcloud.ibsnet.co.jp/api/search?zipcode="
    @IBOutlet var zipcodeTxt: UITextField!
    @IBOutlet var tableView: UITableView!
    
    
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

            Alamofire.request(url, method: .post, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                if let result = response.result.value as? [String: Any] {
                    print(result)
//                    self.loadFinishTrigger.onNext(())
                    let address: [AddressModel]? = Mapper<AddressModel>().mapArray(JSONObject: result)
                    print(address?[0])
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

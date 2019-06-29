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
import SwiftyJSON

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
    var textLength = BehaviorRelay<Int>(value: 0)
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        httpRequest(zipcodeTxt: zipcodeTxt)
        limitLength(textField: zipcodeTxt)
        onlyNumber(textField: zipcodeTxt)
    }
    
    func limitLength(textField: UITextField) {
        // 文字制限
        textField.rx.text.subscribe(onNext: { text in
            if let text = text, text.count >= 7 {
                textField.text = text.prefix(7).description
            }
        }).disposed(by: disposeBag)
    }
    
    func onlyNumber(textField: UITextField) {
        // 数字のみの入力制限
        textField.rx.text.subscribe(onNext: { text in
            guard let txt = textField.text else { return }
            guard let intText = Int(txt) else { textField.text = ""; return }
        }).disposed(by: disposeBag)
    }

    func httpRequest(zipcodeTxt: UITextField) {
        zipcodeTxt.rx.text.subscribe({ _ in
            let url = self.baseUrl + zipcodeTxt.text!
            if zipcodeTxt.text?.count == 7 {
                let headers: HTTPHeaders = [
                    "Contenttype": "application/json"
                ]

                Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                    if let json:JSON = JSON(response.result.value) {
                        print(json)
                        let address: [Result]? = Mapper<Result>().mapArray(JSONObject: json)
                        print(address)
                    }
                }
            }
        }).disposed(by: disposeBag)
    }
}



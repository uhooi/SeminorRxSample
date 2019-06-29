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
    var results: [Result] = []
    func mapping(map: Map) {
        results <- map["results"]
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
    @IBOutlet var resultLabel: UILabel!
    var textLength = BehaviorRelay<Int>(value: 0)
    private let disposeBag = DisposeBag()
    private var returnAddress: AddressModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    // 文字数制限を入れる

    
    // 数字以外の入力はさせない
    

    // api通信するところ

    
}



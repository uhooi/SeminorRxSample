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

struct AddressModel: Codable {
    var results: [Result]
    
    struct Result: Codable {
        var address1: String
        var address2: String
        var address3: String
        var kana1: String
        var kana2: String
        var kana3: String
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



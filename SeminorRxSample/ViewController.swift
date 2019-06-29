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
        httpRequest(zipcodeTxt: zipcodeTxt)
        limitLength(textField: zipcodeTxt)
        onlyNumber(textField: zipcodeTxt)
    }
    
    func limitLength(textField: UITextField) {
        textField.rx.text.subscribe(onNext: { text in
            if let text = text, text.count >= 7 {
                textField.text = text.prefix(7).description
            }
        }).disposed(by: disposeBag)
    }
    
    func onlyNumber(textField: UITextField) {
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
                    let decoder = JSONDecoder()
                    self.returnAddress = try! decoder.decode(AddressModel.self, from: response.data!)
                    if (self.returnAddress?.results.count)! > 0 {
                        let address1: String = self.returnAddress!.results[0].address1
                        let address2: String = self.returnAddress!.results[0].address2
                        let address3: String = self.returnAddress!.results[0].address3
                        let kana1: String = self.returnAddress!.results[0].kana1
                        let kana2: String = self.returnAddress!.results[0].kana2
                        let kana3: String = self.returnAddress!.results[0].kana3
                        self.resultLabel.text = address1 + address2 + address3 + kana1 + kana2 + kana3
                    }
                    
                }
            }
        }).disposed(by: disposeBag)
    }
}

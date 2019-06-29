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

final class ViewController: UIViewController {
    
    // MARK: Properties

    private let disposeBag = DisposeBag()
    private var addresses: AddressModel? {
        didSet {
            guard let result = addresses?.results[0] else {
                self.addressLabel.text = ""
                return
            }
            self.addressLabel.text = result.address1 + result.address2 + result.address3 + result.kana1 + result.kana2 + result.kana3
        }
    }
    
    // MARK: IBOutlets
    
    @IBOutlet private var zipcodeTextField: UITextField!
    @IBOutlet private var addressLabel: UILabel!
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        observeZipcodeTextField()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: Private Methods

    private func observeZipcodeTextField() {
        self.zipcodeTextField.rx.text
            .map { self.validateZipcode($0) }
            .filter { !$0.isEmpty }
            .subscribe (onNext: { self.requestAddress(zipcode: $0) })
            .disposed(by: disposeBag)
    }
    
    private func validateZipcode(_ zipcode: String?) -> String {
        guard let zipcode = zipcode else {
            return ""
        }
        if zipcode.count >= 7 {
            self.zipcodeTextField.text = zipcode.prefix(7).description
        }
        if Int(zipcode) == nil {
            self.zipcodeTextField.text = ""
        }
        return self.zipcodeTextField.text ?? ""
    }
    
    private func requestAddress(zipcode: String) {
        self.addresses = nil
        let baseUrl = "http://zipcloud.ibsnet.co.jp/api/"
        let searchUrl = "\(baseUrl)search"
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        let parameters: [String: Any] = ["zipcode": zipcode]
        Alamofire.request(searchUrl, method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: headers).responseJSON { response in
            guard let data = response.data else {
                return
            }
            do {
                self.addresses = try JSONDecoder().decode(AddressModel.self, from: data)
            } catch let error {
                print(error)
            }
        }
    }
    
}

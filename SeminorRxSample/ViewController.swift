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
import RxOptional
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

    private let zipCodeLength = 7
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
    
    @IBOutlet private var zipCodeTextField: UITextField!
    @IBOutlet private var addressLabel: UILabel!
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        observeZipCodeTextField()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: Private Methods

    private func observeZipCodeTextField() {
        let stream = self.zipCodeTextField.rx.text
            .takeUntil(self.rx.deallocating)
            .filterNil()
            .map { self.excludeNonInteger($0) }
            .map { self.takeZipCodeLength($0) }
            .share(replay: 1)
            
        _ = stream
            .bind(to: self.zipCodeTextField.rx.text)
            
        _ = stream
            .filter { $0.count == self.zipCodeLength }
            .subscribe(onNext: { self.getAddress(zipCode: $0) })
    }
    
    private func excludeNonInteger(_ string: String) -> String {
        return string.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
    }
    
    private func takeZipCodeLength(_ string: String) -> String {
        return string.prefix(self.zipCodeLength).description
    }
    
    private func getAddress(zipCode: String) {
        self.addresses = nil
        let baseUrl = "http://zipcloud.ibsnet.co.jp/api/"
        let searchUrl = "\(baseUrl)search"
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        let parameters: [String: Any] = ["zipcode": zipCode]
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

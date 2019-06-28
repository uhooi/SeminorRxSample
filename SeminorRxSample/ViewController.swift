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


class ViewController: UIViewController {

    private let baseUrl: String =  "http://zipcloud.ibsnet.co.jp/api/search"
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
            let url = self.baseUrl + "?zipcode=5600003"
            let headers: HTTPHeaders = [
                "Contenttype": "application/json"
            ]
//            let parameters:[String: Int] = [
//                "zipcode": 5600003
//            ]
            Alamofire.request(url, method: .post, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                if let result = response.result.value as? [String: Any] {
                    print(result)
//                    self.loadFinishTrigger.onNext(())
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

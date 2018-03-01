//
//  ViewController.swift
//  RxSwift-Searcher-Tutorial
//
//  Created by 시노 on 2018. 3. 1..
//  Copyright © 2018년 INSU BYEON. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

private let cellIdentifier = "tableCell"

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableViewDataSource = [String]()
    let staticDataSource = ["Loli", "Sound Voltex", "Sino", "sinoyo"]
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
        searchBar
            .rx.text // Observable 속성
            .orEmpty // non-optional 속성
            .debounce(0.5, scheduler: MainScheduler.instance) // 0.5 초 이내에 다른 이벤트 발생시 emit 하지 않음
            .distinctUntilChanged() // 같은 원소이면 이벤트를 방출하지 않음
            .filter( { !$0.isEmpty } ) // 비어있지 않은 데이터만...
            .subscribe(onNext: { [unowned self] query in
                self.tableViewDataSource = self.staticDataSource.filter { $0.hasPrefix(query) }
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        cell.textLabel?.text = tableViewDataSource[indexPath.row]
        
        return cell
    }


}


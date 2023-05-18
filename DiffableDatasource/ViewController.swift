//
//  ViewController.swift
//  DiffableDatasource
//
//  Created by Nazar Kopeyka on 08.05.2023.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {

    let tableView: UITableView = { /* 1 */
       let table = UITableView() /* 2 */
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell") /* 3 */
        return table /* 4 */
    }()
    
    enum Section { /* 6 */
        case first /* 7 */
    }
    
    struct Fruit: Hashable { /* 8 */
        let title: String /* 9 */
    }
    
    var dataSource: UITableViewDiffableDataSource<Section, Fruit>! /* 10 DiffableDataSource - we need to provide models that the data source can internally figure out differences for and based on a difference it can animate and update tableView automaticly */
    
    var fruits = [Fruit]() /* 20 */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self /* 5 */
        view.addSubview(tableView) /* 11 */
        tableView.frame = view.bounds /* 12 */
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, model -> UITableViewCell? in /* 13 */
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) /* 14 */
            cell.textLabel?.text = model.title /* 16 */
            return cell /* 15 */
            
        })
        
        title = "My Fruits" /* 17 */
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(didTapAdd)) /* 18 */
    }
    
    @objc func didTapAdd() { /* 19 */
        let actionSheet = UIAlertController(title: "Select Fruit", message: nil, preferredStyle: .actionSheet) /* 20 */
        
        for x in 0...100 { /* 22 */
            actionSheet.addAction(UIAlertAction(title: "Fruit \(x+1)", style: .default, handler: { [weak self] _ in  /* 23 */
                let fruit = Fruit(title: "Fruit \(x+1)") /* 25 */
                self?.fruits.append(fruit) /* 26 */
                self?.updateDatasource() /* 27 */
        }))
    }
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil)) /* 24 */
        
        present(actionSheet, animated: true) /* 21 */
    }

    func updateDatasource() { /* 28 */
        var snapshot = NSDiffableDataSourceSnapshot<Section, Fruit>() /* 29 */
        snapshot.appendSections([.first]) /* 30 */
        snapshot.appendItems(fruits) /* 31 */
        
        dataSource.apply(snapshot, animatingDifferences: true, completion: nil) /* 32 */
    }
}


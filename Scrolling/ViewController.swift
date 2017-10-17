//
//  ViewController.swift
//  Scrolling
//
//  Created by Alexander Zubkov on 16.10.17.
//  Copyright © 2017 Alexander Zubkov. All rights reserved.
//

import UIKit

struct Element {
  var id: Int?
  var title: String?
  var bedrooms: Int?
  var price: String?
}

class ViewController: UIViewController {
  
  @IBOutlet weak var pdButton: UIButton!
  @IBOutlet weak var paButton: UIButton!
  @IBOutlet weak var bdButton: UIButton!
  @IBOutlet weak var baButton: UIButton!
  @IBOutlet weak var table: UITableView!
  
  var total: Int = 0
  var page: Int = 0
  var array: [Element] = []
  var sorting: Sorting = .pd {
    didSet {
      array.removeAll()
      page = 0
      table.reloadData()
      pdButton.setTitleColor(UIColor.lightGray, for: .normal)
      paButton.setTitleColor(UIColor.lightGray, for: .normal)
      bdButton.setTitleColor(UIColor.lightGray, for: .normal)
      baButton.setTitleColor(UIColor.lightGray, for: .normal)
      switch sorting {
      case .pd:
        pdButton.setTitleColor(UIColor.black, for: .normal)
      case .pa:
        paButton.setTitleColor(UIColor.black, for: .normal)
      case .bd:
        bdButton.setTitleColor(UIColor.black, for: .normal)
      case .ba:
        baButton.setTitleColor(UIColor.black, for: .normal)
      }
    }
  }
  
  enum Sorting: String {
    case pd
    case pa
    case bd
    case ba
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    table.tableFooterView = UIView()
    sorting = .pd
    getData()
  }

  func getData() {
    if array.count == total && total != 0 {
      return
    }
    let urlString = "https://www.propertyfinder.ae/mobileapi?page=\(page)&order=\(sorting.rawValue)"
    guard let url = URL(string: urlString) else {
      print("url conversion issue")
      return
    }
    URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
      if let data = data, error == nil {
        do {
          let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:AnyObject]
          self.prepare(json, completion: {
            DispatchQueue.main.async {
              self.table.reloadData()
            }
          })
        } catch {
          print(error)
          // Something went wrong
        }
      } else if let error = error {
        print(error)
      }
    }).resume()
  }
  
  func prepare(_ dict: [String:AnyObject], completion: @escaping () -> ()) {
    if let value = dict["total"] as? Int {
      total = value
    }
    if let res = dict["res"] as? [[String:AnyObject]] {
      for resourse in res {
        var element = Element()
        if let value = resourse["id"] as? Int {
          element.id = value
        }
        if let string = resourse["title"] as? String {
          element.title = string
        }
        if let string = resourse["price"] as? String {
          element.price = string
        }
        if let value = resourse["bedrooms"] as? Int {
          element.bedrooms = value
        }
        array.append(element)
      }
    }
    if array.count < total {
      page += 1
    }
    completion()
  }
  
  @IBAction func action(_ sender: UIButton) {
    if sender.tag == 0 {
      if sorting == .pd {return}
      sorting = .pd
    } else if sender.tag == 1 {
      if sorting == .pa {return}
      sorting = .pa
    } else if sender.tag == 2 {
      if sorting == .bd {return}
      sorting = .bd
    } else {
      if sorting == .ba {return}
      sorting = .ba
    }
    getData()
  }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return (array.count == total && total != 0) ? array.count : (array.count + 1)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row != array.count {
      return UITableViewAutomaticDimension
    } else {
      return 50
    }
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row != array.count {
      return 70
    } else {
      return 50
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row != array.count {
      let cell = tableView.dequeueReusableCell(withIdentifier: "ElementCell", for: indexPath) as! ElementCell
      let element = array[indexPath.row]
      cell.load(element)
      return cell
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath) as! ActivityCell
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.row == array.count - 5 {
      getData()
    }
  }
}


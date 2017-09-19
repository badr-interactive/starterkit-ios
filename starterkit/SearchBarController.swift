//
//  SearchBarController.swift
//  starterkit
//
//  Created by Ade Septiadi on 9/18/17.
//  Copyright © 2017 Ade Septiadi. All rights reserved.
//

import UIKit

class SearchBarController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    @IBOutlet weak var leftMenu: UIBarButtonItem!
    @IBOutlet weak var rightMenu: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    struct Cake {
        var name = String()
        var size = String()
    }
    
    var cakes = [Cake(name: "Red Velvet", size: "Small"),
                 Cake(name: "Brownie", size: "Medium"),
                 Cake(name: "Bannna Bread", size: "Large"),
                 Cake(name: "Vanilla", size: "Small"),
                 Cake(name: "Minty", size: "Medium")]
    
    var filteredCakes = [Cake]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.initSideMenu(leftMenu, rightMenu)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        filteredCakes = cakes
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        // If we haven't typed anything into the search bar then do not filter the results
        if searchController.searchBar.text! == "" {
            filteredCakes = cakes
        } else {
            // Filter the results
            filteredCakes = cakes.filter { $0.name.lowercased().contains(searchController.searchBar.text!.lowercased()) }
        }
        
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredCakes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell 	{
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        
        cell.textLabel?.text = self.filteredCakes[indexPath.row].name
        cell.detailTextLabel?.text = self.filteredCakes[indexPath.row].size
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row \(indexPath.row) selected")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

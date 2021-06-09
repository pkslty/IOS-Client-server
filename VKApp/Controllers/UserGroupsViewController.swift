//
//  UserGroupsViewController.swift
//  VKApp
//
//  Created by Denis Kuzmin on 06.04.2021.
//

import UIKit
import RealmSwift

class UserGroupsViewController: UITableViewController {

    var groups: Results<VKRealmGroup>?
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        
        if let viewController = segue.source as? AllGroupsViewController {
            if let allgroups = viewController.groups,
               let section = viewController.groupsTable.indexPathForSelectedRow?.section,
               let row = viewController.groupsTable.indexPathForSelectedRow?.row {
                    let num = viewController.sections[section].rows[row]
                    //if !groups.contains(allgroups[num]) {
                    //    groups.append(allgroups[num])
                    //}
                    self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getGroups()


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateGroups()
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groups?.count ?? 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as? GroupCell
        
        else { return UITableViewCell() }
        
        cell.config(name: groups![indexPath.row].name,
                    avatarUrlString: groups![indexPath.row].photo200UrlString,
                    description: groups![indexPath.row].screenName)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //groups.remove(at: indexPath.row)
            //tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    private func getGroups() {
        groups = try? RealmService.load(typeOf: VKRealmGroup.self)
    }
    
    private func updateGroups() {
        let ns = NetworkService()
        ns.getGroups { [weak self] groups in
            try? RealmService.save(items: groups)
            self?.tableView.reloadData()
        }
    }
    
}

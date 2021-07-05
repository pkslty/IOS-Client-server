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
    enum UpdateRowsMethod {
        case update
        case delete
        case insert
    }
    var token: NotificationToken?
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        
        if let viewController = segue.source as? AllGroupsViewController {
            let allgroups = viewController.foundedGroups
            let row = viewController.groupsTable.indexPathForSelectedRow?.row

            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getGroups()
        
        token = groups?.observe({ changes in
            switch changes {
            case .initial:
                self.tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                self.updateRows(for: modifications, method: .update)
                self.updateRows(for: deletions, method: .delete)
                self.updateRows(for: insertions, method: .insert)
            case .error(let error):
                print(error)
            }
        })


    }
    
    private func updateRows(for vkPhotosModificatedIndexes: [Int], method: UpdateRowsMethod) {
        var pathsToUpdate = [IndexPath]()
        vkPhotosModificatedIndexes.forEach { index in
            pathsToUpdate.append(IndexPath(row: index, section: 0))
        }
        guard pathsToUpdate.count > 0 else { return }
        switch method {
        case .update:
            tableView.reloadRows(at: pathsToUpdate, with: .automatic)
        case .delete:
        tableView.deleteRows(at: pathsToUpdate, with: .automatic)
        case .insert:
            tableView.insertRows(at: pathsToUpdate, with: .automatic)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateGroups()
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
        NetworkService.getGroups { [weak self] groups in
            try? RealmService.save(items: groups)
        }
    }
    
}

//
//  FriendsViewController.swift
//  VKApp
//
//  Created by Denis Kuzmin on 12.04.2021.
//

import UIKit
import RealmSwift



class FriendsViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var friendTable: UITableView!
    @IBOutlet weak var categoriesPicker: CategoriesPicker!
    
    enum UpdateRowsMethod {
        case update
        case delete
        case insert
    }
    
    var user: User? = User(username: "Denis", firstname: "Denis", login: "1", password: "1")
    let updateIndicator = UIActivityIndicatorView()
    
    
    var categories = [String]()
    var vkFriends:  Results<VKRealmUser>?
    var token: NotificationToken?
    
    struct Section {
        var sectionName: Character
        var rows: [Int]
    }
    
    var sections = [Section]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        getFriends()
        token = vkFriends?.observe({ changes in
            switch changes {
            case .initial:
                self.prepareSections()
                self.friendTable.reloadData()
            case .update( _, let deletions, let insertions, let modifications):
                self.updateRows(for: modifications, method: .update)
                self.updateRows(for: deletions, method: .delete)
                self.updateRows(for: insertions, method: .insert)
            case .error(let error):
                print(error)
            }
        })
        
        categoriesPicker.addTarget(self, action: #selector(categoriesPickerValueChanged(_:)),
                              for: .valueChanged)
        friendTable.register(FriendsTableCellHeader.self, forHeaderFooterViewReuseIdentifier: "FriendsTableCellHeader")
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        friendTable.refreshControl = refreshControl
    }
    
    @objc func refreshTable() {
        updateFriends()
        
    }
    
    @objc func categoriesPickerValueChanged(_ categoriesPicker: CategoriesPicker) {
        let value = categoriesPicker.pickedCategory
        let indexPath = IndexPath(row: 0, section: value)
        friendTable.scrollToRow(at: indexPath, at: .top, animated: false)
        //let generator = UIImpactFeedbackGenerator(style: .soft)
        //generator.impactOccurred()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "showFriendPhotos" {
            guard let destinationVC = segue.destination as? FriendPhotosViewController else { return }
            let section = friendTable.indexPathForSelectedRow!.section
            let row = friendTable.indexPathForSelectedRow!.row
            let friendNum = sections[section].rows[row]
            let friendId = vkFriends![friendNum].id
            destinationVC.friendId = friendId
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateFriends()
    }
    
    private func prepareSections() {
        guard let vkFriends = vkFriends else { return }
        categoriesPicker.categories.removeAll()
        sections = [Section]()
        
        for i in 0 ..< vkFriends.count {
            let ch = Character(vkFriends[i].lastName.first!.uppercased()).isLetter ?
                Character(vkFriends[i].lastName.first!.uppercased()) : "#"
            
            if let num = sections.firstIndex(where: {friendsection in friendsection.sectionName == ch}) {
                sections[num].rows.append(i)
            } else {
                sections.append(Section(sectionName: ch, rows: [i]))
                categoriesPicker.categories.append(String(ch))
            }
        }
        sections.sort(by: {$0.sectionName < $1.sectionName})
        categoriesPicker.categories.sort(by: <)
    }
    
    private func getFriends() {

        vkFriends = try? RealmService.load(typeOf: VKRealmUser.self)
        //prepareSections()
        //friendTable.reloadData()

    }
    
    private func updateFriends() {
        NetworkService.getFriends { [weak self] friends in
            do {
                try RealmService.save(items: friends)
            } catch let error {
                print(error.localizedDescription)
            }
            DispatchQueue.main.async {
                self?.friendTable.refreshControl?.endRefreshing()
            }
            //self?.prepareSections()
            //self?.friendTable.reloadData()
        }
    }
    
    private func updateRows(for vkFriendModificatedIndexes: [Int], method: UpdateRowsMethod) {
        guard let indexPathsForVisibleRows = friendTable.indexPathsForVisibleRows
        else {
            
            return }
        var pathsToUpdate = [IndexPath]()
        for indexPath in indexPathsForVisibleRows {
            for index in vkFriendModificatedIndexes {
                if index == sections[indexPath.section].rows[indexPath.row] {
                    pathsToUpdate.append(indexPath)
                    break
                }
            }
        }
        switch method {
        case .update:
            if pathsToUpdate.count == 0 { break }
            friendTable.reloadRows(at: pathsToUpdate, with: .automatic)
        case .delete, .insert:
            prepareSections()
            friendTable.reloadData()
        }
    }
    
    
}

extension FriendsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sections[section].rows.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsTableCell", for: indexPath) as? FriendsTableCell
        else { return UITableViewCell()}
        
        let num = sections[indexPath.section].rows[indexPath.row]
        cell.config(name: vkFriends![num].fullName,
                    avatarUrlString: vkFriends![num].avatarUrlString)

        return cell
    }
    /*func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(sections[section].sectionName)
    }*/
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard  let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FriendsTableCellHeader") as? FriendsTableCellHeader
        else { return UITableViewHeaderFooterView() }
        
        header.configure(text: String(sections[section].sectionName))
        return header
    }
    
    
    
    
}
        

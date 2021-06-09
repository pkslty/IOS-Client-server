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
    
    var user: User? = User(username: "Denis", firstname: "Denis", login: "1", password: "1")
    
    
    var categories = [String]()
    //var vkFriendsResults: Results<VKRealmUser>?
    var sortedFriends = [VKRealmUser]()
    var vkFriends:  Results<VKRealmUser>?
    
    struct Section {
        var sectionName: Character
        var rows: [Int]
    }
    
    var sections = [Section]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getFriends()
        
        categoriesPicker.addTarget(self, action: #selector(categoriesPickerValueChanged(_:)),
                              for: .valueChanged)
        friendTable.register(FriendsTableCellHeader.self, forHeaderFooterViewReuseIdentifier: "FriendsTableCellHeader")
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
            /*destinationVC.friendNum = sections[friendTable.indexPathForSelectedRow!.section].rows[friendTable.indexPathForSelectedRow!.row]
            destinationVC.friend = sortedFriends[destinationVC.friendNum!]
            destinationVC.username = user?.username*/
            let section = friendTable.indexPathForSelectedRow!.section
            let row = friendTable.indexPathForSelectedRow!.row
            let friendNum = sections[section].rows[row]
            let friendId = sortedFriends[friendNum].id
            destinationVC.friendId = friendId
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateFriends()
    }
    
    private func prepareSections() {
        sortedFriends = vkFriends!.sorted(by: <)
        sections = [Section]()
        
        for i in 0 ..< sortedFriends.count {
            let ch = Character(sortedFriends[i].lastName.first!.uppercased()).isLetter ?
                Character(sortedFriends[i].lastName.first!.uppercased()) : "#"
            
            if let num = sections.firstIndex(where: {friendsection in friendsection.sectionName == ch}) {
                sections[num].rows.append(i)
            } else {
                sections.append(Section(sectionName: ch, rows: [i]))
                categoriesPicker.categories.append(String(ch))
            }
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
        cell.config(name: sortedFriends[num].fullName,
                    avatarUrlString: sortedFriends[num].avatarUrlString)

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
    
    

    private func getFriends() {

        vkFriends = try? RealmService.load(typeOf: VKRealmUser.self)
        prepareSections()
        friendTable.reloadData()

    }
    
    private func updateFriends() {
        let networkService = NetworkService()
        networkService.getFriends { [weak self] friends in
            try? RealmService.save(items: friends)
            self?.prepareSections()
            self?.friendTable.reloadData()
        }
    }
    
}
        /*
        user.friends.append(VKRealmUser(firstName: "Вадим", lastName: "Рощин",
                                   avatar: UIImage(named: "thumb-1")))
       
        user.friends.append(Person(firstName: "Илья", lastName: "Шумихин",
                                   avatar: UIImage(named: "thumb-2")))
        
        user.friends.append(Person(firstName: "Александр", lastName: "Ковалев",
                                   avatar: UIImage(named: "thumb-3")))

        user.friends.append(Person(firstName: "Георгий", lastName: "Сабанов",
                                   avatar: UIImage(named: "thumb-4")))

        user.friends.append(Person(firstName: "Николай", lastName: "Родионов",
                                   avatar: UIImage(named: "thumb-5")))

        user.friends.append(Person(firstName: "Александр", lastName: "Федоров",
                                   avatar: UIImage(named: "thumb-6")))

        user.friends.append(Person(firstName: "Андрей", lastName: "Антропов",
                                   avatar: UIImage(named: "thumb-7")))
        
        user.friends.append(Person(firstName: "Евгений", lastName: "Елчев",
                                   avatar: UIImage(named: "thumb-8")))
        user.friends.append(Person(firstName: "Владислав", lastName: "Фролов",
                                   avatar: UIImage(named: "thumb-9")))
        user.friends.append(Person(firstName: "Максим", lastName: "Пригоженков",
                                   avatar: UIImage(named: "thumb-10")))
        user.friends.append(Person(firstName: "Никита", lastName: "Филонов",
                                   avatar: UIImage(named: "thumb-11")))
        user.friends.append(Person(firstName: "Олег", lastName: "Иванов"))
        user.friends.append(Person(firstName: "Алексей", lastName: "Усанов",
                                   avatar: UIImage(named: "thumb-13")))
        user.friends.append(Person(firstName: "Станислав", lastName: "Иванов",
                                   avatar: UIImage(named: "thumb-14")))
        user.friends.append(Person(firstName: "Алёна", lastName: "Козлова",
                                   avatar: UIImage(named: "thumb-15")))
        user.friends.append(Person(firstName: "Кирилл", lastName: "Лукьянов",
                                   avatar: UIImage(named: "thumb-16")))
        user.friends.append(Person(firstName: "Анатолий", lastName: "Пешков",
                                   avatar: UIImage(named: "thumb-17")))
        user.friends.append(Person(firstName: "Леонид", lastName: "Нифантьев"))
        //user.friends.append(Person(firstname: "A", lastname: "A"))
        //user.friends.append(Person(firstname: "B", lastname: "B"))
        //user.friends.append(Person(firstname: "C", lastname: "C"))
        
        user.friends.append(Person(firstName: "Вячеслав", lastName: "Кирица",
                                   avatar: UIImage(named: "thumb-19")))
        user.friends.append(Person(firstName: "Алексей", lastName: "Кудрявцев",
                                   avatar: UIImage(named: "thumb-20")))
        user.friends.append(Person(firstName: "Юрий", lastName: "Султанов",
                                   avatar: UIImage(named: "thumb-21")))
        user.friends.append(Person(firstName: "Егор", lastName: "Петров",
                                   avatar: UIImage(named: "thumb-22")))
        //user.friends.append(Person(firstname: "Родион", lastname: "Молчанов"))
        user.friends.append(Person(firstName: "Станислав", middleName: "Дмитриевич", lastName: "Белых",
                                   avatar: UIImage(named: "thumb-24")))
        user.friends.append(Person(firstName: "Антон", lastName: "Марченко",
                                   avatar: UIImage(named: "thumb-25")))
        
                                   
        user.friends[0].photos.append((UIImage(named: "man01")!, 0, Set<String>()))
        user.friends[0].photos[0].likes = 87
        user.friends[0].photos[0].likers.insert("admin")
        user.friends[1].photos.append((UIImage(named: "man02")!, 0, Set<String>()))
        
        user.friends[2].photos.append((UIImage(named: "man03")!, 0, Set<String>()))
        user.friends[3].photos.append((UIImage(named: "woman01")!, 0, Set<String>()))
        user.friends[4].photos.append((UIImage(named: "woman02")!, 0, Set<String>()))
        user.friends[5].photos.append((UIImage(named: "man04")!, 0, Set<String>()))
        user.friends[6].photos.append((UIImage(named: "man05")!, 0, Set<String>()))
        
        user.friends[1].photos.append((UIImage(named: "man01")!, 0, Set<String>()))
        user.friends[1].photos.append((UIImage(named: "man03")!, 0, Set<String>()))
        user.friends[1].photos.append((UIImage(named: "woman01")!, 0, Set<String>()))
        user.friends[1].photos.append((UIImage(named: "woman02")!, 0, Set<String>()))
        user.friends[1].photos.append((UIImage(named: "man04")!, 0, Set<String>()))
        user.friends[1].photos.append((UIImage(named: "man05")!, 0, Set<String>()))
        user.friends[6].photos.append((UIImage(named: "man01")!, 0, Set<String>()))
        user.friends[6].photos.append((UIImage(named: "man03")!, 0, Set<String>()))
        user.friends[6].photos.append((UIImage(named: "woman01")!, 0, Set<String>()))
        user.friends[6].photos.append((UIImage(named: "woman02")!, 0, Set<String>()))
        user.friends[6].photos.append((UIImage(named: "man04")!, 0, Set<String>()))
        user.friends[6].photos.append((UIImage(named: "man02")!, 0, Set<String>()))
        user.friends[6].photos.append((UIImage(named: "woman03")!, 0, Set<String>()))
        user.friends[6].photos.append((UIImage(named: "group01")!, 0, Set<String>()))
        user.friends[6].photos.append((UIImage(named: "woman04")!, 0, Set<String>()))*/



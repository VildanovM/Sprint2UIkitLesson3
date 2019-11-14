import UIKit

class NotesViewController: UIViewController {

    let layout = UICollectionViewFlowLayout()
    var collectionView: UICollectionView!
    
    var boards: [Board] = []
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
          super.viewWillTransition(to: size, with: coordinator)
          updateCollectionViewItem(with: size)
      }
    

    
    private func updateCollectionViewItem(with size: CGSize) {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
              return
        }
        layout.itemSize = CGSize(width: 225, height: size.height * 0.8)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        
        
        if Singleton.shared.value == 0 {
            tabBarController?.title = "Заметки"
        } else {
            tabBarController?.title = "Заметки(\(Singleton.shared.value))"
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        boards.append(Board(title: "Todo", items: ["Сделать кнопку", "Сделать вьюконтролер", "Работа с API", "MVC"]))
        boards.append(Board(title: "In Progress", items: ["Нотификация", "UITests", "Autolayout"]))
        boards.append(Board(title: "Done", items: ["GSD", "Alert Controller"]))
        view.backgroundColor = .green
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        view.addSubview(collectionView)
        collectionView.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: MyCollectionViewCell.reuseId)
        collectionView.backgroundColor = .green
        collectionView.delegate = self
        collectionView.dataSource = self
        updateCollectionViewItem(with: view.bounds.size)
        
        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addListTapped(_:)))
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = addButtonItem
        
        
    }
    
    @objc func addListTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Добавить список", message: nil, preferredStyle: .alert)
        alertController.addTextField(configurationHandler: nil)
        alertController.addAction(UIAlertAction(title: "Добавить", style: .default, handler: { (_) in
            guard let text = alertController.textFields?.first?.text, !text.isEmpty else {
                return
            }
            
            self.boards.append(Board(title: text, items: []))
            
            let addedIndexPath = IndexPath(item: self.boards.count - 1, section: 0)
            
            self.collectionView.insertItems(at: [addedIndexPath])
            self.collectionView.scrollToItem(at: addedIndexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
        }))
        
        alertController.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
        present(alertController, animated: true)
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        self.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "notes"), tag: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NotesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return boards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCell.reuseId, for: indexPath) as! MyCollectionViewCell
        cell.setup(with: boards[indexPath.row])
        cell.parentVC = self
        return cell
    }
}

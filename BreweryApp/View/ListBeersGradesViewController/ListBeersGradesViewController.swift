//
//  ListBeersGradesViewController.swift
//  BreweryApp
//
//  Created by Stanislav on 03.04.2021.
//

import UIKit

class ListBeersGradesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let tableView = UITableView()
    private var safeArea: UILayoutGuide!
    
    private let beersGradesStorageModel: BeerGradeStorageModel
    public var requestBeerGrade = [ManagedBeersGrades?]()
    var breweries: ManagedBrewery?
    
    init(beersGradesStorageModel: BeerGradeStorageModel) {
        self.beersGradesStorageModel = beersGradesStorageModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        safeArea = view.layoutMarginsGuide
        view.backgroundColor = .white
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "loadBeers"), object: nil)
        setupNavigationItem()
        setupTableView()
        requestData()
        tableView.reloadData()
    }
    
    func setupNavigationItem() {
        navigationItem.title = "Beer List"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBrewerie))
    }
    
    @objc func loadList(notification: NSNotification) {
        requestData()
        tableView.reloadData()
    }
    
    @objc func addBrewerie() {
        let vc = UINavigationController(rootViewController: NewBeerGradeViewController(beersGradesStorageModel: beersGradesStorageModel))
        guard let vcBG = vc.viewControllers.first as? NewBeerGradeViewController else { return }
        vcBG.brewery = breweries
        present(vc, animated: true)
        
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.register(UINib(nibName: Constants.tabelViewCell, bundle: nil), forCellReuseIdentifier: Constants.reuseIdentifier)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requestBeerGrade.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reuseIdentifier, for: indexPath) as! TableViewCell
        cell.titelLabel.text = requestBeerGrade[indexPath.row]?.nameBG
        cell.descriptionLabel.text = requestBeerGrade[indexPath.row]?.descriptionBG
        cell.breweriesImage.image = UIImage(data: (requestBeerGrade[indexPath.row]?.imageBG)!)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = BeerDetailViewController()
        
        vc.nameLabelSting = requestBeerGrade[indexPath.row]?.nameBG
        vc.descriptionLabelSting = requestBeerGrade[indexPath.row]?.descriptionBG
        vc.imageBeer = UIImage(data: (requestBeerGrade[indexPath.row]?.imageBG)!)
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func requestData() {
        guard let beerGrade = breweries?.rowsBeerGrade?.allObjects as? [ManagedBeersGrades] else { return }
        requestBeerGrade = beerGrade
    } 
}

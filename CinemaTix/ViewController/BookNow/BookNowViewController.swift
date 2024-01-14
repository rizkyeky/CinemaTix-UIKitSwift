//
//  BookNowViewController.swift
//  CinemaTix
//
//  Created by Eky on 28/12/23.
//

import UIKit
import CoreLocation
import MapKit

class BookNowViewController: BaseViewController {
    
    private var viewModel = BookNowViewModel()
    
    private let table = {
        let table = UITableView()
        table.allowsSelection = false
        table.separatorStyle = .none
        table.sectionHeaderTopPadding = 0.0
        table.showsVerticalScrollIndicator = false
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainTable()
    }
    
    override func setupConstraints() {
        view.addSubview(table)
        table.snp.makeConstraints { make in
            make.left.right.bottom.top.equalTo(view)
        }
    }
    
    override func setupNavBar() {
        navigationItem.title = "Book Now"
    }
}

extension BookNowViewController: UITableViewDataSource, UITableViewDelegate {
    func setupMainTable() {
        
        table.delegate = self
        table.dataSource = self
        table.register(BookNowDateTableCell.self)
        table.register(BookNowCinemaTableCell.self)
        
        table.tableHeaderView = MapHeader(size: CGSize(width: view.bounds.width, height: 300))
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 160
        default:
            return 200
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let base = UIView()
        let label = UILabel()
        
        base.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerY.equalTo(base)
            make.left.equalTo(base).offset(16)
        }
        
        switch section {
        case 0:
            label.text = "Date"
        default:
            label.text = "Cinema"
        }
        
        return base
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as BookNowDateTableCell
            cell.viewModel = viewModel
            cell.viewModel?.init7Days()
            return cell
        default:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as BookNowCinemaTableCell
            cell.viewModel = viewModel
            return cell
        }
    }
}

class MapHeader: UIView {
    
    private let mapView = MKMapView()
    private var currLocation: CLLocation?
    private let locationManager = CLLocationManager()
    
    init(size: CGSize) {
        super.init(frame: .init(x: 0, y: 0, width: size.width, height: size.height))
        
        locationManager.delegate = self
        
        addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(self)
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateLocation() {
        let initialLocation = currLocation ?? CLLocation(latitude: -6.9034495, longitude: 107.6431575)
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: initialLocation.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        
        mapView.setRegion(coordinateRegion, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = initialLocation.coordinate
        annotation.title = "Your Location"
        mapView.addAnnotation(annotation)
    }

}

extension MapHeader: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            break
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            
            self.currLocation = location
            
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if error != nil {
                    return
                }
                
                if let placemark = placemarks?.first {
                }
            }
            updateLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }
}

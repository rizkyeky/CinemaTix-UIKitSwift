//
//  BookNowViewModel.swift
//  CinemaTix
//
//  Created by Eky on 28/12/23.
//

import CoreLocation
import RxRelay

class BookNowViewModel: BaseViewModel {
    
    var movie: MovieModel?
    private var currLocation: CLLocation?
    
    open var selectedDateRelay = PublishRelay<Int>()
    
    open var sevenDays: [Date] = []
    
    func init7Days() {
        sevenDays.append(contentsOf: getDatesForThisWeek())
    }
    
    private func getDatesForThisWeek() -> [Date] {
        var dates = [Date]()
        let calendar = Calendar.current
        let currentDate = Date.now
        
        for day in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: day, to: currentDate) {
                dates.append(date)
            }
        }
        
        return dates
    }
}

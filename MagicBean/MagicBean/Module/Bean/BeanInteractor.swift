//   Interactor
//  BeanInteractor.swift

import Foundation

protocol BeanInteractorProtocol {
    func fetchBean()
    func update(quantity: Int)
}

class BeanInteractor {
    // VIP
    var presenter: BeanPresenterProtocol?
    
    // data layer
    private let apiWorker: BeanApiWorkerProtocol
    private var beanEntity: BeanEntity?
    
    // init
    required init(withApiWorker apiWorker: BeanApiWorkerProtocol) {
        self.apiWorker = apiWorker
    }
}

extension BeanInteractor: BeanInteractorProtocol {
    func fetchBean() {
        // demande a l'api de fetch les data
        
        apiWorker.fetchBean { [weak self] (beanEntity) in
            guard let strongSelf = self else { return }
            //            Reflexion🏙🏝 👾👯‍♀️👙🙍🏻‍♀️👄😺🏖🏞 send gst
            strongSelf.beanEntity = beanEntity
            strongSelf.presenter?.interactor(strongSelf, didFetch : beanEntity)
            
        }
    }
    func update(quantity: Int) {
        print("  💟🐝\(#line)💟▓▒░ quantity from update methode :  ░▒▓💟",quantity,"💟")
        // MARK: -
        // TODO:
        //update number for stepper
        presenter?.interactor(self, didUpdate: quantity)
        
        // calculate price
        apiWorker.fetchBean { [weak self] (beanEntity) in
            guard let strongSelf = self else { return }
            strongSelf.beanEntity = beanEntity
            
            let base = beanEntity.priceHT
            let tax = beanEntity.tax
            
            let subTotal = BeanCalculWorker.calculSubTotal(base: base, quantity: quantity)
            let totalNet = BeanCalculWorker.calculTotalNet(base: base, quantity: quantity, tax: tax)
//            presenter?.interactor(self, didUpdate: subTotal, totalNet)
            strongSelf.presenter?.interactor(strongSelf, didUpdateSubTotal: subTotal, totalNet)
        }
        
        // MARK: -
        
        
    }
}



import Foundation
import Alamofire

class HttpHelp: NSObject {
    class func request(_ url: URLConvertible, method: HTTPMethod, success: @escaping (DataResponse<Any>) -> Void, failure:@escaping (Error) -> Void) {
        Alamofire.request(url, method: method).responseJSON { response in
            switch response.result {
            case .success:
                success(response)
                
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
    }
    
    deinit {
        print("HttpHelp func deinit() debug")
    }
    
}



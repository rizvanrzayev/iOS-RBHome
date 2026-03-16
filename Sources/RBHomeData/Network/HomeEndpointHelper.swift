import Data
import Networking

package extension EndpointInterface {
    func makeHomeRequest<T: Decodable>(type: T.Type) -> Endpoint<T> {
        Endpoint(
            path: basePath + path,
            method: method,
            queryParameters: queryParameters,
            bodyParametersEncodable: bodyParametersEncodable,
            bodyParameters: bodyParameters,
            mockFileName: mockFileName
        )
    }
}

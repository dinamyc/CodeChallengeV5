//
//  FlickrSearchAppTests.swift
//  FlickrSearchAppTests
//
//  Created by JL on 21/02/24.
//

import XCTest
@testable import FlickrSearchApp

final class FlickrSearchAppTests: XCTestCase {
    
    // Prueba para verificar que la búsqueda de fotos actualiza la lista de fotos correctamente
    func testSearchViewModel_SearchPhotos_UpdatePhotosList() {
        let viewModel = SearchViewModel()
        
        // Crea una expectativa para esperar a que se complete la llamada de red
        let expectation = XCTestExpectation(description: "Search photos")
        
        let initialCount = viewModel.photos.count
        
        // Llama a searchPhotos, que es una operación asincrónica
        viewModel.searchPhotos(with: "dogs")
        
        // Espera a que se complete la llamada de red
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            // Verifica que el número de fotos haya aumentado después de la búsqueda
            XCTAssertGreaterThan(viewModel.photos.count, initialCount)
            
            // Cumple la expectativa
            expectation.fulfill()
        }
        
        // Espera a que se cumpla la expectativa
        wait(for: [expectation], timeout: 5.0)
    }
    
    // Prueba para verificar que la función de construcción de URL crea la URL correcta
    func testSearchViewModel_BuildURL() {
        let viewModel = SearchViewModel()
        let query = "cats"
        let url = viewModel.buildURL(with: query)
        XCTAssertEqual(url.absoluteString, "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags=cats")
    }
    
    // Prueba para verificar que la función de formateo de fecha funciona correctamente para fechas válidas
    func testPhotoDetailViewModel_FormattedDate_ValidDate() {
        let dateString = "2024-01-26T16:36:52Z"
        let formattedDate = dateString.formattedDate()
        XCTAssertEqual(formattedDate, "26 de January 2024")
    }
    
    // Prueba para verificar que la función de formateo de fecha devuelve nil para fechas inválidas
    func testPhotoDetailViewModel_FormattedDate_InvalidDate() {
        let dateString = "invalidDate"
        let formattedDate = dateString.formattedDate()
        XCTAssertNil(formattedDate)
    }
    
    // Prueba para verificar que la función de eliminación de etiquetas HTML elimina correctamente las etiquetas
    func testPhotoDetailViewModel_HTMLTagRemoval() {
        let htmlString = "<p>This is a <b>test</b> string with <i>HTML</i> tags.</p>"
        let strippedString = htmlString.stringByRemovingHTMLTags()
        XCTAssertEqual(strippedString, "This is a test string with HTML tags.")
    }
    
    
    func testAPIService_HandleNetworkError() {
        let expectation = XCTestExpectation(description: "API Service Network Error Handling")
        
        // Crea una URL inválida para simular un error de red
        let invalidURL = URL(string: "https://invalidurl.com")!
        
        APIService.request(url: invalidURL) { (result: Result<String, APIError>) in
            switch result {
            case .success:
                XCTFail("Expected failure but received success")
            case .failure(let error):
                // Asegúrate de que el error sea de tipo .networkError
                if case APIError.networkError = error {
                    // Si el error es de tipo .networkError, la prueba pasa
                    expectation.fulfill()
                } else {
                    // Si el error no es de tipo .networkError, la prueba falla
                    XCTFail("Expected networkError but received \(error)")
                }
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    // Prueba para verificar que el API Service maneja correctamente los errores de decodificación
    func testAPIService_HandleDecodingError() {
        let expectation = XCTestExpectation(description: "API Service Decoding Error Handling")
        
        // Crea una URL válida pero proporciona datos incorrectos para simular un error de decodificación
        let validURL = URL(string: "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags=dogs")!
        
        APIService.request(url: validURL) { (result: Result<String, APIError>) in
            switch result {
            case .success:
                XCTFail("Expected failure but received success")
            case .failure(let error):
                // Asegúrate de que el error sea de tipo .decodingError
                if case APIError.decodingError = error {
                    // Si el error es de tipo .decodingError, la prueba pasa
                    expectation.fulfill()
                } else {
                    // Si el error no es de tipo .decodingError, la prueba falla
                    XCTFail("Expected decodingError but received \(error)")
                }
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    // Prueba para verificar que la vista de detalle muestra la información correcta de la foto
    func testDetailView() {
        // Crea una foto de ejemplo
        let photo = Photo(title: "Test Photo", description: "Test Description", author: "Test Author", publishedDate: "2024-01-21T00:07:33Z", media: Media(m: URL(string: "https://example.com")!))
        
        // Crea una vista DetailView con la foto de ejemplo
        let detailView = DetailView(photo: photo)
        
        // Verifica que los elementos en la vista estén configurados correctamente
        XCTAssertNotNil(detailView)
        XCTAssertEqual(detailView.photo.title, "Test Photo")
        XCTAssertEqual(detailView.photo.author, "Test Author")
        // Continuar con más verificaciones según sea necesario...
    }
    
}

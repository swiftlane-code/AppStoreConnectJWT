import XCTest
@testable import AppStoreConnectJWT

import ES256SwiftJWT

final class AppStoreConnectJWTTests: XCTestCase {
    func test_generatedTokenIsValid() throws {
		// given
		let ecdsaPrivateKey = read(fileName: "ecdsa_private_key")
		let ecdsaPublicKey = read(fileName: "ecdsa_public_key")
		
		let creationTime = Date(timeIntervalSince1970: 3000)
		let lifetime: TimeInterval = 10
		let expirationTime = creationTime + lifetime
		let scope = ["scope1", "scope2"]
		let config = AppStoreConnectJWTGenerator.Config(
			keyIdentifier: "keyIdentifier",
			issuerID: "issuerID",
			privateKey: ecdsaPrivateKey
		)
		
		let generator = AppStoreConnectJWTGenerator()
		
		// when
		let token = try generator.generateToken(
			config: config,
			creationTime: creationTime,
			tokenLifeTime: lifetime,
			scope: scope
		)
		
		// then
		let jwt = try JWT<AppStoreConnectTokenClaims>(
			jwtString: token.jwtString,
			verifier: .es256(publicKey: ecdsaPublicKey)
		)
		
		XCTAssertEqual(token.creationTime, creationTime)
		XCTAssertEqual(token.expirationTime, expirationTime)
		XCTAssertEqual(token.scope, scope)
		
		XCTAssertEqual(jwt.header.alg, "ES256")
		XCTAssertEqual(jwt.header.kid, config.keyIdentifier)
		XCTAssertEqual(jwt.validateClaims(), .success)
		XCTAssertEqual(
			jwt.claims,
			.init(
				iss: config.issuerID,
				iat: creationTime,
				exp: expirationTime,
				scope: scope
			)
		)
    }
	
	func test_tokenCalculatedParams() throws {
		// given
		let creationTime = Date(timeIntervalSince1970: 6000)
		let lifetime: TimeInterval = 10
		let expirationTime = creationTime + lifetime
		let expiredTime = expirationTime + 0.001
		
		// when
		let token = AppStoreConnectJWTToken(
			jwtString: "test_jwt_string",
			creationTime: creationTime,
			expirationTime: expirationTime,
			scope: nil
		)
		
		// then
		XCTAssertEqual(token.httpHeader.key, "Authorization")
		XCTAssertEqual(token.httpHeader.value, "Bearer test_jwt_string")
		XCTAssertEqual(token.isExpired(after: expirationTime), false)
		XCTAssertEqual(token.isExpired(after: expiredTime), true)
	}
}

func read(fileName: String) -> Data {
	do {
		let pathToTests = NSString(string: #file).deletingLastPathComponent
		let filePath = NSString(string: pathToTests).appendingPathComponent(fileName)
		let fileData = try Data(contentsOf: URL(fileURLWithPath: filePath))
		XCTAssertNotNil(fileData, "Failed to read in the \(fileName) file")
		return fileData
	} catch {
		XCTFail("Error in \(fileName).")
		exit(1)
	}
}

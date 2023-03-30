/**
 Copyright IBM Corporation 2017
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import XCTest
import Foundation

@testable import ES256SwiftJWT

let ecdsaPrivateKey = read(fileName: "ecdsa_private_key")
let ecdsaPublicKey = read(fileName: "ecdsa_public_key")

struct TestClaims: Claims, Equatable {
    var name: String?
    var admin: Bool?
    var iss: String?
    var sub: String?
    var aud: [String]?
    var exp: Date?
    var nbf: Date?
    var iat: Date?
    var jti: String?
    init(name: String? = nil) {
        self.name = name
    }

    static func == (lhs: TestClaims, rhs: TestClaims) -> Bool {
        return lhs.name == rhs.name &&
        lhs.admin == rhs.admin &&
        lhs.iss == rhs.iss &&
        lhs.sub == rhs.sub &&
        lhs.aud ?? [""] == rhs.aud ?? [""] &&
        lhs.exp == rhs.exp &&
        lhs.nbf == rhs.nbf &&
        lhs.iat == rhs.iat &&
        lhs.jti == rhs.jti
    }
}

extension Header: Equatable {

    /// Function to check if two headers are equal. Required to conform to the equatable protocol.
    public static func == (lhs: Header, rhs: Header) -> Bool {
        return lhs.alg == rhs.alg &&
            lhs.crit ?? [] == rhs.crit ?? [] &&
            lhs.cty == rhs.cty &&
            lhs.jku == rhs.jku &&
            lhs.jwk == rhs.jwk &&
            lhs.kid == rhs.kid &&
            lhs.typ == rhs.typ &&
            lhs.x5c ?? [] == rhs.x5c ?? [] &&
            lhs.x5t == rhs.x5t &&
            lhs.x5tS256 == rhs.x5tS256 &&
            lhs.x5u == rhs.x5u
    }
}

@available(macOS 10.12, iOS 10.0, *)
class TestJWT: XCTestCase {
    
    static var allTests: [(String, (TestJWT) -> () throws -> Void)] {
        return [
            ("testSignAndVerifyECDSA", testSignAndVerifyECDSA),
            ("testValidateClaims", testValidateClaims),
            ("testValidateClaimsLeeway", testValidateClaimsLeeway),
        ]
    }
    
    func testSignAndVerifyECDSA() {
        if #available(OSX 10.13, iOS 11, tvOS 11.0, watchOS 4.0, *) {
            do {
                try signAndVerify(signer: .es256(privateKey: ecdsaPrivateKey), verifier: .es256(publicKey: ecdsaPublicKey))
            } catch {
                XCTFail("testSignAndVerify failed: \(error)")
            }
        }
    }
    
    func signAndVerify(signer: JWTSigner, verifier: JWTVerifier) throws {
        var jwt = JWT(claims: TestClaims(name:"Kitura"))
        jwt.claims.name = "Kitura-JWT"
        XCTAssertEqual(jwt.claims.name, "Kitura-JWT")
        jwt.claims.iss = "issuer"
        jwt.claims.aud = ["clientID"]
        jwt.claims.iat = Date(timeIntervalSince1970: 1485949565.58463)
        jwt.claims.exp = Date(timeIntervalSince1970: 2485949565.58463)
        jwt.claims.nbf = Date(timeIntervalSince1970: 1485949565.58463)
        let signed = try jwt.sign(using: signer)
        let ok = JWT<TestClaims>.verify(signed, using: verifier)
        XCTAssertTrue(ok, "Verification failed")
		let decoded = try JWT<TestClaims>(jwtString: signed, verifier: verifier)
        check(jwt: decoded, algorithm: signer.name)
        XCTAssertEqual(decoded.validateClaims(), .success, "Validation failed")
    }

    func check(jwt: JWT<TestClaims>, algorithm: String) {
        XCTAssertEqual(jwt.header.alg, algorithm, "Wrong .alg in decoded")
        XCTAssertEqual(jwt.claims.exp, Date(timeIntervalSince1970: 2485949565.58463), "Wrong .exp in decoded")
        XCTAssertEqual(jwt.claims.iat, Date(timeIntervalSince1970: 1485949565.58463), "Wrong .iat in decoded")
        XCTAssertEqual(jwt.claims.nbf, Date(timeIntervalSince1970: 1485949565.58463), "Wrong .nbf in decoded")
    }
    
    func testValidateClaims() {
        var jwt = JWT(claims: TestClaims(name:"Kitura"))
        jwt.claims.exp = Date()
        XCTAssertEqual(jwt.validateClaims(), .expired, "Validation failed")
        jwt.claims.exp = nil
        jwt.claims.iat = Date(timeIntervalSinceNow: 10)
        XCTAssertEqual(jwt.validateClaims(), .issuedAt, "Validation failed")
        jwt.claims.iat = nil
        jwt.claims.nbf = Date(timeIntervalSinceNow: 10)
        XCTAssertEqual(jwt.validateClaims(), .notBefore, "Validation failed")
    }
    
    func testValidateClaimsLeeway() {
        var jwt = JWT(claims: TestClaims(name:"Kitura"))
        jwt.claims.exp = Date()
        XCTAssertEqual(jwt.validateClaims(leeway: 20), .success, "Validation failed")
        jwt.claims.exp = nil
        jwt.claims.iat = Date(timeIntervalSinceNow: 10)
        XCTAssertEqual(jwt.validateClaims(leeway: 20), .success, "Validation failed")
        jwt.claims.iat = nil
        jwt.claims.nbf = Date(timeIntervalSinceNow: 10)
        XCTAssertEqual(jwt.validateClaims(leeway: 20), .success, "Validation failed")
    }
}

func read(fileName: String) -> Data {
    do {
        var pathToTests = #file
        if pathToTests.hasSuffix("TestJWT.swift") {
            pathToTests = pathToTests.replacingOccurrences(of: "TestJWT.swift", with: "")
        }
        let fileData = try Data(contentsOf: URL(fileURLWithPath: "\(pathToTests)\(fileName)"))
        XCTAssertNotNil(fileData, "Failed to read in the \(fileName) file")
        return fileData
    } catch {
        XCTFail("Error in \(fileName).")
        exit(1)
    }
}

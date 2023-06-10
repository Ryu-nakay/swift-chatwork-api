//
//  APITokenTests.swift
//  
//
//  Created by cw-ryu.nakayama on 2023/06/10.
//

import XCTest
@testable import SwiftChatworkAPI

final class APITokenTests: XCTestCase {
    func test_英数字のみを与えた場合_初期化される() throws {
        do {
            let tokenString = "token1234"
            let token = try APIToken(value: tokenString)
            XCTAssertEqual(token.value, tokenString)
        } catch {
            XCTFail("予期せぬ例外が起きました")
        }
    }
    
    func test_英数字以外が混ざったものを与えた場合_例外が起きる() throws {
        do {
            let tokenString = "token1234あいうえお"
            let token = try APIToken(value: tokenString)
            XCTFail("予期した例外が起きませんでした")
        } catch {
            XCTAssertEqual(error as! APITokenError, APITokenError.invalidValue)
        }
    }
    
    func test_空文字を与えた場合_例外が起きる() throws {
        do {
            let tokenString = ""
            let token = try APIToken(value: tokenString)
            XCTFail("予期した例外が起きませんでした")
        } catch {
            XCTAssertEqual(error as! APITokenError, APITokenError.invalidValue)
        }
    }

}

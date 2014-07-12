//
//  swiftperl.swift
//  swiftperl
//
//  Created by Dan Kogai on 7/12/14.
//  Copyright (c) 2014 Dan Kogai. All rights reserved.
//


class Perl {
    init () { swiftperl_init() }
    deinit  { swiftperl_deinit() }
    func clean() {  swiftperl_deinit(); swiftperl_init() }
    class func sysinit() { swiftperl_sys_init() }
    class func systerm() { swiftperl_sys_term() }
    var preamble = "use v5.16; no strict;"
    func eval(script:String)->Bool {
        return  (preamble+script).withCString {
            swiftperl_eval_pv($0, 0) == 0
        }
    }
    var errstr:String {
        return String.fromCString(CString(swiftperl_errstr()))!
    }
    func bool(name:String)->Bool {
        return name.withCString { swiftperl_getbool($0) != 0 }
    }
    func uint(name:String)->UInt {
        return name.withCString { swiftperl_getuv($0) }
    }
    func int(name:String)->Int {
        return name.withCString { swiftperl_getiv($0) }
    }
    func double(name:String)->Double {
        return name.withCString { swiftperl_getnv($0) }
    }
    func string(name:String)->String {
        return name.withCString {
            String.fromCString(CString(swiftperl_getpv($0)))!
        }
    }
}
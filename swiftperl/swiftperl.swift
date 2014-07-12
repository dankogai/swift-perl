//
//  swiftperl.swift
//  swiftperl
//
//  Created by Dan Kogai on 7/12/14.
//  Copyright (c) 2014 Dan Kogai. All rights reserved.
//

class PerlSV : Printable {
    let sv:UnsafePointer<()>
    init (_ sv:UnsafePointer<()>){ self.sv = sv }
    var defined:Bool    { return swiftperl_svdefined(sv) != 0 }
    var asBool:Bool     { return swiftperl_svtrue(sv) != 0 }
    var asUInt:UInt     { return swiftperl_svuv(sv) }
    var asInt:Int       { return swiftperl_sviv(sv) }
    var asDouble:Double { return swiftperl_svnv(sv) }
    var asString:String {
        return String.fromCString(CString(swiftperl_svpv(sv)))!
    }
    var description:String { return asString }
}

class Perl {
    init () { swiftperl_init() }
    deinit  { swiftperl_deinit() }
    func clean() {  swiftperl_deinit(); swiftperl_init() }
    class func sysInit() { swiftperl_sys_init() }
    class func sysTerm() { swiftperl_sys_term() }
    var preamble = "use v5.16; no strict;"
    func eval(script:String)->PerlSV {
        return  (preamble+script).withCString {
            PerlSV(swiftperl_eval_pv($0, 0))
        }
    }
    var evalok:Bool {
        return swiftperl_err() == 0
    }
    var errstr:String {
        return String.fromCString(CString(swiftperl_errstr()))!
    }
    func $(name:String) -> PerlSV? {
        let sv = name.withCString { swiftperl_get_sv($0) }
        return sv == nil ? nil : PerlSV(sv)
    }
}

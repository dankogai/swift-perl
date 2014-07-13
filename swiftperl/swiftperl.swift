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
    var defined:Bool    { return swiftperl_svok(sv) != 0 }
    func undef() { swiftperl_undef(sv) }
    var asBool:Bool     {
    get {return swiftperl_svtrue(sv) != 0 }
    set { swiftperl_setiv(sv, newValue ? 1 : 0 ) }
    }
    var asUInt:UInt     {
    get { return swiftperl_svuv(sv) }
    set { return swiftperl_setuv(sv, newValue) }
    }
    var asInt:Int       {
    get { return swiftperl_sviv(sv) }
    set { swiftperl_setiv(sv, newValue) }
    }
    var asDouble:Double {
    get { return swiftperl_svnv(sv) }
    set { swiftperl_setnv(sv, newValue) }
    }
    var asString:String {
    get {
        return String.fromCString(CString(swiftperl_svpv(sv)))!
    }
    set {
        newValue.withCString {
            swiftperl_setpv(self.sv, $0)
        }
    }
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
    func sv(name:String, _ add:Bool=false) -> PerlSV? {
        let sv = name.withCString {
            swiftperl_get_sv($0, add ? 1 : 0)
        }
        return sv == nil ? nil : PerlSV(sv)
    }
    func $(name:String, _ add:Bool=false)->PerlSV? {
        return self.sv(name, add)
    }
    func av(name:String, _ add:Bool=false)->[PerlSV?]? {
        let av = name.withCString {
            swiftperl_get_av($0, add ? 1 : 0)
        }
        if av == nil { return nil }
        var result = [PerlSV?]()
        for i in 0..<swiftperl_av_len(av) {
            let sv = swiftperl_av_fetch(av, i)
            result.append(sv == nil ? nil : PerlSV(sv))
        }
        return result
    }
}

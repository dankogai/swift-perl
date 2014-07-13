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

class PerlAV : Printable {
    let av:UnsafePointer<()>
    init (_ sv:UnsafePointer<()>){ self.av = sv }
    func toArray()->[PerlSV?] {
        var result = [PerlSV?]()
        for i in 0..<swiftperl_av_len(av) {
            let sv = swiftperl_av_fetch(av, i)
            result.append(sv == nil ? nil : PerlSV(sv))
        }
        return result
    }
    var description:String { return "\(self.toArray())" }
}

class PerlHV {
    let hv:UnsafePointer<()>
    init (_ hv:UnsafePointer<()>){ self.hv = hv }
    func toDictionary()->[String:PerlSV?] {
        var result = [String:PerlSV?]()
        swiftperl_hv_iterinit(hv)
        while true {
            let he = swiftperl_hv_iternext(hv)
            if he == nil { break }
            let key = String.fromCString(
                CString(swiftperl_hv_iterkey(he))
                )!
            result[key] = PerlSV(swiftperl_hv_iterval(he))
        }
        return result
    }
    var description:String { return "\(self.toDictionary())" }
}

class Perl {
    var debug:Bool
    init(debug:Bool=false) {
        self.debug = debug
        swiftperl_init()
    }
    deinit  {
        if debug { println("Perl: deinitializing interpreter") }
        swiftperl_deinit()
    }
    func reinit() {
        if debug { println("Perl: reinitializing interpreter") }
        swiftperl_deinit(); swiftperl_init()
    }
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
    func av(name:String, _ add:Bool=false)->PerlAV? {
        let av = name.withCString {
            swiftperl_get_av($0, add ? 1 : 0)
        }
        return av == nil ? nil : PerlAV(av)
    }
    func hv(name:String, _ add:Bool=false)->PerlHV?? {
        let hv = name.withCString {
            swiftperl_get_hv($0, add ? 1 : 0)
        }
        return hv == nil ? nil : PerlHV(hv)
    }
}

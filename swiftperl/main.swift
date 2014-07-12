//
//  main.swift
//  swiftperl
//
//  Created by Dan Kogai on 7/12/14.
//  Copyright (c) 2014 Dan Kogai. All rights reserved.
//


Perl.sysInit()

func run(script:String) {
    let pl = Perl()
    let sv = pl.eval(script)
    println("eval \"\(script)\"")
    if !pl.evalok {
        println(" err:   \(pl.errstr)")
    } else {
        println("  !!:   \(sv.asBool)")
        println("  int:  \(sv.asInt)")
        println("  +0.0: \(sv.asDouble)")
        println("  q{}.: \(sv.asString)")
    }
}
run("reverse q(rekcaH lreP rehtonA tsuJ)")
run("atan2(0,-1)")
run("q{0 but true}")
run("my @a = (0,1,2,3)")
run("my %h = (zero => 0, one => 1)")
run("sub{ @_ }")
run("phpinfo()")

let pl = Perl()
pl.eval("our $swift = q(0.0 but rocks)")
println(pl.$("swift"))
println(pl.$("swift")?.asBool)
println(pl.$("swift")?.asDouble)
println(pl.$("objC"))
pl.eval("use Data::Dumper")
println(pl.eval("Dumper(\\%ENV)"))

Perl.sysTerm()

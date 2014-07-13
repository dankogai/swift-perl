//
//  main.swift
//  swiftperl
//
//  Created by Dan Kogai on 7/12/14.
//  Copyright (c) 2014 Dan Kogai. All rights reserved.
//

/// don't forget to do this before making a Perl instance!
Perl.sysInit()

func run(script:String) {
    let pl = Perl(debug:true)
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
run("qr/\\A(.*)\\z/msx")
run("sub{ @_ }")
run("phpinfo()")

let pl = Perl()

pl.eval("our $swift = q(0.0 but rocks)")
println(pl.$("swift"))
println(pl.$("swift")?.asBool)
println(pl.$("swift")?.asDouble)
println(pl.$("objC"))
// scalar
pl.eval("our $scalar")
let scalar = pl.sv("scalar")!
println(scalar.defined)
scalar.asBool = !scalar.asBool
pl.eval("say $scalar")
scalar.asInt *= 42
pl.eval("say $scalar")
scalar.asDouble += 0.195
pl.eval("say $scalar")
scalar.asString += "km"
pl.eval("say $scalar")
scalar.undef()
pl.eval("say $scalar")
// array
pl.eval("our @array")
let array = pl.av("array")!
array[0].asInt = 0
array[3].asInt = 3
println(pl.av("array"))
println(array.delete(0))
println(pl.av("array"))
// hash
pl.eval("our %hash")
let hash = pl.hv("hash")!
hash["zero"].asInt = 0
hash["one"].asInt = 1
println(pl.hv("hash"))
println(hash.delete("one"))
println(pl.hv("hash"))
/// reference
pl.eval("our $ref = 0")
println(pl.$("ref")!.refType)
pl.eval("$ref = \\0")
println(pl.$("ref")!.refType)
println(pl.$("ref")!.toScalar())
pl.eval("$ref = [0]")
println(pl.$("ref")!.refType)
println(pl.$("ref")!.toArray())
pl.eval("$ref = {zero=>0}")
println(pl.$("ref")!.refType)
println(pl.$("ref")!.toHash())
/// use
pl.use("Scalar::Util", "dualvar")
let dv = pl.eval("dualvar 42, q(The Answer)")
println(dv.asInt)
println(dv.asString)


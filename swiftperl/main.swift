//
//  main.swift
//  swiftperl
//
//  Created by Dan Kogai on 7/12/14.
//  Copyright (c) 2014 Dan Kogai. All rights reserved.
//

Perl.sysinit()

let pl = Perl()
pl.eval("$pi = atan2(0, -1);")
pl.eval("say $pi")
println(pl.int("pi"))
println(pl.double("pi"))
pl.eval("$t = q(0 but true)")
println(pl.int("t"))
println(pl.string("t"))
pl.preamble = "use strict;"
pl.eval("print $nonexistent")
println(pl.errstr)
pl.eval("use Data::Dumper; print Dumper(\\%ENV)")
Perl.systerm()

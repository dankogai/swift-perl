//
//  swiftperl.c
//  swiftperl
//
//  Created by Dan Kogai on 7/12/14.
//  Copyright (c) 2014 Dan Kogai. All rights reserved.
//
#include <EXTERN.h>
#include <perl.h>
EXTERN_C void xs_init (pTHX);
EXTERN_C void boot_DynaLoader (pTHX_ CV* cv);
EXTERN_C void
xs_init(pTHX)
{
    char *file = __FILE__;
    dXSUB_SYS;
    
    /* DynaLoader is a special case */
    newXS("DynaLoader::boot_DynaLoader", boot_DynaLoader, file);
}

static PerlInterpreter *my_perl = NULL;

void swiftperl_sys_init() {
    int    noc = 0;
    char **nov = NULL;
    PERL_SYS_INIT3(&noc, &nov, &nov);
}
void *swiftperl_init () {
    if (my_perl != NULL) {
        fprintf(stderr, "%s\n",
                "Multiple perl instance is not supported yet\n");
        return NULL;
    }
    char *embedding[] = { "", "-e", "1" };
    my_perl = perl_alloc();
    perl_construct(my_perl);
    perl_parse(my_perl, xs_init, 3, embedding, NULL);
    PL_exit_flags |= PERL_EXIT_DESTRUCT_END;
    perl_run(my_perl);
    return (void *)my_perl;
}
void swiftperl_deinit() {
    perl_destruct(my_perl);
    perl_free(my_perl);
    my_perl = NULL;
}
void swiftperl_sys_term() {
    if (my_perl != NULL) swiftperl_deinit();
    PERL_SYS_TERM();
}
int swiftperl_eval_pv(const char* script, I32 croak_on_error) {
    SV *result = eval_pv(script, croak_on_error);
    return SvIV(result) != 0;
}
char *swiftperl_errstr() {
    return SvPVx_nolen(ERRSV);
}
long swiftperl_getiv(char *name) {
    return (long)SvIV(get_sv(name, 0));
}
double swiftperl_getnv(char *name) {
    return (double)SvNV(get_sv(name, 0));
}
char *swiftperl_getpv(char *name) {
    return SvPV_nolen(get_sv(name, 0));
}
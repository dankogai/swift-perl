//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//
void swiftperl_sys_init();
void *swiftperl_init();
void swiftperl_deinit();
void swiftperl_sys_term();
void *swiftperl_eval_pv(const char* script, int croak_on_error);
int  swiftperl_err();
char *swiftperl_errstr();
// for PerlSV
void *swiftperl_get_sv(char *name);
int swiftperl_svdefined(void *vp);
int swiftperl_svtrue(void *vp);
unsigned long swiftperl_svuv(void *vp);
long swiftperl_sviv(void *vp);
double swiftperl_svnv(void *vp);
char *swiftperl_svpv(void *vp);

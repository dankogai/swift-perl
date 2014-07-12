//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//
void swiftperl_sys_init();
void *swiftperl_init();
void swiftperl_deinit();
void swiftperl_sys_term();
int swiftperl_eval_pv(const char* script, int croak_on_error);
char *swiftperl_errstr();
int swiftperl_getbool(char *name);
unsigned long swiftperl_getuv(char *name);
long swiftperl_getiv(char *name);
double swiftperl_getnv(char *name);
char *swiftperl_getpv(char *name);

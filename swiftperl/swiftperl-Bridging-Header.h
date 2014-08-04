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
void *swiftperl_get_sv(const char *name, int add);
int swiftperl_svok(void *vp);
int swiftperl_svtrue(void *vp);
unsigned long swiftperl_svuv(void *vp);
long swiftperl_sviv(void *vp);
double swiftperl_svnv(void *vp);
char *swiftperl_svpv(void *vp);
int swiftperl_undef(void *vp);
void swiftperl_setuv(void *vp, unsigned long uv);
void swiftperl_setiv(void *vp, long iv);
void swiftperl_setnv(void *vp, double nv);
void swiftperl_setpv(void *vp, const char *pv);
// for AV
void *swiftperl_get_av(const char *name, int add);
int swiftperl_av_len(void *vp);
void *swiftperl_av_fetch(void *vp, int key, int add);
void *swiftperl_av_delete(void *vp, int key);
// for HV
void *swiftperl_get_hv(const char *name, int add);
void *swiftperl_hv_fetchs(void *vp, const char *key, int add);
int swiftperl_hv_iterinit(void *vp);
void *swiftperl_hv_iternext(void *vp);
char *swiftperl_hv_iterkey(void *vp);
void *swiftperl_hv_iterval(void *vp);
void *swiftperl_hv_delete(void *vp, const char *key);
// for RV
char *swiftperl_reftype(void *vp);
void *swiftperl_deref(void *vp);
/*
 * dummy_terminate.c
 *
 * Code generation for function 'dummy_terminate'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "dummy.h"
#include "dummy_terminate.h"
#include "dummy_data.h"

/* Function Definitions */
void dummy_atexit(void)
{
  emlrtStack st = { NULL, NULL, NULL };

  emlrtCreateRootTLS(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1);
  st.tls = emlrtRootTLSGlobal;
  emlrtEnterRtStackR2012b(&st);
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

void dummy_terminate(void)
{
  emlrtStack st = { NULL, NULL, NULL };

  st.tls = emlrtRootTLSGlobal;
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

/* End of code generation (dummy_terminate.c) */

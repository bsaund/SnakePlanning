/*
 * simpleProd_terminate.c
 *
 * Code generation for function 'simpleProd_terminate'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "simpleProd.h"
#include "simpleProd_terminate.h"
#include "simpleProd_data.h"

/* Function Definitions */
void simpleProd_atexit(void)
{
  emlrtStack st = { NULL, NULL, NULL };

  emlrtCreateRootTLS(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1);
  st.tls = emlrtRootTLSGlobal;
  emlrtEnterRtStackR2012b(&st);
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

void simpleProd_terminate(void)
{
  emlrtStack st = { NULL, NULL, NULL };

  st.tls = emlrtRootTLSGlobal;
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

/* End of code generation (simpleProd_terminate.c) */

/*
 * dummy_initialize.c
 *
 * Code generation for function 'dummy_initialize'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "dummy.h"
#include "dummy_initialize.h"
#include "dummy_data.h"

/* Function Definitions */
void dummy_initialize(void)
{
  emlrtStack st = { NULL, NULL, NULL };

  emlrtBreakCheckR2012bFlagVar = emlrtGetBreakCheckFlagAddressR2012b();
  emlrtCreateRootTLS(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1);
  st.tls = emlrtRootTLSGlobal;
  emlrtClearAllocCountR2012b(&st, false, 0U, 0);
  emlrtEnterRtStackR2012b(&st);
  emlrtFirstTimeR2012b(emlrtRootTLSGlobal);
}

/* End of code generation (dummy_initialize.c) */

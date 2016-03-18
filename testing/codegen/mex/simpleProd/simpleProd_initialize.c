/*
 * simpleProd_initialize.c
 *
 * Code generation for function 'simpleProd_initialize'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "simpleProd.h"
#include "simpleProd_initialize.h"
#include "simpleProd_data.h"

/* Function Definitions */
void simpleProd_initialize(void)
{
  emlrtStack st = { NULL, NULL, NULL };

  emlrtBreakCheckR2012bFlagVar = emlrtGetBreakCheckFlagAddressR2012b();
  emlrtCreateRootTLS(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1);
  st.tls = emlrtRootTLSGlobal;
  emlrtClearAllocCountR2012b(&st, false, 0U, 0);
  emlrtEnterRtStackR2012b(&st);
  emlrtFirstTimeR2012b(emlrtRootTLSGlobal);
}

/* End of code generation (simpleProd_initialize.c) */

/*
 * closestPointOnWorld_initialize.c
 *
 * Code generation for function 'closestPointOnWorld_initialize'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "closestPointOnWorld.h"
#include "closestPointOnWorld_initialize.h"
#include "closestPointOnWorld_data.h"

/* Function Definitions */
void closestPointOnWorld_initialize(void)
{
  emlrtStack st = { NULL, NULL, NULL };

  emlrtBreakCheckR2012bFlagVar = emlrtGetBreakCheckFlagAddressR2012b();
  emlrtCreateRootTLS(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1);
  st.tls = emlrtRootTLSGlobal;
  emlrtClearAllocCountR2012b(&st, false, 0U, 0);
  emlrtEnterRtStackR2012b(&st);
  emlrtFirstTimeR2012b(emlrtRootTLSGlobal);
}

/* End of code generation (closestPointOnWorld_initialize.c) */

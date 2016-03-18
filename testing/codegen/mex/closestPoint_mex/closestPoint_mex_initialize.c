/*
 * closestPoint_mex_initialize.c
 *
 * Code generation for function 'closestPoint_mex_initialize'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "closestPoint.h"
#include "closestPointOnWorld.h"
#include "closestPoint_mex_initialize.h"
#include "closestPoint_mex_data.h"

/* Function Definitions */
void closestPoint_mex_initialize(void)
{
  emlrtStack st = { NULL, NULL, NULL };

  emlrtBreakCheckR2012bFlagVar = emlrtGetBreakCheckFlagAddressR2012b();
  emlrtCreateRootTLS(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1);
  st.tls = emlrtRootTLSGlobal;
  emlrtClearAllocCountR2012b(&st, false, 0U, 0);
  emlrtEnterRtStackR2012b(&st);
  emlrtFirstTimeR2012b(emlrtRootTLSGlobal);
}

/* End of code generation (closestPoint_mex_initialize.c) */

/*
 * closestPointOnWorld_terminate.c
 *
 * Code generation for function 'closestPointOnWorld_terminate'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "closestPointOnWorld.h"
#include "closestPointOnWorld_terminate.h"
#include "closestPointOnWorld_data.h"

/* Function Definitions */
void closestPointOnWorld_atexit(void)
{
  emlrtStack st = { NULL, NULL, NULL };

  emlrtCreateRootTLS(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1);
  st.tls = emlrtRootTLSGlobal;
  emlrtEnterRtStackR2012b(&st);
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

void closestPointOnWorld_terminate(void)
{
  emlrtStack st = { NULL, NULL, NULL };

  st.tls = emlrtRootTLSGlobal;
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

/* End of code generation (closestPointOnWorld_terminate.c) */

/*
 * closestPoint_terminate.c
 *
 * Code generation for function 'closestPoint_terminate'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "closestPoint.h"
#include "closestPoint_terminate.h"
#include "closestPoint_data.h"

/* Function Definitions */
void closestPoint_atexit(void)
{
  emlrtStack st = { NULL, NULL, NULL };

  emlrtCreateRootTLS(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1);
  st.tls = emlrtRootTLSGlobal;
  emlrtEnterRtStackR2012b(&st);
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

void closestPoint_terminate(void)
{
  emlrtStack st = { NULL, NULL, NULL };

  st.tls = emlrtRootTLSGlobal;
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

/* End of code generation (closestPoint_terminate.c) */

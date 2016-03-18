/*
 * _coder_closestPoint_mex_mex.c
 *
 * Code generation for function '_coder_closestPoint_mex_mex'
 *
 */

/* Include files */
#include "closestPoint.h"
#include "closestPointOnWorld.h"
#include "_coder_closestPoint_mex_mex.h"
#include "closestPoint_mex_terminate.h"
#include "_coder_closestPoint_mex_api.h"
#include "closestPoint_mex_initialize.h"
#include "closestPoint_mex_data.h"

/* Variable Definitions */
static const char * emlrtEntryPoints[2] = { "closestPoint",
  "closestPointOnWorld" };

/* Function Declarations */
static void closestPointOnWorld_mexFunction(int32_T nlhs, mxArray *plhs[1],
  int32_T nrhs, const mxArray *prhs[2]);
static void closestPoint_mexFunction(int32_T nlhs, mxArray *plhs[1], int32_T
  nrhs, const mxArray *prhs[4]);

/* Function Definitions */
static void closestPointOnWorld_mexFunction(int32_T nlhs, mxArray *plhs[1],
  int32_T nrhs, const mxArray *prhs[2])
{
  int32_T n;
  const mxArray *inputs[2];
  const mxArray *outputs[1];
  int32_T b_nlhs;
  emlrtStack st = { NULL, NULL, NULL };

  st.tls = emlrtRootTLSGlobal;

  /* Check for proper number of arguments. */
  if (nrhs != 2) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:WrongNumberOfInputs", 5, 12, 2, 4,
                        19, "closestPointOnWorld");
  }

  if (nlhs > 1) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:TooManyOutputArguments", 3, 4, 19,
                        "closestPointOnWorld");
  }

  /* Temporary copy for mex inputs. */
  for (n = 0; n < nrhs; n++) {
    inputs[n] = prhs[n];
    if (*emlrtBreakCheckR2012bFlagVar != 0) {
      emlrtBreakCheckR2012b(&st);
    }
  }

  /* Call the function. */
  closestPointOnWorld_api(inputs, outputs);

  /* Copy over outputs to the caller. */
  if (nlhs < 1) {
    b_nlhs = 1;
  } else {
    b_nlhs = nlhs;
  }

  emlrtReturnArrays(b_nlhs, plhs, outputs);

  /* Module termination. */
  closestPoint_mex_terminate();
}

static void closestPoint_mexFunction(int32_T nlhs, mxArray *plhs[1], int32_T
  nrhs, const mxArray *prhs[4])
{
  int32_T n;
  const mxArray *inputs[4];
  const mxArray *outputs[1];
  int32_T b_nlhs;
  emlrtStack st = { NULL, NULL, NULL };

  st.tls = emlrtRootTLSGlobal;

  /* Check for proper number of arguments. */
  if (nrhs != 4) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:WrongNumberOfInputs", 5, 12, 4, 4,
                        12, "closestPoint");
  }

  if (nlhs > 1) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:TooManyOutputArguments", 3, 4, 12,
                        "closestPoint");
  }

  /* Temporary copy for mex inputs. */
  for (n = 0; n < nrhs; n++) {
    inputs[n] = prhs[n];
    if (*emlrtBreakCheckR2012bFlagVar != 0) {
      emlrtBreakCheckR2012b(&st);
    }
  }

  /* Call the function. */
  closestPoint_api(inputs, outputs);

  /* Copy over outputs to the caller. */
  if (nlhs < 1) {
    b_nlhs = 1;
  } else {
    b_nlhs = nlhs;
  }

  emlrtReturnArrays(b_nlhs, plhs, outputs);

  /* Module termination. */
  closestPoint_mex_terminate();
}

void mexFunction(int32_T nlhs, mxArray *plhs[], int32_T nrhs, const mxArray
                 *prhs[])
{
  /* Initialize the memory manager. */
  mexAtExit(closestPoint_mex_atexit);

  /* Module initialization. */
  closestPoint_mex_initialize();

  /* Dispatch the entry-point. */
  switch (emlrtGetEntryPointIndex(nrhs, prhs, emlrtEntryPoints, 2)) {
   case 0:
    closestPoint_mexFunction(nlhs, plhs, nrhs - 1, &prhs[1]);
    break;

   case 1:
    closestPointOnWorld_mexFunction(nlhs, plhs, nrhs - 1, &prhs[1]);
    break;
  }
}

/* End of code generation (_coder_closestPoint_mex_mex.c) */

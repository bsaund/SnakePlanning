/*
 * _coder_closestPoint_mex.c
 *
 * Code generation for function '_coder_closestPoint_mex'
 *
 */

/* Include files */
#include "closestPoint.h"
#include "_coder_closestPoint_mex.h"
#include "closestPoint_terminate.h"
#include "_coder_closestPoint_api.h"
#include "closestPoint_initialize.h"
#include "closestPoint_data.h"

/* Function Declarations */
static void closestPoint_mexFunction(int32_T nlhs, mxArray *plhs[1], int32_T
  nrhs, const mxArray *prhs[4]);

/* Function Definitions */
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
  closestPoint_terminate();
}

void mexFunction(int32_T nlhs, mxArray *plhs[], int32_T nrhs, const mxArray
                 *prhs[])
{
  /* Initialize the memory manager. */
  mexAtExit(closestPoint_atexit);

  /* Module initialization. */
  closestPoint_initialize();

  /* Dispatch the entry-point. */
  closestPoint_mexFunction(nlhs, plhs, nrhs, prhs);
}

/* End of code generation (_coder_closestPoint_mex.c) */

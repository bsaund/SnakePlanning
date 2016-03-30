/*
 * _coder_closestPointOnWorld_mex.c
 *
 * Code generation for function '_coder_closestPointOnWorld_mex'
 *
 */

/* Include files */
#include "closestPointOnWorld.h"
#include "_coder_closestPointOnWorld_mex.h"
#include "closestPointOnWorld_terminate.h"
#include "_coder_closestPointOnWorld_api.h"
#include "closestPointOnWorld_initialize.h"
#include "closestPointOnWorld_data.h"

/* Function Declarations */
static void closestPointOnWorld_mexFunction(int32_T nlhs, mxArray *plhs[2],
  int32_T nrhs, const mxArray *prhs[2]);

/* Function Definitions */
static void closestPointOnWorld_mexFunction(int32_T nlhs, mxArray *plhs[2],
  int32_T nrhs, const mxArray *prhs[2])
{
  int32_T n;
  const mxArray *inputs[2];
  const mxArray *outputs[2];
  int32_T b_nlhs;
  emlrtStack st = { NULL, NULL, NULL };

  st.tls = emlrtRootTLSGlobal;

  /* Check for proper number of arguments. */
  if (nrhs != 2) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:WrongNumberOfInputs", 5, 12, 2, 4,
                        19, "closestPointOnWorld");
  }

  if (nlhs > 2) {
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
  closestPointOnWorld_terminate();
}

void mexFunction(int32_T nlhs, mxArray *plhs[], int32_T nrhs, const mxArray
                 *prhs[])
{
  /* Initialize the memory manager. */
  mexAtExit(closestPointOnWorld_atexit);

  /* Module initialization. */
  closestPointOnWorld_initialize();

  /* Dispatch the entry-point. */
  closestPointOnWorld_mexFunction(nlhs, plhs, nrhs, prhs);
}

/* End of code generation (_coder_closestPointOnWorld_mex.c) */

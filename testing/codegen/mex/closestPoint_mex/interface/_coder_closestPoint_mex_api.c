/*
 * _coder_closestPoint_mex_api.c
 *
 * Code generation for function '_coder_closestPoint_mex_api'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "closestPoint.h"
#include "simpleProd.h"
#include "_coder_closestPoint_mex_api.h"
#include "closestPoint_mex_data.h"

/* Function Declarations */
static real_T (*b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId))[3];
static const mxArray *b_emlrt_marshallOut(const real_T u);
static real_T c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *a, const
  char_T *identifier);
static real_T d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId);
static real_T (*e_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
  const emlrtMsgIdentifier *msgId))[3];
static real_T (*emlrt_marshallIn(const emlrtStack *sp, const mxArray *p_test,
  const char_T *identifier))[3];
static const mxArray *emlrt_marshallOut(const real_T u[3]);
static real_T f_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId);

/* Function Definitions */
static real_T (*b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId))[3]
{
  real_T (*y)[3];
  y = e_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}
  static const mxArray *b_emlrt_marshallOut(const real_T u)
{
  const mxArray *y;
  const mxArray *m2;
  y = NULL;
  m2 = emlrtCreateDoubleScalar(u);
  emlrtAssign(&y, m2);
  return y;
}

static real_T c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *a, const
  char_T *identifier)
{
  real_T y;
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = identifier;
  thisId.fParent = NULL;
  y = d_emlrt_marshallIn(sp, emlrtAlias(a), &thisId);
  emlrtDestroyArray(&a);
  return y;
}

static real_T d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId)
{
  real_T y;
  y = f_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

static real_T (*e_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
  const emlrtMsgIdentifier *msgId))[3]
{
  real_T (*ret)[3];
  int32_T iv3[1];
  iv3[0] = 3;
  emlrtCheckBuiltInR2012b(sp, msgId, src, "double", false, 1U, iv3);
  ret = (real_T (*)[3])mxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}
  static real_T (*emlrt_marshallIn(const emlrtStack *sp, const mxArray *p_test,
  const char_T *identifier))[3]
{
  real_T (*y)[3];
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = identifier;
  thisId.fParent = NULL;
  y = b_emlrt_marshallIn(sp, emlrtAlias(p_test), &thisId);
  emlrtDestroyArray(&p_test);
  return y;
}

static const mxArray *emlrt_marshallOut(const real_T u[3])
{
  const mxArray *y;
  static const int32_T iv1[1] = { 0 };

  const mxArray *m1;
  static const int32_T iv2[1] = { 3 };

  y = NULL;
  m1 = emlrtCreateNumericArray(1, iv1, mxDOUBLE_CLASS, mxREAL);
  mxSetData((mxArray *)m1, (void *)u);
  emlrtSetDimensions((mxArray *)m1, iv2, 1);
  emlrtAssign(&y, m1);
  return y;
}

static real_T f_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId)
{
  real_T ret;
  emlrtCheckBuiltInR2012b(sp, msgId, src, "double", false, 0U, 0);
  ret = *(real_T *)mxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

void closestPoint_api(const mxArray * const prhs[4], const mxArray *plhs[1])
{
  real_T (*p_plane)[3];
  real_T (*p_test)[3];
  real_T (*p1)[3];
  real_T (*p2)[3];
  real_T (*p3)[3];
  emlrtStack st = { NULL, NULL, NULL };

  st.tls = emlrtRootTLSGlobal;
  p_plane = (real_T (*)[3])mxMalloc(sizeof(real_T [3]));

  /* Marshall function inputs */
  p_test = emlrt_marshallIn(&st, emlrtAlias(prhs[0]), "p_test");
  p1 = emlrt_marshallIn(&st, emlrtAlias(prhs[1]), "p1");
  p2 = emlrt_marshallIn(&st, emlrtAlias(prhs[2]), "p2");
  p3 = emlrt_marshallIn(&st, emlrtAlias(prhs[3]), "p3");

  /* Invoke the target function */
  closestPoint(*p_test, *p1, *p2, *p3, *p_plane);

  /* Marshall function outputs */
  plhs[0] = emlrt_marshallOut(*p_plane);
}

void simpleProd_api(const mxArray * const prhs[2], const mxArray *plhs[1])
{
  real_T a;
  real_T b;
  emlrtStack st = { NULL, NULL, NULL };

  st.tls = emlrtRootTLSGlobal;

  /* Marshall function inputs */
  a = c_emlrt_marshallIn(&st, emlrtAliasP(prhs[0]), "a");
  b = c_emlrt_marshallIn(&st, emlrtAliasP(prhs[1]), "b");

  /* Invoke the target function */
  a = simpleProd(&st, a, b);

  /* Marshall function outputs */
  plhs[0] = b_emlrt_marshallOut(a);
}

/* End of code generation (_coder_closestPoint_mex_api.c) */

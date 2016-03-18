/*
 * _coder_closestPoint_mex_api.c
 *
 * Code generation for function '_coder_closestPoint_mex_api'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "closestPoint.h"
#include "closestPointOnWorld.h"
#include "_coder_closestPoint_mex_api.h"
#include "closestPoint_mex_emxutil.h"
#include "closestPoint_mex_data.h"

/* Variable Definitions */
static emlrtRTEInfo emlrtRTEI = { 1, 1, "_coder_closestPoint_mex_api", "" };

/* Function Declarations */
static real_T (*b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId))[3];
static void c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *world, const
  char_T *identifier, struct0_T *y);
static void d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, struct0_T *y);
static void e_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_real_T *y);
static real_T (*emlrt_marshallIn(const emlrtStack *sp, const mxArray *p_test,
  const char_T *identifier))[3];
static const mxArray *emlrt_marshallOut(const real_T u[3]);
static real_T (*f_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
  const emlrtMsgIdentifier *msgId))[3];
static void g_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, emxArray_real_T *ret);

/* Function Definitions */
static real_T (*b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId))[3]
{
  real_T (*y)[3];
  y = f_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}
  static void c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *world,
  const char_T *identifier, struct0_T *y)
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = identifier;
  thisId.fParent = NULL;
  d_emlrt_marshallIn(sp, emlrtAlias(world), &thisId, y);
  emlrtDestroyArray(&world);
}

static void d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, struct0_T *y)
{
  emlrtMsgIdentifier thisId;
  static const char * fieldNames[2] = { "faces", "vertices" };

  thisId.fParent = parentId;
  emlrtCheckStructR2012b(sp, parentId, u, 2, fieldNames, 0U, 0);
  thisId.fIdentifier = "faces";
  e_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2013a(sp, u, 0, "faces")),
                     &thisId, y->faces);
  thisId.fIdentifier = "vertices";
  e_emlrt_marshallIn(sp, emlrtAlias(emlrtGetFieldR2013a(sp, u, 0, "vertices")),
                     &thisId, y->vertices);
  emlrtDestroyArray(&u);
}

static void e_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_real_T *y)
{
  g_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
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
  static const int32_T iv0[1] = { 0 };

  const mxArray *m0;
  static const int32_T iv1[1] = { 3 };

  y = NULL;
  m0 = emlrtCreateNumericArray(1, iv0, mxDOUBLE_CLASS, mxREAL);
  mxSetData((mxArray *)m0, (void *)u);
  emlrtSetDimensions((mxArray *)m0, iv1, 1);
  emlrtAssign(&y, m0);
  return y;
}

static real_T (*f_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
  const emlrtMsgIdentifier *msgId))[3]
{
  real_T (*ret)[3];
  int32_T iv2[1];
  iv2[0] = 3;
  emlrtCheckBuiltInR2012b(sp, msgId, src, "double", false, 1U, iv2);
  ret = (real_T (*)[3])mxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}
  static void g_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, emxArray_real_T *ret)
{
  int32_T iv3[2];
  int32_T i1;
  int32_T iv4[2];
  boolean_T bv0[2] = { true, false };

  for (i1 = 0; i1 < 2; i1++) {
    iv3[i1] = (i1 << 2) - 1;
  }

  emlrtCheckVsBuiltInR2012b(sp, msgId, src, "double", false, 2U, iv3, &bv0[0],
    iv4);
  i1 = ret->size[0] * ret->size[1];
  ret->size[0] = iv4[0];
  ret->size[1] = iv4[1];
  emxEnsureCapacity(sp, (emxArray__common *)ret, i1, (int32_T)sizeof(real_T),
                    (emlrtRTEInfo *)NULL);
  emlrtImportArrayR2011b(src, ret->data, 8, false);
  emlrtDestroyArray(&src);
}

void closestPointOnWorld_api(const mxArray * const prhs[2], const mxArray *plhs
  [1])
{
  real_T (*p)[3];
  struct0_T world;
  real_T (*p_test)[3];
  emlrtStack st = { NULL, NULL, NULL };

  st.tls = emlrtRootTLSGlobal;
  p = (real_T (*)[3])mxMalloc(sizeof(real_T [3]));
  emlrtHeapReferenceStackEnterFcnR2012b(&st);
  emxInitStruct_struct0_T(&st, &world, &emlrtRTEI, true);

  /* Marshall function inputs */
  p_test = emlrt_marshallIn(&st, emlrtAlias(prhs[0]), "p_test");
  c_emlrt_marshallIn(&st, emlrtAliasP(prhs[1]), "world", &world);

  /* Invoke the target function */
  closestPointOnWorld(&st, *p_test, &world, *p);

  /* Marshall function outputs */
  plhs[0] = emlrt_marshallOut(*p);
  emxFreeStruct_struct0_T(&world);
  emlrtHeapReferenceStackLeaveFcnR2012b(&st);
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

/* End of code generation (_coder_closestPoint_mex_api.c) */

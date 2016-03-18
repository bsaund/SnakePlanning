/*
 * simpleProd.c
 *
 * Code generation for function 'simpleProd'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "closestPoint.h"
#include "simpleProd.h"

/* Variable Definitions */
static emlrtMCInfo emlrtMCI = { 4, 1, "simpleProd",
  "C:\\Users\\Brad\\Documents\\Work\\CMU\\SnakePlanning\\testing\\simpleProd.m"
};

static emlrtRSInfo emlrtRSI = { 4, "simpleProd",
  "C:\\Users\\Brad\\Documents\\Work\\CMU\\SnakePlanning\\testing\\simpleProd.m"
};

/* Function Declarations */
static void disp(const emlrtStack *sp, const mxArray *b, emlrtMCInfo *location);

/* Function Definitions */
static void disp(const emlrtStack *sp, const mxArray *b, emlrtMCInfo *location)
{
  const mxArray *pArray;
  pArray = b;
  emlrtCallMATLABR2012b(sp, 0, NULL, 1, &pArray, "disp", true, location);
}

real_T simpleProd(const emlrtStack *sp, real_T a, real_T b)
{
  real_T c;
  int32_T i0;
  static const char_T cv0[28] = { 'T', 'h', 'i', 's', ' ', 'i', 's', ' ', 'n',
    'o', 't', ' ', 't', 'h', 'e', ' ', 'm', 'e', 'x', ' ', 'f', 'u', 'n', 'c',
    't', 'i', 'o', 'n' };

  char_T u[28];
  const mxArray *y;
  static const int32_T iv0[2] = { 1, 28 };

  const mxArray *m0;
  emlrtStack st;
  st.prev = sp;
  st.tls = sp->tls;
  c = a * b;
  for (i0 = 0; i0 < 28; i0++) {
    u[i0] = cv0[i0];
  }

  y = NULL;
  m0 = emlrtCreateCharArray(2, iv0);
  emlrtInitCharArrayR2013a(sp, 28, m0, &u[0]);
  emlrtAssign(&y, m0);
  st.site = &emlrtRSI;
  disp(&st, y, &emlrtMCI);
  return c;
}

/* End of code generation (simpleProd.c) */

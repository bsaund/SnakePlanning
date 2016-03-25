/*
 * closestPoint.c
 *
 * Code generation for function 'closestPoint'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "closestPoint.h"
#include "closestPointOnWorld.h"

/* Function Definitions */
void closestPoint(const real_T p_test[3], const real_T p1[3], const real_T p2[3],
                  const real_T p3[3], real_T p_plane[3])
{
  real_T a;
  real_T b;
  real_T c;
  real_T d;
  real_T e;
  real_T E1[3];
  int32_T i;
  real_T b_p_plane;
  real_T b_E1;
  real_T D;
  real_T det;
  real_T s;
  real_T t;
  real_T invDet;
  real_T tmp0;
  real_T tmp1;

  /* CLOSESTPOINT returns the closest points to p_test on the triangle */
  /* defined by p1, p2, and p3. All points are column vectors. */
  /* This uses the algorithm from: */
  /* http://www.geometrictools.com/Documentation/DistancePoint3Triangle3.pdf */
  /*      a = dot(E0,E0); */
  /*      b = dot(E0,E1); */
  /*      c = dot(E1,E1); */
  /*      d = dot(E0,D); */
  /*      e = dot(E1,D); */
  a = 0.0;
  b = 0.0;
  c = 0.0;
  d = 0.0;
  e = 0.0;
  for (i = 0; i < 3; i++) {
    b_p_plane = p2[i] - p1[i];
    b_E1 = p3[i] - p1[i];
    D = p1[i] - p_test[i];
    a += b_p_plane * b_p_plane;
    b += b_p_plane * b_E1;
    c += b_E1 * b_E1;
    d += b_p_plane * D;
    e += b_E1 * D;
    p_plane[i] = b_p_plane;
    E1[i] = b_E1;
  }

  /*      f = dot(D,D); */
  det = a * c - b * b;
  s = b * e - c * d;
  t = b * d - a * e;
  if (s + t < det) {
    if (s < 0.0) {
      if (t < 0.0) {
        /*  region = 4 */
        if (d < 0.0) {
          s = muDoubleScalarMin(muDoubleScalarMax(-d / a, 0.0), 1.0);
          t = 0.0;
        } else {
          s = 0.0;
          t = muDoubleScalarMin(muDoubleScalarMax(-e / c, 0.0), 1.0);
        }
      } else {
        /*  region = 3 */
        s = 0.0;
        t = muDoubleScalarMin(muDoubleScalarMax(-e / c, 0.0), 1.0);
      }
    } else if (t < 0.0) {
      /*  region = 5 */
      s = muDoubleScalarMin(muDoubleScalarMax(-d / a, 0.0), 1.0);
      t = 0.0;
    } else {
      /*  region = 0 */
      invDet = 1.0 / det;
      s *= invDet;
      t *= invDet;
    }
  } else if (s < 0.0) {
    /*  region = 2 */
    tmp0 = b + d;
    tmp1 = c + e;
    if (tmp1 > tmp0) {
      s = muDoubleScalarMin(muDoubleScalarMax((tmp1 - tmp0) / ((a - 2.0 * b) + c),
        0.0), 1.0);
      t = 1.0 - s;
    } else {
      s = 0.0;
      t = muDoubleScalarMin(muDoubleScalarMax(-e / c, 0.0), 1.0);
    }
  } else if (t < 0.0) {
    /*  region = 6 */
    tmp0 = b + e;
    tmp1 = a + d;
    if (tmp1 > tmp0) {
      t = muDoubleScalarMin(muDoubleScalarMax((tmp1 - tmp0) / ((a - 2.0 * b) + c),
        0.0), 1.0);
      s = 1.0 - t;
    } else {
      t = 0.0;
      s = muDoubleScalarMin(muDoubleScalarMax(-d / a, 0.0), 1.0);
    }
  } else {
    /*  region = 1 */
    s = muDoubleScalarMin(muDoubleScalarMax((((c + e) - b) - d) / ((a - 2.0 * b)
      + c), 0.0), 1.0);
    t = 1.0 - s;
  }

  for (i = 0; i < 3; i++) {
    p_plane[i] = (p1[i] + p_plane[i] * s) + E1[i] * t;
  }
}

/* End of code generation (closestPoint.c) */

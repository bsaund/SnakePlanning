/*
 * closestPointOnWorld.c
 *
 * Code generation for function 'closestPointOnWorld'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "closestPointOnWorld.h"
#include "closestPoint.h"
#include "closestPointOnWorld_data.h"

/* Variable Definitions */
static emlrtDCInfo emlrtDCI = { 16, 15, "closestPointOnWorld",
  "C:\\Users\\Brad\\Documents\\Work\\CMU\\SnakePlanning\\mexBuilding\\closestPointOnWorld.m",
  1 };

static emlrtBCInfo emlrtBCI = { -1, -1, 16, 15, "v", "closestPointOnWorld",
  "C:\\Users\\Brad\\Documents\\Work\\CMU\\SnakePlanning\\mexBuilding\\closestPointOnWorld.m",
  0 };

static emlrtDCInfo b_emlrtDCI = { 17, 15, "closestPointOnWorld",
  "C:\\Users\\Brad\\Documents\\Work\\CMU\\SnakePlanning\\mexBuilding\\closestPointOnWorld.m",
  1 };

static emlrtBCInfo b_emlrtBCI = { -1, -1, 17, 15, "v", "closestPointOnWorld",
  "C:\\Users\\Brad\\Documents\\Work\\CMU\\SnakePlanning\\mexBuilding\\closestPointOnWorld.m",
  0 };

static emlrtDCInfo c_emlrtDCI = { 18, 15, "closestPointOnWorld",
  "C:\\Users\\Brad\\Documents\\Work\\CMU\\SnakePlanning\\mexBuilding\\closestPointOnWorld.m",
  1 };

static emlrtBCInfo c_emlrtBCI = { -1, -1, 18, 15, "v", "closestPointOnWorld",
  "C:\\Users\\Brad\\Documents\\Work\\CMU\\SnakePlanning\\mexBuilding\\closestPointOnWorld.m",
  0 };

static emlrtBCInfo d_emlrtBCI = { -1, -1, 16, 17, "f", "closestPointOnWorld",
  "C:\\Users\\Brad\\Documents\\Work\\CMU\\SnakePlanning\\mexBuilding\\closestPointOnWorld.m",
  0 };

static emlrtBCInfo e_emlrtBCI = { -1, -1, 17, 17, "f", "closestPointOnWorld",
  "C:\\Users\\Brad\\Documents\\Work\\CMU\\SnakePlanning\\mexBuilding\\closestPointOnWorld.m",
  0 };

static emlrtBCInfo f_emlrtBCI = { -1, -1, 18, 17, "f", "closestPointOnWorld",
  "C:\\Users\\Brad\\Documents\\Work\\CMU\\SnakePlanning\\mexBuilding\\closestPointOnWorld.m",
  0 };

/* Function Definitions */
void closestPointOnWorld(const emlrtStack *sp, const real_T p_test[3], const
  struct0_T *world, real_T p[3], real_T *best_face)
{
  real_T d;
  int32_T i;
  int32_T i0;
  int32_T b_i;
  real_T d0;
  int32_T c_i;
  real_T b_world[3];
  int32_T d_i;
  real_T c_world[3];
  int32_T e_i;
  real_T d_world[3];
  real_T p_temp[3];
  real_T d_temp;

  /* CLOSESTPOINTONWORLD finds the closest point to p_test that lies on */
  /* the mesh 'world'. world should be a struct of faces and vertices, */
  /* the same struct you might pass to matlab's 'patch' */
  *best_face = 0.0;
  d = rtInf;
  for (i = 0; i < 3; i++) {
    p[i] = 0.0;
  }

  i = 1;
  while (i - 1 <= world->faces->size[0] - 1) {
    i0 = world->faces->size[0];
    if ((i >= 1) && (i < i0)) {
      b_i = i;
    } else {
      b_i = emlrtDynamicBoundsCheckR2012b(i, 1, i0, &d_emlrtBCI, sp);
    }

    d0 = world->faces->data[b_i - 1];
    i0 = world->vertices->size[0];
    if (d0 == (int32_T)muDoubleScalarFloor(d0)) {
      c_i = (int32_T)d0;
    } else {
      c_i = (int32_T)emlrtIntegerCheckR2012b(d0, &emlrtDCI, sp);
    }

    if ((c_i >= 1) && (c_i < i0)) {
    } else {
      c_i = emlrtDynamicBoundsCheckR2012b(c_i, 1, i0, &emlrtBCI, sp);
    }

    for (i0 = 0; i0 < 3; i0++) {
      b_world[i0] = world->vertices->data[(c_i + world->vertices->size[0] * i0)
        - 1];
    }

    i0 = world->faces->size[0];
    if ((i >= 1) && (i < i0)) {
      d_i = i;
    } else {
      d_i = emlrtDynamicBoundsCheckR2012b(i, 1, i0, &e_emlrtBCI, sp);
    }

    d0 = world->faces->data[(d_i + world->faces->size[0]) - 1];
    i0 = world->vertices->size[0];
    if (d0 == (int32_T)muDoubleScalarFloor(d0)) {
      c_i = (int32_T)d0;
    } else {
      c_i = (int32_T)emlrtIntegerCheckR2012b(d0, &b_emlrtDCI, sp);
    }

    if ((c_i >= 1) && (c_i < i0)) {
    } else {
      c_i = emlrtDynamicBoundsCheckR2012b(c_i, 1, i0, &b_emlrtBCI, sp);
    }

    for (i0 = 0; i0 < 3; i0++) {
      c_world[i0] = world->vertices->data[(c_i + world->vertices->size[0] * i0)
        - 1];
    }

    i0 = world->faces->size[0];
    if ((i >= 1) && (i < i0)) {
      e_i = i;
    } else {
      e_i = emlrtDynamicBoundsCheckR2012b(i, 1, i0, &f_emlrtBCI, sp);
    }

    d0 = world->faces->data[(e_i + (world->faces->size[0] << 1)) - 1];
    i0 = world->vertices->size[0];
    if (d0 == (int32_T)muDoubleScalarFloor(d0)) {
      c_i = (int32_T)d0;
    } else {
      c_i = (int32_T)emlrtIntegerCheckR2012b(d0, &c_emlrtDCI, sp);
    }

    if ((c_i >= 1) && (c_i < i0)) {
    } else {
      c_i = emlrtDynamicBoundsCheckR2012b(c_i, 1, i0, &c_emlrtBCI, sp);
    }

    for (i0 = 0; i0 < 3; i0++) {
      d_world[i0] = world->vertices->data[(c_i + world->vertices->size[0] * i0)
        - 1];
    }

    closestPoint(p_test, b_world, c_world, d_world, p_temp);
    d_temp = 0.0;
    for (i0 = 0; i0 < 3; i0++) {
      d_temp += (p_test[i0] - p_temp[i0]) * (p_test[i0] - p_temp[i0]);
    }

    if (d_temp < d) {
      d = d_temp;
      for (c_i = 0; c_i < 3; c_i++) {
        p[c_i] = p_temp[c_i];
      }

      *best_face = 1.0 + (real_T)(i - 1);
    }

    i++;
    if (*emlrtBreakCheckR2012bFlagVar != 0) {
      emlrtBreakCheckR2012b(sp);
    }
  }
}

/* End of code generation (closestPointOnWorld.c) */

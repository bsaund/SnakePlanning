/*
 * closestPointOnWorld_emxAPI.h
 *
 * Code generation for function 'closestPointOnWorld_emxAPI'
 *
 */

#ifndef __CLOSESTPOINTONWORLD_EMXAPI_H__
#define __CLOSESTPOINTONWORLD_EMXAPI_H__

/* Include files */
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include "rtwtypes.h"
#include "closestPointOnWorld_types.h"

/* Function Declarations */
extern emxArray_real_T *emxCreateND_real_T(int numDimensions, int *size);
extern emxArray_real_T *emxCreateWrapperND_real_T(double *data, int
  numDimensions, int *size);
extern emxArray_real_T *emxCreateWrapper_real_T(double *data, int rows, int cols);
extern emxArray_real_T *emxCreate_real_T(int rows, int cols);
extern void emxDestroyArray_real_T(emxArray_real_T *emxArray);
extern void emxDestroy_struct0_T(struct0_T emxArray);
extern void emxInit_struct0_T(struct0_T *pStruct);

#endif

/* End of code generation (closestPointOnWorld_emxAPI.h) */

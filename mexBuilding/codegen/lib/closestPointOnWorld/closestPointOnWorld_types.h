/*
 * closestPointOnWorld_types.h
 *
 * Code generation for function 'closestPointOnWorld'
 *
 */

#ifndef __CLOSESTPOINTONWORLD_TYPES_H__
#define __CLOSESTPOINTONWORLD_TYPES_H__

/* Include files */
#include "rtwtypes.h"

/* Type Definitions */
#ifndef struct_emxArray_real_T
#define struct_emxArray_real_T

struct emxArray_real_T
{
  double *data;
  int *size;
  int allocatedSize;
  int numDimensions;
  boolean_T canFreeData;
};

#endif                                 /*struct_emxArray_real_T*/

#ifndef typedef_emxArray_real_T
#define typedef_emxArray_real_T

typedef struct emxArray_real_T emxArray_real_T;

#endif                                 /*typedef_emxArray_real_T*/

#ifndef typedef_struct0_T
#define typedef_struct0_T

typedef struct {
  emxArray_real_T *faces;
  emxArray_real_T *vertices;
} struct0_T;

#endif                                 /*typedef_struct0_T*/
#endif

/* End of code generation (closestPointOnWorld_types.h) */

/*
 * closestPointOnWorld_emxutil.c
 *
 * Code generation for function 'closestPointOnWorld_emxutil'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "closestPointOnWorld.h"
#include "closestPointOnWorld_emxutil.h"

/* Function Definitions */
void emxFreeStruct_struct0_T(struct0_T *pStruct)
{
  emxFree_real_T(&pStruct->faces);
  emxFree_real_T(&pStruct->vertices);
}

void emxFree_real_T(emxArray_real_T **pEmxArray)
{
  if (*pEmxArray != (emxArray_real_T *)NULL) {
    if (((*pEmxArray)->data != (double *)NULL) && (*pEmxArray)->canFreeData) {
      free((void *)(*pEmxArray)->data);
    }

    free((void *)(*pEmxArray)->size);
    free((void *)*pEmxArray);
    *pEmxArray = (emxArray_real_T *)NULL;
  }
}

void emxInitStruct_struct0_T(struct0_T *pStruct)
{
  emxInit_real_T(&pStruct->faces, 2);
  emxInit_real_T(&pStruct->vertices, 2);
}

void emxInit_real_T(emxArray_real_T **pEmxArray, int numDimensions)
{
  emxArray_real_T *emxArray;
  int i;
  *pEmxArray = (emxArray_real_T *)malloc(sizeof(emxArray_real_T));
  emxArray = *pEmxArray;
  emxArray->data = (double *)NULL;
  emxArray->numDimensions = numDimensions;
  emxArray->size = (int *)malloc((unsigned int)(sizeof(int) * numDimensions));
  emxArray->allocatedSize = 0;
  emxArray->canFreeData = true;
  for (i = 0; i < numDimensions; i++) {
    emxArray->size[i] = 0;
  }
}

/* End of code generation (closestPointOnWorld_emxutil.c) */

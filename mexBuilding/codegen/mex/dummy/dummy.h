/*
 * dummy.h
 *
 * Code generation for function 'dummy'
 *
 */

#ifndef __DUMMY_H__
#define __DUMMY_H__

/* Include files */
#include <math.h>
#include <stdlib.h>
#include <string.h>
#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"
#include "blas.h"
#include "rtwtypes.h"
#include "dummy_types.h"

/* Function Declarations */
extern real_T dummy(real_T a, real_T b);

#ifdef __WATCOMC__

#pragma aux dummy value [8087];

#endif
#endif

/* End of code generation (dummy.h) */

/*
 * main.c
 *
 * Code generation for function 'main'
 *
 */

/*************************************************************************/
/* This automatically generated example C main file shows how to call    */
/* entry-point functions that MATLAB Coder generated. You must customize */
/* this file for your application. Do not modify this file directly.     */
/* Instead, make a copy of this file, modify it, and integrate it into   */
/* your development environment.                                         */
/*                                                                       */
/* This file initializes entry-point function arguments to a default     */
/* size and value before calling the entry-point functions. It does      */
/* not store or use any values returned from the entry-point functions.  */
/* If necessary, it does pre-allocate memory for returned values.        */
/* You can use this file as a starting point for a main function that    */
/* you can deploy in your application.                                   */
/*                                                                       */
/* After you copy the file, and before you deploy it, you must make the  */
/* following changes:                                                    */
/* * For variable-size function arguments, change the example sizes to   */
/* the sizes that your application requires.                             */
/* * Change the example values of function arguments to the values that  */
/* your application requires.                                            */
/* * If the entry-point functions return values, store these values or   */
/* otherwise use them as required by your application.                   */
/*                                                                       */
/*************************************************************************/
/* Include files */
#include "rt_nonfinite.h"
#include "closestPointOnWorld.h"
#include "main.h"
#include "closestPointOnWorld_terminate.h"
#include "closestPointOnWorld_emxAPI.h"
#include "closestPointOnWorld_initialize.h"

/* Function Declarations */
static void argInit_3x1_real_T(double result[3]);
static emxArray_real_T *argInit_Unboundedx3_real_T(void);
static double argInit_real_T(void);
static struct0_T argInit_struct0_T(void);
static void main_closestPointOnWorld(void);

/* Function Definitions */
static void argInit_3x1_real_T(double result[3])
{
  int b_j0;

  /* Loop over the array to initialize each element. */
  for (b_j0 = 0; b_j0 < 3; b_j0++) {
    /* Set the value of the array element.
       Change this value to the value that the application requires. */
    result[b_j0] = argInit_real_T();
  }
}

static emxArray_real_T *argInit_Unboundedx3_real_T(void)
{
  emxArray_real_T *result;
  static int iv0[2] = { 2, 3 };

  int b_j0;
  int b_j1;

  /* Set the size of the array.
     Change this size to the value that the application requires. */
  result = emxCreateND_real_T(2, iv0);

  /* Loop over the array to initialize each element. */
  for (b_j0 = 0; b_j0 < result->size[0U]; b_j0++) {
    for (b_j1 = 0; b_j1 < 3; b_j1++) {
      /* Set the value of the array element.
         Change this value to the value that the application requires. */
      result->data[b_j0 + result->size[0] * b_j1] = argInit_real_T();
    }
  }

  return result;
}

static double argInit_real_T(void)
{
  return 0.0;
}

static struct0_T argInit_struct0_T(void)
{
  struct0_T result;

  /* Set the value of each structure field.
     Change this value to the value that the application requires. */
  result.faces = argInit_Unboundedx3_real_T();
  result.vertices = argInit_Unboundedx3_real_T();
  return result;
}

static void main_closestPointOnWorld(void)
{
  double p_test[3];
  struct0_T world;
  double p[3];

  /* Initialize function 'closestPointOnWorld' input arguments. */
  /* Initialize function input argument 'p_test'. */
  argInit_3x1_real_T(p_test);

  /* Initialize function input argument 'world'. */
  world = argInit_struct0_T();

  /* Call the entry-point 'closestPointOnWorld'. */
  closestPointOnWorld(p_test, &world, p);
  emxDestroy_struct0_T(world);
}

int main(int argc, const char * const argv[])
{
  (void)argc;
  (void)argv;

  /* Initialize the application.
     You do not need to do this more than one time. */
  closestPointOnWorld_initialize();

  /* Invoke the entry-point functions.
     You can call entry-point functions multiple times. */
  main_closestPointOnWorld();

  /* Terminate the application.
     You do not need to do this more than one time. */
  closestPointOnWorld_terminate();
  return 0;
}

/* End of code generation (main.c) */

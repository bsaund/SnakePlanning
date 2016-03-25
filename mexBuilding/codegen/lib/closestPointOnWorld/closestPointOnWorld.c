/*
 * closestPointOnWorld.c
 *
 * Code generation for function 'closestPointOnWorld'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "closestPointOnWorld.h"

/* Function Definitions */
void closestPointOnWorld(const double p_test[3], const struct0_T *world, double
  p[3])
{
  double d;
  int i;
  int b_i;
  int b_world;
  int c_world;
  int d_world;
  int e_world;
  double d0;
  double E0[3];
  double E1[3];
  double D[3];
  int i0;
  double b_E0;
  double y;
  double d1;
  double d2;
  double d3;
  double det;
  double s;
  double t;
  double invDet;
  double tmp0;
  double tmp1;

  /* CLOSESTPOINTONWORLD finds the closest point to p_test that lies on */
  /* the mesh 'world'. world should be a struct of faces and vertices, */
  /* the same struct you might pass to matlab's 'patch' */
  d = rtInf;
  for (i = 0; i < 3; i++) {
    p[i] = 0.0;
  }

  for (i = 0; i < world->faces->size[0]; i++) {
    /* CLOSESTPOINT returns the closest points to p_test on the triangle */
    /* defined by p1, p2, and p3. All points are column vectors. */
    /* This uses the algorithm from: */
    /* http://www.geometrictools.com/Documentation/DistancePoint3Triangle3.pdf */
    b_i = (int)world->faces->data[i + world->faces->size[0]];
    b_world = (int)world->faces->data[i];
    c_world = (int)world->faces->data[i + (world->faces->size[0] << 1)];
    d_world = (int)world->faces->data[i];
    e_world = (int)world->faces->data[i];

    /*      a = dot(E0,E0); */
    /*      b = dot(E0,E1); */
    /*      c = dot(E1,E1); */
    /*      d = dot(E0,D); */
    /*      e = dot(E1,D); */
    d0 = 0.0;
    for (i0 = 0; i0 < 3; i0++) {
      b_E0 = world->vertices->data[(b_i + world->vertices->size[0] * i0) - 1] -
        world->vertices->data[(b_world + world->vertices->size[0] * i0) - 1];
      E1[i0] = world->vertices->data[(c_world + world->vertices->size[0] * i0) -
        1] - world->vertices->data[(d_world + world->vertices->size[0] * i0) - 1];
      D[i0] = world->vertices->data[(e_world + world->vertices->size[0] * i0) -
        1] - p_test[i0];
      d0 += b_E0 * b_E0;
      E0[i0] = b_E0;
    }

    y = 0.0;
    for (i0 = 0; i0 < 3; i0++) {
      y += E0[i0] * E1[i0];
    }

    d1 = 0.0;
    for (i0 = 0; i0 < 3; i0++) {
      d1 += E1[i0] * E1[i0];
    }

    d2 = 0.0;
    for (i0 = 0; i0 < 3; i0++) {
      d2 += E0[i0] * D[i0];
    }

    d3 = 0.0;
    for (i0 = 0; i0 < 3; i0++) {
      d3 += E1[i0] * D[i0];
    }

    /*      f = dot(D,D); */
    det = d0 * d1 - y * y;
    s = y * d3 - d1 * d2;
    t = y * d2 - d0 * d3;
    if (s + t < det) {
      if (s < 0.0) {
        if (t < 0.0) {
          /*  region = 4 */
          if (d2 < 0.0) {
            y = -d2 / d0;
            if (y >= 0.0) {
            } else {
              y = 0.0;
            }

            if (y <= 1.0) {
              s = y;
            } else {
              s = 1.0;
            }

            t = 0.0;
          } else {
            s = 0.0;
            y = -d3 / d1;
            if (y >= 0.0) {
            } else {
              y = 0.0;
            }

            if (y <= 1.0) {
              t = y;
            } else {
              t = 1.0;
            }
          }
        } else {
          /*  region = 3 */
          s = 0.0;
          y = -d3 / d1;
          if (y >= 0.0) {
          } else {
            y = 0.0;
          }

          if (y <= 1.0) {
            t = y;
          } else {
            t = 1.0;
          }
        }
      } else if (t < 0.0) {
        /*  region = 5 */
        y = -d2 / d0;
        if (y >= 0.0) {
        } else {
          y = 0.0;
        }

        if (y <= 1.0) {
          s = y;
        } else {
          s = 1.0;
        }

        t = 0.0;
      } else {
        /*  region = 0 */
        invDet = 1.0 / det;
        s *= invDet;
        t *= invDet;
      }
    } else if (s < 0.0) {
      /*  region = 2 */
      tmp0 = y + d2;
      tmp1 = d1 + d3;
      if (tmp1 > tmp0) {
        y = (tmp1 - tmp0) / ((d0 - 2.0 * y) + d1);
        if (y >= 0.0) {
        } else {
          y = 0.0;
        }

        if (y <= 1.0) {
          s = y;
        } else {
          s = 1.0;
        }

        t = 1.0 - s;
      } else {
        s = 0.0;
        y = -d3 / d1;
        if (y >= 0.0) {
        } else {
          y = 0.0;
        }

        if (y <= 1.0) {
          t = y;
        } else {
          t = 1.0;
        }
      }
    } else if (t < 0.0) {
      /*  region = 6 */
      tmp0 = y + d3;
      tmp1 = d0 + d2;
      if (tmp1 > tmp0) {
        y = (tmp1 - tmp0) / ((d0 - 2.0 * y) + d1);
        if (y >= 0.0) {
        } else {
          y = 0.0;
        }

        if (y <= 1.0) {
          t = y;
        } else {
          t = 1.0;
        }

        s = 1.0 - t;
      } else {
        t = 0.0;
        y = -d2 / d0;
        if (y >= 0.0) {
        } else {
          y = 0.0;
        }

        if (y <= 1.0) {
          s = y;
        } else {
          s = 1.0;
        }
      }
    } else {
      /*  region = 1 */
      y = (((d1 + d3) - y) - d2) / ((d0 - 2.0 * y) + d1);
      if (y >= 0.0) {
      } else {
        y = 0.0;
      }

      if (y <= 1.0) {
        s = y;
      } else {
        s = 1.0;
      }

      t = 1.0 - s;
    }

    b_i = (int)world->faces->data[i];
    d0 = 0.0;
    for (i0 = 0; i0 < 3; i0++) {
      b_E0 = (world->vertices->data[(b_i + world->vertices->size[0] * i0) - 1] +
              E0[i0] * s) + E1[i0] * t;
      d0 += (p_test[i0] - b_E0) * (p_test[i0] - b_E0);
      E0[i0] = b_E0;
    }

    if (d0 < d) {
      d = d0;
      for (b_i = 0; b_i < 3; b_i++) {
        p[b_i] = E0[b_i];
      }
    }
  }
}

/* End of code generation (closestPointOnWorld.c) */

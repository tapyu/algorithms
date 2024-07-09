#!/usr/bin/zsh

for urldirectory filename urlfile in {\
'Ch08_geometric_probs','Section 8.1.1: Separating a point from a polyhedron.m','separate_pt_poly.m',\
'Ch08_geometric_probs','Section 8.2.2: Separating polyhedra in 2D.m','separate_poly_2D.m',\
'Ch08_geometric_probs','Section 8.5.3: Analytic center of a set of linear inequalities.m','analytic_center.m',\
'Ch08_geometric_probs','Figure 8.10: Approximate linear discrimination via linear programming.m','svm_1.m',\
'Ch08_geometric_probs','Figure 8.11: Approximate linear discrimination via support vector classifier.m','svm_2.m',\
'Ch08_geometric_probs','Figure 8.15: Linear placement problem.m','placement_lin.m',\
'Ch08_geometric_probs','Figure 8.16: Quadratic placement problem.m','placement_quad.m',\
'Ch08_geometric_probs','Figure 8.17: Fourth-order placement problem.m','placement_quar.m',\
'Ch08_geometric_probs','Figure 8.8: Simplest linear discrimination.m','linear_discr.m',\
'Ch08_geometric_probs','Figure 8.9: Robust linear discrimination problem.m','robust_lin_discr.m',\
'Ch08_geometric_probs','Example 8.3: Bounding correlation coefficients.m','ex_8_3.m',\
'Ch08_geometric_probs','Example 8.4: One free point localization.m','ex_8_4.m',\
'Ch08_geometric_probs','Example 8.7: Floorplan generation test script.m','test_floorplan.m',\
'Ch08_geometric_probs','Euclidean distance between polyhedra.m','eucl_dist_poly.m',\
'Ch08_geometric_probs','Euclidean distance between polyhedra in 2D.m','eucl_dist_poly_2D.m',\
'Ch08_geometric_probs','Euclidean projection on a halfspace.m','eucl_proj_hlf.m',\
'Ch08_geometric_probs','Euclidean projection on a hyperplane.m','eucl_proj_hyp.m',\
'Ch08_geometric_probs','Euclidean projection on a rectangle.m','eucl_proj_rect.m',\
'Ch08_geometric_probs','Euclidean projection on the nonnegative orthant.m','eucl_proj_cone1.m',\
'Ch08_geometric_probs','Euclidean projection on the semidefinite cone.m','eucl_proj_cone2.m',\
'Ch08_geometric_probs','Floor planning.m','floor_plan.m',\
'Ch08_geometric_probs','Maximum volume inscribed ellipsoid in a polyhedron.m','max_vol_ellip_in_polyhedra.m',\
'Ch08_geometric_probs','Minimum volume ellipsoid covering a finite set.m','min_vol_elp_finite_set.m',\
'Ch08_geometric_probs','Minimum volume ellipsoid covering union of ellipsoids.m','min_vol_union_ellip.m',\
'Ch08_geometric_probs','One free point localization.m','ex_8_5.m',\
'Ch08_geometric_probs','Polynomial discrimination.m','poly3_discr.m',\
'Ch08_geometric_probs','Polynomial discrimination.m','poly4_discr.m',\
'Ch08_geometric_probs','Quadratic discrimination.m (separating ellipsoid).m','quad_discr.m',\
'Ch08_geometric_probs','Separating ellipsoids in 2D.m','separate_ell_2D.m',\
'Ch08_geometric_probs','Solve a floor planning problem given graphs H & V.m','floor_plan_graphs.m'}; do
  wget -O $filename http://cvxr.com/cvx/examples/cvxbook/$urldirectory/$urlfile
  # echo $filename http://cvxr.com/cvx/examples/cvxbook/$urldirectory/$urlfile
done

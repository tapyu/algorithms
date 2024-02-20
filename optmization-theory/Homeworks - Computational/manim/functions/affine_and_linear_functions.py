from asyncore import write
from manim import *
import numpy as np

# phi = The polar angle i.e the angle between Z_AXIS and Camera through ORIGIN in radians.
# theta = The azimuthal angle i.e the angle that spins the camera around the Z_AXIS.
# gamma = The rotation of the camera about the vector from the ORIGIN to the Camera.
# see https://www.geogebra.org/m/hqPfxIpp

class AffineAndLinearFunctions(ThreeDScene):
    def construct(self):
        # enunciate
        enunciate = Tex(r"Suppose that ", r"$D$", r"$\subseteq \mathbb{R}^3$ is an Euclidean ball (a convex set) and $f:\mathbb{R}^3 \rightarrow \mathbb{R}^3$ is an Affine function, that is, $f(\mathbf{x}) = \mathbf{Ax}+\mathbf{b}$. For a moment, let us set $\mathbf{b}$ to $\mathbf{0}$, so we have a special case of the affine function: the linear function, $f(\mathbf{x}) = \mathbf{Ax}$.", font_size=35).to_edge(UP)
        enunciate[1].set_color(RED)
        self.play(Write(enunciate))
        self.wait(2)
        self.play(FadeOut(enunciate))
        # initialize and add 3D axis, x1, x2, and x3
        ax = ThreeDAxes()
        self.set_camera_orientation(phi=75*DEGREES , theta=-30*DEGREES, zoom=0.8) 
        x_axis_text = ax.get_x_axis_label(MathTex("x"))
        y_axis_text = ax.get_y_axis_label(MathTex("y"))
        z_axis_text = ax.get_z_axis_label(MathTex("z"))
        self.add(ax, x_axis_text, y_axis_text, z_axis_text)
        self.wait()
        
        # initialize sphere and sets
        sphere = Surface(
            lambda u, theta: np.array([ # u -> angle from xy plane to the point
                1.5 * np.cos(u) * np.cos(theta), # x axis
                1.5 * np.cos(u) * np.sin(theta), # y axis
                1.5 * np.sin(u) # z axis
            ]), v_range=[0, TAU], u_range=[-PI / 2, PI / 2],
            checkerboard_colors=[RED_B, RED_E],
            resolution=(32, 32)) # resolution=(8, 8)
        domain_set = Tex(r"This is the domain set ", r"$D$", font_size=30).to_corner(UR)
        domain_set[1].set_color(RED)
        image_set = Tex(r"This is the image set ", r"$C$", r"$ = f($", r"$D$", r"$) = \{f(\mathbf{x}\mid \mathbf{x} \in$", r"$D$", r"$)\}$", font_size=30).to_corner(UR)
        for i, color in zip((1, 3, 5), (BLUE, RED, RED)):
            image_set[i].set_color(color)

        # play sphere
        self.add_fixed_in_frame_mobjects(domain_set)
        self.play(Create(sphere), Write(domain_set), run_time=2)
        self.wait(2)

        # apply matrix
        A = [[1, 0.2, 0.4], [0.4, 1.2, 0.35], [0.2, 0.35, 1.3]]
        self.play(sphere.animate.apply_matrix(A).set_color([BLUE_B, BLUE_E]), ReplacementTransform(domain_set, image_set), run_time=2)
        # self.play(ApplyMatrix(A, sphere), run_time=2)
        self.add_fixed_in_frame_mobjects(image_set)

        # rotate ambient
        self.begin_ambient_camera_rotation(rate=PI/2, about="theta")
        self.wait(4)
        self.stop_ambient_camera_rotation()
        self.wait()

        # conclusion
        conclusion = Tex(r"If $D$ is convex, $C$ is also convex.\\Then the affine function is a convex function", font_size=30).to_edge(DL)
        self.add_fixed_in_frame_mobjects(conclusion)
        self.play(FadeOut(image_set), Write(conclusion))
        self.wait(3)
        self.play(FadeOut(conclusion))

        # add b vector
        b_vector_text = Tex(r"{10cm} If the Affine function is $f(\mathbf{x}) = \mathbf{Ax}+\mathbf{b}$, then the image is offset by $\mathbf{b}$, and the transformation is not linear anymore.", tex_environment="minipage", font_size=30).to_corner(DL)
        self.add_fixed_in_frame_mobjects(b_vector_text)
        self.play(sphere.animate.shift([1, 3, -2]), Write(b_vector_text))
        self.begin_ambient_camera_rotation(rate=PI/2, about="theta")
        self.wait(5)
        self.stop_ambient_camera_rotation()
        self.wait()
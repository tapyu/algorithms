from manim import *
import numpy as np

# phi = The polar angle i.e the angle between Z_AXIS and Camera through ORIGIN in radians.
# theta = The azimuthal angle i.e the angle that spins the camera around the Z_AXIS.
# gamma = The rotation of the camera about the vector from the ORIGIN to the Camera.
# see https://www.geogebra.org/m/hqPfxIpp

class PerspectiveFunction(ThreeDScene):
    def construct(self):
        # enunciate
        enunciate = Tex(r"{10cm}The perspective function $f: \mathbb{R}^{n+1} \rightarrow \mathbb{R}^n$ is given by $$f(\mathbf{x}, x_{n+1}) = \frac{\mathbf{x}}{x_{n+1}},$$ where $\mathbf{x} \in \mathbb{R}^n$ and $x_{n+1} \in \mathbb{R}$. The domain of the perspective function is $\textnormal{dom f } = \mathbb{R}^n \times \mathbb{R}_{++}$. This function scales or normalizes vectors based on the last component of the input vector. If $D \subseteq \textnormal{dom f}$ is convex , then the resulting image set, $f(D) = \{f(\mathbf{x}, x_{n+1}) \mid (\mathbf{x}, x_{n+1}) \in D\}$, is also convex.", tex_environment="minipage")
        enunciate.generate_target()
        enunciate.target = Tex(r"{10cm}Suppose that $n=2$ and that $C$ is an Euclidean ball. As this transformation is from $\mathbb{R}^3$ to $\mathbb{R}^2$, we will show two separated coordinate systems.", tex_environment="minipage")
        self.play(Write(enunciate))
        self.wait(4)
        self.play(MoveToTarget(enunciate))
        self.wait(2)
        self.play(FadeOut(enunciate))
        self.wait(2)

        # initialize and add 3D axis, x1, x2, and x3
        self.set_camera_orientation(phi=75*DEGREES , theta=-30*DEGREES, zoom=0.7)
        ax3d = ThreeDAxes(x_length=5, y_length=5, z_length=5, z_range=[-1, 5])
        x1_ax3d = ax3d.get_x_axis_label(MathTex("x1"))
        x2_ax3d = ax3d.get_y_axis_label(MathTex("x2"))
        x3_ax3d = ax3d.get_z_axis_label(MathTex("x3"))
        self.play(Create(ax3d), Write(x1_ax3d), Write(x2_ax3d), Write(x3_ax3d))
        self.wait()

        # initialize Euclidean ball + linear transformation = ellipse
        ellipse = Surface(
            # u -> angle from xy plane to the point
            lambda u, theta: 
                ax3d.c2p((1.5 * np.cos(u) * np.cos(theta)) + .5, # x axis
                (1.5 * np.cos(u) * np.sin(theta)) + .5, # y axis
                1.5 * np.sin(u) + 1.5), # z axis
                v_range=[0, TAU], u_range=[-PI / 2, PI / 2],
            checkerboard_colors=[RED_B, RED_E],
            resolution=(32, 32)).apply_matrix([[1, 0.2, 0.4], [0.4, 1.2, 0.35], [0.2, 0.35, 1.3]])
        domain_set = Tex(r"This is the domain set ", r"$D$", font_size=30).to_corner(UL)
        domain_set[1].set_color(RED)
        image_set = Tex(r"This is the image set ", r"$C$", r"$ = f($", r"$D$", r"$) = \{f(\mathbf{x}\mid \mathbf{x} \in$", r"$D$", r"$)\}$", font_size=30).to_edge(DOWN).shift(0.5*UP)
        for i, color in zip((1, 3, 5), (BLUE, RED, RED)):
            image_set[i].set_color(color)
        
        # play Euclidean ball
        self.add_fixed_in_frame_mobjects(domain_set)
        self.play(Create(ellipse), Write(domain_set), run_time=2)
        self.wait(2)

        # perspective function
        def perspective(x):
            return np.array((*(x[:-1]/x[-1]), 0))
        
        self.play(ellipse.animate.apply_function(perspective).set_fill_by_checkerboard([BLUE, DARK_BLUE]), FadeOut(domain_set))
        self.move_camera(phi=0*DEGREES , theta=-90*DEGREES, zoom=1.2)
        self.remove(ax3d.z_axis)
        self.play(Write(image_set), run_time=1)
        self.wait(3)
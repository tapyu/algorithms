from ast import Add
from gzip import WRITE
from manim import *
from numpy import array, sin

class Affine(ThreeDScene):
    def construct(self):
        # initialize and add 3D axis, x1, x2, and x3
        ax = ThreeDAxes()
        self.set_camera_orientation(phi=75*DEGREES, theta=-45*DEGREES, zoom=0.8)
        convex_set = Surface(lambda x, y: (x, y, x+y),[-10,10], [-10,10])
        e1_axis_text = ax.get_x_axis_label(MathTex("e_1"))
        e2_axis_text = ax.get_y_axis_label(MathTex("e_2"))
        e3_axis_text = ax.get_z_axis_label(MathTex("e_3"))
        # say what is affine set
        x1 = Dot3D(point=[1,1,2], radius=0.08, color=YELLOW)
        x2 = Dot3D(point=[-1,-1,-2], radius=0.08, color=YELLOW)
        line_segment = Line3D(start=x1.get_center(), end=x2.get_center())
        line_segment = line_segment.add_updater(lambda mob: mob.become(Line3D(start=x1.get_center(), end=x2.get_center())))
        affine_conclusion_text = Tex(r"The \emph{Affine set} almost has the same definition,\\but the line is infinite instead of a segment,\\ that is, $L = \{\mathbf{y} \in \mathbb{R}^3 \mid \mathbf{y} = \theta \mathbf{x}_1+(1-\theta) \mathbf{x}_2, \forall\: \theta \in \mathbb{R}\}$.\\When $L \subset C$ for any $\mathbf{x}_1,\mathbf{x}_2 \in C$, we say that $C$ is an \emph{Affine set}.").to_edge(DOWN)
        self.add_fixed_in_frame_mobjects(affine_conclusion_text)
        self.play(Write(affine_conclusion_text))
        self.wait(3)
        self.play(FadeOut(affine_conclusion_text), FadeIn(ax, convex_set, line_segment, x1, x2, e1_axis_text, e2_axis_text, e3_axis_text))
        self.wait()
        # show that c is a convex set
        c_is_convex_text = Tex(r"Our plane is a convex set as any line\\segment whose tips belongs to\\it is also inside the plane.").to_corner(UL)
        self.add_fixed_in_frame_mobjects(c_is_convex_text)
        self.play(Write(c_is_convex_text))
        self.wait()
        # show that c is not an affine set
        c_isnt_affine_text = Tex(r"But is not an affine set since it is a \\ bounded sheet :(. An infinite line\\(in red) cannot be in it", color=RED).to_corner(UL)
        self.add_fixed_in_frame_mobjects(c_isnt_affine_text)
        line = Line3D(start=[-20,-20,-40], end=[60,20,80], color=RED)
        self.play(ReplacementTransform(c_is_convex_text, c_isnt_affine_text), FadeOut(line_segment, x1, x2)) # animation 6
        self.wait()
        self.move_camera(phi=135*DEGREES, theta=45*DEGREES, gamma=20*DEGREES, zoom=0.5)
        self.play(Create(line))
        self.wait(2)
        # stretch c to make it an affine set
        transforming_c_to_affine_text = Tex(r"However, if we stretch out\\this sheet to infinity,\\ we get an affine set :)", color=BLACK).to_corner(UL)
        self.add_fixed_in_frame_mobjects(transforming_c_to_affine_text)
        affine_set = Surface(lambda x, y: (x, y, x+y),[-20,20], [-20,20])
        self.play(ReplacementTransform(c_isnt_affine_text, transforming_c_to_affine_text), Transform(convex_set, affine_set))
        self.wait()
        origin_dot = Dot3D(ORIGIN, color=RED)
        self.play(Create(origin_dot))
        subspace_conclusion_text = Tex(r"When the affine set\\happens to include\\the origin. It is\\also a subspace in $\mathbb{R}^3$", color=BLACK).to_corner(UL)
        self.add_fixed_in_frame_mobjects(subspace_conclusion_text)
        self.play(ReplacementTransform(transforming_c_to_affine_text, subspace_conclusion_text))
        self.wait(3)
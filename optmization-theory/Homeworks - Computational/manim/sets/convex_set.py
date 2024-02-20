from ast import Add
from gzip import WRITE
from manim import *
from numpy import array, sin

class Convex(ThreeDScene):
    def construct(self):
        # initialize and add 3D axis, x1, and x2
        ax = ThreeDAxes()
        self.set_camera_orientation(phi=75*DEGREES, theta=-45*DEGREES, zoom=0.8)
        e1_axis_text = ax.get_x_axis_label(MathTex("e_1"))
        e2_axis_text = ax.get_y_axis_label(MathTex("e_2"))
        e3_axis_text = ax.get_z_axis_label(MathTex("e_3"))
        self.add(ax, e1_axis_text, e2_axis_text, e3_axis_text)
        
        # initialize and play plane
        convex_set = Surface(lambda x, y: (x, y, x+y),[-10,10], [-10,10])
        convex_set_text = Tex(r"consider the following set,\\denoted by $C$.").to_corner(UL)
        self.add_fixed_in_frame_mobjects(convex_set_text)
        self.play(Create(convex_set), Write(convex_set_text))

        # move line segment around on the plane
        x1 = Dot3D(point=[1,1,2], radius=0.08, color=YELLOW)
        x2 = Dot3D(point=[-1,-1,-2], radius=0.08, color=YELLOW)
        line_segment = Line3D(start=x1.get_center(), end=x2.get_center())
        line_segment = line_segment.add_updater(lambda mob: mob.become(Line3D(start=x1.get_center(), end=x2.get_center())))
        self.play(Create(line_segment), FadeOut(convex_set_text))
        self.wait()
        self.begin_ambient_camera_rotation(rate=PI/10, about="theta")
        self.play(x1.animate.move_to([1,2,3]))
        self.play(x2.animate.move_to([2,2,6]))
        self.play(x2.animate.move_to([0.3,0.5,0.8]))
        self.play(x2.animate.move_to([0,1.3,1.3]))
        self.play(x2.animate.move_to([3,-2,1]))
        self.play(x2.animate.move_to([1,1,2]))
        self.play(x1.animate.move_to([-3,1,-2]))
        self.stop_ambient_camera_rotation()
        self.wait()
        self.move_camera(phi=45*DEGREES, theta=-45*DEGREES)
        # say what is convex set
        convex_conclusion_text = Tex(r"For any $\mathbf{x}_1,\mathbf{x}_2 \in C$ the line segment \\ $L=\{\mathbf{y} \in \mathbb{R}^3 \mid \mathbf{y} = \theta \mathbf{x}_1+(1-\theta) \mathbf{x}_2, 0\leq \theta \leq 1 \}$, also \\belongs to $C$. When it happens, we say that $C$ is a \emph{Convex set}").to_edge(DOWN)
        self.add_fixed_in_frame_mobjects(convex_conclusion_text)
        self.play(Write(convex_conclusion_text), FadeOut(ax, convex_set, line_segment, x1, x2, e1_axis_text, e2_axis_text, e3_axis_text))
        self.wait(3)
from tkinter import Variable
from manim import *

class Hyperplane(Scene):
    def construct(self):
        # play axis
        ax = NumberPlane()
        x_axis = ax.get_x_axis_label(MathTex("x"))
        y_axis = ax.get_y_axis_label(MathTex("y"))
        self.play(Create(ax), FadeIn(x_axis, y_axis), run_time=2)

        # play vector a
        a = Vector().put_start_and_end_on((0,0,0),(1,1,0))
        a_label = MathTex(r"\mathbf{a}_1 = \begin{bmatrix} 1 \\ 1 \end{bmatrix}").next_to(a, 0.5*UR)
        self.play(Create(a), run_time=1.5)
        self.wait()
        self.play(Create(a_label), run_time=1.5)
        self.wait()
        self.play(FadeOut(a_label), run_time=1.5)
        self.wait()
        # play hyperplane enunciate
        hyperplane_enunciate = Tex(r"{3.5cm} Consider all vectors where $\mathbf{a}^\mathsf{T}\mathbf{x}=3$.", tex_environment="minipage").to_corner(UL)
        self.play(Write(hyperplane_enunciate), run_time=1.5)
        self.wait()
        # play hyperplane line
        L = ax.plot(lambda x: -x+3, x_range=[-10, 10], color=BLUE_C)
        self.play(Create(L), run_time=1.5)
        self.wait()
        # move a to L
        tracker = ValueTracker(1)
        x = Vector().put_start_and_end_on((0,0,0),(tracker.get_value(),-tracker.get_value()+3, 0))
        x_text = Tex("$\mathbf{x}$").next_to(x, UR)
        dot_text = Tex(r"$\mathbf{a}^\mathsf{T}\mathbf{x} = $", f"{np.dot(x.get_end(), a.get_end())}").to_edge(LEFT).shift(UP)
        # add updater
        x.add_updater(lambda mobj: mobj.put_start_and_end_on((0,0,0),(tracker.get_value(),-tracker.get_value()+3, 0)))
        dot_text.add_updater(lambda mobj: mobj.become(Tex(r"$\mathbf{a}^\mathsf{T}\mathbf{x} = $", f"{np.dot(x.get_end(), a.get_end())}").to_edge(LEFT).shift(UP)))
        self.play(Create(x), Write(dot_text), Write(x_text))
        self.wait()
        self.play(FadeOut(x_text))
        self.wait()
        # move x around
        for new_value in (4,2,3,1):
            self.play(tracker.animate.set_value(new_value))
        conclusion = Tex(r"For any value of $\mathbf{x} \in L$, the value is always the same: 3").to_corner(DL)
        self.play(Write(conclusion))
        self.wait()
        # move x to L's right
        x.clear_updaters()
        self.play(x.animate.put_start_and_end_on(ORIGIN, (4,3,0)))
        self.wait()
        area1 = ax.get_area(ParametricFunction(lambda x: (x, 5, 0), t_range=[-2, 10]), bounded_graph=L, color=GREY, opacity=0.5)
        self.play(conclusion.animate.become(Tex(r"For $\mathbf{x}$ in this area, $\mathbf{a}^\mathsf{T}\mathbf{x} > 3$").to_corner(DL)), FadeIn(area1))
        self.wait(3)
        # move x to L's left
        area2 = ax.get_area(L, bounded_graph=ParametricFunction(lambda x: (x, -5, 0), t_range=[-10, 10]), color=GREY, opacity=0.5)
        self.play(FadeOut(area1), FadeIn(area2), conclusion.animate.become(Tex(r"For $\mathbf{x}$ in this area, $\mathbf{a}^\mathsf{T}\mathbf{x} < 3$").to_corner(DL)), x.animate.put_start_and_end_on(ORIGIN, (-5,-2,0)))
        self.wait(3)
        # clean scene
        self.play(FadeOut(x), FadeOut(a), FadeOut(dot_text), FadeOut(hyperplane_enunciate), FadeOut(area2))
        self.wait(2)
        self.play(Wiggle(L), conclusion.animate.become(Tex(r"This is the hyperplane").to_corner(DL)))
        self.wait(2)
        self.play(Indicate(area1), conclusion.animate.become(Tex(r"This is one halfspace").to_corner(DL)), run_time=2)
        self.play(FadeOut(area1))
        self.play(Indicate(area2), conclusion.animate.become(Tex(r"This is another halfspace").to_corner(DL)), run_time=2)
        self.play(FadeOut(area2))
        self.wait()
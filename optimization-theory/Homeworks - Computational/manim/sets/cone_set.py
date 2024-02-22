from manim import *
import numpy as np

class ConeSet(Scene):
    def construct(self):
        ax = Axes(x_range=[0, 10, 1], y_range=[0, 10, 1])
        x_axis = ax.get_x_axis_label(MathTex("x"))
        y_axis = ax.get_y_axis_label(MathTex("y"))
        self.play(Create(ax), FadeIn(x_axis, y_axis))
        self.wait(2)

        # initialize vectors
        x1 = Vector().put_start_and_end_on(ax.c2p(0,0),ax.c2p(1,2))
        theta1 = ValueTracker(1)
        x2 = Vector().put_start_and_end_on(ax.c2p(0,0),ax.c2p(2,1))
        self.play(Create(x1), Create(x2))
        self.wait(1)
        
        # play labels
        label_1 = MathTex(r"\mathbf{x}_1").next_to(x1, 0.5*UR)
        label_2 = MathTex(r"\mathbf{x}_2").next_to(x2, 0.5*UR)
        self.play(Write(label_1), Write(label_2))
        self.wait()
        self.play(FadeOut(label_1), FadeOut(label_2))
        self.wait()
        # initialize upper and lower bound of the cone set
        lowerb = DashedLine(x1.get_start(), x1.get_end(), color=BLUE).set_length(30)
        upperb = DashedLine(x2.get_start(), x2.get_end(), color=BLUE).set_length(30)
        self.play(Create(lowerb), Create(upperb))
        self.wait(1)
        # x1 on x2's tip
        new_final = ax.p2c(x2.get_end())+theta1.get_value()*np.array((1,2))
        self.play(x1.animate.put_start_and_end_on(x2.get_end(), ax.c2p(*new_final)))
        # define updaters
        def x1_updater(mobj):
            new_final = ax.p2c(x2.get_end())+theta1.get_value()*np.array((1,2))
            return mobj.put_start_and_end_on(x2.get_end(), ax.c2p(*new_final))
        x1.add_updater(x1_updater)
        self.wait(0.5)
        # play x3 = x1+x2
        x3 = Vector(color=RED).put_start_and_end_on(ax.c2p(0,0),x1.get_end())
        x3.add_updater(lambda mobj: mobj.put_start_and_end_on(ax.c2p(0,0),x1.get_end()))
        self.play(Create(x3))
        # play linear combination of x1 and x2
        for new_x2, new_theta1, new_theta2 in zip(((2,3), (1,1), (4,5)), (1.3, 0.7, 0.45), (0.7, 1.13, 1.75)):
            self.wait(0.5)
            self.play(x2.animate.put_start_and_end_on(x2.get_start(), new_theta2*ax.c2p(*new_x2)), theta1.animate.set_value(new_theta1))
            self.wait(0.5)
        self.wait(0.5)
        # clean up scene
        self.play(FadeOut(x1,x2,ax,x_axis,y_axis))
        self.wait()

        # conclusion
        conclusion = Tex(r"{50cm}For any $\mathbf{x}_1, \mathbf{x}_2 \in \mathbb{C}$ and $\theta_1, \theta_2 > 0$, $\mathbf{y} = \theta_1\mathbf{x}_1 + \theta_2\mathbf{x}_2$ is also in $\mathbb{C}$", tex_environment="minipage").to_corner(UL)
        self.play(Write(conclusion))
        self.wait(2)
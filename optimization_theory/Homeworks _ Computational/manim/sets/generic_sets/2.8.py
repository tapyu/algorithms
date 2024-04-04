from manim import *

class ImplicitFunctionExample(Scene):
    def construct(self):
        ax = Axes(x_range=[1, 4], y_range=[-1, 4]).add_coordinates()
        x_label = ax.get_x_axis_label(MathTex("x"), edge=DOWN, direction=DOWN, buff=0.5)#.shift(DOWN)
        y_label = ax.get_y_axis_label(MathTex("y"), edge=LEFT, direction=LEFT, buff=0.5)#.shift(DOWN)
        graph = ax.plot_implicit_curve(lambda x, y: x*y-1, color=YELLOW)
        area = ax.get_area(graph)
        axis = VGroup(ax, x_label, y_label)
        self.add(axis, graph, area)
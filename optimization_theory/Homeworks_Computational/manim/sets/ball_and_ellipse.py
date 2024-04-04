from asyncore import write
from manim import *
import numpy as np

# phi = The polar angle i.e the angle between Z_AXIS and Camera through ORIGIN in radians.
# theta = The azimuthal angle i.e the angle that spins the camera around the Z_AXIS.
# gamma = The rotation of the camera about the vector from the ORIGIN to the Camera.
# see https://www.geogebra.org/m/hqPfxIpp

class LinearTransformation(ThreeDScene):
    def construct(self):
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

        # play sphere
        text = Text("It is a ball").to_corner(DL)

        self.add_fixed_in_frame_mobjects(text)
        self.play(Create(sphere), Write(text), run_time=2)
        self.begin_ambient_camera_rotation(rate=PI/4, about="theta")
        self.wait(6)

        text.generate_target()
        text.target = Text("It is a ellipse").to_corner(DL)
        self.add_fixed_in_frame_mobjects(text.target)
        # apply matrix
        A = [[1, 0.2, 0.4], [0.4, 1.2, 0.35], [0.2, 0.35, 1.3]]
        self.play(sphere.animate.apply_matrix(A).set_color([BLUE_B, BLUE_E]), MoveToTarget(text), run_time=2)
        # self.play(ApplyMatrix(A, sphere), run_time=2)
        self.wait(6)
        self.stop_ambient_camera_rotation()
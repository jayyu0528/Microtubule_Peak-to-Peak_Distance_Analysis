function [x_input1, y_input1] = select_point()


[x_input,y_input] = ginput(1);
x_input1 = round(x_input);
y_input1 = round(y_input);
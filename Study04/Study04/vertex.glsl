attribute vec4 position;
attribute vec4 color;

uniform float elapsedTime;

varying vec4 fragColor;

void main(void) {
    fragColor = color;
    gl_Position = position;
    gl_PointSize = 25.0;
}

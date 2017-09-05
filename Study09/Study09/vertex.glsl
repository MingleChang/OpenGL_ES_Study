attribute vec4 position;
attribute vec4 color;
attribute vec3 normal;

uniform float elapsedTime;
uniform mat4 projectionMatrix;
uniform mat4 cameraMatrix;
uniform mat4 modelMatrix;

varying vec4 fragColor;
varying vec3 fragNormal;

void main(void) {
    fragColor = color;
    fragNormal = normal;
    mat4 mvp = projectionMatrix * cameraMatrix * modelMatrix;
    gl_Position = mvp * position;
}

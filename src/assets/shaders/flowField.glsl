// Flow Field Vertex Shader
export const vertexShader = `
  uniform float uTime;
  uniform vec2 uMouse;
  uniform float uPixelRatio;

  attribute float aScale;
  attribute float aRandomness;

  varying vec3 vColor;

  // Simplex 3D Noise
  vec3 mod289(vec3 x) { return x - floor(x * (1.0 / 289.0)) * 289.0; }
  vec4 mod289(vec4 x) { return x - floor(x * (1.0 / 289.0)) * 289.0; }
  vec4 permute(vec4 x) { return mod289(((x*34.0)+1.0)*x); }
  vec4 taylorInvSqrt(vec4 r) { return 1.79284291400159 - 0.85373472095314 * r; }

  float snoise(vec3 v) {
    const vec2 C = vec2(1.0/6.0, 1.0/3.0);
    const vec4 D = vec4(0.0, 0.5, 1.0, 2.0);

    vec3 i  = floor(v + dot(v, C.yyy));
    vec3 x0 = v - i + dot(i, C.xxx);

    vec3 g = step(x0.yzx, x0.xyz);
    vec3 l = 1.0 - g;
    vec3 i1 = min(g.xyz, l.zxy);
    vec3 i2 = max(g.xyz, l.zxy);

    vec3 x1 = x0 - i1 + C.xxx;
    vec3 x2 = x0 - i2 + C.yyy;
    vec3 x3 = x0 - D.yyy;

    i = mod289(i);
    vec4 p = permute(permute(permute(
      i.z + vec4(0.0, i1.z, i2.z, 1.0))
      + i.y + vec4(0.0, i1.y, i2.y, 1.0))
      + i.x + vec4(0.0, i1.x, i2.x, 1.0));

    float n_ = 0.142857142857;
    vec3 ns = n_ * D.wyz - D.xzx;

    vec4 j = p - 49.0 * floor(p * ns.z * ns.z);

    vec4 x_ = floor(j * ns.z);
    vec4 y_ = floor(j - 7.0 * x_);

    vec4 x = x_ *ns.x + ns.yyyy;
    vec4 y = y_ *ns.x + ns.yyyy;
    vec4 h = 1.0 - abs(x) - abs(y);

    vec4 b0 = vec4(x.xy, y.xy);
    vec4 b1 = vec4(x.zw, y.zw);

    vec4 s0 = floor(b0)*2.0 + 1.0;
    vec4 s1 = floor(b1)*2.0 + 1.0;
    vec4 sh = -step(h, vec4(0.0));

    vec4 a0 = b0.xzyw + s0.xzyw*sh.xxyy;
    vec4 a1 = b1.xzyw + s1.xzyw*sh.zzww;

    vec3 p0 = vec3(a0.xy, h.x);
    vec3 p1 = vec3(a0.zw, h.y);
    vec3 p2 = vec3(a1.xy, h.z);
    vec3 p3 = vec3(a1.zw, h.w);

    vec4 norm = taylorInvSqrt(vec4(dot(p0,p0), dot(p1,p1), dot(p2,p2), dot(p3,p3)));
    p0 *= norm.x;
    p1 *= norm.y;
    p2 *= norm.z;
    p3 *= norm.w;

    vec4 m = max(0.6 - vec4(dot(x0,x0), dot(x1,x1), dot(x2,x2), dot(x3,x3)), 0.0);
    m = m * m;
    return 42.0 * dot(m*m, vec4(dot(p0,x0), dot(p1,x1), dot(p2,x2), dot(p3,x3)));
  }

  void main() {
    vec3 pos = position;

    // Flow field displacement
    float noiseFreq = 0.08;
    float noiseAmp = 2.5;
    float time = uTime * 0.15;

    vec3 noisePos = pos * noiseFreq + time;
    float noiseX = snoise(noisePos);
    float noiseY = snoise(noisePos + 100.0);
    float noiseZ = snoise(noisePos + 200.0);

    pos.x += noiseX * noiseAmp * aRandomness;
    pos.y += noiseY * noiseAmp * aRandomness;
    pos.z += noiseZ * noiseAmp * 0.5;

    // Mouse interaction - repel particles
    vec2 mouseWorld = uMouse * 30.0;
    vec2 toMouse = pos.xy - mouseWorld;
    float distToMouse = length(toMouse);
    float repelRadius = 8.0;
    float repelStrength = 3.0;

    if (distToMouse < repelRadius) {
      float repelFactor = (1.0 - distToMouse / repelRadius) * repelStrength;
      pos.xy += normalize(toMouse) * repelFactor;
    }

    vec4 mvPosition = modelViewMatrix * vec4(pos, 1.0);
    gl_Position = projectionMatrix * mvPosition;

    // Size attenuation
    float sizeAtten = (1.0 / -mvPosition.z) * 300.0;
    gl_PointSize = aScale * sizeAtten * uPixelRatio;
    gl_PointSize = max(gl_PointSize, 1.0);

    // Cyberpunk color palette
    float colorMix = (noiseX + 1.0) * 0.5;
    vec3 deepTeal = vec3(0.059, 0.090, 0.165);    // #0f172a
    vec3 neonGreen = vec3(0.063, 0.725, 0.506);   // #10b981
    vec3 brightAccent = vec3(0.078, 0.722, 0.659); // #14b8a6

    vColor = mix(deepTeal, neonGreen, colorMix);
    vColor = mix(vColor, brightAccent, smoothstep(0.7, 1.0, colorMix) * 0.5);

    // Fade based on distance
    float depth = smoothstep(40.0, 10.0, -mvPosition.z);
    vColor *= depth;
  }
`;

// Flow Field Fragment Shader
export const fragmentShader = `
  varying vec3 vColor;

  void main() {
    // Circular particle with soft edge
    vec2 center = gl_PointCoord - 0.5;
    float dist = length(center);
    float alpha = 1.0 - smoothstep(0.3, 0.5, dist);

    // Add glow
    float glow = exp(-dist * 3.0) * 0.5;

    vec3 finalColor = vColor + vColor * glow;

    gl_FragColor = vec4(finalColor, alpha * 0.8);
  }
`;

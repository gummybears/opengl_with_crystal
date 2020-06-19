require "./lib_gl/**"

{% if flag?(:darwin) %}
  @[Link(framework: "OpenGL")]
{% else %}
  @[Link("GL")]
{% end %}
lib LibGL
end
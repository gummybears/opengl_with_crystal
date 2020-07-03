macro for(*exp, &block)
  {% if exp[0].is_a?(Assign) %}
    {{exp[0]}}
    while {{exp[1]}}
      {{block.body}}
      {{exp[2]}}
    end
  {% else %}
    {% in = exp.last.args.first; in2 = in.args.last %}
    {% variables = exp.stringify.split('(')[0][1..-1].id %}
    {% block = in.block.stringify.empty? ? in2.block : in.block %}
    {% if in2.is_a?(Call) && !in2.block.stringify.empty? %}
      {% enumerable = in2.stringify.split(" do\n")[0].id %}
    {% else %}
      {% enumerable = in2 %}
    {% end %}
    ({{enumerable}}).each { |{{variables}}| {{block.body}} }
  {% end %}
end

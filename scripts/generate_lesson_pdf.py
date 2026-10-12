import json
import os
import sys
import subprocess
import re

def render_latex_to_html(text):
    if not text:
        return ""

    def replace_math_expr(expr):
        expr = expr.strip()
        expr = re.sub(r"\\text\{([^}]+)\}", r"\1", expr)
        expr = re.sub(r"\\mathbf\{([^}]+)\}", r"<strong>\1</strong>", expr)
        expr = re.sub(r"\\frac\{1\}\{2\}", "½", expr)
        expr = re.sub(r"\\frac\{([^}]+)\}\{([^}]+)\}", r"(\1 / \2)", expr)
        expr = re.sub(r"\\left\(", "(", expr)
        expr = re.sub(r"\\right\)", ")", expr)
        expr = re.sub(r"\\times", "×", expr)
        expr = re.sub(r"\\approx", "≈", expr)
        expr = re.sub(r"\\le", "≤", expr)
        expr = re.sub(r"\\ge", "≥", expr)
        expr = re.sub(r"\\Omega", "Ω", expr)
        expr = re.sub(r"\\mu", "µ", expr)
        expr = re.sub(r"\\pi", "π", expr)
        expr = re.sub(r"\\implies", "⇒", expr)
        expr = re.sub(r"\\,", " ", expr)
        expr = re.sub(r"\\%", "%", expr)
        expr = re.sub(r"\{([0-9,]+)\}", r"\1", expr)
        expr = re.sub(r"([A-Za-z0-9\(\)]+)\^\{?([0-9a-zA-Z\+\-]+)\}?", r"\1<sup>\2</sup>", expr)
        expr = re.sub(r"([A-Za-z]+)_\{?([0-9a-zA-Z\+\-]+)\}?", r"\1<sub>\2</sub>", expr)
        return expr

    def replace_block(match):
        inner = replace_math_expr(match.group(1))
        return f"<div class=\"math-block\">{inner}</div>"

    def replace_inline(match):
        inner = replace_math_expr(match.group(1))
        return f"<span class=\"math-inline\">{inner}</span>"

    text = re.sub(r"\$\$(.+?)\$\$", replace_block, text, flags=re.DOTALL)
    text = re.sub(r"(?<!\$)\$([^\$\n]+?)\$(?!\$)", replace_inline, text)
    return text


def render_lesson_to_html(lesson_data, output_html_path, mode="learner"):
    title = lesson_data.get("title", "Untitled Lesson")
    lesson_id = lesson_data.get("id", "")
    summary = lesson_data.get("summary", "")
    tier = lesson_data.get("tier", "rookie").upper()
    est_min = lesson_data.get("estimatedMinutes", 10)
    xp = lesson_data.get("xpReward", 10)
    prereqs = ", ".join(lesson_data.get("prerequisites", [])) or "None (First Lesson)"
    components = ", ".join(lesson_data.get("componentIds", [])) or "None"
    steps = lesson_data.get("steps", [])
    brand_title = "Monster Lab • Educator Key & Lesson Review" if mode == "educator" else "Monster Lab • Student Lab Handout"

    step_html = ""
    rendered_widgets = set()
    for idx, step in enumerate(steps, 1):
        step_id = step.get("stepId", f"s{idx}")
        step_title = step.get("title", f"Step {idx}")
        step_type = step.get("type", "story")
        widget_type = step.get("interactiveWidgetType", None)
        markdown_content = step.get("markdownContent", "")
        # convert simple markdown headings/bold/code/lists
        content_lines = markdown_content.split("\n")
        formatted_content = []
        in_code_block = False
        code_buf = []

        for line in content_lines:
            if line.startswith("```"):
                if in_code_block:
                    in_code_block = False
                    formatted_content.append(f"<pre class='code-block'><code>{'<br>'.join(code_buf)}</code></pre>")
                    code_buf = []
                else:
                    in_code_block = True
                    code_buf = []
                continue

            if in_code_block:
                code_buf.append(line.replace("<", "&lt;").replace(">", "&gt;"))
                continue

            if line.startswith("# "):
                formatted_content.append(f"<h2>{line[2:]}</h2>")
            elif line.startswith("## "):
                formatted_content.append(f"<h3>{line[3:]}</h3>")
            elif line.startswith("### "):
                formatted_content.append(f"<h3>{line[4:]}</h3>")
            elif line.startswith("#### "):
                formatted_content.append(f"<h4>{line[5:]}</h4>")
            elif line.startswith("> "):
                formatted_content.append(f"<blockquote class='callout'>{line[2:]}</blockquote>")
            elif line.startswith("- "):
                formatted_content.append(f"<li>{line[2:]}</li>")
            elif line.strip() == "":
                formatted_content.append("<br>")
            else:
                formatted_content.append(f"<p>{line}</p>")

        parsed_body = "\n".join(formatted_content)
        # bold replacement
        parsed_body = re.sub(r'\*\*(.*?)\*\*', r'<strong>\1</strong>', parsed_body)
        # LaTeX math replacement
        parsed_body = render_latex_to_html(parsed_body)

        # Quick check questions if any
        qc_html = ""
        quick_checks = step.get("quickCheck", [])
        if quick_checks:
            badge_title = "Diagnostic Pre-Test (QuickCheck)" if mode == "educator" else "Check Your Understanding"
            qc_html += f"<div class='quick-check-box'><div class='box-badge'>{badge_title}</div>"
            for q_idx, qc in enumerate(quick_checks, 1):
                q_text = render_latex_to_html(qc.get("question", ""))
                options = [render_latex_to_html(opt) for opt in qc.get("options", [])]
                correct_idx = qc.get("correctIndex", 0)
                explanation = render_latex_to_html(qc.get("explanation", ""))
                warmup = render_latex_to_html(qc.get("warmupExplanation", ""))

                if mode == "educator":
                    opt_items = "".join([
                        f"<li class='option {'correct' if opt_i == correct_idx else ''}'>"
                        f"<span class='radio-mark'>{'●' if opt_i == correct_idx else '○'}</span> {opt}"
                        f"{' <span class=\"correct-tag\">[CORRECT ANSWER]</span>' if opt_i == correct_idx else ''}</li>"
                        for opt_i, opt in enumerate(options)
                    ])
                    exp_section = f"""
                    <div class='qc-exp'><strong>Why:</strong> {explanation}</div>
                    {f"<div class='qc-warmup'><strong>Hint/Warmup:</strong> {warmup}</div>" if warmup else ""}
                    """
                else:
                    opt_items = "".join([
                        f"<li class='option'><span class='radio-mark'>○</span> [ ] {opt}</li>"
                        for opt in options
                    ])
                    exp_section = "<div class='qc-exp student-prompt'><em>Select your answer above before continuing to the next step.</em></div>"

                qc_html += f"""
                <div class='qc-item'>
                    <div class='qc-q'><strong>Q{q_idx}:</strong> {q_text}</div>
                    <ul class='qc-options'>{opt_items}</ul>
                    {exp_section}
                </div>
                """
            qc_html += "</div>"

        # Interactive config / Quiz questions
        interactive_config = step.get("interactiveConfig", {}) or {}
        config_html = ""

        # Check for explicitly structured printableActivity
        printable_act = interactive_config.get("printableActivity") or step.get("printableActivity")

        sim_key = widget_type or (printable_act.get("simulationName") if printable_act else None)
        if printable_act and (sim_key not in rendered_widgets or not sim_key):
            if sim_key:
                rendered_widgets.add(sim_key)
            p_title = printable_act.get("title", "Laboratory Investigation Sheet")
            p_sim_name = printable_act.get("simulationName", widget_type or "Interactive Simulation")
            p_instructions = printable_act.get("instructions", "")
            p_table = printable_act.get("table", {})
            p_headers = p_table.get("headers", [])
            p_rows = p_table.get("rows", [])

            table_html = ""
            if p_headers and p_rows:
                header_cols = "".join([f"<th style='padding: 6px; border: 1px solid #cbd5e1;'>{render_latex_to_html(h)}</th>" for h in p_headers])
                body_rows = ""
                for row in p_rows:
                    row_cols = "".join([f"<td style='padding: 6px; border: 1px solid #cbd5e1;'>{render_latex_to_html(col)}</td>" for col in row])
                    body_rows += f"<tr>{row_cols}</tr>"
                table_html = f"""
                <div class='activity-log-table' style='margin-top: 8px;'>
                    <table style='width: 100%; border-collapse: collapse; font-size: 11px;'>
                        <thead>
                            <tr style='background: #e2e8f0; text-align: left;'>
                                {header_cols}
                            </tr>
                        </thead>
                        <tbody>
                            {body_rows}
                        </tbody>
                    </table>
                </div>
                """

            config_html += f"""
            <div class='widget-box'>
                <div class='widget-badge'>{p_title} (Monster Lab In-App Simulator)</div>
                <div class='widget-name'><strong>Interactive Simulation:</strong> <code>{p_sim_name}</code></div>
                <div class='printable-activity'>
                    <p><strong>Investigation Task:</strong> {render_latex_to_html(p_instructions)}</p>
                    {table_html}
                </div>
            </div>
            """

        # Quiz checkpoint questions
        if interactive_config and "questions" in interactive_config:
            quiz_questions = interactive_config.get("questions", [])
            badge_title = f"Step {idx}: Checkpoint Assessment Key" if mode == "educator" else f"Step {idx}: Mastery Checkpoint Quiz"
            config_html += f"<div class='quiz-box'><div class='box-badge'>{badge_title}</div>"
            for q_idx, q in enumerate(quiz_questions, 1):
                q_text = render_latex_to_html(q.get("question", ""))
                options = [render_latex_to_html(opt) for opt in q.get("options", [])]
                correct_idx = q.get("correctIndex", 0)
                explanation = render_latex_to_html(q.get("explanation", ""))

                if mode == "educator":
                    opt_items = "".join([
                        f"<li class='option {'correct' if opt_i == correct_idx else ''}'>"
                        f"<span class='radio-mark'>{'●' if opt_i == correct_idx else '○'}</span> {opt}"
                        f"{' <span class=\"correct-tag\">[CORRECT ANSWER]</span>' if opt_i == correct_idx else ''}</li>"
                        for opt_i, opt in enumerate(options)
                    ])
                    exp_section = f"<div class='qc-exp'><strong>Explanation:</strong> {explanation}</div>"
                else:
                    opt_items = "".join([
                        f"<li class='option'><span class='radio-mark'>○</span> [ ] {opt}</li>"
                        for opt in options
                    ])
                    exp_section = ""

                config_html += f"""
                <div class='quiz-item'>
                    <div class='qc-q'><strong>Question {q_idx}:</strong> {q_text}</div>
                    <ul class='qc-options'>{opt_items}</ul>
                    {exp_section}
                </div>
                """
            config_html += "</div>"

        step_html += f"""
        <div class='step-container'>
            <div class='step-header'>
                <span class='step-number'>STEP {idx}</span>
                <span class='step-title'>{step_title}</span>
                <span class='step-type-badge'>{step_type}</span>
            </div>
            <div class='step-body'>
                {parsed_body}
                {qc_html}
                {config_html}
            </div>
        </div>
        """

    html = f"""<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>{title} ({lesson_id}) - Monster Lab</title>
<style>
  @page {{
    size: A4;
    margin: 1.2cm;
  }}
  body {{
    font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
    color: #1a1a2e;
    background: #ffffff;
    line-height: 1.45;
    font-size: 12.5px;
    margin: 0;
    padding: 0;
  }}
  .header {{
    border-bottom: 2px solid #6366f1;
    padding-bottom: 8px;
    margin-bottom: 12px;
  }}
  .brand-title {{
    font-size: 10px;
    text-transform: uppercase;
    letter-spacing: 2px;
    color: #6366f1;
    font-weight: 800;
  }}
  .lesson-title {{
    font-size: 20px;
    font-weight: 800;
    color: #0f172a;
    margin: 2px 0 4px 0;
  }}
  .summary {{
    font-size: 12.5px;
    color: #475569;
    margin-bottom: 8px;
  }}
  .meta-grid {{
    display: grid;
    grid-template-columns: repeat(5, 1fr);
    background: #f8fafc;
    border: 1px solid #e2e8f0;
    border-radius: 6px;
    padding: 6px 10px;
    font-size: 10px;
  }}
  .meta-item strong {{
    display: block;
    color: #64748b;
    font-size: 9px;
    text-transform: uppercase;
  }}
  .step-container {{
    border: 1px solid #e2e8f0;
    border-radius: 6px;
    margin-bottom: 14px;
    background: #ffffff;
  }}
  h3, h4 {{
    page-break-after: avoid;
    break-after: avoid;
  }}
  .step-header {{
    background: #f1f5f9;
    border-bottom: 1px solid #e2e8f0;
    padding: 8px 14px;
    display: flex;
    align-items: center;
    gap: 10px;
    page-break-after: avoid;
    break-after: avoid;
  }}
  .step-number {{
    background: #6366f1;
    color: white;
    font-size: 10px;
    font-weight: 800;
    padding: 2px 8px;
    border-radius: 4px;
  }}
  .step-title {{
    font-weight: 700;
    font-size: 14px;
    color: #0f172a;
    flex-grow: 1;
  }}
  .step-type-badge {{
    background: #e0e7ff;
    color: #4338ca;
    font-size: 10px;
    font-weight: 600;
    padding: 2px 8px;
    border-radius: 4px;
    text-transform: uppercase;
  }}
  .step-body {{
    padding: 14px;
  }}
  .code-block {{
    background: #0f172a;
    color: #38bdf8;
    padding: 10px 14px;
    border-radius: 6px;
    font-family: 'JetBrains Mono', Consolas, 'Courier New', monospace;
    font-size: 10px;
    line-height: 1.4;
    white-space: pre-wrap;
    word-break: break-word;
    page-break-inside: avoid;
    break-inside: avoid;
  }}
  .math-block {{
    background: #f8fafc;
    border: 1px solid #e2e8f0;
    border-radius: 4px;
    padding: 6px 12px;
    margin: 8px 0;
    text-align: center;
    font-family: 'Cambria Math', 'KaTeX_Math', 'Times New Roman', serif;
    font-size: 13px;
    font-weight: 600;
    color: #1e293b;
    page-break-inside: avoid;
    break-inside: avoid;
  }}
  .math-inline {{
    font-family: 'Cambria Math', 'KaTeX_Math', 'Times New Roman', serif;
    font-size: 12.5px;
    font-weight: 600;
    color: #1e293b;
    padding: 0 2px;
  }}
  .callout {{
    border-left: 4px solid #6366f1;
    background: #f8fafc;
    padding: 8px 12px;
    margin: 8px 0;
    font-style: italic;
    color: #334155;
    page-break-inside: avoid;
    break-inside: avoid;
  }}
  .quick-check-box {{
    background: #f0fdf4;
    border: 1px solid #bbf7d0;
    border-radius: 6px;
    padding: 10px;
    margin-top: 12px;
  }}
  .quiz-box {{
    background: #f5f3ff;
    border: 1px solid #ddd6fe;
    border-radius: 6px;
    padding: 10px;
    margin-top: 12px;
  }}
  .widget-box {{
    background: #eff6ff;
    border: 1px solid #bfdbfe;
    border-radius: 6px;
    padding: 10px;
    margin-top: 12px;
  }}
  .box-badge {{
    font-size: 10px;
    font-weight: 800;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    color: #059669;
    margin-bottom: 6px;
  }}
  .quiz-box .box-badge {{
    color: #7c3aed;
  }}
  .quick-check-box, .quiz-box, .widget-box, .printable-activity {{
    page-break-inside: avoid;
    break-inside: avoid;
  }}
  .qc-item, .quiz-item {{
    page-break-inside: avoid;
    break-inside: avoid;
    margin-bottom: 8px;
    padding-bottom: 8px;
    border-bottom: 1px dashed #cbd5e1;
  }}
  .qc-item:last-child, .quiz-item:last-child {{
    border-bottom: none;
    margin-bottom: 0;
    padding-bottom: 0;
  }}
  .qc-q {{
    font-weight: 600;
    color: #1e293b;
    margin-bottom: 4px;
  }}
  .qc-options {{
    list-style: none;
    padding-left: 0;
    margin: 4px 0 6px 0;
  }}
  .option {{
    padding: 2px 6px;
    border-radius: 4px;
    font-size: 12px;
  }}
  .option.correct {{
    background: #dcfce7;
    color: #166534;
    font-weight: 600;
  }}
  .radio-mark {{
    margin-right: 4px;
    font-size: 10px;
  }}
  .correct-tag {{
    font-size: 9px;
    color: #15803d;
    font-weight: 700;
  }}
  .qc-exp {{
    font-size: 11px;
    color: #475569;
    background: #ffffff;
    padding: 4px 8px;
    border-radius: 4px;
    margin-top: 2px;
  }}
  .qc-warmup {{
    font-size: 11px;
    color: #64748b;
    font-style: italic;
    margin-top: 2px;
  }}
  .widget-name {{
    font-size: 12px;
    color: #1e40af;
    margin-bottom: 4px;
  }}
  .widget-json pre {{
    background: #1e293b;
    color: #e2e8f0;
    padding: 6px 10px;
    border-radius: 4px;
    font-size: 10px;
    margin: 0;
    white-space: pre-wrap;
    word-break: break-word;
  }}
</style>
</head>
<body>

<div class="header">
  <div class="brand-title">{brand_title}</div>
  <div class="lesson-title">{title}</div>
  <div class="summary">{summary}</div>
  <div class="meta-grid">
    <div class="meta-item"><strong>Lesson ID</strong> {lesson_id}</div>
    <div class="meta-item"><strong>Tier</strong> {tier}</div>
    <div class="meta-item"><strong>Estimated</strong> {est_min} mins</div>
    <div class="meta-item"><strong>XP Reward</strong> +{xp} XP</div>
    <div class="meta-item"><strong>Components</strong> {components}</div>
  </div>
</div>

{step_html}

</body>
</html>
"""

    with open(output_html_path, "w", encoding="utf-8") as f:
        f.write(html)


def export_pdf(html_path, pdf_path):
    cmd = [
        "google-chrome-stable",
        "--headless",
        "--disable-gpu",
        "--no-sandbox",
        f"--print-to-pdf={pdf_path}",
        html_path
    ]
    subprocess.run(cmd, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 generate_lesson_pdf.py <lesson_id> [--mode learner|educator]")
        sys.exit(1)

    lesson_id = sys.argv[1]
    mode = "learner"
    if "--mode" in sys.argv:
        mode_idx = sys.argv.index("--mode")
        if mode_idx + 1 < len(sys.argv):
            mode = sys.argv[mode_idx + 1]

    lesson_path = f"assets/curriculum/lessons/{lesson_id}.json"
    if not os.path.exists(lesson_path):
        print(f"File not found: {lesson_path}")
        sys.exit(1)

    with open(lesson_path, "r", encoding="utf-8") as f:
        data = json.load(f)

    os.makedirs("reports/lessons_pdf", exist_ok=True)
    suffix = "_educator" if mode == "educator" else ""
    html_path = f"reports/lessons_pdf/{lesson_id}{suffix}.html"
    pdf_path = f"reports/lessons_pdf/{lesson_id}{suffix}.pdf"

    render_lesson_to_html(data, html_path, mode=mode)
    export_pdf(html_path, pdf_path)
    print(f"Successfully generated PDF ({mode} mode): {pdf_path}")

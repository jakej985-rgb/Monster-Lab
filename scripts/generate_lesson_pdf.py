import json
import os
import sys
import subprocess

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

    step_html = ""
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

            if line.startswith("### "):
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
        import re
        parsed_body = re.sub(r'\*\*(.*?)\*\*', r'<strong>\1</strong>', parsed_body)

        # Quick check questions if any
        qc_html = ""
        quick_checks = step.get("quickCheck", [])
        if quick_checks:
            badge_title = "Diagnostic Pre-Test (QuickCheck)" if mode == "educator" else "Check Your Understanding"
            qc_html += f"<div class='quick-check-box'><div class='box-badge'>{badge_title}</div>"
            for q_idx, qc in enumerate(quick_checks, 1):
                q_text = qc.get("question", "")
                options = qc.get("options", [])
                correct_idx = qc.get("correctIndex", 0)
                explanation = qc.get("explanation", "")
                warmup = qc.get("warmupExplanation", "")
                
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
        interactive_config = step.get("interactiveConfig", {})
        config_html = ""
        if widget_type:
            printable_task = f"""
            <div class='widget-box'>
                <div class='widget-badge'>Hands-On Experiment Sheet (Interactive Simulation)</div>
                <div class='widget-name'><strong>Simulated Lab Activity:</strong> <code>{widget_type}</code></div>
                <div class='printable-activity'>
                    <p><strong>Learner Action:</strong> Open this activity in the Monster Lab app or breadboard workstation. Complete the physical/simulated steps:</p>
                    <ol>
                        <li><strong>Predict:</strong> What outcome do you expect to observe before turning power on or sliding controls?</li>
                        <li><strong>Observe & Record:</strong> Note the telemetry, indicator states, or component response: ________________________</li>
                        <li><strong>Explain:</strong> Why did the circuit or code behave this way? _________________________________________</li>
                    </ol>
                </div>
            </div>
            """
            config_html += printable_task
        elif interactive_config and "questions" in interactive_config:
            quiz_questions = interactive_config.get("questions", [])
            badge_title = "Step 4: Checkpoint Assessment Key" if mode == "educator" else "Step 4: Mastery Checkpoint Quiz"
            config_html += f"<div class='quiz-box'><div class='box-badge'>{badge_title}</div>"
            for q_idx, q in enumerate(quiz_questions, 1):
                q_text = q.get("question", "")
                options = q.get("options", [])
                correct_idx = q.get("correctIndex", 0)
                explanation = q.get("explanation", "")
                
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
    margin: 1.5cm;
  }}
  body {{
    font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
    color: #1a1a2e;
    background: #ffffff;
    line-height: 1.5;
    font-size: 13px;
    margin: 0;
    padding: 0;
  }}
  .header {{
    border-bottom: 2px solid #6366f1;
    padding-bottom: 12px;
    margin-bottom: 20px;
  }}
  .brand-title {{
    font-size: 11px;
    text-transform: uppercase;
    letter-spacing: 2px;
    color: #6366f1;
    font-weight: 800;
  }}
  .lesson-title {{
    font-size: 24px;
    font-weight: 800;
    color: #0f172a;
    margin: 4px 0 8px 0;
  }}
  .summary {{
    font-size: 14px;
    color: #475569;
    margin-bottom: 12px;
  }}
  .meta-grid {{
    display: grid;
    grid-template-columns: repeat(5, 1fr);
    background: #f8fafc;
    border: 1px solid #e2e8f0;
    border-radius: 8px;
    padding: 8px 12px;
    font-size: 11px;
  }}
  .meta-item strong {{
    display: block;
    color: #64748b;
    font-size: 9px;
    text-transform: uppercase;
  }}
  .step-container {{
    border: 1px solid #e2e8f0;
    border-radius: 8px;
    margin-bottom: 18px;
    page-break-inside: avoid;
    background: #ffffff;
  }}
  .step-header {{
    background: #f1f5f9;
    border-bottom: 1px solid #e2e8f0;
    padding: 8px 14px;
    display: flex;
    align-items: center;
    gap: 10px;
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
    font-size: 11px;
    overflow-x: auto;
    line-height: 1.4;
  }}
  .callout {{
    border-left: 4px solid #6366f1;
    background: #f8fafc;
    padding: 8px 12px;
    margin: 8px 0;
    font-style: italic;
    color: #334155;
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
  .widget-box .box-badge {{
    color: #2563eb;
  }}
  .qc-item, .quiz-item {{
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
  }}
</style>
</head>
<body>

<div class="header">
  <div class="brand-title">Monster Lab • STEM Curriculum Dossier</div>
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

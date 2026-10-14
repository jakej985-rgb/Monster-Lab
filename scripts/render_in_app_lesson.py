import json
import os
import sys
import subprocess
import re
import tempfile
import shutil
import glob
import argparse
import html
from concurrent.futures import ThreadPoolExecutor, as_completed
import markdown

def format_text(text):
    """Format and escape plain text fields (titles, questions, options, insight text)."""
    if not text:
        return ""
    escaped = html.escape(str(text), quote=True)
    # Convert inline code `foo` to <code>foo</code>
    escaped = re.sub(r'`([^`\n]+)`', r'<code>\1</code>', escaped)
    # Convert bold **foo** to <strong>foo</strong>
    escaped = re.sub(r'\*\*([^*]+)\*\*', r'<strong>\1</strong>', escaped)
    return escaped

def sanitize_md(text):
    """Escape angle brackets and ampersands outside of code blocks/inline code."""
    parts = re.split(r'(```[\s\S]*?```|`[^`\n]*?`)', text)
    out = []
    for p in parts:
        if p.startswith('`'):
            out.append(p)
        else:
            out.append(p.replace('&', '&amp;').replace('<', '&lt;').replace('>', '&gt;'))
    return ''.join(out)

def prepare_markdown(md_text):
    """Normalize markdown transitions so headings, lists, quotes, and tables parse cleanly."""
    sanitized = sanitize_md(md_text)
    lines = sanitized.split('\n')
    out = []
    in_code = False
    for i, line in enumerate(lines):
        if line.startswith('```'):
            in_code = not in_code
            out.append(line)
            continue
        if in_code:
            out.append(line)
            continue

        prev = lines[i - 1] if i > 0 else ""
        if i > 0 and prev.strip() != '' and not prev.startswith('```'):
            is_cur_ul = bool(re.match(r'^[-*]\s', line))
            is_prev_ul = bool(re.match(r'^[-*]\s', prev))
            is_cur_ol = bool(re.match(r'^\d+\.\s', line))
            is_prev_ol = bool(re.match(r'^\d+\.\s', prev))
            is_cur_h = bool(re.match(r'^#{1,6}\s', line))
            is_cur_table = line.startswith('|')
            is_prev_table = prev.startswith('|')
            is_cur_bq = line.startswith('> ')
            is_prev_bq = prev.startswith('> ')

            if ((is_cur_ul and not is_prev_ul) or
                (is_cur_ol and not is_prev_ol) or
                (not is_cur_ul and is_prev_ul and line.strip()) or
                (not is_cur_ol and is_prev_ol and line.strip()) or
                is_cur_h or
                (is_cur_table and not is_prev_table) or
                (is_cur_bq and not is_prev_bq)):
                out.append('')
        out.append(line)
    return '\n'.join(out)

def render_markdown(md_text):
    """Render markdown into clean HTML with fenced code and table support."""
    prepared = prepare_markdown(md_text)
    return markdown.markdown(prepared, extensions=['fenced_code', 'tables'])

def render_step_card(step, step_idx, total_steps, lesson_id, lesson_data):
    raw_step_title = step.get("title", f"Step {step_idx}")
    step_title = format_text(raw_step_title)
    step_type = step.get("type", "story")
    widget_type = step.get("interactiveWidgetType", None)
    markdown_content = step.get("markdownContent", "")
    quick_checks = step.get("quickCheck", [])
    interactive_config = step.get("interactiveConfig", {})
    xp_reward = lesson_data.get("xpReward", 10)
    est_minutes = lesson_data.get("estimatedMinutes", 10)

    # Markdown rendering
    parsed_body = render_markdown(markdown_content)

    # 1. Quick Check Badge & Modal view
    qc_badge_html = ""
    if quick_checks:
        qc_badge_html = """
        <div class="quickcheck-pill">
            <span class="qc-icon">🧠</span>
            <span class="qc-text">Quick Check Available (Optional Readiness Diagnostic)</span>
        </div>
        """

    # 2. Render Widget / Simulator Mockup as displayed in app
    widget_html = ""
    if widget_type == "visualFlowDiagram":
        widget_html = """
        <div class="app-widget-card visual-flow-widget">
            <div class="widget-header-bar">
                <div class="widget-icon-title">
                    <span class="widget-icon">⚡</span>
                    <div>
                        <div class="widget-title">Signal Flow Simulation</div>
                        <div class="widget-subtitle">Tap nodes to explore • Test signal propagation</div>
                    </div>
                </div>
                <div class="chip-badge">SYSTEM LOOP</div>
            </div>
            
            <div class="flow-diagram-grid">
                <div class="flow-node active">
                    <div class="node-icon">👀</div>
                    <div class="node-label">1. SENSE</div>
                    <div class="node-role">Pushbutton / LDR</div>
                    <div class="node-state">Active Sensing</div>
                </div>
                <div class="flow-arrow">➔</div>
                <div class="flow-node">
                    <div class="node-icon">〰️</div>
                    <div class="node-label">2. TRANSMIT</div>
                    <div class="node-role">Jumper Wires</div>
                    <div class="node-state">Voltage Level</div>
                </div>
                <div class="flow-arrow">➔</div>
                <div class="flow-node">
                    <div class="node-icon">🤖</div>
                    <div class="node-label">3. DECIDE</div>
                    <div class="node-role">ATmega328P CPU</div>
                    <div class="node-state">Running loop()</div>
                </div>
                <div class="flow-arrow">➔</div>
                <div class="flow-node">
                    <div class="node-icon">💡</div>
                    <div class="node-label">4. ACT</div>
                    <div class="node-role">LED / Buzzer / Motor</div>
                    <div class="node-state">Physical Output</div>
                </div>
            </div>

            <div class="flow-action-row">
                <button class="app-button-secondary">⚡ Test Signal Pulse ➔</button>
                <div class="pulse-status-text">Signal state: IDLE (Awaiting trigger)</div>
            </div>
        </div>
        """
    elif widget_type == "rfidCouplingSimulator":
        widget_html = """
        <div class="app-widget-card rfid-simulator-card">
            <div class="widget-header-bar">
                <div class="widget-icon-title">
                    <span class="widget-icon">📡</span>
                    <div>
                        <div class="widget-title">RFID Coupling &amp; UID Read Simulator</div>
                        <div class="widget-subtitle">Teaching model: 13.56 MHz Near-Field Coupling • 3.0 cm Simulated Threshold</div>
                    </div>
                </div>
                <div class="chip-badge">STATIC REVIEW MOCKUP</div>
            </div>

            <div class="rfid-mockup-body">
                <div class="rfid-device-row">
                    <div class="rfid-device-col">
                        <div class="device-icon">📡</div>
                        <div class="device-label">RC522 reader</div>
                        <div class="device-sub">13.56 MHz EM Field</div>
                    </div>
                    <div class="rfid-wave-indicator">
                        <div class="wave-icon">〰️</div>
                        <div class="wave-text">Near-Field Magnetic Wave</div>
                    </div>
                    <div class="rfid-device-col">
                        <div class="device-icon">💳</div>
                        <div class="device-label">Passive tag</div>
                        <div class="device-sub unpowered">Unpowered (&gt;3.0 cm)</div>
                    </div>
                </div>

                <div class="rfid-scale-box">
                    <div class="scale-info-row">
                        <span class="scale-title">Distance Scale (0 to 6 cm)</span>
                        <span class="threshold-pill">Simulated Read Threshold: 3.0 cm</span>
                    </div>
                    <div class="scale-track-wrap">
                        <div class="scale-track-bar"></div>
                        <div class="scale-threshold-line" style="left: 50%;">
                            <span class="threshold-text">3.0 cm threshold</span>
                        </div>
                        <div class="scale-tag-pin" style="left: 83.3%;">
                            <span class="tag-pin-label">💳 Tag at 5.0 cm (Default)</span>
                        </div>
                    </div>
                    <div class="scale-tick-labels">
                        <span>0 cm</span>
                        <span>1 cm</span>
                        <span>2 cm</span>
                        <span class="threshold-tick">3 cm (Threshold)</span>
                        <span>4 cm</span>
                        <span class="default-tick">5 cm (Default)</span>
                        <span>6 cm</span>
                    </div>
                </div>

                <div class="rfid-action-box">
                    <div class="power-status-pill out-of-range">
                        <span class="pill-dot">⚠️</span>
                        <span>TAG NOT POWERED — OUT OF RANGE (5.0 cm &gt; 3.0 cm threshold)</span>
                    </div>
                    <div class="action-btn-row">
                        <button class="mockup-btn btn-disabled" disabled>🔒 Read UID (Unavailable out of range)</button>
                        <button class="mockup-btn btn-reset">↺ Reset (5.0 cm)</button>
                    </div>
                </div>

                <div class="rfid-sequence-box">
                    <div class="sequence-title">IN-RANGE READ SEQUENCE (when distance &le; 3.0 cm):</div>
                    <div class="sequence-stages-grid">
                        <div class="stage-cell">
                            <div class="stage-step">Stage 1</div>
                            <div class="stage-name">Tag load modulation</div>
                            <div class="stage-desc">Tag shifts coil load to modulate 13.56 MHz subcarrier</div>
                        </div>
                        <div class="stage-arrow">➔</div>
                        <div class="stage-cell">
                            <div class="stage-step">Stage 2</div>
                            <div class="stage-name">RC522 receives</div>
                            <div class="stage-desc">MFRC522 detects RF amplitude changes from tag coil</div>
                        </div>
                        <div class="stage-arrow">➔</div>
                        <div class="stage-cell">
                            <div class="stage-step">Stage 3</div>
                            <div class="stage-name">SPI transfer</div>
                            <div class="stage-desc">RC522 → Uno MISO at safe 3.3V logic level</div>
                        </div>
                    </div>
                    <div class="serial-output-mockup">
                        <div class="serial-title">Serial Monitor Output:</div>
                        <code class="serial-text">UID (example): DE AD BE EF</code>
                    </div>
                </div>

                <div class="spi-roles-box">
                    <div class="spi-row"><span class="spi-pin">MOSI</span><span class="spi-desc">Uno → RC522: command data</span></div>
                    <div class="spi-row"><span class="spi-pin">SCK</span><span class="spi-desc">Uno → RC522: clock</span></div>
                    <div class="spi-row"><span class="spi-pin">CS</span><span class="spi-desc">Uno → RC522: select reader</span></div>
                    <div class="spi-row"><span class="spi-pin">MISO</span><span class="spi-desc">RC522 → Uno: returned UID bytes</span></div>
                </div>

                <div class="rfid-summary-footer">
                    <span>💡 <strong>Activity Summary:</strong> Move the tag into range (&le;3 cm simulated threshold) to power the passive tag via inductive coupling, then tap Read UID to inspect the 4-stage transfer and example UID DE AD BE EF in the Serial Monitor.</span>
                </div>
            </div>
        </div>
        """
    elif widget_type and widget_type != "miniQuiz":
        safe_wtype = html.escape(widget_type)
        if interactive_config:
            dump_str = html.escape(json.dumps(interactive_config, indent=2))
            config_dump_html = f"<div class=\"config-dump\"><pre><code>{dump_str}</code></pre></div>"
        else:
            config_dump_html = "<div class=\"config-dump\"><code>Active state initialized • Simulator Ready</code></div>"

        widget_html = f"""
        <div class="app-widget-card">
            <div class="widget-header-bar">
                <span class="widget-icon">🧩</span>
                <div>
                    <div class="widget-title">Interactive Simulator: {safe_wtype}</div>
                    <div class="widget-subtitle">Monster Lab Native Flutter Widget</div>
                </div>
            </div>
            <div class="widget-placeholder-body">
                <div class="placeholder-icon">⚙️</div>
                <div class="placeholder-text">Simulating real-time hardware physics for <strong>{safe_wtype}</strong></div>
                {config_dump_html}
            </div>
        </div>
        """

    # 3. Quiz Checkpoint View as displayed in app
    quiz_html = ""
    if step_type == "quizCheckpoint" or "questions" in interactive_config:
        questions = interactive_config.get("questions", [])
        q_cards = ""
        for q_idx, q in enumerate(questions, 1):
            q_text = format_text(q.get("question", ""))
            options = q.get("options", [])
            correct_idx = q.get("correctIndex", 0)
            explanation = format_text(q.get("explanation", ""))

            opts_html = ""
            for opt_idx, opt in enumerate(options):
                is_correct = (opt_idx == correct_idx)
                safe_opt = format_text(opt)
                opts_html += f"""
                <div class="quiz-option-row {'selected-correct' if is_correct else ''}">
                    <div class="quiz-radio">{'●' if is_correct else '○'}</div>
                    <div class="quiz-opt-text">{safe_opt}</div>
                    {'<div class="correct-badge">CORRECT</div>' if is_correct else ''}
                </div>
                """

            q_cards += f"""
            <div class="app-quiz-question-card">
                <div class="question-header">Question {q_idx} of {len(questions)}</div>
                <div class="question-title">{q_text}</div>
                <div class="options-container">{opts_html}</div>
                <div class="explanation-box">
                    <span class="exp-icon">💡</span>
                    <span><strong>Pedagogical Insight:</strong> {explanation}</span>
                </div>
            </div>
            """

        quiz_html = f"""
        <div class="app-quiz-container">
            <div class="quiz-container-header">
                <div class="quiz-icon-large">🏆</div>
                <div>
                    <div class="quiz-main-title">Checkpoint Assessment Exam</div>
                    <div class="quiz-sub">Answer correctly to unlock +{xp_reward} XP</div>
                </div>
            </div>
            {q_cards}
        </div>
        """

    # 4. Quick Check Expanded View (below the screen for full review)
    qc_details_html = ""
    if quick_checks:
        qc_items = ""
        for q_idx, qc in enumerate(quick_checks, 1):
            q_text = format_text(qc.get("question", ""))
            options = qc.get("options", [])
            correct_idx = qc.get("correctIndex", 0)
            exp = format_text(qc.get("explanation", ""))
            warmup = format_text(qc.get("warmupExplanation", ""))

            opts = ""
            for opt_idx, opt in enumerate(options):
                is_correct = (opt_idx == correct_idx)
                safe_opt = format_text(opt)
                opts += f"""
                <div class="qc-opt {'qc-opt-correct' if is_correct else ''}">
                    <span>{'●' if is_correct else '○'}</span> {safe_opt}
                </div>
                """

            warmup_html = f'<div class="qc-warmup-box"><strong>Warmup Guidance:</strong> {warmup}</div>' if warmup else ''
            qc_items += f"""
            <div class="qc-sub-card">
                <div class="qc-q-title"><strong>Pre-Test Diagnostic Q{q_idx}:</strong> {q_text}</div>
                <div class="qc-opts-list">{opts}</div>
                <div class="qc-feedback"><strong>Explanation:</strong> {exp}</div>
                {warmup_html}
            </div>
            """

        qc_details_html = f"""
        <div class="quick-check-modal-render">
            <div class="modal-header">
                <span class="modal-badge">MODAL OVERLAY PREVIEW</span>
                <span class="modal-title">Readiness Pre-Test: {step_title}</span>
            </div>
            {qc_items}
        </div>
        """

    # Progress fraction
    progress_pct = int((step_idx / total_steps) * 100)
    next_button_text = f"Complete Lesson (+{xp_reward} XP)" if step_idx == total_steps else "Next Step ➔"

    def generate_single_viewport_frame(viewport_class, viewport_label, viewport_badge):
        return f"""
        <div class="viewport-column {viewport_class}">
            <div class="viewport-header">
                <span class="viewport-label">{viewport_label}</span>
                <span class="viewport-badge">{viewport_badge}</span>
            </div>
            <div class="app-screen-frame {viewport_class}-frame">
                <!-- APP TOP BAR -->
                <div class="app-bar">
                    <div class="app-bar-left">
                        <span class="back-arrow">←</span>
                        <span class="app-bar-title">Learn Lab Session</span>
                    </div>
                    <div class="app-bar-right">
                        <span class="imm-mode-pill">IMMERSIVE MODE</span>
                    </div>
                </div>

                <!-- APP BODY CONTAINER -->
                <div class="app-body">
                    <!-- STEP PROGRESS BAR -->
                    <div class="progress-track">
                        <div class="progress-fill" style="width: {progress_pct}%;"></div>
                    </div>
                    
                    <div class="step-meta-row">
                        <div class="step-counter">STEP {step_idx} OF {total_steps}</div>
                        <div class="step-timing">{est_minutes} min • +{xp_reward} XP</div>
                    </div>

                    <div class="step-heading-row">
                        <h2 class="step-main-title">{step_title}</h2>
                        <span class="step-pill-badge">{step_type.upper()}</span>
                    </div>

                    {qc_badge_html}

                    <!-- MAIN MARKDOWN CARD -->
                    <div class="monster-card markdown-card">
                        {parsed_body}
                    </div>

                    {widget_html}
                    {quiz_html}
                    {qc_details_html}

                    <!-- ACTION BAR (STICKY BOTTOM BUTTON) -->
                    <div class="app-action-bar">
                        <button class="app-btn-prev">Previous Step</button>
                        <button class="app-btn-next">
                            {next_button_text}
                        </button>
                    </div>
                </div>
            </div>
        </div>
        """

    mobile_card = generate_single_viewport_frame("mobile-viewport", "📱 Mobile Form Factor (390px)", "iPhone / Small Screen")
    desktop_card = generate_single_viewport_frame("desktop-viewport", "💻 Desktop / Tablet Form Factor (720px)", "Tablet / Desktop Screen")

    return f"""
    <div class="dual-viewport-step-container">
        <div class="step-section-title-bar">
            <div class="step-badge-large">STEP {step_idx} OF {total_steps}</div>
            <div class="step-section-heading">{step_title} <span class="type-tag">({step_type.upper()})</span></div>
        </div>
        <div class="dual-viewport-grid">
            {mobile_card}
            {desktop_card}
        </div>
    </div>
    """


def render_full_app_lesson(lesson_id, output_html_path, output_pdf_path):
    lesson_path = f"assets/curriculum/lessons/{lesson_id}.json"
    with open(lesson_path, "r", encoding="utf-8") as f:
        lesson_data = json.load(f)

    title = lesson_data.get("title", "")
    course_id = lesson_data.get("courseId", "")
    steps = lesson_data.get("steps", [])

    safe_title = format_text(title)
    safe_course_id = html.escape(str(course_id))
    safe_lesson_id = html.escape(str(lesson_id))

    screens_html = ""
    for idx, step in enumerate(steps, 1):
        screens_html += render_step_card(step, idx, len(steps), lesson_id, lesson_data)
        if idx < len(steps):
            screens_html += "<div class='screen-separator'></div>"

    html_content = f"""<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Monster Lab Dual Form Factor In-App: {safe_title} ({safe_lesson_id})</title>
<style>
  @import url('https://fonts.googleapis.com/css2?family=Fredoka:wght@400;600;700&family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;600&display=swap');

  @page {{
    size: A3 landscape;
    margin: 1cm;
  }}

  * {{
    box-sizing: border-box;
  }}

  body {{
    font-family: 'Inter', -apple-system, sans-serif;
    background: #090a10;
    color: #f8fafc;
    margin: 0;
    padding: 24px;
    font-size: 13px;
    line-height: 1.5;
  }}

  .page-intro-header {{
    text-align: center;
    margin-bottom: 24px;
    padding: 20px;
    background: #1e1e2e;
    border-radius: 16px;
    border: 1px solid #2a2a3c;
  }}

  .brand-badge {{
    display: inline-block;
    background: #6c5ce7;
    color: white;
    font-weight: 800;
    font-size: 11px;
    letter-spacing: 1.5px;
    padding: 4px 12px;
    border-radius: 20px;
    margin-bottom: 8px;
  }}

  .intro-title {{
    font-family: 'Fredoka', cursive, sans-serif;
    font-size: 26px;
    font-weight: 700;
    color: #ffffff;
    margin: 4px 0 6px 0;
  }}

  .intro-sub {{
    color: #a4b0be;
    font-size: 14px;
  }}

  .dual-viewport-step-container {{
    margin-bottom: 30px;
    page-break-inside: avoid;
  }}

  .step-section-title-bar {{
    display: flex;
    align-items: center;
    gap: 12px;
    margin-bottom: 16px;
    background: #181926;
    border: 1px solid #2a2a3c;
    border-radius: 12px;
    padding: 10px 16px;
  }}

  .step-badge-large {{
    background: #6c5ce7;
    color: #ffffff;
    font-weight: 800;
    font-size: 11px;
    padding: 4px 10px;
    border-radius: 6px;
  }}

  .step-section-heading {{
    font-size: 17px;
    font-weight: 700;
    color: #ffffff;
  }}

  .type-tag {{
    color: #00cec9;
    font-size: 12px;
    font-weight: 600;
  }}

  .dual-viewport-grid {{
    display: flex;
    gap: 24px;
    justify-content: center;
    align-items: flex-start;
  }}

  .viewport-column {{
    display: flex;
    flex-direction: column;
  }}

  .viewport-header {{
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 8px;
    padding: 0 4px;
  }}

  .viewport-label {{
    font-size: 12px;
    font-weight: 700;
    color: #a29bfe;
  }}

  .viewport-badge {{
    font-size: 10px;
    background: #2a2a3c;
    color: #a4b0be;
    padding: 2px 6px;
    border-radius: 4px;
  }}

  .mobile-viewport {{
    width: 390px;
    flex-shrink: 0;
  }}

  .desktop-viewport {{
    width: 680px;
    flex-grow: 1;
    max-width: 760px;
  }}

  .screen-separator {{
    height: 30px;
    border-bottom: 2px dashed #2a2a3c;
    margin: 30px 0;
    page-break-after: always;
  }}

  /* FLUTTER APP CONTAINER MOCKUP */
  .app-screen-frame {{
    width: 100%;
    background: #12121c;
    border: 2px solid #2a2a3c;
    border-radius: 24px;
    overflow: hidden;
    box-shadow: 0 12px 40px rgba(0,0,0,0.6);
  }}

  .mobile-viewport-frame {{
    border-radius: 28px;
    border: 2px solid #6c5ce7;
  }}

  .desktop-viewport-frame {{
    border-radius: 20px;
    border: 2px solid #00cec9;
  }}

  /* APP BAR */
  .app-bar {{
    height: 52px;
    background: #1e1e2e;
    border-bottom: 1px solid #2a2a3c;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 16px;
  }}

  .app-bar-left {{
    display: flex;
    align-items: center;
    gap: 12px;
  }}

  .back-arrow {{
    font-size: 18px;
    color: #00cec9;
    font-weight: bold;
  }}

  .app-bar-title {{
    font-weight: 700;
    font-size: 15px;
    color: #f8fafc;
  }}

  .imm-mode-pill {{
    background: rgba(108, 92, 231, 0.2);
    color: #a29bfe;
    font-size: 10px;
    font-weight: 700;
    padding: 3px 8px;
    border-radius: 6px;
  }}

  /* APP BODY */
  .app-body {{
    padding: 18px 20px 24px 20px;
  }}

  .progress-track {{
    height: 8px;
    background: #2a2a3c;
    border-radius: 4px;
    overflow: hidden;
    margin-bottom: 12px;
  }}

  .progress-fill {{
    height: 100%;
    background: #6c5ce7;
    border-radius: 4px;
  }}

  .step-meta-row {{
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 8px;
  }}

  .step-counter {{
    color: #a29bfe;
    font-size: 12px;
    font-weight: 800;
    letter-spacing: 0.5px;
  }}

  .step-timing {{
    color: #a4b0be;
    font-size: 11px;
    font-weight: 500;
  }}

  .step-heading-row {{
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 14px;
  }}

  .step-main-title {{
    font-size: 19px;
    font-weight: 800;
    color: #ffffff;
    margin: 0;
  }}

  .step-pill-badge {{
    background: #2a2a3c;
    color: #00cec9;
    font-size: 10px;
    font-weight: 700;
    padding: 3px 8px;
    border-radius: 6px;
  }}

  /* QUICK CHECK PILL */
  .quickcheck-pill {{
    display: inline-flex;
    align-items: center;
    gap: 8px;
    background: rgba(108, 92, 231, 0.15);
    border: 1px solid rgba(108, 92, 231, 0.3);
    color: #a29bfe;
    padding: 6px 12px;
    border-radius: 10px;
    font-size: 11px;
    font-weight: 600;
    margin-bottom: 14px;
  }}

  /* MONSTER CARD */
  .monster-card {{
    background: #1e1e2e;
    border: 1px solid #2a2a3c;
    border-radius: 16px;
    padding: 16px;
    margin-bottom: 16px;
  }}

  .monster-card h1 {{
    color: #00cec9;
    font-size: 18px;
    margin: 10px 0 6px 0;
    font-weight: 800;
  }}

  .monster-card h2 {{
    color: #6c5ce7;
    font-size: 16px;
    margin: 10px 0 6px 0;
    font-weight: 700;
  }}

  .monster-card h3, .md-h3 {{
    color: #00cec9;
    font-size: 15px;
    margin: 8px 0 6px 0;
    font-weight: 700;
  }}

  .monster-card h4, .md-h4 {{
    color: #ffa502;
    font-size: 13px;
    margin: 8px 0 4px 0;
    font-weight: 600;
  }}

  .monster-card p, .md-p {{
    color: #f8fafc;
    margin: 0 0 8px 0;
    line-height: 1.6;
  }}

  .monster-card ul, .monster-card ol {{
    margin: 6px 0 10px 0;
    padding-left: 22px;
  }}

  .monster-card li, .md-li {{
    color: #e2e8f0;
    margin-bottom: 4px;
    line-height: 1.5;
  }}

  .monster-card blockquote, .callout {{
    border-left: 4px solid #6c5ce7;
    background: rgba(108, 92, 231, 0.1);
    padding: 8px 12px;
    margin: 10px 0;
    border-radius: 0 8px 8px 0;
    color: #dcdde1;
    font-size: 12px;
  }}

  .monster-card blockquote p {{
    margin: 0;
  }}

  .monster-card code {{
    font-family: 'JetBrains Mono', monospace;
    font-size: 11px;
    color: #00e676;
    background: #1e293b;
    padding: 2px 5px;
    border-radius: 4px;
  }}

  .monster-card pre, .code-block {{
    background: #090a10;
    border: 1px solid #2a2a3c;
    border-radius: 8px;
    padding: 12px;
    margin: 10px 0;
    overflow-x: auto;
  }}

  .monster-card pre code, .code-block code {{
    background: transparent;
    padding: 0;
    color: #38bdf8;
    font-size: 11px;
    font-family: 'JetBrains Mono', monospace;
    line-height: 1.45;
  }}

  .monster-card table {{
    width: 100%;
    border-collapse: collapse;
    margin: 12px 0;
    font-size: 11.5px;
  }}

  .monster-card th {{
    background: #181926;
    border: 1px solid #2a2a3c;
    padding: 8px 10px;
    color: #00cec9;
    font-weight: 700;
    text-align: left;
  }}

  .monster-card td {{
    border: 1px solid #2a2a3c;
    padding: 7px 10px;
    color: #e2e8f0;
    background: #12121c;
  }}

  /* WIDGET STYLING */
  .app-widget-card {{
    background: #1e1e2e;
    border: 1.5px solid #00cec9;
    border-radius: 16px;
    padding: 16px;
    margin-bottom: 16px;
  }}

  .widget-header-bar {{
    display: flex;
    justify-content: space-between;
    align-items: center;
    border-bottom: 1px solid #2a2a3c;
    padding-bottom: 10px;
    margin-bottom: 14px;
  }}

  .widget-icon-title {{
    display: flex;
    align-items: center;
    gap: 10px;
  }}

  .widget-icon {{
    font-size: 20px;
  }}

  .widget-title {{
    font-weight: 700;
    font-size: 13px;
    color: #ffffff;
  }}

  .widget-subtitle {{
    font-size: 10px;
    color: #a4b0be;
  }}

  .chip-badge {{
    background: rgba(0, 206, 201, 0.15);
    color: #00cec9;
    font-size: 9px;
    font-weight: 800;
    padding: 3px 8px;
    border-radius: 6px;
  }}

  .widget-placeholder-body {{
    padding: 6px 0;
  }}

  .placeholder-icon {{
    font-size: 20px;
    margin-bottom: 4px;
  }}

  .placeholder-text {{
    font-size: 12px;
    color: #a4b0be;
    margin-bottom: 8px;
  }}

  .config-dump {{
    background: #090a10;
    border: 1px solid #2a2a3c;
    border-radius: 8px;
    padding: 10px 12px;
  }}

  .config-dump pre {{
    margin: 0;
    padding: 0;
    background: transparent;
    border: none;
  }}

  .config-dump code {{
    font-family: 'JetBrains Mono', monospace;
    font-size: 11px;
    color: #38bdf8;
    white-space: pre-wrap;
    word-break: break-word;
    line-height: 1.4;
  }}

  .flow-diagram-grid {{
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 12px 6px;
  }}

  .flow-node {{
    background: #12121c;
    border: 1px solid #2a2a3c;
    border-radius: 12px;
    padding: 10px 8px;
    text-align: center;
    width: 22%;
  }}

  .flow-node.active {{
    border-color: #00cec9;
    box-shadow: 0 0 12px rgba(0, 206, 201, 0.3);
  }}

  .node-icon {{
    font-size: 20px;
    margin-bottom: 4px;
  }}

  .node-label {{
    font-size: 10px;
    font-weight: 800;
    color: #00cec9;
  }}

  .node-role {{
    font-size: 9px;
    color: #f8fafc;
    margin-top: 2px;
  }}

  .node-state {{
    font-size: 8px;
    color: #a4b0be;
    margin-top: 2px;
  }}

  .flow-arrow {{
    color: #6c5ce7;
    font-size: 14px;
    font-weight: bold;
  }}

  .flow-action-row {{
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-top: 14px;
    border-top: 1px solid #2a2a3c;
    padding-top: 12px;
  }}

  .app-button-secondary {{
    background: #6c5ce7;
    color: white;
    border: none;
    border-radius: 8px;
    font-weight: 700;
    font-size: 11px;
    padding: 8px 14px;
  }}

  .pulse-status-text {{
    font-size: 10px;
    color: #00b894;
    font-weight: 600;
  }}

  /* RFID SIMULATOR MOCKUP */
  .rfid-simulator-card {{
    border-color: #00cec9;
  }}
  .rfid-mockup-body {{
    padding: 6px 0;
  }}
  .rfid-device-row {{
    display: flex;
    justify-content: space-around;
    align-items: center;
    background: #090a10;
    border: 1px solid #2a2a3c;
    border-radius: 10px;
    padding: 12px;
    margin-bottom: 12px;
  }}
  .rfid-device-col {{
    text-align: center;
  }}
  .rfid-device-col .device-icon {{
    font-size: 26px;
    margin-bottom: 4px;
  }}
  .rfid-device-col .device-label {{
    font-weight: 700;
    font-size: 11px;
    color: #ffffff;
  }}
  .rfid-device-col .device-sub {{
    font-size: 9px;
    color: #a4b0be;
    margin-top: 2px;
  }}
  .rfid-device-col .device-sub.unpowered {{
    color: #ffa502;
  }}
  .rfid-wave-indicator {{
    text-align: center;
  }}
  .rfid-wave-indicator .wave-icon {{
    font-size: 20px;
    color: #00cec9;
  }}
  .rfid-wave-indicator .wave-text {{
    font-size: 9px;
    color: #81ecec;
    margin-top: 2px;
  }}
  .rfid-scale-box {{
    background: #12121c;
    border: 1px solid #2a2a3c;
    border-radius: 10px;
    padding: 12px;
    margin-bottom: 12px;
  }}
  .scale-info-row {{
    display: flex;
    justify-content: space-between;
    align-items: center;
    font-size: 11px;
    font-weight: 700;
    margin-bottom: 10px;
    color: #ffffff;
  }}
  .threshold-pill {{
    background: rgba(255, 214, 0, 0.15);
    color: #ffd600;
    padding: 2px 8px;
    border-radius: 4px;
    font-size: 10px;
  }}
  .scale-track-wrap {{
    position: relative;
    height: 36px;
    margin: 6px 0 10px 0;
  }}
  .scale-track-bar {{
    position: absolute;
    top: 17px;
    left: 0;
    right: 0;
    height: 4px;
    background: #2a2a3c;
    border-radius: 2px;
  }}
  .scale-threshold-line {{
    position: absolute;
    top: 2px;
    bottom: 2px;
    width: 2px;
    background: #ffd600;
  }}
  .threshold-text {{
    position: absolute;
    top: -16px;
    left: -35px;
    font-size: 8px;
    color: #ffd600;
    white-space: nowrap;
    font-weight: 700;
  }}
  .scale-tag-pin {{
    position: absolute;
    top: 6px;
    transform: translateX(-50%);
  }}
  .tag-pin-label {{
    background: #6c5ce7;
    color: #ffffff;
    font-size: 9px;
    font-weight: 700;
    padding: 3px 6px;
    border-radius: 6px;
    white-space: nowrap;
    box-shadow: 0 2px 8px rgba(0,0,0,0.4);
  }}
  .scale-tick-labels {{
    display: flex;
    justify-content: space-between;
    font-size: 9px;
    color: #a4b0be;
  }}
  .scale-tick-labels .threshold-tick {{
    color: #ffd600;
    font-weight: 700;
  }}
  .scale-tick-labels .default-tick {{
    color: #6c5ce7;
    font-weight: 700;
  }}
  .rfid-action-box {{
    display: flex;
    justify-content: space-between;
    align-items: center;
    background: #090a10;
    border: 1px solid #2a2a3c;
    border-radius: 10px;
    padding: 10px 12px;
    margin-bottom: 12px;
    flex-wrap: wrap;
    gap: 8px;
  }}
  .power-status-pill {{
    display: flex;
    align-items: center;
    gap: 6px;
    font-size: 10.5px;
    font-weight: 700;
  }}
  .power-status-pill.out-of-range {{
    color: #ffa502;
  }}
  .action-btn-row {{
    display: flex;
    gap: 8px;
  }}
  .mockup-btn {{
    font-size: 10.5px;
    font-weight: 700;
    padding: 6px 12px;
    border-radius: 6px;
    border: none;
  }}
  .mockup-btn.btn-disabled {{
    background: #2a2a3c;
    color: #636e72;
    cursor: not-allowed;
  }}
  .mockup-btn.btn-reset {{
    background: transparent;
    border: 1px solid #6c5ce7;
    color: #a29bfe;
  }}
  .rfid-sequence-box {{
    background: #12121c;
    border: 1px solid #2a2a3c;
    border-radius: 10px;
    padding: 12px;
    margin-bottom: 12px;
  }}
  .sequence-title {{
    font-size: 10px;
    font-weight: 800;
    color: #00cec9;
    letter-spacing: 0.5px;
    margin-bottom: 8px;
  }}
  .sequence-stages-grid {{
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 4px;
    margin-bottom: 10px;
  }}
  .stage-cell {{
    background: #181926;
    border: 1px solid #2a2a3c;
    border-radius: 8px;
    padding: 8px;
    width: 30%;
    text-align: center;
  }}
  .stage-step {{
    font-size: 8px;
    font-weight: 800;
    color: #6c5ce7;
    text-transform: uppercase;
  }}
  .stage-name {{
    font-size: 10px;
    font-weight: 700;
    color: #ffffff;
    margin: 2px 0;
  }}
  .stage-desc {{
    font-size: 8px;
    color: #a4b0be;
    line-height: 1.3;
  }}
  .stage-arrow {{
    color: #6c5ce7;
    font-size: 12px;
    font-weight: bold;
  }}
  .serial-output-mockup {{
    background: #000000;
    border: 1px solid #2a2a3c;
    border-radius: 6px;
    padding: 8px 10px;
  }}
  .serial-title {{
    font-size: 9px;
    color: #a4b0be;
    margin-bottom: 2px;
  }}
  .serial-text {{
    font-family: 'JetBrains Mono', monospace;
    font-size: 11px;
    color: #00e676;
    font-weight: 600;
  }}
  .spi-roles-box {{
    background: #090a10;
    border: 1px solid #2a2a3c;
    border-radius: 8px;
    padding: 8px 12px;
    margin-bottom: 10px;
  }}
  .spi-row {{
    font-size: 10px;
    padding: 2px 0;
    display: flex;
    gap: 8px;
  }}
  .spi-pin {{
    color: #00cec9;
    font-weight: 700;
    width: 44px;
    font-family: 'JetBrains Mono', monospace;
  }}
  .spi-desc {{
    color: #cbd5e1;
  }}
  .rfid-summary-footer {{
    background: rgba(108, 92, 231, 0.08);
    border: 1px solid rgba(108, 92, 231, 0.25);
    border-radius: 8px;
    padding: 8px 12px;
    font-size: 10px;
    color: #dcdde1;
    line-height: 1.4;
  }}

  /* QUIZ CONTAINER */
  .app-quiz-container {{
    background: #1e1e2e;
    border: 1px solid #2a2a3c;
    border-radius: 16px;
    padding: 16px;
    margin-bottom: 16px;
  }}

  .quiz-container-header {{
    display: flex;
    align-items: center;
    gap: 12px;
    margin-bottom: 16px;
    border-bottom: 1px solid #2a2a3c;
    padding-bottom: 10px;
  }}

  .quiz-icon-large {{
    font-size: 24px;
  }}

  .quiz-main-title {{
    font-size: 15px;
    font-weight: 800;
    color: #ffa502;
  }}

  .quiz-sub {{
    font-size: 11px;
    color: #a4b0be;
  }}

  .app-quiz-question-card {{
    background: #12121c;
    border: 1px solid #2a2a3c;
    border-radius: 12px;
    padding: 12px;
    margin-bottom: 12px;
  }}

  .question-header {{
    font-size: 10px;
    font-weight: 700;
    color: #a29bfe;
    text-transform: uppercase;
    margin-bottom: 4px;
  }}

  .question-title {{
    font-size: 13px;
    font-weight: 700;
    color: #ffffff;
    margin-bottom: 10px;
  }}

  .quiz-option-row {{
    display: flex;
    align-items: center;
    gap: 8px;
    background: #1e1e2e;
    border: 1px solid #2a2a3c;
    border-radius: 8px;
    padding: 8px 10px;
    margin-bottom: 6px;
    font-size: 12px;
  }}

  .quiz-option-row.selected-correct {{
    border-color: #00b894;
    background: rgba(0, 184, 148, 0.12);
  }}

  .quiz-radio {{
    font-size: 12px;
    color: #00b894;
  }}

  .quiz-opt-text {{
    flex-grow: 1;
    color: #f8fafc;
  }}

  .correct-badge {{
    background: #00b894;
    color: #12121c;
    font-size: 9px;
    font-weight: 800;
    padding: 2px 6px;
    border-radius: 4px;
  }}

  .explanation-box {{
    margin-top: 8px;
    background: rgba(0, 206, 201, 0.08);
    border: 1px solid rgba(0, 206, 201, 0.2);
    border-radius: 6px;
    padding: 8px;
    font-size: 11px;
    color: #81ecec;
    display: flex;
    gap: 6px;
  }}

  /* QUICK CHECK MODAL PREVIEW */
  .quick-check-modal-render {{
    background: #1e1e2e;
    border: 1.5px dashed #6c5ce7;
    border-radius: 16px;
    padding: 14px;
    margin-top: 14px;
  }}

  .modal-header {{
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 12px;
    border-bottom: 1px solid #2a2a3c;
    padding-bottom: 6px;
  }}

  .modal-badge {{
    font-size: 9px;
    font-weight: 800;
    color: #a29bfe;
  }}

  .modal-title {{
    font-size: 12px;
    font-weight: 700;
    color: #ffffff;
  }}

  .qc-sub-card {{
    background: #12121c;
    border-radius: 8px;
    padding: 10px;
    margin-bottom: 10px;
  }}

  .qc-q-title {{
    font-size: 12px;
    color: #ffffff;
    margin-bottom: 6px;
  }}

  .qc-opt {{
    font-size: 11px;
    padding: 4px 6px;
    color: #a4b0be;
  }}

  .qc-opt-correct {{
    color: #00b894;
    font-weight: 600;
  }}

  .qc-feedback {{
    font-size: 10px;
    color: #81ecec;
    margin-top: 4px;
  }}

  .qc-warmup-box {{
    font-size: 10px;
    color: #fdcb6e;
    margin-top: 2px;
    font-style: italic;
  }}

  /* ACTION BAR */
  .app-action-bar {{
    display: flex;
    justify-content: space-between;
    margin-top: 16px;
    border-top: 1px solid #2a2a3c;
    padding-top: 14px;
  }}

  .app-btn-prev {{
    background: #2a2a3c;
    color: #a4b0be;
    border: none;
    border-radius: 10px;
    padding: 10px 16px;
    font-weight: 700;
    font-size: 12px;
  }}

  .app-btn-next {{
    background: #6c5ce7;
    color: #ffffff;
    border: none;
    border-radius: 10px;
    padding: 10px 20px;
    font-weight: 800;
    font-size: 12px;
  }}
</style>
</head>
<body>

<div class="page-intro-header">
    <div class="brand-badge">MONSTER LAB • IN-APP VIEW SIMULATOR</div>
    <div class="intro-title">{safe_title}</div>
    <div class="intro-sub">Lesson ID: <code>{safe_lesson_id}</code> • Course ID: <code>{safe_course_id}</code> • Total Steps: {len(steps)}</div>
</div>

{screens_html}

</body>
</html>
"""

    os.makedirs(os.path.dirname(os.path.abspath(output_html_path)), exist_ok=True)
    os.makedirs(os.path.dirname(os.path.abspath(output_pdf_path)), exist_ok=True)

    with open(output_html_path, "w", encoding="utf-8") as f:
        f.write(html_content)

    temp_dir = tempfile.mkdtemp(prefix=f"chrome_pdf_{lesson_id}_")
    try:
        abs_html = os.path.abspath(output_html_path)
        abs_pdf = os.path.abspath(output_pdf_path)
        cmd = [
            "google-chrome-stable",
            "--headless=new",
            "--disable-gpu",
            "--no-sandbox",
            "--disable-background-networking",
            "--disable-sync",
            "--disable-default-apps",
            "--disable-extensions",
            f"--user-data-dir={temp_dir}",
            f"--print-to-pdf={abs_pdf}",
            abs_html
        ]
        subprocess.run(cmd, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        print(f"Rendered in-app PDF to: {output_pdf_path}")
    finally:
        shutil.rmtree(temp_dir, ignore_errors=True)

def process_single_lesson(lesson_id, output_dir="reports/lessons_pdf", skip_existing=False):
    html_out = os.path.join(output_dir, f"{lesson_id}_in_app.html")
    pdf_out = os.path.join(output_dir, f"{lesson_id}_in_app.pdf")
    if skip_existing and os.path.exists(pdf_out) and os.path.getsize(pdf_out) > 0:
        print(f"[SKIP] {lesson_id} already exists ({pdf_out})")
        return True, lesson_id, "skipped"
    try:
        render_full_app_lesson(lesson_id, html_out, pdf_out)
        return True, lesson_id, "rendered"
    except Exception as e:
        print(f"[FAIL] {lesson_id}: {e}", file=sys.stderr)
        return False, lesson_id, str(e)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Render dual-viewport in-app HTML and PDF for curriculum lessons")
    parser.add_argument("lessons", nargs="*", default=[], help="Lesson IDs to render (e.g. l01_01, or 'all' to render all lessons)")
    parser.add_argument("--all", action="store_true", help="Render all curriculum lessons")
    parser.add_argument("--output-dir", default="reports/lessons_pdf", help="Output directory (default: reports/lessons_pdf)")
    parser.add_argument("--workers", type=int, default=6, help="Number of concurrent workers for batch rendering (default: 6)")
    parser.add_argument("--skip-existing", action="store_true", help="Skip rendering if output PDF already exists and is non-empty")
    args = parser.parse_args()

    os.makedirs(args.output_dir, exist_ok=True)

    all_lesson_files = sorted(glob.glob("assets/curriculum/lessons/*.json"))
    all_lesson_ids = [os.path.splitext(os.path.basename(f))[0] for f in all_lesson_files]

    target_ids = []
    if args.all or (len(args.lessons) == 1 and args.lessons[0].lower() == "all"):
        target_ids = all_lesson_ids
    elif args.lessons:
        target_ids = args.lessons
    else:
        # Default fallback to l01_01
        target_ids = ["l01_01"]

    print(f"Target lessons to process: {len(target_ids)} (workers: {args.workers})")

    if len(target_ids) == 1:
        lid = target_ids[0]
        success, lid, status = process_single_lesson(lid, args.output_dir, args.skip_existing)
        if not success:
            sys.exit(1)
    else:
        completed = 0
        failed = []
        skipped = 0
        with ThreadPoolExecutor(max_workers=args.workers) as executor:
            future_to_id = {
                executor.submit(process_single_lesson, lid, args.output_dir, args.skip_existing): lid
                for lid in target_ids
            }
            for future in as_completed(future_to_id):
                lid = future_to_id[future]
                completed += 1
                try:
                    success, lid, status = future.result()
                    if not success:
                        failed.append(lid)
                    elif status == "skipped":
                        skipped += 1
                except Exception as e:
                    print(f"[FAIL] Unexpected worker error for {lid}: {e}", file=sys.stderr)
                    failed.append(lid)
                print(f"[{completed}/{len(target_ids)}] Finished {lid} (Failed so far: {len(failed)})")

        print("\n" + "="*50)
        print(f"Batch Render Completed: {completed}/{len(target_ids)} processed.")
        print(f"Successfully Rendered: {completed - len(failed) - skipped}")
        print(f"Skipped (already existed): {skipped}")
        print(f"Failed: {len(failed)}")
        if failed:
            print(f"Failed lessons: {failed}")
            sys.exit(1)

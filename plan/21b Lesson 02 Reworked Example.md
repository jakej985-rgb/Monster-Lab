# 21b Lesson 02 Reworked Example

## Purpose
Show how Lesson 02 should be expanded using the Phase 21 lesson standard while teaching the learner enough computer and coding knowledge to understand what they are doing.

## Lesson
**Title:** Setting Up Your Monster Lab Station
**Tier:** Rookie
**Target Time:** 15–20 minutes
**Prerequisites:** Lesson 01
**XP:** 50

## Learning Goals
- Explain what the Arduino IDE is.
- Explain the difference between source code, compiling, and uploading.
- Connect an Arduino Uno to a computer safely.
- Identify the USB connection and board.
- Select the correct Arduino board in the IDE.
- Select the correct communication port.
- Explain what a serial port is at a beginner level.
- Understand that the computer sends a compiled program to the Arduino.
- Recognize common setup problems.
- Read a tiny Arduino program and identify its basic parts.

## 1. Mission Introduction
### Give the Monster Its Voice
The Arduino is the robot's brain, but the brain needs instructions.

Your computer is where you write those instructions.

The Arduino IDE is the workbench that lets you write Arduino programs, check code, compile programs, upload them to the board, and communicate with the board.

Think of the process as:
**Write → Check → Compile → Upload → Run**

## 2. Prior Knowledge Check
Ask the learner:

### Question 1
Have you ever written a computer program before?
- Yes.
- A little.
- No.

### Question 2
What do you think a program is?
- Instructions for a computer.
- A battery.
- A USB cable.

### Question 3
What do you think USB is used for in this project?
- Connecting the computer and Arduino.
- Supplying unlimited power to every component.
- Making the Arduino wireless.

Do not block beginners based on their answers. If they already know these concepts, allow them to move quickly through the explanation.

## 3. What Is an IDE?
IDE stands for Integrated Development Environment.

Think of it as a programming workbench. Instead of using one program to write code, another to compile it, and another to send it to the board, the Arduino IDE puts the important tools together.

### Vocabulary
- **IDE:** Software used to write and work with programs.
- **Sketch:** Arduino's name for a program/project.
- **Compile:** Convert source code into a form the Arduino can use.
- **Upload:** Send the compiled program from the computer to the Arduino.
- **Port:** A communication connection the computer uses to communicate with a device.

## 4. What Actually Happens When You Upload?
When you press Upload, several things happen.

### Step 1 — Write code
You create a sketch.

### Step 2 — Check the code
The IDE looks for problems that prevent the program from being compiled.

### Step 3 — Compile
The computer translates the source code into machine instructions appropriate for the board.

### Step 4 — Communicate
The computer sends the program through the USB connection.

### Step 5 — Run
The Arduino stores and executes the program.

### Think About It
Does pressing Upload magically create the program?

**No.** The computer has already converted the source code and then sends the resulting program to the board.

## 5. Meet the USB Cable
The USB cable provides an important connection between the computer and Arduino.

Depending on the board and setup, USB can provide power, data communication, program uploads, and serial communication.

### Physical Mission
1. Find the USB connector on the Arduino.
2. Find the USB connector on the computer.
3. Inspect the cable for damage.
4. Connect the cable.
5. Look for the Arduino power indicator.
6. Confirm the board is receiving power.

### Safety
- Do not force the connector.
- Do not connect damaged cables.
- Do not intentionally short power and ground.

## 6. What Is a Port?
Your computer may have many devices connected to it. The operating system needs a way to identify which communication connection belongs to the Arduino.

That connection appears as a serial or COM port. The exact name depends on the computer and operating system.

Think:
**Computer → Port → USB → Arduino**

### Prediction
If the Arduino is unplugged, should the Arduino's port normally remain available as the same active device?

**Usually no.** The available port list can change when devices are connected or disconnected.

## 7. Selecting the Board
The IDE needs to know which Arduino board you are programming.

For this project, select:
**Arduino Uno**

Different boards can have different processors, pin layouts, memory, communication hardware, and programming requirements.

Choosing the wrong board can cause uploads to fail or produce unexpected behavior.

### Guided Task
Have the learner open:
**Tools → Board → Arduino Uno**

Then verify the selected board.

## 8. Selecting the Port
Now select the communication port belonging to the Arduino.

Have the learner:
1. Open the port selection.
2. Note which ports are currently visible.
3. Disconnect the Arduino.
4. Check the list again.
5. Reconnect the Arduino.
6. Identify the port that appears or returns.
7. Select it.

This turns port selection into something the learner can understand instead of simply being told which item to click.

## 9. Your First Code Reading
Before uploading a full project, look at this tiny sketch:

    void setup() {
      Serial.begin(9600);
    }

    void loop() {
    }

### What Does This Mean?
- **void setup():** A function that runs when the Arduino starts or resets.
- **Serial.begin(9600):** Starts serial communication at a speed called the baud rate.
- **void loop():** The function Arduino repeatedly runs.
- The empty loop means this example does not currently have anything repeating.

### Coding Basics
This introduces functions, parentheses, braces, statements, numbers, and semicolons.

The learner does not need to memorize these yet. The goal is recognizing that code has structure.

## 10. Code Prediction
### Prediction 1
If setup() runs when the Arduino starts, will this happen repeatedly every second?

**No.**

### Prediction 2
What does 9600 represent?
- The serial communication speed.
- The Arduino pin number.
- The amount of memory.

**Answer:** Serial communication speed/baud rate.

### Prediction 3
What happens inside the empty loop?
Nothing from this example is being repeatedly executed.

## 11. First Upload
Walk through the basic workflow:
1. Connect Arduino.
2. Open Arduino IDE.
3. Select Arduino Uno.
4. Select the correct port.
5. Open or enter a simple sketch.
6. Verify the code.
7. Upload the sketch.
8. Watch the IDE for the upload result.

Explain the difference:
**Verify → checks/compiles the sketch.**
**Upload → sends the program to the Arduino.**

The learner should understand that these are not the same button.

## 12. Troubleshooting Challenge
### Scenario A — No Port
The Arduino is plugged in, but no new port appears.

Ask the learner to check:
- Is the USB cable connected?
- Is the cable capable of data communication?
- Is the board powered?
- Is the cable damaged?
- Is the correct USB port being used?
- Does the operating system recognize the device?

### Scenario B — Upload Fails
Ask:
- Is the correct board selected?
- Is the correct port selected?
- Is another program using the serial port?
- Is the USB connection stable?
- Did the code compile successfully?

### Scenario C — Wrong Board
The learner selected a different board model.

Ask why this might cause problems.

Expected reasoning: The IDE needs to know what hardware it is programming so it can compile and upload the program correctly.

## 13. Real-World Example
Professional developers use similar workflows. They write software, build or compile it, send it to a target system, test it, observe the result, and fix problems.

Embedded engineers do this with robots, drones, industrial controllers, sensors, automotive electronics, and smart appliances.

Monster Lab is introducing the same basic engineering workflow.

## 14. Knowledge Check
### Question 1
What does IDE stand for?
- Integrated Development Environment.
- Internal Digital Engine.
- Input Device Electronics.

**Correct:** A

### Question 2
What is an Arduino sketch?
- An Arduino program/project.
- A battery.
- A USB port.

**Correct:** A

### Question 3
What does compiling do?
- Converts source code into a form suitable for the target system.
- Supplies electricity to the Arduino.
- Connects the USB cable.

**Correct:** A

### Question 4
What does Upload do?
- Sends the program to the Arduino.
- Deletes the Arduino.
- Changes the USB cable.

**Correct:** A

### Question 5
Why must you select the correct board?
- Different boards can use different hardware and programming requirements.
- The board name changes the USB cable.
- The Arduino cannot store programs.

**Correct:** A

### Question 6
What does the port identify?
- The computer's communication connection to the Arduino.
- The Arduino's battery level.
- The program's XP reward.

**Correct:** A

### Question 7
What does setup() do?
- Runs once when the Arduino starts or resets.
- Runs continuously forever.
- Deletes the sketch.

**Correct:** A

### Question 8
What does loop() normally do?
- Repeatedly runs the code placed inside it.
- Selects the USB port.
- Compiles the computer's operating system.

**Correct:** A

## 15. Final Review
### You Learned
- The Arduino IDE is the programming workbench.
- Arduino sketches are programs.
- Verify/compile and Upload are different operations.
- USB can provide power and data communication.
- A port identifies a computer communication connection.
- The IDE must know which board you are programming.
- setup() runs during startup or reset.
- loop() repeats.
- Uploading code is part of an engineering test cycle.

### Monster Lab Workflow
**Connect → Select Board → Select Port → Write → Verify → Upload → Test → Troubleshoot**

## Estimated Time Breakdown
| Activity | Target |
|---|---:|
| Mission introduction | 1 min |
| Prior knowledge check | 1–2 min |
| IDE explanation | 2 min |
| Upload process explanation | 2 min |
| USB physical task | 2 min |
| Port investigation | 2–3 min |
| Board selection | 1 min |
| Code walkthrough | 2 min |
| Code prediction | 1–2 min |
| First upload | 2 min |
| Troubleshooting challenge | 2 min |
| Knowledge check | 2–3 min |
| Final review | 1 min |
| **Total** | **18–21 min** |

## Implementation Notes
- Break the lesson into structured step objects.
- Support prior-knowledge questions.
- Support vocabulary.
- Support reading content.
- Support physical tasks.
- Support code explanation.
- Support code prediction.
- Support troubleshooting challenges.
- Support multi-question assessments.
- Keep the lesson beginner-friendly.
- Allow experienced learners to move quickly through familiar sections.
- Preserve lesson progress and completion behavior.

## Done When
- A beginner can set up an Arduino workstation with guidance.
- The learner understands what the IDE does.
- The learner understands board and port selection.
- The learner understands the difference between Verify and Upload.
- The learner can explain the basic upload workflow.
- The learner can read the simple setup/loop example.
- The learner practices troubleshooting instead of randomly changing settings.
- The assessment checks multiple concepts.
- The lesson provides approximately 15–20 minutes of meaningful learning.

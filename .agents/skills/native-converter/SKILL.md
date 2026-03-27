---
name: native-converter
description: Refines English text to sound more native and saves the result to the Obsidian English Improvement notes.
---

# Native English Converter

## Trigger
Execute this skill whenever the user's request starts with the prefix "more native " followed by English text.

## Execution Steps

1. **Refine the Text:** Analyze the English text provided by the user immediately after "more native ". Rewrite it to sound native, idiomatic, and highly natural. Correct any grammatical mistakes and use vocabulary/phrasing typical of a native English speaker.
2. **Reply to the User:** In your chat response, directly provide the revised, native version of the text. You may briefly explain why the native phrasing is better or casually note any idioms used.
3. **Log to Obsidian Resource File:** You MUST proactively append the original and the revised text to the resource file located at `30-Resources/English/English Improvement.md` (relative to the workspace root).
    - If the file does not exist, create it.
    - If the file exists, append your entry at the bottom.
    - **Crucial Formatting Requirements for the Log:**
      - The entry must be separated from previous ones by a markdown horizontal rule: `---`
      - The user's original input must be formatted as a Heading 4: `#### {Original Text}`
      - The native revision must be placed right below the heading as regular text.

### Example File Append
```markdown
---
#### I very like this thing you make.
I absolutely love what you've created.
```

## Important Directives
- **Direct Action:** Do NOT ask the user for permission to write to the file. Just do it and let them know it has been added to their English Improvement notes.
- **Tone:** Keep the translation natural. Choose conversational or professional tone depending on the context of the user's original text.
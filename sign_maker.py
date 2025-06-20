#: sign_gui_preview.py
# Requirements:
# (built-in only: tkinter)

"""
GUI tool to create and preview landscape HTML signs (8.5 x 11 inches).
- Enter up to 3 lines of text with adjustable font sizes
- Live Canvas preview in the window
- Generate a printable HTML file
"""

from dataclasses import dataclass
from pathlib import Path
from tkinter import (
    Tk, Label, Entry, Spinbox, Button,
    StringVar, IntVar, Canvas, messagebox,
)

@dataclass
class Line:
    text: str
    font_size: int

@dataclass
class Sign:
    line1: Line | None
    line2: Line | None
    line3: Line | None

    def generate_html(self) -> str:
        lines = [self.line1, self.line2, self.line3]
        html_lines = "\n".join(
            f'<div class="line" style="font-size: {line.font_size}px">{line.text}</div>'
            for line in lines if line and line.text.strip()
        )
        return f"""<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Printable Sign</title>
  <style>
    @page {{
      size: 11in 8.5in;
      margin: 0.5in;
    }}
    html, body {{
      width: 11in; height: 8.5in;
      margin: 0; padding: 0;
      font-family: Arial, sans-serif;
    }}
    body {{ display: flex; flex-direction: column;
      justify-content: center; align-items: center; text-align: center; }}
    .line {{ margin: 0.3em 0; }}
  </style>
</head>
<body>
{html_lines}
</body>
</html>
"""

    def save(self, output_file: Path) -> None:
        output_file.write_text(self.generate_html(), encoding="utf-8")


class SignGUI:
    def __init__(self) -> None:
        self.root = Tk()
        self.root.title("HTML Sign Maker with Live Preview")
        self.entries: list[tuple[StringVar, IntVar]] = []

        for i in range(3):
            text_var = StringVar()
            size_var = IntVar(value=36)
            Label(self.root, text=f"Line {i+1} Text:").grid(row=i*2, column=0, sticky="e")
            Entry(self.root, textvariable=text_var, width=40).grid(row=i*2, column=1)
            Label(self.root, text="Font Size:").grid(row=i*2+1, column=0, sticky="e")
            Spinbox(self.root, from_=12, to=200, textvariable=size_var, width=5).grid(row=i*2+1, column=1, sticky="w")
            text_var.trace_add("write", self.update_preview)
            size_var.trace_add("write", self.update_preview)
            self.entries.append((text_var, size_var))

        Button(self.root, text="Generate HTML Sign", command=self.make_sign).grid(row=6, column=0, columnspan=2, pady=10)

        self.canvas = Canvas(self.root, width=800, height=600, bg="white")
        self.canvas.grid(row=0, column=2, rowspan=7, padx=10, pady=10)
        self.update_preview()

    def make_sign(self) -> None:
        sign = self._gather_sign()
        output = Path("sign.html")
        sign.save(output)
        messagebox.showinfo("Success", f"Sign saved to {output.resolve()}")

    def _gather_sign(self) -> Sign:
        lines = []
        for text_var, size_var in self.entries:
            txt = text_var.get().strip()
            lines.append(Line(txt, size_var.get()) if txt else None)
        return Sign(*lines)

    def update_preview(self, *args) -> None:
        sign = self._gather_sign()
        self.canvas.delete("all")

        width, height = 800, 600
        self.canvas.create_rectangle(0, 0, width, height, fill="white")

        lines = [ln for ln in [sign.line1, sign.line2, sign.line3] if ln is not None]
        if not lines:
            return

        total_text_height = sum(ln.font_size for ln in lines)
        spacing = (height - total_text_height) / (len(lines) + 1)

        y = spacing
        for ln in lines:
            self.canvas.create_text(
                width / 2, y + ln.font_size / 2,
                text=ln.text,
                font=("Arial", ln.font_size)
            )
            y += ln.font_size + spacing

    def run(self) -> None:
        self.root.mainloop()


if __name__ == "__main__":
    SignGUI().run()

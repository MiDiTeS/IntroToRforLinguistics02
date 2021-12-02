from webvtt import WebVTT
def caption_to_vector(file):
  x = WebVTT().read(file)
  txt = [caption.text for caption in x]
  return(txt)

lines = []
for line in vtt:
    # Strip the newlines from the end of the text.
    # Split the string if it has a newline in the middle
    # Add the lines to an array
    lines.extend(line.text.strip().splitlines())

# Remove repeated lines
previous = None
for line in lines:
    if line == previous:
       continue
    transcript += " " + line
    previous = line
print (transcript)
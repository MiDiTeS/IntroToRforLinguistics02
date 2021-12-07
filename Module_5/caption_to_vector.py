from webvtt import WebVTT
def caption_to_vector(file):
  x = WebVTT().read(file)
  txt = [caption.text for caption in x]
  return(txt)

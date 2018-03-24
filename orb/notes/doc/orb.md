# Orb format
  The grimoire tools work with a structured text format which we call Orb.
This is an introduction to that format.


## Metalanguage
  I call Orb a metalanguage, because it can by design include any other structured
text format within it.  Provided it may be represented in utf-8!  This is
no stricture in practice. 

The Orb format aims to be equally useful for markup, literate programming,
configuration, data exchange, and the sort of interactive notebook which 
Jupyter and org-babel can produce.

The first parser and tool is Grimoire, which, as a bootstrap, is focused on
literate programming.  This will in turn be the format for the tools in the
bettertools suite. 


## Goals
  Orb is:

  - Error free:  An Orb document is never in a state of error.  Any valid
                 utf-8 string is an Orb document.
  - Line based:  Orb files may be rapidly separated into their elements
                 by splitting into lines and examining the first few
                 characters.
  - Humane:      Orb is carefully designed to be readable, as is, by
                 ordinary humans.
  - General:     There are no characters such as <>& in HTML which must be
                 escaped.  Orb codeblocks can enclose any other format,
                 including Orb format.  Orb strings are «brace balanced»
                 and can enclose any utf-8 string as a consequence. 

While it is quite possible to do fancy things with Orb, it is also a
comfortable format to write a blog post, or put a few key-value pairs into
a config file.  If you were to send an email in Orb format, the recipient
might not even notice. 
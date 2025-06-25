# Audiobook Generator

This project converts any file type into an EPUB, then generates an audiobook (MP4) from it.

## 1. Installation

Clone the repository and set up your environment:

```bash
python3.12 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

## 2. Adding Your File

- Place your raw file (unconverted) in `content/raw/<file-type>/`.
- Run the following command to create your audiobook:

  ```bash
  bash create_audiobook.sh -f <path_to_file_with_file_name_and_extension_from_working_dir>
  ```
  For example, if I had a file named star_wars.txt, I would place the file:

  ```
  touch content/raw/star_wars.txt
  ```
  Then, I would run:

  ```
  bash create_audiobook.sh -f content/raw/star_wars.txt
  ```

- After processing, a folder will be created in `content/complete/` named after your file.
- To play the generated MP4 audiobook, use a tool like `mpv`:

  ```bash
  mpv content/complete/star_wars/star_wars.mp4
  ```

Replace `star_wars` with your actual file name.

## 4. Considerations
- folder structures inside of `content/raw` are mimicked inside of `content/complete`. See `content/raw/pheonix_documentation` for an example
- The only file types that have been tested are `.txt` and `.md`. See `content/raw/pheonix_documentation` for examples. 
- Things like validating file names (e.g checking for uniqness inside of `content/raw/epub`) has not been implimented. Be thoughtful about naming your files.

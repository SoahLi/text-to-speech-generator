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

- After processing, a folder will be created in `content/complete/` named after your file.
- To play the generated MP4 audiobook, use a tool like `mpv`:

  ```bash
  mpv content/complete/star_wars/star_wars.mp4
  ```

Replace `star_wars` with your actual file name.

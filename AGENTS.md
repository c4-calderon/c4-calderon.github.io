# AGENTS.md

This file provides guidance for AI coding agents working in this repository.

## Project Overview

**c4-calderon.github.io** is a personal academic portfolio website built with Jekyll (Academic Pages template) and hosted on GitHub Pages. It showcases blog posts, publications, talks, portfolio projects, and CV.

- **Author:** Carlos A. Calderón (Senior Data Analyst & Process Engineer)
- **Site URL:** https://c4-calderon.github.io
- **Stack:** Jekyll (Ruby), Liquid templates, Sass/SCSS, Markdown, Python

## Directory Structure

```
/                           # Root directory
├── _config.yml             # Jekyll configuration (title, author, collections, plugins)
├── Gemfile                 # Ruby dependencies (github-pages gem)
├── _pages/                 # Static pages (about.md, cv.md, cv-v2.md, etc.)
├── _posts/                 # Blog posts (Markdown format, date-prefixed filenames)
├── _notebooks/             # Jupyter notebooks (source of truth for analyses)
├── _publications/          # Academic publications
├── _talks/                 # Conference talks and presentations
├── _portfolio/             # Portfolio projects
├── _teaching/              # Teaching materials
├── _includes/              # Jekyll template includes
├── _layouts/               # Jekyll page layouts
├── _sass/                  # SCSS stylesheets
├── _data/                  # YAML/JSON data files (navigation.yml, cv.json)
├── assets/                 # CSS, JS, fonts, images
├── images/                 # Site images and post assets
├── talkmap/                # Leaflet map for talks location
├── markdown_generator/     # Python scripts for generating Markdown
├── scripts/                # Utility scripts (cv_markdown_to_json.py)
├── data/                   # Datasets (raw/ and processed/)
│   ├── raw/                # Original unmodified data
│   └── processed/          # Cleaned data ready for analysis
└── .github/                # GitHub workflows and issue templates
```

## Build Commands

### Local Development

```bash
# Install dependencies
bundle install

# Run local server (with livereload)
bundle exec jekyll serve -l -H localhost

# Build for production (outputs to _site/)
bundle exec jekyll build

# Clean and rebuild
bundle exec jekyll clean && bundle exec jekyll build
```

The site is available at `http://localhost:4000` when running locally.

### Docker

```bash
docker compose up
```

### Python Scripts

```bash
# Convert CV markdown to JSON
python scripts/cv_markdown_to_json.py -i _pages/cv.md -o _data/cv.json -c _config.yml

# Generate talk map (run from _talks/ directory)
cd _talks && python ../talkmap.py
```

## Code Style Guidelines

### Front Matter (YAML)

All Markdown files must include valid YAML front matter:

```yaml
---
title: "Page Title"
date: YYYY-MM-DD
permalink: /path/to/page/
tags:
  - Tag1
  - Tag2
---
```

**Front Matter Patterns by Collection:**

**Posts** (`_posts/YYYY-MM-DD-title.md`):
```yaml
---
title: 'Post Title'
date: YYYY-MM-DD
permalink: /posts/YYYY/path-title/
tags:
  - Tag1
  - Tag2
---
```

**Talks** (`_talks/`):
```yaml
---
title: "Talk Title"
collection: talks
type: "Talk"
permalink: /talks/YYYY-MM-DD-title/
venue: "Venue Name"
date: YYYY-MM-DD
location: "City, Country"
---
```

**Publications** (`_publications/`):
```yaml
---
title: "Paper Title"
collection: publications
category: manuscripts  # or: books, conferences
permalink: /publication/YYYY-MM-DD-title/
excerpt: 'Brief description.'
date: YYYY-MM-DD
venue: 'Journal/Conference Name'
paperurl: 'https://...'
citation: 'Full citation text'
---
```

**Portfolio** (`_portfolio/`):
```yaml
---
title: "Project Title"
excerpt: "Short description<br/><img src='/images/500x300.png'>"
collection: portfolio
---
```

### Python Code Style

- **Encoding:** Always use `# coding: utf-8` at the top of Python files
- **Imports:** Standard library first, then third-party, then local
- **Docstrings:** Use triple-quoted strings for module and function docstrings
- **Naming:** `snake_case` for functions/variables, `PascalCase` for classes
- **Error Handling:** Use specific exceptions (e.g., `GeocoderTimedOut`, not bare `except`)

Example:
```python
# coding: utf-8
"""
Module docstring describing the module's purpose.
"""

import os
import json
from datetime import datetime

def parse_markdown_cv(md_file):
    """Parse the markdown CV file and extract sections."""
    with open(md_file, 'r', encoding='utf-8') as file:
        content = file.read()
    return content
```

### JavaScript Code Style

- **ES6+:** Use `const`/`let`, arrow functions, template literals
- **Modules:** Use ES module imports/exports
- **JQuery:** The codebase uses jQuery for DOM manipulation

Example:
```javascript
const use_theme = theme || localStorage.getItem("theme") || browserPref;
$('#theme-toggle').on('click', toggleTheme);
```

### Markdown Content Style

- Use single quotes for YAML string values
- Use GFM (GitHub Flavored Markdown) for code blocks
- Include front matter in all content files
- Use Plotly JSON for interactive charts (language: `plotly`)

Example chart block:
````markdown
```plotly
{"data": [...], "layout": {...}}
```
````

### YAML Files

- Use 2-space indentation
- Quote strings that contain special characters
- Use lowercase for keys (e.g., `author_profile: true`)

### Git Workflow

1. **Commits:** Write clear, descriptive commit messages
2. **Branches:** Use feature branches for significant changes
3. **Sensitive Data:** Never commit:
   - `.env` files or credentials
   - Large datasets in `data/` (they are gitignored)
   - Proprietary company data (Renault-SOFASA)
   - Personal private information

## Key Configuration Files

| File | Purpose |
|------|---------|
| `_config.yml` | Global site settings (title, author, collections, plugins) |
| `_data/navigation.yml` | Header navigation links |
| `_data/ui-text.yml` | UI text strings |
| `_data/cv.json` | JSON-formatted CV data |
| `_data/authors.yml` | Author information |

## Common Tasks

### Creating a New Blog Post

1. Create file in `_posts/` with format `YYYY-MM-DD-title.md`
2. Add front matter with title, date, permalink, tags
3. Write content in Markdown (use exported Jupyter notebook content)
4. Place related images in `images/posts/[slug]/`

### Creating a New Publication

1. Create file in `_publications/` or use `markdown_generator/publications.py`
2. Add required front matter fields (title, date, venue, citation)
3. Use `html_escape()` for special characters in YAML values

### Modifying Navigation

Edit `_data/navigation.yml` to add/remove/ reorder header links.

### Updating Author Profile

Edit the `author:` section in `_config.yml` to update:
- Personal info (bio, location, email)
- Social links (GitHub, LinkedIn, etc.)
- Academic profiles (Google Scholar, ORCID, etc.)

## Asset Management

- **Images:** Place in `images/` directory; post images go in `images/posts/[slug]/`
- **CSS:** Modify files in `assets/css/` or `_sass/`
- **JavaScript:** Modify `assets/js/_main.js` or `assets/js/theme.js`
- **Fonts:** Place in `assets/fonts/` or `assets/webfonts/`

## Notes

- This is a static site generator; no runtime tests exist
- Large data files are gitignored (stored locally only)
- Jupyter notebooks in `_notebooks/` are the source of truth for analyses
- Export notebooks to Markdown for blog posts, preserving outputs

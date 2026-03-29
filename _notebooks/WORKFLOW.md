# Workflow: From Jupyter Notebook to Blog Post

Follow these steps to convert your data analysis into a Jekyll blog post.

## 1. Prepare your Notebook

- Ensure your notebook in `_notebooks/` is clean and all cells are executed.
- The first markdown cell should ideally contain the abstract/intro.

## 2. Export to Markdown

Run the following command in your terminal (replace `notebook_name` and `post-folder-name`):

```bash
jupyter nbconvert --to markdown _notebooks/notebook_name.ipynb --output-dir _posts/ --NbConvertApp.output_files_dir=../images/posts/post-folder-name/
```

## 3. Post-Processing (Required)

The exported `.md` file needs three manual adjustments:

### A. Add YAML Front Matter

Open the new `.md` in `_posts/` and add the header at the very top:

```yaml
---
title: 'Your Title Here'
date: YYYY-MM-DD
permalink: /posts/YYYY/MM/title/
tags:
  - Tag1
  - Tag2
---
```

### B. Fix Image Paths

The command in step 2 creates links like `![png](../images/posts/post-folder-name/image.png)`.
For Jekyll to render them correctly on the live site, replace the `..` with `{{site.url}}`:

- **In VS Code:** `Ctrl+H` (Replace)
- **Find:** `](../images/posts/`
- **Replace:** `]({{site.url}}/images/posts/`

### C. Wrap Tables for Responsiveness

Jupyter often exports DataFrames as HTML tables wrapped in a simple `<div>`. To ensure they match the page width and are scrollable on mobile, change the opening tag:

- **Find:** `<div>` (at the start of a table block)
- **Replace:** `<div class="table-container">`

## 4. Preview Locally

Run Jekyll locally to verify everything looks correct:

```bash
bundle exec jekyll serve
```

## 5. Commit and Push

Once satisfied, add the new `.md` and the new images to git:

```bash
git add _posts/YYYY-MM-DD-title.md
git add images/posts/post-folder-name/
git commit -m "Add new post: Your Title"
git push
```

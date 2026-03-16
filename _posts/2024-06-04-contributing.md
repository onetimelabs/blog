---
layout: post
title:  "Contributing to the onetimelabs blog"
author: Fabrizio Genovese and Stefano Gogioso
categories: []
excerpt: This post explains how to contribute to the onetimelabs blog.
usemathjax: true
thanks: "The space at the beginning of each post is optionally used for acknowledgements."
---

![onetimelabs logo](../assetsPosts/2024-06-04-contributing/Logo.svg)


The onetimelabs blog is based on the [Reverie](https://jekyllthemes.io/theme/reverie) Jekyll theme by Amit Merchant.
The blog is open to external contributors, and this post details the workflow and available features for all contributions.

## Table of Contents <!-- omit in toc -->

- [Workflow](#workflow)
  - [Previewing](#previewing)
- [Post preamble](#post-preamble)
- [Latex](#latex)
  - [Theorem environments](#theorem-environments)
    - [Referencing](#referencing)
  - [Typesetting diagrams](#typesetting-diagrams)
    - [Quiver](#quiver)
    - [Tikz](#tikz)
    - [Referencing](#referencing-1)
- [Images](#images)
    - [Referencing](#referencing-2)
- [Code](#code)
- [Cross-posting](#cross-posting)


## Workflow

Standard github workflow:
- Clone this repo
- Create a branch
- Write your post
- Make a PR
- Wait for approval

The blog will be automatically rebuilt once your PR is merged.

### Local Preview

For local preview, you will need to [install Jekyll](https://jekyllrb.com/docs/installation/).
Once the installation is complete, navigate to the root folder of the repository and run the following command once to install its dependencies:

```bash
bundle install
```

Now, everything is set up. To preview the blog, run the following command:

```bash
bundle exec jekyll serve --livereload
```

Jekyll will spawn a local server at `127.0.0.1:4000`: navigate to that address in a browser to see preview the blog locally.
If you encounter issues and need detailed debugging information, run the following command instead:

```bash
bundle exec jekyll serve --livereload --trace --verbose
```

If your page is not refreshing automatically upon changes, you might wish to enabled forced polling (although this is more CPU-intensive):

```bash
bundle exec jekyll serve --livereload --force_polling --trace --verbose
```

If you need to clear the Jekyll cache after a change of post filename, run the following command:

```bash
bundle exec jekyll clean
```

### Local Preview (Nix)

If you have the flakes-enabled nix package manager installed, you can instead use the nix flake devshell included in this repository to preview the blog contents:

```bash
nix develop
```

### Post and Asset Locations

Posts must be placed in the `_posts` folder.
Post titles follow the convention `yyyy-mm-dd-title.md`.
Post assets (such as images) go in a sub-folder `assetPost/yyyy-mm-dd-title` of the `assetsPost` folder named exactly as the post file (without the `.md` extension).
For example, if your post file is in `_posts/2024-06-11-zx-intro.md`, the corresponding assets go into `assetPost/2024-06-11-zx-intro`.

### Front Matter

Each post should start with the following YAML front matter:

```yaml
---
layout: post
title: the title of your post
author: your name(s)
categories: keyword or a list of keywords [keyword1, keyword2, keyword3]. Use quotes "" for multi-word keywords.
excerpt: A short summary of your post
image: assetsPosts/yyyy-mm-dd-title/imageToBeUsedAsThumbnails.png (optional, but useful if e.g. you share the post on social media)
usemathjax: true (set to false if you don't typeset math)
thanks: An optional short acknowledgement message. It will be shown immediately above the content of your post.
---
```

### Post Contents

The remainder of the post should be written in Markdown. The following sections present available features.

## Math

There are two main ways to type maths in this blog: Typst and Latex.

### Typst

This is the preferred choice. We have full typst support, and you can use it as you normally would on your laptop.
- Inline math is shown by using `\@@ ... \@@`. For instance the following snippet: `\@@ sum_(i=1)^n i = (n(n+1))/2 \@@` produces @@ sum_(i=1)^n i = (n(n+1))/2 @@.
- Display math is shown by using `\@@@ ... \@@@`. For instance, the following snippet: `\@@@ sum_(i=1)^n i = (n(n+1))/2 \@@@` produces 

@@@ sum_(i=1)^n i = (n(n+1))/2 @@@

- You can also use a liquid tag `typst` for display math. For instance:

```
{% raw %}
{% typst %}
    sum_(i=1)^n i = (n(n+1))/2
{% endtypst %}
{% endraw %}
```

Produces:

{% typst %}
    sum_(i=1)^n i = (n(n+1))/2
{% endtypst %}

If you need to pass particular preamble arguments to typst, you can do it with a preamble argument:

```
{% raw %}
{% typst {"preamble": "#set text(fill: red)"} %}
    sum_(i=1)^n i = (n(n+1))/2
{% endtypst %}
{% endraw %}
```

{% typst {"preamble": "#set text(fill: red)"} %}
    sum_(i=1)^n i = (n(n+1))/2
{% endtypst %}

### Latex

LaTeX is rendered using MathJax, which is notoriously quirky. We suggest going the Typst way when possible.

- Inline math is shown by using `$ ... $`. Notice that some expressions such as `a_b` typeset correctly, while expressions like `a_{b}` or `a_\command` sometimes do not. I guess this is because mathjax expects `_` to be followed by a literal.
- Display math is shown by using `$$ ... $$`. The problem above doesn't show up in this case, but you gotta be careful:
    ```markdown
    text
    $$ ... $$
    text
    ```
    does not typeset correctly, whereas:
    ```markdown
    text

    $$
    ...
    $$

    text
    ```
    does. You can also use environments, as in:
    ```
    $$
    \begin{align*}
     ...
    \end{align*}
    $$
    ```

### Theorem environments

We provide the following theorem environments: Definition, Proposition, Lemma, Theorem and Corollary. These support both Typst and Latex, even together. Numbering is automatic. If you need others, just ask. The way these works is as follows:
```latex
{% raw %}
{% def %}
A *definition* is a blabla, such that: $...$. Furthermore, it is:

$$
...
$$

And also

{% typst %}
    ...
{% endtypst %}


{% enddef %}
{% endraw %}
```

This gets rendered as follows:

{% def %}
A *definition* is a blabla, such that: $...$. Furthermore, it is:

$$
...
$$

And also

{% typst %}
    ...
{% endtypst %}

{% enddef %}

Numbering is automatic. Use the tags:

```latex
{% raw %}
{% def %}
    For your definitions
{% enddef %}

{% not %}
    For your notations
{% endnot %}

{% ex %}
    For your examples
{% endex %}

{% diag %}
    For your diagrams
{% enddiag %}

{% prop %}
    For your propositions
{% endprop %}

{% lem %}
    For your lemmas
{% endlem %}

{% thm %}
    For your theorems
{% endthm %}

{% cor %}
    For your corollaries
{% endcor %}
{% endraw %}
```

#### Referencing

If you need to reference results just append a `{"id":"your_reference_tag"}` after the tag, where `your_reference_tag` is the same as a LaTex label. For example:


```latex
{% raw %}
{% def {"id":"your_reference_tag"} %}
A *definition* is a blabla, such that: $...$. Furthermore, it is:

$$
...
$$
{% enddef %}
{% endraw %}
```

Then you can reference this by doing:

```markdown
As we remarked in [Reference description](#your_reference_tag), we are awesome...
```

### Typesetting diagrams

We support three types of diagrams: Typst, Quiver and TikZ. As usual Typst is the easiest choice. A diagram may be rendered as follows:

```
{% raw %}
{% typst %}
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#diagram(cell-size: 15mm, $
	G edge(f, ->) edge("d", pi, ->>) & im(f) \
	G slash ker(f) edge("ur", tilde(f), "hook-->")
$)

{% endtypst %}
{% endraw %}
```
And will produce:

{% typst %}

#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#diagram(cell-size: 15mm, $
	G edge(f, ->) edge("d", pi, ->>) & im(f) \
	G slash ker(f) edge("ur", tilde(f), "hook-->")
$)

{% endtypst %}

Here we used [fletcher](https://typst.app/universe/package/fletcher/), but really any Typst library works.

#### Quiver

You can render [quiver](https://q.uiver.app/) diagrams by enclosing quiver expoted iframes between `quiver` tags:
- On [quiver](https://q.uiver.app/), click on `Export: Embed code`
- Copy the code
- In the blog, put it between delimiters as follows:

```html
{% raw %}
{% quiver %}
<!-- https://q.uiver.app/codecodecode-->
<iframe codecodecode></iframe>
{% endquiver %}
{% endraw %}
```

They get rendered as follows:
{% quiver %}
<!-- https://q.uiver.app/#q=WzAsMyxbMCwwLCJYIl0sWzEsMiwiQiJdLFsyLDAsIkEiXSxbMCwxLCJnIiwxXSxbMiwxLCJmIiwxXSxbMCwyLCJoIiwxXV0= -->
<iframe class="quiver-embed" src="https://q.uiver.app/#q=WzAsMyxbMCwwLCJYIl0sWzEsMiwiQiJdLFsyLDAsIkEiXSxbMCwxLCJnIiwxXSxbMiwxLCJmIiwxXSxbMCwyLCJoIiwxXV0=&embed" width="432" height="432" style="border-radius: 8px; border: none;"></iframe>
{% endquiver %}

**Should the picture come out cropped, select `fixed size` when exporting the quiver diagram, and choose some suitable parameters.**

#### Tikz

You can render tikz diagrams by enclosing tikz code between `tikz` tags, as follows:

```latex
{% raw %}
{% tikz %}
  \begin{tikzpicture}
    \draw (0,0) circle (1in);
  \end{tikzpicture}
{% endtikz %}
{% endraw %}
```

Tikz renders as follows:
{% tikz %}
    \rotatebox{0}{
        \scalebox{1}{
            \begin{tikzpicture}
                    \node[circle, fill, minimum size=5pt, inner sep=0pt, label=left:{$1$}] (al1) at (-2,0) {};
                    \node[circle, fill, minimum size=5pt, inner sep=0pt, label=right:{$1$}] (ar1) at (0,0) {};
                    \node[circle, fill, minimum size=5pt, inner sep=0pt, label=right:{$2$}] (ar2) at (0,-1) {};
                    \node[circle, fill, minimum size=5pt, inner sep=0pt, label=right:{$3$}] (ar3) at (0,-2) {};
                        \draw[thick] (al1) to (ar1);
                        \draw[thick, out=180, in=180, looseness=2] (ar2) to (ar3);
            \end{tikzpicture}
        }
    }
{% endtikz %}

Notice that at the moment tikz rendering:
- Is not rendered on some browsers like Safari, unfortunately. This is a total bummer but there isn't much we can do about it. So refrain from using this unless strictly necessary.
- Supports any option you put after `\begin{document}` in a `.tex` file. So you can use this to include any stuff you'd typeset with LaTex (but we STRONGLY advise against it).
- Does not support usage of anything that should go in the LaTex preamble, that is, before `\begin{document}`. This includes exernal tikz libraries such as `calc`, `arrows`, etc; and packages such as `tikz-cd`. Should you need `tikz-cd`, use quiver as explained above. If you need fancier stuff, you'll have to render the tikz diagrams by yourself and import them as images (see below).

#### Referencing

Referencing works also for the quiver and tikz tags, as in:

```latex
{% raw %}
{% tikz {"id":"your_reference_tag"} %}
...
{% endtikz %}
{% endraw %}
```

This automatically creates a numbered 'Figure' caption under the figure, as in:

{% quiver {"id":"example"} %}
<!-- https://q.uiver.app/#q=WzAsMyxbMCwwLCJYIl0sWzEsMiwiQiJdLFsyLDAsIkEiXSxbMCwxLCJnIiwxXSxbMiwxLCJmIiwxXSxbMCwyLCJoIiwxXV0= -->
<iframe class="quiver-embed" src="https://q.uiver.app/#q=WzAsMyxbMCwwLCJYIl0sWzEsMiwiQiJdLFsyLDAsIkEiXSxbMCwxLCJnIiwxXSxbMiwxLCJmIiwxXSxbMCwyLCJoIiwxXV0=&embed" width="432" height="432" style="border-radius: 8px; border: none;"></iframe>
{% endquiver %}

Whenever possible, we encourage you to enclose diagrams into definitions/propositions/etc should you need to reference them.

## Images

Images are included via standard markdown syntax:

```markdown
![image description](image_path)
```

`image_path` can be a remote link. Should you need to upload images to this blog post, do as follows:

- Create a folder in `assetsPosts` with the same title of the blog post file. So if the blogpost file is `yyyy-mm-dd-title.md`, create the folder `assetsPosts/yyyy-mm-dd-title`
- Place your images there
- Reference the images by doing:
    ```markdown
    ![image description](../assetsPosts/yyyy-mm-dd-title/image)
    ```

If the name of the post changes, you should also change the name of the image folder. This will force you to change also the relative paths of all the images links. To avoid this, just specify

```yaml
asset_path: /assetsPosts/yyyy-mm-dd-title/
```

in the post preamble, and reference images by giving

```markdown
{% raw %}
![image description]({{page.asset_path}}/image)
{% endraw %}
```

In this way, changing `asset_path` will be enough, and you won't have to correct all the image references.

Whenever possible, we recommend the images to be in the format `.png`, and to be `800` pixels in width, with **transparent** backround. Ideally, these should be easily readable on the light gray background of the blog website. You can strive from these guidelines if you have no alternative, but our definition and your definition of 'I had no alternative' may be different, and **we may complain**.

#### Referencing

Referencing works exactly as for diagrams:

```latex
{% raw %}
{% figure {"id":"your_reference_tag"} %}
  ![image description](image_path)
{% endfigure %}
{% endraw %}
```

## Code

The onetimelabs blog offers support for code snippets:

```ruby
def print_hi(name)
  puts "Hi, #{name}"
end
print_hi('Tom')
#=> prints 'Hi, Tom' to STDOUT.
```

To include a code snippet, just give:

~~~markdown
```language the snippet is written in
your code
```
~~~

Check out the [Jekyll docs][jekyll-docs] for more info on how to get the most out of Jekyll. File all bugs/feature requests at [Jekyll’s GitHub repo][jekyll-gh]. If you have questions, you can ask them on [Jekyll Talk][jekyll-talk].

[jekyll-docs]: https://jekyllrb.com/docs/home
[jekyll-gh]:   https://github.com/jekyll/jekyll
[jekyll-talk]: https://talk.jekyllrb.com/

## Cross-posting

If you want to cross-post from another blog, just add this to the post preamble:

```yaml
crosspostURL: "https://example.com"
crosspostName: "Some text"
```

This will display the following banner at the very beginning of the post:

<div class="crosspost">
  This is a cross-post from <a href="https://example.com">some text</a>.
</div>
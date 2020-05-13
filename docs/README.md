# SSSD documentation sources

This repository contains the sources of the documentation of SSSD. You can
contribute to SSSD by improving the documentation!

If you are looking for the rendered documentation in HTML format, please see
the [docs link on SSSD's Pagure instance](https://pagure.io/docs/SSSD/sssd/).

## Contributing to the SSSD documentation

The SSSD documentation is written in RST. To contribute to the documentation:

1. Make sure Sphinx is installed (`dnf install python-sphinx graphviz` on Fedora)
2. Fork [this repository](https://pagure.io/SSSD/docs) on Pagure
3. Add your content.  The [Sphinx documentation](http://www.sphinx-doc.org/en/stable/contents.html)
   might prove useful. If you are adding a new page, don't forget to add it to
   an index!
4. Build the HTML pages with `make html`
5. Inspect that the result looks good. The HTML result is located in the `_build` directory
6. Create a local commit with your changes
7. Push it to your Pagure fork
8. Create a pull request

One of the SSSD maintainers will then review the pull request.

For fixing trivial issues like typos, you can also use the "Fork and edit"
button in the [SSSD docs repository](https://pagure.io/SSSD/docs) or just the
"Edit" button in your fork.

## Building the SSSD documentation

SSSD developers should use [this guide](https://docs.pagure.org/pagure/usage/using_doc.html)
to convert the RST markup into HTML and push the HTML into the main SSSD repository.

# Algorithms implemented throughout my academic life

Here, you will find:
- [x] Information about the courses, workshops, webinars, etc from where these algorithms were developed.
- [x] Algorithms implemented by me during such events.
- [x] Algorithms implemented by others, possibly during the same event where I've built mine. Such references will be in public [git submodules].
  - Such submodules are within the `other_solutions/` directory, with the name of the code author.
  - These submodules reference my fork of the original author repo. This ensure that we don't lose the reference if the original author deletes their repo.
  - These materials might be written in a language other than English.
  - If a submodule fits in different topics, then it is symlinked to these topics.
  - Some submodules might be private as they might contain sensitive Professors' computational solutions, which aren't supposed to be available online. In these cases, you cannot access these algorithms as it is restricted to personal consultation.
- [x] Code solution of book's computational exercises. Such books are usually used as reference.
- [x] External theoretical references (books, videos, online courses, etc) for further study of each algorithm.
- [x] External technical references (software, packages that implement such algorithms, tools, etc) that are important for each topic.
- [x] Laboratory or computational homework slides, if the implemented algorithms come from such materials.

Here, you won't find:
- [ ] Book PDFs or theoretical lectures slides.
- [ ] Software

----

## Git-annex for Large files

This repository uses [`git-annex`] to store any file larger than 50MB in my Google Drive. Any new file larger than that should be stored in `git-annex`. For more info, see [here].

[here]: https://gist.github.com/tapyu/0427afb25df969c1972942d945284ba2#git-annex
[git submodules]: https://git-scm.com/book/en/v2/Git-Tools-Submodules
[`git-annex`]: https://git-annex.branchable.com

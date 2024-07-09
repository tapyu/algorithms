# Algorithms implemented throughout my academic life

Here, you will find code implentation from two main (and possibly distict) sources:
- Algorithms implementations during an event (courses, workshops, webinars, etc.).
- Algorithms implementations of book's computational exercises.

The **directory structure is organized by field of knowledge**, and depending on the directory's complexity, you can have a nested structure.

## Algorithms implementations during an event (courses, workshops, webinars, etc.)

If such content is a subdirectory with other directories, we can prefix the dir name with the event code. For instance, `tip7077_computational_intelligence/` contains the code developed during the course "Computational Intelligence", whose course code is TIP7077. If the event is a conference or similar, we can used the event initials as prefix.

Here, you will find:
- [x] Information about the courses, workshops, webinars, etc from where these algorithms were developed.
- [x] Algorithms implemented by me during such events. If such algorithms come from a computational homework slide, it is also made available.
- [x] Algorithms implemented by others, possibly during the same event where I've built mine. Such references will be in public [git submodules].
  - Such submodules are within the `other_solutions/` directory, with the name of the code author.
  - These submodules reference my fork of the original author repo. This ensure that we don't lose the reference if the original author deletes their repo.
  - These materials might be written in a language other than English.
  - If a submodule fits in different topics, then it is symlinked to these topics.
  - Some submodules might be private as they might contain sensitive Professors' computational solutions, which aren't supposed to be available online. In these cases, you cannot access these algorithms as it is restricted to personal consultation.
- [x] External theoretical references (books, videos, online courses, etc) for further study of each algorithm.
- [x] External technical references (software, packages that implement such algorithms, tools, etc) that are important for each topic.

## Algorithms implementations of book's computational exercises.

If such content is a subdirectory with other directories, we can prefix the dir name with `./book_` and the author name. For instance, under `./artificial_intelligence`, we can have `book_simon_haykin/`, which contains algorithms implementation discussed in the book "Neural Networks and Learning Machines", by Simon Haykin.

There you will find:
- [x] Code solution of book's computational exercises. Such books are usually used as reference in the events.
- [x] Algorithms implemented by others and make available on Github. Such references will be in public [git submodules].
  - Such submodules are within the `other_solutions/` directory, with the name of the code author.
  - These materials might be written in a language other than English.

---

Here, you won't find:
- [ ] Books or theoretical lectures slides.
- [ ] Software

----

## Git-annex for Large files

This repository uses [`git-annex`] to store any file larger than 50MB in my Google Drive. Any new file larger than that should be stored in `git-annex`. For more info, see [here].

[here]: https://gist.github.com/tapyu/0427afb25df969c1972942d945284ba2#git-annex
[git submodules]: https://git-scm.com/book/en/v2/Git-Tools-Submodules
[`git-annex`]: https://git-annex.branchable.com

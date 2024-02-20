\ProvidesClass{sobraep}[2015/05/12 V1.0]
\NeedsTeXFormat{LaTeX2e}
\LoadClass[10pt,twocolumn]{article}

\RequirePackage{ifthen}
\RequirePackage{setspace}
\RequirePackage{fancyhdr}
%\RequirePackage[latin1]{inputenc} %% pacote quebrado 
\RequirePackage[T1]{fontenc}
\RequirePackage{graphicx}
\RequirePackage{float}
\RequirePackage[caption=false]{subfig}
\RequirePackage{geometry}
\RequirePackage{indentfirst}
\RequirePackage{caption}
\RequirePackage{fancybox}
\RequirePackage{lastpage}
\RequirePackage{color}
\RequirePackage{amssymb}
\RequirePackage{amsfonts}
\RequirePackage{amsthm}
\RequirePackage{amsmath}
\RequirePackage{multicol}
\RequirePackage{mathptmx}
\RequirePackage{cite}
\RequirePackage{epstopdf}
\RequirePackage{multirow}
\RequirePackage{booktabs}
\RequirePackage{balance}


%*******************************************************************
%*******************************************************************
% Options

%Padrão
\def\configlanguage{2}

\DeclareOption{english}
  {
    \def\configlanguage{1}
  }

\DeclareOption{portugues}
  {
    \def\configlanguage{2}
  }

\ProcessOptions

\ifnum \configlanguage = 1
\RequirePackage[english]{babel}
\else
\RequirePackage[brazil]{babel}
\fi

\geometry{tmargin=25mm,
	            lmargin=18mm,
	            rmargin=12mm,
	            bmargin=25mm,
	            a4paper,
		        ignoreheadfoot}%

\newcommand{\titulo}[1]{\gdef\@portuguesetitle{#1}} %

%Resumos e Abstract
\newenvironment{resumo}{\noindent\hspace*{4mm}\normalsize{\bf{\em Resumo --}}\normalsize\bf}{\par\rm\small\medskip\medskip}

\renewenvironment{abstract}{\noindent\hspace*{4mm}\normalsize{\bf{\em Abstract --}}\normalsize\bf}{\par\rm\small\medskip\medskip}

\newenvironment{keywords}{\noindent\hspace*{4mm}\normalsize{\bf{\em Keywords --}}\normalsize\bf}{\par\rm\small\medskip}

\newenvironment{palavraschave }{\noindent\hspace*{4mm}\normalsize{\bf{\em Palavras-chave --}}\normalsize\bf}{\par\rm\small\medskip\medskip}

%Seções
\setcounter{secnumdepth}{3}
\def\thesection {\Roman{section}.\hskip-7.2pt}
\def\thesubsection {\Alph{subsection}.\hskip-7.2pt}
\def\thesubsubsection {\arabic{subsubsection})\hskip-7.2pt}

\renewcommand\section{\@startsection {section}{1}{\z@}{2.0ex plus
									    0.5ex minus .2ex}{2.0ex plus 0.3ex minus .2ex}{\centering}}
\renewcommand\subsection{\@startsection{subsection}{2}{\z@}{1.8ex plus
		                                0.5ex minus .2ex}{0.2ex plus .0ex}{\it\raggedright}}
\renewcommand\subsubsection[1]{\@startsection{subsubsection}{3}{4mm}{-2.5ex plus
								       -1ex minus-.2ex}{-0.6ex}{\it\raggedright}{#1:}}

\def\maketitle{\par %
	\begingroup %
		\twocolumn[\@maketitle]
	\endgroup %
	\let\maketitle\relax \let\@maketitle\relax
} %
\def\@maketitle{ \centering
	{\Large \bf \ifnum \configlanguage = 1 \@title 	\else  \@portuguesetitle \fi  \par} 
	\vskip 16.75pt
	{\large\@author}
	\vskip 9mm}

\def\englishtitle{ {\centering\large\bf\@title\par} \medskip\medskip }

%footnote rule
\renewcommand\footnoterule{\noindent\rule{5.075cm}{0.85pt}\vskip 6pt}

%nomenclature
\newcommand{\symbolnomenclature}[2]{\indent\parbox{16mm}{#1}{#2\par}}

\newcommand{\symboldescription}[2]{\indent\parbox{8.5mm}{#1}{- #2\par}}

%Table
\renewcommand{\thetable}{\Roman{table}}
\captionsetup[table]{labelsep = newline, labelfont=bf,  justification=centering}
\captionsetup[figure]{labelsep = period, font=small, justification=justified, singlelinecheck=off}
\addto\captionsenglish{\renewcommand{\figurename}{Fig.}}
\addto\captionsbrazil{\renewcommand{\figurename}{Fig.}}
\addto\captionsenglish{\renewcommand{\tablename}{\bf TABLE}}
\addto\captionsbrazil{\renewcommand{\tablename}{\bf TABELA}}
\addto\captionsenglish{\renewcommand{\refname}{REFERENCES}}
\addto\captionsbrazil{\renewcommand{\refname}{REFERÊNCIAS}}

%Elimina a numerção de página
\pagestyle{empty}

%Espaçamento entre paragrafos
\setlength{\parskip}{0pt}

%indent config
\setlength\parindent{4.0mm}

%Configura espaçamento entre colunas
\setlength\columnsep{6.0mm}

%Configura espaçamento entre linhas
\renewcommand{\baselinestretch}{0.985}

%Configuração de Listas
\def\@listI{\leftmargin 7.5mm \leftmargini\parsep  \topsep 0pt  \itemsep -1.25mm \partopsep 10pt \listparindent 0pt 
	              \labelsep 4.5mm }


\setlength{\textfloatsep}{7pt} 
\setlength{\intextsep}{7pt} 
\setlength{\abovecaptionskip}{3pt}
\setlength{\belowcaptionskip}{3pt}

	\setlength{\abovedisplayskip}{1cm}
	\setlength{\belowdisplayskip}{1cm}


\sloppy
\hyphenpenalty=10000
\hyphenchar\font=-1

\hbadness=10000
\vbadness=\maxdimen

\newtheorem{theorem}{Theorem}
\newtheorem{acknowledgement}[theorem]{Acknowledgement}
\newtheorem{axiom}[theorem]{Axiom}
\newtheorem{case}[theorem]{Case}
\newtheorem{claim}[theorem]{Claim}
\newtheorem{conclusion}[theorem]{Conclusion}
\newtheorem{condition}[theorem]{Condition}
\newtheorem{conjecture}[theorem]{Conjecture}
\newtheorem{corollary}[theorem]{Corollary}
\newtheorem{criterion}[theorem]{Criterion}
\newtheorem{definition}[theorem]{Definition}
\newtheorem{example}[theorem]{Example}
\newtheorem{exercise}[theorem]{Exercise}
\newtheorem{lemma}[theorem]{Lemma}
\newtheorem{notation}[theorem]{Notation}
\newtheorem{problem}[theorem]{Problem}
\newtheorem{proposition}[theorem]{Proposition}
\newtheorem{remark}[theorem]{Remark}
\newtheorem{solution}[theorem]{Solution}
\newtheorem{summary}[theorem]{Summary}
\renewenvironment{proof}[1][Proof]{\textbf{#1.} }{\ \rule{0.5em}{0.5em}}

\renewcommand\citeform[1]{[#1]}
\renewcommand\citeleft{}
\renewcommand\citeright{}

\AtBeginDocument{

	
}

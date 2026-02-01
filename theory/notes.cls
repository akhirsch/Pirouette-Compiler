\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{notes}[2023/10/27 Course Notes]

% Packages
\RequirePackage{xcolor}
\RequirePackage{xparse}
\RequirePackage{graphicx}
\RequirePackage[absolute,overlay]{textpos}
\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage{amsthm}
\RequirePackage{stmaryrd}
\RequirePackage{comment}
\RequirePackage{commenters}
\RequirePackage{pl-syntax/pl-syntax}
\RequirePackage{mathpartir}

% AMSTHM Setup
\newtheorem{thm}{Theorem}
\newtheorem{lem}{Lemma}
\newtheorem{prop}{Proposition}
\newtheorem{cor}{Corollary}
\theoremstyle{definition}
\newtheorem{defn}{Definition}
\newtheorem*{nb}{Note}
% \newtheorem{prob}{Problem}

% Commenters Setup
\newcommenter{\akh}{purple}{AKH}

% Ignore Hidden Commands
\excludecomment{hidden}

% Macros

%% Title Macros
\newcommand{\coursename}[1]{\makeatletter\newcommand{\@coursename}{#1}\makeatother}
\newcommand{\lecnumber}[1]{\makeatletter\newcommand{\@lecno}{#1}\makeatother}
\renewcommand{\author}[1]{\makeatletter\newcommand{\@auth}{#1}\makeatother}


% Class Options
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax

\LoadClass[letterpaper]{article}

\renewcommand{\maketitle}{%
  \begin{textblock*}{8in}(0cm,0.25cm)
    \framebox[\textwidth]{
      \vspace{1em}%
      \begin{minipage}{1.0\linewidth}
        \begin{center}
          {\fontsize{15}{20}\fontfamily{phv}\fontseries{b}\selectfont\@coursename}\\[1em]
          {\fontsize{20}{30}\fontfamily{phv}\fontseries{b}\selectfont Lecture~\@lecno:~\@title}\\[1em]
          {\fontsize{10}{15}\fontfamily{phv}\fontseries{b}\selectfont Scribe:~\@auth}%
        \end{center}
      \end{minipage}
      \vspace{1em}
    }%
  \end{textblock*}%
  \vspace*{1in}%
}

\renewcommand{\section}{\@startsection{section}{1}{-1pt}{-1.5ex plus -1ex minus -0.2ex}{1ex plus .2ex}{\normalfont\Large\bfseries}}

\renewcommand{\subsection}{\@startsection{subsection}{2}{-1pt}{-1.5ex plus -1ex minus -0.2ex}{1ex plus .2ex}{\normalfont\large\bfseries}}

\setlength{\textwidth}{7in}
\setlength{\textheight}{9in}
\topmargin -1in
\oddsidemargin -0.25in
\evensidemargin -0.25in
\setcounter{secnumdepth}{0}
\pagenumbering{arabic}


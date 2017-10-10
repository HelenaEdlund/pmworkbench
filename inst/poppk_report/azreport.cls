%----------------------------------------------------------------------------------------
% azreport.cls; Class file 
% 
% This class file defines the structure and design for publishing ready 
% documents at AstraZeneca
% 
% Author: Helena Edlund helena.edlund (at) astrazeneca.com
% 2017-07-24
% version 1.0 :  WORK IN PROGRESS - TO BE CONFIRMED WITH PUBLISHING
%----------------------------------------------------------------------------------------
%
%----------------------------------------------------------------------------------------
% Class structure: identification
%----------------------------------------------------------------------------------------
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{azreport}[2017/07/06 Publishing ready documents AstraZeneca v. 1.0]
%
%----------------------------------------------------------------------------------------
% Class structure: declaration and execution of options 
%----------------------------------------------------------------------------------------
% This class extends the article class. Therefore, read all the document class options and pass them to article. 
\DeclareOption*{%
	\PassOptionsToClass{\CurrentOption}{article}%
}
\ProcessOptions\relax
\LoadClass{article}
%
%----------------------------------------------------------------------------------------
%	Defintions of report variables - to be set by author in the premeable of the report
%----------------------------------------------------------------------------------------
% Type of report to write
\def\@reportType{Population Pharmacokinetic Report}
\newcommand{\reporttype}[1]{\def\@reportType{#1}}
% Drug Substance
\def\@drugName{AZD0000}
\newcommand{\drugname}[1]{\def\@drugName{#1}}
% Study code 
\def\@studyCode{D0000C00000}
\newcommand{\studycode}[1]{\def\@studyCode{#1}}
% Edition 
\def\@reportVersion{1.0}
\newcommand{\reportversion}[1]{\def\@reportVersion{#1}}
% Date
\def\@reportDate{1.0}
\newcommand{\reportdate}[1]{\def\@reportDate{#1}}
% Subtitle
\def\@subTitle{Clinical Studies: XXX}
\newcommand{\subtitle}[1]{\def\@subTitle{#1}}
% Reviewers
\global\let\@reviewers\@empty
\newcommand{\reviewers}[1]{\def\@reviewers{#1}}
% Approvers
\global\let\@approverone\@empty
\newcommand{\approverone}[1]{\def\@approverone{#1}}
\global\let\@approvertwo\@empty
\newcommand{\approvertwo}[1]{\def\@approvertwo{#1}}
% Affiliations
\def\@affiliations{Quantitative Clinical Pharmacology, AstraZeneca}
\newcommand{\affiliations}[1]{\def\@affiliations{#1}}
%
%----------------------------------------------------------------------------------------
%	Define commands to make references within text
%----------------------------------------------------------------------------------------
% Provide bookmarks and hyperlinks for each item listed in the 
% TOC including all tables, figures, publications, other references,
% and appendices that are essential for navigation through documents
% The bookmark hierarchy must be identical to the TOC; up to four levels deep in the hierarchy.
% Bookmarks and hyperlinks must target the correct destination.
\newcommand{\fref}[1]{Figure~\ref{#1}}
\newcommand{\tref}[1]{Table~\ref{#1}}
\newcommand{\eref}[1]{Equation~\ref{#1}}
\newcommand{\sref}[1]{Section~\ref{#1}}
\newcommand{\aref}[1]{Appendix~\ref{#1}}
%
% TODO: textsubscript
%----------------------------------------------------------------------------------------
% Class structure: The following sections define or re-define commands to 
% 				format the pdf according to `4-S5-cv-X Submission Ready Standards' v. 2.0
%----------------------------------------------------------------------------------------
%
% Compiling with xelatex generates a pdf version 1.5 (1.4-1.7 are AZ acceptable)
% 
%----------------------------------------------------------------------------------------
%	1. Packages for table of contents (needs to be loaded before hyperref)
%----------------------------------------------------------------------------------------
\RequirePackage{titletoc}                         % partial tocs
\RequirePackage{tocloft}   				                % custom toc
\RequirePackage[numbib,notlot,notlof]{tocbibind}  % numbered section bibliography in toc
\RequirePackage[title]{appendix}	                % better appendix environment
\RequirePackage{chngcntr}	                        % handles counters in appendices
%
%----------------------------------------------------------------------------------------
%	2. Tables, Figures, Captions, Handling floats etc (do not change the order of the loading)
%----------------------------------------------------------------------------------------
\RequirePackage[section]{placeins}	% managing floats. 
\RequirePackage{graphicx} 
\RequirePackage{multirow}	          % multirow staments in tables
\RequirePackage{longtable}	        % multipage spanning tables
\RequirePackage{array}              % left-aligned, width determined cells in tables
\RequirePackage[dvipsnames,table]{xcolor}
\RequirePackage{arydshln}           
\RequirePackage{amsmath}			      % nicer equations
\RequirePackage{amssymb}
\RequirePackage{hhline}
%
\RequirePackage{caption}
\RequirePackage{pdfpages}	      % includes external PDFs (e.g. pre-published analysis plan)
\RequirePackage{pdflscape}	    % change to landscape
%
% Create command to add footnote to figures/tables
\newcommand\fnote[1]{\captionsetup{font=small}\caption*{#1}}
\renewcommand{\arraystretch}{1.25}  % longer rowheight in tables
% \newcolumntype{L}{>{\raggedright\arraybackslash}p{6cm}} % size can be overwritten
%----------------------------------------------------------------------------------------
%	3. Fonts
%----------------------------------------------------------------------------------------
% All fonts need to be embedded - occurs automatically but may be problematic for plots. 
% Use size 9-12pt.
% Use standard fonts: Times new roman, Arial, Courier New or Symbol
\usepackage{fontspec}
\setmainfont[Path = fonts/, 
    UprightFont = times,
    BoldFont = timesbd,
    ItalicFont = timesi,
    BoldItalicFont =timesbi]{times}
%
% Font color should be black (automatic). 
% Hyperlinks must be designated by blue text or by rectangles using thin lines.
\RequirePackage{hyperref}
\hypersetup{colorlinks = true,
            linkcolor=blue,
	  	     	citecolor = blue}		     
% External links (web links or email links) must be valid and NOT hyperlinked. 
%----------------------------------------------------------------------------------------
%	4. Paragraphs & typesetting penalties
%----------------------------------------------------------------------------------------
\usepackage{ragged2e}
\RaggedRight % Left aligned
\raggedbottom % no additonal vertical space
% Set the distance between normal paragraphs to 12 pt
\setlength{\parskip}{12pt plus 0.4pt minus 0.4pt}
% no indention of paragraphs
\setlength{\parindent}{0pt}
%
% \setlength{\topskip}{1\topskip \@plus 5\p@}
% \setlength\arrayrulewidth{.5\p@}% increase linewidht to 0.5 
%
\doublehyphendemerits=10000		    % No consecutive line hyphens.
\brokenpenalty=10000              % No broken words across columns/pages.
\interfootnotelinepenalty=9999    % Almost never break footnotes.
%
%----------------------------------------------------------------------------------------
%	5. Margins, Headers and Footers
%----------------------------------------------------------------------------------------
% The print area (all text including header and footer) must fit on both Letter and A4 paper
\RequirePackage{geometry}
\RequirePackage{fancyhdr}
\RequirePackage{lastpage}
% Margins
\geometry{includeheadfoot,
		   top=0.51in,       
		   bottom=0.51in, 
		   left=1.18in,
		   right=1in, 
		   headheight=67pt} % height of header
% includeheadfoot option = top and bottom defines distance from top of page to top of header
%
% Define header and footer page styles: 
% different first page and for the following pages
\fancypagestyle{titlepage}{%
	\fancyhf{} 				  									% clear all six header/footer fields
	\fancyhead[L]{\includegraphics[width=5.3cm]{AZlogo.png}} 		% include AZ logo on leftheader
	\renewcommand{\headrulewidth}{0pt}    % no line under header
	\renewcommand{\footrulewidth}{0pt}    % no line under footer
}%
% page numbering: starts at 1 and all subsequent pages are 
% numbered consecutively with Arabic numerals
\fancypagestyle{followingpage}{%
	\fancyhf{} 											                  % clear all six fields
	\fancyhead[L]{\small{\textbf{\@reportType} }\\    % left side header
				\small{\textbf{Drug Substance}~\@drugName}\\ 
				\small{\textbf{Study Code}~\@studyCode}\\ 
				\small{\textbf{Edition}~\@reportVersion}\\ 
				\small{\textbf{Date}~\@reportDate}%
				} 
	\fancyfoot[C]{\thepage~(\pageref{LastPage})}	% Page number (total # pages) at center footer
	\renewcommand{\headrulewidth}{0pt}  % no line under header
	\renewcommand{\footrulewidth}{0pt}   % no line under footer
}%
\pagestyle{followingpage}	% set to follwingpage (for first page is set in titlepage below)
%
%----------------------------------------------------------------------------------------
%	6. Title page design
%----------------------------------------------------------------------------------------
\renewcommand\@maketitle{%
  \newpage%
  \thispagestyle{titlepage}%
  % right centered table at top of page
  {\begin{flushright}
    		\begin{tabular}{l l}%
    		\hline \\[-9pt]
    		\multicolumn{2}{l}{\small{\textbf{\@reportType}}}\\[3pt]
    		\small{Drug Substance} 		& \@drugName \\[3pt] 
    		\small{Study Code} 				& \@studyCode \\[3pt] 
    		\small{Edition} 					& \@reportVersion \\[3pt] 
    		\small{Date} 					    & \@reportDate \\[3pt]
    		\hline
   \end{tabular}\par
	\end{flushright}}%
	%	big vertical space and then title and subtitle
  \vskip 4em
  \rule{\textwidth}{3pt}%	line above title
 	\par
	{\Large\bfseries \@title \par}% title 
	{\large\bfseries \@subTitle}% subtitle
	\par
	\rule{\textwidth}{3pt}% line below title
	%	small vertical space and then author, reviewers, approvers
	\par
  {\begin{tabular}{p{2.8cm} p{12cm}}%
  \textbf{Prepared by:}	& \@author \\[1.0ex]
  \textbf{Reviewed by:}	& \@reviewers \\[1.0ex]
  \end{tabular}
  % 				big vertical space to allow for signature
  \vskip 4em
  \begin{tabular}{p{2.8cm} p{5cm} p{0.5cm} p{5cm}}%
  \textbf{Approved by:}	&               & &                      \\
  \hhline{~-~-}\\[-2ex]
                      	& \@approverone & & Date (Day Month Year) \\
  \end{tabular}
  % add section approver if provided
  {\if\@approvertwo\@empty%
    	\par
	 \else%
	 % 				big vertical space to allow for signature
  		\vskip 4em%
  		\begin{tabular}{p{2.8cm} p{5cm} p{0.5cm} p{5cm}}%
     	\textbf{Approved by:}	&               & &                       \\
     	\hhline{~-~-}\\[-2ex]
      	                    & \@approvertwo & & Date (Day Month Year) \\
      \end{tabular}
      \par
    \fi}
    }%
    % vertical skip and add affiliations
    \vskip 1em%
    \rule{\textwidth}{1pt}\par%	line above affiliations
    {\small{\@affiliations}}
  \par
  \clearpage
}%
%
%----------------------------------------------------------------------------------------
%	7. Formating of lists (bullets and numbered)
%----------------------------------------------------------------------------------------
% This section remains to be fixed but am waiting for cluster update of latex packages
\RequirePackage[shortlabels]{enumitem}
%
% A-List bullet (level 1) and A-list subsidary (level 2)
\setlist{parsep=\parskip} % all bullets separated by 12pt (=parskip)
% Level 1: bullet, no indent of bullet and 0.69 hanging
\setlist[1]{leftmargin=*, labelsep=0.69in}
% Level 2: dash, 0.69 indent + 0.31 hanging.
% No info provided for level 3 and 4 but appears similar to level 2.
\setlist[2,3,4]{leftmargin=*, labelsep=0.31in}    % relative previous level
\renewcommand{\labelitemiii}{\textendash}         % changes label to dash
\renewcommand{\labelitemiv}{\textendash}          % changes label to dash
% 
% A-list (a), A-list (i), A-list Number. 
% Selection of level 1 indicator controlled by user, number by default.
\setlist[enumerate,2]{label=\alph*.}
\setlist[enumerate,3]{label=\roman*.}
\setlist[enumerate,4]{label=\arabic*.}
% 
%----------------------------------------------------------------------------------------
%	8. Misc packages
%----------------------------------------------------------------------------------------
\RequirePackage[UKenglish]{babel}
\RequirePackage{underscore}     	% underscore not a special character in text mode
% 
%----------------------------------------------------------------------------------------
%	9. Design of section headers
%----------------------------------------------------------------------------------------
% Redefined the headings. The space before and after automatically includes \parskip. 
% Hence, remove 12 from original definition. 
% The after skip needs to be positive otherwise there is no linebreak after the section header
% Publishing has confirmed that the extra linespace after the headers is ok (12 instead of 6). %
% Heading 1: 14pt, Bold, All caps. 24 pt before and 12 after
\renewcommand\section{\@startsection{section}{1}{\z@} % name, level, indent (indents both number and text)
                                   {12pt \@plus 0.6pt \@minus 0.6pt}% before skip
                                   {0.1pt \@plus 0.05pt \@minus 0.05pt}% after skip
                                   {\normalfont\large\bfseries\MakeUppercase}} % style
% Heading 2: 14pt, Bold. 6 pt before and 6 after
\renewcommand\subsection{\@startsection{subsection}{2}{\z@}%
                                   {0.1pt \@plus 0.05pt \@minus 0.05pt}%
                                   {0.1pt \@plus 0.05pt \@minus 0.05pt}%
                                   {\normalfont\large\bfseries}}
% Heading 3: 12pt, Bold. 0 pt before and 6 after
\renewcommand\subsubsection{\@startsection{subsubsection}{3}{\z@}%
                                   {0.1pt \@plus 0.05pt \@minus 0.05pt}%
                                   {0.1pt \@plus 0.05pt \@minus 0.05pt}%
                                   {\normalfont\normalsize\bfseries}}
% Heading 4: 12pt, Bold. 0 pt before and 6 after
\renewcommand\paragraph{\@startsection{paragraph}{4}{\z@}%
                                   {0.1pt \@plus 0.05pt \@minus 0.05pt}%
                                   {0.1pt \@plus 0.05pt \@minus 0.05pt}%
                                   {\normalfont\normalsize\bfseries\itshape}}
% Heading 5: 12pt, Bold (no numbering). 0 pt before and 6 after
\renewcommand\subparagraph{\@startsection{subparagraph}{5}{\parindent}%
                                   {0.1pt \@plus 0.05pt \@minus 0.05pt}%
                                   {0.1pt \@plus 0.05pt \@minus 0.05pt}%
                                   {\normalfont\normalsize\bfseries}}
% Appendix title is set in the appendix environment below
%
%----------------------------------------------------------------------------------------
%	10. Citations and Bibliography
%----------------------------------------------------------------------------------------
\RequirePackage{natbib} 
% \RequirePackage{biblatex}            % easier bibliography handling - not installed on cluster...
%
%----------------------------------------------------------------------------------------
%	11. Table of contents
%----------------------------------------------------------------------------------------
% Dependent on the already loaded packages
%
%-----------------------------------
%	Create a list of appendices
%-----------------------------------
\newcommand{\listappname}{List of appendices}
\newlistof{app}{loa}{\listappname}
\newcommand{\azappendix}[1]{% needs to be added by this command to be in the list
	\section{#1}%
	\addcontentsline{loa}{app}{\appendixname~\thesection~#1}
}%
%
%-----------------------------------
%	Change the toc designs
%-----------------------------------
\tocloftpagestyle{followingpage}
%
% Change the title for toc 
\AtBeginDocument{
	\renewcommand{\contentsname}{Table of contents}
	\renewcommand{\listtablename}{List of tables}
	\renewcommand{\listfigurename}{List of figures}
	\renewcommand{\tocbibname}{References}
}%
%
% Change font and separation of toc tiles (same as section style)
% Only needed for loa when titletoc is used 
% (titletoc catches the style of sections and overwrites for toc, lof, lot) 
% \renewcommand{\cfttoctitlefont}{\normalfont\large\bfseries\MakeUppercase}
% \renewcommand{\cftlottitlefont}{\normalfont\large\bfseries\MakeUppercase}
% \renewcommand{\cftloftitlefont}{\normalfont\large\bfseries\MakeUppercase}
\renewcommand{\cftloatitlefont}{\normalfont\large\bfseries\MakeUppercase}
\setlength{\cftafterloatitleskip}{0pt}
%
% smaller space between dots connecting title and page number
\renewcommand{\cftdotsep}{0.4}
\renewcommand{\cftsecleader}{\cftdotfill{\cftdotsep}} % dots for sections as well
%
% More space between rows in tables
\renewcommand{\cftparskip}{12pt} % only affects list of app, 
% the other lists are overwritten by the titletoc packages
%
% Remove indention of the subsections in all TOC
\addtocounter{secnumdepth}{1}
\setcounter{tocdepth}{4}
\cftsetindents{section}{0in}{0.6in}
\cftsetindents{subsection}{0in}{0.6in}
\cftsetindents{subsubsection}{0in}{0.6in}
\cftsetindents{paragraph}{0in}{0.6in}
\cftsetindents{fig}{0in}{0.6in}
\cftsetindents{tab}{0in}{0.6in}
%
% Set the fonts of the section table entries to upper case
\renewcommand\cftsecfont{\normalfont}%
% I do not get MakeUppercase to work here... use \scshape ?
% https://tex.stackexchange.com/questions/25694/error-when-trying-to-use-maketextuppercase-to-customize-the-table-of-contents
\renewcommand{\cftsecpagefont}{\normalfont}% non-bold
%
%
% Re-set the counters of figures and tables for appendices and defefine the section style to 
% match A-appendix title (same as header 1 but not uppercase)
\g@addto@macro\appendices{%
	\counterwithin{figure}{section}%
	\counterwithin{table}{section}%
  \renewcommand\section{\@startsection{section}{1}{\z@}% name, level, indent
                       {12pt \@plus 0.6pt \@minus 0.6pt}% before skip
                       {0.1pt \@plus 0.05pt \@minus 0.05pt}% after skip
                       {\normalfont\large\bfseries}} % style
}% NOTE: "\AtBeginEnvironment{appendices}" does for some reason not work with xelatex
%
% Add `Figure' and `Table' before the numbers in list of figures and list of tables
\renewcommand{\cftfigpresnum}{Figure~}% figure before number
\renewcommand{\cftfigaftersnum}{~}% space after
\renewcommand{\cfttabpresnum}{Table~}%
\renewcommand{\cfttabaftersnum}{~}%
%
% Increase the size of the box figure, table and appendixes are written in to aviod overlaying text
\setlength{\cftfignumwidth}{60pt}% fig
\setlength{\cfttabnumwidth}{60pt}% tab
\setlength{\cftappnumwidth}{65pt}% app
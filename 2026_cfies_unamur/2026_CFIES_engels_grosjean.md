# Transformer l’évaluation des étudiants en science des données biologiques grâce à des tutoriels interactifs

Guyliann Engels<sup>1</sup> & Philippe Grosjean<sup>2</sup>

<sup>1</sup> *Service d'écologie numérique, Institut Complexys & Infortech, Université de Mons, Belgique, guyliann.engels@umons.ac.be*

<sup>2</sup> *Service d'écologie numérique, Institut Complexys & Infortech, Université de Mons, Belgique, philippe.grosjean@umons.ac.be*

**Mots-clés.** Science des données biologiques, Évaluation continue, Tutoriels interactifs, précorrection par IA

**Title.** Assessing biological data science students using interactive tutorials.

**Keywords.** Biological Data Science, Continuous assessment, Interactive tutorials, AI-assisted pre-grading

## 1 Contexte

La science des données biologiques requiert l’acquisition de compétences pratiques et théoriques par les étudiants. Ils doivent maîtriser des notions de statistiques, de programmation (en R dans notre formation) et de biologie. L’évaluation de telles compétences ne peut être réalisée correctement via des interrogations sur papier ou des QCM (en ligne). La programmation nécessite de pouvoir exécuter son code. Dans ce contexte nous présentons un dispositif d’évaluation sur ordinateur permettant aux étudiants d’exécuter du code R dont l’utilisation est strictement cadrée.

## 2 Développement

Le dispositif concerne 108 étudiants inscrits dans quatre cours successifs de science des données biologiques répartis de la deuxième à la cinquième année de la formation en biologie à l’Université de Mons (<https://wp.sciviews.org>). Les trois premiers cours sont obligatoires et le dernier est à option. Les étudiants participent en moyenne tous les quinze jours à une activité d’évaluation sous la forme d’un questionnaire interactif. Dès le début de l’année académique, un planning de travail précis est fourni (voir par exemple <https://wp.sciviews.org/sdd-umons2/?iframe=wp.sciviews.org/sdd-umons2-2025/planning.html>).

Durant le premier quadrimestre, 41 questionnaires composés de 298 questions ont été rédigés. Les questions sont réparties en 61 questions à choix multiples, 81 questions ouvertes et 156 questions nécessitant la rédaction de code R. Les étudiants ont la possibilité de soumettre plusieurs réponses pour une même question. L’ensemble des interactions réalisées par les étudiants est enregistré dans un Learning Record Store (LRS), permettant la collecte de 45000 traces d’apprentissage uniquement sur le premier quadrimestre.

Les étudiants peuvent réaliser les épreuves sur leur ordinateur personnel, dans un environnement informatique familier. Ils ont accès à un environnement d’évaluation dans lequel les enseignants définissent les ressources externes autorisées, garantissant ainsi l’intégrité des évaluations. Les épreuves sont réalisables à cahier ouvert ou non. Chaque épreuve est néanmoins limitée dans le temps.

Chaque questionnaire est conçu en R Markdown et remplit deux fonctions complémentaires. Premièrement il sert de modèle pour le questionnaire d’interrogation. Deuxièmement il intègre des balises particulières interprétées par un script R qui le transforme en modèle de correction de l'épreuve. Ce dernier reprend les questions et permet de générer un document personnalisé pour chaque étudiant, comprenant ses dernières réponses, la note obtenue ainsi qu’un commentaire pour chaque question. Cette restitution favorise un retour personnalisé, exploitable dans une logique d’évaluation continue. Ces fichiers sont distribués via le rapport de progression de l'étudiant.

Une interface web dédiée permet aux enseignants de corriger les productions soit individuellement soit de manière transversale par question facilitant le traitement de grands volumes de réponses. Le mode de correction par question regroupe automatiquement les réponses similaires ce qui améliore la cohérence des évaluations tout en réduisant la charge de correction.

La correction étant chronophage, l’interface web de complétion a constitué une première étape de réduction de cette charge. Ensuite, nous avons ajouté des tests en R afin de comparer les résultats associés au code et les réponses aux choix multiples avec ceux attendus par les enseignants. Nous explorons actuellement l’utilisation d’un modèle de langage exécuté localement afin de produire des commentaires plus riches tout en préservant la confidentialité des données étudiantes.

Ce dispositif illustre comment l’évaluation continue de compétences complexes en science des données peut être mise en œuvre à grande échelle tout en garantissant la sécurité des épreuves, la traçabilité des apprentissages et la production de rétroactions individualisées.

Du matériel supplémentaire, notamment un questionnaire, un corrigé, ainsi que les rendus des apprenants sur Posit Connect, est disponible via le lien suivant : <https://go.sciviews.org/learnr_exam>.

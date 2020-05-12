_author: tclaudel_
# Introduction
Le projet consiste à mettre en place une infrastructure de différents services a l'aide de Kubernetes et de docker
# Notions
### Notions et concepts de base
* **noeuds** (serveurs) : physiques ou virtuels
	- master ou simple noeud d'exécution
* **pods** : pierre centrale de K8S
	 - ensemble cohérent de conteneurs
	 - un ou plusieurs conteneurs
	 - une instance de K8S
* **service** : abstraction des pods
	 - permet d'éviter la communication par ip (changeante car on est en conteneurs)
	 - service > ip/port > pods
	 - service = ip et port fixe
* **volumes**: persistents ou non
	 - lieux d'échanges entre pods
	 - intérieur de pods = non persistent
	 - extérieur = persistent
* **deployments** : objets de gestion des déploiments
	 - création/suppression
	 - scaling : gestion de paramètres pour la montée en charge (ou réduction)
* **namespaces** : cluster virtuel (ensemble de services)
	*  sous ensemble pour cloisonner dans K8S
# How it works
```sequence {theme="hand"}
kubmaster->nubnode
```
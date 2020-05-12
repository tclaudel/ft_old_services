_author: tclaudel_

- [Introduction](#Introduction)
- [Notions](#Notions)

# Introduction
### Kubernetes / K8S : origines
Kubernetes : grec timonier ou pilote (cf logo)
* Origine 2015 (1.0) : Google reverse à CNCF (Cloud Native Computing Foundation)
* CNCF : Amazon, Google, Huawei, Oracle, Docker, Citrix, eBay, Reddit, MasterCard...
* Google en 2014 : 2 milliards de conteneurs lancés par semaine
* raccourci : orchestrateur de conteneur (comme Swarm pour docker mais bien plus poussé)
* conteneurs : docker mais pas que (CoreOS...)
### Kubernetes : pourquoi ?
* pour orchestrer : comme swarm (lancement orchestré de multiples conteneurs)
* pour créer de l'abstraction avec la notion de service (plus en IP)
* pour apporter de la haute disponibilité (maintenir les conteneurs up)
* pour scaler : lancer de multiples instances en fonction de paramètres (à la main ou en automatique)
* peu importe le provider : vsphere (vmware), google cloud, aws, azure, bare metal (physique)
### Kubernetes : cluster ou minikube
* en mode démo/test : avec minikube
		- nécessité d'avoir virtualbox
		- image déployée automatiquement sur un vbox
* en mode cluster : un master et des noeuds esclave
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
	 - sous ensemble pour cloisonner dans K8S
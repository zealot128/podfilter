### 2014-02-24

* Podcast Kategorien: Nutzung der Itunes-Kategorien Liste und Angabe der Podcasts
* Sortierung nach Popularitaet moeglich
* Technisches: Jetzt Timeout nach 30s beim Fetchen, Turbolinks wieder aktiviert zum schnelleren Seitenaufbau

### 2014-01-20

* Responsiveness/Views/Layout ueberarbeitet
* internes Refaktoring: "Podcast" Modell mit verschiedenen Varianten (Sources)

### 2014-01-05 Bugfixes

* Source-Seite fix
* Merging von vielen gleichen Podcasts
* Anzahl Hoerer korrigiert

### 2013-12-17 Personal Recommendation feed & ignore list

* on Dashboard, user can see link to personal recommendation feed (with/out torrent-files)
* standard Ignore pseudo source collection for all users
* every source in ignore file that has user in common with somebody else decreases their similarity



### 2013-11-27 Facebook/G+ Login & Performance

* Login via Facebook + Google+
* various SQL optimizations, indices

### 2013-11-24 Twitter & Github Login

* Login via Twitter/Github
* Dashboard optimzation
* Some Caching
* OPML-File can have a name -> default name for upload and oauth-login


### 2013-11-23 Search & Merging

* Search Podcasts with filter for offline/inactive
* Merging for admin users -> podcasts of different formats or sources (mp3,aac,
  bitlove vs. feedburner, ..) can be merged and will be displayed as one in
  list
* OPML export/download from dashboard

### 2013-11-17 Launch, Recommendations, Indexing

* Initial Launch
* Feedparser/Entry updater
* Similarity

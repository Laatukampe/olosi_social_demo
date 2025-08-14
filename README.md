# OLOSI Social Demo

Tämä repositorio sisältää **OLOSI**‑sovelluksen sosiaalisen median demoversion. Demossa voit asettaa oman mielialan (MIELI), fyysisen olon (VOINTI) ja yksinäisyys‑/seuratilasi (SEURA) sekä tarkastella fiktiivisten kontaktien tiloja taulukkomaisessa näkymässä.

## Tärkeimmät ominaisuudet

* **Tilan asetusnäkymä:** Kolme korttia MIELI, VOINTI ja SEURA. Emojin painallus avaa valintaruudukon viidestä vaihtoehdosta; SEURA määritetään valitsemalla iso valintaruutu (yksinäinen/ei yksinäinen).
* **Yleisnäkymä:** Taulukko, jossa on 50 esimerkkikontaktia. Sarakkeet ovat NIMI, MIELI, VOINTI ja SEURA. Emojeita klikkaamalla voit päivittää kontaktien tiloja. Valinnat tallentuvat paikallisesti `SharedPreferences`‑tietokantaan.
* **Esteettömyys:** Suuret kosketusalueet, selitteet (Semantics) ja kontrastit noudattavat WCAG‑suosituksia. Emojin valinta ja valintaruudun vaihto antavat haptisen palautteen (tuettu Androidilla).
* **Riverpod‑tilanhallinta:** Sovelluksen tila on jaettu `contactsProvider`– ja `ContactsNotifier`–luokan kautta. Data kerroksessa on erotettu `ContactRepository` ja `LocalStore`, jolloin tallennustavan vaihtaminen (esim. Supabase/Firebase) onnistuu jatkossa helposti.

## Asennus ja käyttöönotto

1. **Kloonaa projekti ja asenna riippuvuudet**
   ```bash
   git clone https://github.com/Laatukampe/olosi_social_demo.git
   cd olosi_social_demo
   flutter pub get
   ```
2. **Aja sovellus webissä** (Codespaces/paikallinen):
   ```bash
   flutter run -d web-server --web-hostname 0.0.0.0 --web-port 5173
   ```
   Voit käyttää selainosoitetta `http://localhost:5173` testataksesi sovellusta.
3. **iOS/Android‑emulaattori:**
   *iOS*: Vaatii Macin ja Xcoden. Käynnistä simulaattori ja suorita:
   ```bash
   flutter run -d ios
   ```
   *Android*: Avaamalla AVD Managerista laitteen ja suorittamalla:
   ```bash
   flutter run -d android
   ```
4. **APK:n rakentaminen:** Projektin mukana on GitHub Actions ‑workflow, joka koostaa Android APK:n automaattisesti `main`‑haaran pushissa. Voit myös rakentaa APK:n paikallisesti:
   ```bash
   flutter build apk --release
   ```

## Päivittäminen vanhasta demosta

Jos sinulla on vanha **OLOSI**‑demo (esim. `olosi_app`‑repossa), voit päivittää projektin seuraavasti:

1. **Kopioi teemaa ja komponentteja**: Uusi teema sijaitsee `lib/core/theme.dart` ja korvaa vanhan `theme.dart`‑tiedoston. Uudet näkymät löytyvät `lib/features/status_set/` ja `lib/features/contacts_list/`. Kopioi nämä kansiot vanhaan projektiisi.
2. **Päivitä `pubspec.yaml`**: Lisää `flutter_riverpod`, `shared_preferences` ja `vibration` riippuvuuksiksi, sekä nosta Flutter‑version vaatimukset yhteensopiviksi (`environment.sdk`).
3. **Korvaa vanha kontaktilistanäkymä**: Vanhan sovelluksesi `contacts_list_page.dart` voidaan korvata uuden `contacts_list_page.dart` ja `contact_row.dart` (löytyy `lib/features/contacts_list/` kansiosta). Uudessa versiossa käytetään Grid‑tyylistä sarakejakoa ja jokainen solu on oma `Expanded`‑widgetinsä.
4. **Siirrä datakerros**: Korvaa vanha `data/local/local_store.dart` ja `data/repo/status_repository.dart` uuden `data/local/local_store.dart` ja `data/repo/contact_repository.dart` tiedostoilla. Nämä varmistavat, että kontaktit ja tilat tallennetaan JSON‑muodossa `SharedPreferences`‑muistiin.
5. **Käynnistä uudelleen**: Suorita `flutter pub get` ja käynnistä sovellus. Vanhan projektin konfiguraatiosta riippuen joudut ehkä poistamaan käyttöön otetut tiedostot (esim. vanhat näkymät) tai päivittämään reitityksen `main.dart` ja `app.dart` vastaamaan uusia widgetejä.

## Lisenssi

Tämä demoprojekti on tarkoitettu opetuskäyttöön eikä sisällä kaupallista lisenssiä. Käyttö tapahtuu omalla vastuulla.
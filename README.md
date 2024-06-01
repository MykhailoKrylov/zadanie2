## Zadanie 2

##### Dodawanie workflow do repozytorium 

![image](https://github.com/MykhailoKrylov/zadanie2/assets/134151663/1f1db3e1-738c-4f81-abfd-9a2f172046cd)


##### Podczas próby uruchomienia workflow pojawia się błąd:
![image](https://github.com/MykhailoKrylov/zadanie2/assets/134151663/419abb76-97fa-4123-8167-cdab305e300c)

Próbuję naprawić błąd, dodając zmienną z małymi literami 

![image](https://github.com/MykhailoKrylov/zadanie2/assets/134151663/6c450265-1b4b-4550-b208-74998166c61b)

Nie udało się naprawić błędu. Musiałem zmienić nazwę konta 

W ten sposób sprawdziłem, czy obraz zawiera zagrożenia sklasyfikowane jako krytyczne lub wysokie:
```

      - name: Check CVE Scan Results
        run: |
          cve_scan_results=$(jq '.[] | select(.severity == "HIGH" or .severity == "CRITICAL")' <<< '${{ steps.scan.outputs.result }}')
          if [ -n "$cve_scan_results" ]; then
            echo "Critical or High severity CVEs found, stopping the workflow."
            exit 1
          fi
        shell: bash
```
Ten etap uruchamia skrypt shell, który używa jq do filtrowania wyników skanowania CVE pod kątem wszelkich luk o stopniu „HIGH” lub „CRITICAL”.
Jeśli takie luki zostaną znalezione, skrypt wypisuje komunikat i kończy działanie z niezerowym statusem, zatrzymując przepływ pracy.
Jeśli nie zostaną znalezione żadne wysokie lub krytyczne luki, przepływ pracy jest kontynuowany, umożliwiając przesłanie obrazu Docker do GHCR.

Udało się 
![image](https://github.com/mykhailokrylov/zadanie2/assets/134151663/66631a93-5d11-4f6c-b800-f199c4c002c2)

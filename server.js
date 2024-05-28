const http = require("http");
const satelize = require("satelize"); // biblioteka do pobierania informacji o lokalizacji na podstawie adresu IP

const port = 3000;

const server = http.createServer((req, res) => {
  const clientIp = req.connection.remoteAddress;

  let timeZone = "Europe/Warsaw"; // Domyślna strefa czasowa

  // Sprawdzenie czy adres IP jest lokalny
  if (clientIp !== "::ffff:172.17.0.1" && clientIp !== "127.0.0.1") {
    satelize.satelize({ ip: clientIp }, function (err, geoData) {
      if (err || !geoData) {
        console.log(err);
        return;
      }
      timeZone = geoData.timezone;
    });
  }

  const date = new Date().toLocaleString("pl-PL", {
    timeZone: timeZone,
  });

  res.setHeader("Content-Type", "text/html");
  res.end(`<p>Adres IP: ${clientIp}</p><p>Data i godzina: ${date}</p>`);
});

server.listen(port, () => {
  const startupDate = new Date();
  console.log(
    `Start serwera:${startupDate} \n Autor: Mykhailo Krylov \n Na porcie: ${port}`
  );
});

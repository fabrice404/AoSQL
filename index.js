const fs = require('fs');
const path = require('path');
const { Connection } = require('postgrejs');
const { format } = require('sql-formatter');

const formatterConfig = {
  dataTypeCase: "upper",
  functionCase: "upper",
  keywordCase: "upper",
  dialect: "postgresql",
  language: "postgresql",
  expressionWidth: 200,
  useTabs: false,
  tabWitdth: 2,
}

const separator = '\n------------------------------------\n';
const today = new Date();
let year = today.getFullYear().toString();
let day = today.getDate().toString();

if (today.getMonth() < 11) {
  day = '1';
}

if (process.argv.length > 2) {
  const argDate = process.argv[2].split(/\//gi);
  if (argDate.length === 2) {
    [year, day] = process.argv[2].split(/\//gi);
  } else if (argDate.length === 1) {
    [day] = argDate;
  }
}

year = year.padStart(4, '0');
day = day.padStart(2, '0');

const readFile = (path) => {
  if (!fs.existsSync(path)) {
    fs.writeFileSync(path, '');
  }
  return fs.readFileSync(path, 'utf-8');
}

const main = async () => {
  const dayName = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'][new Date(Number(year), 11, Number(day)).getDay()];
  const date = `${dayName} ${year}-12-${day}`;
  console.log(`\n${date}`);
  console.log(separator);

  const connection = new Connection({
    host: 'localhost',
    port: 5432,
    user: 'aosql',
    password: 'aosql',
    database: 'santa_workshop',
  });
  await connection.connect();

  const nodemonInitFile = path.join(__dirname, '.nodemon.start');
  if (fs.existsSync(nodemonInitFile)) {
    const dbInitFile = path.join(__dirname, 'import', `advent_of_sql_day_${+day}.sql`);
    if (!fs.existsSync(dbInitFile)) {
      console.log(`Please download the import file, put it in ${dbInitFile} and restart the app!`);
      process.exit(1);
    }

    const queries = fs.readFileSync(dbInitFile, 'utf-8').trim().split(';').filter(Boolean);
    console.log("Initializing database...");
    for (const query of queries) {
      const result = await connection.query(query);
      console.log(result);
    }
    console.log("Database intialized!");
    fs.rmSync(nodemonInitFile);
    console.log(separator);
  }

  const challengeFile = path.join(__dirname, 'challenges', `${day}.sql`);
  const query = readFile(challengeFile);
  if (query) {
    const formatted = format(query, formatterConfig);
    if (formatted !== query) {
      fs.writeFileSync(challengeFile, formatted);
    }

    const result = await connection.query(query);
    console.log(
      result.rows.map((row) => row.join(',')).join('\n')
    );
  }
  console.log(separator);
}

main();

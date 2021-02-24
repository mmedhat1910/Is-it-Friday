const app = require('express')();
const fs = require('fs');

const PORT = process.env.PORT || 3000;

app.get('/', (req, res) => {
	res.send('Hello');
});
app.get('/count', async (req, res) => {
	const data = loadCount();
	count = data[0].count;
	count++;
	data[0] = { count };
	saveCount(data);
	res.send(data);
});

const saveCount = (count) => {
	const JSONData = JSON.stringify(count);
	fs.writeFileSync('count.json', JSONData);
	console.log('Saved');
};
const loadCount = () => {
	try {
		const dataBuffer = fs.readFileSync('count.json');
		const JSONData = dataBuffer.toString();
		return JSON.parse(JSONData);
	} catch (e) {
		return [];
	}
};
app.listen(PORT, () => console.log('Running on port ' + PORT));

const quantity = Math.round(Math.random() * (20 - 1) + 1);

const arrays = {
  P: [],
  S: [],
  T: [],
};

console.log(quantity + ' objetos');

const randomDestiny = () => ['P', 'S', 'T'][Math.round(Math.random() * 2)];

for (let i = 0; i < quantity; i++) {
  const destiny = randomDestiny();
  const weight = Math.round(Math.random() * (15 - 1) + 1);
  arrays[destiny].push(weight);
  console.log(`\x1b[36m ${weight} \x1b[0m\x1b[31m ${destiny} \x1b[0m`);
}

Object.entries(arrays).forEach(([key, value]) => {
  console.log(
    key,
    value.sort((a, b) => b - a)
  );
});

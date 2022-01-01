import { loginUser } from "../user/login";
import { fetchFromAPI } from "../utils";

const tags = [
  { name: "recipe", emoji: "👨‍🍳", description: "Any kind of recipe" },
  { name: "cake", emoji: "🎂", description: "Any kind of cake" },
  { name: "chocolate", emoji: "🍫", description: "Any kind of chocolate" },
  { name: "fast-food", emoji: "🍔", description: "Any find of fast food" },
  { name: "sweet", emoji: "🍬", description: "Any kind of sweets" },
  { name: "salad", emoji: "🥗", description: "Any kind of diet food" },
  { name: "non-veg", emoji: "🍗", description: "Any kind of non veg" },
  { name: "high-protein", emoji: "🥚", description: "High protein food" },
  { name: "movie-snack", emoji: "🍿", description: "Snacks for movies" },
  { name: "lunch", emoji: "🍱", description: "Any find of lunch" },
  { name: "sushi", emoji: "🍣", description: "Any find of sushi" },
  { name: "dairy", emoji: "🥛", description: "Any find of dairy" },
  { name: "sea-food", emoji: "🦞", description: "Any find of sea food" },
  { name: "ice-cream", emoji: "🍦", description: "Any find of ice creams" },
  { name: "snack", emoji: "🌮", description: "Any kind of snacks" },
  { name: "fruits", emoji: "🍎", description: "Any kind of healty fruit" },
  {
    name: "green-veggies",
    emoji: "🥦",
    description: "Any find of healty vegetable",
  },
  {
    name: "drinks",
    emoji: "🧃",
    description: "Soft drinks and juice and plant drinks",
  },
  { name: "breakfast", emoji: "🥪", description: "Any find of breakfast" },
  { name: "dinner", emoji: "🥘", description: "Any find of dinner" },
  {
    name: "kitchen",
    emoji: "🔪",
    description: "Any kind of kitchen product",
  },
  {
    name: "coffee",
    emoji: "☕",
    description: "Any kind of caffeine",
  },
];

const createTags = async (data: typeof tags) => {
  const user = await loginUser("james@gmail.com");

  for (let i = 0; i < data.length; i++) {
    const response = await fetchFromAPI(`/tag/${user.user.id}`, {
      method: "POST",
      data: data[i],
      token: user.token,
    });

    console.log(response[0].data.msg);
  }
};

createTags(tags);

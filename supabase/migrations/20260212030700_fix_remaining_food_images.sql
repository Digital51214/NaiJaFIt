-- Fix remaining food images with corrected food name matching
-- This addresses spelling variations and case sensitivity issues

-- Foods that were missing due to spelling variations
UPDATE foods
SET image_url = 'https://www.9jafoodie.com/wp-content/uploads/2017/05/Owho-Soup-1030x1030.jpg'
WHERE "FoodName" ILIKE 'Owoho Soup' OR "FoodName" ILIKE 'Owho Soup';

UPDATE foods
SET image_url = 'https://sisijemimah.com/wp-content/uploads/2020/06/Akara-and-Pap-5.jpg'
WHERE "FoodName" ILIKE 'Wake' OR "FoodName" ILIKE 'Akamu' OR "FoodName" ILIKE 'Pap';

-- Ensure case-insensitive matching for all major foods
UPDATE foods
SET image_url = 'https://sisimiami.com/photos/jollof-rice-9.jpg'
WHERE "FoodName" ILIKE 'Jollof Rice' AND (image_url IS NULL OR image_url = '');

UPDATE foods
SET image_url = 'https://sistersolitaire.co.za/wp-content/uploads/2020/09/Fried-rice-1-683x1024.jpg'
WHERE "FoodName" ILIKE 'Fried Rice' AND (image_url IS NULL OR image_url = '');

UPDATE foods
SET image_url = 'https://realfood.tesco.com/media/images/1400x919-white-rice-LH-612f6ebb-2682-4df8-a8e6-b31d85b54e6c-0-1400x919.jpg'
WHERE "FoodName" ILIKE 'White Rice' AND (image_url IS NULL OR image_url = '');

UPDATE foods
SET image_url = 'https://cheflolaskitchen.com/wp-content/uploads/2018/12/Nigerian-Eba-Garri-How-to-make-swallow-eba-garri-flour-and-water-Nigerian-food-african-swallow-768x512.jpg'
WHERE "FoodName" ILIKE 'Eba' AND (image_url IS NULL OR image_url = '');

UPDATE foods
SET image_url = 'https://cheflolaskitchen.com/wp-content/uploads/2019/01/Pounded-Yam-768x512.jpg'
WHERE "FoodName" ILIKE 'Pounded Yam' AND (image_url IS NULL OR image_url = '');

UPDATE foods
SET image_url = 'https://babystepsnutrition.com/wp-content/uploads/2021/02/PXL_20210224_200330875-scaled.jpg'
WHERE "FoodName" ILIKE 'Fufu' AND (image_url IS NULL OR image_url = '');

UPDATE foods
SET image_url = 'https://www.thecookingworld.ng/wp-content/uploads/2021/04/IMG_8141-1024x768.jpg'
WHERE "FoodName" ILIKE 'Amala' AND (image_url IS NULL OR image_url = '');

UPDATE foods
SET image_url = 'https://www.9jafoodie.com/wp-content/uploads/2018/07/How-to-cook-Egusi-soup.jpg'
WHERE "FoodName" ILIKE 'Egusi Soup' AND (image_url IS NULL OR image_url = '');

UPDATE foods
SET image_url = 'https://www.9jafoodie.com/wp-content/uploads/2018/03/Efo-Riro-1030x1030.jpg'
WHERE "FoodName" ILIKE 'Efo Riro' AND (image_url IS NULL OR image_url = '');

UPDATE foods
SET image_url = 'https://www.9jafoodie.com/wp-content/uploads/2017/08/Okra-Soup-1030x1030.jpg'
WHERE "FoodName" ILIKE 'Okra Soup' AND (image_url IS NULL OR image_url = '');

UPDATE foods
SET image_url = 'https://www.9jafoodie.com/wp-content/uploads/2017/09/Ogbono-Soup-1030x1030.jpg'
WHERE "FoodName" ILIKE 'Ogbono Soup' AND (image_url IS NULL OR image_url = '');

UPDATE foods
SET image_url = 'https://thumbor.thedailymeal.com/nqZdXWuv9zlLJkWLngx5HqlTXJw=/0x0:1920x1080/filters:format(webp)/https://www.thedailymeal.com/sites/default/files/story/2019/fried-plantain-xl-blog0217_0.jpg'
WHERE "FoodName" ILIKE 'Fried Plantain' AND (image_url IS NULL OR image_url = '');

UPDATE foods
SET image_url = 'https://thumbor.thedailymeal.com/conditional-1920x1080/filters:format(webp)/https://www.thedailymeal.com/img/gallery/boiled-plantain-recipe/l-intro-1687964751.jpg'
WHERE "FoodName" ILIKE 'Boiled Plantain' AND (image_url IS NULL OR image_url = '');

UPDATE foods
SET image_url = 'https://www.9jafoodie.com/wp-content/uploads/2016/08/Moi-Moi-e1472682838908-1030x1030.jpg'
WHERE ("FoodName" ILIKE 'Moi Moi' OR "FoodName" ILIKE 'Moin Moin') AND (image_url IS NULL OR image_url = '');

UPDATE foods
SET image_url = 'https://www.allnigerianrecipes.com/food/pictures/akara-feature.jpg'
WHERE "FoodName" ILIKE 'Akara' AND (image_url IS NULL OR image_url = '');

UPDATE foods
SET image_url = 'https://www.allnigerianrecipes.com/food/pictures/suya-recipe.jpg'
WHERE "FoodName" ILIKE 'Suya' AND (image_url IS NULL OR image_url = '');

UPDATE foods
SET image_url = 'https://cheflolaskitchen.com/wp-content/uploads/2018/12/Jollof-Spaghetti-Pasta-Nigerian-style-768x512.jpg'
WHERE "FoodName" ILIKE 'Jollof Spaghetti' AND (image_url IS NULL OR image_url = '');

UPDATE foods
SET image_url = 'https://bukkas.co.za/wp-content/uploads/2017/07/puffpuff.png'
WHERE "FoodName" ILIKE 'Puff Puff' AND (image_url IS NULL OR image_url = '');

UPDATE foods
SET image_url = 'https://www.9jafoodie.com/wp-content/uploads/2016/08/Nigerian-Chicken-Stew-1030x1030.jpg'
WHERE "FoodName" ILIKE 'Chicken%Nigerian%' AND (image_url IS NULL OR image_url = '');

-- Verify the updates
SELECT 
  "FoodName",
  CASE 
    WHEN image_url IS NOT NULL AND image_url != '' THEN 'Has Image'
    ELSE 'Missing Image'
  END as image_status
FROM foods
ORDER BY image_status, "FoodName";
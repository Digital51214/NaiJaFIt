-- Add image_url column to foods table
ALTER TABLE public.foods 
ADD COLUMN IF NOT EXISTS image_url TEXT;

-- Create public bucket for food images
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
    'food-images',
    'food-images',
    true,  -- PUBLIC bucket for food images
    10485760, -- 10MB limit
    ARRAY['image/jpeg', 'image/jpg', 'image/png', 'image/webp']
)
ON CONFLICT (id) DO NOTHING;

-- RLS Policy: Anyone can view food images (public read)
CREATE POLICY "public_read_food_images" ON storage.objects
FOR SELECT TO public
USING (bucket_id = 'food-images');

-- RLS Policy: Authenticated users can upload food images
CREATE POLICY "authenticated_upload_food_images" ON storage.objects
FOR INSERT TO authenticated
WITH CHECK (bucket_id = 'food-images');

-- RLS Policy: Authenticated users can update their uploaded food images
CREATE POLICY "authenticated_update_food_images" ON storage.objects
FOR UPDATE TO authenticated
USING (bucket_id = 'food-images' AND owner = auth.uid())
WITH CHECK (bucket_id = 'food-images' AND owner = auth.uid());

-- RLS Policy: Authenticated users can delete their uploaded food images
CREATE POLICY "authenticated_delete_food_images" ON storage.objects
FOR DELETE TO authenticated
USING (bucket_id = 'food-images' AND owner = auth.uid());
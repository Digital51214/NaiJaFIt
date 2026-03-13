-- Enable RLS on foods table if not already enabled
ALTER TABLE public.foods ENABLE ROW LEVEL SECURITY;

-- Drop existing policy if it exists
DROP POLICY IF EXISTS "public_read_foods" ON public.foods;

-- Create policy allowing anyone to read foods (public access)
CREATE POLICY "public_read_foods" 
ON public.foods
FOR SELECT 
TO public 
USING (true);

-- Optional: Allow authenticated users to manage foods
DROP POLICY IF EXISTS "authenticated_manage_foods" ON public.foods;
CREATE POLICY "authenticated_manage_foods" 
ON public.foods
FOR ALL 
TO authenticated
USING (true)
WITH CHECK (true);
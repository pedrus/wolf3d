
extern vec2 player_pos = vec2(0.0, 0.0);
extern float player_ang = 0.0;
extern float plane_size = 0.0;

vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
{
	float p_ang = player_ang;
	float p_size = plane_size;
	float camera_x = 2 * screen_coords[0] / 800 - 1;
	vec2 ray_dir;
	vec2 player_dir; 
	vec2 plane;

	player_dir[0] = cos(player_ang);
	player_dir[1] = sin(player_ang);
	plane[0] = -plane_size * sin(player_ang);
	plane[1] = plane_size * cos(player_ang);
	ray_dir[0] = player_dir[0] + plane[0] * camera_x;
	ray_dir[1] = player_dir[1] + plane[1] * camera_x;

	int mapX = int(player_pos[0]);
	int mapY = int(player_pos[1]);

	float sideDistX = 0;
	float sideDistY = 0;

	float deltaDistX = sqrt(1 + (ray_dir[1] * ray_dir[1]) / (ray_dir[0] * ray_dir[0]));
	float deltaDistY = sqrt(1 + (ray_dir[0] * ray_dir[0]) / (ray_dir[1] * ray_dir[1]));
	float perpWallDist = 0;

	int stepX = 0;
	int stepY = 0;

	int hit = 0;
	int side = 0;

	if (ray_dir[0] < 0)
	{
		stepX = -1;
		sideDistX = (player_pos[0] - mapX) * deltaDistX;
	}
	else
	{
		stepX = 1;
		sideDistX = (mapX + 1.0 - player_pos[0]) * deltaDistX;
	}
	if (ray_dir[1] < 0)
	{
		stepY = -1;
		sideDistY = (player_pos[1] - mapY) * deltaDistY;
	}
	else
	{
		stepY = 1;
		sideDistY = (mapY + 1.0 - player_pos[1]) * deltaDistY;
	}

	return color;
}
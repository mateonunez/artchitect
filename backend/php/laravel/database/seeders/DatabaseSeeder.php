<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Database\Seeders\MoodSeeder;
use Database\Seeders\TourSeeder;
use Database\Seeders\UserSeeder;
use Database\Seeders\TravelSeeder;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     *
     * @return void
     */
    public function run()
    {
        $this->call([
            UserSeeder::class,
        ]);
    }
}

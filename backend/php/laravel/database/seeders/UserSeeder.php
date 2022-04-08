<?php

namespace Database\Seeders;

use App\Models\Role;
use App\Models\User;
use Carbon\Carbon;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class UserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $payloadAdmin = [
            'name' => 'God',
            'email' => 'god@architect.com',
            'password' => Hash::make('architect'),
            'email_verified_at' => Carbon::now()
        ];

        User::create($payloadAdmin);
    }
}

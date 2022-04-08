<?php

namespace Tests;

use App\Models\Role;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\TestCase as BaseTestCase;
use Illuminate\Support\Facades\Hash;
use Laravel\Passport\Passport;

abstract class TestCase extends BaseTestCase
{
    use CreatesApplication, RefreshDatabase;

    /**
     * Initial setup for tests.
     *
     * @return void
     */
    public function setUp(): void
    {
        if (!$this->app) {
            $this->refreshApplication();
        }

        $this->refreshDatabase();
    }

    /**
     * Return user headers for API requests.
     *
     * @return void
     */
    protected function actingAsUser(): void
    {
        $user = User::factory()->create();

        Passport::actingAs($user);
    }
}

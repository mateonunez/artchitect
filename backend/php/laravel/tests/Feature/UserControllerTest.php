<?php

namespace Tests\Feature;

use Tests\TestCase;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;

class UserControllerTest extends TestCase
{
    use RefreshDatabase;

    /**
     * @return void
     */
    public function setUp(): void
    {
        parent::setUp();

        $this->actingAsUser();
    }

    /** @group user_controller */
    public function testStore()
    {
        $payload = [
            'name' => 'Test',
            'email' => 'test@example.com',
            'password' => bcrypt('test'),
        ];

        $response = $this->post('/api/users', $payload);

        $response->assertStatus(201);
        $response->assertSeeText('data');
    }

    /** @group user_controller */
    public function test_index()
    {
        User::factory()->count(10)->create();

        $response = $this->get('/api/users');

        $response->assertStatus(200);
        $response->assertSeeText('data');
    }

    /** @group user_controller */
    public function testShow()
    {
        $user = User::factory()->create();

        $response = $this->get('/api/users/' . $user->id);

        $response->assertStatus(200);
        $response->assertSeeText('data');
    }

    /** @group user_controller */
    public function testUpdatePut()
    {
        $user = User::factory()->create();

        $newUserName = 'Test PUT update';

        $payload = [
            'name' => $newUserName,
            'email' => $user->email,
            'password' => $user->password
        ];

        $response = $this->put('/api/users/' . $user->id, $payload);

        $response->assertStatus(200);
        $response->assertSeeText('data');
        $response->assertSeeText($newUserName);
    }

    /** @group user_controller */
    public function testUpdatePatch()
    {
        $user = User::factory()->create();

        $newUserName = 'Test PATCH update';

        $payload = [
            'name' => $newUserName,
        ];

        $response = $this->patch('/api/users/' . $user->id, $payload);

        $response->assertStatus(200);
        $response->assertSeeText('data');
        $response->assertSeeText($newUserName);
    }

    /** @group user_controller */
    public function testDelete()
    {
        $user = User::factory()->create();

        $response = $this->delete('/api/users/' . $user->id);

        $response->assertStatus(200);
    }

    /** @group user_controller */
    public function testCreateWithTheSameEmail()
    {
        $user = User::factory()->create();

        $response = $this->delete('/api/users/' . $user->id);
        $response->assertStatus(200);

        $payload = [
            'name' => 'Test',
            'email' => $user->email,
            'password' => bcrypt('test'),
        ];

        $response = $this->post('/api/users', $payload);

        $response->assertStatus(201);
        $response->assertSeeText('data');
        $response->assertSeeText($user->email);
    }
}

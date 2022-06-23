<?php

namespace App\Providers;

use App\Models\User;
use App\Events\UserLoggedIn;
use App\Events\UserRegistered;
use App\Observers\UserObserver;
use App\Jobs\SendUserLoggedInToBroker;
use App\Jobs\SendUserRegisteredToBroker;
use Illuminate\Foundation\Support\Providers\EventServiceProvider as ServiceProvider;

class EventServiceProvider extends ServiceProvider
{
    /**
     * The event listener mappings for the application.
     *
     * @var array<class-string, array<int, class-string>>
     */
    protected $listen = [
        UserLoggedIn::class => [
            SendUserLoggedInToBroker::class,
        ],
        UserRegistered::class => [
            SendUserRegisteredToBroker::class,
        ],
    ];

    /**
     * Register any events for your application.
     *
     * @return void
     */
    public function boot()
    {
        parent::boot();

        User::observe(UserObserver::class);
    }

    /**
     * Determine if events and listeners should be automatically discovered.
     *
     * @return bool
     */
    public function shouldDiscoverEvents()
    {
        return false;
    }
}

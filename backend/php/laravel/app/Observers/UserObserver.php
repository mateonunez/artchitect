<?php

namespace App\Observers;

use App\Models\User;

class UserObserver
{
    /**
     * Handle the User "deleted" event. Preventing duplicates email after deletion.
     *
     * @param  \App\Models\User  $user
     * @return void
     */
    public function deleted(User $user)
    {
        $user->update([
            'email' => time() . '::' . $user->email
        ]);
    }
}

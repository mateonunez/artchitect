<?php

namespace App\Console\Commands;

use Dotenv\Dotenv;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Artisan;

class PrepareEnv extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'prepare:env {--T|testing}';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Prepare the env after the first installation';

    /**
     * Create a new command instance.
     *
     * @return void
     */
    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Execute the console command.
     *
     * @return int
     */
    public function handle()
    {
        // ! Testing is doesn't working as expected
        $testing = $this->option('testing');

        // Checking for env file
        $this->info('Checking for Env file');

        $resultEnv = $this->copyEnvFile($testing);
        $resultEnv
            ? $this->info('Env file copied')
            : $this->info('Env file not copied');

        // Generating application key
        $applicationKeyExists = $this->applicationKeyExists($testing);

        $generate = false;
        if ($applicationKeyExists) {
            $answer = $this->ask('Application Key is already defined, do you want to overwrite it? [y/N]');
            $generate = strtolower($answer) === 'y';
        }

        if ($generate) {
            $resultKey = $this->generateApplicationKey($testing);
            $this->info($resultKey);
        }

        // Checking for migrations
        $resultMigrations = $this->runMigrations($testing);
        $this->info($resultMigrations);

        // Installing passport
        $resultPassport = $this->installPassport($testing);
        $this->info($resultPassport);

        // Running Seeders
        $resultSeeders = $this->runSeeders($testing);
        $this->info($resultSeeders);

        return 0;
    }

    /**
     * Checking for .env file
     *
     * @param bool $testing
     * @return bool
     */
    public function copyEnvFile($testing)
    {
        $env = $testing ? '.env.testing' : '.env';
        $envRealpath = base_path() . DIRECTORY_SEPARATOR . $env;

        $envExample = $testing ? '.env.testing.example' : '.env.example';
        $envExampleRealpath = base_path() . DIRECTORY_SEPARATOR . $envExample;

        if (File::exists($envRealpath)) {
            return false;
        }

        File::copy($envExampleRealpath, $envRealpath);

        return true;
    }

    /**
     * Checks if application key is already present
     *
     * @param bool $testing
     * @return bool
     */
    public function applicationKeyExists($testing)
    {
        $env = $testing ? '.env.testing' : '.env';
        $envRealpath = base_path() . DIRECTORY_SEPARATOR . $env;

        $envParsed = Dotenv::parse(file_get_contents($envRealpath));

        return !empty($envParsed['APP_KEY']);
    }

    /**
     * Generates the application key
     *
     * @param bool $testing
     * @return string
     */
    public function generateApplicationKey($testing)
    {
        $keyGenerateCommand = 'key:generate' . ($testing ? ' --env=testing' : '');
        Artisan::call($keyGenerateCommand);

        return trim(Artisan::output());
    }

    /**
     * Runs the migrations
     *
     * @param bool $testing
     * @return string
     */
    public function runMigrations($testing)
    {
        $keyGenerateCommand = 'migrate:fresh' . ($testing ? ' --env=testing' : '');
        Artisan::call($keyGenerateCommand, [], $this->getOutput());

        return trim(Artisan::output());
    }

    /**
     * Installs Passport
     *
     * @param bool $testing
     * @return string
     */
    public function installPassport($testing)
    {
        $passportInstallCommand = 'passport:install --uuids' . ($testing ? ' --env=testing' : '');
        Artisan::call($passportInstallCommand, [], $this->getOutput());

        $keyGenerateCommand = 'key:generate --force' . ($testing ? ' --env=testing' : '');
        Artisan::call($keyGenerateCommand, [], $this->getOutput());

        return trim(Artisan::output());
    }

    /**
     * Runs the seeders
     *
     * @param bool $testing
     * @return string
     */
    public function runSeeders($testing)
    {
        $keyGenerateCommand = 'db:seed' . ($testing ? ' --env=testing' : '');
        Artisan::call($keyGenerateCommand, [], $this->getOutput());

        return trim(Artisan::output());
    }
}

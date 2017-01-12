use strict;
use warnings;
use Test::More;

BEGIN {
    use_ok('Moonshine::Bootstrap');
}

subtest "build" => sub {
    my $class = Moonshine::Bootstrap->new();

    component_test(
        {
            class  => $class,
            action => 'progress_bar',
            args   => { aria_valuenow => '60' },
            expected =>
'<div class="progress-bar" style="min-width:3em; width:60%;" aria-valuemax="100" aria-valuemin="0" aria-valuenow="60" role="progressbar"><span class="sr-only">60%</span></div>',
        }
    );

    component_test(
        {
            class  => $class,
            action => 'progress_bar',
            args   => { aria_valuenow => '60', show => 1 },
            expected =>
'<div class="progress-bar" style="min-width:3em; width:60%;" aria-valuemax="100" aria-valuemin="0" aria-valuenow="60" role="progressbar">60%</div>',
        }
    );

    component_test(
        {
            class  => $class,
            action => 'progress_bar',
            args   => { aria_valuenow => '60', show => 1, switch => 'success' },
            expected =>
'<div class="progress-bar progress-bar-success" style="min-width:3em; width:60%;" aria-valuemax="100" aria-valuemin="0" aria-valuenow="60" role="progressbar">60%</div>',
        }
    );

    component_test(
        {
            class  => $class,
            action => 'progress_bar',
            args   => { aria_valuenow => '60', show => 1, switch => 'info' },
            expected =>
'<div class="progress-bar progress-bar-info" style="min-width:3em; width:60%;" aria-valuemax="100" aria-valuemin="0" aria-valuenow="60" role="progressbar">60%</div>',
        }
    );

    component_test(
        {
            class  => $class,
            action => 'progress_bar',
            args   => { aria_valuenow => '60', show => 1, switch => 'warning' },
            expected =>
'<div class="progress-bar progress-bar-warning" style="min-width:3em; width:60%;" aria-valuemax="100" aria-valuemin="0" aria-valuenow="60" role="progressbar">60%</div>',
        }
    );

    component_test(
        {
            class  => $class,
            action => 'progress_bar',
            args   => { aria_valuenow => '60', show => 1, switch => 'danger' },
            expected =>
'<div class="progress-bar progress-bar-danger" style="min-width:3em; width:60%;" aria-valuemax="100" aria-valuemin="0" aria-valuenow="60" role="progressbar">60%</div>',
        }
    );

    component_test(
        {
            class  => $class,
            action => 'progress_bar',
            args   => {
                aria_valuenow => '60',
                show          => 1,
                switch        => 'danger',
                striped       => 1
            },
            expected =>
'<div class="progress-bar progress-bar-danger progress-bar-striped" style="min-width:3em; width:60%;" aria-valuemax="100" aria-valuemin="0" aria-valuenow="60" role="progressbar">60%</div>',
        }
    );

    component_test(
        {
            class  => $class,
            action => 'progress_bar',
            args   => {
                aria_valuenow => '60',
                show          => 1,
                switch        => 'danger',
                striped       => 1,
                animated      => 1,
            },
            expected =>
'<div class="progress-bar progress-bar-danger progress-bar-striped active" style="min-width:3em; width:60%;" aria-valuemax="100" aria-valuemin="0" aria-valuenow="60" role="progressbar">60%</div>',
        }
    );


    component_test(
        {
            class    => $class,
            action   => 'progress',
            args     => {},
            expected => '<div class="progress"></div>',
        }
    );

    component_test(
        {
            class  => $class,
            action => 'progress',
            args   => { bar => { aria_valuenow => '60' } },
            expected =>
'<div class="progress"><div class="progress-bar" style="min-width:3em; width:60%;" aria-valuemax="100" aria-valuemin="0" aria-valuenow="60" role="progressbar"><span class="sr-only">60%</span></div></div>',
        }
    );

    component_test(
        {
            class  => $class,
            action => 'progress',
            args   => { stacked => [
				{ aria_valuenow => '35', show => 1, switch => 'success' },
				{ aria_valuenow => '20', striped => 1 },
				{ aria_valuenow => '10', switch => 'danger' },
			]},
            expected =>
'<div class="progress"><div class="progress-bar progress-bar-success" style="min-width:3em; width:35%;" aria-valuemax="100" aria-valuemin="0" aria-valuenow="35" role="progressbar">35%</div><div class="progress-bar progress-bar-striped" style="min-width:3em; width:20%;" aria-valuemax="100" aria-valuemin="0" aria-valuenow="20" role="progressbar"><span class="sr-only">20%</span></div><div class="progress-bar progress-bar-danger" style="min-width:3em; width:10%;" aria-valuemax="100" aria-valuemin="0" aria-valuenow="10" role="progressbar"><span class="sr-only">10%</span></div></div>'
		}
	);


};

sub component_test {
    my $args = shift;

    my $action = $args->{action};
    my $element = $args->{class}->$action( $args->{args} // {} );
    return is( $element->render, $args->{expected},
        "got expected $args->{expected}" );
}

done_testing();

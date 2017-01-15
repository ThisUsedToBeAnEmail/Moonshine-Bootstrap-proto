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
            class    => $class,
            action   => 'row',
            args     => {},
            expected => '<div class="row"></div>'
        }
    );

    component_test(
        {
            class    => $class,
            action   => 'col',
            args     => { md => 6 },
            expected => '<div class="col-md-6"></div>'
        }
    );

    component_test(
        {
            class    => $class,
            action   => 'col',
            args     => { xs => 6 },
            expected => '<div class="col-xs-6"></div>'
        }
    );

    component_test(
        {
            class    => $class,
            action   => 'col',
            args     => { sm => 6 },
            expected => '<div class="col-sm-6"></div>'
        }
    );

    component_test(
        {
            class    => $class,
            action   => 'col',
            args     => { xs => 6, md => 6, sm => 6 },
            expected => '<div class="col-xs-6 col-sm-6 col-md-6"></div>'
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

sub dead_test {
    my $args = shift;

    my $action = $args->{action};
    eval { $args->{class}->$action( $args->{args} // {} ) };
    my $error = $@;
    return like( $error, $args->{expected}, "got expected $args->{expected}" );
}

done_testing();

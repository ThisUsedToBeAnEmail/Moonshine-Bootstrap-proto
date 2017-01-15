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

use strict;
use warnings;
use Test::More;

BEGIN {
    use_ok('Moonshine::Bootstrap');
}

subtest "build" => sub {
    my $class = Moonshine::Bootstrap->new();
    
    component_test({
        class => $class,
        action => 'link_image',
        args => {
            img => {
                alt => 'Brand',
                src => 'some.src',
            },
            href => 'some.url',
        },
        expected => '<a class="navbar-brand" href="some.url"><img alt="Brand" src="some.src"></img></a>'
	});

};

sub component_test {
    my $args = shift;

    my $action = $args->{action};
    my $element = $args->{class}->$action($args->{args} // {});
    return is($element->render, $args->{expected}, "got expected $args->{expected}");
}

done_testing();

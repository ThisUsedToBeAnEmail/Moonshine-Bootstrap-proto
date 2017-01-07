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
        action => 'input_group',
        args => {
			mid => 'basic-addon1',
			input => {
                placeholder => 'Username',
			},
            left => {
				data => q(@),
			},
        },
        expected => '<div class="input-group"><span class="input-group-addon" id="basic-addon1">@</span><input class="form-control" placeholder="Username" type="text" aria-describedby="basic-addon1"></input></div>',
    });

    component_test({
        class => $class,
        action => 'input_group',
        args => {
			mid => 'basic-addon1',
			input => {
                placeholder => 'Username',
			},
            right => {
				data => q(@),
			},
        },
        expected => '<div class="input-group"><input class="form-control" placeholder="Username" type="text" aria-describedby="basic-addon1"></input><span class="input-group-addon" id="basic-addon1">@</span></div>',
    });

    component_test({
        class => $class,
        action => 'input_group',
        args => {
			mid => 'basic-addon1',
            sizing => 'lg',
			input => {
                placeholder => 'Username',
			},
            right => {
				data => q(@),
			},
        },
        expected => '<div class="input-group input-group-lg"><input class="form-control" placeholder="Username" type="text" aria-describedby="basic-addon1"></input><span class="input-group-addon" id="basic-addon1">@</span></div>',
    });


    component_test({
        class => $class,
        action => 'input_group',
        args => {
			mid => 'basic-addon1',
			input => {
                placeholder => 'Username',
			},
            left => {
				data => q(@),
			},
            right => {
				data => q(@),
			},
        },
        expected => '<div class="input-group"><span class="input-group-addon" id="basic-addon1">@</span><input class="form-control" placeholder="Username" type="text" aria-describedby="basic-addon1"></input><span class="input-group-addon" id="basic-addon1">@</span></div>',
    });

    component_test({
        class => $class,
        action => 'input_group',
        args => {
			mid => 'basic-addon1',
            lid => 'basic-username',
            label => {
                data => 'Some text',
            },
			input => {
                placeholder => 'Username',
			},
            left => {
				data => q(@),
			},
            right => {
				data => q(@),
			},
        },
        expected => '<label for="basic-username">Some text</label><div class="input-group"><span class="input-group-addon" id="basic-addon1">@</span><input class="form-control" id="basic-username" placeholder="Username" type="text" aria-describedby="basic-addon1"></input><span class="input-group-addon" id="basic-addon1">@</span></div>',
    });

};

sub component_test {
    my $args = shift;

    my $action = $args->{action};
    my $element = $args->{class}->$action($args->{args} // {});
    return is($element->render, $args->{expected}, "got expected $args->{expected}");
}

done_testing();

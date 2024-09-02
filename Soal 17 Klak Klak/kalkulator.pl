sub penjumlahan {
    my ($a, $b) = @_;
    
    ADD:
    if ($b != 0) {
        my $carry = $a & $b;
        $a = $a ^ $b;
        $b = $carry << 1;
        goto ADD;
    }
    return $a;
}

sub pengurangan {
    my ($a, $b) = @_;
    
    $b = penjumlahan(~$b, 1);
    
    return penjumlahan($a, $b);
}

sub perkalian {
    my ($a, $b) = @_;
    my $result = 0;

    MULTIPLY:
    if ($b != 0) {
        if ($b & 1) { 
            $result = penjumlahan($result, $a);
        }
        $a = $a << 1; 
        $b = $b >> 1; 
        goto MULTIPLY;
    }

    return $result;
}


sub pembagian {
    my ($dividend, $divisor) = @_;
    my $quotient = 0;
    my $temp_divisor = $divisor;
    if ($divisor == 0) {
        die "Error: Division by zero\n";
    }

    DIVIDE:
    if ($dividend >= $divisor) {
        my $count = 1;

        while ($dividend >= ($temp_divisor << 1)) {
            $temp_divisor <<= 1;
            $count <<= 1;
        }

        $dividend = pengurangan($dividend, $temp_divisor);
        $quotient = penjumlahan($quotient, $count);

        # Reset temp_divisor and repeat
        $temp_divisor = $divisor;
        goto DIVIDE;
    }

    return $quotient;
}

sub pangkat {
    my ($a, $b) = @_;
    my $result = 1;  
    EXPONENTIATE:
    if ($b != 0) {
        $result = perkalian($result, $a);  # Kuadratkan a (a * a))
        $b = pengurangan($b, 1);  # Kurangi b sebanyak 1
        goto EXPONENTIATE;
    }

    return $result;
}

sub evaluate_expression {
    my ($expression) = @_;

    $expression =~ s/\s+//g;  # Hapus spasi

    # Tokenisasi ekspresi (termasuk operator dan angka)
    my @tokens = split(/(\d+|\+|\-|\*|\/|\^)/, $expression);
    @tokens = grep { $_ ne '' } @tokens;  # Hapus elemen kosong

    # Mulai dari token pertama sebagai nilai awal
    my $result = shift @tokens;

    my $index = 0;

    # Label untuk iterasi
    EVAL_EXPRESSION:
    if ($index < @tokens) {
        my $op = $tokens[$index++];
        my $num = $tokens[$index++];

        if ($op eq '+') {
            $result = penjumlahan($result, $num);
        } elsif ($op eq '-') {
            $result = pengurangan($result, $num);
        } elsif ($op eq '*') {
            $result = perkalian($result, $num);
        } elsif ($op eq '/') {
            $result = pembagian($result, $num);
        } elsif ($op eq '^') {
            $result = pangkat($result, $num);
        }

        goto EVAL_EXPRESSION;  # Ulangi hingga semua token habis
    }

    return $result;
}


print "Masukkan ekspresi aritmatika: ";
my $expr = <STDIN>;
chomp $expr;

my $result = evaluate_expression($expr);
print "Hasil dari '$expr' adalah: $result\n";
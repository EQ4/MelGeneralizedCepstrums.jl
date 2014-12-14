using MelGeneralizedCepstrums
using Base.Test

import MelGeneralizedCepstrums: frequency_scale, log_func

srand(98765)
c = rand(Float64, 21)

function test_mgc_basics()
    mgc = MelGeneralizedCepstrum(0.41, -0.01, c)
    @test alpha(mgc) == 0.41
    @test gamma(mgc) == -0.01
    @test order(mgc) == 20
    @test powercoef(mgc) == mgc[1]
    @test size(mgc) == size(c)

    @test frequency_scale(typeof(mgc)) == Mel
    @test log_func(typeof(mgc)) == GeneralizedLog
end

function test_mc_basics()
    mc = MelCepstrum(0.41, c)
    @test alpha(mc) == 0.41
    @test gamma(mc) == zero(Float64)
    @test order(mc) == 20
    @test powercoef(mc) == mc[1]
    @test size(mc) == size(c)

    @test frequency_scale(typeof(mc)) == Mel
    @test log_func(typeof(mc)) == StandardLog
end

function test_gc_basics()
    gc = GeneralizedCepstrum(-0.01, c)
    @test alpha(gc) == 0.0
    @test gamma(gc) == -0.01
    @test order(gc) == 20
    @test powercoef(gc) == gc[1]
    @test size(gc) == size(c)

    @test frequency_scale(typeof(gc)) == Linear
    @test log_func(typeof(gc)) == GeneralizedLog
end

function test_gnorm(γ::Float64)
    srand(98765)
    x = rand(100)
    mc = rand(21)

    g = SPTK.gnorm(mc, γ)
    ĝ = gnorm(mc, γ)
    @test_approx_eq g ĝ
end

function test_mc2b(α::Float64)
    srand(98765)
    x = rand(100)
    mc = rand(21)

    g = SPTK.mc2b(mc, α)
    ĝ = mc2b(mc, α)
    @test_approx_eq g ĝ
end

function test_c2ir(len::Int=512)
    srand(98765)
    x = rand(100)
    c = rand(21)

    ir = SPTK.c2ir(c, len)
    ir̂ = c2ir(c, len)
    @test_approx_eq ir ir̂
end

function test_freqt(order::Int, α::Float64)
    srand(98765)
    x = rand(100)
    mc = rand(21)

    m = SPTK.freqt(mc, order, α)
    m̂ = freqt(mc, order, α)
    @test_approx_eq m m̂
end

test_mgc_basics()
test_mc_basics()
test_gc_basics()

for ns in 1:15
    γ=-1.0/ns
    println("gnorm: testing with γ=$γ")
    test_gnorm(γ)
end

for α in [0.35, 0.41, 0.544]
    println("mc2b: testing with α=$α")
    test_mc2b(α)
end

for len in [128, 256, 512, 1024]
    println("c2ir: testing with len=$len")
    test_c2ir(len)
end

for order in 20:2:30
    for α in [0.35, 0.41, 0.544]
        println("freqt: testing with order=$order, α=$α")
        test_freqt(order, α)
    end
end

(

SynthDef.new(\ifm7, {
        // args for whole instrument
        arg out, amp=0.2, amplag=0.02, gate=1, ivel=0.1,hz,
        // operator frequency multiplier. these can be partials or custom intervals
        hz1=1, hz2=2, hz3=0, hz4=0, hz5=0, hz6=0,
        // operator amplitudes
        amp1=1,amp2=0.5,amp3=0.3,amp4=1,amp5=1,amp6=1,
				// velocity sensitivity for ops
				vels1=1,vels2=1,vels3=1,vels4=1,vels5=1,vels6=1,
        // operator phases
        phase1=0,phase2=0,phase3=0,phase4=0,phase5=0,phase6=0,
        // phase modulation params
        hz1_to_hz1=0, hz1_to_hz2=0, hz1_to_hz3=0, hz1_to_hz4=0, hz1_to_hz5=0, hz1_to_hz6=0,
        hz2_to_hz1=0, hz2_to_hz2=0, hz2_to_hz3=0, hz2_to_hz4=0, hz2_to_hz5=0, hz2_to_hz6=0,
        hz3_to_hz1=0, hz3_to_hz2=0, hz3_to_hz3=0, hz3_to_hz4=0, hz3_to_hz5=0, hz3_to_hz6=0,
        hz4_to_hz1=0, hz4_to_hz2=0, hz4_to_hz3=0, hz4_to_hz4=0, hz4_to_hz5=0, hz4_to_hz6=0,
        hz5_to_hz1=0, hz5_to_hz2=0, hz5_to_hz3=0, hz5_to_hz4=0, hz5_to_hz5=0, hz5_to_hz6=0,
        hz6_to_hz1=0, hz6_to_hz2=0, hz6_to_hz3=0, hz6_to_hz4=0, hz6_to_hz5=0, hz6_to_hz6=0,
	// boolean if the carrier is output
	carrier1=1,carrier2=1,carrier3=0,carrier4=0,carrier5=0,carrier6=0,
	// operator amplitude envelopes
	opAmpA1=0.05, opAmpD1=0.1, opAmpS1=1.0, opAmpR1=1.0, opAmpCurve1= -1.0,
	opAmpA2=0.05, opAmpD2=0.1, opAmpS2=1.0, opAmpR2=1.0, opAmpCurve2= -1.0,
	opAmpA3=0.05, opAmpD3=0.1, opAmpS3=1.0, opAmpR3=1.0, opAmpCurve3= -1.0,
	opAmpA4=0.05, opAmpD4=0.1, opAmpS4=1.0, opAmpR4=1.0, opAmpCurve4= -1.0,
	opAmpA5=0.05, opAmpD5=0.1, opAmpS5=1.0, opAmpR5=1.0, opAmpCurve5= -1.0,
	opAmpA6=0.05, opAmpD6=0.1, opAmpS6=1.0, opAmpR6=1.0, opAmpCurve6= -1.0;

        var ctrls, mods, osc, op_env, chans, chan_vec, osc_mix, opEnv1, opEnv2, opEnv3, opEnv4, opEnv5, opEnv6,kilnod;

	opEnv1 = EnvGen.kr(Env.adsr(opAmpA1,opAmpD1,opAmpS1,opAmpR1,1.0, opAmpCurve1),gate,doneAction:0);
	opEnv2 = EnvGen.kr(Env.adsr(opAmpA2,opAmpD2,opAmpS2,opAmpR2,1.0, opAmpCurve2),gate,doneAction:0);
	opEnv3 = EnvGen.kr(Env.adsr(opAmpA3,opAmpD3,opAmpS3,opAmpR3,1.0, opAmpCurve3),gate,doneAction:0);
	opEnv4 = EnvGen.kr(Env.adsr(opAmpA4,opAmpD4,opAmpS4,opAmpR4,1.0, opAmpCurve4),gate,doneAction:0);
	opEnv5 = EnvGen.kr(Env.adsr(opAmpA5,opAmpD5,opAmpS5,opAmpR5,1.0, opAmpCurve5),gate,doneAction:0);
	opEnv6 = EnvGen.kr(Env.adsr(opAmpA6,opAmpD6,opAmpS6,opAmpR6,1.0, opAmpCurve6),gate,doneAction:0);

        // the 6 oscillators, their frequence, phase and amplitude
	ctrls = [[ Lag.kr(hz * hz1,0.01), phase1, Lag.kr(amp1 * vels1.max(0.01) * ivel ,0.01) * opEnv1    ],
                 [ Lag.kr(hz * hz2,0.01), phase2, Lag.kr(amp2,0.01) * opEnv2 * (vels2.max(0.01) * ivel) ],
                 [ Lag.kr(hz * hz3,0.01), phase3, Lag.kr(amp3,0.01) * opEnv3 * (vels3.max(0.01) * ivel) ],
                 [ Lag.kr(hz * hz4,0.01), phase4, Lag.kr(amp4,0.01) * opEnv4 * (vels4.max(0.01) * ivel) ],
                 [ Lag.kr(hz * hz5,0.01), phase5, Lag.kr(amp5,0.01) * opEnv5 * (vels5.max(0.01) * ivel) ],
                 [ Lag.kr(hz * hz6,0.01), phase6, Lag.kr(amp6,0.01) * opEnv6 * (vels6.max(0.01) * ivel) ]];

        // All the operators phase modulation params
        mods = [[hz1_to_hz1, hz2_to_hz1, hz3_to_hz1, hz4_to_hz1, hz5_to_hz1, hz6_to_hz1],
                [hz1_to_hz2, hz2_to_hz2, hz3_to_hz2, hz4_to_hz2, hz5_to_hz2, hz6_to_hz2],
                [hz1_to_hz3, hz2_to_hz3, hz3_to_hz3, hz4_to_hz3, hz5_to_hz3, hz6_to_hz3],
                [hz1_to_hz4, hz2_to_hz4, hz3_to_hz4, hz4_to_hz4, hz5_to_hz4, hz6_to_hz4],
                [hz1_to_hz5, hz2_to_hz5, hz3_to_hz5, hz4_to_hz5, hz5_to_hz5, hz6_to_hz5],
                [hz1_to_hz6, hz2_to_hz6, hz3_to_hz6, hz4_to_hz6, hz5_to_hz6, hz6_to_hz6]];

        // returns a six channel array of OutputProxy objects
        osc = FM7.ar(ctrls,mods);
        chan_vec = [carrier1,carrier2,carrier3,carrier4,carrier5,carrier6];
        osc_mix = Mix.new(chan_vec.collect({|v,i| osc[i]*v}));
        amp = Lag.ar(K2A.ar(amp ), amplag);
      	kilnod = DetectSilence.ar(osc_mix, 0.01, 0.2, doneAction:2);
        Out.ar(out, (osc_mix * amp).dup);
      }).add;

);

(
var params = [\hz,440,\ivel,0.5,\gate,1];
Synth.new(\ifm7, params);

);
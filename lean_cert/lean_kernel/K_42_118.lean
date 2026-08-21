import Sound
import lean_certs.cert_42_118

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H42_gt_118_kernel : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 118 := by
  exact certValidRoot_sound (k := 42) (d := 118) (c := cert_42_118) (by decide)

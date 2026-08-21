import Sound
import lean_certs.cert_40_118

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H40_gt_118_kernel : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 118 := by
  exact certValidRoot_sound (k := 40) (d := 118) (c := cert_40_118) (by decide)

import Sound
import lean_certs.cert_40_108

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H40_gt_108_kernel : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 108 := by
  exact certValidRoot_sound (k := 40) (d := 108) (c := cert_40_108) (by decide)
